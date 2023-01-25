Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8CD7D67BA88
	for <lists+netdev@lfdr.de>; Wed, 25 Jan 2023 20:16:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234999AbjAYTQv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Jan 2023 14:16:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35600 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229505AbjAYTQu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Jan 2023 14:16:50 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 90A37C157
        for <netdev@vger.kernel.org>; Wed, 25 Jan 2023 11:16:49 -0800 (PST)
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 30PJCK2P011313;
        Wed, 25 Jan 2023 19:16:46 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=Kw6y/k3JVtY/PJ+o+FkxSFGfrlT5w8ZPzHsbbKZuVNc=;
 b=QNwZ1i2W0T3JW3KzgxAk8rDjD1UbSGTXL2zm8gm3Lrk5dd4lEN9dSaHAV6Q+bmMcJP08
 6Eetx8IJI14Ldxaue0hHuFDnqks9XlZJcnOrmGpE5P0xL6dr4sJgF2JSkgnjziCejT1M
 oB5h3DE9iXJViihoFek/jdiLlRZKPkwe1j2qs3i4UN9lzgrlvNsKbgWqXA0i+Von2rkI
 4hE+rLNgrjhqAaRuR4j0NKVtgAlt8lyR9PZsondc3zEyFb4+qAxw404h+8S6SFGn4KYc
 SiUPOptV74FFP250fMXBOhoAFXuj4mrecLRcG4WJHi3DVJ9cgdQWXetdm5sGU9pmasb9 xg== 
Received: from ppma01dal.us.ibm.com (83.d6.3fa9.ip4.static.sl-reverse.com [169.63.214.131])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3nb8yu2d2b-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 25 Jan 2023 19:16:46 +0000
Received: from pps.filterd (ppma01dal.us.ibm.com [127.0.0.1])
        by ppma01dal.us.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 30PGkIKS004500;
        Wed, 25 Jan 2023 19:16:45 GMT
Received: from smtprelay06.dal12v.mail.ibm.com ([9.208.130.100])
        by ppma01dal.us.ibm.com (PPS) with ESMTPS id 3n87p87tw2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 25 Jan 2023 19:16:45 +0000
Received: from smtpav02.wdc07v.mail.ibm.com (smtpav02.wdc07v.mail.ibm.com [10.39.53.229])
        by smtprelay06.dal12v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 30PJGhgY000712
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 25 Jan 2023 19:16:44 GMT
Received: from smtpav02.wdc07v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id AD2ED5805B;
        Wed, 25 Jan 2023 19:16:43 +0000 (GMT)
Received: from smtpav02.wdc07v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 894085805D;
        Wed, 25 Jan 2023 19:16:42 +0000 (GMT)
Received: from [9.65.236.34] (unknown [9.65.236.34])
        by smtpav02.wdc07v.mail.ibm.com (Postfix) with ESMTP;
        Wed, 25 Jan 2023 19:16:42 +0000 (GMT)
Message-ID: <c2ee03e3-0947-5f25-da09-79d387e62ed2@linux.vnet.ibm.com>
Date:   Wed, 25 Jan 2023 11:16:41 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.13.0
Subject: Re: [PATCH net-next] ibmvnic: Toggle between queue types in affinity
 mapping
Content-Language: en-US
To:     Jakub Kicinski <kuba@kernel.org>,
        Nick Child <nnac123@linux.ibm.com>
Cc:     netdev@vger.kernel.org, bjking1@linux.ibm.com, haren@linux.ibm.com,
        ricklind@us.ibm.com
References: <20230123221727.30423-1-nnac123@linux.ibm.com>
 <20230124183925.257621e8@kernel.org>
From:   Rick Lindsley <ricklind@linux.vnet.ibm.com>
In-Reply-To: <20230124183925.257621e8@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: yO9X3fPCTr68JpPX3i61ycS_aWymGlLg
X-Proofpoint-ORIG-GUID: yO9X3fPCTr68JpPX3i61ycS_aWymGlLg
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.122.1
 definitions=2023-01-25_13,2023-01-25_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0
 mlxlogscore=884 impostorscore=0 adultscore=0 priorityscore=1501 mlxscore=0
 phishscore=0 malwarescore=0 bulkscore=0 lowpriorityscore=0 clxscore=1011
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2301250169
X-Spam-Status: No, score=-3.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 1/24/23 18:39, Jakub Kicinski wrote:

> Seems sensible but why did you invert the order? To save LoC?

Proc zero is often the default vector for other interrupts.  If we're going to diddle with the irq's for performance,  it would make sense to me to steer around proc 0.

Rick

