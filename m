Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BBBD44ADEF4
	for <lists+netdev@lfdr.de>; Tue,  8 Feb 2022 18:09:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1383727AbiBHRJF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Feb 2022 12:09:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44322 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244646AbiBHRI5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Feb 2022 12:08:57 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B18FC061576;
        Tue,  8 Feb 2022 09:08:57 -0800 (PST)
Received: from pps.filterd (m0098394.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 218FDECh021819;
        Tue, 8 Feb 2022 17:08:55 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=qCF7+eNQDUyl/0G84iJLVzuv+hBQGfreFxuZ3s8JTWo=;
 b=elM4hjQR+E3ISPuxkdo71F16gbwJK1FgP8Txb85F+Bo2+SmHiJkTYWZ2tIyVbq9+cDdK
 fj1/cWnv35f6cLKc1axBwLMKnki1bCgt5YW4J6/g0OX9MYrAA1Mfi9UpPvkzlEvy4Xug
 u00IA9nTAnx3xgykFlY0AoHLy2boj9OCpkN93BhpvUcdsbVsd4KKwkx/p5kRsfjrRT64
 f47C3QpuIqf73dDZv0FnWz/BCPTqBBmjllDHELC94NTnWwwjQfBLvX8bNhXmOIwVMLhY
 JWqh861pD6DSJL9OvVArrrFMkG0dc5jo7/ChH9c/DxpXbDXVCvNxVfHIRfp3w+AQQyXR Hg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3e3tyc41h0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 08 Feb 2022 17:08:55 +0000
Received: from m0098394.ppops.net (m0098394.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 218FEBfe028810;
        Tue, 8 Feb 2022 17:08:54 GMT
Received: from ppma01fra.de.ibm.com (46.49.7a9f.ip4.static.sl-reverse.com [159.122.73.70])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3e3tyc41fc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 08 Feb 2022 17:08:54 +0000
Received: from pps.filterd (ppma01fra.de.ibm.com [127.0.0.1])
        by ppma01fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 218GwYMg027957;
        Tue, 8 Feb 2022 17:08:52 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma01fra.de.ibm.com with ESMTP id 3e1gv9et2s-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 08 Feb 2022 17:08:52 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 218GwisP35652078
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 8 Feb 2022 16:58:45 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 2C78FA4040;
        Tue,  8 Feb 2022 17:08:50 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C5F54A404D;
        Tue,  8 Feb 2022 17:08:49 +0000 (GMT)
Received: from [9.145.157.102] (unknown [9.145.157.102])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue,  8 Feb 2022 17:08:49 +0000 (GMT)
Message-ID: <74e9c7fb-073c-cd62-c42a-e57c18de3404@linux.ibm.com>
Date:   Tue, 8 Feb 2022 18:08:49 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH net-next v5 4/5] net/smc: Dynamic control auto fallback by
 socket options
Content-Language: en-US
To:     "D. Wythe" <alibuda@linux.alibaba.com>
Cc:     kuba@kernel.org, davem@davemloft.net, netdev@vger.kernel.org,
        linux-s390@vger.kernel.org, linux-rdma@vger.kernel.org
References: <cover.1644323503.git.alibuda@linux.alibaba.com>
 <20f504f961e1a803f85d64229ad84260434203bd.1644323503.git.alibuda@linux.alibaba.com>
From:   Karsten Graul <kgraul@linux.ibm.com>
Organization: IBM Deutschland Research & Development GmbH
In-Reply-To: <20f504f961e1a803f85d64229ad84260434203bd.1644323503.git.alibuda@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: og8X6yN2Z5uhKco5YJkC4Xf1aqOLDDVB
X-Proofpoint-ORIG-GUID: -QrAYevUNwwi5BTJn6tCRZWeyA0TkpSA
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-02-08_06,2022-02-07_02,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 suspectscore=0
 priorityscore=1501 adultscore=0 impostorscore=0 mlxscore=0 phishscore=0
 spamscore=0 malwarescore=0 mlxlogscore=999 bulkscore=0 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2201110000
 definitions=main-2202080103
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H5,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 08/02/2022 13:53, D. Wythe wrote:
> From: "D. Wythe" <alibuda@linux.alibaba.com>
> 
> This patch aims to add dynamic control for SMC auto fallback, since we
> don't have socket option level for SMC yet, which requires we need to
> implement it at the same time.

In your response to the v2 version of this series you wrote:

> After some trial and thought, I found that the scope of netlink control 
> is too large, we should limit the scope to socket. Adding a socket option 
> may be a better choice, what do you think?

I want to understand why this socket option is required, who needs it and why.
What were your trials and thoughts, did you see any problems with the global 
switch via the netlink interface?
