Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 714564D3F63
	for <lists+netdev@lfdr.de>; Thu, 10 Mar 2022 03:51:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236426AbiCJCwK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Mar 2022 21:52:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58486 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233899AbiCJCwJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Mar 2022 21:52:09 -0500
Received: from mail-oo1-xc33.google.com (mail-oo1-xc33.google.com [IPv6:2607:f8b0:4864:20::c33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4AEE312343A
        for <netdev@vger.kernel.org>; Wed,  9 Mar 2022 18:51:10 -0800 (PST)
Received: by mail-oo1-xc33.google.com with SMTP id k13-20020a4a948d000000b003172f2f6bdfso5252408ooi.1
        for <netdev@vger.kernel.org>; Wed, 09 Mar 2022 18:51:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=OyoCdqHPlZLj19Fw91ICJbWCO/QQd+Vqj4mGw798MFY=;
        b=oKJMI/jxBUAaenH0SjAaGocKdWGGfFX8seocqIbbeWaPHF84EWsOGqiC2ia4lFc/Nt
         slyXaicD87YUp+QhI9m+k4/tG9AMbMY2dlSIdhmXTzBG3lKa69HlMBOL2hdh5RNXj2h8
         wW3kqmbppZ89WDOZxqP6PbTZISq3f3Rg1ovQk0/R8knugM52j1O0f+LmP3ELbK9U2Q7M
         QdS0DZOLgqm/QCi1As8KRZrTvQOkH+58vqIVcLQLKtY/+G4SzY4pl0dEzR1BZLK7xM7u
         P/Su/qJl1MQIg/fCsbrQf58hCWuHlDUPpz66RRH/tdVDPH9Mt7IO2QVs4lf+DQIq4Pl9
         nT8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=OyoCdqHPlZLj19Fw91ICJbWCO/QQd+Vqj4mGw798MFY=;
        b=dPneS+klgfj+IneEOYwI0EkicSmP5jbFYJadhwuUwIwbtywfan7B6Ou7UzAYD8lsOJ
         Jgw+qCdSiT7EBLY4AWYEQzB2R10jP0wxVHQVASsqCTL1MbOPXu+SU8cKuctBOuNMA3/W
         2l2k1Xxq8fZjdQujyXZlyN3cqUjXgwKJHRSmcOvF6uLeuu4yYSWCQmu8kU888gBilIh1
         sPIa96FXasD5qh4m97spji0+7iKbNVGqVpl6g2k/jt3W+2QC6ChEzv7TdHu+80W2x1LK
         d688cj9ixjRta7VLvkRRguk7NynjwhkDRCJxlmpIYTStRhUzcaOE/bMQWgKkLJgLceBB
         K+tQ==
X-Gm-Message-State: AOAM532kFAyFbl94sNYZfI4MsNmV7Ao/4Qd3YrmhCyXHPB0MBVz/UcYB
        uEV67GCvvG4D3sZKtHIxY8JclC8QNP2ncw==
X-Google-Smtp-Source: ABdhPJypBIJHQFMVjIKHPkwcQMsgNMAkITvwcySXGBPA60eIAm9Njxh5p1zbZTJ/qqxqDfVp26doUA==
X-Received: by 2002:a05:6870:248e:b0:d6:dd7b:a55b with SMTP id s14-20020a056870248e00b000d6dd7ba55bmr7501265oaq.158.1646880669486;
        Wed, 09 Mar 2022 18:51:09 -0800 (PST)
Received: from [172.16.0.2] ([8.48.134.65])
        by smtp.googlemail.com with ESMTPSA id u22-20020a4ae696000000b0032158ab4ce9sm304924oot.26.2022.03.09.18.51.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 09 Mar 2022 18:51:08 -0800 (PST)
Message-ID: <3731ad8f-55b4-154e-28b7-0ee6cea827b8@gmail.com>
Date:   Wed, 9 Mar 2022 19:51:07 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.6.2
Subject: Re: [PATCH net-next 2/2] net: limit altnames to 64k total
Content-Language: en-US
To:     Jakub Kicinski <kuba@kernel.org>, davem@davemloft.net
Cc:     netdev@vger.kernel.org, jiri@resnulli.us,
        George Shuklin <george.shuklin@gmail.com>
References: <20220309182914.423834-1-kuba@kernel.org>
 <20220309182914.423834-3-kuba@kernel.org>
From:   David Ahern <dsahern@gmail.com>
In-Reply-To: <20220309182914.423834-3-kuba@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/9/22 11:29 AM, Jakub Kicinski wrote:
> diff --git a/net/core/rtnetlink.c b/net/core/rtnetlink.c
> index aa05e89cc47c..159c9c61e6af 100644
> --- a/net/core/rtnetlink.c
> +++ b/net/core/rtnetlink.c
> @@ -3652,12 +3652,23 @@ static int rtnl_alt_ifname(int cmd, struct net_device *dev, struct nlattr *attr,
>  			   bool *changed, struct netlink_ext_ack *extack)
>  {
>  	char *alt_ifname;
> +	size_t size;
>  	int err;
>  
>  	err = nla_validate(attr, attr->nla_len, IFLA_MAX, ifla_policy, extack);
>  	if (err)
>  		return err;
>  
> +	if (cmd == RTM_NEWLINKPROP) {
> +		size = rtnl_prop_list_size(dev);
> +		size += nla_total_size(ALTIFNAMSIZ);
> +		if (size >= U16_MAX) {
> +			NL_SET_ERR_MSG(extack,
> +				       "effective property list too long");
> +			return -EINVAL;
> +		}
> +	}
> +
>  	alt_ifname = nla_strdup(attr, GFP_KERNEL_ACCOUNT);
>  	if (!alt_ifname)
>  		return -ENOMEM;

this tests the existing property size. Don't you want to test the size
with the alt_ifname - does it make the list go over 64kB?
