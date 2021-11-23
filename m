Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 700C0459F56
	for <lists+netdev@lfdr.de>; Tue, 23 Nov 2021 10:33:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232619AbhKWJgY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Nov 2021 04:36:24 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:37912 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230236AbhKWJgW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Nov 2021 04:36:22 -0500
Received: from pps.filterd (m0187473.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1AN7TeRr027824;
        Tue, 23 Nov 2021 09:33:13 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=6aV245QdxwI33KAHp1SVACH3oe3e1BqJbVIhHlCufEA=;
 b=lIsYxPaxveROR9STsdDrjkyMAWM4iGrV7FxrAhhGg81OljTA5qA+r8jK5vvjM7tTE76J
 4aD+/hE7zgVr+sq/2QY6Gh3VSEDcCLOrv8m4wlUkLGV4rzBmiQOp0dQp1Ihl4l9WEhw/
 lIez38uDf7+oWKCwls0MoQaEBcEyAvclfk3FHENeYvTC9h8zOqf9MosRjZpmDdZR92Yw
 VSY104XY7XewnbEtzpx8LkW7zCZG9UNk+iI+485IDqFGmPKEQHtaJTFxsM5NX4j288n0
 tGcQHUkFhaF9mzNL1yHFi7Td1TRjOxXhfeZNMPDiFDCPNgcYKCzE3ocIOcAgrP4QUL6W cQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3cgsn2mpsj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 23 Nov 2021 09:33:13 +0000
Received: from m0187473.ppops.net (m0187473.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 1AN98m6h025971;
        Tue, 23 Nov 2021 09:33:12 GMT
Received: from ppma02fra.de.ibm.com (47.49.7a9f.ip4.static.sl-reverse.com [159.122.73.71])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3cgsn2mpry-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 23 Nov 2021 09:33:12 +0000
Received: from pps.filterd (ppma02fra.de.ibm.com [127.0.0.1])
        by ppma02fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 1AN9WHaR029818;
        Tue, 23 Nov 2021 09:33:10 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma02fra.de.ibm.com with ESMTP id 3cern9myg1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 23 Nov 2021 09:33:09 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 1AN9X7W160490032
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 23 Nov 2021 09:33:07 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 52EB6A405C;
        Tue, 23 Nov 2021 09:33:07 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E69B0A4054;
        Tue, 23 Nov 2021 09:33:06 +0000 (GMT)
Received: from [9.145.60.43] (unknown [9.145.60.43])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 23 Nov 2021 09:33:06 +0000 (GMT)
Message-ID: <9aaa03b2-4478-6dff-0bfc-06eba7ef2bf7@linux.ibm.com>
Date:   Tue, 23 Nov 2021 10:33:07 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.0
Subject: Re: [PATCH RFC net-next] net/smc: Unbind buffer size from clcsock and
 make it tunable
Content-Language: en-US
To:     Tony Lu <tonylu@linux.alibaba.com>
Cc:     kuba@kernel.org, davem@davemloft.net, guwen@linux.alibaba.com,
        netdev@vger.kernel.org, linux-s390@vger.kernel.org,
        linux-rdma@vger.kernel.org
References: <20211122134255.63347-1-tonylu@linux.alibaba.com>
 <f08e1793-630f-32a6-6662-19edc362b386@linux.ibm.com>
 <YZyQg23Vqes4Ls5t@TonyMac-Alibaba>
From:   Karsten Graul <kgraul@linux.ibm.com>
Organization: IBM Deutschland Research & Development GmbH
In-Reply-To: <YZyQg23Vqes4Ls5t@TonyMac-Alibaba>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: BfPe0sFyMSKE48vSzIXlygvEvlet0FZo
X-Proofpoint-ORIG-GUID: A-ScYIA7gJ316wnyHHo2UJNUFtWXRho1
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-11-23_03,2021-11-22_02,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 suspectscore=0 impostorscore=0 malwarescore=0 spamscore=0 mlxscore=0
 lowpriorityscore=0 mlxlogscore=999 adultscore=0 phishscore=0 bulkscore=0
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2111230051
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 23/11/2021 07:56, Tony Lu wrote:
> To solve this issue, we developed a set of patches to replace the
> AF_INET / SOCK_STREAM with AF_SMC / SMCPROTO_SMC{6} by configuration.
> So that we can control acceleration in kernel without any other changes
> in user-space, and won't break our application containers and publish
> workflow. These patches are still improving for upstream.

This sounds interesting. Will this also be namespace-based like the sysctls
in the current patch? Will this future change integrate nicely with the current
new sysctls? This might allow to activate smc for containers, selectively. 

Please send these changes in a patch series together when they are finished.
We would like to review them as a whole to see how things play together.

Thank you!
