Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 31CE26E667E
	for <lists+netdev@lfdr.de>; Tue, 18 Apr 2023 16:00:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230401AbjDROAl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Apr 2023 10:00:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41678 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230179AbjDROAk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Apr 2023 10:00:40 -0400
Received: from mail-ej1-x631.google.com (mail-ej1-x631.google.com [IPv6:2a00:1450:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1BC9A13846
        for <netdev@vger.kernel.org>; Tue, 18 Apr 2023 07:00:38 -0700 (PDT)
Received: by mail-ej1-x631.google.com with SMTP id fy21so30468633ejb.9
        for <netdev@vger.kernel.org>; Tue, 18 Apr 2023 07:00:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1681826436; x=1684418436;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=1sm1an5W25AGqY0VrYSiyBTsi7R7E/9n7rLrrhgn8AI=;
        b=RCy8ovyhatebT2oz1+4dON+XnN1nWd/JpF1nt9Fz4k/QIXS44SQADceHmiuSjlkbwc
         d/mu/FdJiSs2ueN3nbblvvOGhrqUyF5DEOL9ZAdW4tLdZexEYBbne9uwTeu8UuHOSWWk
         KMZdAOVP9yOkWmnoNVVKQLV5kDv49HSAV+/2DTWY0Jfpd4vK/D/lf+sZF/ocR+B4QUYh
         LPnw8VQDFRfjjIfkXDG/lOa7JiGnatKPfXj33R4nkcKMH/G+W488nnzjk/+omEowPwOr
         SjjOxl/LRKnAxVRfXmFXk4EhASKkZ6jhdqchKDDuwNsZW1gflybl4F7WCIz/9PzqjG+g
         0WlA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681826436; x=1684418436;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=1sm1an5W25AGqY0VrYSiyBTsi7R7E/9n7rLrrhgn8AI=;
        b=UrFlvE/btjH9qRTexZbstXBEJawegZIrh7yIslQiZO7EEWoLvGE1s18d8Yde5piaMI
         /hksgzkU27cSfcc+xx4yewxnvmgzbrLfEXY3N07QCkJAcQ1Du5C2buLAjY3Gj2YWT260
         L/O6iQiRmZDnsswuqtbfVEnYtM/bSuaFDPrRFpUC9RnG0TJrbegaVAjJnt7JmOdZSgpg
         VTaiKT29/Wj96Vf4iRCmjtJekyfqHKVoGKudGhLBCIZrFVpAK8YHG/zFUVTHE471HfQc
         tnDZPDwafhDgUZwSEF2txiKp65tUby2b7s6k6u7l94yld4NeEq0u7vTAyiJURzUsOx9W
         aCAg==
X-Gm-Message-State: AAQBX9evlGo/I+Mr39DlAkCE8cnxdelotyO6hb9RhYF/av5cYQ187vkf
        ONxtzSxfk9k/JH9SAQ4TNmGitQ7e4nwF3gMBoyk=
X-Google-Smtp-Source: AKy350aw9lL51UQoVrt0t14hauhFsACqroGjDSR6BKjrwxZfPyE71aUsmA1NqeTne8M0Tz4v72In+u3FOiT1rMN/488=
X-Received: by 2002:a17:907:9090:b0:932:e6d5:bd7c with SMTP id
 ge16-20020a170907909000b00932e6d5bd7cmr10305040ejb.20.1681826436356; Tue, 18
 Apr 2023 07:00:36 -0700 (PDT)
MIME-Version: 1.0
References: <20230412234434.91819-1-witu@nvidia.com> <ZD6I9eTJWS1KWL3R@corigine.com>
In-Reply-To: <ZD6I9eTJWS1KWL3R@corigine.com>
From:   William Tu <u9012063@gmail.com>
Date:   Tue, 18 Apr 2023 06:59:58 -0700
Message-ID: <CALDO+SZ9Y-Fmw+JxKBxdp5w=pvjjY+GoGxWu_sA6AP6e=Siz8Q@mail.gmail.com>
Subject: Re: [PATCH RFC net-next v20] vmxnet3: Add XDP support.
To:     Simon Horman <simon.horman@corigine.com>
Cc:     netdev@vger.kernel.org, jsankararama@vmware.com, gyang@vmware.com,
        doshir@vmware.com, alexander.duyck@gmail.com,
        alexandr.lobakin@intel.com, bang@vmware.com,
        maciej.fijalkowski@intel.com, witu@nvidia.com,
        horatiu.vultur@microchip.com, error27@gmail.com,
        Alexander Duyck <alexanderduyck@fb.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 18, 2023 at 5:11=E2=80=AFAM Simon Horman <simon.horman@corigine=
.com> wrote:
>
> On Wed, Apr 12, 2023 at 04:44:34PM -0700, William Tu wrote:
> > From: William Tu <u9012063@gmail.com>
> >
> > The patch adds native-mode XDP support: XDP DROP, PASS, TX, and REDIREC=
T.
>
> ...
>
> > +/* ndo_xdp_xmit */
> > +int
> > +vmxnet3_xdp_xmit(struct net_device *dev,
> > +              int n, struct xdp_frame **frames, u32 flags)
> > +{
> > +     struct vmxnet3_adapter *adapter =3D netdev_priv(dev);
> > +     struct vmxnet3_tx_queue *tq;
> > +     struct netdev_queue *nq;
> > +     int i;
> > +
> > +     if (unlikely(test_bit(VMXNET3_STATE_BIT_QUIESCED, &adapter->state=
)))
> > +             return -ENETDOWN;
> > +     if (unlikely(test_bit(VMXNET3_STATE_BIT_RESETTING, &adapter->stat=
e)))
> > +             return -EINVAL;
> > +
> > +     tq =3D vmxnet3_xdp_get_tq(adapter);
> > +     if (tq->stopped)
> > +             return -ENETDOWN;
> > +
> > +     nq =3D netdev_get_tx_queue(adapter->netdev, tq->qid);
>
> Hi William,
>
> gcc-12 with W=3D1 tells me that:
>
>  drivers/net/vmxnet3/vmxnet3_xdp.c:228:23: warning: variable 'nq' set but=
 not used [-Wunused-but-set-variable]
>          struct netdev_queue *nq;
>
Hi Simon,
Thanks a lot for reviewing and found this error.
I will fix it in next version.
William
