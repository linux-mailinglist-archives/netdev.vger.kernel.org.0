Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9706A532DB5
	for <lists+netdev@lfdr.de>; Tue, 24 May 2022 17:39:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239004AbiEXPjW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 May 2022 11:39:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40758 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239008AbiEXPjT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 May 2022 11:39:19 -0400
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4BE79703E3;
        Tue, 24 May 2022 08:39:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1653406756; x=1684942756;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=4rd15RSs+bC2DmRXjk8iPqEenJ0gefzbXgGg23o0n4E=;
  b=fEPaH8SKVsM7s0KJvdxgMBc3qylwc3wR8cdEKxYucHe3Wphba3HK1YvE
   GTMLsDNVVT5HrdsHVb7PbKKGbC/fv//sd0cO59OUif5YeavdOF3rdtHw1
   I17JiQ34X/CTPphMK2V0JouOGTWAeXP8uswrGSBiyr3D8ddmGW0i2xwge
   G6j5hT1ZocbWkolwLm4vSmD7T5CsLLjXD6j1QxfGKU8WGmv3USi+tz5bg
   xrcC7IVUriMtmuZEOa4jE5PkDsmnhAucb8sAcSF+XZQnQU6cgJHBNjaDb
   O6Lrun4DUlPWYhBNAlk3d2e0RBhX+w8HRaE6fmKVnQ4tL/2evesZTF1x3
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10357"; a="359958128"
X-IronPort-AV: E=Sophos;i="5.91,248,1647327600"; 
   d="scan'208";a="359958128"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 May 2022 08:39:04 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.91,248,1647327600"; 
   d="scan'208";a="577938831"
Received: from irvmail001.ir.intel.com ([10.43.11.63])
  by fmsmga007.fm.intel.com with ESMTP; 24 May 2022 08:39:01 -0700
Received: from newjersey.igk.intel.com (newjersey.igk.intel.com [10.102.20.203])
        by irvmail001.ir.intel.com (8.14.3/8.13.6/MailSET/Hub) with ESMTP id 24OFd0qk001875;
        Tue, 24 May 2022 16:39:00 +0100
From:   Alexander Lobakin <alexandr.lobakin@intel.com>
To:     Nathan Chancellor <nathan@kernel.org>
Cc:     Alexander Lobakin <alexandr.lobakin@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Kalle Valo <kvalo@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Tom Rix <trix@redhat.com>, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        llvm@lists.linux.dev, "kernelci.org bot" <bot@kernelci.org>
Subject: Re: [PATCH] ath6kl: Use cc-disable-warning to disable -Wdangling-pointer
Date:   Tue, 24 May 2022 17:38:14 +0200
Message-Id: <20220524153814.1093477-1-alexandr.lobakin@intel.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220524145655.869822-1-nathan@kernel.org>
References: <20220524145655.869822-1-nathan@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Nathan Chancellor <nathan@kernel.org>
Date: Tue, 24 May 2022 07:56:55 -0700

> Clang does not support this option so the build fails:
> 
>   error: unknown warning option '-Wno-dangling-pointer' [-Werror,-Wunknown-warning-option]
> 
> Use cc-disable-warning so that the option is only added when it is
> supported.
> 
> Fixes: bd1d129daa3e ("wifi: ath6k: silence false positive -Wno-dangling-pointer warning on GCC 12")
> Reported-by: "kernelci.org bot" <bot@kernelci.org>
> Signed-off-by: Nathan Chancellor <nathan@kernel.org>

I was just about to send it :D

Reviewed-and-tested-by: Alexander Lobakin <alexandr.lobakin@intel.com>

> ---
>  drivers/net/wireless/ath/ath6kl/Makefile | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/net/wireless/ath/ath6kl/Makefile b/drivers/net/wireless/ath/ath6kl/Makefile
> index 01cc0d50fee6..a75bfa9fd1cf 100644
> --- a/drivers/net/wireless/ath/ath6kl/Makefile
> +++ b/drivers/net/wireless/ath/ath6kl/Makefile
> @@ -38,7 +38,7 @@ ath6kl_core-y += recovery.o
>  
>  # FIXME: temporarily silence -Wdangling-pointer on non W=1+ builds
>  ifndef KBUILD_EXTRA_WARN
> -CFLAGS_htc_mbox.o += -Wno-dangling-pointer
> +CFLAGS_htc_mbox.o += $(call cc-disable-warning, dangling-pointer)
>  endif
>  
>  ath6kl_core-$(CONFIG_NL80211_TESTMODE) += testmode.o
> 
> base-commit: 677fb7525331375ba2f90f4bc94a80b9b6e697a3
> -- 
> 2.36.1

Thanks,
Al
