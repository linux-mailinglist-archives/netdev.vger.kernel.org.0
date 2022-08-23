Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 19C5059E5BE
	for <lists+netdev@lfdr.de>; Tue, 23 Aug 2022 17:11:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243554AbiHWPKT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Aug 2022 11:10:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37460 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241070AbiHWPKD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Aug 2022 11:10:03 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C4B1513A395;
        Tue, 23 Aug 2022 05:43:33 -0700 (PDT)
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 27NCGsdl021750;
        Tue, 23 Aug 2022 12:43:30 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=pp1; bh=WbtKC7chpqC1IcOcrEjrWtevRugPmoaBI9Cx6n4JziY=;
 b=JHGbi38DwxXPWEP2G/nacxqSd58GJP1XY0ADDjNIO9cAkqOZJtd9Dm3TgErkUwGje9TX
 7uG7fby/nZ2F5ft1h45x7TaCAEHQbvzGP032v+2sAm0g5x+YZK7DFUc3pYQTi5n1MYYA
 iC37zbV3XDp42cAEmHbNCEFMM6q90rMkTtD6GpjAuRsqMMKS+MWUkpccyH9dZWuY5mYR
 x8WItYgmZU8aNZHB/PrJy9qFCwoigV91JTYpkpspbXfEsBSVcA1nDS/8hD682i3TP2cw
 EGq+7iSI2QdK5QqAcoo94kk37jq1Gouy+WEovCUEuLX+GW+FJTyOpBkLEG4H0KoQo14I 5g== 
Received: from ppma02fra.de.ibm.com (47.49.7a9f.ip4.static.sl-reverse.com [159.122.73.71])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3j4xru0sc9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 23 Aug 2022 12:43:29 +0000
Received: from pps.filterd (ppma02fra.de.ibm.com [127.0.0.1])
        by ppma02fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 27NCMtbs014099;
        Tue, 23 Aug 2022 12:43:27 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma02fra.de.ibm.com with ESMTP id 3j2q88ts54-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 23 Aug 2022 12:43:27 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 27NChOpo33292782
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 23 Aug 2022 12:43:24 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5C52B11C04C;
        Tue, 23 Aug 2022 12:43:24 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 9B47D11C052;
        Tue, 23 Aug 2022 12:43:23 +0000 (GMT)
Received: from localhost (unknown [9.171.95.166])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTPS;
        Tue, 23 Aug 2022 12:43:23 +0000 (GMT)
Date:   Tue, 23 Aug 2022 14:43:22 +0200
From:   Vasily Gorbik <gor@linux.ibm.com>
To:     Wolfram Sang <wsa+renesas@sang-engineering.com>
Cc:     linux-kernel@vger.kernel.org, Stefan Haberland <sth@linux.ibm.com>,
        Jan Hoeppner <hoeppner@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Sven Schnelle <svens@linux.ibm.com>,
        Vineeth Vijayan <vneethv@linux.ibm.com>,
        Peter Oberparleiter <oberpar@linux.ibm.com>,
        Alexandra Winter <wintera@linux.ibm.com>,
        Wenjia Zhang <wenjia@linux.ibm.com>,
        Steffen Maier <maier@linux.ibm.com>,
        Benjamin Block <bblock@linux.ibm.com>,
        linux-s390@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH] s390: move from strlcpy with unused retval to strscpy
Message-ID: <your-ad-here.call-01661258602-ext-1883@work.hours>
References: <20220818210102.7301-1-wsa+renesas@sang-engineering.com>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20220818210102.7301-1-wsa+renesas@sang-engineering.com>
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: Kjxn_1es0zlqUhLUsQAhDxF_kltSf8R8
X-Proofpoint-ORIG-GUID: Kjxn_1es0zlqUhLUsQAhDxF_kltSf8R8
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-08-23_05,2022-08-22_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0
 priorityscore=1501 lowpriorityscore=0 suspectscore=0 impostorscore=0
 bulkscore=0 malwarescore=0 clxscore=1011 mlxscore=0 adultscore=0
 phishscore=0 mlxlogscore=894 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2207270000 definitions=main-2208230050
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Aug 18, 2022 at 11:01:01PM +0200, Wolfram Sang wrote:
> Follow the advice of the below link and prefer 'strscpy' in this
> subsystem. Conversion is 1:1 because the return value is not used.
> Generated by a coccinelle script.
> 
> Link: https://lore.kernel.org/r/CAHk-=wgfRnXz0W3D37d01q3JFkr_i_uTL=V6A6G1oUZcprmknw@mail.gmail.com/
> Signed-off-by: Wolfram Sang <wsa+renesas@sang-engineering.com>

Squashed it together with
https://lore.kernel.org/r/20220818205948.6360-1-wsa+renesas@sang-engineering.com
and applied to s390 tree. Thank you!
