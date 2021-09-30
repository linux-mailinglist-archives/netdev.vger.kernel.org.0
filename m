Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4213141D1E0
	for <lists+netdev@lfdr.de>; Thu, 30 Sep 2021 05:33:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347896AbhI3Dfe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Sep 2021 23:35:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53714 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347830AbhI3Dfd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Sep 2021 23:35:33 -0400
Received: from mail-ot1-x330.google.com (mail-ot1-x330.google.com [IPv6:2607:f8b0:4864:20::330])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B1066C06161C
        for <netdev@vger.kernel.org>; Wed, 29 Sep 2021 20:33:51 -0700 (PDT)
Received: by mail-ot1-x330.google.com with SMTP id e66-20020a9d2ac8000000b0054da8bdf2aeso3371951otb.12
        for <netdev@vger.kernel.org>; Wed, 29 Sep 2021 20:33:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=YTI11cKExqGKDSYMABDHyjBOosyGOeHTKgIE6BN28pg=;
        b=kHm0biBYniIjW0BrPkrHjAZdkRXJhK63asL3YI/HL8AvQRXgAz2xktZcdPsb9ao2fU
         OC88aYY21I7XSdDX+Bv1l01rmdpUXGO2sGkvFASee0YWLO7oRD0vb6d19CkifXw/IB9H
         uLGtC7Pod7xDGR/ezWZzwtmRIAoOWCcyb8igwoNYNhS8o9nFHDUt5DU/CSl8WNbzSJF0
         xXs55wyU9hm/8cRHnqouk4/K3vqSauvBdfzxb/mJwK/lz1Bg8oKPVCXpTCturCXc2vfZ
         T2B8faId9APEI0ur/XNgHJzov5Gl6MI7/+z0OeI2YqIxw93n35r43FaTZXbhi9JQM+hF
         EnvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=YTI11cKExqGKDSYMABDHyjBOosyGOeHTKgIE6BN28pg=;
        b=zkHpVaNs0eV44LANUqqYWw4nZqteIwlrxfbLwY+QPzGqSZauGRU5/miKt1pQI8TK0L
         h0yUA2X8hjRUhb/lj5ZGmDC0IuKPnWXaQxn51/3VfkAfG7dMNPQ/Yd7TuuUoBGAiurRf
         fxkwk7VnLPDulWY5AEkgwLVRQVqR0qjfa8I8xoxXmpD5cV8k3sf/9HytvQLm9KeWJkT9
         UldaYZ+FkssIRCT/kjm5M4dMGw7dPvTKwFCil0eVxKSUbB0l79svPf+p+TaWk6WfmEf5
         wYyVZw7CQcgzVbTrwf9oz79AAZT8iHn9PLu12HpbksJ1KKBc8oefSEA02s+utRE0cZpL
         71iA==
X-Gm-Message-State: AOAM531EkJjqh3GZWvlhw5C5CbuFtk49G9qw8kv9aRLgQSXzId5sEklr
        4lup3Angi5kl1JNtfiF+OuE=
X-Google-Smtp-Source: ABdhPJyIhtM8LtkuU/hcnpYv6AMJDWzSN+vUuLutxEUKRgJNuQmuW3WE8Frp5w7Dj4BgcUqolL8a+Q==
X-Received: by 2002:a9d:6a85:: with SMTP id l5mr3272820otq.122.1632972831002;
        Wed, 29 Sep 2021 20:33:51 -0700 (PDT)
Received: from Davids-MacBook-Pro.local ([8.48.134.30])
        by smtp.googlemail.com with ESMTPSA id f61sm349333otf.73.2021.09.29.20.33.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 29 Sep 2021 20:33:50 -0700 (PDT)
Subject: Re: [RFC iproute2-next 03/11] ip: nexthop: add nh struct and a helper
 to parse nhmsg into it
To:     Nikolay Aleksandrov <razor@blackwall.org>, netdev@vger.kernel.org
Cc:     roopa@nvidia.com, donaldsharp72@gmail.com, idosch@idosch.org,
        Nikolay Aleksandrov <nikolay@nvidia.com>
References: <20210929152848.1710552-1-razor@blackwall.org>
 <20210929152848.1710552-4-razor@blackwall.org>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <6b6ddf10-5350-f21e-6eac-04f8e19d4fb3@gmail.com>
