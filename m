Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3120B10E29F
	for <lists+netdev@lfdr.de>; Sun,  1 Dec 2019 17:38:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727200AbfLAQf7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 1 Dec 2019 11:35:59 -0500
Received: from mail-il1-f196.google.com ([209.85.166.196]:36697 "EHLO
        mail-il1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726393AbfLAQf7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 1 Dec 2019 11:35:59 -0500
Received: by mail-il1-f196.google.com with SMTP id b15so10940227iln.3;
        Sun, 01 Dec 2019 08:35:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=EmKXPT8/zzRPMHZdVznWwaEqUYddRfodakHAFbk74gY=;
        b=jBJCNYV7E9qH9/FnvkjHwjWx5oRkv2t9fLyI8atyKOxXUumjx7wHBM38zb9ReMx8U2
         USGKsR3ENN8rxtghmGCxxtIRqixfCTbjiMV1l+u9XQGQf2qtl7u+K4JZbssMjHKR6/pB
         NfGSe7cVzV1UBiPaiCIj63W4Jw1gaICoIKwjRL3BUCSlltKdkkbRrtfELlEJk2mqkNuP
         fxc1ghZ8tyyEkNXnuJWYloKCmZ0KDKEelCKvtbDB/e7cehbFZBxCP3G5H++EUS8PowYP
         MzZeVozXr8EC+YomO5nhX3fcxzCp+Cu/S5ss9+Hx33yNMmcU5NCo2GhTYsn+MnvSAaUw
         LEcg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=EmKXPT8/zzRPMHZdVznWwaEqUYddRfodakHAFbk74gY=;
        b=jcdlYxcmZ09qxlVLFXXhPY5UbIhKqjYCI2DYad6iA2NVy7oHSUrh4JBfzgA5oRFdiM
         qKPx0dWfFiRHanmAVShmlpPqVya0wk+rEmOvabIfQgCS6Zgxmu0dP7eEGbUqdPGI+6e1
         uCYOvfr6zQAGZyGTeo46YU4Y3G0wKJnP/bEAdjEB9KFG77BYO79VY8BI83g6TkOcdsBJ
         5ZHu5aVTJm8mL7bqykYgLxv/Ds18J1UrJilorAM6ErX+Ky60FTicmIrKnMnwg0ICCtoG
         2QOEOLz+TSqvDJGWsZabX0DXhzRyNHMkQAkWW7grI5eJc+DP6TM1RBo9BhB+VgXwj3il
         cylA==
X-Gm-Message-State: APjAAAXLmpiV0Xiof9IcbxMY5pyudI6O7u2rwjiMf2/YtUmLG8XUdHBq
        Co3D8PMZoSXIR/OvYf0RJ0CAh0cz
X-Google-Smtp-Source: APXvYqwIGHpUDCTLx6NUYZvnwluVz7GM9HsJnDjkWaPYpZXaxx4LTfh/9h7LO4SsISF4tXoychuGZw==
X-Received: by 2002:a92:3b19:: with SMTP id i25mr16713300ila.85.1575218158458;
        Sun, 01 Dec 2019 08:35:58 -0800 (PST)
Received: from dahern-DO-MB.local ([2601:282:800:fd80:fd6b:fde:b20f:61ed])
        by smtp.googlemail.com with ESMTPSA id e73sm256972iof.63.2019.12.01.08.35.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 01 Dec 2019 08:35:57 -0800 (PST)
Subject: Re: [RFC net-next 07/18] tun: set offloaded xdp program
To:     Prashant Bhole <prashantbhole.linux@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        "Michael S . Tsirkin" <mst@redhat.com>
Cc:     Jason Wang <jasowang@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>, netdev@vger.kernel.org,
        qemu-devel@nongnu.org, kvm@vger.kernel.org
References: <20191126100744.5083-1-prashantbhole.linux@gmail.com>
 <20191126100744.5083-8-prashantbhole.linux@gmail.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <e0631f09-28ce-7d13-e58c-87a700a39353@gmail.com>
Date:   Sun, 1 Dec 2019 09:35:56 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:68.0)
 Gecko/20100101 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <20191126100744.5083-8-prashantbhole.linux@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/26/19 4:07 AM, Prashant Bhole wrote:
> From: Jason Wang <jasowang@redhat.com>
> 
> This patch introduces an ioctl way to set an offloaded XDP program
> to tun driver. This ioctl will be used by qemu to offload XDP program
> from virtio_net in the guest.
> 
> Signed-off-by: Jason Wang <jasowang@redhat.com>
> Signed-off-by: Prashant Bhole <prashantbhole.linux@gmail.com>
> ---
>  drivers/net/tun.c           | 19 ++++++++++++++-----
>  include/uapi/linux/if_tun.h |  1 +
>  2 files changed, 15 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/net/tun.c b/drivers/net/tun.c
> index d078b4659897..ecb49101b0b5 100644
> --- a/drivers/net/tun.c
> +++ b/drivers/net/tun.c
> @@ -241,6 +241,7 @@ struct tun_struct {
>  	struct bpf_prog __rcu *xdp_prog;
>  	struct tun_prog __rcu *steering_prog;
>  	struct tun_prog __rcu *filter_prog;
> +	struct tun_prog __rcu *offloaded_xdp_prog;

I have been looking into running XDP pograms in the TX path of a tap
device [1] where the program is installed and managed by a process in
the host. The code paths are the same as what you are doing with XDP
offload, so how about calling this xdp_prog_tx?

[1]
https://github.com/dsahern/linux/commit/f2303d05187c8a604cdb70b288338e9b1d1b0db6
