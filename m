Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8273F51C9D0
	for <lists+netdev@lfdr.de>; Thu,  5 May 2022 22:00:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1385235AbiEEUDs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 May 2022 16:03:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50274 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244042AbiEEUDr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 May 2022 16:03:47 -0400
Received: from mail-lj1-x22c.google.com (mail-lj1-x22c.google.com [IPv6:2a00:1450:4864:20::22c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 887A45F261
        for <netdev@vger.kernel.org>; Thu,  5 May 2022 13:00:06 -0700 (PDT)
Received: by mail-lj1-x22c.google.com with SMTP id c15so6922064ljr.9
        for <netdev@vger.kernel.org>; Thu, 05 May 2022 13:00:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=engleder-embedded-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=6gPZEnEWKasiTJ+W5JEInWHPtBugWQuFFkqdD2+8rIE=;
        b=OSv5Pa4D4uv8ROYV++6WvUPY6DGWfSC6/ssVBo9wrnJ/FS8V1bdDXc/4qYF5PqfgAc
         6tFE0wL83DEv7lsbPFpjbtkVJVfkNWjb2moYISaibfLxoVQt9vdG3SgpHC2ChWwUnNPI
         Qv9XjLZZInOaJ3gFiQ7HMw/99a0wcpFKNBhLvznjU4FWRBt/Y0hNaTFtbGY5U/7kmik6
         i+rIXM5FfpccTz7t2S3MuAUaSVugLh9/4/gSApE+idTD6Znv7Bj90oMhtyDYVpExTDhl
         bI4EFUbRuF74cpn3nlfHCKebjYFqd0T+WWvmLd+Yo+e3/cQLVXkxoV0u05QTYWICz9PJ
         f5Pw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=6gPZEnEWKasiTJ+W5JEInWHPtBugWQuFFkqdD2+8rIE=;
        b=N5UNSn3/vP4ZbFQAPnreSaEvrpuis2XFyymzHArF9WLCi7xY/0UUteK4Pz5VnGkbkn
         Gbp6oq1HSbZ38KQc4NAPShQBOdQhT7cPOKgAS58xGZ7QQ+N5OVJ+i1+Xn/xqOX1lNWQ4
         pYDoNkv6hBhvlYElekMRsjGu/Fqk8CMT81ldiwJCwkWHkPWxBdys21JGhoWN5y0FkydW
         D9thCE71KYUYAY+7BBJjopK9A3DW5oInH4dR8l+SOY1diJTX8tMgX4VHjz232Rr+DNpe
         tq8Vm8+i987EmTik/ab+QNmeb0Te/3K92kLJUott8ajXYbj6kMuM/y8s2qWz1CjQztl+
         bW7g==
X-Gm-Message-State: AOAM530KLjka0OH7Zg1XQcdd+HljFED5VoIeqtM6weIO+RIpVGJ0RMtC
        0+fYxjPiogGLFbGknhsb8llRWEK9OwLipOI7U2O0eg==
X-Google-Smtp-Source: ABdhPJw62k8QefqEJaNCAVaVyRYvyfFajC9KiIxeIOZP1KcWXDIQr+TvyqGmjPcwSg0lHagCSwhSXQhc0eg9RMQAj8c=
X-Received: by 2002:a2e:9bce:0:b0:24f:257d:28d3 with SMTP id
 w14-20020a2e9bce000000b0024f257d28d3mr17176467ljj.93.1651780804544; Thu, 05
 May 2022 13:00:04 -0700 (PDT)
MIME-Version: 1.0
References: <20220501111836.10910-1-gerhard@engleder-embedded.com>
 <20220501111836.10910-3-gerhard@engleder-embedded.com> <4c2a15271887aa3f5d759771ddedac04e11db743.camel@redhat.com>
In-Reply-To: <4c2a15271887aa3f5d759771ddedac04e11db743.camel@redhat.com>
From:   Gerhard Engleder <gerhard@engleder-embedded.com>
Date:   Thu, 5 May 2022 21:59:53 +0200
Message-ID: <CANr-f5wYg-qxVWgdUb3w3tj89NG9HpDAMvp0xFtts6yTotQ75Q@mail.gmail.com>
Subject: Re: [PATCH net-next v3 2/6] ptp: Request cycles for TX timestamp
To:     Paolo Abeni <pabeni@redhat.com>
Cc:     Richard Cochran <richardcochran@gmail.com>,
        Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        yangbo.lu@nxp.com, David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, mlichvar@redhat.com,
        netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > The free running cycle counter of physical clocks called cycles shall be
> > used for hardware timestamps to enable synchronisation.
> >
> > Introduce new flag SKBTX_HW_TSTAMP_USE_CYCLES, which signals driver to
> > provide a TX timestamp based on cycles if cycles are supported.
> >
> > Signed-off-by: Gerhard Engleder <gerhard@engleder-embedded.com>
> > ---
> >  include/linux/skbuff.h |  5 +++++
> >  net/core/skbuff.c      |  5 +++++
> >  net/socket.c           | 11 ++++++++++-
> >  3 files changed, 20 insertions(+), 1 deletion(-)
> >
> > diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
> > index 3270cb72e4d8..fa03e02b761d 100644
> > --- a/include/linux/skbuff.h
> > +++ b/include/linux/skbuff.h
> > @@ -615,6 +615,11 @@ enum {
> >       /* device driver is going to provide hardware time stamp */
> >       SKBTX_IN_PROGRESS = 1 << 2,
> >
> > +     /* generate hardware time stamp based on cycles if supported, flag is
> > +      * used only for TX path
> > +      */
> > +     SKBTX_HW_TSTAMP_USE_CYCLES = 1 << 3,
> > +
> >       /* generate wifi status information (where possible) */
> >       SKBTX_WIFI_STATUS = 1 << 4,
>
> Don't you need to update accordingly SKBTX_ANY_TSTAMP, so that this
> flags is preserved on segmentation?

You are right, SKBTX_HW_TSTAMP_USE_CYCLES should be preserved like
SKBTX_HW_TSTAMP. I will fix that.

Thank you!

Gerhard
