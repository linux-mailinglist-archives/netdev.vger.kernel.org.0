Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3419650A1B4
	for <lists+netdev@lfdr.de>; Thu, 21 Apr 2022 16:11:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1389012AbiDUOLL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Apr 2022 10:11:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46736 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1388936AbiDUOLH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Apr 2022 10:11:07 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id E81603AA67
        for <netdev@vger.kernel.org>; Thu, 21 Apr 2022 07:08:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1650550096;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=QysMU2yYugYFLYjW2LOfTqqKvlLZq8H2fqc/5Hi2OwA=;
        b=Ax7o4mC6y4m4rWcXvieI+cev99D7t9Uy3ZN+x1m+HvGY2O1SRfWccxaQFWiYDIMnJ8oYua
        96Opj0Gk5Ui5eqe8bWJYVAEOuWK4KA8SjSDJDZU3pTzRsJmAeEZhpe+1bGhinAiYKE5D7x
        IuR2WIoStE4j9jB9b/2M/Kd5Ki+osH4=
Received: from mail-ej1-f71.google.com (mail-ej1-f71.google.com
 [209.85.218.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-321-UPDxcGE3Npu1pWS4OD6mjQ-1; Thu, 21 Apr 2022 10:08:12 -0400
X-MC-Unique: UPDxcGE3Npu1pWS4OD6mjQ-1
Received: by mail-ej1-f71.google.com with SMTP id sd37-20020a1709076e2500b006f01130b21fso1601785ejc.7
        for <netdev@vger.kernel.org>; Thu, 21 Apr 2022 07:08:12 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=QysMU2yYugYFLYjW2LOfTqqKvlLZq8H2fqc/5Hi2OwA=;
        b=AxCYjywZkTx7mGLUpYBIxCMtq3YuoaVrGll4fe14PcO+FlxJ6HUDK44PJkSD6m5y++
         LoGsT+YPGoQN58NtqNzznE5sQhQiraA/DY6R5eP1ZllStNhqonFziwbIq8N9UvTY8ynT
         /UaC2LNwUBZ5qznfcJzL/McTwfNk6sbRCFkaVjLHkGyBT/6A3/RlVO5mygP7QJela5mr
         17e2fKKKV2weyk0qJHHlHZE5a3I/5v7bXOwlVjfJvaYzyIfjKp2ROSse3Q4tQUWnoeDB
         fqX9rDLRFm3tQ5X33DGQz7pdc770AW1eAxhd565+kKGy880UqNLI6JzgHOmAOBqpul/6
         yJnA==
X-Gm-Message-State: AOAM533maxGQI8OC9+kMsWrLst4MBA6DSlseGvMNl9JvnY7vgb/AntH1
        ulb3jjwMID2hWX/YBu6kjm0ZzCFoMNHBNjuREQ8ns8j5Gbrt0R31wTjJqBKzGNLMMGVqx1TPRQ9
        r4du8nasKZfbXjoiV
X-Received: by 2002:aa7:d2d6:0:b0:423:97a4:801c with SMTP id k22-20020aa7d2d6000000b0042397a4801cmr28374706edr.383.1650550091510;
        Thu, 21 Apr 2022 07:08:11 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJz3UzhXjJKIUWIe+FtmghcBY3LXg/jvh/2MMeLG1JqYitGhX//nK2tUibwxnsLz37Kl67RNDA==
X-Received: by 2002:aa7:d2d6:0:b0:423:97a4:801c with SMTP id k22-20020aa7d2d6000000b0042397a4801cmr28374687edr.383.1650550091329;
        Thu, 21 Apr 2022 07:08:11 -0700 (PDT)
Received: from sgarzare-redhat ([217.171.75.76])
        by smtp.gmail.com with ESMTPSA id ee17-20020a056402291100b0041fe1e4e342sm11340261edb.27.2022.04.21.07.08.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 Apr 2022 07:08:10 -0700 (PDT)
Date:   Thu, 21 Apr 2022 16:08:05 +0200
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     "Andrea Parri (Microsoft)" <parri.andrea@gmail.com>
Cc:     KY Srinivasan <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        Wei Liu <wei.liu@kernel.org>, Dexuan Cui <decui@microsoft.com>,
        Michael Kelley <mikelley@microsoft.com>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, linux-hyperv@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/5] hv_sock: Add validation for untrusted Hyper-V values
Message-ID: <20220421140805.qg4cwqhsq5vuqkut@sgarzare-redhat>
References: <20220420200720.434717-1-parri.andrea@gmail.com>
 <20220420200720.434717-4-parri.andrea@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20220420200720.434717-4-parri.andrea@gmail.com>
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 20, 2022 at 10:07:18PM +0200, Andrea Parri (Microsoft) wrote:
>For additional robustness in the face of Hyper-V errors or malicious
>behavior, validate all values that originate from packets that Hyper-V
>has sent to the guest in the host-to-guest ring buffer.  Ensure that
>invalid values cannot cause data being copied out of the bounds of the
>source buffer in hvs_stream_dequeue().
>
>Signed-off-by: Andrea Parri (Microsoft) <parri.andrea@gmail.com>
>---
> include/linux/hyperv.h           |  5 +++++
> net/vmw_vsock/hyperv_transport.c | 11 +++++++++--
> 2 files changed, 14 insertions(+), 2 deletions(-)
>
>diff --git a/include/linux/hyperv.h b/include/linux/hyperv.h
>index fe2e0179ed51e..55478a6810b60 100644
>--- a/include/linux/hyperv.h
>+++ b/include/linux/hyperv.h
>@@ -1663,6 +1663,11 @@ static inline u32 hv_pkt_datalen(const struct vmpacket_descriptor *desc)
> 	return (desc->len8 << 3) - (desc->offset8 << 3);
> }
>
>+/* Get packet length associated with descriptor */
>+static inline u32 hv_pkt_len(const struct vmpacket_descriptor *desc)
>+{
>+	return desc->len8 << 3;
>+}
>
> struct vmpacket_descriptor *
> hv_pkt_iter_first_raw(struct vmbus_channel *channel);
>diff --git a/net/vmw_vsock/hyperv_transport.c b/net/vmw_vsock/hyperv_transport.c
>index 8c37d07017fc4..092cadc2c866d 100644
>--- a/net/vmw_vsock/hyperv_transport.c
>+++ b/net/vmw_vsock/hyperv_transport.c
>@@ -577,12 +577,19 @@ static bool hvs_dgram_allow(u32 cid, u32 port)
> static int hvs_update_recv_data(struct hvsock *hvs)
> {
> 	struct hvs_recv_buf *recv_buf;
>-	u32 payload_len;
>+	u32 pkt_len, payload_len;
>+
>+	pkt_len = hv_pkt_len(hvs->recv_desc);
>+
>+	/* Ensure the packet is big enough to read its header */
>+	if (pkt_len < HVS_HEADER_LEN)
>+		return -EIO;
>
> 	recv_buf = (struct hvs_recv_buf *)(hvs->recv_desc + 1);
> 	payload_len = recv_buf->hdr.data_size;
>
>-	if (payload_len > HVS_MTU_SIZE)
>+	/* Ensure the packet is big enough to read its payload */
>+	if (payload_len > pkt_len - HVS_HEADER_LEN || payload_len > HVS_MTU_SIZE)

checkpatch warns that we exceed 80 characters, I do not have a strong 
opinion on this, but if you have to resend better break the condition 
into 2 lines.

Maybe even update or remove the comment? (it only describes the first 
condition, but the conditions are pretty clear, so I don't think it adds 
much).

Thanks,
Stefano

