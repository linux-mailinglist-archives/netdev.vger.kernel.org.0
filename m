Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9FF85440569
	for <lists+netdev@lfdr.de>; Sat, 30 Oct 2021 00:24:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231173AbhJ2W00 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Oct 2021 18:26:26 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:35530 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229546AbhJ2W00 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 Oct 2021 18:26:26 -0400
Received: from pps.filterd (m0127361.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 19TLbwQI033017
        for <netdev@vger.kernel.org>; Fri, 29 Oct 2021 22:23:56 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=mime-version :
 content-type : content-transfer-encoding : date : from : to : cc : subject
 : in-reply-to : references : message-id; s=pp1;
 bh=AICvhYs4UCxz70mi3nR6ys90uGVMQ++TbuOrTcgWNZU=;
 b=GUmyMJzneDCFDtYTZP1g4GGl9jgj5zQbEOWiLgxBxYrBwTTeYv7PjEB5d/mhxTHYktRo
 wyQ9a/4OavbdQrNDVJRKnH8iJcgEWVgjrpgbcVaJUsBz71aEAOX4S1OrD8j8kA6cJQBu
 gontxRmLKgjVCSid2+tFcDDWsxvC83UB207J/t4oWXT/sqGKx93zj2Jj1zr5keoK1yX3
 k0vc+45VVlmvb6+xvKXGK7VcjTyTcw6cEPMpRX49FliJrXpaD4zSrE+j5kmrJGyg88ov
 TXjJhbhEqZfgR9KWlCqtc628cqYu7wTjIid/dgZidTShd42clgrRNTP8phXiXglCW8mx 5g== 
Received: from ppma05wdc.us.ibm.com (1b.90.2fa9.ip4.static.sl-reverse.com [169.47.144.27])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3c0q04k12y-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Fri, 29 Oct 2021 22:23:56 +0000
Received: from pps.filterd (ppma05wdc.us.ibm.com [127.0.0.1])
        by ppma05wdc.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 19TMCCZ6003902
        for <netdev@vger.kernel.org>; Fri, 29 Oct 2021 22:23:55 GMT
Received: from b03cxnp07027.gho.boulder.ibm.com (b03cxnp07027.gho.boulder.ibm.com [9.17.130.14])
        by ppma05wdc.us.ibm.com with ESMTP id 3bx4enhhau-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Fri, 29 Oct 2021 22:23:55 +0000
Received: from b03ledav003.gho.boulder.ibm.com (b03ledav003.gho.boulder.ibm.com [9.17.130.234])
        by b03cxnp07027.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 19TMNqBm36307382
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 29 Oct 2021 22:23:52 GMT
Received: from b03ledav003.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 935336A04D;
        Fri, 29 Oct 2021 22:23:52 +0000 (GMT)
Received: from b03ledav003.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 548EC6A061;
        Fri, 29 Oct 2021 22:23:52 +0000 (GMT)
Received: from ltc.linux.ibm.com (unknown [9.10.229.42])
        by b03ledav003.gho.boulder.ibm.com (Postfix) with ESMTP;
        Fri, 29 Oct 2021 22:23:52 +0000 (GMT)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Fri, 29 Oct 2021 15:23:52 -0700
From:   Dany Madden <drt@linux.ibm.com>
To:     Sukadev Bhattiprolu <sukadev@linux.ibm.com>
Cc:     netdev@vger.kernel.org, Brian King <brking@linux.ibm.com>,
        abdhalee@in.ibm.com, vaish123@in.ibm.com
Subject: Re: [PATCH net 2/3] ibmvnic: Process crqs after enabling interrupts
In-Reply-To: <20211029220316.2003519-2-sukadev@linux.ibm.com>
References: <20211029220316.2003519-1-sukadev@linux.ibm.com>
 <20211029220316.2003519-2-sukadev@linux.ibm.com>
Message-ID: <e4d7bd9bdeab64959c25635e16d0bc09@imap.linux.ibm.com>
X-Sender: drt@linux.ibm.com
User-Agent: Roundcube Webmail/1.1.12
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: sKwKRN79G-MYyXZ5mfHjcqiqFhBC4hXr
X-Proofpoint-GUID: sKwKRN79G-MYyXZ5mfHjcqiqFhBC4hXr
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-10-29_06,2021-10-29_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 adultscore=0 clxscore=1015 mlxscore=0 bulkscore=0 suspectscore=0
 mlxlogscore=497 spamscore=0 lowpriorityscore=0 impostorscore=0
 phishscore=0 malwarescore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2110150000 definitions=main-2110290123
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2021-10-29 15:03, Sukadev Bhattiprolu wrote:
> Soon after registering a CRQ it is possible that we get a fail over or
> maybe a CRQ_INIT from the VIOS while interrupts were disabled.
> 
> Look for any such CRQs after enabling interrupts.
> 
> Otherwise we can intermittently fail to bring up ibmvnic adapters 
> during
> boot, specially in kexec/kdump kernels.
> 
> Fixes: 032c5e82847a ("Driver for IBM System i/p VNIC protocol")
> Reported-by: Vaishnavi Bhat <vaish123@in.ibm.com>
> Signed-off-by: Sukadev Bhattiprolu <sukadev@linux.ibm.com>

Reviewed-by: Dany Madden <drt@linux.ibm.com>
