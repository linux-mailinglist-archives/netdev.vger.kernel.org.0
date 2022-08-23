Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B4FA159E419
	for <lists+netdev@lfdr.de>; Tue, 23 Aug 2022 15:31:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243340AbiHWM5Z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Aug 2022 08:57:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41794 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241876AbiHWM47 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Aug 2022 08:56:59 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9BEA1A1D67;
        Tue, 23 Aug 2022 03:01:39 -0700 (PDT)
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 27N9VFKn025088;
        Tue, 23 Aug 2022 09:53:07 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to :
 subject : message-id : references : mime-version : content-type :
 in-reply-to; s=pp1; bh=oEb0ieXm7fGIofO+eA4A2nQzfMfdeD785gWKknA8rZE=;
 b=JowQnbgz6XpHKTvQ1Z6HtUSW1EWBdnk1JS2TdE3DZJUYNaXVUrWlPOvWI+OsC3M1fNwd
 B7hn/IOJQGgNklt3ysccQLS2xPCV/2nbTpIyM+O8pZV9Jf8wx4htWLpN6jVV7rMfatlQ
 il+cVt4YVGTsdhb16q/z0WqPBxd5dqaZQtO65rwe8TltRMRLBtyQ6c4X9NM1k63h4Zdo
 M5rEsT1q6HUZaj18LwGibxO53Js4KfQYdf+IY7mnSiKFYSjuVWmVwx7hI91lkpmAKrHl
 hshm2t9DzgVhzIvRen5y1hu09dFiJIgvbm23BhxSAE/KY1ibzLa3/pFxlTg6p/EAeMwT dA== 
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3j4vaygk62-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 23 Aug 2022 09:53:07 +0000
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 27N9p4NC027851;
        Tue, 23 Aug 2022 09:53:05 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma06ams.nl.ibm.com with ESMTP id 3j2pvj3k4d-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 23 Aug 2022 09:53:05 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 27N9o33D33489338
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 23 Aug 2022 09:50:04 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 168754C040;
        Tue, 23 Aug 2022 09:53:02 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 32C714C044;
        Tue, 23 Aug 2022 09:53:01 +0000 (GMT)
Received: from li-4a3a4a4c-28e5-11b2-a85c-a8d192c6f089.ibm.com (unknown [9.145.17.18])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTPS;
        Tue, 23 Aug 2022 09:53:01 +0000 (GMT)
Date:   Tue, 23 Aug 2022 11:52:59 +0200
From:   Alexander Gordeev <agordeev@linux.ibm.com>
To:     Wolfram Sang <wsa+renesas@sang-engineering.com>,
        linux-kernel@vger.kernel.org, Stefan Haberland <sth@linux.ibm.com>,
        Jan Hoeppner <hoeppner@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
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
Message-ID: <YwSjew42Iryps1ag@li-4a3a4a4c-28e5-11b2-a85c-a8d192c6f089.ibm.com>
References: <20220818210102.7301-1-wsa+renesas@sang-engineering.com>
 <YwM4y78boN4s1VNo@li-4a3a4a4c-28e5-11b2-a85c-a8d192c6f089.ibm.com>
 <YwNAW2Zp6o7Z//Y2@shikoro>
 <YwNtJAQlJVycijou@li-4a3a4a4c-28e5-11b2-a85c-a8d192c6f089.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YwNtJAQlJVycijou@li-4a3a4a4c-28e5-11b2-a85c-a8d192c6f089.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: smCgthl38UYQ0TQDujEZdzz3DlyQeg-d
X-Proofpoint-ORIG-GUID: smCgthl38UYQ0TQDujEZdzz3DlyQeg-d
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-08-23_04,2022-08-22_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 spamscore=0
 malwarescore=0 mlxlogscore=725 suspectscore=0 adultscore=0 mlxscore=0
 impostorscore=0 lowpriorityscore=0 priorityscore=1501 clxscore=1015
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2207270000 definitions=main-2208230036
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Aug 22, 2022 at 01:48:54PM +0200, Alexander Gordeev wrote:
> I guess, you also wanted a fix for arch/s390/kvm/tests/instr_icpt/main.c
> in this series.

Please, ignore this one.

Thanks!
