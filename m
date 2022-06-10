Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E5400545B8B
	for <lists+netdev@lfdr.de>; Fri, 10 Jun 2022 07:19:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244385AbiFJFTA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Jun 2022 01:19:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57740 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243933AbiFJFS6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Jun 2022 01:18:58 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E58B935A8A;
        Thu,  9 Jun 2022 22:18:57 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6F7F161E2B;
        Fri, 10 Jun 2022 05:18:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C60CC34114;
        Fri, 10 Jun 2022 05:18:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654838336;
        bh=2yFCZugsiNQZN0gkgMSO/PLnnK4cDobzksJyDLjp9Ts=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=rh1PySG6mRmieZPY8cY0A1hPrIcbkuP807V49e98ihkLxbZ06HxYRwIuVMf+wTLDn
         X/yCYKI3C60vy05a003Jfa/l8d0up/cE/3SCBy/NuCOYNPxYpirlNBYrpXNy/Wd9yS
         jlJr0CyMDaP1q3f/tt8/VcfJ3YUsM+y3ifSXc9V4=
Date:   Fri, 10 Jun 2022 07:18:49 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Bill Wendling <morbo@google.com>
Cc:     isanbard@gmail.com, Tony Luck <tony.luck@intel.com>,
        Borislav Petkov <bp@alien8.de>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>,
        Phillip Potter <phil@philpotter.co.uk>,
        Arnd Bergmann <arnd@arndb.de>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Jan Kara <jack@suse.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Jaroslav Kysela <perex@perex.cz>,
        Takashi Iwai <tiwai@suse.com>,
        Nathan Chancellor <nathan@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Tom Rix <trix@redhat.com>,
        Daniel Kiper <daniel.kiper@oracle.com>,
        Ross Philipson <ross.philipson@oracle.com>,
        linux-edac@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-acpi@vger.kernel.org, linux-mm@kvack.org,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org, alsa-devel@alsa-project.org,
        llvm@lists.linux.dev
Subject: Re: [PATCH 07/12] driver/char: use correct format characters
Message-ID: <YqLUORmZQgG1D6lc@kroah.com>
References: <20220609221702.347522-1-morbo@google.com>
 <20220609221702.347522-8-morbo@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220609221702.347522-8-morbo@google.com>
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jun 09, 2022 at 10:16:26PM +0000, Bill Wendling wrote:
> From: Bill Wendling <isanbard@gmail.com>

Why isn't that matching your From: line in the email?

> 
> When compiling with -Wformat, clang emits the following warnings:

Is that ever a default build option for the kernel?

> 
> drivers/char/mem.c:775:16: error: format string is not a string literal (potentially insecure) [-Werror,-Wformat-security]
>                               NULL, devlist[minor].name);
>                                     ^~~~~~~~~~~~~~~~~~~
> 
> Use a string literal for the format string.
> 
> Link: https://github.com/ClangBuiltLinux/linux/issues/378
> Signed-off-by: Bill Wendling <isanbard@gmail.com>
> ---
>  drivers/char/mem.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/char/mem.c b/drivers/char/mem.c
> index 84ca98ed1dad..32d821ba9e4d 100644
> --- a/drivers/char/mem.c
> +++ b/drivers/char/mem.c
> @@ -772,7 +772,7 @@ static int __init chr_dev_init(void)
>  			continue;
>  
>  		device_create(mem_class, NULL, MKDEV(MEM_MAJOR, minor),
> -			      NULL, devlist[minor].name);
> +			      NULL, "%s", devlist[minor].name);

Please explain how this static string can ever be user controlled.

thanks,

greg k-h
