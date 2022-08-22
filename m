Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6A80859BB10
	for <lists+netdev@lfdr.de>; Mon, 22 Aug 2022 10:08:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233799AbiHVIGU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Aug 2022 04:06:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33168 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233721AbiHVIGF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Aug 2022 04:06:05 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE2CFEE2B;
        Mon, 22 Aug 2022 01:05:43 -0700 (PDT)
Received: from pps.filterd (m0127361.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 27M6UGkH034597;
        Mon, 22 Aug 2022 08:05:40 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : references : mime-version : content-type :
 in-reply-to; s=pp1; bh=jo91yn3RyGLtKXmjg6ojCQa07KBc1vMehaeMQNh6qHU=;
 b=oJLQyDG+C1B6oJnoyQTO30+YxqSVZqM2WIaWtsDLamUfO/v0p0LfW8AH1pwmBT8wA9Ww
 3NJ03kpK2HbClja5FHP3YIKU4EFymjkqe3GbrTow1NtWwZn6acTjHIJWhZJLv9kVkU6j
 1pvxdzTJf6pZZ3ij7B41LWUpbGtaFC+rQ0I/h3VL9h6tcCOuw9KGuRXr2aFYd508poZ/
 y7CQzfOgMysfMZn5VdoAYNNGNWqiIcKZNkUXI6kNCNOQuo1OUYHt7X8Sp04UWzqqi9O3
 LmUZQ9YdSVmuwAqCclSfDKo2+rDdgYdADk7Jyvv99BXUfl/djhQOqVSqvog23pUJnWYw Xg== 
Received: from ppma05fra.de.ibm.com (6c.4a.5195.ip4.static.sl-reverse.com [149.81.74.108])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3j44k52kmu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 22 Aug 2022 08:05:40 +0000
Received: from pps.filterd (ppma05fra.de.ibm.com [127.0.0.1])
        by ppma05fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 27M85ThF012022;
        Mon, 22 Aug 2022 08:05:38 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma05fra.de.ibm.com with ESMTP id 3j2q899h5m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 22 Aug 2022 08:05:38 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 27M85sJm34668884
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 22 Aug 2022 08:05:54 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 86C32A405F;
        Mon, 22 Aug 2022 08:05:34 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 6648CA405C;
        Mon, 22 Aug 2022 08:05:33 +0000 (GMT)
Received: from li-4a3a4a4c-28e5-11b2-a85c-a8d192c6f089.ibm.com (unknown [9.145.17.18])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTPS;
        Mon, 22 Aug 2022 08:05:33 +0000 (GMT)
Date:   Mon, 22 Aug 2022 10:05:31 +0200
From:   Alexander Gordeev <agordeev@linux.ibm.com>
To:     Wolfram Sang <wsa+renesas@sang-engineering.com>
Cc:     linux-kernel@vger.kernel.org, Stefan Haberland <sth@linux.ibm.com>,
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
Message-ID: <YwM4y78boN4s1VNo@li-4a3a4a4c-28e5-11b2-a85c-a8d192c6f089.ibm.com>
References: <20220818210102.7301-1-wsa+renesas@sang-engineering.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220818210102.7301-1-wsa+renesas@sang-engineering.com>
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: uWuo6fIu6g3JI8gQ2Bt4H7O_9L8uPcCb
X-Proofpoint-GUID: uWuo6fIu6g3JI8gQ2Bt4H7O_9L8uPcCb
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-08-22_04,2022-08-18_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 adultscore=0
 clxscore=1011 lowpriorityscore=0 phishscore=0 suspectscore=0
 priorityscore=1501 impostorscore=0 bulkscore=0 mlxscore=0 spamscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2207270000 definitions=main-2208220034
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Aug 18, 2022 at 11:01:01PM +0200, Wolfram Sang wrote:
Hi Wolfram,
> Follow the advice of the below link and prefer 'strscpy' in this
> subsystem. Conversion is 1:1 because the return value is not used.
> Generated by a coccinelle script.

Could you please explain why you skipped strlcpy() usage in
drivers/s390/char/diag_ftp.c and drivers/s390/char/sclp_ftp.c?

Thanks!
