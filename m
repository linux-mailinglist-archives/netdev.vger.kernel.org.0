Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 813F73E9DA3
	for <lists+netdev@lfdr.de>; Thu, 12 Aug 2021 06:36:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234187AbhHLEhT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Aug 2021 00:37:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53374 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233944AbhHLEhT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Aug 2021 00:37:19 -0400
Received: from mail-pl1-x62d.google.com (mail-pl1-x62d.google.com [IPv6:2607:f8b0:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 809B3C061765;
        Wed, 11 Aug 2021 21:36:54 -0700 (PDT)
Received: by mail-pl1-x62d.google.com with SMTP id b7so5622562plh.7;
        Wed, 11 Aug 2021 21:36:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Xaj8kqlp1ggNrNt1fsWQYeeZnV1wGuQKD/BDozzpsHQ=;
        b=PlguRCx/bjsKIoqgtqehUYdY1EjGaPLpnj1JZ4xQZwXEtKVtCB2Z3mrlj/djr1QwrI
         LfAqeqG7q0sYnOUCaMaE5XzUd8QmtZoktNiwywuqe6zKzDYHHJzelAMwC/qHAYxo2b7h
         M7mXmb1EvuZ1H6XXF99iKsMPwT7buNPB3muxTX0YWhyYFRG0bYYeCPirDWXPQDwyBrD3
         surFuMJBVi7u7093xfhbOCctvSPDQ5y/5RskzBgzdLQJtARXiwtAjd5441tb1VYc+5st
         1M/xvzOXXgrLx2HrP8Kxp6OopethkgtMUNbqNugvCqr4DCmL2BJ1jRF42Fmq4UIZpMLH
         tiuA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Xaj8kqlp1ggNrNt1fsWQYeeZnV1wGuQKD/BDozzpsHQ=;
        b=NnDehuaqmq2cZ99gI0l0wp5CMOgZCDhK4lIuMgYE474be7retgi0YJHPk2GsSPbLb7
         gtOS6kCSHBIhLlYG4OLr3/WG2PJ4g4ya+GKIixRIdQ5mNySH5o5T6DowpzTDoWy2bEyE
         rF9sx82SXtmvESZlfePsL99BbOiSoZEaNX5ZtgM7dd6EV5+a0JxhGjI4zBoWAhcdyPZP
         KKazr8Qcf5FyjiiTw4vSQ/EuXd620Zp4YpfI3uRM9FNrAZ6wxG3zW4VcK2mPplcOyMyf
         B5Na7cX2LB/m2HlIdund85Lc4Vcb2K1gUjRHmZuMX872iHyL4hZtbQUUIdDI1egeyS4n
         BAyA==
X-Gm-Message-State: AOAM533zmSE3yZKelPiPaxj2QrWUuRPxeXDDXJKqm6sjGib8DqS3jWFA
        8CQ18TlseiCj+aoLwNLkJA4=
X-Google-Smtp-Source: ABdhPJz/RBm1XY5TjUDbVSmHXH7DpbOP+vSACxWwNrHDZlF2fal69iSXyN+cuMHJyAlrLWyuT3xEVg==
X-Received: by 2002:a17:90b:2313:: with SMTP id mt19mr14417168pjb.230.1628743014002;
        Wed, 11 Aug 2021 21:36:54 -0700 (PDT)
Received: from fedora ([2405:201:6008:6ce2:9fb0:9db:90a4:39e2])
        by smtp.gmail.com with ESMTPSA id j23sm8747218pjn.12.2021.08.11.21.36.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Aug 2021 21:36:53 -0700 (PDT)
Date:   Thu, 12 Aug 2021 10:06:46 +0530
From:   Shreyansh Chouhan <chouhan.shreyansh630@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org, edumazet@google.com,
        willemb@google.com, xie.he.0141@gmail.com, gustavoars@kernel.org,
        wanghai38@huawei.com, tannerlove@google.com, eyal.birger@gmail.com,
        rsanger@wand.net.nz, jiapeng.chong@linux.alibaba.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: Can a valid vnet header have both csum_start and csum_offset 0?
Message-ID: <YRSlXr2bsFfZOBgw@fedora>
References: <YRLONiYsdqKLeja3@fedora>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YRLONiYsdqKLeja3@fedora>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Aug 11, 2021 at 12:36:38AM +0530, Shreyansh Chouhan wrote:
> Hi,
> 
> When parsing the vnet header in __packet_snd_vnet_parse[1], we do not
> check for if the values of csum_start and csum_offset given in the
> header are both 0.
> 
> Having both these values 0, however, causes a crash[2] further down the
> gre xmit code path. In the function ipgre_xmit, we pull the ip header
> and gre header from skb->data, this results in an invalid
> skb->csum_start which was calculated from the vnet header. The
> skb->csum_start offset in this case turns out to be lower than
> skb->transport_header. This causes us to pass a negative number as an
> argument to csum_partial[3] and eventually to do_csum[4], which then causes
> a kernel oops in the while loop.
> 
> I do not understand what should the correct behavior be in this
> scenario, should we consider this vnet header as invalid?

Something like the following diff:

diff --git a/net/packet/af_packet.c b/net/packet/af_packet.c
index 57a1971f29e5..65bff1c8f75c 100644
--- a/net/packet/af_packet.c
+++ b/net/packet/af_packet.c
@@ -2479,13 +2479,17 @@ static void tpacket_destruct_skb(struct sk_buff *skb)
 
 static int __packet_snd_vnet_parse(struct virtio_net_hdr *vnet_hdr, size_t len)
 {
+	__u16 csum_start = __virtio16_to_cpu(vio_le(), vnet_hdr->csum_start);
+	__u16 csum_offset = __virtio16_to_cpu(vio_le(), vnet_hdr->csum_offset);
+	__u16 hdr_len = __virtio16_to_cpu(vio_le(), vnet_hdr->hdr_len);
+
+	if (csum_start + csum_offset == 0)
+		return -EINVAL;
+
 	if ((vnet_hdr->flags & VIRTIO_NET_HDR_F_NEEDS_CSUM) &&
-	    (__virtio16_to_cpu(vio_le(), vnet_hdr->csum_start) +
-	     __virtio16_to_cpu(vio_le(), vnet_hdr->csum_offset) + 2 >
-	      __virtio16_to_cpu(vio_le(), vnet_hdr->hdr_len)))
+	    csum_start + csum_offset + 2 > hdr_len)
 		vnet_hdr->hdr_len = __cpu_to_virtio16(vio_le(),
-			 __virtio16_to_cpu(vio_le(), vnet_hdr->csum_start) +
-			__virtio16_to_cpu(vio_le(), vnet_hdr->csum_offset) + 2);
+				csum_start + csum_offset + 2);
 
 	if (__virtio16_to_cpu(vio_le(), vnet_hdr->hdr_len) > len)
 		return -EINVAL;

> Or should we rather accomodate for both csum_start
> and csum_offset values to be 0 in ipgre_xmit?
> 
> Regards,
> Shreyansh Chouhan
> 
> --
> 
> [1] https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/net/packet/af_packet.c#n2480
> [2] https://syzkaller.appspot.com/bug?id=c391f74aac26dd8311c45743ae618f9d5e38b674
> [3] https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/include/linux/skbuff.h#n4662
> [4] https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/arch/x86/lib/csum-partial_64.c#n35
