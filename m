Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4D61D617B56
	for <lists+netdev@lfdr.de>; Thu,  3 Nov 2022 12:07:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230196AbiKCLGp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Nov 2022 07:06:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38568 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229379AbiKCLGn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Nov 2022 07:06:43 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A08B11807;
        Thu,  3 Nov 2022 04:06:41 -0700 (PDT)
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 2A3AxHvx020904;
        Thu, 3 Nov 2022 11:06:31 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=pp1;
 bh=D5ZJYJJzdmKl6VKB1x+ZsgHobgWwnL9dR8vjBV6faE8=;
 b=lwgcEoDimMaI/xjA3zAtyfRzYiwcWmF/SHFWieBDo4vO14JVA3ghlS7mJlmb0B858FJe
 aAYRk/tOSoE8NgKMTa85XRbk1On0blIySGHM62lJf4RgLsaUZSX9GmBO4N0Rcg5qWiHk
 jQS5vfX7bdJ0dXGmz9+4h/S2CyaYFe9q8e67cW7TL6nZaH6/QKyr7AQ9fku83Y3rZ8B8
 8VoWK8kFD2FsKIm4yGuIwqyFc6UYFnljwNfB8XlanhuIlsXz/HaYsABZxgZWqi9z/KRG
 4/foEBbGBqGHeBEg7NzaUWhwQrXkiZYwCOqpjEv2t9tU+FXQtL7X385DGJ9eDkMwlQ/z +A== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3km6pgtr2t-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 03 Nov 2022 11:06:31 +0000
Received: from m0098417.ppops.net (m0098417.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 2A3A6ZAn030604;
        Thu, 3 Nov 2022 11:06:30 GMT
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3km6pgtr21-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 03 Nov 2022 11:06:30 +0000
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 2A3B5AX7004419;
        Thu, 3 Nov 2022 11:06:28 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma04ams.nl.ibm.com with ESMTP id 3kgut98kg6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 03 Nov 2022 11:06:28 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 2A3B6PI754460900
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 3 Nov 2022 11:06:25 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 4DA5B52077;
        Thu,  3 Nov 2022 11:06:25 +0000 (GMT)
Received: from [9.155.206.12] (unknown [9.155.206.12])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id C7A2A52076;
        Thu,  3 Nov 2022 11:06:24 +0000 (GMT)
Message-ID: <c7f5b3db-76f8-2772-b2cd-355f0c4c55b1@linux.ibm.com>
Date:   Thu, 3 Nov 2022 12:06:24 +0100
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.4.1
Subject: Re: [PATCH 1/3] s390/ctcm: Fix return type of ctc{mp,}m_tx()
Content-Language: en-US
To:     Kees Cook <keescook@chromium.org>,
        Nathan Chancellor <nathan@kernel.org>
Cc:     Wenjia Zhang <wenjia@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Sven Schnelle <svens@linux.ibm.com>,
        linux-s390@vger.kernel.org, netdev@vger.kernel.org,
        Nick Desaulniers <ndesaulniers@google.com>,
        Tom Rix <trix@redhat.com>,
        Sami Tolvanen <samitolvanen@google.com>, llvm@lists.linux.dev,
        linux-kernel@vger.kernel.org, patches@lists.linux.dev
References: <20221102163252.49175-1-nathan@kernel.org>
 <202211021209.276A8BA@keescook>
From:   Alexandra Winter <wintera@linux.ibm.com>
In-Reply-To: <202211021209.276A8BA@keescook>
Content-Type: text/plain; charset=UTF-8
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: iq7UUNIrJuydhwvZ29r6r-zMkTvVR5Kx
X-Proofpoint-GUID: 48HCB_04PtbYHLC3D9-pEU7WJvQCjLA5
Content-Transfer-Encoding: 7bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-03_02,2022-11-03_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1011
 lowpriorityscore=0 priorityscore=1501 phishscore=0 spamscore=0
 impostorscore=0 mlxlogscore=999 mlxscore=0 malwarescore=0 adultscore=0
 suspectscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2210170000 definitions=main-2211030076
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 02.11.22 20:09, Kees Cook wrote:
> On Wed, Nov 02, 2022 at 09:32:50AM -0700, Nathan Chancellor wrote:
>> With clang's kernel control flow integrity (kCFI, CONFIG_CFI_CLANG),
>> indirect call targets are validated against the expected function
>> pointer prototype to make sure the call target is valid to help mitigate
>> ROP attacks. If they are not identical, there is a failure at run time,
>> which manifests as either a kernel panic or thread getting killed. A
>> proposed warning in clang aims to catch these at compile time, which
>> reveals:
>>
>>   drivers/s390/net/ctcm_main.c:1064:21: error: incompatible function pointer types initializing 'netdev_tx_t (*)(struct sk_buff *, struct net_device *)' (aka 'enum netdev_tx (*)(struct sk_buff *, struct net_device *)') with an expression of type 'int (struct sk_buff *, struct net_device *)' [-Werror,-Wincompatible-function-pointer-types-strict]
>>           .ndo_start_xmit         = ctcm_tx,
>>                                     ^~~~~~~
>>   drivers/s390/net/ctcm_main.c:1072:21: error: incompatible function pointer types initializing 'netdev_tx_t (*)(struct sk_buff *, struct net_device *)' (aka 'enum netdev_tx (*)(struct sk_buff *, struct net_device *)') with an expression of type 'int (struct sk_buff *, struct net_device *)' [-Werror,-Wincompatible-function-pointer-types-strict]
>>           .ndo_start_xmit         = ctcmpc_tx,
>>                                     ^~~~~~~~~
>>
>> ->ndo_start_xmit() in 'struct net_device_ops' expects a return type of
>> 'netdev_tx_t', not 'int'. Adjust the return type of ctc{mp,}m_tx() to
>> match the prototype's to resolve the warning and potential CFI failure,
>> should s390 select ARCH_SUPPORTS_CFI_CLANG in the future.
>>
>> Link: https://github.com/ClangBuiltLinux/linux/issues/1750
>> Signed-off-by: Nathan Chancellor <nathan@kernel.org>
> 
> Reviewed-by: Kees Cook <keescook@chromium.org>
> 

Could you please also remove the corresponding comments:
diff --git a/drivers/s390/net/ctcm_main.c b/drivers/s390/net/ctcm_main.c
index 37b551bd43bf..14200548704a 100644
--- a/drivers/s390/net/ctcm_main.c
+++ b/drivers/s390/net/ctcm_main.c
@@ -825,13 +825,6 @@ static int ctcmpc_transmit_skb(struct channel *ch, struct sk_buff *skb)
 /*
  * Start transmission of a packet.
  * Called from generic network device layer.
- *
- *  skb                Pointer to buffer containing the packet.
- *  dev                Pointer to interface struct.
- *
- * returns 0 if packet consumed, !0 if packet rejected.
- *         Note: If we return !0, then the packet is free'd by
- *               the generic network layer.
  */
 /* first merge version - leaving both functions separated */
 static int ctcm_tx(struct sk_buff *skb, struct net_device *dev)

Reviewed-by: Alexandra Winter <wintera@linux.ibm.com>
