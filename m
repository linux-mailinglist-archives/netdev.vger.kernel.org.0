Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B1C0E603484
	for <lists+netdev@lfdr.de>; Tue, 18 Oct 2022 23:01:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230000AbiJRVBl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Oct 2022 17:01:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44244 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229756AbiJRVBj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Oct 2022 17:01:39 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 102647333D
        for <netdev@vger.kernel.org>; Tue, 18 Oct 2022 14:01:25 -0700 (PDT)
Received: from pps.filterd (m0187473.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 29IKg5GG022393;
        Tue, 18 Oct 2022 21:00:18 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=2L1KuEpM2clY5yrNUxF0t8gHaGAfMogZpGNaqOkm4zI=;
 b=NCqA73I0AMG9IAE1wAFtJRdZCUvYAm7Z7w3TcbvxIe/KxcBdlZXM3KdYMLz98/+iQCoz
 vROwu+6zfWklwAvWXJYZ0v130n7EKPml63vFde9VjO8VjH8bXX5kJtf7HYaAgU3McvVH
 0Rrw0qpFgckhhxx1TqEYx4h978HR7yLiiNFBLWjoq1rOanddsVpyjynHOO+Vyvp817e2
 jlzVKRoad5KbdYXH6sthV1w6eUQ4sRA/8/dOGJcR4MYFsdyzGhtkIo95nxm/aymgtGCo
 WVWHJyIro6hklh3EOrdOcsintZb5GVL9nythuMPmm6cZvMLf4861/nO7TgRtOY6tAJcM xw== 
Received: from ppma03dal.us.ibm.com (b.bd.3ea9.ip4.static.sl-reverse.com [169.62.189.11])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3ka3dkgf1w-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 18 Oct 2022 21:00:18 +0000
Received: from pps.filterd (ppma03dal.us.ibm.com [127.0.0.1])
        by ppma03dal.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 29IKoNiN009336;
        Tue, 18 Oct 2022 21:00:17 GMT
Received: from b03cxnp08026.gho.boulder.ibm.com (b03cxnp08026.gho.boulder.ibm.com [9.17.130.18])
        by ppma03dal.us.ibm.com with ESMTP id 3k7mg9v8p9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 18 Oct 2022 21:00:17 +0000
Received: from smtpav01.dal12v.mail.ibm.com ([9.208.128.133])
        by b03cxnp08026.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 29IL0Iw34850334
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 18 Oct 2022 21:00:18 GMT
Received: from smtpav01.dal12v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 1A3C25806B;
        Tue, 18 Oct 2022 21:00:15 +0000 (GMT)
Received: from smtpav01.dal12v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B204B58066;
        Tue, 18 Oct 2022 21:00:14 +0000 (GMT)
Received: from [9.160.6.192] (unknown [9.160.6.192])
        by smtpav01.dal12v.mail.ibm.com (Postfix) with ESMTP;
        Tue, 18 Oct 2022 21:00:14 +0000 (GMT)
Message-ID: <94c6ed71-286b-0fd8-5128-9fe9b7ebcd0f@linux.ibm.com>
Date:   Tue, 18 Oct 2022 16:00:14 -0500
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.2
Subject: Re: [PATCH net-next] ibmveth: Always stop tx queues during close
Content-Language: en-US
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, nick.child@ibm.com
References: <20221017151743.45704-1-nnac123@linux.ibm.com>
 <20221018114729.79dbfbe2@kernel.org>
From:   Nick Child <nnac123@linux.ibm.com>
In-Reply-To: <20221018114729.79dbfbe2@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 6UVpLKVxb45Jg0t2optFgSeyFr8-6Y_y
X-Proofpoint-ORIG-GUID: 6UVpLKVxb45Jg0t2optFgSeyFr8-6Y_y
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-10-18_07,2022-10-18_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0
 priorityscore=1501 adultscore=0 malwarescore=0 impostorscore=0
 mlxlogscore=976 lowpriorityscore=0 mlxscore=0 bulkscore=0 suspectscore=0
 clxscore=1015 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2209130000 definitions=main-2210180115
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Hello Jakub,

Thanks for the review,

On 10/18/22 13:47, Jakub Kicinski wrote:
> On Mon, 17 Oct 2022 10:17:43 -0500 Nick Child wrote:
>> The issue with this approach was that the hypervisor freed all of
>> the devices control structures after the hcall H_FREE_LOGICAL_LAN
>> was performed but the transmit queues were never stopped. So the higher
>> layers in the network stack would continue transmission but any
>> H_SEND_LOGICAL_LAN hcall would fail with H_PARAMETER until the
>> hypervisor's structures for the device were allocated with the
>> H_REGISTER_LOGICAL_LAN hcall in ibmveth_open.
> 
> Sounds like we should treat this one as a fix as well?

Agreed. I will resend with `net` tag.


> How far back is it safe to backport?
The issue is introduced in commit 860f242eb534 ("[PATCH] ibmveth change 
buffer pools dynamically") which first appears in v3.19.
Please let me know if I should resend with "Fixes:".

Since the aforementioned commit, multiple other patches have mimicked 
the behavior. Because the same bad logic is used in multiple places, 
their will be multiple merge conflicts depending on the LTS branch. From
what I can tell the patch will differ between the one posted here 
(v6.1), LTS v4.14-5.15, and LTS v4.9.

Since the issue only results in annoying "failed to send" driver 
messages and is under no pressure to get backported from end users, we 
are okay if it does not get backported. That being said, if you would 
like to see it backported, I can send you the patches that would apply
cleanly to v4.9 and v4.14-v5.15.

If there is anything else I can do please let me know.

Thanks again,
Nick Child
