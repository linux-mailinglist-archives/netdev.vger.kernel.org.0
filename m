Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ADD0D43C79D
	for <lists+netdev@lfdr.de>; Wed, 27 Oct 2021 12:24:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241423AbhJ0K0m (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Oct 2021 06:26:42 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:11284 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S239361AbhJ0K0j (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Oct 2021 06:26:39 -0400
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 19RALg5j020914;
        Wed, 27 Oct 2021 10:24:13 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=TFwPPLUITtY8fa2kbtoi1NI6hKGKe/D/krYKWxZzwbw=;
 b=iLfYTU5tDQEEyZh4TkHobZgeOJX/dyZWPJAzY73Kkspv+kuQwk+ZJ3s90z5J8jVi1Yx1
 jFn0KvW+RpHJaKzyYvLobStWqE34lKsNadXk/p9R6y5SlU2OsI506MXhBO5UCRRAc+fp
 oKLq8c7lVFX3pW463UptHzSmIRt3rRkQcZZZL+yhbKhSa0nEY7tdp9MOEsBU8Nrird6A
 8olXy8KpdhuGRkLZhOSg93K4B0xUMut9tyMxCbDNMG+01OLniHnMDy2ByVdYq9s2oc48
 whEZQ1uB33VGAw5PV+PauqHZ73vdklauacBUjtLnW2t77asJo3o7qsJJ14eASBenpNpY yg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3by4xsr1rx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 27 Oct 2021 10:24:13 +0000
Received: from m0098396.ppops.net (m0098396.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 19RALear020812;
        Wed, 27 Oct 2021 10:24:12 GMT
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3by4xsr1rb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 27 Oct 2021 10:24:12 +0000
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 19RACw7Z013485;
        Wed, 27 Oct 2021 10:24:10 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma06ams.nl.ibm.com with ESMTP id 3bx4f1dxv4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 27 Oct 2021 10:24:09 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 19RAO7cm3932922
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 27 Oct 2021 10:24:07 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 4BFAE5204F;
        Wed, 27 Oct 2021 10:24:07 +0000 (GMT)
Received: from [9.145.41.29] (unknown [9.145.41.29])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id BE4E852050;
        Wed, 27 Oct 2021 10:24:06 +0000 (GMT)
Message-ID: <c1d3d584-4a96-a34b-ed25-a376b17b36c7@linux.ibm.com>
Date:   Wed, 27 Oct 2021 12:24:18 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Subject: Re: [PATCH net 2/4] net/smc: Fix smc_link->llc_testlink_time overflow
Content-Language: en-US
To:     Tony Lu <tonylu@linux.alibaba.com>, davem@davemloft.net,
        kuba@kernel.org, ubraun@linux.ibm.com
Cc:     netdev@vger.kernel.org, linux-s390@vger.kernel.org,
        linux-rdma@vger.kernel.org, jacob.qi@linux.alibaba.com,
        xuanzhuo@linux.alibaba.com, guwen@linux.alibaba.com,
        dust.li@linux.alibaba.com
References: <20211027085208.16048-1-tonylu@linux.alibaba.com>
 <20211027085208.16048-3-tonylu@linux.alibaba.com>
From:   Karsten Graul <kgraul@linux.ibm.com>
Organization: IBM Deutschland Research & Development GmbH
In-Reply-To: <20211027085208.16048-3-tonylu@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: KleOzwbSit34Wr11CIof2m3lA3XnGZsw
X-Proofpoint-ORIG-GUID: hTqYOENxP2bIjyNRmsInwzbi96PB7cwY
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-10-27_03,2021-10-26_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=999
 priorityscore=1501 suspectscore=0 malwarescore=0 bulkscore=0 phishscore=0
 clxscore=1015 impostorscore=0 mlxscore=0 spamscore=0 lowpriorityscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2110270062
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 27/10/2021 10:52, Tony Lu wrote:
> From: Tony Lu <tony.ly@linux.alibaba.com>
> 
> The value of llc_testlink_time is set to the value stored in
> net->ipv4.sysctl_tcp_keepalive_time when linkgroup init. The value of
> sysctl_tcp_keepalive_time is already jiffies, so we don't need to
> multiply by HZ, which would cause smc_link->llc_testlink_time overflow,
> and test_link send flood.

Thanks for fixing this, we will include your patch in our next submission
to the netdev tree.
