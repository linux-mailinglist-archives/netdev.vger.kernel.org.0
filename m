Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 571A7379FF0
	for <lists+netdev@lfdr.de>; Tue, 11 May 2021 08:47:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230401AbhEKGs0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 May 2021 02:48:26 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:52115 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230381AbhEKGsW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 May 2021 02:48:22 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1620715636;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=sx7nPbuFzoppkZ1L0KO8BbiXNbbmx+wsvBNBIIout20=;
        b=MuQf+ICsW5uAH/LDQdThW0QAnzmYwlQCBaR6VKSPr3fNHW1PipTEMKRKA2QbeGysV2guET
        LRW1yqr92q3c1lCH+eHzeFdS6flpey/ceOrA6yF2Vs1agFl2FXIPi2OWLD6652Grk+gh6Q
        DSVxBA4vbCMEqepkEnlqihV0OGJEmU0=
Received: from mail-pl1-f197.google.com (mail-pl1-f197.google.com
 [209.85.214.197]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-527-hMC8WMR0MiaXgYcB0U5azw-1; Tue, 11 May 2021 02:47:12 -0400
X-MC-Unique: hMC8WMR0MiaXgYcB0U5azw-1
Received: by mail-pl1-f197.google.com with SMTP id m10-20020a170902f20ab02900ed7e32ff42so7110204plc.19
        for <netdev@vger.kernel.org>; Mon, 10 May 2021 23:47:12 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=sx7nPbuFzoppkZ1L0KO8BbiXNbbmx+wsvBNBIIout20=;
        b=G1khTUaSNhkp/5vYX3kWnClJsyRHdwnoXVE14ESIF9rSlXFhaKTSXEXjlfldnttjr7
         TEuXcfKIBAdYo4Q6Qb1dIlRWiEPZSn1vaWv6TfoegjM2Qqb0de38LclwDz21xflk4tQY
         Z8mEtbixjHyssKv0jPUwOGqPMUCMlkfJToptL2PhZFD1RqbvsxeL+KXU8vJ+Kq+OAg+o
         EuV+lssq5IzwDktuHy8TUxmRoc8u9RymJZRIxfNCAqoi2RqttfSsD39zAgzoYW/uBlV1
         cSn6GtlrGHBt5/QNnaPQqYqqZHsdRImi+gPM+WexmYKpLy6DRUVd2xCUtHv3k3BTpz13
         TTmQ==
X-Gm-Message-State: AOAM531LvEZpsMSHhdf4uPO9QKpxTD4hEL5FIg/6d1/Uj+RWfcxpFjN/
        +v24YbboTfXgMFbfciSQwS41DwTPQWl5ZSC8G1oov7bE4nKSVobt5zU97IuWgQCmfCRrVpM9YUC
        cyQyDpKw6dAToLMwi
X-Received: by 2002:a63:4a44:: with SMTP id j4mr28981021pgl.283.1620715631786;
        Mon, 10 May 2021 23:47:11 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJz4Y68wI4Mxy05AHpRaptwpa5l3QU8whi/1YTywzoMGIWFR/WITTxyH3t+IdjkN5CZAtIhfpw==
X-Received: by 2002:a63:4a44:: with SMTP id j4mr28981001pgl.283.1620715631488;
        Mon, 10 May 2021 23:47:11 -0700 (PDT)
Received: from wangxiaodeMacBook-Air.local ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id ml19sm1607366pjb.2.2021.05.10.23.47.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 10 May 2021 23:47:10 -0700 (PDT)
Subject: Re: [PATCH 1/4] virtio-net: add definitions for host USO feature
To:     Yuri Benditovich <yuri.benditovich@daynix.com>,
        davem@davemloft.net, kuba@kernel.org, mst@redhat.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org
Cc:     yan@daynix.com
References: <20210511044253.469034-1-yuri.benditovich@daynix.com>
 <20210511044253.469034-2-yuri.benditovich@daynix.com>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <40938c20-5851-089b-c3c0-074bbd636970@redhat.com>
Date:   Tue, 11 May 2021 14:47:02 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <20210511044253.469034-2-yuri.benditovich@daynix.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


在 2021/5/11 下午12:42, Yuri Benditovich 写道:
> Define feature bit and GSO type according to the VIRTIO
> specification.
>
> Signed-off-by: Yuri Benditovich <yuri.benditovich@daynix.com>
> ---
>   include/uapi/linux/virtio_net.h | 2 ++
>   1 file changed, 2 insertions(+)
>
> diff --git a/include/uapi/linux/virtio_net.h b/include/uapi/linux/virtio_net.h
> index 3f55a4215f11..a556ac735d7f 100644
> --- a/include/uapi/linux/virtio_net.h
> +++ b/include/uapi/linux/virtio_net.h
> @@ -57,6 +57,7 @@
>   					 * Steering */
>   #define VIRTIO_NET_F_CTRL_MAC_ADDR 23	/* Set MAC address */
>   
> +#define VIRTIO_NET_F_HOST_USO     56	/* Host can handle USO packets */
>   #define VIRTIO_NET_F_HASH_REPORT  57	/* Supports hash report */
>   #define VIRTIO_NET_F_RSS	  60	/* Supports RSS RX steering */
>   #define VIRTIO_NET_F_RSC_EXT	  61	/* extended coalescing info */
> @@ -130,6 +131,7 @@ struct virtio_net_hdr_v1 {
>   #define VIRTIO_NET_HDR_GSO_TCPV4	1	/* GSO frame, IPv4 TCP (TSO) */
>   #define VIRTIO_NET_HDR_GSO_UDP		3	/* GSO frame, IPv4 UDP (UFO) */
>   #define VIRTIO_NET_HDR_GSO_TCPV6	4	/* GSO frame, IPv6 TCP */
> +#define VIRTIO_NET_HDR_GSO_UDP_L4	5	/* GSO frame, IPv4 UDP (USO) */


This is the gso_type not the feature actually.

I wonder what's the reason for not

1) introducing a dedicated virtio-net feature bit for this 
(VIRTIO_NET_F_GUEST_GSO_UDP_L4.
2) toggle the NETIF_F_GSO_UDP_L4  feature for tuntap based on the 
negotiated feature.

Thanks


>   #define VIRTIO_NET_HDR_GSO_ECN		0x80	/* TCP has ECN set */
>   	__u8 gso_type;
>   	__virtio16 hdr_len;	/* Ethernet + IP + tcp/udp hdrs */

