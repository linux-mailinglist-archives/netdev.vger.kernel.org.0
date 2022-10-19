Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 701186044C5
	for <lists+netdev@lfdr.de>; Wed, 19 Oct 2022 14:14:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232477AbiJSMOf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Oct 2022 08:14:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47316 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233088AbiJSMOO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Oct 2022 08:14:14 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CEE4246203
        for <netdev@vger.kernel.org>; Wed, 19 Oct 2022 04:50:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1666180184;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=HfKaXAM67nrWxBo+o2Le2Vo+rZyeTr5pYYlDrowdGww=;
        b=CccAIOVsrKqEtSI6i8PdRM+GTP1xYGyPYX6Hz/PMAfHJPgRwQNq+9hxgRkU+THcJKAOWV2
        7SdOtJhWw7hDi7e39bBJNR0A98YYWktRdjUBn2Imx/kpOF1NnX2eZQgTk6+UutltAcAMon
        ScYukKvXHxcJywOMn1XpR24fDuknR9Y=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-618-Z01E0sNSP8G3_FkxIsAEEg-1; Wed, 19 Oct 2022 07:49:42 -0400
X-MC-Unique: Z01E0sNSP8G3_FkxIsAEEg-1
Received: by mail-wm1-f72.google.com with SMTP id az11-20020a05600c600b00b003c6e3d4d5b1so9564412wmb.7
        for <netdev@vger.kernel.org>; Wed, 19 Oct 2022 04:49:42 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=HfKaXAM67nrWxBo+o2Le2Vo+rZyeTr5pYYlDrowdGww=;
        b=fc7rfuQcIaHGsvi+LUFB07s3Xl3SrzcEJoohDRKpg5N/pkvqgVQ1i+nTVw080rZ0nd
         tf7FhvqtcKTRJZcd2t/UaoW+/XuPhUJnYIXMgT6n/J/UcV/krOIFZJpaD3OWsiPf2kOd
         Vifaq4ZYsDpoVAUqJmBGmQVWyeFPz1VczEoDJbg0qHTauthhIuom1WT1/mkylk4FiBEW
         FxY28mIX/LtoRW6W1VrgrCitMH2Ab9JOhSHngrLC69TPSKhwT4FLP6yvzEC+Lq26y5vl
         +Zb7jMdH53yz/UO3zwBcGxijj/3NfCLLB6EgjBn0H0NM0prm98/OzRMoByNVALd2dr36
         EA0w==
X-Gm-Message-State: ACrzQf3AUwcLNXuAYN64jn5IZVr30Tl5exl+Lsj+UIdlYOiLrVU7Ry4l
        0FXxt04re5nK+p7EwJY06r8H0gJwWXMwUFElOBG72B4z4ogI7dHGqZT0wfI6sSrl54zlj8xftXT
        86w+0Qsvg1XkPtopY
X-Received: by 2002:a5d:598d:0:b0:231:2304:3a5a with SMTP id n13-20020a5d598d000000b0023123043a5amr4931480wri.434.1666180181692;
        Wed, 19 Oct 2022 04:49:41 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM4naKoI+49panSp4JLVPLoygdy3bA51aQUk0/netD4C5WEddCLKNJIoIp5COV9GgG6ccsYJeA==
X-Received: by 2002:a5d:598d:0:b0:231:2304:3a5a with SMTP id n13-20020a5d598d000000b0023123043a5amr4931455wri.434.1666180181415;
        Wed, 19 Oct 2022 04:49:41 -0700 (PDT)
Received: from redhat.com ([2.54.191.184])
        by smtp.gmail.com with ESMTPSA id z10-20020a05600c0a0a00b003a2f2bb72d5sm30867129wmp.45.2022.10.19.04.49.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Oct 2022 04:49:40 -0700 (PDT)
Date:   Wed, 19 Oct 2022 07:49:35 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Yury Norov <yury.norov@gmail.com>
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        Borislav Petkov <bp@alien8.de>,
        Eric Dumazet <edumazet@google.com>,
        Guo Ren <guoren@linux.alibaba.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Kuniyuki Iwashima <kuniyu@amazon.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Menglong Dong <imagedong@tencent.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Petr Machata <petrm@nvidia.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        andriy.shevchenko@linux.intel.com, caraitto@google.com,
        jonolson@google.com, willemb@google.com,
        "David S .Miller" <davem@davemloft.net>,
        Andrew Jones <ajones@ventanamicro.com>,
        amritha.nambiar@intel.com, linux@rasmusvillemoes.dk
Subject: Re: [PATCH] Revert "net: fix cpu_max_bits_warn() usage in
 netif_attrmask_next{,_and}"
Message-ID: <20221019074843-mutt-send-email-mst@kernel.org>
References: <20221017030947.1295426-1-yury.norov@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221017030947.1295426-1-yury.norov@gmail.com>
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Oct 16, 2022 at 08:09:47PM -0700, Yury Norov wrote:
> This reverts commit 854701ba4c39afae2362ba19a580c461cb183e4f.
> 
> The reverted commit makes netif_attr_test_online() network subsystems
> generating warnings, and it breaks syzkaller testing.
> 
> https://syzkaller.appspot.com/bug?extid=9abe5ecc348676215427
> 
> Signed-off-by: Yury Norov <yury.norov@gmail.com>

Fixes: 854701ba4c39 ("net: fix cpu_max_bits_warn() usage in netif_attrmask_next{,_and}")
Acked-by: Michael S. Tsirkin <mst@redhat.com>

> ---
>  include/linux/netdevice.h | 10 ++++++----
>  1 file changed, 6 insertions(+), 4 deletions(-)
> 
> diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
> index a36edb0ec199..eddf8ee270e7 100644
> --- a/include/linux/netdevice.h
> +++ b/include/linux/netdevice.h
> @@ -3663,8 +3663,9 @@ static inline bool netif_attr_test_online(unsigned long j,
>  static inline unsigned int netif_attrmask_next(int n, const unsigned long *srcp,
>  					       unsigned int nr_bits)
>  {
> -	/* n is a prior cpu */
> -	cpu_max_bits_warn(n + 1, nr_bits);
> +	/* -1 is a legal arg here. */
> +	if (n != -1)
> +		cpu_max_bits_warn(n, nr_bits);
>  
>  	if (srcp)
>  		return find_next_bit(srcp, nr_bits, n + 1);
> @@ -3685,8 +3686,9 @@ static inline int netif_attrmask_next_and(int n, const unsigned long *src1p,
>  					  const unsigned long *src2p,
>  					  unsigned int nr_bits)
>  {
> -	/* n is a prior cpu */
> -	cpu_max_bits_warn(n + 1, nr_bits);
> +	/* -1 is a legal arg here. */
> +	if (n != -1)
> +		cpu_max_bits_warn(n, nr_bits);
>  
>  	if (src1p && src2p)
>  		return find_next_and_bit(src1p, src2p, nr_bits, n + 1);
> -- 
> 2.34.1

