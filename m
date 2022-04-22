Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0BD3750B3FD
	for <lists+netdev@lfdr.de>; Fri, 22 Apr 2022 11:25:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1445947AbiDVJ1z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Apr 2022 05:27:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45214 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1445943AbiDVJ1y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Apr 2022 05:27:54 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 13A3A2DCB;
        Fri, 22 Apr 2022 02:25:01 -0700 (PDT)
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 23M815rN008056;
        Fri, 22 Apr 2022 09:24:55 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=Hk7Ac73kGeVVf0vrXna8FQdc/Yg16YPb85IKIhoH7qc=;
 b=PQ6V4jN0Ox0uypcarZstLZJn+tJVP+2L3Rk3BrFm2c0JdMI4B/PZX2iKBqsTJx7LvZS1
 VDvroEVe0kUuJrnJ2E3xKNBwcU7NUMNR0dIS/Ac+LFXT+npjgK6YxbLupzxZB7xkARBb
 zEWPGJ726YYwgXj76ORM1CG+abn3YLNfY7HTBDDnrn5OVO1xYpTT2cGt1GL48mxOXGjv
 ndeKcw7fB4SYuvSbiDI0DK1WzOL3+oeg/yKjeRAVK6OPKz1GQnOEQUri/nM8WNl2ZHQo
 JIHzjXtAziaRcHZ+cXJ5iaXUtY7Q+P7qzZ2VLUBXao34In7qrUkrNtRAQ8D5p4OssBsT Sw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3fjhsyybss-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 22 Apr 2022 09:24:55 +0000
Received: from m0098409.ppops.net (m0098409.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 23M7x7fG005110;
        Fri, 22 Apr 2022 09:24:54 GMT
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3fjhsyybs5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 22 Apr 2022 09:24:54 +0000
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 23M9NI0F019142;
        Fri, 22 Apr 2022 09:24:52 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma04ams.nl.ibm.com with ESMTP id 3ffne9946d-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 22 Apr 2022 09:24:52 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 23M9OnVN58393028
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 22 Apr 2022 09:24:49 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A78FFA4055;
        Fri, 22 Apr 2022 09:24:49 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 29389A404D;
        Fri, 22 Apr 2022 09:24:49 +0000 (GMT)
Received: from [9.171.62.248] (unknown [9.171.62.248])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri, 22 Apr 2022 09:24:49 +0000 (GMT)
Message-ID: <4ac3ecef-8438-072b-82b3-ef0b594edfd2@linux.ibm.com>
Date:   Fri, 22 Apr 2022 11:24:51 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.1
Subject: Re: [PATCH net] net/smc: sync err code when tcp connection was
 refused
Content-Language: en-US
To:     liuyacan@corp.netease.com
Cc:     davem@davemloft.net, kuba@kernel.org, linux-kernel@vger.kernel.org,
        linux-s390@vger.kernel.org, netdev@vger.kernel.org,
        pabeni@redhat.com, tonylu@linux.alibaba.com, ubraun@linux.ibm.com
References: <20220421094027.683992-1-liuyacan@corp.netease.com>
 <20220421115805.1642771-1-liuyacan@corp.netease.com>
From:   Karsten Graul <kgraul@linux.ibm.com>
Organization: IBM Deutschland Research & Development GmbH
In-Reply-To: <20220421115805.1642771-1-liuyacan@corp.netease.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: xC0YdByMi1YD-XLRlZXMb7obVVf0Y4S1
X-Proofpoint-GUID: HG0Lv2td8mmgvG2k1YZG68YvqXVmHWE0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-04-22_02,2022-04-21_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 clxscore=1015
 lowpriorityscore=0 adultscore=0 mlxlogscore=876 priorityscore=1501
 spamscore=0 phishscore=0 bulkscore=0 suspectscore=0 impostorscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2204220040
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 21/04/2022 13:58, liuyacan@corp.netease.com wrote:
> From: Yacan Liu <liuyacan@corp.netease.com>
> 
> Forgot to cc ubraun@linux.ibm.com

No problem, its okay to add the current maintainers. 
Ursula left the company in the meantime.
