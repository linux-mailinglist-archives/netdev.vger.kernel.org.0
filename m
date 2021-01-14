Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 673CC2F5CA1
	for <lists+netdev@lfdr.de>; Thu, 14 Jan 2021 09:53:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727683AbhANIui (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Jan 2021 03:50:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48332 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727653AbhANIuh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Jan 2021 03:50:37 -0500
Received: from mail-wr1-x42d.google.com (mail-wr1-x42d.google.com [IPv6:2a00:1450:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6728C061575
        for <netdev@vger.kernel.org>; Thu, 14 Jan 2021 00:49:51 -0800 (PST)
Received: by mail-wr1-x42d.google.com with SMTP id d26so4859048wrb.12
        for <netdev@vger.kernel.org>; Thu, 14 Jan 2021 00:49:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=6wind.com; s=google;
        h=reply-to:subject:to:cc:references:from:organization:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Q6BI4wzIUI1CmnUE/I7AYdI3YACE2q3tnUeqo749Z5I=;
        b=VgRQsyYfkyRSKoxNQjEABaqWvCAFj+MRwcmA59y8HOC1Z0Lu4k87xofr8cz7W5+lr+
         JwlpvH3N2NCoaTACdeHlNa/GoJ3Qs9AHKoMWzPutFFUwR65MaSGeS1iTmrwyU/sdNq/F
         0shIFi/is4wJe5nAFIRGzGeBzrmVw7CfO4f/9xM8owYpKvYPRf1kU6/iz8Ou/wxFtx8K
         2nrRpOwxvGZHgu2DvorujkpXaHqMgl/dn+dE4UTJqnGUBya9w4eLghlSmTe8UQMU/TtP
         4X5VEcY4nuEqO5neaUloKKk5pt+rtQJvZ76HfR2Mcul8ecIaQ80mJbjdYUdNpFN0yMpx
         6bOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:reply-to:subject:to:cc:references:from
         :organization:message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=Q6BI4wzIUI1CmnUE/I7AYdI3YACE2q3tnUeqo749Z5I=;
        b=WFwnUW8IIc3ehFf0JR9yEeyISUkpbLjdFuXsgYPkHBdeegRRxYuG2EpFMRTX1lTkWa
         Kl4nhUha54UnaSLl2eJ7MSdg1C4AIF+fJjECfwtPwGnM/y4pWslvbiTIAm6+zC3tiNv+
         fePd/KUDldTKOo8fbDO5fYxQS+E/fqqVCPpKaDFkoazEeip249uMojL6yIoUAlyWyZaB
         CZpqYxxUNORYFHj7FqE/mLLtuUaG1j+YCL1Sw/0fgDPYxt7ZHp8aaJ7NaZdlWJp6HZxB
         E6kOuXf2fsaHarQj4CxYnhgI7XIN4O9PLPpG618Ph/qly1Vf8rUwVR2RfRDxj3B+2mpi
         DGiQ==
X-Gm-Message-State: AOAM5326qRoJbR24tARrdAp5R463j+uqUF7BB29kseejExgyrlXzmPbd
        bLRoto55gTXq/FMxFPnuzPdKsg==
X-Google-Smtp-Source: ABdhPJxGKXC/GuWzj3B5eGO6jDA4ECH1JOm2tsbJUwqmRCX+C8xPFg846aCOprvIYwIEu2AABVh/yA==
X-Received: by 2002:adf:ef8b:: with SMTP id d11mr6826842wro.156.1610614190435;
        Thu, 14 Jan 2021 00:49:50 -0800 (PST)
Received: from ?IPv6:2a01:e0a:410:bb00:bdf0:d24a:73d7:779b? ([2a01:e0a:410:bb00:bdf0:d24a:73d7:779b])
        by smtp.gmail.com with ESMTPSA id x17sm8330407wro.40.2021.01.14.00.49.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 14 Jan 2021 00:49:49 -0800 (PST)
Reply-To: nicolas.dichtel@6wind.com
Subject: Re: [PATCH net] net: sit: unregister_netdevice on newlink's error
 path
To:     Jakub Kicinski <kuba@kernel.org>, davem@davemloft.net
Cc:     netdev@vger.kernel.org,
        syzbot+2393580080a2da190f04@syzkaller.appspotmail.com
References: <20210114012947.2515313-1-kuba@kernel.org>
From:   Nicolas Dichtel <nicolas.dichtel@6wind.com>
Organization: 6WIND
Message-ID: <f7ddd59c-8446-4771-c1a6-c58819d5bcdb@6wind.com>
Date:   Thu, 14 Jan 2021 09:49:48 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20210114012947.2515313-1-kuba@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Le 14/01/2021 à 02:29, Jakub Kicinski a écrit :
[snip]
> --- a/net/ipv6/sit.c
> +++ b/net/ipv6/sit.c
> @@ -1645,8 +1645,11 @@ static int ipip6_newlink(struct net *src_net, struct net_device *dev,
>  	}
>  
>  #ifdef CONFIG_IPV6_SIT_6RD
> -	if (ipip6_netlink_6rd_parms(data, &ip6rd))
> +	if (ipip6_netlink_6rd_parms(data, &ip6rd)) {
>  		err = ipip6_tunnel_update_6rd(nt, &ip6rd);
> +		if (err)
nit: I would prefer 'if (err < 0)' to be consistent with the rest of the sit
code, but it's purely aesthetic (ipip6_tunnel_update_6rd() returns a negative
value or 0).

With or without this:
Acked-by: Nicolas Dichtel <nicolas.dichtel@6wind.com>

> +			unregister_netdevice_queue(dev, NULL);
> +	}
>  #endif
>  
>  	return err;
> 
