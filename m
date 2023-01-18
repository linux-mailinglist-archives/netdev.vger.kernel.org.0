Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F33626719A4
	for <lists+netdev@lfdr.de>; Wed, 18 Jan 2023 11:51:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229685AbjARKvM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Jan 2023 05:51:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43520 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229883AbjARKsu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Jan 2023 05:48:50 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 511621CF74;
        Wed, 18 Jan 2023 01:55:55 -0800 (PST)
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 30I9BYtA029046;
        Wed, 18 Jan 2023 09:55:46 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=RwVgZ4gAgChB9dQuFg/BrH3z1bCoNoJ9VOyOuUBY96Y=;
 b=LprhYLJ+Am8oKeerrnGngONd4DmlFlTLoa54EYfTqDK64Gz1+VH5QOntmlO1Vb6YEVQu
 j+2EUq+QRPtnpszxA9mErSZyt68J8cUDCBJpua0Wj0O6Tgkomdj5Y85t8beHVX4nZvkb
 zQMoXPQEXr9UYqOWql7InuRgdu8CDoBxx9yomtrwMaMPVmw0bAhvBy//CRUGQRkrfWsG
 xPhpwZSNMNzwJO1UPqChMcNP/FubKhc0NfSkehMsVUvBY9a6CPWz7Vy/1ad6Kd6Q/+/a
 /RFH+pnfR1EiX5wn0BANMRzFVHLPxUiQh7FJqVbNB5n/u/JZNUf6cLJUrbJzc3GCUICA IQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3n6dwv8yhs-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 18 Jan 2023 09:55:46 +0000
Received: from m0098409.ppops.net (m0098409.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 30I9ZwU2023772;
        Wed, 18 Jan 2023 09:55:46 GMT
Received: from ppma02fra.de.ibm.com (47.49.7a9f.ip4.static.sl-reverse.com [159.122.73.71])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3n6dwv8yh7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 18 Jan 2023 09:55:45 +0000
Received: from pps.filterd (ppma02fra.de.ibm.com [127.0.0.1])
        by ppma02fra.de.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 30I2iYqw030244;
        Wed, 18 Jan 2023 09:55:43 GMT
Received: from smtprelay07.fra02v.mail.ibm.com ([9.218.2.229])
        by ppma02fra.de.ibm.com (PPS) with ESMTPS id 3n3m16kpgu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 18 Jan 2023 09:55:43 +0000
Received: from smtpav03.fra02v.mail.ibm.com (smtpav03.fra02v.mail.ibm.com [10.20.54.102])
        by smtprelay07.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 30I9tdTi50266434
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 18 Jan 2023 09:55:39 GMT
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id CF01720040;
        Wed, 18 Jan 2023 09:55:39 +0000 (GMT)
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C2D5A2004E;
        Wed, 18 Jan 2023 09:55:38 +0000 (GMT)
Received: from [9.179.3.165] (unknown [9.179.3.165])
        by smtpav03.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Wed, 18 Jan 2023 09:55:38 +0000 (GMT)
Message-ID: <d8d9be9e-079a-6c44-647e-cc2afe4578c8@linux.ibm.com>
Date:   Wed, 18 Jan 2023 10:55:35 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [net-next 8/8] net/smc: De-tangle ism and smc device
 initialization
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     David Miller <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        linux-s390@vger.kernel.org, Heiko Carstens <hca@linux.ibm.com>,
        Alexandra Winter <wintera@linux.ibm.com>,
        Wenjia Zhang <wenjia@linux.ibm.com>,
        Thorsten Winkler <twinkler@linux.ibm.com>,
        Stefan Raspl <raspl@linux.ibm.com>,
        Karsten Graul <kgraul@linux.ibm.com>,
        Nils Hoppmann <niho@linux.ibm.com>,
        Halil Pasic <pasic@linux.ibm.com>,
        Tony Lu <tonylu@linux.alibaba.com>,
        Wen Gu <guwen@linux.alibaba.com>
References: <20230116092712.10176-1-jaka@linux.ibm.com>
 <20230116092712.10176-9-jaka@linux.ibm.com>
 <20230117192821.6bab7f24@kernel.org>
From:   Jan Karcher <jaka@linux.ibm.com>
Organization: IBM - Network Linux on Z
In-Reply-To: <20230117192821.6bab7f24@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: p1UwZRUjlgGJwcy-K2eKKmn5cFEEAyuL
X-Proofpoint-GUID: MY8x5FtmeG7hijVJvw6Z1hfzTPZAppZm
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.923,Hydra:6.0.562,FMLib:17.11.122.1
 definitions=2023-01-18_04,2023-01-17_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0
 priorityscore=1501 spamscore=0 impostorscore=0 bulkscore=0 phishscore=0
 mlxlogscore=849 adultscore=0 clxscore=1015 lowpriorityscore=0 mlxscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2301180082
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 18/01/2023 04:28, Jakub Kicinski wrote:
> On Mon, 16 Jan 2023 10:27:12 +0100 Jan Karcher wrote:
>> From: Stefan Raspl <raspl@linux.ibm.com>
>>
>> The struct device for ISM devices was part of struct smcd_dev. Move to
>> struct ism_dev, provide a new API call in struct smcd_ops, and convert
>> existing SMCD code accordingly.
>> Furthermore, remove struct smcd_dev from struct ism_dev.
>> This is the final part of a bigger overhaul of the interfaces between SMC
>> and ISM.
> 
> breaks allmodconfig build for x86

Good catch. Found it and working on a fix. Going to send a new version.
