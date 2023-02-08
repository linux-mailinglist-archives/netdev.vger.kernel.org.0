Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DAF9F68F6E7
	for <lists+netdev@lfdr.de>; Wed,  8 Feb 2023 19:30:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231758AbjBHSag (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Feb 2023 13:30:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60828 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230290AbjBHSaf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Feb 2023 13:30:35 -0500
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 31A2C1F4B6;
        Wed,  8 Feb 2023 10:30:35 -0800 (PST)
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 318IEIXM015668;
        Wed, 8 Feb 2023 18:30:26 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=5smuUaoNvL6NYygKsHmfLz7PjJxGaIVIIwAGufAl5+o=;
 b=iI4mdQtFQhwaBNYien7GsdFq238gYXKmaQdPcQmhtSNtyRx4vGUBksPliAMl+9DTMFb3
 R8kOrw0Z6HeKYkPkkDIYbB++L1bOB5y+DYd30r3I79HP7gFW6mcTs/+0L4Z/tNncL8t/
 VE/f0dv4JnSnWhVr4Nj9okBjEz6aEtUA3raYYJ5DbWWfaL2WT2FlhVkgPPEA1wTm8gct
 YPU6XPmVxKI8eKmbJmcq7jKPFrUd8+2lWwhoMaguNQsWqBPxMMUJAfx3SH8OHwImVw+m
 +FM8A7IIGzU5wwUMyB9G0h4hK5aSr+vWTQ6N/KqdQBWs95MXl26qud8GyfXTI8aon0U1 MA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3nmgu50jx0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 08 Feb 2023 18:30:26 +0000
Received: from m0098421.ppops.net (m0098421.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 318IEIrY015657;
        Wed, 8 Feb 2023 18:30:25 GMT
Received: from ppma01fra.de.ibm.com (46.49.7a9f.ip4.static.sl-reverse.com [159.122.73.70])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3nmgu50jvq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 08 Feb 2023 18:30:25 +0000
Received: from pps.filterd (ppma01fra.de.ibm.com [127.0.0.1])
        by ppma01fra.de.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 3183jRAH003761;
        Wed, 8 Feb 2023 18:30:23 GMT
Received: from smtprelay03.fra02v.mail.ibm.com ([9.218.2.224])
        by ppma01fra.de.ibm.com (PPS) with ESMTPS id 3nhf06kqdy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 08 Feb 2023 18:30:23 +0000
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
        by smtprelay03.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 318IUKCS39649672
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 8 Feb 2023 18:30:20 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 12B8D20040;
        Wed,  8 Feb 2023 18:30:20 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 9CA6620043;
        Wed,  8 Feb 2023 18:30:19 +0000 (GMT)
Received: from [9.171.33.244] (unknown [9.171.33.244])
        by smtpav02.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Wed,  8 Feb 2023 18:30:19 +0000 (GMT)
Message-ID: <d0f3a634-6c47-2b5d-0c20-8ef1e3a5a004@linux.ibm.com>
Date:   Wed, 8 Feb 2023 19:30:19 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.6.1
Subject: Re: [PATCH net-next 3/4] s390/qeth: Convert sysfs sprintf to
 sysfs_emit
Content-Language: en-US
To:     Joe Perches <joe@perches.com>, David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, linux-s390@vger.kernel.org,
        Heiko Carstens <hca@linux.ibm.com>,
        Thorsten Winkler <twinkler@linux.ibm.com>,
        Jules Irenge <jbi.octave@gmail.com>
References: <20230206172754.980062-1-wintera@linux.ibm.com>
 <20230206172754.980062-4-wintera@linux.ibm.com>
 <c6dc6cf574379a937fdc7718c0516fbdcd82a729.camel@perches.com>
From:   Alexandra Winter <wintera@linux.ibm.com>
In-Reply-To: <c6dc6cf574379a937fdc7718c0516fbdcd82a729.camel@perches.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: WxTsxpQYrm4BARCdHYEtmYMDocAjt4SK
X-Proofpoint-ORIG-GUID: 9_y2BsY89cOyH2WIR1tgQ-bUbdTaSIdl
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.122.1
 definitions=2023-02-08_08,2023-02-08_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 adultscore=0
 mlxlogscore=749 priorityscore=1501 lowpriorityscore=0 bulkscore=0
 impostorscore=0 mlxscore=0 suspectscore=0 spamscore=0 malwarescore=0
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2302080158
X-Spam-Status: No, score=-3.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 07.02.23 17:06, Joe Perches wrote:
> On Mon, 2023-02-06 at 18:27 +0100, Alexandra Winter wrote:
>> From: Thorsten Winkler <twinkler@linux.ibm.com>
...
> 
> One of the intended uses of sysfs_emit is to not require the
> knowlege of buf as PAGE_SIZE so it could possibly be
> extended/changed.
> 
> So perhaps the use of entry_len is useless and the PAGE_SIZE use
> above should be removed.
> 

Thanks a lot for pointing that out. Will send a v2 tomorrow.

> The below though could emit a partial line, dunno if that's a
> good thing or not but sysfs is not supposed to emit multiple
> lines anyway.

Agree, this may not be the best usage of sysfs.
But we don't want to change existing behaviour with this patch.

