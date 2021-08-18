Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 66C2B3F00E7
	for <lists+netdev@lfdr.de>; Wed, 18 Aug 2021 11:49:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232280AbhHRJuI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Aug 2021 05:50:08 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:60495 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232260AbhHRJuF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Aug 2021 05:50:05 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1629280171;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=HvcSEnORdg0rggRp6WxuZOJU65VaYwpcnMsvEkyDCJQ=;
        b=BDLW0Zy35+gIVndksOSDct/KtI7MQYeMYc89qSqHxb58vWejHciB5HTkOWoE0AeGYAQ+F7
        4Ljtt4oX9huk6WV9MDBZ3jdgdYaD2lR/ldBa/6B+9+xvhF6Kfg/980LenBW+SlwDw7ru/D
        EOWLdRsDhMe6gb69NsjeR477lI92Nkk=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-395-U9eewldkOcScfcBQjs4Iiw-1; Wed, 18 Aug 2021 05:49:29 -0400
X-MC-Unique: U9eewldkOcScfcBQjs4Iiw-1
Received: by mail-wr1-f69.google.com with SMTP id k15-20020a5d628f0000b029015501bab520so405438wru.16
        for <netdev@vger.kernel.org>; Wed, 18 Aug 2021 02:49:29 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:cc:subject:to:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=HvcSEnORdg0rggRp6WxuZOJU65VaYwpcnMsvEkyDCJQ=;
        b=TKIDRxnkkm1T2FciiDNF1TDTxriFb1SRhKmQ0Pst91VTDRilJmX8tY7sfqSJCItR6j
         BdaKL6rsg66RIEKwtFk5CGCH6duxQkGufHoXKaPQClIp+qHP7hoph3PRQLE9pv2oi22+
         LzZy+g4e/jX518wQru7q29b3dpAhEdQbprdF3hD/C0ROGIf9k3K6F4vWa73VwslKhyV/
         xZdwwLVzcvu3cWatUsZISB7LS96XwbQE/8uR8mrPWqB0ZshL3xOY5VXe6ac7spys/VYk
         5lgRhsCXSjP/FiU525o2lOu2wHwG/DGLE24jqPttjjSfFRNw2k396kI7mXKK28F1MR2f
         +IpA==
X-Gm-Message-State: AOAM532zP2pEKveuSf1Q+mZdQAftBCkMC3YGbbHAILbcrMivTsWzADQr
        sXwcatEhJ1r3C+TF9gIA5hEGMWiQu/FjK0H7ZlJWHfLlqbtqxcw40wd9HAHA+Kdig9JspLzhGbc
        6CqzrQWGmm8GGuzGg
X-Received: by 2002:a7b:cb02:: with SMTP id u2mr7496210wmj.103.1629280168601;
        Wed, 18 Aug 2021 02:49:28 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyofXpRJKhkep0m9OkVH9UnpUv5Dqh6G0c+2TULLuqBeGVu3+SnILWTvBPsQllJ3RbZHSfpkQ==
X-Received: by 2002:a7b:cb02:: with SMTP id u2mr7496180wmj.103.1629280168354;
        Wed, 18 Aug 2021 02:49:28 -0700 (PDT)
Received: from [192.168.42.238] (3-14-107-185.static.kviknet.dk. [185.107.14.3])
        by smtp.gmail.com with ESMTPSA id d8sm5373020wrx.12.2021.08.18.02.49.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 18 Aug 2021 02:49:27 -0700 (PDT)
From:   Jesper Dangaard Brouer <jbrouer@redhat.com>
X-Google-Original-From: Jesper Dangaard Brouer <brouer@redhat.com>
Cc:     brouer@redhat.com
Subject: Re: [RFC bpf-next 2/5] libbpf: SO_TXTIME support in AF_XDP
To:     Kishen Maloor <kishen.maloor@intel.com>, bpf@vger.kernel.org,
        netdev@vger.kernel.org, hawk@kernel.org, magnus.karlsson@intel.com,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Jithu Joseph <jithu.joseph@intel.com>
References: <20210803171006.13915-1-kishen.maloor@intel.com>
 <20210803171006.13915-3-kishen.maloor@intel.com>
Message-ID: <31fb6a84-562e-a41d-0614-061e1f475db3@redhat.com>
Date:   Wed, 18 Aug 2021 11:49:27 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210803171006.13915-3-kishen.maloor@intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 03/08/2021 19.10, Kishen Maloor wrote:
> This change adds userspace support for SO_TXTIME in AF_XDP
> to include a specific TXTIME (aka "Launch Time")
> with XDP frames issued from userspace XDP applications.
> 
> The userspace API has been expanded with two helper functons:
> 
> - int xsk_socket__enable_so_txtime(struct xsk_socket *xsk, bool enable)
>     Sets the SO_TXTIME option on the AF_XDP socket (using setsockopt()).
> 
> - void xsk_umem__set_md_txtime(void *umem_area, __u64 chunkAddr,
>                                 __s64 txtime)
>     Packages the application supplied TXTIME into struct xdp_user_tx_metadata:
>     struct xdp_user_tx_metadata {

Struct name is important and becomes UAPI. I'm not 100% convinced this 
is a good name.

For BPF programs libbpf can at load-time lookup the 'btf_id' via:

   btf_id = bpf_core_type_id_kernel(struct xdp_user_tx_metadata);

Example see[1]
  [1] https://github.com/xdp-project/bpf-examples/commit/2390b4b11079

I know this is AF_XDP userspace, but I hope Andrii can help guide us 
howto expose the bpf_core_type_id_kernel() API via libbpf, to be used by 
the AF_XDP userspace program.


>          __u64 timestamp;
>          __u32 md_valid;
>          __u32 btf_id;
>     };

