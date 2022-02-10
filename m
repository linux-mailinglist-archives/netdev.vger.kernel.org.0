Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C85FF4B09A3
	for <lists+netdev@lfdr.de>; Thu, 10 Feb 2022 10:36:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235329AbiBJJgI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Feb 2022 04:36:08 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:56464 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234258AbiBJJgH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Feb 2022 04:36:07 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id BB94EC64
        for <netdev@vger.kernel.org>; Thu, 10 Feb 2022 01:36:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1644485767;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=BOZWC5nc6sKJ4hcB+2YbGBGeey1dn9oCrwtXLVhLO38=;
        b=bnhFXpiwwdkgZdJn4hWI2tYw2cO/WQFWOldxM2UVgMEHe8FBAgTl7mPk0xy8PFK6c2NimT
        FCyI4smfbMD4zpHviY3oxTYt/OB51Mn6oVfT0eVw5c5m8vvvIT/f7ZqVOEGuZsNoPOEMnd
        RLhUfJPQR7CHkNU/nnPg1TaOenYGLH8=
Received: from mail-io1-f72.google.com (mail-io1-f72.google.com
 [209.85.166.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-223-V662rFQ6OxOuzFgkbr91xw-1; Thu, 10 Feb 2022 04:36:04 -0500
X-MC-Unique: V662rFQ6OxOuzFgkbr91xw-1
Received: by mail-io1-f72.google.com with SMTP id 193-20020a6b01ca000000b00612778c712aso3682617iob.14
        for <netdev@vger.kernel.org>; Thu, 10 Feb 2022 01:36:04 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=BOZWC5nc6sKJ4hcB+2YbGBGeey1dn9oCrwtXLVhLO38=;
        b=5JW7xMzcslWO05YktwSzgc1QVfE1ODRt8v3uXhs63qFbNqDbivgFGwjX6PmX7psD1+
         jvwZz23ThndAadoESvrytaaFkjIEgc++IR+aNEsXCbVAe+2fgG07YENy/9TufAiawtwF
         Mbt5sXZxjBBqdYp+ULmyRHfVwn+jPGx4YMUIYJ05WUosJLWhB36MmDOIcuW+hdCamEaw
         T4G1w0Itt/Dj2naEHNMqENgqvgn8ODO1PE8mbTleVjOWqWjT/wGZqISC5vFO1y8yN0FR
         VsyTVFX3hqKIRGWdi8dVNmLwbY3/poxVX3gQyRo8HXYMLN4pJRAvPqrBBuncvEjVrHN7
         Eehg==
X-Gm-Message-State: AOAM533VF1Et3mnd+t0CGqvHvH6GYgLmjZMGeAVMAlXi/AbVbYCgObVI
        dgB5Ki3YPJ9lgJ3kMyCrwaf9sippIgkDCHyO1tbi2LtrELzF5vNs1G+jA4vV+DLFMRmNuCJ4lS/
        hBSQtwFuvZBCP8Q3VGCE9+GWGt2/lECFv
X-Received: by 2002:a05:6e02:1c23:: with SMTP id m3mr3440243ilh.258.1644485764038;
        Thu, 10 Feb 2022 01:36:04 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwEpZw27B1Zoe5ixqQ711qw3nwFVfP5fzd4SoubNF7LC8XLOlef8Pzml+xs2Pbbn/4NOear5V60AHKpKKqcCU0=
X-Received: by 2002:a05:6e02:1c23:: with SMTP id m3mr3440232ilh.258.1644485763787;
 Thu, 10 Feb 2022 01:36:03 -0800 (PST)
MIME-Version: 1.0
References: <20220128151922.1016841-1-ihuguet@redhat.com> <20220128151922.1016841-2-ihuguet@redhat.com>
 <20220128142728.0df3707e@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <CACT4ouctx9+UP2BKicjk6LJSRcR2M_4yDhHmfDARcDuVj=_XAg@mail.gmail.com> <20220207085311.3f6d0d19@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20220207085311.3f6d0d19@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   =?UTF-8?B?w43DsWlnbyBIdWd1ZXQ=?= <ihuguet@redhat.com>
Date:   Thu, 10 Feb 2022 10:35:53 +0100
Message-ID: <CACT4oucCn2ixs8hCizGhvjLPOa90k3vEZEVbuY6nUF-M23B=yw@mail.gmail.com>
Subject: Re: [PATCH net-next 1/2] sfc: default config to 1 channel/core in
 local NUMA node only
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Edward Cree <ecree.xilinx@gmail.com>, habetsm.xilinx@gmail.com,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Feb 7, 2022 at 5:53 PM Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Mon, 7 Feb 2022 16:03:01 +0100 =C3=8D=C3=B1igo Huguet wrote:
> > On Fri, Jan 28, 2022 at 11:27 PM Jakub Kicinski <kuba@kernel.org> wrote=
:
> > > On Fri, 28 Jan 2022 16:19:21 +0100 =C3=8D=C3=B1igo Huguet wrote:
> > > > Handling channels from CPUs in different NUMA node can penalize
> > > > performance, so better configure only one channel per core in the s=
ame
> > > > NUMA node than the NIC, and not per each core in the system.
> > > >
> > > > Fallback to all other online cores if there are not online CPUs in =
local
> > > > NUMA node.
> > >
> > > I think we should make netif_get_num_default_rss_queues() do a simila=
r
> > > thing. Instead of min(8, num_online_cpus()) we should default to
> > > num_cores / 2 (that's physical cores, not threads). From what I've se=
en
> > > this appears to strike a good balance between wasting resources on
> > > pointless queues per hyperthread, and scaling up for CPUs which have
> > > many wimpy cores.
> > >
> >
> > I have a few busy weeks coming, but I can do this after that.
> >
> > With num_cores / 2 you divide by 2 because you're assuming 2 NUMA
> > nodes, or just the plain number 2?
>
> Plain number 2, it's just a heuristic which seems to work okay.
> One queue per core (IOW without the /2) is still way too many queues
> for normal DC workloads.
>

Maybe it's because of being quite special workloads, but I have
encountered problems related to queues in different NUMA nodes in 2
cases: XDP performance being almost half with more RX queues because
of being in different node (the example in my patches) and a customer
losing UDP packets which was solved reducing the number of RX queues
so all them are in the same node.

--=20
=C3=8D=C3=B1igo Huguet

