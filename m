Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 009B3351B1
	for <lists+netdev@lfdr.de>; Tue,  4 Jun 2019 23:13:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726341AbfFDVNm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Jun 2019 17:13:42 -0400
Received: from mail-pl1-f196.google.com ([209.85.214.196]:42232 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726033AbfFDVNm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Jun 2019 17:13:42 -0400
Received: by mail-pl1-f196.google.com with SMTP id go2so8820424plb.9
        for <netdev@vger.kernel.org>; Tue, 04 Jun 2019 14:13:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=+MRGJM1MvQ+pLJ5XQXRpKmgJ7MXywui6RZlLpsprORM=;
        b=LEMunEYiqangjshc3eHo3Jy1vdvL7YeoosBbdV9ssK8xSiZVCogPMxrUzJNNgUVQnB
         2SEWqKvYmnoNOQvY8pTx+bJRwtueEq6DFHJpEAbAJSJDqxLIEH9/lfbOzo1SGFQVvEnE
         bRWTlwZafSpCte1cUsqCJNUecIfxhydC5e/35if/oVyGoSP9QRvUtFUCQa9hJt7jTV7W
         TFfbzjxDmK7XHot0pY9INUbvpE2jupKEYYwSd3Vv3hsoc85btTg6KDctBsvTGXUNr6li
         aVCF/1N7KZPAgBSzVDtItC8BrUc55ADnBsYt74mN2zz8sgGPJtuH9aoJ9JsRE1zOCeL5
         0U+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=+MRGJM1MvQ+pLJ5XQXRpKmgJ7MXywui6RZlLpsprORM=;
        b=qenjkr1Afkx4rlcoR1TDJgMJUMEeQlYPuZ+F/GRDC+QVXzzf8EinxNC89nhq5w+JfP
         7xtrRk4ATnahE8gj1bG1gjdG0YBSv0voch1+tcOZdGpg26ROUCaEeXCskUusaevn5rrl
         jZ2bq1B3Oml35Stk28yaempfue7YIrtvxlOvOawriVkUeIM4rQmZcX8ip006eMbobW/M
         salnOOumLn9oOTspZoQvcpEZY37PXOHt5AZVoLKS9Omy2COJhB/kwX5Y+25cQTW9eRIP
         jOJoTArar/yp+rVO6Jr+NLF2VIW93c1bqi02/tcNjU+n+0fe8O+axPduPa9OUf1cBlL9
         NuKA==
X-Gm-Message-State: APjAAAUIBSNID8gtNTimmjNPlijXRgCwpQvcOKnywNwsU5muOscosx8i
        tE1sVmTfjyIMkhn7f7nH6C0=
X-Google-Smtp-Source: APXvYqy0YywLKrbudFTr9rVTGjoewHQ8v+1NF2NbVbzZOWJXgkbZYwSZhk+2r1mFH4+4wR/OfcXp1g==
X-Received: by 2002:a17:902:e30e:: with SMTP id cg14mr17266964plb.47.1559682821402;
        Tue, 04 Jun 2019 14:13:41 -0700 (PDT)
Received: from [172.27.227.186] ([216.129.126.118])
        by smtp.googlemail.com with ESMTPSA id x129sm16583326pfb.29.2019.06.04.14.13.39
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 04 Jun 2019 14:13:40 -0700 (PDT)
Subject: Re: [PATCH v2 net-next 4/7] ipv6: Plumb support for nexthop object in
 a fib6_info
To:     Martin Lau <kafai@fb.com>
Cc:     Wei Wang <weiwan@google.com>, David Ahern <dsahern@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        "idosch@mellanox.com" <idosch@mellanox.com>,
        "saeedm@mellanox.com" <saeedm@mellanox.com>
References: <CAEA6p_AgK08iXuSBbMDqzatGaJj_UFbNWiBV-dQp2r-Y71iesw@mail.gmail.com>
 <dec5c727-4002-913f-a858-362e0d926b8d@gmail.com>
 <CAEA6p_Aa2eV+jH=H9iOqepbrBLBUvAg2-_oD96wA0My6FMG_PQ@mail.gmail.com>
 <5263d3ae-1865-d935-cb03-f6dfd4604d15@gmail.com>
 <CAEA6p_CixzdRNUa46YZusFg-37MFAVqQ8D09rxVU5Nja6gO1SA@mail.gmail.com>
 <4cdcdf65-4d34-603e-cb21-d649b399d760@gmail.com>
 <20190604005840.tiful44xo34lpf6d@kafai-mbp.dhcp.thefacebook.com>
 <453565b0-d08a-be96-3cd7-5608d4c21541@gmail.com>
 <20190604052929.4mlxa5sswm46mwrq@kafai-mbp.dhcp.thefacebook.com>
 <c7fb6999-16a2-001d-8e9a-ac44ed9e9fa2@gmail.com>
 <20190604210619.kq5jnkinak7izn2u@kafai-mbp.dhcp.thefacebook.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <0c307c47-4cde-1e55-8168-356b2ef30298@gmail.com>
Date:   Tue, 4 Jun 2019 15:13:38 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:52.0)
 Gecko/20100101 Thunderbird/52.9.1
