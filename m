Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D904568BAB7
	for <lists+netdev@lfdr.de>; Mon,  6 Feb 2023 11:47:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230071AbjBFKrU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Feb 2023 05:47:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230038AbjBFKrP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Feb 2023 05:47:15 -0500
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2284D15560;
        Mon,  6 Feb 2023 02:47:14 -0800 (PST)
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 316AiHIs011233;
        Mon, 6 Feb 2023 10:47:08 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=rzupTz1tqZsaVWXedvwufJ5m/OJ+sVtYPaVZoZ/ood4=;
 b=GXZ4naFuvAn1/71BskGUJpUW2tjl8xoKKaaN7Nza6DcYq/DVnoG1LeJV1iO9eTR1nmb+
 +fEtlwVgIEZo2oKo2eHDZh+OM4SQCanPH7jrboGWYo5aND8X/FaYrEGMpm5K8Th+5pPf
 e55L/pYd5fY72X+gH8Z/BNZ/JqOUDLXJeCdFsHVuxrhB3ShnHadq8boaFw79vjkGqnTA
 zQwuMqwzpHPKohcUZEavj6YlCmwG03MLTX4mxnOd9TBugbztrBLu1tLqCXsjja9X+ljo
 QUa0Ex9c/HgeeTv+E1OkzmY0LJPtj2nV+7FvQJsVA+xbVzOrwdcQ5yqubFevEO0Att+i Hg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3nk028g1rg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 06 Feb 2023 10:47:08 +0000
