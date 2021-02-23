Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2189E323267
	for <lists+netdev@lfdr.de>; Tue, 23 Feb 2021 21:50:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234438AbhBWUsf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Feb 2021 15:48:35 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:4364 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S231561AbhBWUsd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Feb 2021 15:48:33 -0500
Received: from pps.filterd (m0098414.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 11NKeK9E137767;
        Tue, 23 Feb 2021 15:47:37 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : to : date : in-reply-to : references : content-type : mime-version
 : content-transfer-encoding; s=pp1;
 bh=4xcx1H4OA6P7X6TfQrSHyC/j7208ylKQzYvCwC2kOU0=;
 b=V42EG6Jn27J9+1d+7CvLAXM+z1aWV+ilwpE1Cm3x9KBR8vPxtvY9gm5K4DgWqleOp464
 45nbL0KGwL1PeVvEbL3NUVjmfo0lqZdTpHbIbQP8+yNLQvU7BOEwKZs6wicUAPDLTM3p
 Iyt4nMfqka0Ud5RZw0cun1STMRvJ67DX3G5egS5aOCu7IKqGMb42KDQvMqjNTMTsCqdo
 ZOZ0AClXEKNWZIaYoXmyYcmh9AnvP9xNOipdI1dtBrdqgEOyoyynlJHY9ucP7jql/ivs
 8tttNEZaPDZ7yeYcAkTM2ZVljF5L7A9Ims2ivPKnygXKAA0jJlIHXu3dNDaAl/+iYp1p Lg== 
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0b-001b2d01.pphosted.com with ESMTP id 36vkmyrvgu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 23 Feb 2021 15:47:37 -0500
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 11NKgg7S002145;
        Tue, 23 Feb 2021 20:47:35 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma06ams.nl.ibm.com with ESMTP id 36tsph2xtj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 23 Feb 2021 20:47:35 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 11NKlXuP35586382
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 23 Feb 2021 20:47:33 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 49482A4055;
        Tue, 23 Feb 2021 20:47:33 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id F0582A4053;
        Tue, 23 Feb 2021 20:47:32 +0000 (GMT)
Received: from sig-9-145-151-190.de.ibm.com (unknown [9.145.151.190])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 23 Feb 2021 20:47:32 +0000 (GMT)
Message-ID: <c964892195a6b91d20a67691448567ef528ffa6d.camel@linux.ibm.com>
Subject: Re: More strict error checking in bpf_asm?
From:   Ilya Leoshkevich <iii@linux.ibm.com>
To:     Ian Denhardt <ian@zenhack.net>, ast@kernel.org,
        daniel@iogearbox.net, bpf@vger.kernel.org, netdev@vger.kernel.org
Date:   Tue, 23 Feb 2021 21:47:32 +0100
In-Reply-To: <161411199784.11959.16534412799839825563@localhost.localdomain>
References: <161411199784.11959.16534412799839825563@localhost.localdomain>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.38.4 (3.38.4-1.fc33) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-02-23_08:2021-02-23,2021-02-23 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0
 priorityscore=1501 bulkscore=0 spamscore=0 clxscore=1011
 lowpriorityscore=0 mlxlogscore=999 malwarescore=0 impostorscore=0
 mlxscore=0 phishscore=0 suspectscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2009150000 definitions=main-2102230174
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 2021-02-23 at 15:26 -0500, Ian Denhardt wrote:
> Hi,
> 
> I'm using the `bpf_asm` tool to do some syscall filtering, and found
> out
> the hard way that its error checking isn't very strict. In particular,
> it issues a warning (not an error) when a jump offset overflows the
> instruction's field. It really seems like this *ought* to be a hard
> error, but I see from the commit message in
> 7e22077d0c73a68ff3fd8b3d2f6564fcbcf8cb23 that this was left as a
> warning
> due to backwards compatibility concerns.

My 2c: when I was writing that commit, I did not have any specific
examples of code that would break in mind - that was pure
speculation/paranoia. So it's OK from my perspective to convert this
fprintf to a hard error.

[...]