MIME-Version: 1.0
In-Reply-To: <20190604210619.kq5jnkinak7izn2u@kafai-mbp.dhcp.thefacebook.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 6/4/19 3:06 PM, Martin Lau wrote:
> On Tue, Jun 04, 2019 at 02:17:28PM -0600, David Ahern wrote:
>> On 6/3/19 11:29 PM, Martin Lau wrote:
>>> On Mon, Jun 03, 2019 at 07:36:06PM -0600, David Ahern wrote:
>>>> On 6/3/19 6:58 PM, Martin Lau wrote:
>>>>> I have concern on calling ip6_create_rt_rcu() in general which seems
>>>>> to trace back to this commit
>>>>> dec9b0e295f6 ("net/ipv6: Add rt6_info create function for ip6_pol_route_lookup")
>>>>>
>>>>> This rt is not tracked in pcpu_rt, rt6_uncached_list or exception bucket.
>>>>> In particular, how to react to NETDEV_UNREGISTER/DOWN like
>>>>> the rt6_uncached_list_flush_dev() does and calls dev_put()?
>>>>>
>>>>> The existing callers seem to do dst_release() immediately without
>>>>> caching it, but still concerning.
>>>>
>>>> those are the callers that don't care about the dst_entry, but are
>>>> forced to deal with it. Removing the tie between fib lookups an
>>>> dst_entry is again the right solution.
>>> Great to know that there will be a solution.  It would be great
>>> if there is patch (or repo) to show how that may look like on
>>> those rt6_lookup() callers.
>>
>> Not 'will be', 'there is' a solution now. Someone just needs to do the
>> conversions and devise the tests for the impacted users.
> I don't think everyone will convert to the new nexthop solution
> immediately.
> 
> How about ensuring the existing usage stays solid first?

Use of nexthop objects has nothing to do with separating fib lookups
from dst_entries, but with the addition of fib6_result it Just Works.

Wei converted ipv6 to use exception caches instead of adding them to the
FIB.

I converted ipv6 to use separate data structures for fib entries, added
direct fib6 lookup functions and added fib6_result. See the
net/core/filter.c.

The stage is set for converting users.

For example, ip6_nh_lookup_table does not care about the dst entry, only
the fib entry. This converts it:

static int ip6_nh_lookup_table(struct net *net, struct fib6_config *cfg,
                               const struct in6_addr *gw_addr, u32 tbid,
                               int flags, struct fib6_result *res)
{
        struct flowi6 fl6 = {
                .flowi6_oif = cfg->fc_ifindex,
                .daddr = *gw_addr,
                .saddr = cfg->fc_prefsrc,
        };
        struct fib6_table *table;
        struct rt6_info *rt;

        table = fib6_get_table(net, tbid);
        if (!table)
                return -EINVAL;

        if (!ipv6_addr_any(&cfg->fc_prefsrc))
                flags |= RT6_LOOKUP_F_HAS_SADDR;

        flags |= RT6_LOOKUP_F_IGNORE_LINKSTATE;

        fib6_table_lookup(net, table, cfg->fc_ifindex, fl6, res, flags);
        if (res.f6i == net->ipv6.fib6_null_entry)
                return -ENETUNREACH;

        fib6_select_path(net, &res, fl6, oif, false, NULL, flags);

        return 0;
}
