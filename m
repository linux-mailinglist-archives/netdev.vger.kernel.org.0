Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 61A5B6D94D4
	for <lists+netdev@lfdr.de>; Thu,  6 Apr 2023 13:14:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236833AbjDFLOm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Apr 2023 07:14:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43268 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229771AbjDFLOl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Apr 2023 07:14:41 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6EE91E6;
        Thu,  6 Apr 2023 04:14:40 -0700 (PDT)
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3368qPG8011886;
        Thu, 6 Apr 2023 11:14:36 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=WjEAuWLkS9VAxEzf203T1+TPUhyVG+CqnTJOgnevsgM=;
 b=hIfsr24GJBPrrREnaBWIwEALiXZwnLtAkeqY+V3yjr64Z5gA7FDotLDDdFxMlMkYY+db
 X6WVN65GdJf7DaV2YMmSminAVkRGd3lBGD4ZYnWck6UYe24RqsmMnhXo9DT38HygnjMb
 mHE0JgWmKR6/7rPFautu1KUyK+kReZTIp/wgHO2DOIa4Sosv89w2a1qNqOrur8h/sgVC
 qpXXMzV/8XGq/FDbQc3X227ifSUkBbTj21TiTtB0tIeRqv+Ai+OjSxME2MMhStTkdEGd
 rjVG4kY24mh6DPc+llYVXWDTbMTgkHXeBaDdRE9eeVjoa+sxRKbUYT2fyp8wcWfVuiwd yw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3psar79fvj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 06 Apr 2023 11:14:35 +0000
Received: from m0098399.ppops.net (m0098399.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 336B07qr030927;
        Thu, 6 Apr 2023 11:14:35 GMT
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3psar79fut-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 06 Apr 2023 11:14:35 +0000
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 3364GjDZ027288;
        Thu, 6 Apr 2023 11:14:33 GMT
Received: from smtprelay01.fra02v.mail.ibm.com ([9.218.2.227])
        by ppma04ams.nl.ibm.com (PPS) with ESMTPS id 3ppc87c8pw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 06 Apr 2023 11:14:32 +0000
Received: from smtpav03.fra02v.mail.ibm.com (smtpav03.fra02v.mail.ibm.com [10.20.54.102])
        by smtprelay01.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 336BETMu61866262
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 6 Apr 2023 11:14:29 GMT
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 0CBFC2004D;
        Thu,  6 Apr 2023 11:14:29 +0000 (GMT)
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 9F8C220043;
        Thu,  6 Apr 2023 11:14:28 +0000 (GMT)
Received: from [9.152.224.183] (unknown [9.152.224.183])
        by smtpav03.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Thu,  6 Apr 2023 11:14:28 +0000 (GMT)
Message-ID: <33ab688e-88c9-d950-be66-f0f79774ff6c@linux.ibm.com>
Date:   Thu, 6 Apr 2023 13:14:28 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.9.1
Subject: Re: [RFC PATCH net-next v4 0/9] net/smc: Introduce SMC-D-based OS
 internal communication acceleration
To:     Niklas Schnelle <schnelle@linux.ibm.com>,
        Wen Gu <guwen@linux.alibaba.com>, kgraul@linux.ibm.com,
        wenjia@linux.ibm.com, jaka@linux.ibm.com, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com
Cc:     linux-s390@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <1679887699-54797-1-git-send-email-guwen@linux.alibaba.com>
 <6156aaad710bc7350cbae6cb821289c8a37f44bb.camel@linux.ibm.com>
Content-Language: en-US
From:   Alexandra Winter <wintera@linux.ibm.com>
In-Reply-To: <6156aaad710bc7350cbae6cb821289c8a37f44bb.camel@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: I5uCFC6L47uNjIs2DB9yjf9t5XvJvDUe
X-Proofpoint-GUID: n3LH0WtZmqozgv_4YrVMHpESp8mAnFCi
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-04-06_04,2023-04-05_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 malwarescore=0 bulkscore=0 phishscore=0 impostorscore=0 adultscore=0
 mlxscore=0 priorityscore=1501 spamscore=0 suspectscore=0 mlxlogscore=999
 clxscore=1011 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2303200000 definitions=main-2304060096
X-Spam-Status: No, score=-2.3 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 05.04.23 19:04, Niklas Schnelle wrote:
> One more question though, what about the SEID why does that have to be
> fixed and at least partially match what ISM devices use? I think I'm
> missing some SMC protocol/design detail here. I'm guessing this would
> require a protocol change?
> 
> Thanks,
> Niklas

Niklas,
in the initial SMC CLC handshake the client and server exchange the SEID (one per peer system)
and up to 8 proposals for SMC-D interfaces.
Wen's current proposal assumes that smc-d loopback can be one of these 8 proposed interfaces,
iiuc. So on s390 the proposal can contain ISM devices and a smc-d loopback device at the same time.
If one of the peers is e.g. an older Linux version, it will just ignore the loopback-device
in the list (Don't find a match for CHID 0xFFFF) and use an ISM interface for SMC-D if possible.
Therefor it is important that the SEID is used in the same way as it is today in the handshake.

If we decide for some reason (virtio-ism open issues?) that a protocol change/extension is
required/wanted, then it is a new game and we can come up with new identifiers, but we may
lose compatibility to backlevel systems.

Alexandra
