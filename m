Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 99B4C5BEAF1
	for <lists+netdev@lfdr.de>; Tue, 20 Sep 2022 18:15:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231324AbiITQP2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Sep 2022 12:15:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56532 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229928AbiITQPZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Sep 2022 12:15:25 -0400
Received: from mail-ed1-x52a.google.com (mail-ed1-x52a.google.com [IPv6:2a00:1450:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 14B1953004;
        Tue, 20 Sep 2022 09:15:25 -0700 (PDT)
Received: by mail-ed1-x52a.google.com with SMTP id f20so4577976edf.6;
        Tue, 20 Sep 2022 09:15:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date;
        bh=nRomfx6cjKTEcdkhPE+g3ZgR4tQZNJCFgEI/T1r7oHc=;
        b=EtcejFQ74farzMNYgtNCZ57QvDq9Wxjv8e28oyMafdnNJKenH26A8IQLJO9CdwlJrg
         0dmGwOgoJa65slikJKBDNLrJzCZfRqT2L6xg4AvPNqApS+I7DF9T1zhuHhV1ZC4TMW/L
         CwRXLtjxJtM3xxgx60Sbw6fYrZYx2w4IKW5AqhYDVh53YYN0TFXI3Rw4nZLRg25akkDo
         aTTBawh2y1o/ah5TzshA52Zoxoo1xMTnMe+9eWY4AmshU0+GYmHGgbkgvlpSpWUsA0IX
         Os0TwoySCnNfKyrmINyP4KbCoyr88b4J6ahP6Kt6wG+k1kLxZ2jER5Q1Fy597pVwPxNv
         AWgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=nRomfx6cjKTEcdkhPE+g3ZgR4tQZNJCFgEI/T1r7oHc=;
        b=0mD7NImQQ75OkiFW8CedYftRT0O0vfya6likH1zmAFR696pI2QNN3YiKRwRkEknPjW
         XFL5Dtbb30XQUyyZmH5nYq2Y9/nttJCuO2DWjychn2VVbL0cjLdSlaritNaaj2Nx2xlA
         BPbFTClTsCfRsA8JS06/S2vTB28lc54e59MxK4XV6anpKiRZnTsOsYwkklZTNXLevWxA
         0yL3kgvCk3v0gW4pZBDR1OC9vu5tQpwainPOR7kW+NUsBKo9KWQwxt3jIUGEdBtlQawi
         UB9STMZWc4NITCCP33txNFLtEWMYtTlsuymDL4Y68EtjTW2aCVYC5I9KdSb1yOYAb1Wt
         LTpA==
X-Gm-Message-State: ACrzQf379TgmgEWbGgIP+eBoNYmKPUkOh3NleWpYX0hTz5vUgKPEavHk
        Nm2Nf0wMlZXcl4M9XtYFuVYQl2U33o0cgc6ls/9o85PHK7F8gw==
X-Google-Smtp-Source: AMsMyM6EJKi//PPXFg8Ng3Lf2as4Jxv9eJHAAqqM4FFInAeOsJOGSC6Gmb9tJJb4+pHHinQenPnoTV9kNvoKoTv5Pi0=
X-Received: by 2002:a05:6402:1a4f:b0:44e:f731:f7d5 with SMTP id
 bf15-20020a0564021a4f00b0044ef731f7d5mr20560014edb.357.1663690523423; Tue, 20
 Sep 2022 09:15:23 -0700 (PDT)
MIME-Version: 1.0
References: <20220919073631.1574577-1-floridsleeves@gmail.com> <20220920100157.GV2950045@gauss3.secunet.de>
In-Reply-To: <20220920100157.GV2950045@gauss3.secunet.de>
From:   Li Zhong <floridsleeves@gmail.com>
Date:   Tue, 20 Sep 2022 09:15:35 -0700
Message-ID: <CAMEuxRo9oy4uc3XK7wQ26zgwmpwwp+iOT_47OsshAv-94tGgtw@mail.gmail.com>
Subject: Re: [PATCH v1] drivers/net/ethernet/3com: check the return value of vortex_up()
To:     Steffen Klassert <steffen.klassert@secunet.com>
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        f.fainelli@gmail.com, pabeni@redhat.com, kuba@kernel.org,
        edumazet@google.com, davem@davemloft.net, klassert@kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Sep 20, 2022 at 3:02 AM Steffen Klassert
<steffen.klassert@secunet.com> wrote:
>
> On Mon, Sep 19, 2022 at 12:36:31AM -0700, Li Zhong wrote:
> > Check the return value of vortex_up(), which could be error code when
> > the rx ring is not full.
> >
> > Signed-off-by: Li Zhong <floridsleeves@gmail.com>
> > ---
> >  drivers/net/ethernet/3com/3c59x.c | 5 ++++-
> >  1 file changed, 4 insertions(+), 1 deletion(-)
> >
> > diff --git a/drivers/net/ethernet/3com/3c59x.c b/drivers/net/ethernet/3com/3c59x.c
> > index ccf07667aa5e..7806c5f60ac8 100644
> > --- a/drivers/net/ethernet/3com/3c59x.c
> > +++ b/drivers/net/ethernet/3com/3c59x.c
> > @@ -1942,6 +1942,7 @@ vortex_error(struct net_device *dev, int status)
> >       void __iomem *ioaddr = vp->ioaddr;
> >       int do_tx_reset = 0, reset_mask = 0;
> >       unsigned char tx_status = 0;
> > +     int err;
> >
> >       if (vortex_debug > 2) {
> >               pr_err("%s: vortex_error(), status=0x%x\n", dev->name, status);
> > @@ -2016,7 +2017,9 @@ vortex_error(struct net_device *dev, int status)
> >                       /* Must not enter D3 or we can't legally issue the reset! */
> >                       vortex_down(dev, 0);
> >                       issue_and_wait(dev, TotalReset | 0xff);
> > -                     vortex_up(dev);         /* AKPM: bug.  vortex_up() assumes that the rx ring is full. It may not be. */
> > +                     err = vortex_up(dev);
> > +                     if (err)
> > +                             return;
>
> Why does that fix the bug mentioned in the above comment?
>

Since the bug is an unchecked error, we detect it with static analysis and
validate it's a bug by the comment we see above the code. So we fix this bug
following the guide of this comment.