Received: from m0098421.ppops.net (m0098421.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 316AjG6o014623;
        Mon, 6 Feb 2023 10:47:07 GMT
Received: from ppma03dal.us.ibm.com (b.bd.3ea9.ip4.static.sl-reverse.com [169.62.189.11])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3nk028g1r4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 06 Feb 2023 10:47:07 +0000
Received: from pps.filterd (ppma03dal.us.ibm.com [127.0.0.1])
        by ppma03dal.us.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 3168wOfd017625;
        Mon, 6 Feb 2023 10:47:06 GMT
Received: from smtprelay03.dal12v.mail.ibm.com ([9.208.130.98])
        by ppma03dal.us.ibm.com (PPS) with ESMTPS id 3nhf07ct85-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 06 Feb 2023 10:47:06 +0000
Received: from smtpav03.wdc07v.mail.ibm.com (smtpav03.wdc07v.mail.ibm.com [10.39.53.230])
        by smtprelay03.dal12v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 316Al5iJ13238794
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 6 Feb 2023 10:47:05 GMT
Received: from smtpav03.wdc07v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 432F35805C;
        Mon,  6 Feb 2023 10:47:05 +0000 (GMT)
Received: from smtpav03.wdc07v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B5F9E58054;
        Mon,  6 Feb 2023 10:47:01 +0000 (GMT)
Received: from [9.163.48.193] (unknown [9.163.48.193])
        by smtpav03.wdc07v.mail.ibm.com (Postfix) with ESMTP;
        Mon,  6 Feb 2023 10:47:01 +0000 (GMT)
Message-ID: <949f5094-1361-ac4b-77e9-c200e166d455@linux.ibm.com>
Date:   Mon, 6 Feb 2023 11:47:00 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.6.1
Subject: Re: [net-next v2 0/8] drivers/s390/net/ism: Add generalized interface
To:     Wen Gu <guwen@linux.alibaba.com>, Jan Karcher <jaka@linux.ibm.com>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev@vger.kernel.org, linux-s390@vger.kernel.org,
        Heiko Carstens <hca@linux.ibm.com>,
        Alexandra Winter <wintera@linux.ibm.com>,
        Thorsten Winkler <twinkler@linux.ibm.com>,
        Stefan Raspl <raspl@linux.ibm.com>,
        Karsten Graul <kgraul@linux.ibm.com>,
        Nils Hoppmann <niho@linux.ibm.com>,
        Halil Pasic <pasic@linux.ibm.com>,
        Tony Lu <tonylu@linux.alibaba.com>
References: <20230123181752.1068-1-jaka@linux.ibm.com>
 <39206f64-3f88-235e-7017-2479ac58844d@linux.alibaba.com>
From:   Wenjia Zhang <wenjia@linux.ibm.com>
In-Reply-To: <39206f64-3f88-235e-7017-2479ac58844d@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: X-av6iv2ugOXj6NvhsoWyCNiUHtLDuz8
X-Proofpoint-GUID: fgmVx9mn4ktZv3B2WsJm81jMc_tr3jWA
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.122.1
 definitions=2023-02-06_05,2023-02-06_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 mlxlogscore=999
 lowpriorityscore=0 suspectscore=0 malwarescore=0 clxscore=1015
 impostorscore=0 adultscore=0 mlxscore=0 spamscore=0 bulkscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2302060091
X-Spam-Status: No, score=-3.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 02.02.23 14:53, Wen Gu wrote:
> 
> 
> On 2023/1/24 02:17, Jan Karcher wrote:
> 
>> Previously, there was no clean separation between SMC-D code and the ISM
>> device driver.This patch series addresses the situation to make ISM 
>> available
>> for uses outside of SMC-D.
>> In detail: SMC-D offers an interface via struct smcd_ops, which only the
>> ISM module implements so far. However, there is no real separation 
>> between
>> the smcd and ism modules, which starts right with the ISM device
>> initialization, which calls directly into the SMC-D code.
>> This patch series introduces a new API in the ISM module, which allows
>> registration of arbitrary clients via include/linux/ism.h: struct 
>> ism_client.
>> Furthermore, it introduces a "pure" struct ism_dev (i.e. getting rid of
>> dependencies on SMC-D in the device structure), and adds a number of API
>> calls for data transfers via ISM (see ism_register_dmb() & friends).
>> Still, the ISM module implements the SMC-D API, and therefore has a 
>> number
>> of internal helper functions for that matter.
>> Note that the ISM API is consciously kept thin for now (as compared to 
>> the
>> SMC-D API calls), as a number of API calls are only used with SMC-D and
>> hardly have any meaningful usage beyond SMC-D, e.g. the VLAN-related 
>> calls.
>>
> 
> Hi,
> 
> Thanks for the great work!
> 
> We are tring to adapt loopback and virtio-ism device into SMC-D based on 
> the new
> interface and want to confirm something. (cc: Alexandra Winter, Jan 
> Karcher, Wenjia Zhang)
> 
>  From my understanding, this patch set is from the perspective of ISM 
> device driver
> and aims to make ISM device not only used by SMC-D, which is great!
> 
> But from the perspective of SMC, SMC-D protocol now binds with the 
> helper in
> smc_ism.c (smc_ism_* helper) and some part of smc_ism.c and smcd_ops 
> seems to be
> dedicated to only serve ISM device.
> 
> For example,
> 
> - The input param of smcd_register_dev() and smcd_unregister_dev() is 
> ism_dev,
>    instead of abstract smcd_dev like before.
> 
> - the smcd->ops->register_dmb has param of ism_client, exposing specific 
> underlay.
> 
> So I want to confirm that, which of the following is our future 
> direction of the
> SMC-D device expansion?
> 
> (1) All extended devices (eg. virtio-ism and loopback) are ISM devices 
> and SMC-D
>      only supports ISM type device.
> 
>      SMC-D protocol -> smc_ism_* helper in smc_ism.c -> only ISM device.
> 
>      Future extended device must under the definition of ism_dev, in 
> order to share
>      the ism-specific helper in smc_ism.c (such as smcd_register_dev(), 
> smcd_ops->register_dmbs..).
> 
>      With this design intention, futher extended SMC-D used device may 
> be like:
> 
>                      +---------------------+
>                      |    SMC-D protocol   |
>                      +---------------------+
>                        | current helper in|
>                        |    smc_ism.c     |
>           +--------------------------------------------+
>           |              Broad ISM device              |
>           |             defined as ism_dev             |
>           |  +----------+ +------------+ +----------+  |
>           |  | s390 ISM | | virtio-ism | | loopback |  |
>           |  +----------+ +------------+ +----------+  |
>           +--------------------------------------------+
> 
> (2) All extended devices (eg. virtio-ism and loopback) are abstracted as 
> smcd_dev and
>      SMC-D protocol use the abstracted capabilities.
> 
>      SMC-D does not care about the type of the underlying device, and 
> only focus on the
>      capabilities provided by smcd_dev.
> 
>      SMC-D protocol use a kind of general helpers, which only invoking 
> smcd_dev->ops,
>      without underlay device exposed. Just like most of helpers now in 
> smc_ism.c, such as
>      smc_ism_cantalk()/smc_ism_get_chid()/smc_ism_set_conn()..
> 
>      With this design intention, futher extended SMC-D used device 
> should be like:
> 
>                       +----------------------+
>                       |     SMC-D protocol   |
>                       +----------------------+
>                        |   general helper   |
>                        |invoke smcd_dev->ops|
>                        | hiding underlay dev|
>             +-----------+  +------------+  +----------+
>             | smc_ism.c |  | smc_vism.c |  | smc_lo.c |
>             |           |  |            |  |          |
>             | s390 ISM  |  | virtio-ism |  | loopback |
>             |  device   |  |   device   |  |  device  |
>             +-----------+  +------------+  +----------+
> 
> IMHO, (2) is more clean and beneficial to the flexible expansion of 
> SMC-D devices, with no
> underlay devices exposed.
> 
> So (2) should be our target. Do you agree? :)
> 
> If so, maybe we should make some part of helpers or ops of SMC-D device 
> (such as smcd_register/unregister_dev
> and smcd->ops->register_dmb) more generic？
> 
> Thanks,
> Wen Gu

Currently we tend a bit more towards the first solution. The reasoning 
behind it is the following:
If we create a full blown interface, we would have an own file for every 
new device which on the one hand is clean, but on the other hand raises 
the risk of duplicated code.
So if we go down that path (2) we have to take care that we avoid 
duplicated code.

In the context of the currently discussed changes this could mean:
- ISM is the only device right now using indirect copy,
- lo & vism should (AFAIU) copy directly.

As you may see this leaves us with the big question: How much 
abstraction is enough vs. when do we go overboard?
