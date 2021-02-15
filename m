Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D572E31B83D
	for <lists+netdev@lfdr.de>; Mon, 15 Feb 2021 12:45:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230090AbhBOLpE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Feb 2021 06:45:04 -0500
Received: from hqnvemgate26.nvidia.com ([216.228.121.65]:4626 "EHLO
        hqnvemgate26.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229988AbhBOLo5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Feb 2021 06:44:57 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate26.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B602a5e8f0001>; Mon, 15 Feb 2021 03:44:15 -0800
Received: from yaviefel (172.20.145.6) by HQMAIL107.nvidia.com (172.20.187.13)
 with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 15 Feb 2021 11:44:12
 +0000
References: <cover.1612815057.git.petrm@nvidia.com>
 <dec388d80b682213ed2897d9f4ae40c2c2dd9eb8.1612815058.git.petrm@nvidia.com>
 <9bd96142-9dce-efb5-8ac6-d4aa62441fa4@gmail.com>
User-agent: mu4e 1.4.10; emacs 27.1
From:   Petr Machata <petrm@nvidia.com>
To:     David Ahern <dsahern@gmail.com>
CC:     Petr Machata <petrm@nvidia.com>, <netdev@vger.kernel.org>,
        David Ahern <dsahern@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        "Jakub Kicinski" <kuba@kernel.org>,
        Ido Schimmel <idosch@nvidia.com>
Subject: Re: [RFC PATCH 04/13] nexthop: Add implementation of resilient
 next-hop groups
In-Reply-To: <9bd96142-9dce-efb5-8ac6-d4aa62441fa4@gmail.com>
Date:   Mon, 15 Feb 2021 12:44:08 +0100
Message-ID: <8735xxblo7.fsf@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [172.20.145.6]
X-ClientProxiedBy: HQMAIL107.nvidia.com (172.20.187.13) To
 HQMAIL107.nvidia.com (172.20.187.13)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1613389455; bh=kHTU6PgBt1AB7f1M3TML7ozkRjfsPBQKuOXliKz09oc=;
        h=References:User-agent:From:To:CC:Subject:In-Reply-To:Date:
         Message-ID:MIME-Version:Content-Type:X-Originating-IP:
         X-ClientProxiedBy;
        b=V7LrpqMlbXrxre/ThlMKhbHsuG4ml4QsiHXIYMoWp4jSHpcspNcdAcn01XqgTmcjx
         /2zA/IrxJHMfltuZ/JBcDWm3i5jkRKDM4s/EIfKIqrSZ8IESndU2XIVkITsNhdwSJK
         +CAfm40xS+2cyryKg3j+aJWOVDFuH0eXBwOfmrG5STVsXXnDBHnWbqEb/eqewpSClC
         L6Ji1eNjLZh1kT6wIjs5wQQnhcFxppWtKMz4vjsT8Ud4LWu5WTNDo85m54zQBFJm7l
         wVSBhw7pOFkvWvzheN1T1tFAsP5dNP67MsJVzlHEnqvfYXxSNkN21xDFq+KI1ZBxUP
         2Qh6PtEmLN1Fw==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


David Ahern <dsahern@gmail.com> writes:

> On 2/8/21 1:42 PM, Petr Machata wrote:
>> @@ -212,7 +254,7 @@ static inline bool nexthop_is_multipath(const struct nexthop *nh)
>>  		struct nh_group *nh_grp;
>>  
>>  		nh_grp = rcu_dereference_rtnl(nh->nh_grp);
>> -		return nh_grp->mpath;
>> +		return nh_grp->mpath || nh_grp->resilient;
>
> That pattern shows up multiple times; since this is datapath, it would
> be worth adding a new bool for it (is_multipath or has_nexthops or
> something else along those lines)

OK.
