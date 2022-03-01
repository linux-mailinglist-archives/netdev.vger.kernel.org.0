Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DECC74C8074
	for <lists+netdev@lfdr.de>; Tue,  1 Mar 2022 02:47:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232010AbiCABsZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Feb 2022 20:48:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35344 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232009AbiCABsY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Feb 2022 20:48:24 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 3FD5ABC3A
        for <netdev@vger.kernel.org>; Mon, 28 Feb 2022 17:47:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1646099263;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=luuUiMnqhEGGpxdu/95KFzZYsnUnE9Pq8uUGjugbrlY=;
        b=hYHa/PblLMChYqyOcW7I2t4JyShG9J9QCVQhWGAhxtL/S3n3JU4TsDdRHVKiA2h9XbPJGt
        Bp3GMjuxpA40CgjV5cJCurcWVKcNAWcrUE/m067ZmRhVZWTGHAZhPEaDuNWlFTL9CZ+Cw/
        wKliyVH/SOlzVCH9gfebYmedn5geI50=
Received: from mail-lj1-f199.google.com (mail-lj1-f199.google.com
 [209.85.208.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-512-Qrn7VZJjMpCaIHbCNcPsSg-1; Mon, 28 Feb 2022 20:47:41 -0500
X-MC-Unique: Qrn7VZJjMpCaIHbCNcPsSg-1
Received: by mail-lj1-f199.google.com with SMTP id 20-20020a2e0914000000b0024635d136ddso6545025ljj.22
        for <netdev@vger.kernel.org>; Mon, 28 Feb 2022 17:47:41 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=luuUiMnqhEGGpxdu/95KFzZYsnUnE9Pq8uUGjugbrlY=;
        b=D0MnRlSIN13ju5zwTA4eAWJL/x5qIkDHUKRLTRgfuwwOs9HnYwrHcTiDEhzzbUC5B2
         baUI4yRveD54OVn9EyXAHQxp8R24pnlS3R57aYE/AaasuqAkPQ2+cXb7LJ2PNePMUhTm
         0oluTuE9e31scrCCnSSlkKSuDqXBKdfE5Wg+jToy5Stdtq2U531oKM6sSdZAu1VKMx3A
         Tkyqf1Me3rqyIg5ZF1xuI5G86ufsM7Y72KdEGCAgMXAuxeDoLbAE7bphGARC0U4aLOlr
         8VNm8fJjtr1ZRcGJpO93/Auf0J63PqKFa6irQMSWGcOtFEQMRiCnI8EAslMo461tgKHo
         Ucbg==
X-Gm-Message-State: AOAM530Ekfcs9NsiJP4/TDPmN+04Il0mwH9rNxDe89wC7vJzzzavqAc2
        pgAqECNL+lB3DbfV3gs+YMSaQOTZ4O520c+qV/WhDGtMW/XFThGt4xrhkz7tEEq17LmuR9XGUFq
        gLw4zkxNO+h6LRxsmuSzQX2q2Ky4ADHSI
X-Received: by 2002:a05:651c:90b:b0:244:c4a4:d5d8 with SMTP id e11-20020a05651c090b00b00244c4a4d5d8mr15365307ljq.97.1646099259987;
        Mon, 28 Feb 2022 17:47:39 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzJ5hCTbfyBOqrRW7yCVhA13lM9sJi5Vxe5wjHoF/hQ4fvPwxZrUmAPDewdu4KFv9hll3xHVZ0CbU9/hV+Sprk=
X-Received: by 2002:a05:651c:90b:b0:244:c4a4:d5d8 with SMTP id
 e11-20020a05651c090b00b00244c4a4d5d8mr15365294ljq.97.1646099259773; Mon, 28
 Feb 2022 17:47:39 -0800 (PST)
MIME-Version: 1.0
References: <20220224103852.311369-1-baymaxhuang@gmail.com>
 <20220228033805.1579435-1-baymaxhuang@gmail.com> <CACGkMEtFFe3mVkXYjYJZtGdU=tAB+T5TYCqySzSxR2N5e4UV1A@mail.gmail.com>
 <20220228091539.057c80ef@hermes.local>
In-Reply-To: <20220228091539.057c80ef@hermes.local>
From:   Jason Wang <jasowang@redhat.com>
Date:   Tue, 1 Mar 2022 09:47:28 +0800
Message-ID: <CACGkMEsqKQD_mBRB5FQwoOTR-gq1Br1oEdtEoxBLhbCSt4SRgA@mail.gmail.com>
Subject: Re: [PATCH net-next v3] tun: support NAPI for packets received from
 batched XDP buffs
To:     Stephen Hemminger <stephen@networkplumber.org>
Cc:     Harold Huang <baymaxhuang@gmail.com>,
        netdev <netdev@vger.kernel.org>, Paolo Abeni <pabeni@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        open list <linux-kernel@vger.kernel.org>,
        "open list:XDP (eXpress Data Path)" <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 1, 2022 at 1:15 AM Stephen Hemminger
<stephen@networkplumber.org> wrote:
>
> On Mon, 28 Feb 2022 15:46:56 +0800
> Jason Wang <jasowang@redhat.com> wrote:
>
> > On Mon, Feb 28, 2022 at 11:38 AM Harold Huang <baymaxhuang@gmail.com> wrote:
> > >
> > > In tun, NAPI is supported and we can also use NAPI in the path of
> > > batched XDP buffs to accelerate packet processing. What is more, after
> > > we use NAPI, GRO is also supported. The iperf shows that the throughput of
> > > single stream could be improved from 4.5Gbps to 9.2Gbps. Additionally, 9.2
> > > Gbps nearly reachs the line speed of the phy nic and there is still about
> > > 15% idle cpu core remaining on the vhost thread.
> > >
> > > Test topology:
> > > [iperf server]<--->tap<--->dpdk testpmd<--->phy nic<--->[iperf client]
> > >
> > > Iperf stream:
> > > iperf3 -c 10.0.0.2  -i 1 -t 10
> > >
> > > Before:
> > > ...
> > > [  5]   5.00-6.00   sec   558 MBytes  4.68 Gbits/sec    0   1.50 MBytes
> > > [  5]   6.00-7.00   sec   556 MBytes  4.67 Gbits/sec    1   1.35 MBytes
> > > [  5]   7.00-8.00   sec   556 MBytes  4.67 Gbits/sec    2   1.18 MBytes
> > > [  5]   8.00-9.00   sec   559 MBytes  4.69 Gbits/sec    0   1.48 MBytes
> > > [  5]   9.00-10.00  sec   556 MBytes  4.67 Gbits/sec    1   1.33 MBytes
> > > - - - - - - - - - - - - - - - - - - - - - - - - -
> > > [ ID] Interval           Transfer     Bitrate         Retr
> > > [  5]   0.00-10.00  sec  5.39 GBytes  4.63 Gbits/sec   72          sender
> > > [  5]   0.00-10.04  sec  5.39 GBytes  4.61 Gbits/sec               receiver
> > >
> > > After:
> > > ...
> > > [  5]   5.00-6.00   sec  1.07 GBytes  9.19 Gbits/sec    0   1.55 MBytes
> > > [  5]   6.00-7.00   sec  1.08 GBytes  9.30 Gbits/sec    0   1.63 MBytes
> > > [  5]   7.00-8.00   sec  1.08 GBytes  9.25 Gbits/sec    0   1.72 MBytes
> > > [  5]   8.00-9.00   sec  1.08 GBytes  9.25 Gbits/sec   77   1.31 MBytes
> > > [  5]   9.00-10.00  sec  1.08 GBytes  9.24 Gbits/sec    0   1.48 MBytes
> > > - - - - - - - - - - - - - - - - - - - - - - - - -
> > > [ ID] Interval           Transfer     Bitrate         Retr
> > > [  5]   0.00-10.00  sec  10.8 GBytes  9.28 Gbits/sec  166          sender
> > > [  5]   0.00-10.04  sec  10.8 GBytes  9.24 Gbits/sec               receiver
> > >
> > > Reported-at: https://lore.kernel.org/all/CACGkMEvTLG0Ayg+TtbN4q4pPW-ycgCCs3sC3-TF8cuRTf7Pp1A@mail.gmail.com
> > > Signed-off-by: Harold Huang <baymaxhuang@gmail.com>
> >
> > Acked-by: Jason Wang <jasowang@redhat.com>
>
> Would this help when using sendmmsg and recvmmsg on the TAP device?

We haven't exported the socket object of tuntap to userspace. So we
can't use sendmmsg()/recvmsg() now.

> Asking because interested in speeding up another use of TAP device, and wondering
> if this would help.
>

Yes, it would be interesting. We need someone to work on that.

Thanks

