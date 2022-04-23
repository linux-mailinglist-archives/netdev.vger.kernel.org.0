Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2EAE050C939
	for <lists+netdev@lfdr.de>; Sat, 23 Apr 2022 12:31:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234923AbiDWK36 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 23 Apr 2022 06:29:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234287AbiDWK3x (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 23 Apr 2022 06:29:53 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 686A563BCC;
        Sat, 23 Apr 2022 03:26:57 -0700 (PDT)
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 23N5iGYR022826;
        Sat, 23 Apr 2022 10:26:49 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=pp1;
 bh=YU6DuhMWdcCqR/esisKnTr9adDxkr5LITBnMOC56St0=;
 b=HvszEA+1PbErzd7LQ4sjqKedhogooYyUWasDXm97cypyjJ6hJhUfpVHh02Sk7H0xtfpR
 shAZDQt/dlOlqTPc9girsE83tA+bbeNucKXoHuufp49bnffPMdb72RusoaHdXCCVW/M6
 0vVnM7vzILMhEbwgorjElEF0PaI7wnhcIus8gDGOb8jsjvIFu3gdFzlu94XegVCM0FKO
 O0dZPfP4HjQSZUSw0Vry7Q/hGmmByHo9onoDnXGiokc1fjAA3A99twrBt6jZxi7TUFrN
 2QHh4EmYYe5Im/cg/yfoAFgePVqXCq7UY3inqGt+UcOdec8BOQK2cnHrT0kgQjiNboKa pg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3fmbjtjm55-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sat, 23 Apr 2022 10:26:49 +0000
Received: from m0098410.ppops.net (m0098410.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 23NANtUo018886;
        Sat, 23 Apr 2022 10:26:48 GMT
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3fmbjtjm4w-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sat, 23 Apr 2022 10:26:48 +0000
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 23NAJBCn026117;
        Sat, 23 Apr 2022 10:26:46 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma03ams.nl.ibm.com with ESMTP id 3fm938r9jv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sat, 23 Apr 2022 10:26:46 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 23NAQh4717301768
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 23 Apr 2022 10:26:43 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B840611C04A;
        Sat, 23 Apr 2022 10:26:43 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 61E1111C04C;
        Sat, 23 Apr 2022 10:26:43 +0000 (GMT)
Received: from [9.171.84.240] (unknown [9.171.84.240])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Sat, 23 Apr 2022 10:26:43 +0000 (GMT)
Message-ID: <67d3e987-47ba-160f-ed73-0dfe1e92c513@linux.ibm.com>
Date:   Sat, 23 Apr 2022 12:26:43 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.1
Subject: Re: [PATCH net 0/2] net/smc: Two fixes for smc fallback
Content-Language: en-US
To:     Wen Gu <guwen@linux.alibaba.com>, davem@davemloft.net,
        kuba@kernel.org
Cc:     linux-s390@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <1650614179-11529-1-git-send-email-guwen@linux.alibaba.com>
From:   Karsten Graul <kgraul@linux.ibm.com>
Organization: IBM Deutschland Research & Development GmbH
In-Reply-To: <1650614179-11529-1-git-send-email-guwen@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: 2CUIawL_-KQQfU_dJDQmS3Xqj4MoEqJX
X-Proofpoint-GUID: kOD7krKXrfscmW1WgjmafpbaIVQaF47V
Content-Transfer-Encoding: 7bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-04-23_01,2022-04-22_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0
 malwarescore=0 bulkscore=0 phishscore=0 adultscore=0 lowpriorityscore=0
 spamscore=0 suspectscore=0 clxscore=1015 priorityscore=1501
 mlxlogscore=908 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2204230046
X-Spam-Status: No, score=-3.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 22/04/2022 09:56, Wen Gu wrote:
> This patch set includes two fixes for smc fallback:
> 
> Patch 1/2 introduces some simple helpers to wrap the replacement
> and restore of clcsock's callback functions. Make sure that only
> the original callbacks will be saved and not overwritten.
> 
> Patch 2/2 fixes a syzbot reporting slab-out-of-bound issue where
> smc_fback_error_report() accesses the already freed smc sock (see
> https://lore.kernel.org/r/00000000000013ca8105d7ae3ada@google.com/).
> The patch fixes it by resetting sk_user_data and restoring clcsock
> callback functions timely in fallback situation.

Thank you for the analysis and the fix!

For the series:
Acked-by: Karsten Graul <kgraul@linux.ibm.com>
