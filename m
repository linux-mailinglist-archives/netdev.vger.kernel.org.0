Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 89EC6508E5A
	for <lists+netdev@lfdr.de>; Wed, 20 Apr 2022 19:23:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344045AbiDTR0V (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Apr 2022 13:26:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42292 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243846AbiDTR0T (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Apr 2022 13:26:19 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BCE9645065
        for <netdev@vger.kernel.org>; Wed, 20 Apr 2022 10:23:32 -0700 (PDT)
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 23KFTAhD008004;
        Wed, 20 Apr 2022 17:23:31 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=RvXYz86dtfi5pwU9unYA4/BVHSmLIYSunXFgIu2jk78=;
 b=R/X3fkcDezNBWPJx9u9OPzo/xPr1EHglY8ua8qQlEiF6PE+//W/CJPGVnHhkgfGOy979
 sobB02Gdm9WTLhEm/5aA/anR7gavO06ncfa5LB5Pkts7owhJHY6/MgalIjRn39BpApox
 0xTaoz09ZrxkEQzhs8X1w2iXWiaNwQfgnMkU1NSsPO+kPURenGga5mnb7ySqMUTKeQJd
 0lFp2N3WgCMbV/u3gnfxFaqgKwCR/oThC1KDre98fDSFaVJpD9dceIEz4O8JfnzNkvwS
 u7k43T1q0vH7IkV+BuJTyZCnO2iif+2JEpjhnCStp1u26Q7csbu4FaWQLI9semfPPG9q zA== 
Received: from ppma01wdc.us.ibm.com (fd.55.37a9.ip4.static.sl-reverse.com [169.55.85.253])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3fg7kbfds2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 20 Apr 2022 17:23:31 +0000
Received: from pps.filterd (ppma01wdc.us.ibm.com [127.0.0.1])
        by ppma01wdc.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 23KHHcho009372;
        Wed, 20 Apr 2022 17:23:30 GMT
Received: from b03cxnp08026.gho.boulder.ibm.com (b03cxnp08026.gho.boulder.ibm.com [9.17.130.18])
        by ppma01wdc.us.ibm.com with ESMTP id 3ffneadx5c-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 20 Apr 2022 17:23:30 +0000
Received: from b03ledav006.gho.boulder.ibm.com (b03ledav006.gho.boulder.ibm.com [9.17.130.237])
        by b03cxnp08026.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 23KHNTgH30343604
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 20 Apr 2022 17:23:29 GMT
Received: from b03ledav006.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3D04DC605B;
        Wed, 20 Apr 2022 17:23:29 +0000 (GMT)
Received: from b03ledav006.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E7521C6057;
        Wed, 20 Apr 2022 17:23:28 +0000 (GMT)
Received: from [9.163.5.13] (unknown [9.163.5.13])
        by b03ledav006.gho.boulder.ibm.com (Postfix) with ESMTP;
        Wed, 20 Apr 2022 17:23:28 +0000 (GMT)
Message-ID: <abffa0b0-300d-8ecd-8319-c99621198c86@linux.vnet.ibm.com>
Date:   Wed, 20 Apr 2022 10:23:28 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.8.0
Subject: Re: [EXT] EEH Causes bnx2x to Hang in napi_disable
Content-Language: en-US
To:     Manish Chopra <manishc@marvell.com>,
        Netdev <netdev@vger.kernel.org>,
        Ariel Elior <aelior@marvell.com>,
        Sudarsana Reddy Kalluru <skalluru@marvell.com>
References: <e478c5c4-3c0f-705b-6215-8bad6084f536@linux.vnet.ibm.com>
 <BY3PR18MB4612CB2F82889E5B155BD03EABEE9@BY3PR18MB4612.namprd18.prod.outlook.com>
From:   David Christensen <drc@linux.vnet.ibm.com>
In-Reply-To: <BY3PR18MB4612CB2F82889E5B155BD03EABEE9@BY3PR18MB4612.namprd18.prod.outlook.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: vgl8g3wSEotG7Fdn-8DAYJ7CRLbVFiGb
X-Proofpoint-GUID: vgl8g3wSEotG7Fdn-8DAYJ7CRLbVFiGb
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-04-20_05,2022-04-20_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0 spamscore=0
 priorityscore=1501 adultscore=0 malwarescore=0 suspectscore=0 phishscore=0
 mlxscore=0 mlxlogscore=829 bulkscore=0 lowpriorityscore=0 clxscore=1015
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2204200101
X-Spam-Status: No, score=-6.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H3,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

>> ----------------------------------------------------------------------
>> Experiencing an inaccessible system when bnx2x attempts to recover from an
>> injected EEH error. This is a POWER10 system running SLES 15 SP3
>> (5.3.18-150300.59.49-default) with a BCM57810 dual port NIC.
>>
> Thanks for reporting this issue, I tried to reproduce the same issue where in my case it leaded to system crash but it was not exactly the same
> symptom of hang/stuck in napi_disable(). But I believe they all have the same root cause for different issues as you stated about the incorrect
> sequence of NAPI API usage in this particular driver flow (unlike in regular unload flow (ndo_stop()) where it deletes NAPI after it disables the NAPI).
> So driver actually needs to disable NAPI first and delete the NAPI afterwards, I tried below change which fixed the crash which I was always seeing on
> my setup.
> 
> Can you please try this below change to see if that helps for the issue you reported or not ?

Glad to report that it fixed our problem as well.  Thanks for the help.

Dave
