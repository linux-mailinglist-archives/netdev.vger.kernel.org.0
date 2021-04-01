Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6B44335180A
	for <lists+netdev@lfdr.de>; Thu,  1 Apr 2021 19:48:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235979AbhDARnb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Apr 2021 13:43:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57212 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234806AbhDARkS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Apr 2021 13:40:18 -0400
Received: from mail-ot1-x330.google.com (mail-ot1-x330.google.com [IPv6:2607:f8b0:4864:20::330])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 075E9C0045E0
        for <netdev@vger.kernel.org>; Thu,  1 Apr 2021 07:31:08 -0700 (PDT)
Received: by mail-ot1-x330.google.com with SMTP id 91-20020a9d08640000b0290237d9c40382so2246818oty.12
        for <netdev@vger.kernel.org>; Thu, 01 Apr 2021 07:31:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=1vCbM6Y5ugdY17zZFnGBErJCF6VoWEI4g+Hy5HNZJz0=;
        b=m4hHihRwHsQUoDd6qiU0eoBmr19cjsuiBJngjDxN73OTRxmXq8lJ0LLouW73Jczshp
         GX8COA/kb7iXeinrkzcvHS5ywGNjMtYWVX/n4SfXhveUaC8KXmn663o30qNLTd3+O8xI
         TpXwDWSKAlxVODOYjXDH1HUSLN7epIq3bR11fclfyDYr9dIDdBnCF1xMWw/KJH7Irssi
         8aIc06nz8Qu0BfH5WLkWFOtXzsMZNGQn8ewxHgbwQkhlxVhpT5YjJ2DGVtWslenAhMxZ
         wstM2y698gXVSVYFkM3LIlDyVrxt+MPwXyjpdkbkwh81fhjoxLH3EWBsHXCBKrNkLryR
         4EFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=1vCbM6Y5ugdY17zZFnGBErJCF6VoWEI4g+Hy5HNZJz0=;
        b=JPDlJWnEn/GOoLb3310vkpPGfmw61L/H8O2m2PrbVh56Io2eSWicqdhUtw0xjOUstO
         4olIKiqPANkFoZYbOJJXQCom3yRrM9nVmESRFRR8+3fyGes2h0hw3tBODySjS76GwoeC
         mgqjJz9ku6S9dqOQ0FLa1uB3ikGmgz1+FN5Hc34Df3/xOSgyPStyT9s/c6tVy5lqm/Dm
         wrR5JPbtMg0a+uVIbBWsEcx7NfL0Tc6edtJgG8sLJjnUujllecnviuvpE7OcIyLaOFJM
         aRmlJzihTWRs1yYmx5QmG/1C+wN8+4/lXcw5G0IVjbBo+eCuGg7Lvyk3pusxjWlYBZuU
         iUrA==
X-Gm-Message-State: AOAM533zyuvoMcED8Xn1WVf0hOCmcm0wfC0VCACUq7aaNyHdisx88aQH
        /+o4FpFAc6BuxMg4Rq18HjGQOKyFtkI=
X-Google-Smtp-Source: ABdhPJylEUA4Yu2JbpJlM2UyLGcpgdWMRO2TMuPIh52PRD13hp2/0XCHfIjyCwPeVowE+LpPLLW30w==
X-Received: by 2002:a05:6830:10d3:: with SMTP id z19mr7253197oto.362.1617287467346;
        Thu, 01 Apr 2021 07:31:07 -0700 (PDT)
Received: from Davids-MacBook-Pro.local ([8.48.134.56])
        by smtp.googlemail.com with ESMTPSA id 38sm1194146oth.14.2021.04.01.07.31.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 01 Apr 2021 07:31:06 -0700 (PDT)
Subject: Re: [RFC] add extack errors for iptoken
To:     Stephen Hemminger <stephen@networkplumber.org>,
        Hongren Zheng <i@zenithal.me>
Cc:     Daniel Borkmann <daniel@iogearbox.net>, netdev@vger.kernel.org
References: <YF80x4bBaXpS4s/W@Sun> <20210331204902.78d87b40@hermes.local>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <2854a1c9-ca3e-312d-c94f-12aea1469bc0@gmail.com>
Date:   Thu, 1 Apr 2021 08:31:05 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.9.0
MIME-Version: 1.0
In-Reply-To: <20210331204902.78d87b40@hermes.local>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/31/21 9:49 PM, Stephen Hemminger wrote:
> @@ -5681,14 +5682,29 @@ static int inet6_set_iftoken(struct inet6_dev *idev, struct in6_addr *token)
>  
>  	ASSERT_RTNL();
>  
> -	if (!token)
> +	if (!token) {

You forgot to add a message here.

>  		return -EINVAL;
> -	if (dev->flags & (IFF_LOOPBACK | IFF_NOARP))
> +	}
> +
> +	if (dev->flags & IFF_LOOPBACK) {
> +		NL_SET_ERR_MSG_MOD(extack, "Device is loopback");
>  		return -EINVAL;
> -	if (!ipv6_accept_ra(idev))
> +	}
> +
> +	if (dev->flags & IFF_NOARP) {
> +		NL_SET_ERR_MSG_MOD(extack, "Device does not do discovery");

'Device does not do neighbor discovery'

>  		return -EINVAL;
> -	if (idev->cnf.rtr_solicits == 0)
> +	}
> +
> +	if (!ipv6_accept_ra(idev)) {
> +		NL_SET_ERR_MSG_MOD(extack, "Device does accept route adverts");

How about
'Router advertisements are disabled for this device'


> +		return -EINVAL;
> +	}
> +
> +	if (idev->cnf.rtr_solicits == 0) {
> +		NL_SET_ERR_MSG(extack, "Device has disabled router solicitation");

How about

'Router solicitation is disabled on device'

