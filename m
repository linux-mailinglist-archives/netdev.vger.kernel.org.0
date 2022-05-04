Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B3CBE51ACD4
	for <lists+netdev@lfdr.de>; Wed,  4 May 2022 20:29:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1376913AbiEDSdA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 May 2022 14:33:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57506 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1376932AbiEDScm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 May 2022 14:32:42 -0400
Received: from mail-ot1-f43.google.com (mail-ot1-f43.google.com [209.85.210.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C50E5AA43;
        Wed,  4 May 2022 11:09:11 -0700 (PDT)
Received: by mail-ot1-f43.google.com with SMTP id m6-20020a05683023a600b0060612720715so1395504ots.10;
        Wed, 04 May 2022 11:09:11 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=D+E9lNuRbHFdd170vr+MtjOcic+cq6LuKuOZKRSFmmQ=;
        b=hqu6R1IRae0VoX6RVScHw+Zzo1GjIz7JEVjL/qj/M5RsjpSzZPnxbWaJ2QRNj9pG/V
         GzcagHr+46Vvmokee05IR5m2irmd6EgL7Zj5NeOxB9mO4H+0VWs7t+QY6SdSEHLAFOQX
         7nlxFOlTSSaPyJczzOi0IByyUPBRQBxkBJureHxsnNNwZLVdOxVmsPv3XR9dms/Hhmdq
         Dpei6T4pf7hR9BSOp3RbmeuXVXYkTBZhjTdTpNg8Sjcc5Id2RNDvW92doze4AoQiouKc
         /p5ZsjI6uJj0BqaJNqAfTwSy3ZnrnJ6J4Wl3iDw286tyYbPdWZk0VQKlkpwQfXgmyYMV
         dCDg==
X-Gm-Message-State: AOAM531GBGiEJMipM7x6IPEegxYs2k8skR7Jmuzu2kokd0nLw2UfSWFh
        7VEkFE2UyuEFyw5s9SPLig==
X-Google-Smtp-Source: ABdhPJz7UxGCoN/1mtQLUptxPhW193aedSmrIFdTLYGH8vHQEwAOv7HLwELKhlP+txzkjgVxGZbMKA==
X-Received: by 2002:a05:6830:116:b0:606:3fb1:e89e with SMTP id i22-20020a056830011600b006063fb1e89emr2227922otp.310.1651687750783;
        Wed, 04 May 2022 11:09:10 -0700 (PDT)
Received: from robh.at.kernel.org (66-90-144-107.dyn.grandenetworks.net. [66.90.144.107])
        by smtp.gmail.com with ESMTPSA id d19-20020a4ad353000000b0035eb4e5a6bfsm6240803oos.21.2022.05.04.11.09.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 May 2022 11:09:10 -0700 (PDT)
Received: (nullmailer pid 1975953 invoked by uid 1000);
        Wed, 04 May 2022 18:09:09 -0000
Date:   Wed, 4 May 2022 13:09:09 -0500
From:   Rob Herring <robh@kernel.org>
To:     Kees Cook <keescook@chromium.org>
Cc:     "Gustavo A . R . Silva" <gustavoars@kernel.org>,
        Chris Zankel <chris@zankel.net>,
        Max Filippov <jcmvbkbc@gmail.com>,
        Frank Rowand <frowand.list@gmail.com>,
        Guenter Roeck <linux@roeck-us.net>,
        linux-xtensa@linux-xtensa.org, devicetree@vger.kernel.org,
        kunit-dev@googlegroups.com, linux-arm-kernel@lists.infradead.org,
        linux-bluetooth@vger.kernel.org, linux-hardening@vger.kernel.org,
        linux-hyperv@vger.kernel.org, linux-integrity@vger.kernel.org,
        linux-rdma@vger.kernel.org, linux-scsi@vger.kernel.org,
        linux-security-module@vger.kernel.org, linux-usb@vger.kernel.org,
        linux-wireless@vger.kernel.org, llvm@lists.linux.dev,
        netdev@vger.kernel.org, selinux@vger.kernel.org
Subject: Re: [PATCH 29/32] xtensa: Use mem_to_flex_dup() with struct property
Message-ID: <YnKbaXEUHyu+btOD@robh.at.kernel.org>
References: <20220504014440.3697851-1-keescook@chromium.org>
 <20220504014440.3697851-30-keescook@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220504014440.3697851-30-keescook@chromium.org>
X-Spam-Status: No, score=-1.2 required=5.0 tests=BAYES_00,
        FREEMAIL_ENVFROM_END_DIGIT,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H3,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Gmail won't send this, so I've trimmed the recipients...

On Tue, May 03, 2022 at 06:44:38PM -0700, Kees Cook wrote:
> As part of the work to perform bounds checking on all memcpy() uses,
> replace the open-coded a deserialization of bytes out of memory into a
> trailing flexible array by using a flex_array.h helper to perform the
> allocation, bounds checking, and copying.
> 
> Cc: Chris Zankel <chris@zankel.net>
> Cc: Max Filippov <jcmvbkbc@gmail.com>
> Cc: Rob Herring <robh+dt@kernel.org>
> Cc: Frank Rowand <frowand.list@gmail.com>
> Cc: Guenter Roeck <linux@roeck-us.net>
> Cc: linux-xtensa@linux-xtensa.org
> Cc: devicetree@vger.kernel.org
> Signed-off-by: Kees Cook <keescook@chromium.org>
> ---
>  arch/xtensa/platforms/xtfpga/setup.c | 9 +++------
>  include/linux/of.h                   | 3 ++-
>  2 files changed, 5 insertions(+), 7 deletions(-)
> 
> diff --git a/arch/xtensa/platforms/xtfpga/setup.c b/arch/xtensa/platforms/xtfpga/setup.c
> index 538e6748e85a..31c1fa4ba4ec 100644
> --- a/arch/xtensa/platforms/xtfpga/setup.c
> +++ b/arch/xtensa/platforms/xtfpga/setup.c
> @@ -102,7 +102,7 @@ CLK_OF_DECLARE(xtfpga_clk, "cdns,xtfpga-clock", xtfpga_clk_setup);
>  #define MAC_LEN 6
>  static void __init update_local_mac(struct device_node *node)
>  {
> -	struct property *newmac;
> +	struct property *newmac = NULL;
>  	const u8* macaddr;
>  	int prop_len;
>  
> @@ -110,19 +110,16 @@ static void __init update_local_mac(struct device_node *node)
>  	if (macaddr == NULL || prop_len != MAC_LEN)
>  		return;
>  
> -	newmac = kzalloc(sizeof(*newmac) + MAC_LEN, GFP_KERNEL);
> -	if (newmac == NULL)
> +	if (mem_to_flex_dup(&newmac, macaddr, MAC_LEN, GFP_KERNEL))
>  		return;
>  
> -	newmac->value = newmac + 1;
> -	newmac->length = MAC_LEN;
> +	newmac->value = newmac->contents;
>  	newmac->name = kstrdup("local-mac-address", GFP_KERNEL);
>  	if (newmac->name == NULL) {
>  		kfree(newmac);
>  		return;
>  	}
>  
> -	memcpy(newmac->value, macaddr, MAC_LEN);
>  	((u8*)newmac->value)[5] = (*(u32*)DIP_SWITCHES_VADDR) & 0x3f;
>  	of_update_property(node, newmac);
>  }
> diff --git a/include/linux/of.h b/include/linux/of.h
> index 17741eee0ca4..efb0f419fd1f 100644
> --- a/include/linux/of.h
> +++ b/include/linux/of.h
> @@ -30,7 +30,7 @@ typedef u32 ihandle;
>  
>  struct property {
>  	char	*name;
> -	int	length;
> +	DECLARE_FLEX_ARRAY_ELEMENTS_COUNT(int, length);
>  	void	*value;
>  	struct property *next;
>  #if defined(CONFIG_OF_DYNAMIC) || defined(CONFIG_SPARC)
> @@ -42,6 +42,7 @@ struct property {
>  #if defined(CONFIG_OF_KOBJ)
>  	struct bin_attribute attr;
>  #endif
> +	DECLARE_FLEX_ARRAY_ELEMENTS(u8, contents);

99.9% of the time, this is not where the property value is stored as it 
points into an FDT blob. I suppose that is okay, but just want to make 
sure.

The DT API for creating new nodes and properties is horrible as it is 
multiple allocs and strdups which makes for tricky error paths. A better 
API to centralize it would be welcome, but if this is the only case you 
came across it's certainly not a requirement.

Rob
