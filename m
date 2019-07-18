Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E191D6D5EF
	for <lists+netdev@lfdr.de>; Thu, 18 Jul 2019 22:44:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391043AbfGRUn6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Jul 2019 16:43:58 -0400
Received: from mail-pl1-f193.google.com ([209.85.214.193]:37861 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728028AbfGRUn6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Jul 2019 16:43:58 -0400
Received: by mail-pl1-f193.google.com with SMTP id b3so14472289plr.4;
        Thu, 18 Jul 2019 13:43:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=LYEXZ5N9rPpogmDAcWX6hwABOAs14BvUTBurxuuI1RY=;
        b=BB5hxWg3aJdp8hn8wlbXIAyYL+T1ONv8UiDdbsJUvl7cnmHGgeh5nSVKDpd46jefRI
         OAZIoClrZ8z9dTc6WxJdaQ4rWT3ohTqTRQJczOMuku0bdVSpyryYyMotUhrn4p0PQBj+
         OR98GFIWyCoC4Kczi7EBydUGPy/5ubdP8jOa3ag2Pf8sfx7rEek/WxS+FqCYM/AA5N9e
         ArqU/ejTPUkN6Rh0RED0SZ+WlXjw1vmtlhSPhH7Zv8qgs0t7kKg0+JTQjggbcoXYVWMx
         6s35qNer+Ore2H6OhHqlnk1EldBbqZvoLLNn9mrUmFVId8dHkUxkS3dPdtVUI+HAxWx+
         399w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=LYEXZ5N9rPpogmDAcWX6hwABOAs14BvUTBurxuuI1RY=;
        b=BO4iQ9I4No6FVOwh/ekA7U69sr4qL6pSZVeXoAOVeqWtE4qbijR2OomTaxqDgqHUPA
         qDMZMLJW0+WsKvRGpjr6bRiO49M/3m1k6y+3pxioOtOafLriX2EB4uego+TK4G8PStHF
         E9fHleoJEalK6d8Ljz6tBdjVBFWGcFTCgmbR6WUcY5A056PV/JVCtcYTSzJp18E8Pskf
         x3ShurETbfWHp257VeNrzEDHcfjFvMeEsPxrlt3X3g6Tg/NdpHtrLAb+3tABd0UmEBrC
         6rdz9JS91ftr4W875P4mffOUYcoASTcEfdscwl5fqQaNVCuOq1psCaMQhGTAOBrsY+xb
         Odqw==
X-Gm-Message-State: APjAAAVAC0ATpJU4KaiB6lFH9MuLLLuhaCaLyHq7bcs+EekNFt1GTfPp
        IFsjFxcg1BuiKDlsAl+J8dDflGsr
X-Google-Smtp-Source: APXvYqxdVxflYcy1YfwwID/ae0S15efGydHsA9phGsaHFyYJjkmzNOF6ylcR74wiPpsyQ+cpRdgDSw==
X-Received: by 2002:a17:902:b591:: with SMTP id a17mr50565034pls.96.1563482637275;
        Thu, 18 Jul 2019 13:43:57 -0700 (PDT)
Received: from ast-mbp ([2620:10d:c090:200::3:f9e9])
        by smtp.gmail.com with ESMTPSA id b68sm37017265pfb.149.2019.07.18.13.43.56
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 18 Jul 2019 13:43:56 -0700 (PDT)
Date:   Thu, 18 Jul 2019 13:43:54 -0700
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Ilya Leoshkevich <iii@linux.ibm.com>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org, ys114321@gmail.com,
        gor@linux.ibm.com, heiko.carstens@de.ibm.com, daniel@iogearbox.net
Subject: Re: [PATCH bpf v2] bpf: fix narrower loads on s390
Message-ID: <20190718204353.nkdsvvxybqt7vahk@ast-mbp>
References: <20190718150103.84837-1-iii@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190718150103.84837-1-iii@linux.ibm.com>
User-Agent: NeoMutt/20180223
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 18, 2019 at 05:01:03PM +0200, Ilya Leoshkevich wrote:
> The very first check in test_pkt_md_access is failing on s390, which
> happens because loading a part of a struct __sk_buff field produces
> an incorrect result.
> 
> The preprocessed code of the check is:
> 
> {
> 	__u8 tmp = *((volatile __u8 *)&skb->len +
> 		((sizeof(skb->len) - sizeof(__u8)) / sizeof(__u8)));
> 	if (tmp != ((*(volatile __u32 *)&skb->len) & 0xFF)) return 2;
> };
> 
> clang generates the following code for it:
> 
>       0:	71 21 00 03 00 00 00 00	r2 = *(u8 *)(r1 + 3)
>       1:	61 31 00 00 00 00 00 00	r3 = *(u32 *)(r1 + 0)
>       2:	57 30 00 00 00 00 00 ff	r3 &= 255
>       3:	5d 23 00 1d 00 00 00 00	if r2 != r3 goto +29 <LBB0_10>
> 
> Finally, verifier transforms it to:
> 
>   0: (61) r2 = *(u32 *)(r1 +104)
>   1: (bc) w2 = w2
>   2: (74) w2 >>= 24
>   3: (bc) w2 = w2
>   4: (54) w2 &= 255
>   5: (bc) w2 = w2
> 
> The problem is that when verifier emits the code to replace a partial
> load of a struct __sk_buff field (*(u8 *)(r1 + 3)) with a full load of
> struct sk_buff field (*(u32 *)(r1 + 104)), an optional shift and a
> bitwise AND, it assumes that the machine is little endian and
> incorrectly decides to use a shift.
> 
> Adjust shift count calculation to account for endianness.
> 
> Fixes: 31fd85816dbe ("bpf: permits narrower load from bpf program context fields")
> Signed-off-by: Ilya Leoshkevich <iii@linux.ibm.com>
> ---
>  include/linux/filter.h | 13 +++++++++++++
>  kernel/bpf/verifier.c  |  4 ++--
>  2 files changed, 15 insertions(+), 2 deletions(-)
> 
> diff --git a/include/linux/filter.h b/include/linux/filter.h
> index ff65d22cf336..4fe88e43f0fe 100644
> --- a/include/linux/filter.h
> +++ b/include/linux/filter.h
> @@ -24,6 +24,8 @@
>  
>  #include <net/sch_generic.h>
>  
> +#include <asm/byteorder.h>
> +

unnecessary empty line

>  #include <uapi/linux/filter.h>
>  #include <uapi/linux/bpf.h>
>  
> @@ -1216,4 +1218,15 @@ struct bpf_sockopt_kern {
>  	s32		retval;
>  };
>  
> +static inline u8 bpf_narrower_load_shift(u32 size_default, u32 size, u32 off)

please place this function right after bpf_ctx_narrow_access_ok()
and order arguments the same way as bpf_ctx_narrow_access_ok does.

> +{
> +	u8 load_off = off & (size_default - 1);
> +
> +#ifdef __LITTLE_ENDIAN
> +	return load_off * 8;
> +#else
> +	return (size_default - (load_off + size)) * 8;
> +#endif
> +}
> +
>  #endif /* __LINUX_FILTER_H__ */
> diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
> index 5900cbb966b1..48edc9c9a879 100644
> --- a/kernel/bpf/verifier.c
> +++ b/kernel/bpf/verifier.c
> @@ -8616,8 +8616,8 @@ static int convert_ctx_accesses(struct bpf_verifier_env *env)
>  		}
>  
>  		if (is_narrower_load && size < target_size) {
> -			u8 shift = (off & (size_default - 1)) * 8;
> -
> +			u8 shift = bpf_narrower_load_shift(size_default, size,
> +							   off);
>  			if (ctx_field_size <= 4) {
>  				if (shift)
>  					insn_buf[cnt++] = BPF_ALU32_IMM(BPF_RSH,
> -- 
> 2.21.0
> 
