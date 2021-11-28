Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 44B7C460A60
	for <lists+netdev@lfdr.de>; Sun, 28 Nov 2021 22:44:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236262AbhK1VsK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 28 Nov 2021 16:48:10 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:47940 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S236303AbhK1VqK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 28 Nov 2021 16:46:10 -0500
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1ASKud1L006735;
        Sun, 28 Nov 2021 21:42:50 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=53T3DVQXoOmGk0Ru/bhYIr21fbVr8KqJ17GtJgDRD9I=;
 b=l3n4T7on+31LPEFelJ6Pu/7akDMPbgrPmUOsJ5gi1kWmekxE1GKlbF7A3RI+PkswfSdx
 mKZNTlf10solSPUSonUdJJt/ns8QxHSayq41bNSXXj/s43SmYlQNSPFGmb6F+lFjC0ij
 SzNejjGEvlXdgSnJ0Z9Bgn0rzyje+SGqqTZCQOjqGoXSVtqMTViKUBIa24nNln+MO2jB
 FZ0GOF4fcPbMJXPnL4B1q1EoqSDSQ129vb7ux37q811fQgvaaEVCxiA7PortAs+YPC21
 LuSkZV9+X5Q1OKG+RWZWE3JrLb7spqU3aDoCg+MfSRucwpd0W1te8g7zRElkMFQbGBPG kA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3cmh8d8f2n-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sun, 28 Nov 2021 21:42:50 +0000
Received: from m0098419.ppops.net (m0098419.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 1ASLeB8R032291;
        Sun, 28 Nov 2021 21:42:49 GMT
Received: from ppma01fra.de.ibm.com (46.49.7a9f.ip4.static.sl-reverse.com [159.122.73.70])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3cmh8d8f2a-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sun, 28 Nov 2021 21:42:49 +0000
Received: from pps.filterd (ppma01fra.de.ibm.com [127.0.0.1])
        by ppma01fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 1ASLbHKJ028231;
        Sun, 28 Nov 2021 21:42:48 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma01fra.de.ibm.com with ESMTP id 3ckca96fq8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sun, 28 Nov 2021 21:42:48 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 1ASLgj7U59113762
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 28 Nov 2021 21:42:45 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B56A6A405B;
        Sun, 28 Nov 2021 21:42:45 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5D53FA4054;
        Sun, 28 Nov 2021 21:42:45 +0000 (GMT)
Received: from [9.145.59.207] (unknown [9.145.59.207])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Sun, 28 Nov 2021 21:42:45 +0000 (GMT)
Message-ID: <883f1ab1-21be-9019-d8c6-3942a0b8588c@linux.ibm.com>
Date:   Sun, 28 Nov 2021 22:42:50 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.0
Subject: Re: [PATCH net] net/smc: Clear memory when release and reuse buffer
Content-Language: en-US
To:     Jakub Kicinski <kuba@kernel.org>,
        Tony Lu <tonylu@linux.alibaba.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org,
        linux-s390@vger.kernel.org, linux-rdma@vger.kernel.org
References: <20211125122858.90726-1-tonylu@linux.alibaba.com>
 <20211126112855.37274cb7@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Karsten Graul <kgraul@linux.ibm.com>
Organization: IBM Deutschland Research & Development GmbH
In-Reply-To: <20211126112855.37274cb7@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: gArUDayhvrN29MTxd2k2bNRQBnzh0YlT
X-Proofpoint-GUID: RbmPb3ySMcWuxDcUW-fEtS-yD77t07at
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-11-28_07,2021-11-28_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0 adultscore=0
 mlxscore=0 clxscore=1015 priorityscore=1501 malwarescore=0
 lowpriorityscore=0 spamscore=0 impostorscore=0 phishscore=0
 mlxlogscore=999 bulkscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2110150000 definitions=main-2111280126
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 26/11/2021 20:28, Jakub Kicinski wrote:
> The tag in the subject seems incorrect, we tag things as [PATCH net] 
> if they are fixes, and as [PATCH net-next] if they are new features,
> code refactoring or performance improvements.
> 
> Is this a fix for a regression? In which case we need a Fixes tag to
> indicate where it was introduced. Otherwise it needs to be tagged as
> [PATCH net-next].
> 
> I'm assuming Karsten will take it via his tree, otherwise you'll need
> to repost.
> 

We are testing this change atm and will submit it via our tree.
Very nice change, I like it!
