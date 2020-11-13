Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D52EB2B1415
	for <lists+netdev@lfdr.de>; Fri, 13 Nov 2020 03:00:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726134AbgKMCAI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Nov 2020 21:00:08 -0500
Received: from mx0a-00190b01.pphosted.com ([67.231.149.131]:17856 "EHLO
        mx0a-00190b01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726041AbgKMCAH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Nov 2020 21:00:07 -0500
Received: from pps.filterd (m0050095.ppops.net [127.0.0.1])
        by m0050095.ppops.net-00190b01. (8.16.0.42/8.16.0.42) with SMTP id 0AD1wYbn009542;
        Fri, 13 Nov 2020 01:59:05 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=akamai.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=jan2016.eng;
 bh=urGlG8FK0LuiIFPiv1vlATrci5jDs6XTpV0W0cyQ4os=;
 b=TH77c1Vk53fynD0pszR0u///Yk0Q6Us7TJhatTXyHAxiP952u8St97I4UJQCahxWr3xf
 deAGHlUNVavGrJG/xsC9OX+PwSCpnseYVQuG4y8eJ1Xnfetg4X9xe7CfUBRxV+4fuoiR
 ua+chJhNzvmmg+HHe0RUsXTWe1lWAN5Q5R0l25dkwQA9UeGcDT+J+/YphrmXfcJ2l9zj
 MIXZCTuvadLEWD8d5rKQ4lMW44A3ljdvi2qTLAWqYclSFy+WghOWBYKVAx4k0wloA49q
 LdklpWZ2bBG9J248vCYN8C1Ghujq2u/pKdTXW5dQzaOzqFxf/ohTlNUWQsldwiz1x1ym Nw== 
Received: from prod-mail-ppoint4 (a72-247-45-32.deploy.static.akamaitechnologies.com [72.247.45.32] (may be forged))
        by m0050095.ppops.net-00190b01. with ESMTP id 34nm0kmae0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 13 Nov 2020 01:59:05 +0000
Received: from pps.filterd (prod-mail-ppoint4.akamai.com [127.0.0.1])
        by prod-mail-ppoint4.akamai.com (8.16.0.42/8.16.0.42) with SMTP id 0AD1ns4a032195;
        Thu, 12 Nov 2020 20:59:04 -0500
Received: from prod-mail-relay18.dfw02.corp.akamai.com ([172.27.165.172])
        by prod-mail-ppoint4.akamai.com with ESMTP id 34nqt477s1-1;
        Thu, 12 Nov 2020 20:59:04 -0500
Received: from [0.0.0.0] (unknown [172.27.113.23])
        by prod-mail-relay18.dfw02.corp.akamai.com (Postfix) with ESMTP id 378EB52F;
        Fri, 13 Nov 2020 01:59:04 +0000 (GMT)
Subject: Re: [PATCH net V3] Exempt multicast addresses from five-second
 neighbor lifetime
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, David Ahern <dsahern@gmail.com>
References: <20201110172305.28056-1-jdike@akamai.com>
 <20201112093225.447edf7b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Jeff Dike <jdike@akamai.com>
Message-ID: <7f3d2fa6-b17b-91b9-d47c-c5e14edcced5@akamai.com>
Date:   Thu, 12 Nov 2020 20:59:03 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20201112093225.447edf7b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-11-12_16:2020-11-12,2020-11-12 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 bulkscore=0
 mlxlogscore=999 suspectscore=0 malwarescore=0 phishscore=0 mlxscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2011130008
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-11-12_16:2020-11-12,2020-11-12 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 spamscore=0
 impostorscore=0 priorityscore=1501 bulkscore=0 phishscore=0 suspectscore=0
 malwarescore=0 lowpriorityscore=0 mlxscore=0 adultscore=0 clxscore=1015
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2011130009
X-Agari-Authentication-Results: mx.akamai.com; spf=${SPFResult} (sender IP is 72.247.45.32)
 smtp.mailfrom=jdike@akamai.com smtp.helo=prod-mail-ppoint4
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Jakub,

Yes to all your suggestions.

Thanks for the review.

Jeff

On 11/12/20 12:32 PM, Jakub Kicinski wrote:
> On Tue, 10 Nov 2020 12:23:05 -0500 Jeff Dike wrote:
>> Commit 58956317c8de ("neighbor: Improve garbage collection")
>> guarantees neighbour table entries a five-second lifetime.  Processes
>> which make heavy use of multicast can fill the neighour table with
>> multicast addresses in five seconds.  At that point, neighbour entries
>> can't be GC-ed because they aren't five seconds old yet, the kernel
>> log starts to fill up with "neighbor table overflow!" messages, and
>> sends start to fail.
>>
>> This patch allows multicast addresses to be thrown out before they've
>> lived out their five seconds.  This makes room for non-multicast
>> addresses and makes messages to all addresses more reliable in these
>> circumstances.
> 
> We should add 
> 
> Fixes: 58956317c8de ("neighbor: Improve garbage collection")
> 
> right?
> 
>> Signed-off-by: Jeff Dike <jdike@akamai.com>
> 
>> diff --git a/net/ipv4/arp.c b/net/ipv4/arp.c
>> index 687971d83b4e..097aa8bf07ee 100644
>> --- a/net/ipv4/arp.c
>> +++ b/net/ipv4/arp.c
>> @@ -125,6 +125,7 @@ static int arp_constructor(struct neighbour *neigh);
>>  static void arp_solicit(struct neighbour *neigh, struct sk_buff *skb);
>>  static void arp_error_report(struct neighbour *neigh, struct sk_buff *skb);
>>  static void parp_redo(struct sk_buff *skb);
>> +static int arp_is_multicast(const void *pkey);
>>  
>>  static const struct neigh_ops arp_generic_ops = {
>>  	.family =		AF_INET,
>> @@ -156,6 +157,7 @@ struct neigh_table arp_tbl = {
>>  	.key_eq		= arp_key_eq,
>>  	.constructor	= arp_constructor,
>>  	.proxy_redo	= parp_redo,
>> +	.is_multicast   = arp_is_multicast,
> 
> extreme nit pick - please align the = sign using tabs like the
> surrounding code does.
> 
>>  	.id		= "arp_cache",
>>  	.parms		= {
>>  		.tbl			= &arp_tbl,
>> @@ -928,6 +930,10 @@ static void parp_redo(struct sk_buff *skb)
>>  	arp_process(dev_net(skb->dev), NULL, skb);
>>  }
>>  
>> +static int arp_is_multicast(const void *pkey)
>> +{
>> +	return ipv4_is_multicast(*((__be32 *)pkey));
>> +}
>>  
>>  /*
>>   *	Receive an arp request from the device layer.
>> diff --git a/net/ipv6/ndisc.c b/net/ipv6/ndisc.c
>> index 27f29b957ee7..67457cfadcd2 100644
>> --- a/net/ipv6/ndisc.c
>> +++ b/net/ipv6/ndisc.c
>> @@ -81,6 +81,7 @@ static void ndisc_error_report(struct neighbour *neigh, struct sk_buff *skb);
>>  static int pndisc_constructor(struct pneigh_entry *n);
>>  static void pndisc_destructor(struct pneigh_entry *n);
>>  static void pndisc_redo(struct sk_buff *skb);
>> +static int ndisc_is_multicast(const void *pkey);
>>  
>>  static const struct neigh_ops ndisc_generic_ops = {
>>  	.family =		AF_INET6,
>> @@ -115,6 +116,7 @@ struct neigh_table nd_tbl = {
>>  	.pconstructor =	pndisc_constructor,
>>  	.pdestructor =	pndisc_destructor,
>>  	.proxy_redo =	pndisc_redo,
>> +	.is_multicast = ndisc_is_multicast,
> 
> looks like the character after = is expected to be a tab, for better or
> worse
> 
>>  	.allow_add  =   ndisc_allow_add,
>>  	.id =		"ndisc_cache",
>>  	.parms = {
>> @@ -1706,6 +1708,11 @@ static void pndisc_redo(struct sk_buff *skb)
>>  	kfree_skb(skb);
>>  }
>>  
>> +static int ndisc_is_multicast(const void *pkey)
>> +{
>> +	return ipv6_addr_is_multicast((struct in6_addr *)pkey);
>> +}
>> +
>>  static bool ndisc_suppress_frag_ndisc(struct sk_buff *skb)
>>  {
>>  	struct inet6_dev *idev = __in6_dev_get(skb->dev);
> 
