Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EE5612ED4F3
	for <lists+netdev@lfdr.de>; Thu,  7 Jan 2021 18:03:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728828AbhAGRC0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Jan 2021 12:02:26 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:11978 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726650AbhAGRCZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Jan 2021 12:02:25 -0500
Received: from pps.filterd (m0098413.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 107H1dHT125554;
        Thu, 7 Jan 2021 12:01:42 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=g/07yt6F6iI0Q4WiX8eb4mDvryw79jBaT6FXa8eHMws=;
 b=gAjCbjlYdTTq0XaGaKimgU/Nz9+1MrvpWVpsx7F+pVxKonNHA/wWnfXCUHGACjssubXi
 awU0KfP85g9Wu65uhRbU6DItw/MgxHt4/lxS/xLGBsdHVmVaGlAS8Doiz2KSdxX1paMQ
 Zpf5Lx4tARAtIyv9yso3Fvdoh536gtO95oUZ8wz8hc0Uv15RFXFLHLRQpvp/9Y9GK6b+
 MD6kGhWh3j3a4FMfEQuCYZwAlOb26VjJKh6EbBZsu2lMBgjMuQ6LYHE2k/B1jitaK5GG
 0aa+qaUM2JrcWw1mLMUBMnycujB4l/RWrqH8RzgDyNVnzgITSEP56+jtDEyB2hZJ1fGU Tw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 35x5dxa20r-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 07 Jan 2021 12:01:40 -0500
Received: from m0098413.ppops.net (m0098413.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 107H1bOp125453;
        Thu, 7 Jan 2021 12:01:40 -0500
Received: from ppma05fra.de.ibm.com (6c.4a.5195.ip4.static.sl-reverse.com [149.81.74.108])
        by mx0b-001b2d01.pphosted.com with ESMTP id 35x5dxa1ve-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 07 Jan 2021 12:01:40 -0500
Received: from pps.filterd (ppma05fra.de.ibm.com [127.0.0.1])
        by ppma05fra.de.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 107GcNek024585;
        Thu, 7 Jan 2021 17:01:22 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma05fra.de.ibm.com with ESMTP id 35tgf8amx7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 07 Jan 2021 17:01:22 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 107H1KVQ22872364
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 7 Jan 2021 17:01:20 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 6377F11C054;
        Thu,  7 Jan 2021 17:01:20 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 1F70C11C04C;
        Thu,  7 Jan 2021 17:01:20 +0000 (GMT)
Received: from [9.145.66.183] (unknown [9.145.66.183])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu,  7 Jan 2021 17:01:20 +0000 (GMT)
Subject: Re: UBSAN: object-size-mismatch in wg_xmit
To:     "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Dmitry Vyukov <dvyukov@google.com>
Cc:     Kees Cook <keescook@google.com>, Netdev <netdev@vger.kernel.org>,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>,
        WireGuard mailing list <wireguard@lists.zx2c4.com>,
        Eric Dumazet <edumazet@google.com>
References: <000000000000e13e2905b6e830bb@google.com>
 <CAHmME9qwbB7kbD=1sg_81=82vO07XMV7GyqBcCoC=zwM-v47HQ@mail.gmail.com>
 <CACT4Y+ac8oFk1Sink0a6VLUiCENTOXgzqmkuHgQLcS2HhJeq=g@mail.gmail.com>
 <CAHmME9q0HMz+nERjoT-TQ8_6bcAFUNVHDEeXQAennUrrifKESw@mail.gmail.com>
From:   Julian Wiedmann <jwi@linux.ibm.com>
Message-ID: <68452c93-de95-aaa6-3cac-d868a202ea6f@linux.ibm.com>
Date:   Thu, 7 Jan 2021 18:01:19 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.5.0
MIME-Version: 1.0
In-Reply-To: <CAHmME9q0HMz+nERjoT-TQ8_6bcAFUNVHDEeXQAennUrrifKESw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2021-01-07_07:2021-01-07,2021-01-07 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 malwarescore=0
 mlxlogscore=999 spamscore=0 mlxscore=0 lowpriorityscore=0 bulkscore=0
 priorityscore=1501 adultscore=0 suspectscore=0 clxscore=1011
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2101070098
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 21.12.20 12:23, Jason A. Donenfeld wrote:
> Hi Dmitry,
> 

...

> fall on the border of a mapping? Is UBSAN non-deterministic as an
> optimization? Or is there actually some mysterious UaF happening with
> my usage of skbs that I shouldn't overlook?
> 

One oddity is that wg_xmit() returns negative errnos, rather than a
netdev_tx_t (ie. NETDEV_TX_OK or NETDEV_TX_BUSY).

Any chance that the stack mis-interprets one of those custom errnos
as NETDEV_TX_BUSY, and thus believes that it still owns the skb?

> Jason
> 