I assume this struct is intended to be BTF "described".

Struct member *names* are very important for BTF. (E.g. see how 
'spinlock' have special meaning and is matched internally by kernel).

The member name 'timestamp' seems too generic.  This is a very specific 
'LaunchTime' feature, which could be reflected in the name.

Later it looks like you are encoding the "type" in md_valid, which I 
guess it is needed as timestamps can have different "types".
E.g. some of the clockid_t types from clock_gettime(2):
  CLOCK_REALTIME
  CLOCK_TAI
  CLOCK_MONOTONIC
  CLOCK_BOOTTIME

Which of these timestamp does XDP_METADATA_USER_TX_TIMESTAMP represent?
Or what timestamp type is the expected one?

In principle we could name the member 'Launch_Time_CLOCK_TAI' to encoded 
the clockid_t type in the name, but I think that would be too much (and 
require too advanced BTF helpers to extract type, having a clock_type 
member is easier to understand/consume from C).


>     and stores it in the XDP metadata area, which precedes the XDP frame.
> 
> Signed-off-by: Kishen Maloor <kishen.maloor@intel.com>
> ---
>   tools/include/uapi/linux/if_xdp.h     |  2 ++
>   tools/include/uapi/linux/xdp_md_std.h | 14 ++++++++++++++
>   tools/lib/bpf/xsk.h                   | 27 ++++++++++++++++++++++++++-
>   3 files changed, 42 insertions(+), 1 deletion(-)
>   create mode 100644 tools/include/uapi/linux/xdp_md_std.h
> 
> diff --git a/tools/include/uapi/linux/if_xdp.h b/tools/include/uapi/linux/if_xdp.h
> index a78a8096f4ce..31f81f82ed86 100644
> --- a/tools/include/uapi/linux/if_xdp.h
> +++ b/tools/include/uapi/linux/if_xdp.h
> @@ -106,6 +106,8 @@ struct xdp_desc {
>   	__u32 options;
>   };
>   
> +#define XDP_DESC_OPTION_METADATA (1 << 0)
> +
>   /* UMEM descriptor is __u64 */
>   
>   #endif /* _LINUX_IF_XDP_H */
> diff --git a/tools/include/uapi/linux/xdp_md_std.h b/tools/include/uapi/linux/xdp_md_std.h
> new file mode 100644
> index 000000000000..f00996a61639
> --- /dev/null
> +++ b/tools/include/uapi/linux/xdp_md_std.h
> @@ -0,0 +1,14 @@
> +#ifndef _UAPI_LINUX_XDP_MD_STD_H
> +#define _UAPI_LINUX_XDP_MD_STD_H
> +
> +#include <linux/types.h>
> +
> +#define XDP_METADATA_USER_TX_TIMESTAMP 0x1
> +
> +struct xdp_user_tx_metadata {
> +	__u64 timestamp;
> +	__u32 md_valid;
> +	__u32 btf_id;
> +};
> +
> +#endif /* _UAPI_LINUX_XDP_MD_STD_H */
> diff --git a/tools/lib/bpf/xsk.h b/tools/lib/bpf/xsk.h
> index 01c12dca9c10..1b52ffe1c9a3 100644
> --- a/tools/lib/bpf/xsk.h
> +++ b/tools/lib/bpf/xsk.h
> @@ -16,7 +16,8 @@
>   #include <stdint.h>
>   #include <stdbool.h>
>   #include <linux/if_xdp.h>
> -
> +#include <linux/xdp_md_std.h>
> +#include <errno.h>
>   #include "libbpf.h"
>   
>   #ifdef __cplusplus
> @@ -248,6 +249,30 @@ static inline __u64 xsk_umem__add_offset_to_addr(__u64 addr)
>   LIBBPF_API int xsk_umem__fd(const struct xsk_umem *umem);
>   LIBBPF_API int xsk_socket__fd(const struct xsk_socket *xsk);
>   
> +/* Helpers for SO_TXTIME */
> +
> +static inline void xsk_umem__set_md_txtime(void *umem_area, __u64 addr, __s64 txtime)
> +{
> +	struct xdp_user_tx_metadata *md;
> +
> +	md = (struct xdp_user_tx_metadata *)&((char *)umem_area)[addr];
> +
> +	md->timestamp = txtime;
> +	md->md_valid |= XDP_METADATA_USER_TX_TIMESTAMP;

Is this encoding the "type" of the timestamp?

I don't see the btf_id being updated.  Does that happen in another patch?

As I note above we are current;y lacking an libbpf equivalent 
bpf_core_type_id_kernel() lookup function in userspace.

> +}
> +
> +static inline int xsk_socket__enable_so_txtime(struct xsk_socket *xsk, bool enable)
> +{
> +	unsigned int val = (enable) ? 1 : 0;
> +	int err;
> +
> +	err = setsockopt(xsk_socket__fd(xsk), SOL_XDP, SO_TXTIME, &val, sizeof(val));
> +
> +	if (err)
> +		return -errno;
> +	return 0;
> +}
> +
>   #define XSK_RING_CONS__DEFAULT_NUM_DESCS      2048
>   #define XSK_RING_PROD__DEFAULT_NUM_DESCS      2048
>   #define XSK_UMEM__DEFAULT_FRAME_SHIFT    12 /* 4096 bytes */
> 

