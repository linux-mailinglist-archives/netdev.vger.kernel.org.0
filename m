Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 67A03617C36
	for <lists+netdev@lfdr.de>; Thu,  3 Nov 2022 13:10:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231641AbiKCMKS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Nov 2022 08:10:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39124 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231527AbiKCMKC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Nov 2022 08:10:02 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 39F5E10CF;
        Thu,  3 Nov 2022 05:09:34 -0700 (PDT)
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 2A3C1D5Z002441;
        Thu, 3 Nov 2022 12:09:27 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=pp1;
 bh=8MkCcA35cKOL9OlxmEeZCl4Yiqau1N46WGHALoFqEKk=;
 b=DW45MuLTmTWuaa3vXrHOzfFaQ45gIJCw9xngDbzeOFGN6O0bwdrUPHxwbl8HNNg4erZC
 uxjspbD/L502EjNnWXzNyJhbAzvWbK0HMeBGJq5lTnKTO7gXjPKvv72r8p5T4clxfKZc
 gagm0rhGl5YYkUs5sxQSDGqs5Sal0OvZQ92kIne23nVSNrXX5ZdHpB6GcbN9r+Ygnzdh
 xcjvnZpThncRj4TLWD8nIgPfW96pl/uFb2efKjHbaPt/WMyWXNI7vTLuuoyr3te8dfQS
 kFg8orkYUi9jwjWK694+FfYDEzq+H8JWNOOGtrMpBTjJyTyFxfhBi5/h09YhZ4ikTmxi AQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3kmbm2ugem-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 03 Nov 2022 12:09:27 +0000
Received: from m0098420.ppops.net (m0098420.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 2A3AJvW7028378;
        Thu, 3 Nov 2022 12:09:26 GMT
Received: from ppma04fra.de.ibm.com (6a.4a.5195.ip4.static.sl-reverse.com [149.81.74.106])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3kmbm2ugdn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 03 Nov 2022 12:09:26 +0000
Received: from pps.filterd (ppma04fra.de.ibm.com [127.0.0.1])
        by ppma04fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 2A3C5aj2021403;
        Thu, 3 Nov 2022 12:09:24 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma04fra.de.ibm.com with ESMTP id 3kgut8xgvm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 03 Nov 2022 12:09:24 +0000
Received: from d06av24.portsmouth.uk.ibm.com (mk.ibm.com [9.149.105.60])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 2A3C9LwV25428580
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 3 Nov 2022 12:09:21 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id AE1DF42041;
        Thu,  3 Nov 2022 12:09:21 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 39BEB42042;
        Thu,  3 Nov 2022 12:09:21 +0000 (GMT)
Received: from [9.155.206.12] (unknown [9.155.206.12])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu,  3 Nov 2022 12:09:21 +0000 (GMT)
Message-ID: <913c05c0-90e7-be14-f873-2fa6f6830e73@linux.ibm.com>
Date:   Thu, 3 Nov 2022 13:09:20 +0100
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.4.1
Subject: Re: [PATCH 2/3] s390/netiucv: Fix return type of netiucv_tx()
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
 <20221102163252.49175-2-nathan@kernel.org>
From:   Alexandra Winter <wintera@linux.ibm.com>
In-Reply-To: <20221102163252.49175-2-nathan@kernel.org>
Content-Type: text/plain; charset=UTF-8
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: xIq9VlggrHD0aWo56u81gnjEL6N7uQHn
X-Proofpoint-GUID: hy9eSRtdG7OfsMOdmR_7C6x7wuxX7AcT
Content-Transfer-Encoding: 7bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-03_02,2022-11-03_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 mlxlogscore=999 malwarescore=0 impostorscore=0 clxscore=1015 spamscore=0
 lowpriorityscore=0 adultscore=0 suspectscore=0 bulkscore=0 mlxscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2210170000 definitions=main-2211030083
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
>   drivers/s390/net/netiucv.c:1854:21: error: incompatible function pointer types initializing 'netdev_tx_t (*)(struct sk_buff *, struct net_device *)' (aka 'enum netdev_tx (*)(struct sk_buff *, struct net_device *)') with an expression of type 'int (struct sk_buff *, struct net_device *)' [-Werror,-Wincompatible-function-pointer-types-strict]
>           .ndo_start_xmit         = netiucv_tx,
>                                     ^~~~~~~~~~
> 
> ->ndo_start_xmit() in 'struct net_device_ops' expects a return type of
> 'netdev_tx_t', not 'int'. Adjust the return type of netiucv_tx() to
> match the prototype's to resolve the warning and potential CFI failure,
> should s390 select ARCH_SUPPORTS_CFI_CLANG in the future.
> 
> Link: https://github.com/ClangBuiltLinux/linux/issues/1750
> Signed-off-by: Nathan Chancellor <nathan@kernel.org>
> ---
>  drivers/s390/net/netiucv.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/s390/net/netiucv.c b/drivers/s390/net/netiucv.c
> index 65aa0a96c21d..1a7f2bc3a87b 100644
> --- a/drivers/s390/net/netiucv.c
> +++ b/drivers/s390/net/netiucv.c
> @@ -1256,7 +1256,7 @@ static int netiucv_close(struct net_device *dev)
>   *         Note: If we return !0, then the packet is free'd by
>   *               the generic network layer.
>   */
> -static int netiucv_tx(struct sk_buff *skb, struct net_device *dev)
> +static netdev_tx_t netiucv_tx(struct sk_buff *skb, struct net_device *dev)
>  {
>  	struct netiucv_priv *privptr = netdev_priv(dev);
>  	int rc;

Could you please also remove the corresponding comments:
diff --git a/drivers/s390/net/netiucv.c b/drivers/s390/net/netiucv.c
index 65aa0a96c21d..21e36f63fbc7 100644
--- a/drivers/s390/net/netiucv.c
+++ b/drivers/s390/net/netiucv.c
@@ -1248,13 +1248,6 @@ static int netiucv_close(struct net_device *dev)
 /*
  * Start transmission of a packet.
  * Called from generic network device layer.
- *
- * @param skb Pointer to buffer containing the packet.
- * @param dev Pointer to interface struct.
- *
- * @return 0 if packet consumed, !0 if packet rejected.
- *         Note: If we return !0, then the packet is free'd by
- *               the generic network layer.
  */
 static int netiucv_tx(struct sk_buff *skb, struct net_device *dev)
 {

Reviewed-by: Alexandra Winter <wintera@linux.ibm.com>
