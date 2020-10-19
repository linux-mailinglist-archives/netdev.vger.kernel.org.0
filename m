Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8B1E929282F
	for <lists+netdev@lfdr.de>; Mon, 19 Oct 2020 15:30:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728047AbgJSNap (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Oct 2020 09:30:45 -0400
Received: from mx0a-00191d01.pphosted.com ([67.231.149.140]:23630 "EHLO
        mx0a-00191d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727297AbgJSNao (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Oct 2020 09:30:44 -0400
Received: from pps.filterd (m0049295.ppops.net [127.0.0.1])
        by m0049295.ppops.net-00191d01. (8.16.0.42/8.16.0.42) with SMTP id 09JC4GIC034612;
        Mon, 19 Oct 2020 08:05:10 -0400
Received: from tlpd255.enaf.dadc.sbc.com (sbcsmtp3.sbc.com [144.160.112.28])
        by m0049295.ppops.net-00191d01. with ESMTP id 348e4h76dp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 19 Oct 2020 08:05:10 -0400
Received: from enaf.dadc.sbc.com (localhost [127.0.0.1])
        by tlpd255.enaf.dadc.sbc.com (8.14.5/8.14.5) with ESMTP id 09JC58Rf051249;
        Mon, 19 Oct 2020 07:05:09 -0500
Received: from zlp30496.vci.att.com (zlp30496.vci.att.com [135.46.181.157])
        by tlpd255.enaf.dadc.sbc.com (8.14.5/8.14.5) with ESMTP id 09JC53gQ051157
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO);
        Mon, 19 Oct 2020 07:05:03 -0500
Received: from zlp30496.vci.att.com (zlp30496.vci.att.com [127.0.0.1])
        by zlp30496.vci.att.com (Service) with ESMTP id A1654403A420;
        Mon, 19 Oct 2020 12:05:03 +0000 (GMT)
Received: from tlpd252.dadc.sbc.com (unknown [135.31.184.157])
        by zlp30496.vci.att.com (Service) with ESMTP id 88A5A4016998;
        Mon, 19 Oct 2020 12:05:03 +0000 (GMT)
Received: from dadc.sbc.com (localhost [127.0.0.1])
        by tlpd252.dadc.sbc.com (8.14.5/8.14.5) with ESMTP id 09JC53KH002202;
        Mon, 19 Oct 2020 07:05:03 -0500
Received: from mail.eng.vyatta.net (mail.eng.vyatta.net [10.156.50.82])
        by tlpd252.dadc.sbc.com (8.14.5/8.14.5) with ESMTP id 09JC4w3o001664;
        Mon, 19 Oct 2020 07:04:58 -0500
Received: from [10.156.47.164] (unknown [10.156.47.164])
        by mail.eng.vyatta.net (Postfix) with ESMTPA id 9F0FF360059;
        Mon, 19 Oct 2020 05:04:27 -0700 (PDT)
Reply-To: mmanning@vyatta.att-mail.com
Subject: Re: Why revert commit 2271c95 ("vrf: mark skb for multicast or
 link-local as enslaved to VRF")?
To:     David Ahern <dsahern@gmail.com>,
        Stephen Suryaputra <ssuryaextr@gmail.com>
Cc:     netdev@vger.kernel.org, sashal@kernel.org
References: <20201018132436.GA11729@ICIPI.localdomain>
 <75fda8c7-adf3-06a4-298f-b75ac6e6969b@gmail.com>
 <20201018160624.GB11729@ICIPI.localdomain>
 <33c7f9b3-aec6-6327-53b3-3b54f74ddcf6@gmail.com>
From:   Mike Manning <mmanning@vyatta.att-mail.com>
Message-ID: <544357d4-1481-8563-323a-addf8b89d9e4@vyatta.att-mail.com>
Date:   Mon, 19 Oct 2020 13:04:26 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <33c7f9b3-aec6-6327-53b3-3b54f74ddcf6@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-10-19_05:2020-10-16,2020-10-19 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_policy_notspam policy=outbound_policy score=0 bulkscore=0
 malwarescore=0 suspectscore=0 spamscore=0 adultscore=0 impostorscore=0
 priorityscore=1501 clxscore=1011 lowpriorityscore=0 mlxlogscore=999
 mlxscore=0 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2010190087
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 19/10/2020 02:53, David Ahern wrote:
> On 10/18/20 10:06 AM, Stephen Suryaputra wrote:
>> $ git --no-pager show afed1a4
>>
>> commit afed1a4dbb76c81900f10fd77397fb91ad442702
>> Author: Sasha Levin <sashal@kernel.org>
>> Date:   Mon Mar 23 16:21:31 2020 -0400
>>
>>     Revert "vrf: mark skb for multicast or link-local as enslaved to VRF"
>>     
>>     This reverts commit 2271c9500434af2a26b2c9eadeb3c0b075409fb5.
>>     
>>     This patch shouldn't have been backported to 4.14.
>>     
>>     Signed-off-by: Sasha Levin <sashal@kernel.org>
>>
> My response last November was:
>
> 'backporting this patch and it's bug fix, "ipv6: Fix handling of LLA
> with VRF and sockets bound to VRF" to 4.14 is a bit questionable. They
> definitely do not need to come back to 4.9.'
>
> Basically, my point is that this is work that was committed to 4.19-next
> I believe and given the state of the VRF feature over the releases, I
> could not confirm for 4.14 that everything works as intended. Hence, the
> comment about it being questionable.
>
> If you / your company are actively using and testing VRF on 4.14 and can
> confirm it works, then I am fine with the patch (and its bugfix) getting
> applied.

Hi,

This fix is part of a series "vrf: allow simultaneous service instances
in default and other VRFs" that is present in 5.x kernels and should not
be used in isolation.

But it was at a later stage erroneously backported as a standalone fix
(without the rest of the series) to 4.14 and 4.19.

So it was reverted from these kernels, especially as it was causing this
regression:

VRF: All router multicast entry(FF02:2) not added to VRF Dev but added
on VLAN Dev

Sorry for any inconvenience.

Thanks, Mike



