Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 646752C17EA
	for <lists+netdev@lfdr.de>; Mon, 23 Nov 2020 22:51:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731254AbgKWVq3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Nov 2020 16:46:29 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:47446 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728738AbgKWVq3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Nov 2020 16:46:29 -0500
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0ANLWoJr102052;
        Mon, 23 Nov 2020 16:46:27 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=mime-version : date :
 from : to : cc : subject : in-reply-to : references : message-id :
 content-type : content-transfer-encoding; s=pp1;
 bh=ghwOGPesoytsjogApGZsfOPD2kiwotGTTwQzd4+OWpQ=;
 b=lpJtFgV03G4Vy7h1kkfHkRBmOBS0MMwx269deYEqqFjvWZFGmQBwj/zjajLR6P4NX0WO
 OJRT6w+xyBqm1gMytETz+9qDm3UUOD13RfcPEmBtVj7pHx6Ur6RoVNpd2JUXVCX05SRk
 1w5Xsby6Mo9JciWqxUbNE1MPePUo1KlBXr25eVcafWgu4GcCLPdzGXG8pDp8AvwcpTYP
 P2ksu0+T5q1ErveJ4p7Mo6nQJSqtMGb5jJcfwyz/1g01BYNVRmFSXeMiQPisuabbryXO
 ASl709Ol4lHsDOpgqAxKTTcUZ9b5psj6CmofR6pMv2Lokz6f+ASSpDRmO9PkXGlTr0ic FA== 
Received: from ppma01wdc.us.ibm.com (fd.55.37a9.ip4.static.sl-reverse.com [169.55.85.253])
        by mx0a-001b2d01.pphosted.com with ESMTP id 350fe74j0v-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 23 Nov 2020 16:46:27 -0500
Received: from pps.filterd (ppma01wdc.us.ibm.com [127.0.0.1])
        by ppma01wdc.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 0ANLUCSJ031882;
        Mon, 23 Nov 2020 21:46:26 GMT
Received: from b03cxnp08026.gho.boulder.ibm.com (b03cxnp08026.gho.boulder.ibm.com [9.17.130.18])
        by ppma01wdc.us.ibm.com with ESMTP id 34xth8td5h-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 23 Nov 2020 21:46:26 +0000
Received: from b03ledav002.gho.boulder.ibm.com (b03ledav002.gho.boulder.ibm.com [9.17.130.233])
        by b03cxnp08026.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 0ANLkFOl6095510
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 23 Nov 2020 21:46:15 GMT
Received: from b03ledav002.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id CCA47136055;
        Mon, 23 Nov 2020 21:46:24 +0000 (GMT)
Received: from b03ledav002.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 9A0A2136053;
        Mon, 23 Nov 2020 21:46:24 +0000 (GMT)
Received: from ltc.linux.ibm.com (unknown [9.16.170.189])
        by b03ledav002.gho.boulder.ibm.com (Postfix) with ESMTP;
        Mon, 23 Nov 2020 21:46:24 +0000 (GMT)
MIME-Version: 1.0
Date:   Mon, 23 Nov 2020 13:46:24 -0800
From:   drt <drt@linux.vnet.ibm.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Lijun Pan <ljp@linux.ibm.com>, netdev@vger.kernel.org,
        sukadev@linux.ibm.com, drt@linux.ibm.com
Subject: Re: [PATCH net 02/15] ibmvnic: process HMC disable command
In-Reply-To: <20201123114328.00c0b933@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
References: <20201120224049.46933-1-ljp@linux.ibm.com>
 <20201120224049.46933-3-ljp@linux.ibm.com>
 <20201121153637.17a91ac4@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <aa10c3fad62841df56a6185b3b267ca9@linux.vnet.ibm.com>
 <20201123114328.00c0b933@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Message-ID: <7024b51598ede2a5ea40324ebb30f18f@linux.vnet.ibm.com>
X-Sender: drt@linux.vnet.ibm.com
User-Agent: Roundcube Webmail/1.0.1
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-11-23_18:2020-11-23,2020-11-23 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=999 mlxscore=0
 bulkscore=0 suspectscore=0 lowpriorityscore=0 adultscore=0 impostorscore=0
 clxscore=1015 priorityscore=1501 phishscore=0 spamscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2011230136
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2020-11-23 11:43, Jakub Kicinski wrote:
> On Sun, 22 Nov 2020 07:12:38 -0800 drt wrote:
>> On 2020-11-21 15:36, Jakub Kicinski wrote:
>> > On Fri, 20 Nov 2020 16:40:36 -0600 Lijun Pan wrote:
>> >> From: Dany Madden <drt@linux.ibm.com>
>> >>
>> >> Currently ibmvnic does not support the disable vnic command from the
>> >> Hardware Management Console. This patch enables ibmvnic to process
>> >> CRQ message 0x07, disable vnic adapter.
>> >
>> > What user-visible problem does this one solve?
>> This allows HMC to disconnect a Linux client from the network if the
>> vNIC adapter is misbehaving and/or sending malicious traffic. The 
>> effect
>> is the same as when a sysadmin sets a link down (ibmvnic_close()) on 
>> the
>> Linux client. This patch extends this ability to the HMC.
> 
> Okay, sounds to me like net-next material, then.
> 
> IIUC we don't need to fix this ASAP and backport to stable.

Yes, I will submit v2 net-next. Thank you.
