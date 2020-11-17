Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 87ACD2B5870
	for <lists+netdev@lfdr.de>; Tue, 17 Nov 2020 04:45:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727690AbgKQDoW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Nov 2020 22:44:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55342 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725730AbgKQDoT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Nov 2020 22:44:19 -0500
Received: from mail-io1-xd43.google.com (mail-io1-xd43.google.com [IPv6:2607:f8b0:4864:20::d43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A656AC0613CF;
        Mon, 16 Nov 2020 19:44:19 -0800 (PST)
Received: by mail-io1-xd43.google.com with SMTP id r12so19743916iot.4;
        Mon, 16 Nov 2020 19:44:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=57lbXEPj7jmNMETWFLeFaZrg6lk8ttcI8EA76YL2pTI=;
        b=eSKEDg7flLp4D1xoqZ18+arU7NXV4g8oO1m1RWGJoWcR2z06I7q55NoUPBmwfyCpmY
         +M0SWFotPWRCiX+TGv0Ttx7lTJEds1dHPK++mDc6ARujz/A21t6WD07GwzrMliseeOLs
         2kIW+eYOKvnBiB+GL0POaDVXQXP5Rw3Qy/YywlPunIKsXoY3iWzC67AhVzbskHYCqo+C
         zvFSrBQ6aJ+MVua6yhNS7xQK9GOnhdhEF1x/vtNMg++yM2rVIt9MoikEDr3xmyZoDI0T
         3UyAi3N3JdADZkQLkz34egyA6lP9k1pe18zesJ13e3dyDZS5Cl7zowqhxx4jpqaExgqp
         vO8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=57lbXEPj7jmNMETWFLeFaZrg6lk8ttcI8EA76YL2pTI=;
        b=uK0RsIVkMG01/CZAP/dC/i0zGcROmpmgr6eaVZapZjJA7sNo4dFgmD1tVPlKOw+/m5
         YBLD/45pHN7PdR48ZgdCbRf3yxLviO+AiePXyph3I2Jn732KwWmgXVJL8+zS6Ztdv7iT
         Ot4HrJmjt1AHxHrS6Hx5dMSp1a6QH9Ii3HeEm+yLYltgfsj8JMyLm24giUFjHODMAdl6
         v6JbMFpEnisPkKygLYaUtJpJ5RxN5XzDcgHcwc3AFuKEd+40Yvoz2JxlBWlLs/VWFM4D
         T3ddJ57MMoo3F2cPaZl6lA1DexQiZNQreEq74WB/dK9kr8IKPyzmbPznZMWzL+2zxuIZ
         qztg==
X-Gm-Message-State: AOAM5300+1bHwR2LskTvr0LdxCJLk5n69I5mZVS9qpXmgbqOLqdi3/p+
        lslsfO0CBelO8J5uhg6ywts8dAq1cH4=
X-Google-Smtp-Source: ABdhPJw/yEB+ALCGdMUZTF7R+rcBxaLw/KLDk/LjnT/LhqsFVjxtGZJGtYSIsdkP62NeXytg4aZCaQ==
X-Received: by 2002:a6b:4401:: with SMTP id r1mr10057525ioa.78.1605584659034;
        Mon, 16 Nov 2020 19:44:19 -0800 (PST)
Received: from Davids-MacBook-Pro.local ([2601:282:800:dc80:c472:ae53:db1e:5dd0])
        by smtp.googlemail.com with ESMTPSA id c89sm12728838ilf.26.2020.11.16.19.44.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 16 Nov 2020 19:44:18 -0800 (PST)
Subject: Re: [PATCH v4 bpf-next 3/5] kbuild: build kernel module BTFs if BTF
 is enabled and pahole supports it
To:     Andrii Nakryiko <andrii@kernel.org>
Cc:     kernel-team@fb.com, linux-kernel@vger.kernel.org,
        rafael@kernel.org, jeyu@kernel.org,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Masahiro Yamada <yamada.masahiro@socionext.com>,
        bpf@vger.kernel.org, netdev@vger.kernel.org, ast@fb.com,
        daniel@iogearbox.net
References: <20201110011932.3201430-1-andrii@kernel.org>
 <20201110011932.3201430-4-andrii@kernel.org>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <f52c83a9-c350-5ba8-e178-10a0d7d0fed6@gmail.com>
Date:   Mon, 16 Nov 2020 20:44:15 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.4.3
MIME-Version: 1.0
In-Reply-To: <20201110011932.3201430-4-andrii@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/9/20 6:19 PM, Andrii Nakryiko wrote:
> diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
> index d7a7bc3b6098..1e78faaf20a5 100644
> --- a/lib/Kconfig.debug
> +++ b/lib/Kconfig.debug
> @@ -274,6 +274,15 @@ config DEBUG_INFO_BTF
>  	  Turning this on expects presence of pahole tool, which will convert
>  	  DWARF type info into equivalent deduplicated BTF type info.
>  
> +config PAHOLE_HAS_SPLIT_BTF
> +	def_bool $(success, test `$(PAHOLE) --version | sed -E 's/v([0-9]+)\.([0-9]+)/\1\2/'` -ge "119")
> +
> +config DEBUG_INFO_BTF_MODULES
> +	def_bool y
> +	depends on DEBUG_INFO_BTF && MODULES && PAHOLE_HAS_SPLIT_BTF
> +	help
> +	  Generate compact split BTF type information for kernel modules.
> +
>  config GDB_SCRIPTS
>  	bool "Provide GDB scripts for kernel debugging"
>  	help

Thank you for adding a config option for this feature vs bumping the
required pahole version in scripts/link-vmlinux.sh. This is a much more
friendly way of handling kernel features that require support from build
tools.
