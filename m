Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CAE364AE8D9
	for <lists+netdev@lfdr.de>; Wed,  9 Feb 2022 06:13:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233097AbiBIFFr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Feb 2022 00:05:47 -0500
Received: from gmail-smtp-in.l.google.com ([23.128.96.19]:41436 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377804AbiBIEjW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Feb 2022 23:39:22 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 591FFC061578
        for <netdev@vger.kernel.org>; Tue,  8 Feb 2022 20:39:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1644381560;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=1kf6j/pfO95p2NADuTOz6pxSpChN6rEDgT0nLmQL7w4=;
        b=W1wfG42ZaAg3XL012mAnW20azBmDFI13ZIiQ/FyZf+hvOnlaXlis7Xkhxyxqt0B5zCE8hc
        NFjemdLxolcdUOeIx5USpaMc6nhvk271zsURbfd7CEHkcPOpRlH5FhIUrM+EAPlN0F0Sdi
        7jInAQIrWYawhdT5VYSkYlrjmWrkP70=
Received: from mail-pf1-f198.google.com (mail-pf1-f198.google.com
 [209.85.210.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-107-ljE9qz4fOt6JF0kwpd3UZQ-1; Tue, 08 Feb 2022 23:39:19 -0500
X-MC-Unique: ljE9qz4fOt6JF0kwpd3UZQ-1
Received: by mail-pf1-f198.google.com with SMTP id t24-20020aa79398000000b004e025989ac7so906974pfe.18
        for <netdev@vger.kernel.org>; Tue, 08 Feb 2022 20:39:18 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=1kf6j/pfO95p2NADuTOz6pxSpChN6rEDgT0nLmQL7w4=;
        b=AQ1kcgokkBRwi0PXtiN1XwpR5SNJvdipK8/2RGYDMkMLDCl7KNyFTsAQIJNNdYScBf
         rex8uEo5l3FkGyo8kyEsqqIQSkvssPwVtiaiv7nzqyiBqlWak4Ijh8oka4wb4z9FzdDm
         rqbiZMiYrlGJVM1PoixuxCJap4TVQvNc1ttHC9Bx8CXPwdJ8+6yF1sr0xL1zC7Xp52r5
         CWZ2lvbMWTF4HKTxIPcgj6Y7GCXA4sFiAn7+xoKd+QAxlrIWcvOewPo7yZO0DFVjdA6K
         S15fIoca1XxtujDn8xEyLTJsSHC0OVm6mWNF2cP7i3UonAPOiuU7gDR24LA7L8E8ngB1
         GVPg==
X-Gm-Message-State: AOAM530UB1AsOHCXujGpScskZlxFfbxXHqDtja/PBZHZPxUAHOR3jvYh
        fR8qdkQc3j/p1VMgLhvZFzQLzmvWDP9C6c6hrlt/CIf9J1LZitnNuDairJpfEWTO4pmPLp2Qi7k
        dq85S/9PH2tSGcSBB
X-Received: by 2002:a17:90b:351:: with SMTP id fh17mr1494245pjb.28.1644381557330;
        Tue, 08 Feb 2022 20:39:17 -0800 (PST)
X-Google-Smtp-Source: ABdhPJyMXR6X2J1CaA2tRB0gLeu4mXToGnDAqW9oiqkiF+2CcatJHXLt3XWFCBXLi/0YasKKk8UpiQ==
X-Received: by 2002:a17:90b:351:: with SMTP id fh17mr1494231pjb.28.1644381557019;
        Tue, 08 Feb 2022 20:39:17 -0800 (PST)
Received: from [10.72.13.141] ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id j10sm17444059pfu.93.2022.02.08.20.39.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 08 Feb 2022 20:39:16 -0800 (PST)
Message-ID: <5ac96035-2448-2a25-5bc9-677a7eb0a271@redhat.com>
Date:   Wed, 9 Feb 2022 12:39:10 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.5.1
Subject: Re: [RFC PATCH 2/5] driver/net/tun: Added features for USO.
Content-Language: en-US
To:     Andrew Melnychenko <andrew@daynix.com>, davem@davemloft.net,
        kuba@kernel.org, mst@redhat.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org
Cc:     yuri.benditovich@daynix.com, yan@daynix.com
References: <20220125084702.3636253-1-andrew@daynix.com>
 <20220125084702.3636253-3-andrew@daynix.com>
From:   Jason Wang <jasowang@redhat.com>
In-Reply-To: <20220125084702.3636253-3-andrew@daynix.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


在 2022/1/25 下午4:46, Andrew Melnychenko 写道:
> Added support for USO4 and USO6, also added code for new ioctl TUNGETSUPPORTEDOFFLOADS.
> For now, to "enable" USO, it's required to set both USO4 and USO6 simultaneously.
> USO enables NETIF_F_GSO_UDP_L4.
>
> Signed-off-by: Andrew Melnychenko <andrew@daynix.com>
> ---
>   drivers/net/tap.c | 18 ++++++++++++++++--
>   drivers/net/tun.c | 15 ++++++++++++++-
>   2 files changed, 30 insertions(+), 3 deletions(-)
>
> diff --git a/drivers/net/tap.c b/drivers/net/tap.c
> index 8e3a28ba6b28..82d742ba78b1 100644
> --- a/drivers/net/tap.c
> +++ b/drivers/net/tap.c
> @@ -940,6 +940,10 @@ static int set_offload(struct tap_queue *q, unsigned long arg)
>   			if (arg & TUN_F_TSO6)
>   				feature_mask |= NETIF_F_TSO6;
>   		}
> +
> +		/* TODO: for now USO4 and USO6 should work simultaneously */
> +		if (arg & (TUN_F_USO4 | TUN_F_USO6) == (TUN_F_USO4 | TUN_F_USO6))
> +			features |= NETIF_F_GSO_UDP_L4;


If kernel doesn't want to split the GSO_UDP features, I wonder how much 
value to keep separated features for TUN and virtio.

Thanks


>   	}
>   
>   	/* tun/tap driver inverts the usage for TSO offloads, where
> @@ -950,7 +954,8 @@ static int set_offload(struct tap_queue *q, unsigned long arg)
>   	 * When user space turns off TSO, we turn off GSO/LRO so that
>   	 * user-space will not receive TSO frames.
>   	 */
> -	if (feature_mask & (NETIF_F_TSO | NETIF_F_TSO6))
> +	if (feature_mask & (NETIF_F_TSO | NETIF_F_TSO6) ||
> +	    feature_mask & (TUN_F_USO4 | TUN_F_USO6) == (TUN_F_USO4 | TUN_F_USO6))
>   		features |= RX_OFFLOADS;
>   	else
>   		features &= ~RX_OFFLOADS;
> @@ -979,6 +984,7 @@ static long tap_ioctl(struct file *file, unsigned int cmd,
>   	unsigned short u;
>   	int __user *sp = argp;
>   	struct sockaddr sa;
> +	unsigned int supported_offloads;
>   	int s;
>   	int ret;
>   
> @@ -1074,7 +1080,8 @@ static long tap_ioctl(struct file *file, unsigned int cmd,
>   	case TUNSETOFFLOAD:
>   		/* let the user check for future flags */
>   		if (arg & ~(TUN_F_CSUM | TUN_F_TSO4 | TUN_F_TSO6 |
> -			    TUN_F_TSO_ECN | TUN_F_UFO))
> +			    TUN_F_TSO_ECN | TUN_F_UFO |
> +			    TUN_F_USO4 | TUN_F_USO6))
>   			return -EINVAL;
>   
>   		rtnl_lock();
> @@ -1082,6 +1089,13 @@ static long tap_ioctl(struct file *file, unsigned int cmd,
>   		rtnl_unlock();
>   		return ret;
>   
> +	case TUNGETSUPPORTEDOFFLOADS:
> +		supported_offloads = TUN_F_CSUM | TUN_F_TSO4 | TUN_F_TSO6 |
> +						TUN_F_TSO_ECN | TUN_F_UFO | TUN_F_USO4 | TUN_F_USO6;
> +		if (copy_to_user(&arg, &supported_offloads, sizeof(supported_offloads)))
> +			return -EFAULT;
> +		return 0;
> +
>   	case SIOCGIFHWADDR:
>   		rtnl_lock();
>   		tap = tap_get_tap_dev(q);
> diff --git a/drivers/net/tun.c b/drivers/net/tun.c
> index fed85447701a..4f2105d1e6f1 100644
> --- a/drivers/net/tun.c
> +++ b/drivers/net/tun.c
> @@ -185,7 +185,7 @@ struct tun_struct {
>   	struct net_device	*dev;
>   	netdev_features_t	set_features;
>   #define TUN_USER_FEATURES (NETIF_F_HW_CSUM|NETIF_F_TSO_ECN|NETIF_F_TSO| \
> -			  NETIF_F_TSO6)
> +			  NETIF_F_TSO6 | NETIF_F_GSO_UDP_L4)
>   
>   	int			align;
>   	int			vnet_hdr_sz;
> @@ -2821,6 +2821,12 @@ static int set_offload(struct tun_struct *tun, unsigned long arg)
>   		}
>   
>   		arg &= ~TUN_F_UFO;
> +
> +		/* TODO: for now USO4 and USO6 should work simultaneously */
> +		if (arg & TUN_F_USO4 && arg & TUN_F_USO6) {
> +			features |= NETIF_F_GSO_UDP_L4;
> +			arg &= ~(TUN_F_USO4 | TUN_F_USO6);
> +		}
>   	}
>   
>   	/* This gives the user a way to test for new features in future by
> @@ -2991,6 +2997,7 @@ static long __tun_chr_ioctl(struct file *file, unsigned int cmd,
>   	int sndbuf;
>   	int vnet_hdr_sz;
>   	int le;
> +	unsigned int supported_offloads;
>   	int ret;
>   	bool do_notify = false;
>   
> @@ -3154,6 +3161,12 @@ static long __tun_chr_ioctl(struct file *file, unsigned int cmd,
>   	case TUNSETOFFLOAD:
>   		ret = set_offload(tun, arg);
>   		break;
> +	case TUNGETSUPPORTEDOFFLOADS:
> +		supported_offloads = TUN_F_CSUM | TUN_F_TSO4 | TUN_F_TSO6 |
> +				TUN_F_TSO_ECN | TUN_F_UFO | TUN_F_USO4 | TUN_F_USO6;
> +		if (copy_to_user(&arg, &supported_offloads, sizeof(supported_offloads)))
> +			ret = -EFAULT;
> +		break;
>   
>   	case TUNSETTXFILTER:
>   		/* Can be set only for TAPs */

