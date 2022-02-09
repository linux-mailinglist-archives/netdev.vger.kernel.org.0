Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1859A4AE8D1
	for <lists+netdev@lfdr.de>; Wed,  9 Feb 2022 06:13:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233236AbiBIFGP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Feb 2022 00:06:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39796 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377724AbiBIEcE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Feb 2022 23:32:04 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id CF169C0612BD
        for <netdev@vger.kernel.org>; Tue,  8 Feb 2022 20:26:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1644380765;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=8mY8elVfyQglRlLXkjN7Nh6smhNHX9r1QRGNGZo7nas=;
        b=jH+MmTLgXpN4posvgRydc5fVFKJsW/z/+L3jTaENMG3FyemXVRMMhOG9J02lbGIUHF9tUO
        R0F9hOcv1xe35eyTZ+5vv+LvzHhxRoPPqU6A5VP4OnSRusXqvevOyum4YDpOTz5hIrZmkP
        1LkjE432qd0IaX/joKsdc2T5O7Rt/tw=
Received: from mail-pj1-f71.google.com (mail-pj1-f71.google.com
 [209.85.216.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-354-9eghzDWLNmGXMiByTrqw1w-1; Tue, 08 Feb 2022 23:26:03 -0500
X-MC-Unique: 9eghzDWLNmGXMiByTrqw1w-1
Received: by mail-pj1-f71.google.com with SMTP id mz22-20020a17090b379600b001b863f7a846so888298pjb.9
        for <netdev@vger.kernel.org>; Tue, 08 Feb 2022 20:26:03 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=8mY8elVfyQglRlLXkjN7Nh6smhNHX9r1QRGNGZo7nas=;
        b=b6kEtxTAMe9FUo+EPysbUrHgyjmXVqlP3kf2+owZFzrRn4Bfshw+cp8Xj3sVEeOEGp
         QlC7SH4LFxwaMnvCO7dvVyIGWcnw30zv90S2RsA5cwDIH7DqonFvTihuLWa/pWMmTZe0
         qjDfONd5YIzzFG8fNerhmNVkflbVISU7ArSpD18Gs8ml95uTLKeNTIP5NrVY+NBu+WYG
         UF7eEjCJ7hH+EbJDKlPc2p7dt8DmcjKznpYqg7IWAyYUF9vnz529d/kLxZ+YXVHrUms8
         4mmbYzQspujrYuYrsuiuk6b9ulDrgXUNpZaFJIftL7OqzNaSuYnHaHG9FUlX5Gy5Lymr
         SKHg==
X-Gm-Message-State: AOAM530Kf5j6/VX3ebtTpnOyz+wNHFXI8i4VvuW3tw55nDAZJY/MDRmn
        sWyV12Rr+epS8mi4Ah/RwmhhMKCz23Y447LRi+DJ7AEwl7BKq2pIlk2X5nDGlvhXdPVYGsy49Ej
        P+Rc3DPBRP6FzBjEV
X-Received: by 2002:a17:902:d4d2:: with SMTP id o18mr689053plg.70.1644380762288;
        Tue, 08 Feb 2022 20:26:02 -0800 (PST)
X-Google-Smtp-Source: ABdhPJykaFv2k/rU0QWZ6U8v2dqzYGXw3Od1HYD//YNB9h1Dzi13vXmiZ2WWJpeEOkwfNhTZU6a1Xw==
X-Received: by 2002:a17:902:d4d2:: with SMTP id o18mr689040plg.70.1644380761987;
        Tue, 08 Feb 2022 20:26:01 -0800 (PST)
Received: from [10.72.13.141] ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id z15sm10137088pfh.82.2022.02.08.20.25.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 08 Feb 2022 20:26:01 -0800 (PST)
Message-ID: <06a90de0-57ae-9315-dc2c-03cc74b4ae0c@redhat.com>
Date:   Wed, 9 Feb 2022 12:25:54 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.5.1
Subject: Re: [RFC PATCH 1/5] uapi/linux/if_tun.h: Added new ioctl for tun/tap.
Content-Language: en-US
To:     Andrew Melnychenko <andrew@daynix.com>, davem@davemloft.net,
        kuba@kernel.org, mst@redhat.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org
Cc:     yuri.benditovich@daynix.com, yan@daynix.com
References: <20220125084702.3636253-1-andrew@daynix.com>
 <20220125084702.3636253-2-andrew@daynix.com>
From:   Jason Wang <jasowang@redhat.com>
In-Reply-To: <20220125084702.3636253-2-andrew@daynix.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


在 2022/1/25 下午4:46, Andrew Melnychenko 写道:
> Added TUNGETSUPPORTEDOFFLOADS that should allow
> to get bits of supported offloads.


So we don't use dedicated ioctls in the past, instead, we just probing 
by checking the return value of TUNSETOFFLOADS.

E.g qemu has the following codes:

int tap_probe_has_ufo(int fd)
{
     unsigned offload;

     offload = TUN_F_CSUM | TUN_F_UFO;

     if (ioctl(fd, TUNSETOFFLOAD, offload) < 0)
         return 0;

     return 1;
}

Any reason we can't keep using that?

Thanks


> Added 2 additional offlloads for USO(IPv4 & IPv6).
> Separate offloads are required for Windows VM guests,
> g.e. Windows may set USO rx only for IPv4.
>
> Signed-off-by: Andrew Melnychenko <andrew@daynix.com>
> ---
>   include/uapi/linux/if_tun.h | 3 +++
>   1 file changed, 3 insertions(+)
>
> diff --git a/include/uapi/linux/if_tun.h b/include/uapi/linux/if_tun.h
> index 454ae31b93c7..07680fae6e18 100644
> --- a/include/uapi/linux/if_tun.h
> +++ b/include/uapi/linux/if_tun.h
> @@ -61,6 +61,7 @@
>   #define TUNSETFILTEREBPF _IOR('T', 225, int)
>   #define TUNSETCARRIER _IOW('T', 226, int)
>   #define TUNGETDEVNETNS _IO('T', 227)
> +#define TUNGETSUPPORTEDOFFLOADS _IOR('T', 228, unsigned int)
>   
>   /* TUNSETIFF ifr flags */
>   #define IFF_TUN		0x0001
> @@ -88,6 +89,8 @@
>   #define TUN_F_TSO6	0x04	/* I can handle TSO for IPv6 packets */
>   #define TUN_F_TSO_ECN	0x08	/* I can handle TSO with ECN bits. */
>   #define TUN_F_UFO	0x10	/* I can handle UFO packets */
> +#define TUN_F_USO4	0x20	/* I can handle USO for IPv4 packets */
> +#define TUN_F_USO6	0x40	/* I can handle USO for IPv6 packets */
>   
>   /* Protocol info prepended to the packets (when IFF_NO_PI is not set) */
>   #define TUN_PKT_STRIP	0x0001

