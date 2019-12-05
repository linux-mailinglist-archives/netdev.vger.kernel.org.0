Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A2B6A1141DB
	for <lists+netdev@lfdr.de>; Thu,  5 Dec 2019 14:45:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729558AbfLENp1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Dec 2019 08:45:27 -0500
Received: from mx0a-00191d01.pphosted.com ([67.231.149.140]:53304 "EHLO
        mx0a-00191d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729549AbfLENp1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Dec 2019 08:45:27 -0500
X-Greylist: delayed 13163 seconds by postgrey-1.27 at vger.kernel.org; Thu, 05 Dec 2019 08:45:26 EST
Received: from pps.filterd (m0049287.ppops.net [127.0.0.1])
        by m0049287.ppops.net-00191d01. (8.16.0.42/8.16.0.42) with SMTP id xB59tkIT006666;
        Thu, 5 Dec 2019 05:05:53 -0500
Received: from tlpd255.enaf.dadc.sbc.com (sbcsmtp3.sbc.com [144.160.112.28])
        by m0049287.ppops.net-00191d01. with ESMTP id 2wpxu0s0tn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 05 Dec 2019 05:05:53 -0500
Received: from enaf.dadc.sbc.com (localhost [127.0.0.1])
        by tlpd255.enaf.dadc.sbc.com (8.14.5/8.14.5) with ESMTP id xB5A5p62097842;
        Thu, 5 Dec 2019 04:05:52 -0600
Received: from zlp30499.vci.att.com (zlp30499.vci.att.com [135.46.181.149])
        by tlpd255.enaf.dadc.sbc.com (8.14.5/8.14.5) with ESMTP id xB5A5k5L097699
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO);
        Thu, 5 Dec 2019 04:05:46 -0600
Received: from zlp30499.vci.att.com (zlp30499.vci.att.com [127.0.0.1])
        by zlp30499.vci.att.com (Service) with ESMTP id 59F9F4009E6E;
        Thu,  5 Dec 2019 10:05:46 +0000 (GMT)
Received: from tlpd252.dadc.sbc.com (unknown [135.31.184.157])
        by zlp30499.vci.att.com (Service) with ESMTP id 474D84009E6D;
        Thu,  5 Dec 2019 10:05:46 +0000 (GMT)
Received: from dadc.sbc.com (localhost [127.0.0.1])
        by tlpd252.dadc.sbc.com (8.14.5/8.14.5) with ESMTP id xB5A5k3g042040;
        Thu, 5 Dec 2019 04:05:46 -0600
Received: from mail.eng.vyatta.net (mail.eng.vyatta.net [10.156.50.82])
        by tlpd252.dadc.sbc.com (8.14.5/8.14.5) with ESMTP id xB5A5bn4039126;
        Thu, 5 Dec 2019 04:05:37 -0600
Received: from mgillott-7520 (unknown [10.156.47.174])
        by mail.eng.vyatta.net (Postfix) with ESMTPA id BB5B5360168;
        Thu,  5 Dec 2019 02:05:35 -0800 (PST)
Message-ID: <7ade55872e403c55453033c7122efd28504b3b19.camel@vyatta.att-mail.com>
Subject: Re: [PATCH ipsec] xfrm: check DST_NOPOLICY as well as DST_NOXFRM
From:   Mark Gillott <mgillott@vyatta.att-mail.com>
To:     nicolas.dichtel@6wind.com, netdev@vger.kernel.org
Cc:     steffen.klassert@secunet.com, herbert@gondor.apana.org.au
Date:   Thu, 05 Dec 2019 10:05:33 +0000
In-Reply-To: <c050dc8c-eb17-7195-51ed-18de0a270f5b@6wind.com>
References: <20191204151714.20975-1-mgillott@vyatta.att-mail.com>
         <5a033c2e-dbf3-426a-007c-e7eec85fc3a6@6wind.com>
         <9a0813f2446b0423963d871795e34b3fe99e301d.camel@vyatta.att-mail.com>
         <c050dc8c-eb17-7195-51ed-18de0a270f5b@6wind.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5-0ubuntu0.18.04.1 
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2019-12-05_02:2019-12-04,2019-12-05 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_policy_notspam policy=outbound_policy score=0 mlxscore=0
 suspectscore=0 mlxlogscore=999 priorityscore=1501 spamscore=0
 impostorscore=0 bulkscore=0 malwarescore=0 clxscore=1015
 lowpriorityscore=0 phishscore=0 adultscore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.12.0-1910280000
 definitions=main-1912050080
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 2019-12-05 at 09:52 +0100, Nicolas Dichtel wrote:
> Le 05/12/2019 à 09:10, Mark Gillott a écrit :
> > On Wed, 2019-12-04 at 17:57 +0100, Nicolas Dichtel wrote:
> > > Le 04/12/2019 à 16:17, Mark Gillott a écrit :
> > > > Before performing a policy bundle lookup, check the
> > > > DST_NOPOLICY
> > > > option, as well as DST_NOXFRM. That is, skip further processing
> > > > if
> > > > either of the disable_policy or disable_xfrm sysctl attributes
> > > > are
> > > > set.
> > > 
> > > Can you elaborate why this change is needed?
> > 
> > We have a separate DPDK-based dataplane that is responsible for all
> > IPsec processing - policy handing/encryption/decryption.
> > Consequently
> > we set the net.ipv[4|6].conf.<if>.disable_policy sysctl to 1 for
> > all
> > "interesting" interfaces. That is we want the kernel to ignore any
> > IPsec policies.
> > 
> > Despite the above & depending on configuration, we found that
> > originating traffic was ending up deep inside XFRM where it would
> > get
> > dropped because of a route lookup problem.
> 
> And why don't you set disable_xfrm to thoses interfaces also?
> disable_policy means no xfrm policy lookup on output, disable_xfrm
> means no xfrm
> policy check on input.
> 

True, setting disable_xfrm=1 would solve the issue. Except this is
output - the test case is a ping from a peer, the corresponding ICMP
response is discarded by the kernel. Feels like disable_policy is the
right check (the kernel is doing XFRM output).

Cheers,
Mark

