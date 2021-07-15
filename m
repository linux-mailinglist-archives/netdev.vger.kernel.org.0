Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 98F413C9E45
	for <lists+netdev@lfdr.de>; Thu, 15 Jul 2021 14:09:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232422AbhGOMMo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Jul 2021 08:12:44 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:38372 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232251AbhGOMMn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Jul 2021 08:12:43 -0400
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 16FC4Xqp160684;
        Thu, 15 Jul 2021 08:09:37 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : to : cc : date : in-reply-to : references : content-type :
 mime-version : content-transfer-encoding; s=pp1;
 bh=ic6pTeLhXlFSTQ4ty+9243ASrrwXWSWipYoOuiWNB9I=;
 b=rT4QrldydfKmaAnXQmhDuoYfQYqQiW9l+9jZ4b3kzqWyOZZVm47ii2DHOkVH4zRtVKIb
 hBB4gTaATn1IsA/eDnN6txwEWFv2jFgAmFrbEVR7HcmlbNQxifYs9oUj003KNr08q4hm
 QmlgBuSzNGW/hVPN/QvZwNcbqmP5VbUnb2g4//otMFkTkFmvk1Y/ppWPPsSsy3nJZJqV
 m47RIUcGLKW2QOeqg+lnIFSEk26zTwSzgAbu1poaVFdpZCzZVqFQHENDxOK1xmN7Tvaf
 bygOz2PV7J8MTHTCO7hGFtb89Q7uzJ2riIxEA0Z8rMH45qh9W06w41tGucZQpdEVWtCT yQ== 
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com with ESMTP id 39stfg3r64-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 15 Jul 2021 08:09:37 -0400
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 16FC9GlB007567;
        Thu, 15 Jul 2021 12:09:35 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma04ams.nl.ibm.com with ESMTP id 39q368a86f-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 15 Jul 2021 12:09:35 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 16FC9W5u33292630
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 15 Jul 2021 12:09:32 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id DB9CCA40C2;
        Thu, 15 Jul 2021 12:09:31 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5860AA4060;
        Thu, 15 Jul 2021 12:09:31 +0000 (GMT)
Received: from sig-9-145-173-31.de.ibm.com (unknown [9.145.173.31])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 15 Jul 2021 12:09:31 +0000 (GMT)
Message-ID: <8b280523cf98294bee897615de84546e241b4e11.camel@linux.ibm.com>
Subject: Re: Range checking on r1 in function reg_set_seen in
 arch/s390/net/bpf_jit_comp.c
From:   Ilya Leoshkevich <iii@linux.ibm.com>
To:     Colin Ian King <colin.king@canonical.com>,
        Michael Holzheu <holzheu@linux.vnet.ibm.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc:     Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        linux-s390@vger.kernel.org,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        bpf@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date:   Thu, 15 Jul 2021 14:09:31 +0200
In-Reply-To: <845025d4-11b9-b16d-1dd6-1e0bd66b0e20@canonical.com>
References: <845025d4-11b9-b16d-1dd6-1e0bd66b0e20@canonical.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.38.4 (3.38.4-1.fc33) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: Yeh2bFnmdHA8v-hMPlD-PsmPVYjoXK6O
X-Proofpoint-ORIG-GUID: Yeh2bFnmdHA8v-hMPlD-PsmPVYjoXK6O
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-07-15_07:2021-07-14,2021-07-15 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 mlxscore=0
 lowpriorityscore=0 malwarescore=0 clxscore=1011 mlxlogscore=815
 bulkscore=0 impostorscore=0 priorityscore=1501 phishscore=0 adultscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2107150088
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 2021-07-15 at 13:02 +0100, Colin Ian King wrote:
> Hi
> 
> Static analysis with cppcheck picked up an interesting issue with the
> following inline helper function in arch/s390/net/bpf_jit_comp.c :
> 
> static inline void reg_set_seen(struct bpf_jit *jit, u32 b1)
> {
>         u32 r1 = reg2hex[b1];
> 
>         if (!jit->seen_reg[r1] && r1 >= 6 && r1 <= 15)
>                 jit->seen_reg[r1] = 1;
> }
> 
> Although I believe r1 is always within range, the range check on r1
> is
> being performed before the more cache/memory expensive lookup on
> jit->seen_reg[r1].  I can't see why the range change is being
> performed
> after the access of jit->seen_reg[r1]. The following seems more
> correct:
> 
>         if (r1 >= 6 && r1 <= 15 && !jit->seen_reg[r1])
>                 jit->seen_reg[r1] = 1;
> 
> ..since the check on r1 are less expensive than !jit->seen_reg[r1]
> and
> also the range check ensures the array access is not out of bounds. I
> was just wondering if I'm missing something deeper to why the order
> is
> the way it is.
> 
> Colin

Hi,

I think your analysis is correct, thanks for spotting this!
Even though I don't think the performance difference would be 
measurable here, not confusing future readers is a good reason
to make a change that you suggest.
Do you plan to send a patch?

Best regards,
Ilya

