Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 693B459E2D
	for <lists+netdev@lfdr.de>; Fri, 28 Jun 2019 16:48:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726730AbfF1Osg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Jun 2019 10:48:36 -0400
Received: from mail-pf1-f196.google.com ([209.85.210.196]:38747 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726770AbfF1Osf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Jun 2019 10:48:35 -0400
Received: by mail-pf1-f196.google.com with SMTP id y15so3107798pfn.5
        for <netdev@vger.kernel.org>; Fri, 28 Jun 2019 07:48:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=4+9BQ/9qN/HEB5jYhHOcTVXcrlmUmZtAOZVfYv7/QOA=;
        b=ofGc0v9hZZwUxfhb5r0SX5BCHeOcj3Ym+G17847226BPeApHLQt5lHVJGZPjPCl6mJ
         R9yEA1WaiRHbrYKbycxmjkd9zcIuG73DJH0UQtlrraeon+eWgyD9ND/T5MTW0MQaCyTR
         T/8ILMD0OYRqTF/FvjRgFsB3BtZtKPQ5aqUdQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=4+9BQ/9qN/HEB5jYhHOcTVXcrlmUmZtAOZVfYv7/QOA=;
        b=hBogC3hwhn1KcyxdEUPCSvqvLqzteBH90Cxcxu3mBSzir4VjMVRw6Rvg/nNAKuL3H/
         bmoc7oKOoG9uo9XZON8n7/OQpEgsZipFmZ5QI/tdgHS+XQFdxus6FsLND/uSwGV5szcE
         /W+IPsoCxjY+WQ0PTRhuCSthlLudp68Hy3Fz4A+QlK0xRdbvH2UNP9ZhXQj3m/ffgRfq
         zuf31TATmS1pw2ACzsM85vGljYjksfDJwp22KCv+A/DomesecQBlyGXySwLrQ9LVx+IX
         2/G+D+4kGdC2cPtnnXnRNFi6Np22i+YJ4sdS1cAmorsvHWiYF2Qz39yknEywMqjQ5Mqy
         NARA==
X-Gm-Message-State: APjAAAVjWOkqt9orZVd7or7dsIWc8z3f8HWvv43ofJmWQ7Xr5c9X5WFc
        ut+DkS88COCihJ/tSVNISZIgbA==
X-Google-Smtp-Source: APXvYqxuLReGYT1J6pyZqWFjFn4v/IkeCqcW7PORteWScBzJ7GtXkI24Q14wzzAy1SnCsExLh59UaA==
X-Received: by 2002:a17:90a:29c5:: with SMTP id h63mr13123809pjd.83.1561733315036;
        Fri, 28 Jun 2019 07:48:35 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id b11sm2896176pfd.18.2019.06.28.07.48.33
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 28 Jun 2019 07:48:33 -0700 (PDT)
Date:   Fri, 28 Jun 2019 07:48:33 -0700
From:   Kees Cook <keescook@chromium.org>
To:     Arnd Bergmann <arnd@arndb.de>
Cc:     James Morris <jmorris@namei.org>,
        "Serge E. Hallyn" <serge@hallyn.com>,
        James Smart <james.smart@broadcom.com>,
        Dick Kennedy <dick.kennedy@broadcom.com>,
        "James E . J . Bottomley" <jejb@linux.ibm.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Florian Schilhabel <florian.c.schilhabel@googlemail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "David S . Miller" <davem@davemloft.net>,
        Wensong Zhang <wensong@linux-vs.org>,
        Simon Horman <horms@verge.net.au>,
        Julian Anastasov <ja@ssi.bg>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        devel@driverdev.osuosl.org, netdev@vger.kernel.org,
        lvs-devel@vger.kernel.org, netfilter-devel@vger.kernel.org,
        coreteam@netfilter.org, Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Masahiro Yamada <yamada.masahiro@socionext.com>,
        Alexander Potapenko <glider@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Michal Hocko <mhocko@suse.cz>,
        Thomas Gleixner <tglx@linutronix.de>,
        linux-security-module@vger.kernel.org
Subject: Re: [PATCH 1/4] [v2] structleak: disable STRUCTLEAK_BYREF in
 combination with KASAN_STACK
Message-ID: <201906280748.910641F1DD@keescook>
References: <20190628123819.2785504-1-arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190628123819.2785504-1-arnd@arndb.de>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jun 28, 2019 at 02:37:46PM +0200, Arnd Bergmann wrote:
> The combination of KASAN_STACK and GCC_PLUGIN_STRUCTLEAK_BYREF
> leads to much larger kernel stack usage, as seen from the warnings
> about functions that now exceed the 2048 byte limit:
> 
> drivers/media/i2c/tvp5150.c:253:1: error: the frame size of 3936 bytes is larger than 2048 bytes
> drivers/media/tuners/r820t.c:1327:1: error: the frame size of 2816 bytes is larger than 2048 bytes
> drivers/net/wireless/broadcom/brcm80211/brcmsmac/phy/phy_n.c:16552:1: error: the frame size of 3144 bytes is larger than 2048 bytes [-Werror=frame-larger-than=]
> fs/ocfs2/aops.c:1892:1: error: the frame size of 2088 bytes is larger than 2048 bytes
> fs/ocfs2/dlm/dlmrecovery.c:737:1: error: the frame size of 2088 bytes is larger than 2048 bytes
> fs/ocfs2/namei.c:1677:1: error: the frame size of 2584 bytes is larger than 2048 bytes
> fs/ocfs2/super.c:1186:1: error: the frame size of 2640 bytes is larger than 2048 bytes
> fs/ocfs2/xattr.c:3678:1: error: the frame size of 2176 bytes is larger than 2048 bytes
> net/bluetooth/l2cap_core.c:7056:1: error: the frame size of 2144 bytes is larger than 2048 bytes [-Werror=frame-larger-than=]
> net/bluetooth/l2cap_core.c: In function 'l2cap_recv_frame':
> net/bridge/br_netlink.c:1505:1: error: the frame size of 2448 bytes is larger than 2048 bytes
> net/ieee802154/nl802154.c:548:1: error: the frame size of 2232 bytes is larger than 2048 bytes
> net/wireless/nl80211.c:1726:1: error: the frame size of 2224 bytes is larger than 2048 bytes
> net/wireless/nl80211.c:2357:1: error: the frame size of 4584 bytes is larger than 2048 bytes
> net/wireless/nl80211.c:5108:1: error: the frame size of 2760 bytes is larger than 2048 bytes
> net/wireless/nl80211.c:6472:1: error: the frame size of 2112 bytes is larger than 2048 bytes
> 
> The structleak plugin was previously disabled for CONFIG_COMPILE_TEST,
> but meant we missed some bugs, so this time we should address them.
> 
> The frame size warnings are distracting, and risking a kernel stack
> overflow is generally not beneficial to performance, so it may be best
> to disallow that particular combination. This can be done by turning
> off either one. I picked the dependency in GCC_PLUGIN_STRUCTLEAK_BYREF
> and GCC_PLUGIN_STRUCTLEAK_BYREF_ALL, as this option is designed to
> make uninitialized stack usage less harmful when enabled on its own,
> but it also prevents KASAN from detecting those cases in which it was
> in fact needed.
> 
> KASAN_STACK is currently implied by KASAN on gcc, but could be made a
> user selectable option if we want to allow combining (non-stack) KASAN
> with GCC_PLUGIN_STRUCTLEAK_BYREF.
> 
> Note that it would be possible to specifically address the files that
> print the warning, but presumably the overall stack usage is still
> significantly higher than in other configurations, so this would not
> address the full problem.
> 
> I could not test this with CONFIG_INIT_STACK_ALL, which may or may not
> suffer from a similar problem.
> 
> Fixes: 81a56f6dcd20 ("gcc-plugins: structleak: Generalize to all variable types")
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>

Acked-by: Kees Cook <keescook@chromium.org>

-Kees

> ---
> [v2] do it for both GCC_PLUGIN_STRUCTLEAK_BYREF and GCC_PLUGIN_STRUCTLEAK_BYREF_ALL.
> ---
>  security/Kconfig.hardening | 7 +++++++
>  1 file changed, 7 insertions(+)
> 
> diff --git a/security/Kconfig.hardening b/security/Kconfig.hardening
> index a1ffe2eb4d5f..af4c979b38ee 100644
> --- a/security/Kconfig.hardening
> +++ b/security/Kconfig.hardening
> @@ -61,6 +61,7 @@ choice
>  	config GCC_PLUGIN_STRUCTLEAK_BYREF
>  		bool "zero-init structs passed by reference (strong)"
>  		depends on GCC_PLUGINS
> +		depends on !(KASAN && KASAN_STACK=1)
>  		select GCC_PLUGIN_STRUCTLEAK
>  		help
>  		  Zero-initialize any structures on the stack that may
> @@ -70,9 +71,15 @@ choice
>  		  exposures, like CVE-2017-1000410:
>  		  https://git.kernel.org/linus/06e7e776ca4d3654
>  
> +		  As a side-effect, this keeps a lot of variables on the
> +		  stack that can otherwise be optimized out, so combining
> +		  this with CONFIG_KASAN_STACK can lead to a stack overflow
> +		  and is disallowed.
> +
>  	config GCC_PLUGIN_STRUCTLEAK_BYREF_ALL
>  		bool "zero-init anything passed by reference (very strong)"
>  		depends on GCC_PLUGINS
> +		depends on !(KASAN && KASAN_STACK=1)
>  		select GCC_PLUGIN_STRUCTLEAK
>  		help
>  		  Zero-initialize any stack variables that may be passed
> -- 
> 2.20.0
> 

-- 
Kees Cook
