Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 92F9E45B80E
	for <lists+netdev@lfdr.de>; Wed, 24 Nov 2021 11:08:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239432AbhKXKLl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Nov 2021 05:11:41 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:20978 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230515AbhKXKLl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Nov 2021 05:11:41 -0500
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1AO9pWOQ015011;
        Wed, 24 Nov 2021 10:08:29 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=KdIKZkao5MHmcU9nfG+lATujxB6sNuLODpSuIVTHwcw=;
 b=tMma7d7fw9WRWmE4kKJYjEYgpUH7bYakwOwKdMMCpBcb6G15PnlSfIiO/VQ5e6Fw0cV3
 cwJy464Ud/rfGWILcqKxSN0geMqugLUBiij74dQOuWqwpsh3E4gxldW9M52ZTjc0XQ7t
 YbItFuIncqC/D4ufkUN0gRzT1kWq+NDVafY0K1HPI1U0sOsJzChNjTaJri5cYpnmlNIz
 2XUgTPLBEMbuiMqfyyxdAMo/QghVG7ABE4ErtbouW1qN7px1clxjvK4B11uwYZQDtBS/
 04J5AtCkoGysdj+0j/BYB87cPxAxi0IHA5uSdAgwgww1IQz1Uy6hccOLDN4e8eLVIPfQ 8Q== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3chk4rgamr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 24 Nov 2021 10:08:28 +0000
Received: from m0098421.ppops.net (m0098421.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 1AOA0Kiw013809;
        Wed, 24 Nov 2021 10:08:28 GMT
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3chk4rgame-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 24 Nov 2021 10:08:27 +0000
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 1AOA6wcl007373;
        Wed, 24 Nov 2021 10:08:26 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma03ams.nl.ibm.com with ESMTP id 3cerna80vg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 24 Nov 2021 10:08:26 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 1AOA8NUh22217182
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 24 Nov 2021 10:08:23 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 52CFDA4065;
        Wed, 24 Nov 2021 10:08:23 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id EC787A4060;
        Wed, 24 Nov 2021 10:08:22 +0000 (GMT)
Received: from [9.145.38.7] (unknown [9.145.38.7])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed, 24 Nov 2021 10:08:22 +0000 (GMT)
Message-ID: <1f67548e-cbf6-0dce-82b5-10288a4583bd@linux.ibm.com>
Date:   Wed, 24 Nov 2021 11:08:23 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.0
Subject: Re: [PATCH RFC net] net/smc: Ensure the active closing peer first
 closes clcsock
Content-Language: en-US
To:     Tony Lu <tonylu@linux.alibaba.com>
Cc:     kuba@kernel.org, davem@davemloft.net, guwen@linux.alibaba.com,
        netdev@vger.kernel.org, linux-s390@vger.kernel.org,
        linux-rdma@vger.kernel.org
References: <20211116033011.16658-1-tonylu@linux.alibaba.com>
 <d83109fe-ae25-def0-b28e-f8695d4535c7@linux.ibm.com>
 <YZ3+ihxIU5l8mvWY@TonyMac-Alibaba>
From:   Karsten Graul <kgraul@linux.ibm.com>
Organization: IBM Deutschland Research & Development GmbH
In-Reply-To: <YZ3+ihxIU5l8mvWY@TonyMac-Alibaba>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: hajGgR40Vw03lTaolrItrFUOdFAo-1me
X-Proofpoint-GUID: HkV2Q0ocY0zPYF47pg0nB-_LnQ0VcBpQ
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-11-24_03,2021-11-23_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0 bulkscore=0
 mlxscore=0 adultscore=0 spamscore=0 malwarescore=0 phishscore=0
 clxscore=1015 impostorscore=0 priorityscore=1501 mlxlogscore=999
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2111240057
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 24/11/2021 09:57, Tony Lu wrote:
> IMHO, given that, it is better to not ignore smc_close_final(), and move 
> kernel_sock_shutdown() to __smc_release(), because smc_shutdown() also
> calls kernel_sock_shutdown() after smc_close_active() and
> smc_close_shutdown_write(), then enters SMC_PEERCLOSEWAIT1. It's no need
> to call it twice with SHUT_WR and SHUT_RDWR. 

Since the idea is to shutdown the socket before the remote peer shutdowns it
first, are you sure that this shutdown in smc_release() is not too late?
Is it sure that smc_release() is called in time for this processing?

Maybe its better to keep the shutdown in smc_close_active() and to use an rc1
just like shown in your proposal, and return either the rc of smc_close_final() 
or the rc of kernel_sock_shutdown().
I see the possibility of calling shutdown twice for the clcsocket, but does it
harm enough to give a reason to check it before in smc_shutdown()? I expect TCP
to handle this already.
