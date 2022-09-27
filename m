Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 118055EC48A
	for <lists+netdev@lfdr.de>; Tue, 27 Sep 2022 15:33:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232927AbiI0Ndy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Sep 2022 09:33:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43754 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232007AbiI0NdZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Sep 2022 09:33:25 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9DB3929CB2;
        Tue, 27 Sep 2022 06:32:03 -0700 (PDT)
Received: from pps.filterd (m0187473.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 28RC7MK7021419;
        Tue, 27 Sep 2022 13:31:55 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=MdCRng429X186D9J5471uKUeBpf1L3mUsZeSHfDOuuo=;
 b=Ea++vmzat+1IfdSk5AE8yUJBcop1GbKcnP2NoXbX/dbGGYA9QRi9t7/kwgfnN8xIIfaL
 ggq5fz5qhSr2SSScuUd8DxhEzavE23skcgkzrLFTnZU0ceiFXTsIpTAssbbXEOrW/epZ
 EqfP5OMXXosSPMJkwk4zR2/GxKxl1L8lwy5oiYiP4YYslzHH7ycs7K9wchAVC/J9tj2V
 I+qPKnzogVaBILi2/4xNhUg3r5a/Qt10bH0/BqvQreC7ysYW6Rxy39WkiZyfzYnxtKCJ
 pTFaQY/djLGnmjUF9SIinb6C9jU0apkHWuSkafNwlZmv8JVcz6DNbJsb6ibeUnYBrSPV JA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3juwmn0x1h-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 27 Sep 2022 13:31:54 +0000
Received: from m0187473.ppops.net (m0187473.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 28RC7woq023440;
        Tue, 27 Sep 2022 13:31:54 GMT
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3juwmn0wyy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 27 Sep 2022 13:31:54 +0000
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 28RDQB7l007072;
        Tue, 27 Sep 2022 13:31:51 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma06ams.nl.ibm.com with ESMTP id 3jss5j3w2g-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 27 Sep 2022 13:31:51 +0000
Received: from d06av24.portsmouth.uk.ibm.com (mk.ibm.com [9.149.105.60])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 28RDVmtU5374536
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 27 Sep 2022 13:31:48 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 8808642041;
        Tue, 27 Sep 2022 13:31:48 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 401AF42042;
        Tue, 27 Sep 2022 13:31:48 +0000 (GMT)
Received: from [9.152.224.236] (unknown [9.152.224.236])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 27 Sep 2022 13:31:48 +0000 (GMT)
Message-ID: <03ac1fb3-ea5d-d5b8-1d7e-92c13fba339d@linux.ibm.com>
Date:   Tue, 27 Sep 2022 15:31:47 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.13.1
Subject: Re: [PATCH 3/7] s390/qeth: Convert snprintf() to scnprintf()
Content-Language: en-US
To:     Jakub Kicinski <kuba@kernel.org>,
        Jules Irenge <jbi.octave@gmail.com>
Cc:     borntraeger@linux.ibm.com, svens@linux.ibm.com,
        linux-s390@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, agordeev@linux.ibm.com
References: <YzHyniCyf+G/2xI8@fedora> <20220926173312.7a735619@kernel.org>
From:   Alexandra Winter <wintera@linux.ibm.com>
In-Reply-To: <20220926173312.7a735619@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: M714Eh_pQXytoOwcg4b1iSr1bFrEZ10w
X-Proofpoint-ORIG-GUID: LrFxKqbuAeCJmJhsbHQj367zWD2JyA2_
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.528,FMLib:17.11.122.1
 definitions=2022-09-27_05,2022-09-27_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 impostorscore=0
 bulkscore=0 mlxscore=0 clxscore=1015 suspectscore=0 lowpriorityscore=0
 mlxlogscore=819 spamscore=0 phishscore=0 priorityscore=1501 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2209130000
 definitions=main-2209270080
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 27.09.22 02:33, Jakub Kicinski wrote:
> On Mon, 26 Sep 2022 19:42:38 +0100 Jules Irenge wrote:
>> Coccinnelle reports a warning
>> Warning: Use scnprintf or sprintf
>> Adding to that, there has been a slow migration from snprintf to scnprintf.
>> This LWN article explains the rationale for this change
>> https: //lwn.net/Articles/69419/
>> Ie. snprintf() returns what *would* be the resulting length,
>> while scnprintf() returns the actual length.
>>
>> Signed-off-by: Jules Irenge <jbi.octave@gmail.com>
> 
> Looks legit but please repost this separately.
> We only see patch 3 of the series.
When you repost, you can add
Reviewed-by: Alexandra Winter <wintera@linux.ibm.com>

Thank you
Alexandra
