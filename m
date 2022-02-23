Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D21A74C1A5C
	for <lists+netdev@lfdr.de>; Wed, 23 Feb 2022 18:59:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243635AbiBWR7f (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Feb 2022 12:59:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54528 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233244AbiBWR7f (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Feb 2022 12:59:35 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F8023D4BA;
        Wed, 23 Feb 2022 09:59:07 -0800 (PST)
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 21NHCA9Q009503;
        Wed, 23 Feb 2022 17:59:02 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=KQgdeyVb6XDj3wVVuf7oj1X39sHmzApFe1ufbT3McI0=;
 b=JxAtqCZZOF1XGM0Y/gjvrLKzglEvhK4ws5s2WS0BNxVeNbUxbZC+p0k5R0Bt/bJY0GyO
 0wNxE1p0krpGWs07Ly4UHvm3JnyogLZbV0D4H2ICKd+tSudhWhs1pVab+vvHGQpa6aLN
 tshRuDrUxxmh0XU7wG4BSgnW6oMKKuA1BUVvWeRK/ge4Xa8pH7iUTVIeeix5limhZfPQ
 wC3VI464uyNOU7izNALHdK4GsP7/FcJhLU+Bqh6DinEMVY9ajPKn8cDH65iioLHdoFCu
 KSO7gP6efTlPqtMi8TJXN7uABi5qT4T6ARf2ht5npkgF46qGhGwsHUb8+PBkkOhReBiI MQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3eds4210gb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 23 Feb 2022 17:59:02 +0000
Received: from m0098399.ppops.net (m0098399.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 21NHcNku020370;
        Wed, 23 Feb 2022 17:59:02 GMT
Received: from ppma06fra.de.ibm.com (48.49.7a9f.ip4.static.sl-reverse.com [159.122.73.72])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3eds4210fc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 23 Feb 2022 17:59:01 +0000
Received: from pps.filterd (ppma06fra.de.ibm.com [127.0.0.1])
        by ppma06fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 21NHqcf0003232;
        Wed, 23 Feb 2022 17:58:59 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma06fra.de.ibm.com with ESMTP id 3eaqtjtat2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 23 Feb 2022 17:58:59 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 21NHwvn527459868
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 23 Feb 2022 17:58:57 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 32F28AE055;
        Wed, 23 Feb 2022 17:58:57 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id BA037AE051;
        Wed, 23 Feb 2022 17:58:56 +0000 (GMT)
Received: from [9.171.51.229] (unknown [9.171.51.229])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed, 23 Feb 2022 17:58:56 +0000 (GMT)
Message-ID: <9725f86f-eabe-6aaf-0ef1-74138d895834@linux.ibm.com>
Date:   Wed, 23 Feb 2022 18:59:10 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.6.0
Subject: Re: [PATCH] net/smc: Use a mutex for locking "struct smc_pnettable"
Content-Language: en-US
To:     "Fabio M. De Francesco" <fmdefrancesco@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-s390@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Tony Lu <tonylu@linux.alibaba.com>
Cc:     syzbot+4f322a6d84e991c38775@syzkaller.appspotmail.com
References: <20220223100252.22562-1-fmdefrancesco@gmail.com>
From:   Karsten Graul <kgraul@linux.ibm.com>
Organization: IBM Deutschland Research & Development GmbH
In-Reply-To: <20220223100252.22562-1-fmdefrancesco@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: cBjvvFVE5h4wDlBNvxiEwIdI-1B97C5b
X-Proofpoint-ORIG-GUID: n377XhP_E8myP0gMgqX0ryRpPzkO7S86
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-02-23_09,2022-02-23_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 clxscore=1011
 mlxscore=0 suspectscore=0 priorityscore=1501 malwarescore=0
 lowpriorityscore=0 impostorscore=0 phishscore=0 bulkscore=0 spamscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2201110000 definitions=main-2202230100
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H5,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 23/02/2022 11:02, Fabio M. De Francesco wrote:
> smc_pnetid_by_table_ib() uses read_lock() and then it calls smc_pnet_apply_ib()
> which, in turn, calls mutex_lock(&smc_ib_devices.mutex).
> 
> read_lock() disables preemption. Therefore, the code acquires a mutex while in
> atomic context and it leads to a SAC bug.
> 
> Fix this bug by replacing the rwlock with a mutex.
> 
> Reported-and-tested-by: syzbot+4f322a6d84e991c38775@syzkaller.appspotmail.com
> Fixes: 64e28b52c7a6 ("net/smc: add pnet table namespace support")
> Confirmed-by: Tony Lu <tonylu@linux.alibaba.com>
> Signed-off-by: Fabio M. De Francesco <fmdefrancesco@gmail.com>
> ---

Thank you Fabio!

This should go to the net tree...

Acked-by: Karsten Graul <kgraul@linux.ibm.com>
