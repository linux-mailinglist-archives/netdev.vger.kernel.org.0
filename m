Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9B29855A5B3
	for <lists+netdev@lfdr.de>; Sat, 25 Jun 2022 03:10:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229840AbiFYBJv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Jun 2022 21:09:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39002 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229530AbiFYBJu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Jun 2022 21:09:50 -0400
Received: from mail-yb1-xb33.google.com (mail-yb1-xb33.google.com [IPv6:2607:f8b0:4864:20::b33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75DF34505F
        for <netdev@vger.kernel.org>; Fri, 24 Jun 2022 18:09:49 -0700 (PDT)
Received: by mail-yb1-xb33.google.com with SMTP id i15so7290520ybp.1
        for <netdev@vger.kernel.org>; Fri, 24 Jun 2022 18:09:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Lgb/dwNym3yIQwv7VBixIQzONvaskgF7jjqJP6fYNO0=;
        b=akG6oJnskVswrqo2dkLvCohrIurPiAfAXBqhNKxSyJslvEuXmAbypeWp+A0RWTdM2H
         HjcZn2Oqglw1cTZA83tWRD4wi8O6zL2JuMFrU47ViCvs6Zz4NIM6x7yUgY2A4ii8okA1
         BfeDwzNiNGDA4fUkvPJS9176itZArOvWRUiN/17sVOOn0t1G4fkUv/jZVSLHjvylfGIy
         1uh/Kw5CXu4pR1h6UjzWgZLi7lIqYMiTj02EpNKzEiMLZvtomIV7Zvq1TXwanixS/cjO
         LagqMoLKxYBuy4cJs11AJggF5zpHv7IAfYJAnUQYTfyJExqs+yZpOPK3/VPWABwVr7Zw
         9P6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Lgb/dwNym3yIQwv7VBixIQzONvaskgF7jjqJP6fYNO0=;
        b=nnVqkP7y6NW1Do+7tLF6qDhO4kF4yOikOi+ZII4iMJO0Vu0bQbymtPjQqa2r1rhjRP
         c8XYskn0pul9fdH4D7h9dR0IGw5O/I6kMiTsrsh8yxYu+mhzM3tBwtGNZoadDxbTWlyz
         VfFTFmS1RlHT3VtNiBXXElQF5UvvTmARCQxcSIC+Q2Jmtu7mC9Idgu1tfEmyVyBDdKlx
         Yf+bRCOMsnMR/BquVw0JMPNtHn8LiDwcE7HW71/YnWBwBejBz7bk1mpiQXWR8MYRWZob
         lLgD8Sg84MRzGK+dK3JCw1Rz3shAZX8BNI9ejUIgnLtU6Xf+veTMGApRHRzfchTij2Rc
         8D8A==
X-Gm-Message-State: AJIora8MsieOfcJQsgpA0utNktK68e3225kK7rLsrnf7spTU89lFGFdV
        iWFAYm6LdbNL/LPb22qMVzRKfu+QRG4UTyXhjlo=
X-Google-Smtp-Source: AGRyM1tfDijXcpDHg2UE7api9laQ1R7tNoFaFA3vpai3wqvzRSxuPi98K4iWPDyE44rYsEuTapPczM4f4e+aSQr4Nqg=
X-Received: by 2002:a25:324d:0:b0:66b:405b:752f with SMTP id
 y74-20020a25324d000000b0066b405b752fmr2062054yby.23.1656119388692; Fri, 24
 Jun 2022 18:09:48 -0700 (PDT)
MIME-Version: 1.0
References: <20220623042105.2274812-1-kuba@kernel.org>
In-Reply-To: <20220623042105.2274812-1-kuba@kernel.org>
From:   Petar Penkov <peterpenkov96@gmail.com>
Date:   Fri, 24 Jun 2022 18:09:38 -0700
Message-ID: <CA+DcSEhaiOySZduR+-1Ep3WYt_9cm0kYB25GbSDZLPsCVbuYgA@mail.gmail.com>
Subject: Re: [PATCH net] net: tun: stop NAPI when detaching queues
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     David Miller <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Network Development <netdev@vger.kernel.org>,
        pabeni@redhat.com, Mahesh Bandewar <maheshb@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Thanks for the fix (and for the syzbot one)!

Acked-by: Petar Penkov <ppenkov@aviatrix.com>


On Wed, Jun 22, 2022 at 9:21 PM Jakub Kicinski <kuba@kernel.org> wrote:
>
> While looking at a syzbot report I noticed the NAPI only gets
> disabled before it's deleted. I think that user can detach
> the queue before destroying the device and the NAPI will never
> be stopped.
>
> Compile tested only.
>
> Fixes: 943170998b20 ("tun: enable NAPI for TUN/TAP driver")
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> ---
> CC: maheshb@google.com
> CC: peterpenkov96@gmail.com
> ---
>  drivers/net/tun.c | 11 ++++++++++-
>  1 file changed, 10 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/net/tun.c b/drivers/net/tun.c
> index 7fd0288c3789..e2eb35887394 100644
> --- a/drivers/net/tun.c
> +++ b/drivers/net/tun.c
> @@ -273,6 +273,12 @@ static void tun_napi_init(struct tun_struct *tun, struct tun_file *tfile,
>         }
>  }
>
> +static void tun_napi_enable(struct tun_file *tfile)
> +{
> +       if (tfile->napi_enabled)
> +               napi_enable(&tfile->napi);
> +}
> +
>  static void tun_napi_disable(struct tun_file *tfile)
>  {
>         if (tfile->napi_enabled)
> @@ -653,8 +659,10 @@ static void __tun_detach(struct tun_file *tfile, bool clean)
>                 if (clean) {
>                         RCU_INIT_POINTER(tfile->tun, NULL);
>                         sock_put(&tfile->sk);
> -               } else
> +               } else {
>                         tun_disable_queue(tun, tfile);
> +                       tun_napi_disable(tfile);
> +               }
>
>                 synchronize_net();
>                 tun_flow_delete_by_queue(tun, tun->numqueues + 1);
> @@ -808,6 +816,7 @@ static int tun_attach(struct tun_struct *tun, struct file *file,
>
>         if (tfile->detached) {
>                 tun_enable_queue(tfile);
> +               tun_napi_enable(tfile);
>         } else {
>                 sock_hold(&tfile->sk);
>                 tun_napi_init(tun, tfile, napi, napi_frags);
> --
> 2.36.1
>
