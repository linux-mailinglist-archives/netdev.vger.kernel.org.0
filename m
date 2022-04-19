Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B35B850704F
	for <lists+netdev@lfdr.de>; Tue, 19 Apr 2022 16:28:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344966AbiDSO3H (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Apr 2022 10:29:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44756 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349056AbiDSO27 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Apr 2022 10:28:59 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 7E1577645
        for <netdev@vger.kernel.org>; Tue, 19 Apr 2022 07:26:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1650378376;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=8s+pPGRz1Zr2HimXdsiESRrW1tRMdv6YKimHzq2vGb8=;
        b=PdVtk48CPc5l4tTUtKcYKKtS6vcFstKOFV+J+szMwzKKm/Ysr43eFpAr23UnjKFDB/13ac
        Nck53Fa63Xyllac6MoHptm2rLUegLotZrhod9kuBei/2iSZ3HLeRtp/uHmw4sqr7bzAayD
        /HvBCvPCedA1NMcBMNzyNMaOoBFRsqA=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-578-q9m6eMKaN4WlFxkwdK1whg-1; Tue, 19 Apr 2022 10:26:15 -0400
X-MC-Unique: q9m6eMKaN4WlFxkwdK1whg-1
Received: by mail-wr1-f69.google.com with SMTP id 61-20020adf80c3000000b00207a6ffdd1eso1951185wrl.14
        for <netdev@vger.kernel.org>; Tue, 19 Apr 2022 07:26:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=8s+pPGRz1Zr2HimXdsiESRrW1tRMdv6YKimHzq2vGb8=;
        b=21BTcZii+PAZU8fOnsEwT08sbOpDfhhRGZW1X9CbnavikvaN5zAtm6sBss7La5Q519
         bulgkhAf3av9St9hoXKv/9IZJvL6yiXkYgZVJkZQrclvatErw9VyRvm8DBRGzTnr/VzQ
         H/lZ3/UxDFmW+jOtitCf/L7Fl+akgnHWlg5vh8CKMFEXL74R/76DFLaoiYp21tf2jJyJ
         Cnum634fKgRawvd7C04VwUme1UOyk18GLd41DKbAj4PG1pFbONnAF4k9It34SOC7WYNH
         HAHQOoL8LFI61NtxAU8FNt+3CTau3KWmsndZOY1Gp2Me2OQYstzXkMitRq9Pt0Ad2aPI
         0YEg==
X-Gm-Message-State: AOAM530HjRqIMaZLF8/Wc2yTytR6znTB58nxjXnJcUOV7HM5oy5hNv3X
        XT21uFGyL++Ip3gR00Po2H7XTUdftDPNieUUmx+D34ZahkQ/YCurKRNfqwU15I9fhmIdKWJg0em
        IVAhPcgzfVVMlqYC7
X-Received: by 2002:a5d:584c:0:b0:20a:821a:b393 with SMTP id i12-20020a5d584c000000b0020a821ab393mr12389240wrf.141.1650378374115;
        Tue, 19 Apr 2022 07:26:14 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyqeCv7YzF+w0wTnLztCkQOTZj9S/cIJHLdA9pOMdkh9Lf6AZp3WzsHpWOUjonfL25Rwue5jw==
X-Received: by 2002:a5d:584c:0:b0:20a:821a:b393 with SMTP id i12-20020a5d584c000000b0020a821ab393mr12389217wrf.141.1650378373868;
        Tue, 19 Apr 2022 07:26:13 -0700 (PDT)
Received: from redhat.com ([2.53.17.80])
        by smtp.gmail.com with ESMTPSA id i6-20020a0560001ac600b0020a93f75030sm5602953wry.48.2022.04.19.07.26.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Apr 2022 07:26:13 -0700 (PDT)
Date:   Tue, 19 Apr 2022 10:26:09 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Cc:     Hangbin Liu <liuhangbin@gmail.com>,
        Maxim Mikityanskiy <maximmi@mellanox.com>,
        Mike Pattrick <mpattric@redhat.com>, netdev@vger.kernel.org,
        Eric Dumazet <edumazet@google.com>,
        virtualization@lists.linux-foundation.org,
        Balazs Nemeth <bnemeth@redhat.com>,
        Flavio Leitner <fbl@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jason Wang <jasowang@redhat.com>
Subject: Re: [PATCH net 1/2] net/af_packet: adjust network header position
 for VLAN tagged packets
Message-ID: <20220419101325-mutt-send-email-mst@kernel.org>
References: <20220418044339.127545-1-liuhangbin@gmail.com>
 <20220418044339.127545-2-liuhangbin@gmail.com>
 <CA+FuTScQ=tP=cr5f2S97Z7ex1HMX5R-C0W6JE2Bx5UWgiGknZA@mail.gmail.com>
 <Yl4mU0XLmPukG0WO@Laptop-X1>
 <CA+FuTSfBU7ck91ayf_t9=7eRGJZHuWSeXzX2SxFAQMPSitY9SA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+FuTSfBU7ck91ayf_t9=7eRGJZHuWSeXzX2SxFAQMPSitY9SA@mail.gmail.com>
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 19, 2022 at 09:56:02AM -0400, Willem de Bruijn wrote:
> > >
> > > We should also maintain feature consistency between packet_snd,
> > > tpacket_snd and to the limitations of its feature set to
> > > packet_sendmsg_spkt. The no_fcs is already lacking in tpacket_snd as
> > > far as I can tell. But packet_sendmsg_spkt also sets it and calls
> > > packet_parse_headers.
> >
> > Yes, I think we could fix the tpacket_snd() in another patch.
> >
> > There are also some duplicated codes in these *_snd functions.
> > I think we can move them out to one single function.
> 
> Please don't refactor this code. It will complicate future backports
> of stable fixes.

Hmm I don't know offhand which duplication this refers to specifically
so maybe it's not worth addressing specifically but generally not
cleaning up code just because of backports seems wrong ...

> > > Because this patch touches many other packets besides the ones
> > > intended, I am a bit concerned about unintended consequences. Perhaps
> >
> > Yes, makes sense.
> >
> > > stretching the definition of the flags to include VLAN is acceptable
> > > (unlike outright tunnels), but even then I would suggest for net-next.
> >
> > As I asked, I'm not familiar with virtio code. Do you think if I should
> > add a new VIRTIO_NET_HDR_GSO_VLAN flag? It's only a L2 flag without any L3
> > info. If I add something like VIRTIO_NET_HDR_GSO_VLAN_TCPV4/TCPV6/UDP. That
> > would add more combinations. Which doesn't like a good idea.
> 
> I would prefer a new flag to denote this type, so that we can be
> strict and only change the datapath for packets that have this flag
> set (and thus express the intent).
> 
> But the VIRTIO_NET_HDR types are defined in the virtio spec. The
> maintainers should probably chime in.

Yes, it's a UAPI extension, not to be done lightly. In this case IIUC
gso_type in the header is only u8 - 8 bits and 5 of these are already
used.  So I don't think the virtio TC will be all that happy to burn up
a bit unless a clear benefit can be demonstrated. 

I agree with the net-next proposal, I think it's more a feature than a
bugfix. In particular I think a Fixes tag can also be dropped in that
IIUC GSO for vlan packets didn't work even before that commit - right?

-- 
MST

