Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DF1956182BF
	for <lists+netdev@lfdr.de>; Thu,  3 Nov 2022 16:28:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231624AbiKCP2N (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Nov 2022 11:28:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37894 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232182AbiKCP1n (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Nov 2022 11:27:43 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 339221B9CB;
        Thu,  3 Nov 2022 08:27:41 -0700 (PDT)
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 2A3F8ll6022285;
        Thu, 3 Nov 2022 15:27:33 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=pp1;
 bh=6wCipEvp9ampmbBGbfyYVCsuiKJVysmr33s+ba/f0TY=;
 b=kkdLZKt/C8bEnxBfn7+WFcjR9KsLMTHsA32/mFHkLI/Kpp7bSjbt+HXmHprWCGdi7E0d
 TAZUAcL9abbpc+JZjvatlgh3zxkz8qmbdrphFAmwJPr9jDUWakpevwyRV0hMBnNqySHu
 prpaG8OdU3AyYJ0WuN0IUaQziJssoT3F7PgnucBp6iId6HUXJ5DNB6uVKOWHTiygyptQ
 HDPCT+wfZ02M9sNp/pVVSe/ZJ3bKU2qY4yTwKsaSum0bjqE1KIipKJXw3LkUcidlh+YT
 WWAODkiR9Vx6v6ELllkGGy8A03zLYoVBVzN0TZNhdCVW21kB/vsblzgikRKm3dYDkC3f gQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3kmf9r2td1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 03 Nov 2022 15:27:33 +0000
Received: from m0098409.ppops.net (m0098409.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 2A3FA7fm030157;
        Thu, 3 Nov 2022 15:27:32 GMT
Received: from ppma04fra.de.ibm.com (6a.4a.5195.ip4.static.sl-reverse.com [149.81.74.106])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3kmf9r2tbt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 03 Nov 2022 15:27:32 +0000
Received: from pps.filterd (ppma04fra.de.ibm.com [127.0.0.1])
        by ppma04fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 2A3F5eI3014295;
        Thu, 3 Nov 2022 15:27:30 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma04fra.de.ibm.com with ESMTP id 3kgut8xqrh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 03 Nov 2022 15:27:30 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 2A3FRR0C6226564
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 3 Nov 2022 15:27:27 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E7F85AE04D;
        Thu,  3 Nov 2022 15:27:26 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 76D29AE045;
        Thu,  3 Nov 2022 15:27:26 +0000 (GMT)
Received: from [9.152.224.241] (unknown [9.152.224.241])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu,  3 Nov 2022 15:27:26 +0000 (GMT)
Message-ID: <7c5f70bd-c7a5-cf43-8ce9-f97dbba59a15@linux.ibm.com>
Date:   Thu, 3 Nov 2022 16:27:26 +0100
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.4.1
Subject: Re: [PATCH 3/3] s390/lcs: Fix return type of lcs_start_xmit()
Content-Language: en-US
To:     Nathan Chancellor <nathan@kernel.org>,
        Wenjia Zhang <wenjia@linux.ibm.com>
Cc:     Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Sven Schnelle <svens@linux.ibm.com>,
        linux-s390@vger.kernel.org, netdev@vger.kernel.org,
        Nick Desaulniers <ndesaulniers@google.com>,
        Tom Rix <trix@redhat.com>, Kees Cook <keescook@chromium.org>,
        Sami Tolvanen <samitolvanen@google.com>, llvm@lists.linux.dev,
        linux-kernel@vger.kernel.org, patches@lists.linux.dev
References: <20221102163252.49175-1-nathan@kernel.org>
 <20221102163252.49175-3-nathan@kernel.org>
From:   Alexandra Winter <wintera@linux.ibm.com>
In-Reply-To: <20221102163252.49175-3-nathan@kernel.org>
Content-Type: text/plain; charset=UTF-8
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 0JkxIsgOHNAoaozpH7FELDEopzUm619D
X-Proofpoint-ORIG-GUID: UgUdqCnUmOghft52R9yJJ-fHv2FECiVd
Content-Transfer-Encoding: 7bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-03_04,2022-11-03_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015
 lowpriorityscore=0 malwarescore=0 bulkscore=0 impostorscore=0 spamscore=0
 mlxscore=0 priorityscore=1501 mlxlogscore=999 suspectscore=0 phishscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2210170000 definitions=main-2211030101
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 02.11.22 17:32, Nathan Chancellor wrote:
> With clang's kernel control flow integrity (kCFI, CONFIG_CFI_CLANG),
> indirect call targets are validated against the expected function
> pointer prototype to make sure the call target is valid to help mitigate
> ROP attacks. If they are not identical, there is a failure at run time,
> which manifests as either a kernel panic or thread getting killed. A
> proposed warning in clang aims to catch these at compile time, which
> reveals:
> 
>   drivers/s390/net/lcs.c:2090:21: error: incompatible function pointer types initializing 'netdev_tx_t (*)(struct sk_buff *, struct net_device *)' (aka 'enum netdev_tx (*)(struct sk_buff *, struct net_device *)') with an expression of type 'int (struct sk_buff *, struct net_device *)' [-Werror,-Wincompatible-function-pointer-types-strict]
>           .ndo_start_xmit         = lcs_start_xmit,
>                                     ^~~~~~~~~~~~~~
>   drivers/s390/net/lcs.c:2097:21: error: incompatible function pointer types initializing 'netdev_tx_t (*)(struct sk_buff *, struct net_device *)' (aka 'enum netdev_tx (*)(struct sk_buff *, struct net_device *)') with an expression of type 'int (struct sk_buff *, struct net_device *)' [-Werror,-Wincompatible-function-pointer-types-strict]
>           .ndo_start_xmit         = lcs_start_xmit,
>                                     ^~~~~~~~~~~~~~
> 
> ->ndo_start_xmit() in 'struct net_device_ops' expects a return type of
> 'netdev_tx_t', not 'int'. Adjust the return type of lcs_start_xmit() to
> match the prototype's to resolve the warning and potential CFI failure,
> should s390 select ARCH_SUPPORTS_CFI_CLANG in the future.
> 
> Link: https://github.com/ClangBuiltLinux/linux/issues/1750
> Signed-off-by: Nathan Chancellor <nathan@kernel.org>
> ---
>  drivers/s390/net/lcs.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/s390/net/lcs.c b/drivers/s390/net/lcs.c
> index 84c8981317b4..4cbb9802bf22 100644
> --- a/drivers/s390/net/lcs.c
> +++ b/drivers/s390/net/lcs.c
> @@ -1519,7 +1519,7 @@ lcs_txbuffer_cb(struct lcs_channel *channel, struct lcs_buffer *buffer)
>  /*
>   * Packet transmit function called by network stack
>   */
> -static int
> +static netdev_tx_t
>  __lcs_start_xmit(struct lcs_card *card, struct sk_buff *skb,
>  		 struct net_device *dev)
>  {
> @@ -1582,7 +1582,7 @@ __lcs_start_xmit(struct lcs_card *card, struct sk_buff *skb,
>  	return rc;
>  }
>  
> -static int
> +static netdev_tx_t
>  lcs_start_xmit(struct sk_buff *skb, struct net_device *dev)
>  {
>  	struct lcs_card *card;

Thanks a lot for the fix.
Could you please also fix the indentation of these lines?
With that:
Reviewed-by: Alexandra Winter <wintera@linux.ibm.com>


