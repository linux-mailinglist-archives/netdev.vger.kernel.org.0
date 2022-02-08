Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8CAC64ACF5E
	for <lists+netdev@lfdr.de>; Tue,  8 Feb 2022 04:01:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345711AbiBHDBk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Feb 2022 22:01:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43860 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245526AbiBHDBj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Feb 2022 22:01:39 -0500
Received: from mail-ej1-x642.google.com (mail-ej1-x642.google.com [IPv6:2a00:1450:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A9CABC061A73;
        Mon,  7 Feb 2022 19:01:38 -0800 (PST)
Received: by mail-ej1-x642.google.com with SMTP id m4so48071191ejb.9;
        Mon, 07 Feb 2022 19:01:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=KgJJdfopCu/gOTHns364l9rxwDPl5Ujwxxvwj3Zh+CA=;
        b=lgnRSdgFW6GsulGqW6bELZTt4gLU7Iqwu2zRGVIQOOlgP13+GlUT3pxc8u8uC469nl
         VZNz50vaB6hg2JIAebzJoCMgQ38LTFlXpDq1vWoK0ez980OdQ9z3RTeodLipWHbL7Yke
         1teeBSwS+lfwi3CVx4dkBK4DKhnqsXd84FygiXgobtpn0lTHgm3MspDOQS3VA1WkX2qu
         PCWnBvsX5SMipHyRXKeadFgjF9LHRl4TP9F3sUfNh/o4TKRtoh84HVF32VRQivlVm9So
         Qkj6ldLLBnLMNStCGc/ysMDqhSOpJ77stv1E10E322pYDLeMeTQCAGUeHv+UFZmudZHU
         Wlgw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=KgJJdfopCu/gOTHns364l9rxwDPl5Ujwxxvwj3Zh+CA=;
        b=eOxBbnK+IFRyDjPjrovedgqFdQKaxWUitWt70uGlfr9oP3GWIUMsO++N8VKVurKz+x
         NDPvtqSHGMimI80/e0W2UKq9XXAwTu4+MS5zN17NRkXJck3DFhYyoZIgQVU9+Lrg9+Qk
         L8hrFOrTKObRNt8W2oQlSYnGCHITP28aNHe66hHUjGwBjfEa9S5qALAkYyQveUzmUhYu
         UYCMBQPlGsU4zi0fzYPn+1vQraDQZPDcazpYOj6+VS5zbH7/LtktYiXM0wdmW4NMXxSx
         skwhpQuNgSpM8B6OtxSl1UAwHKLMBcAqdpkw8S4Bw304bGYbS2XJeCkSVuz5sf2JxCuz
         43qw==
X-Gm-Message-State: AOAM531zgam0zh7E4ta/7P1xlKxGnGYhLHNMGdwAEsPgLQLAD+ZkWcVA
        znliRnSXIx7ZNUzl6mtZtHoNqMDVf0C4sGPORM8=
X-Google-Smtp-Source: ABdhPJzy6B6nffkllGqyVTgi5ViR54JhqpK5tpeI4Nm3zWRXvBisvTFfec8rkSUIWFxOcKbPWFgq5y4M/f4Oizf6idQ=
X-Received: by 2002:a17:907:1689:: with SMTP id hc9mr2096012ejc.348.1644289297300;
 Mon, 07 Feb 2022 19:01:37 -0800 (PST)
MIME-Version: 1.0
References: <20220205081738.565394-1-imagedong@tencent.com> <20220207094301.5c061d23@gandalf.local.home>
In-Reply-To: <20220207094301.5c061d23@gandalf.local.home>
From:   Menglong Dong <menglong8.dong@gmail.com>
Date:   Tue, 8 Feb 2022 10:56:44 +0800
Message-ID: <CADxym3ZaMmUpZxpLrj3YMvH1nygVE5x4u6VKWZiZ98JWpRF10w@mail.gmail.com>
Subject: Re: [PATCH v6 net-next] net: drop_monitor: support drop reason
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     Jakub Kicinski <kuba@kernel.org>, David Ahern <dsahern@kernel.org>,
        Ido Schimmel <idosch@idosch.org>,
        Neil Horman <nhorman@tuxdriver.com>,
        David Miller <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Menglong Dong <imagedong@tencent.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Feb 7, 2022 at 10:43 PM Steven Rostedt <rostedt@goodmis.org> wrote:
>
> On Sat,  5 Feb 2022 16:17:38 +0800
> menglong8.dong@gmail.com wrote:
>
> > --- a/net/core/drop_monitor.c
> > +++ b/net/core/drop_monitor.c
> > @@ -48,6 +48,16 @@
> >  static int trace_state = TRACE_OFF;
> >  static bool monitor_hw;
> >
> > +#undef EM
> > +#undef EMe
> > +
> > +#define EM(a, b)     [a] = #b,
> > +#define EMe(a, b)    [a] = #b
> > +
> > +static const char *drop_reasons[SKB_DROP_REASON_MAX + 1] = {
>
> Do you need to define the size above? Can't the compiler do it for you?
>
> static const char *drop_reasons[] = {
>

Yeah, it seems the compiler can do this job. Thanks!

> -- Steve
>
> > +     TRACE_SKB_DROP_REASON
> > +};
> > +
> >  /* net_dm_mutex
> >   *
