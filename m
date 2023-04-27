Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 248946F0009
	for <lists+netdev@lfdr.de>; Thu, 27 Apr 2023 06:02:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242131AbjD0ECW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Apr 2023 00:02:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33258 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236396AbjD0ECV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Apr 2023 00:02:21 -0400
Received: from mail-pf1-x42a.google.com (mail-pf1-x42a.google.com [IPv6:2607:f8b0:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 167D72683
        for <netdev@vger.kernel.org>; Wed, 26 Apr 2023 21:02:20 -0700 (PDT)
Received: by mail-pf1-x42a.google.com with SMTP id d2e1a72fcca58-64115e652eeso2071979b3a.0
        for <netdev@vger.kernel.org>; Wed, 26 Apr 2023 21:02:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1682568139; x=1685160139;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=C7rxN0Rg+dR7loq/+pO5UWYK2rJoxwijWZLZ2qvnTgM=;
        b=OcGyc/JBrCriKJ7GFiB/7QmVOWNo5rBXG7qIRqMt77c7jhL0bfEn34fHV65IFByxq1
         x6y65GfJdSybUEwfvIOLQKeVyTW6MoVj6Q1p97EXpee5ESaoIPwy4A5A0zqGWNHHLMj0
         5cnv8wYhd3u2jagaeHVgmMdQWxrHfpuv11HtJGVrEuHdG59yQw11renXQ9y4Gb8Y2EZD
         bVfPT2vwI4B7PD48EjmZN25tF0+/PEycEIoGSG9I5zgIxkgCLhkI29mWFnWW0R0TRKOY
         nkvsnHrZyx0cm89UMZiUt0/3589DtS8YCq64E3WMqxCqFh7b6OsAieKkZPu8ENKFSxTe
         GJiw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682568139; x=1685160139;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=C7rxN0Rg+dR7loq/+pO5UWYK2rJoxwijWZLZ2qvnTgM=;
        b=VmFxKZTxoOFVLNZu6nGX8L2X+xLu8387dp3fDW8mSn7GI/iUJZ+c8Fz0sS4XjH69Yc
         sd4cs8TykEGhVHqhjbVn3/+QXScgtmd7Pa4djyzRZLHosKz3UM8WRpFQEcSOmbCaY/Wl
         A1iopPNVIY0t7o48Q5AlHpJwynmfuSEBwGhqQVChYry6NwcpAkRLMRJNfZSoR6PfTlee
         M91MVpuQuJZest7H3LI6retKNTS2+cbQuSsf/7A7HclgHOaRcfTxWObymMjqfDrsV7H6
         EWojOqVCP+gVrH/xSFQ1LFIYCeayGtrUnkK+3jN+NiwS/voYVBOYAYY2r4OsPQUu+gTF
         SlLQ==
X-Gm-Message-State: AC+VfDwHLi7F5ev9kEvlXJyhd4L3SNtXQ7lzyTubd0Xoz6iNDYEKew71
        02Pes0ZuxxVIA+0MxoACzV+JuD42P3eSzVxf+3U=
X-Google-Smtp-Source: ACHHUZ7ZpzU9OgTbGG9cdJ103wwWBQnamwX7T1Rvxxp4YRkKz3cpP4hdiO4MZLeFNb2mdm+2iZXnNLznz21qkU40idg=
X-Received: by 2002:a17:90a:f28e:b0:23f:d487:1bc8 with SMTP id
 fs14-20020a17090af28e00b0023fd4871bc8mr5951435pjb.13.1682568139335; Wed, 26
 Apr 2023 21:02:19 -0700 (PDT)
MIME-Version: 1.0
References: <20230423032817.285371-1-glipus@gmail.com> <ZEmCmirgOnAIByYH@corigine.com>
In-Reply-To: <ZEmCmirgOnAIByYH@corigine.com>
From:   Max Georgiev <glipus@gmail.com>
Date:   Wed, 26 Apr 2023 22:02:08 -0600
Message-ID: <CAP5jrPFVUwjbBEU2mka0oZV3FyXAJeDriN9HZ2wuLqm+tYxqxg@mail.gmail.com>
Subject: Re: [RFC PATCH v4 2/5] Add ifreq pointer field to kernel_hwtstamp_config
 structure
To:     Simon Horman <simon.horman@corigine.com>
Cc:     kory.maincent@bootlin.com, kuba@kernel.org, netdev@vger.kernel.org,
        maxime.chevallier@bootlin.com, vladimir.oltean@nxp.com,
        vadim.fedorenko@linux.dev, richardcochran@gmail.com,
        gerhard@engleder-embedded.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 26, 2023 at 1:59=E2=80=AFPM Simon Horman <simon.horman@corigine=
.com> wrote:
>
> On Sat, Apr 22, 2023 at 09:28:17PM -0600, Maxim Georgiev wrote:
> > Considering the stackable nature of drivers there will be situations
> > where a driver implementing ndo_hwtstamp_get/set functions will have
> > to translate requests back to SIOCGHWTSTAMP/SIOCSHWTSTAMP IOCTLs
> > to pass them to lower level drivers that do not provide
> > ndo_hwtstamp_get/set callbacks. To simplify request translation in
> > such scenarios let's include a pointer to the original struct ifreq
> > to kernel_hwtstamp_config structure.
> >
> > Suggested-by: Jakub Kicinski <kuba@kernel.org>
> > Signed-off-by: Maxim Georgiev <glipus@gmail.com>
> >
> > Notes:
> >
> >   Changes in V4:
> >   - Introducing KERNEL_HWTSTAMP_FLAG_IFR_RESULT flag indicating that
> >     the operation results are returned in the ifr referred by
> >     struct kernel_hwtstamp_config instead of kernel_hwtstamp_config
> >     glags/tx_type/rx_filter fields.
> >   - Implementing generic_hwtstamp_set/set_lower() functions
> >     which will be used by vlan, maxvlan, bond and potentially
> >     other drivers translating ndo_hwtstamp_set/set calls to
> >     lower level drivers.
> > ---
> >  include/linux/net_tstamp.h |  7 ++++
> >  include/linux/netdevice.h  |  6 +++
> >  net/core/dev_ioctl.c       | 80 +++++++++++++++++++++++++++++++++++---
> >  3 files changed, 87 insertions(+), 6 deletions(-)
> >
> > diff --git a/include/linux/net_tstamp.h b/include/linux/net_tstamp.h
> > index 7c59824f43f5..5164dce3f9a0 100644
> > --- a/include/linux/net_tstamp.h
> > +++ b/include/linux/net_tstamp.h
> > @@ -20,6 +20,13 @@ struct kernel_hwtstamp_config {
> >       int flags;
> >       int tx_type;
> >       int rx_filter;
> > +     struct ifreq *ifr;
> > +     int kernel_flags;
>
> nit: ifr and kernel_flags should be added to the kdoc for this struct
>      that appears immediately above it.
>
> > +};
> > +
> > +/* possible values for kernel_hwtstamp_config->kernel_flags */
> > +enum kernel_hwtstamp_flags {
> > +     KERNEL_HWTSTAMP_FLAG_IFR_RESULT =3D (1 << 0),
>
> nit: maybe BIT(0)
>
> >  };
> >
> >  static inline void hwtstamp_config_to_kernel(struct kernel_hwtstamp_co=
nfig *kernel_cfg,
>
> ...

Thank you for the feedback!
I'll update and resend the patch
