Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2F1684E600C
	for <lists+netdev@lfdr.de>; Thu, 24 Mar 2022 09:13:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348805AbiCXINi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Mar 2022 04:13:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49988 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239836AbiCXINh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Mar 2022 04:13:37 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 32C8E9AE67;
        Thu, 24 Mar 2022 01:12:06 -0700 (PDT)
Received: from pps.filterd (m0127361.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 22O67q3R002802;
        Thu, 24 Mar 2022 08:11:41 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=pp1;
 bh=x4rW/bF5joN8CfS3qWpGRYaFY95pIFDgsbQdFt7B66c=;
 b=sBcuqZ/p2eOnGczCcBuREtrnttjUVdppli3Htcw0pv3l1wZxx2OPrfu8OuOmGwHGE6Uw
 1h61u37fVekasqNRZ6tykGtP87+ohnMo7/330ThZIvqvIu0HXb1wP1p5JtZhGifzCImZ
 yB9yhhes4PeS2gALf7jaWUtaseOO4o/6hvhEQS3tBZN+iFOu8SywuI5y696gzCYLpB3V
 sAmReAXBA9qaYxAYLB9/g6ujdRFYs6830Wi2FK434IYYO7TGO2hPbD64SHONqgnjx7PV
 Ph4xcogF29xF4YtmFYTUO4GgBKeK3F46dBcFVmhtvYFy5J8zSnJFNAsmp1XlqORXGKLg FA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3f08ckp0n0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 24 Mar 2022 08:11:41 +0000
Received: from m0127361.ppops.net (m0127361.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 22O6dnpB018999;
        Thu, 24 Mar 2022 08:11:40 GMT
Received: from ppma06fra.de.ibm.com (48.49.7a9f.ip4.static.sl-reverse.com [159.122.73.72])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3f08ckp0mf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 24 Mar 2022 08:11:40 +0000
Received: from pps.filterd (ppma06fra.de.ibm.com [127.0.0.1])
        by ppma06fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 22O87xYJ010090;
        Thu, 24 Mar 2022 08:11:38 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma06fra.de.ibm.com with ESMTP id 3ew6ej0vtj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 24 Mar 2022 08:11:38 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 22O8BYmN18088436
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 24 Mar 2022 08:11:34 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id CE2C84C044;
        Thu, 24 Mar 2022 08:11:34 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id BFBE34C058;
        Thu, 24 Mar 2022 08:11:33 +0000 (GMT)
Received: from [9.171.8.155] (unknown [9.171.8.155])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 24 Mar 2022 08:11:33 +0000 (GMT)
Message-ID: <871cbef1-d1e2-78a0-7efe-2925bfe90110@linux.ibm.com>
Date:   Thu, 24 Mar 2022 09:11:33 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [syzbot] BUG: unable to handle kernel NULL pointer dereference in
 __tcp_transmit_skb
Content-Language: en-US
To:     Eric Dumazet <edumazet@google.com>,
        syzbot <syzbot+090d23ddbd5cd185c2e0@syzkaller.appspotmail.com>
Cc:     Andrii Nakryiko <andrii@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>, bpf <bpf@vger.kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        David Miller <davem@davemloft.net>,
        David Ahern <dsahern@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Martin KaFai Lau <kafai@fb.com>,
        KP Singh <kpsingh@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>, Paolo Abeni <pabeni@redhat.com>,
        Song Liu <songliubraving@fb.com>,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>,
        Yonghong Song <yhs@fb.com>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Wenjia Zhang <wenjia@linux.ibm.com>,
        Thorsten Winkler <twinkler@linux.ibm.com>,
        Alexandra Winter <wintera@linux.ibm.com>
References: <000000000000acf1e405daebb7c7@google.com>
 <CANn89iKMWp3o7ZS9dL+6GgWR-tr2rOvMKdKxb1=aDmhLB7mFrw@mail.gmail.com>
From:   Karsten Graul <kgraul@linux.ibm.com>
Organization: IBM Deutschland Research & Development GmbH
In-Reply-To: <CANn89iKMWp3o7ZS9dL+6GgWR-tr2rOvMKdKxb1=aDmhLB7mFrw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: giHpBmfRpSg5IzL6hjf7JM3BnVA6P7J7
X-Proofpoint-ORIG-GUID: NkU4YCnc6hOpuPlsznyvCqShHdKtA4ol
Content-Transfer-Encoding: 7bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.850,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-03-23_08,2022-03-23_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0 clxscore=1011
 adultscore=0 lowpriorityscore=0 priorityscore=1501 mlxscore=0
 suspectscore=0 bulkscore=0 malwarescore=0 spamscore=0 mlxlogscore=999
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2203240047
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H4,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 24/03/2022 02:41, Eric Dumazet wrote:
> On Wed, Mar 23, 2022 at 5:13 PM syzbot
> <syzbot+090d23ddbd5cd185c2e0@syzkaller.appspotmail.com> wrote:
>>
>> Hello,
>>
>> syzbot found the following issue on:
>>
>> HEAD commit:    36c2e31ad25b net: geneve: add missing netlink policy and s..
>> git tree:       net-next
>> console output: https://syzkaller.appspot.com/x/log.txt?x=17c308a5700000
>> kernel config:  https://syzkaller.appspot.com/x/.config?x=4a15e2288cf165c9
>> dashboard link: https://syzkaller.appspot.com/bug?extid=090d23ddbd5cd185c2e0
>> compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2
>> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=171eadbd700000
>> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=12cacda3700000
>>
>> IMPORTANT: if you fix the issue, please add the following tag to the commit:
>> Reported-by: syzbot+090d23ddbd5cd185c2e0@syzkaller.appspotmail.com
>>
> 
> AF_SMC does not handle TCP_REPAIR properly.
> 
> Look at commit d9e4c129181004e ("mptcp: only admit explicitly
> supported sockopt") for an equivalent bug/fix.

Got it, we will fix that.
