Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 768062A35C
	for <lists+netdev@lfdr.de>; Sat, 25 May 2019 10:11:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726395AbfEYILK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 25 May 2019 04:11:10 -0400
Received: from mx0a-00191d01.pphosted.com ([67.231.149.140]:46472 "EHLO
        mx0a-00191d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726256AbfEYILK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 25 May 2019 04:11:10 -0400
X-Greylist: delayed 3647 seconds by postgrey-1.27 at vger.kernel.org; Sat, 25 May 2019 04:11:09 EDT
Received: from pps.filterd (m0053301.ppops.net [127.0.0.1])
        by mx0a-00191d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x4P74Xs4024810;
        Sat, 25 May 2019 03:09:53 -0400
Received: from tlpd255.enaf.dadc.sbc.com (sbcsmtp3.sbc.com [144.160.112.28])
        by mx0a-00191d01.pphosted.com with ESMTP id 2spysas4yt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sat, 25 May 2019 03:09:53 -0400
Received: from enaf.dadc.sbc.com (localhost [127.0.0.1])
        by tlpd255.enaf.dadc.sbc.com (8.14.5/8.14.5) with ESMTP id x4P79pD8102047;
        Sat, 25 May 2019 02:09:52 -0500
Received: from zlp30496.vci.att.com (zlp30496.vci.att.com [135.46.181.157])
        by tlpd255.enaf.dadc.sbc.com (8.14.5/8.14.5) with ESMTP id x4P79hNU101901
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO);
        Sat, 25 May 2019 02:09:43 -0500
Received: from zlp30496.vci.att.com (zlp30496.vci.att.com [127.0.0.1])
        by zlp30496.vci.att.com (Service) with ESMTP id 4F3B14009E8B;
        Sat, 25 May 2019 07:09:43 +0000 (GMT)
Received: from tlpd252.dadc.sbc.com (unknown [135.31.184.157])
        by zlp30496.vci.att.com (Service) with ESMTP id 3915D4014CA0;
        Sat, 25 May 2019 07:09:43 +0000 (GMT)
Received: from dadc.sbc.com (localhost [127.0.0.1])
        by tlpd252.dadc.sbc.com (8.14.5/8.14.5) with ESMTP id x4P79hES039361;
        Sat, 25 May 2019 02:09:43 -0500
Received: from mail.eng.vyatta.net (mail.eng.vyatta.net [10.156.50.82])
        by tlpd252.dadc.sbc.com (8.14.5/8.14.5) with ESMTP id x4P79atU039172;
        Sat, 25 May 2019 02:09:37 -0500
Received: from debian10.local (unknown [10.156.48.137])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.eng.vyatta.net (Postfix) with ESMTPSA id A15BF360060;
        Sat, 25 May 2019 00:09:34 -0700 (PDT)
Date:   Sat, 25 May 2019 08:09:24 +0100
From:   George Wilkie <gwilkie@vyatta.att-mail.com>
To:     David Ahern <dsahern@gmail.com>
Cc:     Shrijeet Mukherjee <shrijeet@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        netdev@vger.kernel.org
Subject: Re: [PATCH net-next] vrf: local route leaking
Message-ID: <20190525070924.GA1184@debian10.local>
References: <20190524080551.754-1-gwilkie@vyatta.att-mail.com>
 <0d920356-8d12-b0b5-c14b-3600e54e9390@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0d920356-8d12-b0b5-c14b-3600e54e9390@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-05-25_04:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_policy_notspam policy=outbound_policy score=0
 priorityscore=1501 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0
 spamscore=0 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1905250049
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, May 24, 2019 at 02:19:45PM -0600, David Ahern wrote:
> I think this codifies the use case:
>   ip li add vrf-a up type vrf table 1
>   ip route add vrf vrf-a unreachable default
>   ip li add vrf-b up type vrf table 2
>   ip route add vrf vrf-b unreachable default
>   ip ru add pref 32765 from all lookup local
>   ip ru del pref 0
> 
>   ip netns add foo
>   ip li add veth1 type veth peer name veth11 netns foo
>   ip addr add dev veth1 10.1.1.1/24
>   ip li set veth1 vrf vrf-b up
>   ip -netns foo li set veth11 up
>   ip -netns foo addr add dev veth11 10.1.1.11/24
>   ip -netns foo ro add 10.1.2.0/24 via 10.1.1.1
> 
>   ip netns add bar
>   ip li add veth2 type veth peer name veth12 netns bar
>   ip li set veth2 vrf vrf-a up
>   ip addr add dev veth2 10.1.2.1/24
>   ip -netns bar li set veth12 up
>   ip -netns bar addr add dev veth12 10.1.2.12/24

Although I'm not using namespaces:
   ip link add vrfA type vrf table 256
   ip link set dev vrfA up
   ip route add table 256 unreachable default metric 4278198272
   ip link set dev ens4 master vrfA
   ip address add 10.10.2.9/24 dev ens4
   ip link set dev ens4 up

   ip link add vrfB type vrf table 257
   ip link set dev vrfB up
   ip route add table 257 unreachable default metric 4278198272
   ip link set dev ens5 master vrfB
   ip address add 10.10.3.9/24 dev ens5
   ip link set dev ens5 up

> 
> If you do route leaking this way:
>   ip ro add vrf vrf-b 10.1.2.0/24 dev veth2
>   ip ro add vrf vrf-a 10.1.1.0/24 dev veth1
> 
> yes, you hit problems trying to connect to a local address.
> 
> If you do route leaking this way:
>   ip ro add vrf vrf-b 10.1.2.0/24 dev vrf-a
>   ip ro add vrf vrf-a 10.1.1.0/24 dev vrf-b
> 
> you do not.
> 

That was my initial thought, although it needs a 2nd lookup.
The problem I hit though was I couldn't figure out how to make it work
when leaking from global into a VRF. I couldn't see how to indicate
a lookup in the global table.  Is there a way to do this?
Using a loopback doesn't work, e.g. if 10.1.1.0/24 was on a global interface:
   ip ro add vrf vrf-a 10.1.1.0/24 dev lo

It seemed if something new was needed, leaking the locals was neater approach?

Thanks.

