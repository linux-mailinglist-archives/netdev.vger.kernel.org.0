Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3563C5068DC
	for <lists+netdev@lfdr.de>; Tue, 19 Apr 2022 12:37:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348820AbiDSKkC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Apr 2022 06:40:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43060 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238239AbiDSKkB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Apr 2022 06:40:01 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B91372B19F;
        Tue, 19 Apr 2022 03:37:15 -0700 (PDT)
Received: from pps.filterd (m0098394.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 23J9L0pq028174;
        Tue, 19 Apr 2022 10:37:05 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=yC4FBruC+6vmK802CppACHaf5lBfmmagRdOytRhheOQ=;
 b=kX5fFS9LM6gl99AwAiFuCnczuIWq16fpxRKaOlSjfp+NI/mhhYZZ+ebFx5NwAxrnHBnn
 5xwnj2E/iHCV8p5jmDYPqMjf2dZesBHRuc1IXe7bZynVAWjFvNbZzP1IV2QtA2dJmhDR
 qHpceCNU00/OO+R/tYjTdnZQYRh0SUyCKMTzWG1APo6vOxY06myW5xipjlewnCj+PNUU
 D/5hkoCDKDQjmREUO6Z5LwnRpAOBNf62ZcbxWBBi8EN4rUtJe7QljhJ1KHJfcDOEv8Ql
 ujf46z4vnLM81B5rugkyX6n5XQRztOWknBOUyXppsE7GJm1+U28kzw/nvWZ1sAp2hK53 SQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3fg79x3u1s-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 19 Apr 2022 10:37:05 +0000
Received: from m0098394.ppops.net (m0098394.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 23JAb4FI026940;
        Tue, 19 Apr 2022 10:37:04 GMT
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3fg79x3u13-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 19 Apr 2022 10:37:04 +0000
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 23JAb2Ei032472;
        Tue, 19 Apr 2022 10:37:02 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma03ams.nl.ibm.com with ESMTP id 3ffne8m6g9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 19 Apr 2022 10:37:02 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 23JAb0tA33423738
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 19 Apr 2022 10:37:00 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id F10EDA4084;
        Tue, 19 Apr 2022 10:36:59 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 80DC1A4085;
        Tue, 19 Apr 2022 10:36:59 +0000 (GMT)
Received: from [9.171.65.20] (unknown [9.171.65.20])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 19 Apr 2022 10:36:59 +0000 (GMT)
Message-ID: <ed643c3d-6ad0-1b3c-1fe3-9157e7aa5859@linux.ibm.com>
Date:   Tue, 19 Apr 2022 12:37:12 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
Subject: Re: [PATCH] net/smc: sync err info when TCP connection is refused
Content-Language: en-US
To:     Tony Lu <tonylu@linux.alibaba.com>, yacanliu@163.com
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        linux-s390@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, liuyacan <liuyacan@corp.netease.com>
References: <20220417123307.1094747-1-yacanliu@163.com>
 <Yl6Nnvnrvqv3ofES@TonyMac-Alibaba>
From:   Karsten Graul <kgraul@linux.ibm.com>
Organization: IBM Deutschland Research & Development GmbH
In-Reply-To: <Yl6Nnvnrvqv3ofES@TonyMac-Alibaba>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 9GZAdY8RLP3kRzLJHUpw4rQi3LJ89Rd-
X-Proofpoint-ORIG-GUID: tTdBiRFx4PYqPSNgyd4cloEcdp8i9IBd
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-04-19_04,2022-04-15_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 clxscore=1011
 priorityscore=1501 bulkscore=0 mlxlogscore=999 spamscore=0 phishscore=0
 adultscore=0 impostorscore=0 lowpriorityscore=0 malwarescore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2204190058
X-Spam-Status: No, score=-5.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H4,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 19/04/2022 12:23, Tony Lu wrote:
> On Sun, Apr 17, 2022 at 08:33:07PM +0800, yacanliu@163.com wrote:
>> From: liuyacan <liuyacan@corp.netease.com>
>>
>> In the current implementation, when TCP initiates a connection
>> to an unavailable [ip,port], ECONNREFUSED will be stored in the
>> TCP socket, but SMC will not. However, some apps (like curl) use
>> getsockopt(,,SO_ERROR,,) to get the error information, which makes
>> them miss the error message and behave strangely.
>>
>> Signed-off-by: liuyacan <liuyacan@corp.netease.com>
> 
> This fix works for me. I have tested it with curl for unavailable
> address.
> 
> This patch missed net or net-next tag, I think net is preferred.
> 
> Reviewed-by: Tony Lu <tonylu@linux.alibaba.com>
> 
> Thank you,
> Tony Lu

Thank you both for the fix and the test!

Acked-by: Karsten Graul <kgraul@linux.ibm.com>
