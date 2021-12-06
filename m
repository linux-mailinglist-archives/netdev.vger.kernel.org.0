Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2743D469162
	for <lists+netdev@lfdr.de>; Mon,  6 Dec 2021 09:25:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239167AbhLFI2s (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Dec 2021 03:28:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45248 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239064AbhLFI2r (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Dec 2021 03:28:47 -0500
Received: from mail-wr1-x42c.google.com (mail-wr1-x42c.google.com [IPv6:2a00:1450:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4838AC061746
        for <netdev@vger.kernel.org>; Mon,  6 Dec 2021 00:25:19 -0800 (PST)
Received: by mail-wr1-x42c.google.com with SMTP id c4so20656423wrd.9
        for <netdev@vger.kernel.org>; Mon, 06 Dec 2021 00:25:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=6wind.com; s=google;
        h=reply-to:subject:to:cc:references:from:organization:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=yAdMPsj3JW8Gnm/fmPbwg36Uo5J5cei1mcZu5T2MUfU=;
        b=KdMtYocApG9rREjc1inZ9ROuTU/L12zlTRoSbpjNnlMAAbOAGx4OlsHY1G4a2NkRxD
         i5pzAG+hzKLqknsXPBESLyoZtbYAXbbkuGdEwgsNdH3Y+MndUdVFkGtwNUryA7HwFfUY
         o9VHhlUW7fqJov/Vm6Em7FTFFTfRiHuoCTYW5Hm0HQZGU5au253FMt7pKiQhPrwjafDM
         Fl8PSQr7qU6zVGmhiQ8rwUSQ3IVhjvwMoWF+JSIYirtkxGd1ezLOmDh+Vfu5PwPMmcAZ
         jvNN/i6rwVorTj+AsPsb2uIQPW0yCCoF/5oqYMVwByJpzkfYQNyCn9x6HBAvG4ZAV9FO
         YiIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:subject:to:cc:references:from
         :organization:message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=yAdMPsj3JW8Gnm/fmPbwg36Uo5J5cei1mcZu5T2MUfU=;
        b=lcZhH8VPCQOQ9MPPbTrqXSzXrtI+BAZhPwEhTT33aYezFekIeDXiwdEeehKqzYseve
         APQYj5RE6u6UybtpCx8Hvx6AxJFDP9aIK8PSX+vUFbSTQb6s+PACOSCtl54qM5paaoq1
         k4P+wGJ+/8QtLrqMNVnaull+BALAG0KEql0hDXWAP68E+VHEWdr5cAsDuGuRH+WUAVLp
         QPFKDPU5rnaAMuqwKbV9gF808YW5RBqTjz0eDiITmNqfwn4Emy3Q/d14jDziNUS6JcEu
         l01Wv4eGMkeDrZbokAz+wD46ZvxMCl7ay9D64h+KoRM1baWTs4AhdetjEJgj+4ZZr4UU
         yDdA==
X-Gm-Message-State: AOAM530B76dmPuoXJE+lCtmnsShXLQS/ShiAc0WsMJCfz7qaM7qsbs0C
        9mm5GTgUq9k0vSVG6gEnmHkuq57mP4XA4w==
X-Google-Smtp-Source: ABdhPJzzqJWi6nEF9nTwFi6ViY/PStv6NNgJTwTEJdj0U7owdZuJITGQZYyzNhwGIqAkIhhCl4e/qQ==
X-Received: by 2002:a05:6000:1564:: with SMTP id 4mr42046423wrz.9.1638779117799;
        Mon, 06 Dec 2021 00:25:17 -0800 (PST)
Received: from ?IPv6:2a01:e0a:b41:c160:4164:4f64:6e9c:dacc? ([2a01:e0a:b41:c160:4164:4f64:6e9c:dacc])
        by smtp.gmail.com with ESMTPSA id 38sm11388596wrc.1.2021.12.06.00.25.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 06 Dec 2021 00:25:17 -0800 (PST)
Reply-To: nicolas.dichtel@6wind.com
Subject: Re: [PATCH net-next v5] rtnetlink: Support fine-grained netdevice
 bulk deletion
To:     Lahav Schlesinger <lschlesinger@drivenets.com>,
        netdev@vger.kernel.org
Cc:     kuba@kernel.org, dsahern@gmail.com, nikolay@nvidia.com
References: <20211205093658.37107-1-lschlesinger@drivenets.com>
From:   Nicolas Dichtel <nicolas.dichtel@6wind.com>
Organization: 6WIND
Message-ID: <84166fe9-37f1-2c99-2caf-c68dcc5a370c@6wind.com>
Date:   Mon, 6 Dec 2021 09:25:17 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <20211205093658.37107-1-lschlesinger@drivenets.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Le 05/12/2021 à 10:36, Lahav Schlesinger a écrit :
Some comments below, but please, keep the people who replied to previous
versions of this patch in cc.

[snip]

> diff --git a/include/uapi/linux/if_link.h b/include/uapi/linux/if_link.h
> index eebd3894fe89..68fcde9c0c5e 100644
> --- a/include/uapi/linux/if_link.h
> +++ b/include/uapi/linux/if_link.h
> @@ -348,6 +348,7 @@ enum {
>  	IFLA_PARENT_DEV_NAME,
>  	IFLA_PARENT_DEV_BUS_NAME,
>  
> +	IFLA_IFINDEX,
nit: maybe the previous blank line sit better after this new attribute (and
before __IFLA_MAX)?

>  	__IFLA_MAX
>  };
>  
> diff --git a/net/core/rtnetlink.c b/net/core/rtnetlink.c
> index fd030e02f16d..5165cc699d97 100644
> --- a/net/core/rtnetlink.c
> +++ b/net/core/rtnetlink.c
> @@ -37,6 +37,7 @@
>  #include <linux/pci.h>
>  #include <linux/etherdevice.h>
>  #include <linux/bpf.h>
> +#include <linux/sort.h>
>  
>  #include <linux/uaccess.h>
>  
> @@ -1880,6 +1881,7 @@ static const struct nla_policy ifla_policy[IFLA_MAX+1] = {
>  	[IFLA_PROTO_DOWN_REASON] = { .type = NLA_NESTED },
>  	[IFLA_NEW_IFINDEX]	= NLA_POLICY_MIN(NLA_S32, 1),
>  	[IFLA_PARENT_DEV_NAME]	= { .type = NLA_NUL_STRING },
> +	[IFLA_IFINDEX]		= { .type = NLA_S32 },
Same policy than IFLA_NEW_IFINDEX to refuse negative ifindex.

>  };
>  
>  static const struct nla_policy ifla_info_policy[IFLA_INFO_MAX+1] = {
> @@ -3050,6 +3052,78 @@ static int rtnl_group_dellink(const struct net *net, int group)
>  	return 0;
>  }
>  
> +static int dev_ifindex_cmp(const void *a, const void *b)
> +{
> +	struct net_device * const *dev1 = a, * const *dev2 = b;
> +
> +	return (*dev1)->ifindex - (*dev2)->ifindex;
> +}
> +
> +static int rtnl_ifindex_dellink(struct net *net, struct nlattr *head, int len,
> +				struct netlink_ext_ack *extack)
> +{
> +	int i = 0, num_devices = 0, rem;
> +	struct net_device **dev_list;
> +	const struct nlattr *nla;
> +	LIST_HEAD(list_kill);
> +	int ret;
> +
> +	nla_for_each_attr(nla, head, len, rem) {
> +		if (nla_type(nla) == IFLA_IFINDEX)
> +			num_devices++;
> +	}
> +
> +	dev_list = kmalloc_array(num_devices, sizeof(*dev_list), GFP_KERNEL);
> +	if (!dev_list)
> +		return -ENOMEM;
> +
> +	nla_for_each_attr(nla, head, len, rem) {
> +		const struct rtnl_link_ops *ops;
> +		struct net_device *dev;
> +		int ifindex;
> +
> +		if (nla_type(nla) != IFLA_IFINDEX)
> +			continue;
> +
> +		ifindex = nla_get_s32(nla);
> +		ret = -ENODEV;
> +		dev = __dev_get_by_index(net, ifindex);
> +		if (!dev) {
> +			NL_SET_ERR_MSG_ATTR(extack, nla, "Unknown ifindex");
It would be nice to have the ifindex in the error message. This message does not
give more information than "ENODEV".

> +			goto out_free;
> +		}
> +
> +		ret = -EOPNOTSUPP;
> +		ops = dev->rtnl_link_ops;
> +		if (!ops || !ops->dellink) {
> +			NL_SET_ERR_MSG_ATTR(extack, nla, "Device cannot be deleted");
Same here.


Thank you,
Nicolas
