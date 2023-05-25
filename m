Return-Path: <netdev+bounces-5478-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 592E37118CB
	for <lists+netdev@lfdr.de>; Thu, 25 May 2023 23:08:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 004AA281815
	for <lists+netdev@lfdr.de>; Thu, 25 May 2023 21:08:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1EB8324E9B;
	Thu, 25 May 2023 21:08:30 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A7461EA8B
	for <netdev@vger.kernel.org>; Thu, 25 May 2023 21:08:29 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 753DF194
	for <netdev@vger.kernel.org>; Thu, 25 May 2023 14:08:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1685048907;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=fQFPGHestOCuKAWvf5+aboFtChT5jhD5sIE19dqJk9k=;
	b=J/S6zCdHpN4v3sn+fW5jlL+rpDVem2AQ4b8nqhZNehhFXUo6nZh4oBRBjyKn5qyxBoZ04x
	sXJYeN2JeXcCYO/ksSsoc22dkT4sBSbXAQ8a+VUJ0YLrW1+So8WhZvcHy4QFb0JFl0MZL2
	yBESvELzdrV6OrxArvoBJ699vageO8o=
Received: from mail-qk1-f199.google.com (mail-qk1-f199.google.com
 [209.85.222.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-271-wAgA_1XtPBeIp4s6Ar7z3w-1; Thu, 25 May 2023 17:08:26 -0400
X-MC-Unique: wAgA_1XtPBeIp4s6Ar7z3w-1
Received: by mail-qk1-f199.google.com with SMTP id af79cd13be357-75b04cf87c0so6747385a.2
        for <netdev@vger.kernel.org>; Thu, 25 May 2023 14:08:26 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685048905; x=1687640905;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=fQFPGHestOCuKAWvf5+aboFtChT5jhD5sIE19dqJk9k=;
        b=JJFgmJ4wJp3aWWsGRRntzU5HJLj/EoKwP9G0Ab01TjZaOp3j5jam6Nh4ey7JAr4Jfk
         nf32QmUuCrGCNMus1N2ShWBN+gnhnbSsTpkKk9TlK0yc7w2//nI/I8wIJUXRHYPwrZgg
         +8KozOTJy74AXa5Ghc+6VervhWOjmWTjo9Kgd4uXVIrT5lJRv+7/t8+cOMrXaBbFuxRt
         pWFsri5abKirmzx7AnHCfmWe23Hkv9fspZwELvrAiqFo/9A7uAcw/saALQ7LnLPvxCP+
         SVSPVZ97gFv8tYOvrdHsQf+1ewWVSat6VM2g4nGVJVbJ57oTFPw72O87sZFG3q0m6iy+
         iRuw==
X-Gm-Message-State: AC+VfDwP2e8ALJ+SxxHnZhXtX0haeuLTDlHyV3bPjARuF30F99JmCHrz
	l0cl99qw12+BTT3dkSBKlCyWs+tYnuPACkBDNxK/zKK/Zo/phdPrp7KGNo+eLeD8fAEYYHNDCrn
	AA/jCayOlqKL5WVuEwvL2h8LR
X-Received: by 2002:ac8:7f46:0:b0:3f6:b934:b0a2 with SMTP id g6-20020ac87f46000000b003f6b934b0a2mr1058509qtk.5.1685048905378;
        Thu, 25 May 2023 14:08:25 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ7fvgoUxNXWMjmItGEy4TqEox4eDVNd8eiOOi25AKmDLlZQfRJ5ZvFIsArvLGLQbYrbd4n07g==
X-Received: by 2002:ac8:7f46:0:b0:3f6:b934:b0a2 with SMTP id g6-20020ac87f46000000b003f6b934b0a2mr1058485qtk.5.1685048905029;
        Thu, 25 May 2023 14:08:25 -0700 (PDT)
Received: from localhost ([37.163.27.228])
        by smtp.gmail.com with ESMTPSA id s22-20020a05622a1a9600b003f740336bb9sm723479qtc.9.2023.05.25.14.08.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 May 2023 14:08:24 -0700 (PDT)
Date: Thu, 25 May 2023 23:08:19 +0200
From: Andrea Claudi <aclaudi@redhat.com>
To: Stephen Hemminger <stephen@networkplumber.org>
Cc: netdev@vger.kernel.org
Subject: Re: [PATCH iproute2 v3 0/2] vxlan: option printing
Message-ID: <ZG/OQ3lVZT4ESiwL@renaissance-vector>
References: <20230525165922.9711-1-stephen@networkplumber.org>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230525165922.9711-1-stephen@networkplumber.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Thu, May 25, 2023 at 09:59:20AM -0700, Stephen Hemminger wrote:
> This patchset makes printing of vxlan details more consistent.
> It also adds extra verbose output.
> 
> Before:
> $ ip -d link show dev vxlan0
> 4: vxlan0: <BROADCAST,MULTICAST> mtu 1450 qdisc noop state DOWN mode DEFAULT group default qlen 1000
>     link/ether e6:a4:54:b2:34:85 brd ff:ff:ff:ff:ff:ff promiscuity 0  allmulti 0 minmtu 68 maxmtu 65535 
>     vxlan id 42 group 239.1.1.1 dev enp2s0 srcport 0 0 dstport 4789 ttl auto ageing 300 udpcsum noudp6zerocsumtx noudp6zerocsumrx addrgenmode eui64 numtxqueues 1 numrxqueues 1 gso_max_size 64000 gso_max_segs 64 tso_max_size 64000 tso_max_segs 64 gro_max_size 65536 
> 
> After:
> $ ip -d link show dev vxlan0
> 4: vxlan0: <BROADCAST,MULTICAST> mtu 1450 qdisc noop state DOWN mode DEFAULT group default qlen 1000
>     link/ether e6:a4:54:b2:34:85 brd ff:ff:ff:ff:ff:ff promiscuity 0  allmulti 0 minmtu 68 maxmtu 65535 
>     vxlan id 42 group 239.1.1.1 dev enp2s0 srcport 0 0 dstport 4789 ttl auto ageing 300 addrgenmode eui64 numtxqueues 1 numrxqueues 1 gso_max_size 64000 gso_max_segs 64 tso_max_size 64000 tso_max_segs 64 gro_max_size 65536
> 
> To get all settings, use multiple detail flags
> $ ip -d -d link show dev vxlan0
> 4: vxlan0: <BROADCAST,MULTICAST> mtu 1450 qdisc noop state DOWN mode DEFAULT group default qlen 1000
>     link/ether e6:a4:54:b2:34:85 brd ff:ff:ff:ff:ff:ff promiscuity 0  allmulti 0 minmtu 68 maxmtu 65535 
>     vxlan noexternal id 42 group 239.1.1.1 dev enp2s0 srcport 0 0 dstport 4789 learning noproxy norsc nol2miss nol3miss ttl auto ageing 300 udp_csum noudp_zero_csum6_tx noudp_zero_csum6_rx noremcsum_tx noremcsum_rx addrgenmode eui64 numtxqueues 1 numrxqueues 1 gso_max_size 64000 gso_max_segs 64 tso_max_size 64000 tso_max_segs 64 gro_max_size 65536
> 
> Stephen Hemminger (2):
>   vxlan: use print_nll for gbp and gpe
>   vxlan: make option printing more consistent
> 
>  include/json_print.h |  9 +++++
>  ip/iplink_vxlan.c    | 95 ++++++++++----------------------------------
>  lib/json_print.c     | 19 +++++++++
>  3 files changed, 48 insertions(+), 75 deletions(-)
> 
> -- 
> 2.39.2
> 
>

That's perfect for me, thanks Stephen.

Maybe the PRINT_VXLAN_OPTION macro can be moved to json_print.h to be
reused in other parts of iproute, but we can do that if and when we'll
need it.

Acked-by: Andrea Claudi <aclaudi@redhat.com>


