Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 711553C746E
	for <lists+netdev@lfdr.de>; Tue, 13 Jul 2021 18:24:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229867AbhGMQ1P (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Jul 2021 12:27:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42808 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229437AbhGMQ1N (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Jul 2021 12:27:13 -0400
Received: from mail-ot1-x32e.google.com (mail-ot1-x32e.google.com [IPv6:2607:f8b0:4864:20::32e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0AA6BC0613E9;
        Tue, 13 Jul 2021 09:24:23 -0700 (PDT)
Received: by mail-ot1-x32e.google.com with SMTP id 7-20020a9d0d070000b0290439abcef697so23070278oti.2;
        Tue, 13 Jul 2021 09:24:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=xczKCTyuhtwoZjASSpqKqupD2qvCeMqp8pYEr+GbpNU=;
        b=D7+eSBGkcYe9VJAe//BclzJZaP77VVPBtIXqCryLaHfmOTlOsOUQUhhy1RAeTS7B6P
         6PY910s0Hd46vFDMGWRM4H1rA2MhXvxZp0z65kWIrMFOI9q+JjjLI/qw61Ut3z0MyGem
         WqKFkLr21TK4zvyAM2R6vVJAMHjW7lfsnu5ZoPQRmWjSrM/x4UETCbnx3QMRjBAKoQcH
         du7XKpCvrDdxTEdtCe9Dp/rxjkkNPqYSDUxkHm5EolWpg5WiQ73SrvF/Y4YprLHOo8t3
         wEuBRy21csCxfkTnXbpETZv3bC6a7h4RNa2XgdQoGFoKTocewl87AQOo1e0lJe0Zoeco
         589A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=xczKCTyuhtwoZjASSpqKqupD2qvCeMqp8pYEr+GbpNU=;
        b=MZ4kh5L2vj+05xgAyTNFjNTJ33e+IqSxOK/Mzg0wHuRaAexozsQIFU5zeOpay6+GOr
         NGCsjm7sl2VAb1lBZKfoA0Jsxqr6FLacUKhLvIiG6EjiJ0NeIEMDETZS7yJW6QzR+3kG
         yLoX3XTidK+9DJFU0U7bZK1c8FrMN4rjNC9xexC8bLaFLLgKEI96Lje6asXPrzrrsorh
         HFSkuL5cju8YGqN0MLAgOibi8rS5aaypDSLo8tuR60MoMFq0L0F4tWFq8Y42E+b8/9wi
         X+pbcQSAGYyc1s0IdWGeJdFdw0/BsT8JLdQXqpEb8tWv8BH933sD/NcuZsyPjVMV5YRE
         GcpQ==
X-Gm-Message-State: AOAM532XCYU17YapFjXPEbDiC8VEoLof+xCXYSXbAkjDlf46NnoZCC4b
        Hja0w6lm5eNOczkjdboB66kmJVu3Ia9fdg==
X-Google-Smtp-Source: ABdhPJzTppdsBnWIA1Bvcrk2KcTfjzyz0Kad81Vma9wuL00XsCV/K3wYWyRovp//eCvs/0AUhpprGA==
X-Received: by 2002:a9d:1b41:: with SMTP id l59mr4431102otl.8.1626193462339;
        Tue, 13 Jul 2021 09:24:22 -0700 (PDT)
Received: from Davids-MacBook-Pro.local ([8.48.134.38])
        by smtp.googlemail.com with ESMTPSA id v11sm946831ook.7.2021.07.13.09.24.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 13 Jul 2021 09:24:21 -0700 (PDT)
Subject: Re: [PATCH v2] net: Use nlmsg_unicast() instead of netlink_unicast()
To:     Yajun Deng <yajun.deng@linux.dev>, davem@davemloft.net,
        yoshfuji@linux-ipv6.org, dsahern@kernel.org, kuba@kernel.org,
        mathew.j.martineau@linux.intel.com, matthieu.baerts@tessares.net,
        pablo@netfilter.org, kadlec@netfilter.org, fw@strlen.de,
        vyasevich@gmail.com, nhorman@tuxdriver.com,
        marcelo.leitner@gmail.com, johannes.berg@intel.com, ast@kernel.org,
        yhs@fb.com, 0x7f454c46@gmail.com, aahringo@redhat.com,
        rdunlap@infradead.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        mptcp@lists.linux.dev, netfilter-devel@vger.kernel.org,
        coreteam@netfilter.org, linux-sctp@vger.kernel.org
References: <20210713024824.14359-1-yajun.deng@linux.dev>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <55d96ad0-f9e3-ce17-0f7d-5e4c57faeac3@gmail.com>
Date:   Tue, 13 Jul 2021 10:24:19 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210713024824.14359-1-yajun.deng@linux.dev>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 7/12/21 8:48 PM, Yajun Deng wrote:
> diff --git a/net/ipv4/raw_diag.c b/net/ipv4/raw_diag.c
> index 1b5b8af27aaf..ccacbde30a2c 100644
> --- a/net/ipv4/raw_diag.c
> +++ b/net/ipv4/raw_diag.c
> @@ -119,11 +119,8 @@ static int raw_diag_dump_one(struct netlink_callback *cb,
>  		return err;
>  	}
>  
> -	err = netlink_unicast(net->diag_nlsk, rep,
> -			      NETLINK_CB(in_skb).portid,
> -			      MSG_DONTWAIT);
> -	if (err > 0)
> -		err = 0;
> +	err = nlmsg_unicast(net->diag_nlsk, rep, NETLINK_CB(in_skb).portid);
> +
>  	return err;

can be shortened to:

	return nlmsg_unicast(net->diag_nlsk, rep, NETLINK_CB(in_skb).portid);



other than that it's a good cleanup:

Reviewed-by: David Ahern <dsahern@kernel.org>
