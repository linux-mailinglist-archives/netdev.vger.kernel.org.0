Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C842B616DFB
	for <lists+netdev@lfdr.de>; Wed,  2 Nov 2022 20:49:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229752AbiKBTtN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Nov 2022 15:49:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56212 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230017AbiKBTtG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Nov 2022 15:49:06 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC0C6D67;
        Wed,  2 Nov 2022 12:49:04 -0700 (PDT)
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 2A2IIWQH010990;
        Wed, 2 Nov 2022 19:48:51 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=pp1; bh=ZpgHRdfL/PCPvt/oLWblbnONuZmPNKwE3Dml7DHi9W4=;
 b=iwHuU+YmxC9VDgMTRP6RIXPKGhVfhrohDMht5Wuio5Dr+FytgQfmE3LFs3rj58NCgnaq
 hL4iLPsVhwLc0m0lDJW3itn/OVy7TPyhn9sThVF7yrWQO55IFSQXaRheZ2emjp+spzM0
 KO06Kq3GVekHji/9+YfROhLO5VJRj7/mr9C771vQfdfnZVWYCOh9SqzAmL5JNu9I4cOE
 mmPI2F8XjCKgZ8G9yZi2uZx8Ag7rTeD9xVu4UGOUQZeV5XPEBBiBRULAxOXJbexMLiWe
 1DWcOPo1ca3IqNvlVoY4FY6AzJboPuoIMxWxidzpp6rYhArA3PVZxCEl/UyzIFu4jNhz mA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3kkvbydavu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 02 Nov 2022 19:48:50 +0000
Received: from m0098421.ppops.net (m0098421.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 2A2J7Qgl012433;
        Wed, 2 Nov 2022 19:48:50 GMT
Received: from ppma02fra.de.ibm.com (47.49.7a9f.ip4.static.sl-reverse.com [159.122.73.71])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3kkvbydav2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 02 Nov 2022 19:48:50 +0000
Received: from pps.filterd (ppma02fra.de.ibm.com [127.0.0.1])
        by ppma02fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 2A2Jb903026962;
        Wed, 2 Nov 2022 19:48:48 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma02fra.de.ibm.com with ESMTP id 3kgut9djuu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 02 Nov 2022 19:48:48 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 2A2Jmi17131832
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 2 Nov 2022 19:48:44 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A7EC2AE045;
        Wed,  2 Nov 2022 19:48:44 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 10496AE04D;
        Wed,  2 Nov 2022 19:48:44 +0000 (GMT)
Received: from osiris (unknown [9.145.72.45])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTPS;
        Wed,  2 Nov 2022 19:48:43 +0000 (GMT)
Date:   Wed, 2 Nov 2022 20:48:42 +0100
From:   Heiko Carstens <hca@linux.ibm.com>
To:     Nathan Chancellor <nathan@kernel.org>
Cc:     Alexandra Winter <wintera@linux.ibm.com>,
        Wenjia Zhang <wenjia@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Sven Schnelle <svens@linux.ibm.com>,
        linux-s390@vger.kernel.org, netdev@vger.kernel.org,
        Nick Desaulniers <ndesaulniers@google.com>,
        Tom Rix <trix@redhat.com>, Kees Cook <keescook@chromium.org>,
        Sami Tolvanen <samitolvanen@google.com>, llvm@lists.linux.dev,
        linux-kernel@vger.kernel.org, patches@lists.linux.dev
Subject: Re: [PATCH 1/3] s390/ctcm: Fix return type of ctc{mp,}m_tx()
Message-ID: <Y2LJmr8gE2I7gOP5@osiris>
References: <20221102163252.49175-1-nathan@kernel.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221102163252.49175-1-nathan@kernel.org>
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: DuVgliAug7XDRy9FdO2XYNOCFotwB4f6
X-Proofpoint-ORIG-GUID: j9ddi9CrRnHLmls-L0esyfSCrumPwTUN
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-02_14,2022-11-02_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 mlxlogscore=671
 priorityscore=1501 spamscore=0 malwarescore=0 adultscore=0
 lowpriorityscore=0 suspectscore=0 clxscore=1011 mlxscore=0 impostorscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2210170000 definitions=main-2211020128
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Nathan,

On Wed, Nov 02, 2022 at 09:32:50AM -0700, Nathan Chancellor wrote:
> should s390 select ARCH_SUPPORTS_CFI_CLANG in the future.

Yes, s390 should select that :)

But, is there any switch or option I need to set when compiling clang,
so it knows about the kcfi sanitizer?

I get:
clang-16: error: unsupported option '-fsanitize=kcfi' for target 's390x-ibm-linux'

> clang --version
clang version 16.0.0 (https://github.com/llvm/llvm-project.git e02110e2ab4dd71b276e887483f0e6e286d243ed)
