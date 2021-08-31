Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 928443FCFFF
	for <lists+netdev@lfdr.de>; Wed,  1 Sep 2021 01:39:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241020AbhHaXj4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 Aug 2021 19:39:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51024 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240762AbhHaXjz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 31 Aug 2021 19:39:55 -0400
Received: from mail-io1-xd2c.google.com (mail-io1-xd2c.google.com [IPv6:2607:f8b0:4864:20::d2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A7794C061575;
        Tue, 31 Aug 2021 16:38:59 -0700 (PDT)
Received: by mail-io1-xd2c.google.com with SMTP id b10so1663276ioq.9;
        Tue, 31 Aug 2021 16:38:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=tUZ/6gxHKQY+MLhwwBoin+tt0s6rL2lsIE/bdjac6C4=;
        b=Hwz2yA+BGnUW70F5TcU+p9pBEzkaxBenxYPKrUMy8bn2dvVZQxBAme8tnnWFyrQLui
         nxLA6CMzP1PdOc4/1q8Spi4C8KNNYPqXeZSqvqPKgnE2YzuhEymcyKMzsXR3TUa3a3dq
         DNlPEInm/EE2GlK8ennahhp9TP5E8Es6gqDffJEuhx58ERdmYBCYL0pzJQ1Jfs37fKTI
         kf+Jpg2iqxIBg8GXXjyGQISO54UaKQPKKwbGPWCoVxH5aIiitEvGx2svPrr2Lju6oWOf
         0b//G5Z5iLXZ1LP5XsKRDwX7uozDHI7eaXcnUBNSLDX2rD0sLYUQK42PelaWIfYJCmF2
         dSvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=tUZ/6gxHKQY+MLhwwBoin+tt0s6rL2lsIE/bdjac6C4=;
        b=IW6XAWaCquExhoXT9G2b6Mktuc5+PygPnJ6pD64kppnqY6WKh1KbOcsob4T/NiAIOd
         y4lI3ndQT6WgQRdZjBtbuLbsGeiSMNUA6Q1+yuQ5nt8eexdvQQaIPGGSUZyscl3rkaDg
         lh/G7pEvEtjkq7DDMcxMZ0PGGLF9E2OuOIbyoYQ1P9dJ2kZgMnMteGvyaMij2BJT8ER+
         rU6+boQDBkFRflByZn8hk/IombgDh6syE9VSRPPNdYaQpBlPA53kxhHYY4LLo/XtpNCQ
         4yaB6bOFRuRQbAgIkLu1ECQlMW9Qc5JabSFtZvvpac7VgZYJ+fcqERF7UwohIwaIorKQ
         6zpg==
X-Gm-Message-State: AOAM531oYiNCc1PfTZQGZ07cfX2+XjVIN9SgYCbbObKyBib62RKSxCni
        hAvgM4MdPtYwL1O93XkD1UU=
X-Google-Smtp-Source: ABdhPJyOBRK9tUCp+HhnVJC/Dlt6j09dGDYtOfFkXUoGxK008rAkmj59uYhr4MFAJg6B1+P4pxCpug==
X-Received: by 2002:a5e:9819:: with SMTP id s25mr25084435ioj.63.1630453139017;
        Tue, 31 Aug 2021 16:38:59 -0700 (PDT)
Received: from localhost ([172.243.157.240])
        by smtp.gmail.com with ESMTPSA id n14sm11478077ilm.48.2021.08.31.16.38.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 31 Aug 2021 16:38:58 -0700 (PDT)
Date:   Tue, 31 Aug 2021 16:38:52 -0700
From:   John Fastabend <john.fastabend@gmail.com>
To:     Lorenzo Bianconi <lorenzo@kernel.org>, bpf@vger.kernel.org,
        netdev@vger.kernel.org
Cc:     lorenzo.bianconi@redhat.com, davem@davemloft.net, kuba@kernel.org,
        ast@kernel.org, daniel@iogearbox.net, shayagr@amazon.com,
        john.fastabend@gmail.com, dsahern@kernel.org, brouer@redhat.com,
        echaudro@redhat.com, jasowang@redhat.com,
        alexander.duyck@gmail.com, saeed@kernel.org,
        maciej.fijalkowski@intel.com, magnus.karlsson@intel.com,
        tirthendu.sarkar@intel.com, toke@redhat.com
Message-ID: <612ebd8c6484_6b87208a3@john-XPS-13-9370.notmuch>
In-Reply-To: <3d98cda6f49ef9ff34d2aec3d00924592b4739e3.1629473233.git.lorenzo@kernel.org>
References: <cover.1629473233.git.lorenzo@kernel.org>
 <3d98cda6f49ef9ff34d2aec3d00924592b4739e3.1629473233.git.lorenzo@kernel.org>
Subject: RE: [PATCH v12 bpf-next 05/18] net: xdp: add
 xdp_update_skb_shared_info utility routine
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Lorenzo Bianconi wrote:
> Introduce xdp_update_skb_shared_info routine to update frags array
> metadata in skb_shared_info data structure converting to a skb from
> a xdp_buff or xdp_frame.
> According to the current skb_shared_info architecture in
> xdp_frame/xdp_buff and to the xdp multi-buff support, there is
> no need to run skb_add_rx_frag() and reset frags array converting the buffer
> to a skb since the frag array will be in the same position for xdp_buff/xdp_frame
> and for the skb, we just need to update memory metadata.
> Introduce XDP_FLAGS_PF_MEMALLOC flag in xdp_buff_flags in order to mark
> the xdp_buff or xdp_frame as under memory-pressure if pages of the frags array
> are under memory pressure. Doing so we can avoid looping over all fragments in
> xdp_update_skb_shared_info routine. The driver is expected to set the
> flag constructing the xdp_buffer using xdp_buff_set_frag_pfmemalloc
> utility routine.
> Rely on xdp_update_skb_shared_info in __xdp_build_skb_from_frame routine
> converting the multi-buff xdp_frame to a skb after performing a XDP_REDIRECT.
> 
> Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>

Acked-by: John Fastabend <john.fastabend@gmail.com>