Date:   Wed, 29 Sep 2021 21:33:47 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <20210929152848.1710552-4-razor@blackwall.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 9/29/21 9:28 AM, Nikolay Aleksandrov wrote:
> @@ -328,6 +336,93 @@ static void print_nh_res_bucket(FILE *fp, const struct rtattr *res_bucket_attr)
>  	close_json_object();
>  }
>  
> +static void ipnh_destroy_entry(struct nh_entry *nhe)
> +{
> +	if (nhe->nh_encap)
> +		free(nhe->nh_encap);
> +	if (nhe->nh_groups)
> +		free(nhe->nh_groups);
> +}
> +
> +/* parse nhmsg into nexthop entry struct which must be destroyed by
> + * ipnh_destroy_enty when it's not needed anymore
> + */

I'd rather not have 2 functions interpreting the attributes. You should
be able to get print_nexthop to use the parse function and then print
using the nh_entry.


> +static int ipnh_parse_nhmsg(FILE *fp, const struct nhmsg *nhm, int len,
> +			    struct nh_entry *nhe)
> +{
> +	struct rtattr *tb[NHA_MAX+1];
> +	int err = 0;
> +
> +	memset(nhe, 0, sizeof(*nhe));
> +	parse_rtattr_flags(tb, NHA_MAX, RTM_NHA(nhm), len, NLA_F_NESTED);
> +
> +	if (tb[NHA_ID])
> +		nhe->nh_id = rta_getattr_u32(tb[NHA_ID]);
> +
> +	if (tb[NHA_OIF])
> +		nhe->nh_oif = rta_getattr_u32(tb[NHA_OIF]);
> +
> +	if (tb[NHA_GROUP_TYPE])
> +		nhe->nh_grp_type = rta_getattr_u16(tb[NHA_GROUP_TYPE]);
> +
> +	if (tb[NHA_GATEWAY]) {
> +		if (RTA_PAYLOAD(tb[NHA_GATEWAY]) > sizeof(nhe->nh_gateway)) {
> +			fprintf(fp, "<nexthop id %u invalid gateway length %lu>\n",
> +				nhe->nh_id, RTA_PAYLOAD(tb[NHA_GATEWAY]));
> +			err = EINVAL;
> +			goto out_err;
> +		}
> +		nhe->nh_gateway_len = RTA_PAYLOAD(tb[NHA_GATEWAY]);
> +		memcpy(&nhe->nh_gateway, RTA_DATA(tb[NHA_GATEWAY]),
> +		       RTA_PAYLOAD(tb[NHA_GATEWAY]));
> +	}
> +
> +	if (tb[NHA_ENCAP]) {
> +		nhe->nh_encap = malloc(RTA_LENGTH(RTA_PAYLOAD(tb[NHA_ENCAP])));
> +		if (!nhe->nh_encap) {
> +			err = ENOMEM;
> +			goto out_err;
> +		}
> +		memcpy(nhe->nh_encap, tb[NHA_ENCAP],
> +		       RTA_LENGTH(RTA_PAYLOAD(tb[NHA_ENCAP])));
> +		memcpy(&nhe->nh_encap_type, tb[NHA_ENCAP_TYPE],
> +		       sizeof(nhe->nh_encap_type));
> +	}
> +
> +	if (tb[NHA_GROUP]) {
> +		if (!__valid_nh_group_attr(tb[NHA_GROUP])) {
> +			fprintf(fp, "<nexthop id %u invalid nexthop group>",
> +				nhe->nh_id);
> +			err = EINVAL;
> +			goto out_err;
> +		}
> +
> +		nhe->nh_groups = malloc(RTA_PAYLOAD(tb[NHA_GROUP]));
> +		if (!nhe->nh_groups) {
> +			err = ENOMEM;
> +			goto out_err;
> +		}
> +		nhe->nh_groups_cnt = RTA_PAYLOAD(tb[NHA_GROUP]) /
> +				     sizeof(struct nexthop_grp);
> +		memcpy(nhe->nh_groups, RTA_DATA(tb[NHA_GROUP]),
> +		       RTA_PAYLOAD(tb[NHA_GROUP]));
> +	}
> +
> +	nhe->nh_blackhole = !!tb[NHA_BLACKHOLE];
> +	nhe->nh_fdb = !!tb[NHA_FDB];
> +
> +	nhe->nh_family = nhm->nh_family;
> +	nhe->nh_protocol = nhm->nh_protocol;
> +	nhe->nh_scope = nhm->nh_scope;
> +	nhe->nh_flags = nhm->nh_flags;
> +
> +	return 0;
> +
> +out_err:
> +	ipnh_destroy_entry(nhe);
> +	return err;
> +}
> +


