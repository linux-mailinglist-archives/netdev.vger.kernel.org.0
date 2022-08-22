Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5E22859BED6
	for <lists+netdev@lfdr.de>; Mon, 22 Aug 2022 13:50:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234822AbiHVLuG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Aug 2022 07:50:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50616 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234855AbiHVLto (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Aug 2022 07:49:44 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B005140A5;
        Mon, 22 Aug 2022 04:49:10 -0700 (PDT)
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 27MBBvMB012567;
        Mon, 22 Aug 2022 11:49:01 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to :
 subject : message-id : references : mime-version : content-type :
 in-reply-to; s=pp1; bh=8jnSZ4izdUnoErqgj5Jfal17Z/S5X9/JGdMPR3d3QVc=;
 b=kZ8GH0+T1vRJx8xzwWMNHAJ4mqNDEHrjphek+GpGTvMuGFF1UFhAkKq/SwjW3iKvnhOO
 aLE7/78EHkXVJtyeGfk4fP0julho2Xb4SRiIaU5haRpaBC7EoL8xmMWUWQYJB/0X0u2e
 +QRlNemAYqK+PQdPpHwswN6oNFXApIbmb/2Mi5IYyYaQ3bCX5ltTdSKcXPVw66jKTMJL
 6JTW0umQlt9XsJH+TazEUR+OcUOiulseL4H57UnRKsOiOCEJZ2Fp8+TfewonfEqBLKo6
 hefHkR+hAe6vxQtV4f7rVhsteREhgaCz1k282mXeextGFs9FzMX4ShIShsJUjZg/eaYC hw== 
Received: from ppma05fra.de.ibm.com (6c.4a.5195.ip4.static.sl-reverse.com [149.81.74.108])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3j48qa135b-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 22 Aug 2022 11:49:00 +0000
Received: from pps.filterd (ppma05fra.de.ibm.com [127.0.0.1])
        by ppma05fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 27MBRkFg006306;
        Mon, 22 Aug 2022 11:48:58 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma05fra.de.ibm.com with ESMTP id 3j2q899q5y-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 22 Aug 2022 11:48:58 +0000
Received: from d06av24.portsmouth.uk.ibm.com (d06av24.portsmouth.uk.ibm.com [9.149.105.60])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 27MBjwG029229346
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 22 Aug 2022 11:45:58 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E8D0342041;
        Mon, 22 Aug 2022 11:48:54 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 37A2B4203F;
        Mon, 22 Aug 2022 11:48:54 +0000 (GMT)
Received: from li-4a3a4a4c-28e5-11b2-a85c-a8d192c6f089.ibm.com (unknown [9.145.17.18])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTPS;
        Mon, 22 Aug 2022 11:48:54 +0000 (GMT)
Date:   Mon, 22 Aug 2022 13:48:52 +0200
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
Message-ID: <YwNtJAQlJVycijou@li-4a3a4a4c-28e5-11b2-a85c-a8d192c6f089.ibm.com>
References: <20220818210102.7301-1-wsa+renesas@sang-engineering.com>
 <YwM4y78boN4s1VNo@li-4a3a4a4c-28e5-11b2-a85c-a8d192c6f089.ibm.com>
 <YwNAW2Zp6o7Z//Y2@shikoro>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YwNAW2Zp6o7Z//Y2@shikoro>
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: 3s7IsW1Hrudt8DozdirZjgJJ5kRG7GLO
X-Proofpoint-GUID: 3s7IsW1Hrudt8DozdirZjgJJ5kRG7GLO
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-08-22_06,2022-08-22_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0
 malwarescore=0 phishscore=0 suspectscore=0 priorityscore=1501 mlxscore=0
 mlxlogscore=999 bulkscore=0 adultscore=0 lowpriorityscore=0 spamscore=0
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2207270000 definitions=main-2208220048
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Aug 22, 2022 at 10:37:47AM +0200, Wolfram Sang wrote:
> Hi Alexander,
> 
> > Could you please explain why you skipped strlcpy() usage in
> > drivers/s390/char/diag_ftp.c and drivers/s390/char/sclp_ftp.c?
> 
> Sure. It is a bit hidden in $subject, but the key is to convert strlcpy
> instances for now which do not check the return value. This is the
> low-hanging fruit.
> 
> Converting the other uses checking the return value needs to be done
> manually and much more carfully. I wanted to this as a second step, but
> if you prefer to have everything converted in one go, I can give your
> subsystem a priority boost. Would you prefer that?

A follow-up patch is also fine.

I guess, you also wanted a fix for arch/s390/kvm/tests/instr_icpt/main.c
in this series.

> Thanks and happy hacking,
> 
>    Wolfram

Thanks!
