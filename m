Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C94EA5996E9
	for <lists+netdev@lfdr.de>; Fri, 19 Aug 2022 10:18:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347450AbiHSIJZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Aug 2022 04:09:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39132 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347437AbiHSIJY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Aug 2022 04:09:24 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A51109AFBF;
        Fri, 19 Aug 2022 01:09:22 -0700 (PDT)
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 27J6vIV1019537;
        Fri, 19 Aug 2022 08:09:18 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=pp1;
 bh=Udv9bz/xQJBZrSCR6IODRmBEUGm4gg5qONcdmdNP+Lc=;
 b=WZybTPf3J1T/jjLIymqVirEde9WA41zu5MRphcAHYnlnW4qUM0XPXZk7pRmJx1yhbdWF
 qStAZzOtISdMXBCEebsIM2E7C2d+lccWBExHRwj5hZ9poq7bifQtjBXVOxIWFfE9i58C
 TDHh9fb6lOL+po1W98S/lkSCvspFboK6WjNe6KB81YerTjxYcdQcsfiYszI5W3fOzSy7
 5uatsUjMsLVl3IrL+UIrkNfafGnv/zQR57o2Dh9pY1y/z8TpSwSBW5+3se0b/rFJ+uJm
 LRCW0xKUC1EKpy6NvyCkpCe77ZsJKgqpShpSNle8PrJx0H4o1oe0r9m+PeBCZlMrOmrW Aw== 
Received: from ppma03fra.de.ibm.com (6b.4a.5195.ip4.static.sl-reverse.com [149.81.74.107])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3j25q3a6u4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 19 Aug 2022 08:09:18 +0000
Received: from pps.filterd (ppma03fra.de.ibm.com [127.0.0.1])
        by ppma03fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 27J86Aaa001381;
        Fri, 19 Aug 2022 08:09:16 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma03fra.de.ibm.com with ESMTP id 3hx3k8w5rj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 19 Aug 2022 08:09:15 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 27J89CcY24772874
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 19 Aug 2022 08:09:12 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 7E984A4051;
        Fri, 19 Aug 2022 08:09:12 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D6482A4040;
        Fri, 19 Aug 2022 08:09:11 +0000 (GMT)
Received: from [9.145.158.147] (unknown [9.145.158.147])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri, 19 Aug 2022 08:09:11 +0000 (GMT)
Message-ID: <580bf781-81f6-5f8e-12bf-7195f7a62b36@linux.ibm.com>
Date:   Fri, 19 Aug 2022 10:09:11 +0200
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.12.0
Subject: Re: [PATCH] s390: move from strlcpy with unused retval to strscpy
Content-Language: en-US
To:     Wolfram Sang <wsa+renesas@sang-engineering.com>,
        linux-kernel@vger.kernel.org
Cc:     Stefan Haberland <sth@linux.ibm.com>,
        Jan Hoeppner <hoeppner@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Sven Schnelle <svens@linux.ibm.com>,
        Vineeth Vijayan <vneethv@linux.ibm.com>,
        Peter Oberparleiter <oberpar@linux.ibm.com>,
        Wenjia Zhang <wenjia@linux.ibm.com>,
        Steffen Maier <maier@linux.ibm.com>,
        Benjamin Block <bblock@linux.ibm.com>,
        linux-s390@vger.kernel.org, netdev@vger.kernel.org
References: <20220818210102.7301-1-wsa+renesas@sang-engineering.com>
From:   Alexandra Winter <wintera@linux.ibm.com>
In-Reply-To: <20220818210102.7301-1-wsa+renesas@sang-engineering.com>
Content-Type: text/plain; charset=UTF-8
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 07MBEEmAI3oDzTfECX0PkbivG95bSTto
X-Proofpoint-ORIG-GUID: 07MBEEmAI3oDzTfECX0PkbivG95bSTto
Content-Transfer-Encoding: 7bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-08-19_04,2022-08-18_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0
 priorityscore=1501 bulkscore=0 mlxscore=0 spamscore=0 adultscore=0
 clxscore=1011 phishscore=0 impostorscore=0 lowpriorityscore=0
 suspectscore=0 mlxlogscore=911 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2207270000 definitions=main-2208190032
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 18.08.22 23:01, Wolfram Sang wrote:
> Follow the advice of the below link and prefer 'strscpy' in this
> subsystem. Conversion is 1:1 because the return value is not used.
> Generated by a coccinelle script.
> 
> Link: https://lore.kernel.org/r/CAHk-=wgfRnXz0W3D37d01q3JFkr_i_uTL=V6A6G1oUZcprmknw@mail.gmail.com/
> Signed-off-by: Wolfram Sang <wsa+renesas@sang-engineering.com>
> ---
>  drivers/s390/block/dasd_devmap.c | 2 +-
>  drivers/s390/block/dasd_eer.c    | 4 ++--
>  drivers/s390/block/dcssblk.c     | 2 +-
>  drivers/s390/char/hmcdrv_cache.c | 2 +-
>  drivers/s390/char/tape_class.c   | 4 ++--
>  drivers/s390/cio/qdio_debug.c    | 2 +-
>  drivers/s390/net/ctcm_main.c     | 2 +-
>  drivers/s390/net/fsm.c           | 2 +-
>  drivers/s390/net/qeth_ethtool.c  | 4 ++--
>  drivers/s390/scsi/zfcp_aux.c     | 2 +-
>  drivers/s390/scsi/zfcp_fc.c      | 2 +-
>  11 files changed, 14 insertions(+), 14 deletions(-)
> 


Thank you. Ack'ed for drivers/s390/net and drivers/s390/cio
Acked-by: Alexandra Winter <wintera@linux.ibm.com>
