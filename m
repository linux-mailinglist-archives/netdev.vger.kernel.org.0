Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7D50B113FF3
	for <lists+netdev@lfdr.de>; Thu,  5 Dec 2019 12:12:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729240AbfLELM3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Dec 2019 06:12:29 -0500
Received: from mx0b-00191d01.pphosted.com ([67.231.157.136]:15480 "EHLO
        mx0a-00191d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728735AbfLELM3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Dec 2019 06:12:29 -0500
Received: from pps.filterd (m0049459.ppops.net [127.0.0.1])
        by m0049459.ppops.net-00191d01. (8.16.0.42/8.16.0.42) with SMTP id xB5B5IpO001699;
        Thu, 5 Dec 2019 06:12:14 -0500
Received: from tlpd255.enaf.dadc.sbc.com (sbcsmtp3.sbc.com [144.160.112.28])
        by m0049459.ppops.net-00191d01. with ESMTP id 2wpyurgtye-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 05 Dec 2019 06:12:13 -0500
Received: from enaf.dadc.sbc.com (localhost [127.0.0.1])
        by tlpd255.enaf.dadc.sbc.com (8.14.5/8.14.5) with ESMTP id xB5BCCQw094807;
        Thu, 5 Dec 2019 05:12:13 -0600
Received: from zlp30494.vci.att.com (zlp30494.vci.att.com [135.46.181.159])
        by tlpd255.enaf.dadc.sbc.com (8.14.5/8.14.5) with ESMTP id xB5BC6YT094610
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO);
        Thu, 5 Dec 2019 05:12:06 -0600
Received: from zlp30494.vci.att.com (zlp30494.vci.att.com [127.0.0.1])
        by zlp30494.vci.att.com (Service) with ESMTP id 4A1ED4009E83;
        Thu,  5 Dec 2019 11:12:06 +0000 (GMT)
Received: from tlpd252.dadc.sbc.com (unknown [135.31.184.157])
        by zlp30494.vci.att.com (Service) with ESMTP id 2B5134009E89;
        Thu,  5 Dec 2019 11:12:06 +0000 (GMT)
Received: from dadc.sbc.com (localhost [127.0.0.1])
        by tlpd252.dadc.sbc.com (8.14.5/8.14.5) with ESMTP id xB5BC5cE103598;
        Thu, 5 Dec 2019 05:12:06 -0600
Received: from mail.eng.vyatta.net (mail.eng.vyatta.net [10.156.50.82])
        by tlpd252.dadc.sbc.com (8.14.5/8.14.5) with ESMTP id xB5BC0Vr102884;
        Thu, 5 Dec 2019 05:12:00 -0600
Received: from mgillott-7520 (unknown [10.156.47.174])
        by mail.eng.vyatta.net (Postfix) with ESMTPA id DE20C360067;
        Thu,  5 Dec 2019 03:11:58 -0800 (PST)
Message-ID: <1816d96d94ab3705e4b0a9ea79a6b50db71ee474.camel@vyatta.att-mail.com>
Subject: Re: [PATCH ipsec] xfrm: check DST_NOPOLICY as well as DST_NOXFRM
From:   Mark Gillott <mgillott@vyatta.att-mail.com>
To:     nicolas.dichtel@6wind.com, netdev@vger.kernel.org
Cc:     steffen.klassert@secunet.com, herbert@gondor.apana.org.au
Date:   Thu, 05 Dec 2019 11:11:56 +0000
In-Reply-To: <dc657389-aab2-2174-7571-29ebd5972316@6wind.com>
References: <20191204151714.20975-1-mgillott@vyatta.att-mail.com>
         <5a033c2e-dbf3-426a-007c-e7eec85fc3a6@6wind.com>
         <9a0813f2446b0423963d871795e34b3fe99e301d.camel@vyatta.att-mail.com>
         <c050dc8c-eb17-7195-51ed-18de0a270f5b@6wind.com>
         <7ade55872e403c55453033c7122efd28504b3b19.camel@vyatta.att-mail.com>
         <dc657389-aab2-2174-7571-29ebd5972316@6wind.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5-0ubuntu0.18.04.1 
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2019-12-05_03:2019-12-04,2019-12-05 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_policy_notspam policy=outbound_policy score=0 phishscore=0
 adultscore=0 clxscore=1015 priorityscore=1501 bulkscore=0 mlxlogscore=880
 mlxscore=0 lowpriorityscore=0 spamscore=0 suspectscore=0 malwarescore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1910280000 definitions=main-1912050091
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 2019-12-05 at 11:51 +0100, Nicolas Dichtel wrote:
> Le 05/12/2019 à 11:05, Mark Gillott a écrit :
> > On Thu, 2019-12-05 at 09:52 +0100, Nicolas Dichtel wrote:
> > > Le 05/12/2019 à 09:10, Mark Gillott a écrit :
> > > > On Wed, 2019-12-04 at 17:57 +0100, Nicolas Dichtel wrote:
> > > > > Le 04/12/2019 à 16:17, Mark Gillott a écrit :
> > > > > > Before performing a policy bundle lookup, check the
> > > > > > DST_NOPOLICY
> > > > > > option, as well as DST_NOXFRM. That is, skip further
> > > > > > processing
> > > > > > if
> > > > > > either of the disable_policy or disable_xfrm sysctl
> > > > > > attributes
> > > > > > are
> > > > > > set.
> > > > > 
> > > > > Can you elaborate why this change is needed?
> > > > 
> > > > We have a separate DPDK-based dataplane that is responsible for
> > > > all
> > > > IPsec processing - policy handing/encryption/decryption.
> > > > Consequently
> > > > we set the net.ipv[4|6].conf.<if>.disable_policy sysctl to 1
> > > > for
> > > > all
> > > > "interesting" interfaces. That is we want the kernel to ignore
> > > > any
> > > > IPsec policies.
> > > > 
> > > > Despite the above & depending on configuration, we found that
> > > > originating traffic was ending up deep inside XFRM where it
> > > > would
> > > > get
> > > > dropped because of a route lookup problem.
> > > 
> > > And why don't you set disable_xfrm to thoses interfaces also?
> > > disable_policy means no xfrm policy lookup on output,
> > > disable_xfrm
> > > means no xfrm
> > > policy check on input.
> 
> I inverted them! :/
> disable_policy => no xfrm policy check on input
> disable_xfrm => no xfrm encryption on output
> 
> > > 
> > 
> > True, setting disable_xfrm=1 would solve the issue. Except this is
> > output - the test case is a ping from a peer, the corresponding
> > ICMP
> > response is discarded by the kernel. Feels like disable_policy is
> > the
> > right check (the kernel is doing XFRM output).
> 
> If you don't want to perform xfrm encryption on output, you have to
> set
> disable_xfrm. disable_policy is for input path only.
> 

Alright happy to drop this patch and we'll use disable_xfrm (as well
as/instead of disable_policy).

Many thanks,
Mark

