Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 47FA94ED416
	for <lists+netdev@lfdr.de>; Thu, 31 Mar 2022 08:46:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231363AbiCaGsF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 31 Mar 2022 02:48:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54966 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231409AbiCaGsB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 31 Mar 2022 02:48:01 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A2E0212BFA1;
        Wed, 30 Mar 2022 23:46:14 -0700 (PDT)
Received: from pps.filterd (m0098393.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 22V6Zngp026272;
        Thu, 31 Mar 2022 06:46:07 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 subject : to : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=pp1;
 bh=j3tfj7O2wEheyep15OrUZJlIY48tSkzjLa7LTRYCpAw=;
 b=nhG62outzBcPT7IugEs9Khr6d8HoeWCnOcomCrBrcztuIMuawMzgCGq37kOHWO1Z707V
 annu2TfPJcpfDFiuh8i64PKr2EVF5yIq19WMvgB9/z/5lqE889OIx3BWY1SvaQ7zvspz
 5BZcsIfHxECf4cQd0A32S6FbbtaOPA4h6Uu/L+UZA2yHk0hA+Ftv2elzqkYdpHqI28En
 TsaTOfA9nOrewbLAJX5nPVyoshHiOOspNZUurd7E/LJeBo/C1cLJTz/JcBBYi089CvzI
 3Vr8jepNshZniKLWlXUAWDZ4UPqHNy0ra/18FdlCMmtHZLsGEGIzQFSY/7N4bEiQROYj yw== 
Received: from ppma06fra.de.ibm.com (48.49.7a9f.ip4.static.sl-reverse.com [159.122.73.72])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3f56h38wan-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 31 Mar 2022 06:46:06 +0000
Received: from pps.filterd (ppma06fra.de.ibm.com [127.0.0.1])
        by ppma06fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 22V6cfXK012256;
        Thu, 31 Mar 2022 06:46:04 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma06fra.de.ibm.com with ESMTP id 3f1t3j0mnj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 31 Mar 2022 06:46:03 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 22V6k1Yd36110786
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 31 Mar 2022 06:46:01 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 9A0E2AE051;
        Thu, 31 Mar 2022 06:46:01 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3A714AE056;
        Thu, 31 Mar 2022 06:46:01 +0000 (GMT)
Received: from [9.171.10.81] (unknown [9.171.10.81])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 31 Mar 2022 06:46:01 +0000 (GMT)
Message-ID: <0a252813-e954-518f-a969-67960a9af00c@linux.ibm.com>
Date:   Thu, 31 Mar 2022 08:46:03 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [syzbot] general protection fault in smc_pnet_add (2)
Content-Language: en-US
To:     syzbot <syzbot+03e3e228510223dabd34@syzkaller.appspotmail.com>,
        davem@davemloft.net, kuba@kernel.org, linux-kernel@vger.kernel.org,
        linux-s390@vger.kernel.org, netdev@vger.kernel.org,
        syzkaller-bugs@googlegroups.com
References: <000000000000c6056605db790400@google.com>
From:   Karsten Graul <kgraul@linux.ibm.com>
Organization: IBM Deutschland Research & Development GmbH
In-Reply-To: <000000000000c6056605db790400@google.com>
Content-Type: text/plain; charset=UTF-8
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: dsxAZLH2k7hmmhjqC9uZ6LWPnmyA4F_e
X-Proofpoint-ORIG-GUID: dsxAZLH2k7hmmhjqC9uZ6LWPnmyA4F_e
Content-Transfer-Encoding: 7bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.850,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-03-31_02,2022-03-30_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0 mlxscore=0
 phishscore=0 adultscore=0 clxscore=1011 bulkscore=0 spamscore=0
 mlxlogscore=834 suspectscore=0 malwarescore=0 priorityscore=1501
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2203310037
X-Spam-Status: No, score=0.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H5,
        RCVD_IN_MSPIKE_WL,SORTED_RECIPS,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 31/03/2022 02:48, syzbot wrote:
> Hello,
> 
> syzbot found the following issue on:
> 
> HEAD commit:    d82a6c5ef9dc net: prestera: acl: make read-only array clie..
> git tree:       net-next
> console output: https://syzkaller.appspot.com/x/log.txt?x=13862081700000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=cce8a73d5200f3c0
> dashboard link: https://syzkaller.appspot.com/bug?extid=03e3e228510223dabd34
> compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=167da879700000
> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=12bb0fe1700000


dev.parent is not checked properly before dev_name() is called, I will provide a fix for this.
