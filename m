Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 47695547B0C
	for <lists+netdev@lfdr.de>; Sun, 12 Jun 2022 18:23:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229828AbiFLQX5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 12 Jun 2022 12:23:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51088 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229554AbiFLQXz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 12 Jun 2022 12:23:55 -0400
Received: from mail-wm1-x336.google.com (mail-wm1-x336.google.com [IPv6:2a00:1450:4864:20::336])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A9F5D5E152
        for <netdev@vger.kernel.org>; Sun, 12 Jun 2022 09:23:54 -0700 (PDT)
Received: by mail-wm1-x336.google.com with SMTP id j5-20020a05600c1c0500b0039c5dbbfa48so3386322wms.5
        for <netdev@vger.kernel.org>; Sun, 12 Jun 2022 09:23:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=philpotter-co-uk.20210112.gappssmtp.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Bp1t0MAX0vF2MFrixDjLhlmP3KLo6hgWxyC3M+usaE8=;
        b=R/sEjCaZtQEnfPFaK+UnnTh0wg4bRV6svzZB+oS2hfNNJzpfcRRfcZmCJOP8EySmQd
         g+xcBgfqADhJshLEY78CKFvKjnbnDQTiZlNPaYQ4krJN4DIZr0DcF9zio2w2kHV8Sq+E
         bLM/i/SzIos3D8gnl2FjBUdtUwk4BOXJ/p4Gz7UFvasXpv6HXMR+5PupsiPSPR0TnZya
         F4NsEqC4DRhyBo+zGRqyKs6C3D88H2ZM6iKWsmgHMRXInXx2VY+xkqjwHyZXLhqJ9DIi
         GLX8O48hgFb+6agiYOXIOISy12Ll9TGb3KH9UckWOW5W3iIlklqwzjxaxwQD5RPR2Sdf
         1JcA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Bp1t0MAX0vF2MFrixDjLhlmP3KLo6hgWxyC3M+usaE8=;
        b=r2dV7pdnausKP95+FwLdfi8azceEh9fjVToytKjqdp6sWehameaRD5yxtrbx2afmQ5
         DsOAKsCWNQF+fWnTbvzOV3QeP1xe/PvpKFWVJOYQhWO2De5ZrYDLOYLccU5sUD9ZlSnY
         rEJqOjYLEoSW2NQuEhU1u2w8jqpRL2tPtce0eNXwWztLRAER17t3mBNbQtw85nY1AlDl
         qCMFeOW0nEhyrErkgJcu1HgztYFBZQT32mEuilxcPT0a9/U2EZyTteXKlwoWFbchf9fR
         yIKHL7TlHl9exJ0lv/Z6wlYV08TFAoeR0zqE1lCRZH7EpWvZ7/pl5U7N2GEnSgXv8DDF
         v2Zw==
X-Gm-Message-State: AOAM530c+WW/HRfKWf8DvT1tkSywWmxpvZ2q0eCVSABmmE+xLXLFjgMa
        yoCeRa2HwI2+EklNM0RlBEI/cw==
X-Google-Smtp-Source: ABdhPJyPL0K+xAMvnRb2ONEX1jWjnGDkkA7zHOBZU3POgTFS7NF7cqaibZCvN8D1E1ysUwm9U4xflg==
X-Received: by 2002:a05:600c:2682:b0:39c:8ec6:57d9 with SMTP id 2-20020a05600c268200b0039c8ec657d9mr3559545wmt.99.1655051032703;
        Sun, 12 Jun 2022 09:23:52 -0700 (PDT)
Received: from equinox (2.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.a.1.e.e.d.f.d.0.b.8.0.1.0.0.2.ip6.arpa. [2001:8b0:dfde:e1a0::2])
        by smtp.gmail.com with ESMTPSA id bh8-20020a05600c3d0800b003942a244ee6sm6005715wmb.43.2022.06.12.09.23.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 12 Jun 2022 09:23:51 -0700 (PDT)
Date:   Sun, 12 Jun 2022 17:23:47 +0100
From:   Phillip Potter <phil@philpotter.co.uk>
To:     Bill Wendling <morbo@google.com>
Cc:     isanbard@gmail.com, Tony Luck <tony.luck@intel.com>,
        Borislav Petkov <bp@alien8.de>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>,
        Phillip Potter <phil@philpotter.co.uk>,
        Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
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
        Ross Philipson <ross.philipson@oracle.com>,
        Daniel Kiper <daniel.kiper@oracle.com>,
        linux-edac@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-acpi@vger.kernel.org, linux-mm@kvack.org,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org, alsa-devel@alsa-project.org,
        llvm@lists.linux.dev
Subject: Re: [PATCH 08/12] cdrom: use correct format characters
Message-ID: <YqYTExy0IpVbunBL@equinox>
References: <20220609221702.347522-1-morbo@google.com>
 <20220609221702.347522-9-morbo@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220609221702.347522-9-morbo@google.com>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jun 09, 2022 at 10:16:27PM +0000, Bill Wendling wrote:
> From: Bill Wendling <isanbard@gmail.com>
> 
> When compiling with -Wformat, clang emits the following warnings:
> 
> drivers/cdrom/cdrom.c:3454:48: error: format string is not a string literal (potentially insecure) [-Werror,-Wformat-security]
>         ret = scnprintf(info + *pos, max_size - *pos, header);
>                                                       ^~~~~~
> 
> Use a string literal for the format string.
> 
> Link: https://github.com/ClangBuiltLinux/linux/issues/378
> Signed-off-by: Bill Wendling <isanbard@gmail.com>
> ---
>  drivers/cdrom/cdrom.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/cdrom/cdrom.c b/drivers/cdrom/cdrom.c
> index 416f723a2dbb..52b40120c76e 100644
> --- a/drivers/cdrom/cdrom.c
> +++ b/drivers/cdrom/cdrom.c
> @@ -3451,7 +3451,7 @@ static int cdrom_print_info(const char *header, int val, char *info,
>  	struct cdrom_device_info *cdi;
>  	int ret;
>  
> -	ret = scnprintf(info + *pos, max_size - *pos, header);
> +	ret = scnprintf(info + *pos, max_size - *pos, "%s", header);
>  	if (!ret)
>  		return 1;
>  
> -- 
> 2.36.1.255.ge46751e96f-goog
> 

Hi Bill,

Thank you for the patch, much appreciated.

Looking at this though, all callers of cdrom_print_info() provide 'header'
as a string literal defined within the driver, when making the call.
Therefore, I'm not convinced this change is necessary for cdrom.c -
that said, in this particular use case I don't think it would hurt
either.

I've followed the other responses on parts of this series, so I
understand that a different solution is potentially in the works.
Thought I'd respond anyway though out of courtesy.

All the best,
Phil (Uniform CDROM Maintainer)
