Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0CE14D2F7D
	for <lists+netdev@lfdr.de>; Thu, 10 Oct 2019 19:21:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726827AbfJJRVX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Oct 2019 13:21:23 -0400
Received: from mail-qk1-f195.google.com ([209.85.222.195]:36864 "EHLO
        mail-qk1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726131AbfJJRVW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Oct 2019 13:21:22 -0400
Received: by mail-qk1-f195.google.com with SMTP id u184so6335019qkd.4
        for <netdev@vger.kernel.org>; Thu, 10 Oct 2019 10:21:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=xuvZN0JITodz2dLriQ7w9E3lEap+u/kTKfmALojGiXI=;
        b=pXvR3WdevfThpK6cyxcaeOuvjdw4Z2kJd6T4aFcXn2jmKAeJo74f0Tmk2tKwk6EUdN
         cGCTn5Y/HVU0nmpCGVUM9YI55p/CiuzGU7poiJHq3C5voS1pwmjv2Q18v2uVyPklSrPI
         4EYqI0j5pTpGWTNNA2T/yiT7acrkbCZziLGKS1XW0x27hoiPi4YreBLFCje2gjU9q8Qu
         26JBHgtgJnf6tMzpN7oW3itWRwLSS2KamPJ5U0ANI431FsCOc/q3TDgj1WH+ezdWQ3eQ
         rQz3vySzMofV+CV+o0GallARMOJIB1L9mo3EDGU5TPWH7E1+gexllXrLawymH7wXBobO
         Y0xg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=xuvZN0JITodz2dLriQ7w9E3lEap+u/kTKfmALojGiXI=;
        b=sXK8gNvWtk2GZo5Aj8oMJvfJQ8YZXUdCWWJrTDyC7/mUvDlw+S2RjqBLA8ToAmMcvK
         zV+NEAiERnzcOLxZCDGdpQQJHQ6RsJWeOmy46hT4IoNPdTP9JtRlWyjFH2UQvmWHyab5
         fLF8CP2brUEgje4MypwWlyQYvOObvbP/mgBzY6zJK4LaF4w7c6zzKq6OiCJp7m15DP9T
         qYFppzl611rwgSCGOVfvXTq55fWb2f0ARVThKnBFv86NEKyCe9vpZIbT9zS12zWdNcVH
         4eltsXVjWATlV4fo5fb+3AV49hkYJ6KP8IFa/Hs8ID7LLzUm6stnU2mRqsnA+dhonDut
         R2qQ==
X-Gm-Message-State: APjAAAXm6jKc7HYjAksuxxaCpzYlG5hMeSSGZRJgaNWEPcv1TcV3QHSx
        BaL/euS2KgniR6NoFmI0UlD5OJuLQ9s=
X-Google-Smtp-Source: APXvYqys42xIeFnEN5JmYINrqK78cSzCxgKoo1zagzhJB4sId53ApV4Lp3JoUu8AyzpgxfsZ65rJWA==
X-Received: by 2002:a37:6255:: with SMTP id w82mr10872838qkb.305.1570728080205;
        Thu, 10 Oct 2019 10:21:20 -0700 (PDT)
Received: from cakuba.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id q207sm3254120qke.98.2019.10.10.10.21.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Oct 2019 10:21:19 -0700 (PDT)
Date:   Thu, 10 Oct 2019 10:21:02 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Michal Kubecek <mkubecek@suse.cz>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jiri Pirko <jiri@mellanox.com>,
        Johannes Berg <johannes@sipsolutions.net>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next v2] genetlink: do not parse attributes for
 families with zero maxattr
Message-ID: <20191010102102.3bc8515d@cakuba.netronome.com>
In-Reply-To: <20191010103402.36408E378C@unicorn.suse.cz>
References: <20191010103402.36408E378C@unicorn.suse.cz>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 10 Oct 2019 12:34:02 +0200 (CEST), Michal Kubecek wrote:
> Commit c10e6cf85e7d ("net: genetlink: push attrbuf allocation and parsing
> to a separate function") moved attribute buffer allocation and attribute
> parsing from genl_family_rcv_msg_doit() into a separate function
> genl_family_rcv_msg_attrs_parse() which, unlike the previous code, calls
> __nlmsg_parse() even if family->maxattr is 0 (i.e. the family does its own
> parsing). The parser error is ignored and does not propagate out of
> genl_family_rcv_msg_attrs_parse() but an error message ("Unknown attribute
> type") is set in extack and if further processing generates no error or
> warning, it stays there and is interpreted as a warning by userspace.
> 
> Dumpit requests are not affected as genl_family_rcv_msg_dumpit() bypasses
> the call of genl_family_rcv_msg_doit() if family->maxattr is zero. Do the
> same also in genl_family_rcv_msg_doit().
> 
> Fixes: c10e6cf85e7d ("net: genetlink: push attrbuf allocation and parsing to a separate function")
> Signed-off-by: Michal Kubecek <mkubecek@suse.cz>
> ---
>  net/netlink/genetlink.c | 9 +++++----
>  1 file changed, 5 insertions(+), 4 deletions(-)
> 
> diff --git a/net/netlink/genetlink.c b/net/netlink/genetlink.c
> index ecc2bd3e73e4..1f14e55ad3ad 100644
> --- a/net/netlink/genetlink.c
> +++ b/net/netlink/genetlink.c
> @@ -639,21 +639,23 @@ static int genl_family_rcv_msg_doit(const struct genl_family *family,
>  				    const struct genl_ops *ops,
>  				    int hdrlen, struct net *net)
>  {
> -	struct nlattr **attrbuf;
> +	struct nlattr **attrbuf = NULL;
>  	struct genl_info info;
>  	int err;
>  
>  	if (!ops->doit)
>  		return -EOPNOTSUPP;
>  
> +	if (!family->maxattr)
> +		goto no_attrs;
>  	attrbuf = genl_family_rcv_msg_attrs_parse(family, nlh, extack,
>  						  ops, hdrlen,
>  						  GENL_DONT_VALIDATE_STRICT,
> -						  family->maxattr &&
>  						  family->parallel_ops);
>  	if (IS_ERR(attrbuf))
>  		return PTR_ERR(attrbuf);
>  
> +no_attrs:

The use of a goto statement as a replacement for an if is making me
uncomfortable. 

Looks like both callers of genl_family_rcv_msg_attrs_parse() jump
around it if !family->maxattr and then check the result with IS_ERR().

Would it not make more sense to have genl_family_rcv_msg_attrs_parse()
return NULL if !family->maxattr?

Just wondering, if you guys prefer this version I can apply..

>  	info.snd_seq = nlh->nlmsg_seq;
>  	info.snd_portid = NETLINK_CB(skb).portid;
>  	info.nlhdr = nlh;
> @@ -676,8 +678,7 @@ static int genl_family_rcv_msg_doit(const struct genl_family *family,
>  		family->post_doit(ops, skb, &info);
>  
>  out:
> -	genl_family_rcv_msg_attrs_free(family, attrbuf,
> -				       family->maxattr && family->parallel_ops);
> +	genl_family_rcv_msg_attrs_free(family, attrbuf, family->parallel_ops);
>  
>  	return err;
>  }
