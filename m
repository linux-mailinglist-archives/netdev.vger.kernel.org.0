Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5651767DFFC
	for <lists+netdev@lfdr.de>; Fri, 27 Jan 2023 10:23:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231520AbjA0JXf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Jan 2023 04:23:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38056 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232029AbjA0JXd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Jan 2023 04:23:33 -0500
Received: from mail-ej1-x629.google.com (mail-ej1-x629.google.com [IPv6:2a00:1450:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 930AC6E95
        for <netdev@vger.kernel.org>; Fri, 27 Jan 2023 01:22:47 -0800 (PST)
Received: by mail-ej1-x629.google.com with SMTP id m2so11532139ejb.8
        for <netdev@vger.kernel.org>; Fri, 27 Jan 2023 01:22:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=7q//eWD7kpKVjwkvP9sSwP1duHlI8w+YBBfIBpjcKsU=;
        b=XOWnbPeHK869eG5NgRyxRRIGBWXGJksAbHxR5YyTn4BIx6+j+VvSQiBjgC3IN9kLM6
         AIo37Y0Rc444kkJFPhPJ6euTVgyNThZCA2oJb2LzDS/1SVriuTTi8EvYecyC8eIdiBEA
         la8iyZFBSWntYG3t4RdeHYi2TDDpBZODccGCEEg9KztzkAhrwpRR4+oZ8vRrEH6hfG1I
         +R2LKV3N6AglJsS27FLGOe6VHMW4SFpYZRrG1BWdBlBxB0tdFUCbmlrjFalVdDQAPvUE
         UZjgytkW2zekKT3kN+TYRvzQJK4PsaCiyRzKlKREKYukuda1NuaZ59TM9s4yuM4laT8M
         VHYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7q//eWD7kpKVjwkvP9sSwP1duHlI8w+YBBfIBpjcKsU=;
        b=s0hcwvBzXLHSGXKNxJHm/SEh3Kh6JZpaARnuFBSAWF/O6qhhLgMEobTiJGF7cLu14T
         ZUVRO6KS0T1Wl4ixQpIdLDoFIutAUOYI2Y+m5QKZcMOh/NdA5rB6xaPA/rO49iChIAcw
         DLYDXiOcu1HJ/eLavWuIxwiA29ZG8P/GQn7dLe3DTNATXn2VeU+35bFCy+CDAv11Ldyv
         ed3iaFKUjWf+NMJmi85LvyzHO7bMTcwqwneRQHMKN05hC8oJbJLFiW2N4KvlaBhfrTq/
         n/U0Fk6crJlgDDuWJvbUu3jpg7dsrlGqG9utw68V7sN+t06zwAYl8hoeJKog8GXyaWUz
         Bv7A==
X-Gm-Message-State: AFqh2kryfSVTUULpHDc5uorqRdbxOid8ZuOK6+QP/7l0XO5pwPEAYrFp
        fnNptyQtl46xv4pBTwH1i0w=
X-Google-Smtp-Source: AMrXdXsI0jN67mGYaa42H82OuSgQ4JsGdf/ChsuoiIeoIX5rV8ZZhPMBjBwTpMW0C2YxZ8KtVkdWQw==
X-Received: by 2002:a17:907:8e86:b0:84d:43c3:a897 with SMTP id tx6-20020a1709078e8600b0084d43c3a897mr57904255ejc.2.1674811365461;
        Fri, 27 Jan 2023 01:22:45 -0800 (PST)
Received: from skbuf ([188.27.185.85])
        by smtp.gmail.com with ESMTPSA id x26-20020a1709060a5a00b00877f2b842fasm1898006ejf.67.2023.01.27.01.22.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 27 Jan 2023 01:22:45 -0800 (PST)
Date:   Fri, 27 Jan 2023 11:22:42 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Leon Romanovsky <leon@kernel.org>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        bridge@lists.linux-foundation.org,
        Eric Dumazet <edumazet@google.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        netdev@vger.kernel.org, Nikolay Aleksandrov <razor@blackwall.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Roopa Prabhu <roopa@nvidia.com>
Subject: Re: [PATCH net-next] netlink: provide an ability to set default
 extack message
Message-ID: <20230127092242.ajwlo3tivxsjsul7@skbuf>
References: <2919eb55e2e9b92265a3ba600afc8137a901ae5f.1674760340.git.leon@kernel.org>
 <20230126223213.riq6i2gdztwuinwi@skbuf>
 <Y9NfkgRbWAbrxQ1G@unreal>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y9NfkgRbWAbrxQ1G@unreal>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jan 27, 2023 at 07:22:26AM +0200, Leon Romanovsky wrote:
> It means changing ALL error unwind places where extack was forwarded
> before to subfunctions.
> 
> Places like this:
>  ret = func(..., extack)
>  if (ret) {
>    NL_SET_ERR_MSG_MOD...
>    return ret;
>  }
> 
> will need to be changed to something like this:
>  ret = func(..., extack)
>  if (ret) {
>    NL_SET_ERR_MSG_WEAK...
>    return ret;
>  }

Yeah, but my point is that you inspect the code that you plan to convert,
rather than converting it in bulk and inspecting later...

> Can we please discuss current code and not over-engineered case which
> doesn't exist in the reality?
> 
> Even for your case, I would like to see NL_SET_ERR_MSG_FORCE() to
> explicitly say that message will be overwritten.

__nla_validate_parse()

	if (unlikely(rem > 0)) {
		pr_warn_ratelimited("netlink: %d bytes leftover after parsing attributes in process `%s'.\n",
				    rem, current->comm);
		NL_SET_ERR_MSG(extack, "bytes leftover after parsing attributes");
		if (validate & NL_VALIDATE_TRAILING)
			return -EINVAL;
	}

	return 0;

called by nla_validate_deprecated() with validate == NL_VALIDATE_LIBERAL

followed by other extack setting in tunnel_key_copy_opts(), which will
not overwrite the initial warning message.
