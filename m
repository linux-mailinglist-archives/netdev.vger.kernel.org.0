Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B8A944F6D9E
	for <lists+netdev@lfdr.de>; Wed,  6 Apr 2022 23:59:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236898AbiDFWBq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Apr 2022 18:01:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59418 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236848AbiDFWBo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Apr 2022 18:01:44 -0400
Received: from mail-pl1-x633.google.com (mail-pl1-x633.google.com [IPv6:2607:f8b0:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 17E78158D82
        for <netdev@vger.kernel.org>; Wed,  6 Apr 2022 14:59:45 -0700 (PDT)
Received: by mail-pl1-x633.google.com with SMTP id o10so3169050ple.7
        for <netdev@vger.kernel.org>; Wed, 06 Apr 2022 14:59:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20210112.gappssmtp.com; s=20210112;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=bXhrp57RyScu0ZRvGqkj/42ZMpBOCbed3PRNPxmdooU=;
        b=B59yobXTGPG4rEfgZjhYoSKEU4ZMy+8G9eOxJcsAVR9eKsxs7p0WGGXtFMVpagGXNK
         dc4CcJaYjjpvU+9eQ0X2Lt92CL0FUiid9cd+cr9qROWyWtMhR4nXsBnAr1RaWcW0t/xq
         6sVHWUttKLQi3MW8gne2IPX2vp23No3IfrWl1IC4fgtjfhybReP9L72H/uAidTrHi07x
         WdpxrHRw4thm/pt2GLR4yKHel6jLeLq1VWY+mFsuf0eb/46uuriT1kjp65eDBJ9uAkzM
         sCCE0siQIAXgyFR7MFokyn5WQbLHG5NbmhZ+zyQc2c44Xg4wNySqGtL8QRqwPiL2F4cT
         EkBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=bXhrp57RyScu0ZRvGqkj/42ZMpBOCbed3PRNPxmdooU=;
        b=jIfyVVOXQvYoRE5PSxpDv0yRhmdjK4NsZF1OVIX5iblEo0ttdUEepSaHdj/MBp4nVF
         WnSmUAT6Rc22D56fXKG76UZv/UOTrZhujWZ5KaQzXa+cDr2zXKC4m8cubuQDV0QTyl1n
         exEfKZDYCul+iE+PLNl7x4X1SKiCDLff2tCNV0Xs8aK6waKObJQ+iKVbBOcubYJqOqRX
         m09f/BZjOyGyZnXjugVDsyrp5Xjq+vwPPD/ED4qoQCEz44/TbVkbT35uyu51NRBdJEy7
         P+DquuPwbCFqw9FAqczo7EDjnpsTFO5JLi9fXkFbMv3tmIxq0WjIlwHDy3ZYJ8wKjeHf
         TXDg==
X-Gm-Message-State: AOAM5332E44D633nCDCjON0H3ceU/HImUcaFSFe6CZ382AvDfxQcH3i0
        dsIbgu1HlyE1iHqSmEDVaF02cw==
X-Google-Smtp-Source: ABdhPJzgZCCGDuuQfvFHhd+mYjLI8r5Wq68lTnYfarN485RvSlkGa2xnJxtuQJr0OAeMb0BR2Lm+1w==
X-Received: by 2002:a17:902:ce05:b0:156:a7f7:aae1 with SMTP id k5-20020a170902ce0500b00156a7f7aae1mr10931690plg.166.1649282384592;
        Wed, 06 Apr 2022 14:59:44 -0700 (PDT)
Received: from hermes.local (204-195-112-199.wavecable.com. [204.195.112.199])
        by smtp.gmail.com with ESMTPSA id u3-20020a17090add4300b001ca56ea162bsm6323543pjv.33.2022.04.06.14.59.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 Apr 2022 14:59:44 -0700 (PDT)
Date:   Wed, 6 Apr 2022 14:59:41 -0700
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Yann Droneaud <ydroneaud@opteya.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] af_unix: Escape abstract unix socket address
Message-ID: <20220406145941.728b4cb5@hermes.local>
In-Reply-To: <20220406102213.2020784-1-ydroneaud@opteya.com>
References: <20220406102213.2020784-1-ydroneaud@opteya.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed,  6 Apr 2022 12:22:13 +0200
Yann Droneaud <ydroneaud@opteya.com> wrote:

> Abstract unix socket address are bytes sequences up to
> 108 bytes (UNIX_PATH_MAX == sizeof(struct sockaddr_un) -
> offsetof(struct sockaddr_un, sun_path)).
> 
> As with any random string of bytes, printing them in
> /proc/net/unix should be done with caution to prevent
> misbehavior.
> 
> It would have been great to use seq_escape_mem() to escape
> the control characters in a reversible way.
> 
> Unfortunately userspace might expect that NUL bytes are
> replaced with '@' characters as it's done currently.
> 
> So this patch implements the following scheme: any control
> characters, including NUL, in the abstract unix socket
> addresses is replaced by '@' characters.
> 
> Sadly, with such non reversible escape scheme, abstract
> addresses such as "\0\0", "\0\a", "\0\b", "\0\t", etc.
> will have the same representation: "@@".
> 
> But will prevent "cat /proc/net/unix" from messing with
> terminal, and will prevent "\n" in abstract address from
> messing with parsing the list of Unix sockets.
> 
> Signed-off-by: Yann Droneaud <ydroneaud@opteya.com>
> ---
>  net/unix/af_unix.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/net/unix/af_unix.c b/net/unix/af_unix.c
> index e71a312faa1e..8021efd92301 100644
> --- a/net/unix/af_unix.c
> +++ b/net/unix/af_unix.c
> @@ -3340,7 +3340,8 @@ static int unix_seq_show(struct seq_file *seq, void *v)
>  				i++;
>  			}
>  			for ( ; i < len; i++)
> -				seq_putc(seq, u->addr->name->sun_path[i] ?:
> +				seq_putc(seq, !iscntrl(u->addr->name->sun_path[i]) ?
> +					 u->addr->name->sun_path[i] :
>  					 '@');
>  		}
>  		unix_state_unlock(s);

Unfortunately, you will break userspace ABI with this.
