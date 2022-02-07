Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E51554AB87D
	for <lists+netdev@lfdr.de>; Mon,  7 Feb 2022 11:13:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243085AbiBGKNI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Feb 2022 05:13:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44374 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239624AbiBGKDY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Feb 2022 05:03:24 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE552C043181;
        Mon,  7 Feb 2022 02:03:21 -0800 (PST)
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 21785xXk030293;
        Mon, 7 Feb 2022 10:03:19 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=AF0Dx+4XW7Kaq7j1oa4pc94i8mQFs1VABgai99KOuUw=;
 b=JGWs/Ru1xkw4enlnqcZl7kE9jY4UnA+ucQ6W0LERQx63aLtYdISadIeMzH3lF8c0A4JU
 rGgPqTpcWFq0wqdrHl0YP1EmcWkBdMwejV2llf6593/tQptDYp+ieibZ23j8fkyjOojz
 RrA8hXwZwD3KrLqclsxfb+RjmHQlcMQcv5QqPeoiE76v/92SUY7cZMyBHh1MdQEuiiK0
 HTCzuAPnanePFMti7KIwzVqeYH8RfKgGr0WmlnXZ8n6kDVC/eKIXFcdLQX1eYv/WVw4Q
 xsAMHyOAD8ZmLH/LE/rIrwuXXbDCkRUBv26KoHuLkFo45q0USnsNTTf40N/moO1HnK07 0w== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3e22ssqyhw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 07 Feb 2022 10:03:19 +0000
Received: from m0098409.ppops.net (m0098409.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 2179wUJx030874;
        Mon, 7 Feb 2022 10:03:18 GMT
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3e22ssqyh4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 07 Feb 2022 10:03:18 +0000
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 217A2QKs003686;
        Mon, 7 Feb 2022 10:03:16 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma03ams.nl.ibm.com with ESMTP id 3e1gv92s7c-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 07 Feb 2022 10:03:16 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 217A3EPm47710484
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 7 Feb 2022 10:03:14 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id EC127A4059;
        Mon,  7 Feb 2022 10:03:13 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 78F45A4055;
        Mon,  7 Feb 2022 10:03:13 +0000 (GMT)
Received: from [9.145.72.174] (unknown [9.145.72.174])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon,  7 Feb 2022 10:03:13 +0000 (GMT)
Message-ID: <7d18c7ac-9a4f-6a4f-2acf-5c83112fe967@linux.ibm.com>
Date:   Mon, 7 Feb 2022 11:03:13 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH net-next v4 3/3] net/smc: Fallback when handshake
 workqueue congested
Content-Language: en-US
To:     "D. Wythe" <alibuda@linux.alibaba.com>
Cc:     kuba@kernel.org, davem@davemloft.net, netdev@vger.kernel.org,
        linux-s390@vger.kernel.org, linux-rdma@vger.kernel.org,
        Tony Lu <tonylu@linux.alibaba.com>
References: <cover.1644214112.git.alibuda@linux.alibaba.com>
 <6deeca64bfecbd01d724092a1a2c91ca8bce3ce0.1644214112.git.alibuda@linux.alibaba.com>
 <bab2d7f1-c57a-cab4-3963-23721292eece@linux.ibm.com>
 <f1ed4d54-d658-c668-99af-9994a634baf3@linux.alibaba.com>
From:   Karsten Graul <kgraul@linux.ibm.com>
Organization: IBM Deutschland Research & Development GmbH
In-Reply-To: <f1ed4d54-d658-c668-99af-9994a634baf3@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: NS2kA0sPzDlWuWVSS4MfOxV2RBimsbwN
X-Proofpoint-ORIG-GUID: COBzwk8t8i4nWQcSz8WMOsyq5qFaTZGO
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-02-07_03,2022-02-03_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0
 priorityscore=1501 spamscore=0 suspectscore=0 malwarescore=0 mlxscore=0
 mlxlogscore=792 impostorscore=0 bulkscore=0 adultscore=0 clxscore=1015
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2201110000 definitions=main-2202070065
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H5,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 07/02/2022 10:50, D. Wythe wrote:
> 
> The main communication in v2 series is about adding a dynamic control for auto fallback to TCP. I will soon add a new patch to implements this in v5 series, or modify it in curret patch. Which one do you recommend?
> 

When you change a patch then you need to send a new series.
