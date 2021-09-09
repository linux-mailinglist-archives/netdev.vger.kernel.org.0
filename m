Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 45A68404587
	for <lists+netdev@lfdr.de>; Thu,  9 Sep 2021 08:15:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352496AbhIIGQ0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Sep 2021 02:16:26 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:56612 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1352448AbhIIGQY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Sep 2021 02:16:24 -0400
Received: from pps.filterd (m0098393.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 18963cdb004569;
        Thu, 9 Sep 2021 02:14:57 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=cPUonm5kJsYc2X/GGy0xJ2tmTzDsookwnNtXApmtolc=;
 b=NrJLNRL4xEjUp1z+/jRe3yFzuigHc03eaOxwwrifihwsN+sqwlBg5anjhndNmZhJuGrX
 zp7VBDPyu6dMj8amk4nETdtLln66fP0tplxQAuQB/WA2sT0SyesvaCIxzq2xqvGUqm09
 FmJlvYRX2SIKAK7g1vS+dof5/8Cyxic2YCAulXMVh8uLUsUM3mFioi5QfMr0+goLF+4J
 joRGTbx0+e3qYUH/ds+jOC6DgM8NpcQnMNtCRDjnfKtk5KoUGTcq0YOLqv79g4njT3qw
 f2uQDrt/1Sc22wnHlB77aYvioOoWnWwwrqFgZN8djBgmUMtAaKRCfcKb2ckkS6ZKeLWw RQ== 
Received: from ppma02fra.de.ibm.com (47.49.7a9f.ip4.static.sl-reverse.com [159.122.73.71])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3axmeqtg97-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 09 Sep 2021 02:14:57 -0400
Received: from pps.filterd (ppma02fra.de.ibm.com [127.0.0.1])
        by ppma02fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 1896CAlI007700;
        Thu, 9 Sep 2021 06:14:55 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma02fra.de.ibm.com with ESMTP id 3axcnk87vk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 09 Sep 2021 06:14:54 +0000
Received: from d06av24.portsmouth.uk.ibm.com (d06av24.portsmouth.uk.ibm.com [9.149.105.60])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 1896EpGp46661900
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 9 Sep 2021 06:14:52 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D918B42041;
        Thu,  9 Sep 2021 06:14:51 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id DBB794203F;
        Thu,  9 Sep 2021 06:14:50 +0000 (GMT)
Received: from [9.171.14.134] (unknown [9.171.14.134])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu,  9 Sep 2021 06:14:50 +0000 (GMT)
Subject: Re: [PATCH v2 60/63] net/af_iucv: Use struct_group() to zero struct
 iucv_sock region
To:     Kees Cook <keescook@chromium.org>, linux-kernel@vger.kernel.org
Cc:     Julian Wiedmann <jwi@linux.ibm.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-s390@vger.kernel.org,
        netdev@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-wireless@vger.kernel.org, dri-devel@lists.freedesktop.org,
        linux-staging@lists.linux.dev, linux-block@vger.kernel.org,
        linux-kbuild@vger.kernel.org, clang-built-linux@googlegroups.com,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        linux-hardening@vger.kernel.org
References: <20210818060533.3569517-1-keescook@chromium.org>
 <20210818060533.3569517-61-keescook@chromium.org>
From:   Karsten Graul <kgraul@linux.ibm.com>
Organization: IBM Deutschland Research & Development GmbH
Message-ID: <19ff61a0-0cda-6000-ce56-dc6b367c00d6@linux.ibm.com>
Date:   Thu, 9 Sep 2021 08:14:52 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <20210818060533.3569517-61-keescook@chromium.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: oFVZQt8pTzxySj5pZJpy_ghkEsh5Wye4
X-Proofpoint-ORIG-GUID: oFVZQt8pTzxySj5pZJpy_ghkEsh5Wye4
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-09-09_01:2021-09-07,2021-09-09 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0 bulkscore=0
 phishscore=0 adultscore=0 suspectscore=0 malwarescore=0 mlxlogscore=968
 priorityscore=1501 clxscore=1011 lowpriorityscore=0 mlxscore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2109030001
 definitions=main-2109090035
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 18/08/2021 08:05, Kees Cook wrote:
> In preparation for FORTIFY_SOURCE performing compile-time and run-time
> field bounds checking for memset(), avoid intentionally writing across
> neighboring fields.
> 
> Add struct_group() to mark the region of struct iucv_sock that gets
> initialized to zero. Avoid the future warning:
> 
> In function 'fortify_memset_chk',
>     inlined from 'iucv_sock_alloc' at net/iucv/af_iucv.c:476:2:
> ./include/linux/fortify-string.h:199:4: warning: call to '__write_overflow_field' declared with attribute warning: detected write beyond size of field (1st parameter); maybe use struct_group()? [-Wattribute-warning]
>   199 |    __write_overflow_field(p_size_field, size);
>       |    ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> 
> Cc: Julian Wiedmann <jwi@linux.ibm.com>
> Cc: Karsten Graul <kgraul@linux.ibm.com>
> Cc: "David S. Miller" <davem@davemloft.net>
> Cc: Jakub Kicinski <kuba@kernel.org>
> Cc: linux-s390@vger.kernel.org
> Cc: netdev@vger.kernel.org
> Signed-off-by: Kees Cook <keescook@chromium.org>
> ---
>  include/net/iucv/af_iucv.h | 10 ++++++----
>  net/iucv/af_iucv.c         |  2 +-
>  2 files changed, 7 insertions(+), 5 deletions(-)

No objections.
Acked-by: Karsten Graul <kgraul@linux.ibm.com>

Thank you.
