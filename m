Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 66F4C323983
	for <lists+netdev@lfdr.de>; Wed, 24 Feb 2021 10:33:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234630AbhBXJcM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Feb 2021 04:32:12 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:17014 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S234296AbhBXJb6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Feb 2021 04:31:58 -0500
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 11O92dUB068788;
        Wed, 24 Feb 2021 04:31:00 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : to : date : in-reply-to : references : content-type : mime-version
 : content-transfer-encoding; s=pp1;
 bh=9LGToq0Nu8zzd3GiL0F1mN1L6aESnNdH9k+UG3/BMe4=;
 b=fEilGAkrpCXk4njkF8JmqLlwoKKrOSriebr/Nt2eCrXcQRNNjjaNlr/jE+QnuN0I7/Hk
 Wdi8cpL8Ry1EQfDQTH+aPIrmmnV3BjuRSIs4y3Co3WRfUgOBAvCe2n7NhBrKr3itkU9b
 +z4LUfJb1yVIG39daH8E40/LVVGL0yyu3+zVfDGMGJ9rEISo1eqQwPaSV8I7B4Mq2PL5
 uFbK0QmQSDzuE23RMVxtfFKYwfNyMSpwkzFa4LsvGQIKqXxpZBmlwUT88F7NZvCZBC9X
 h4SP9rhdI+HGb3uf7QMYbKkE8j7ZVfK07WyFC14mIXs25Kkozck0a/Jq2asEGSDGuX2A RQ== 
Received: from ppma05fra.de.ibm.com (6c.4a.5195.ip4.static.sl-reverse.com [149.81.74.108])
        by mx0b-001b2d01.pphosted.com with ESMTP id 36vkn29sbf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 24 Feb 2021 04:31:00 -0500
Received: from pps.filterd (ppma05fra.de.ibm.com [127.0.0.1])
        by ppma05fra.de.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 11O9RB6K000475;
        Wed, 24 Feb 2021 09:30:58 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma05fra.de.ibm.com with ESMTP id 36tt289sbg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 24 Feb 2021 09:30:58 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 11O9Uurl30474542
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 24 Feb 2021 09:30:56 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 51BC652050;
        Wed, 24 Feb 2021 09:30:56 +0000 (GMT)
Received: from sig-9-145-151-190.de.ibm.com (unknown [9.145.151.190])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id F105652057;
        Wed, 24 Feb 2021 09:30:55 +0000 (GMT)
Message-ID: <f215762a6033020e79c2b9f5ab2a410c06499a1a.camel@linux.ibm.com>
Subject: Re: [PATCH 1/2] tools, bpf_asm: Hard error on out of range jumps.
From:   Ilya Leoshkevich <iii@linux.ibm.com>
To:     Ian Denhardt <ian@zenhack.net>, ast@kernel.org,
        daniel@iogearbox.net, bpf@vger.kernel.org, netdev@vger.kernel.org
Date:   Wed, 24 Feb 2021 10:30:55 +0100
In-Reply-To: <af571eef0bc5d33180879c0c81a7d1b26431b915.1614134213.git.ian@zenhack.net>
References: <cover.1614134213.git.ian@zenhack.net>
         <af571eef0bc5d33180879c0c81a7d1b26431b915.1614134213.git.ian@zenhack.net>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.38.4 (3.38.4-1.fc33) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-02-24_02:2021-02-23,2021-02-24 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0
 lowpriorityscore=0 priorityscore=1501 bulkscore=0 phishscore=0 mlxscore=0
 mlxlogscore=999 clxscore=1015 suspectscore=0 impostorscore=0 adultscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102240071
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 2021-02-23 at 21:15 -0500, Ian Denhardt wrote:
> Per discussion at:
> 
> https://lore.kernel.org/bpf/c964892195a6b91d20a67691448567ef528ffa6d.camel@linux.ibm.com/T/#t
> 
> ...this was originally introduced as a warning due to concerns about
> breaking existing code, but a hard error probably makes more sense,
> especially given that concerns about breakage were only speculation.
> ---
>  tools/bpf/bpf_exp.y | 6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/tools/bpf/bpf_exp.y b/tools/bpf/bpf_exp.y
> index 8d48e896be50..8d03e5245da5 100644
> --- a/tools/bpf/bpf_exp.y
> +++ b/tools/bpf/bpf_exp.y
> @@ -549,9 +549,11 @@ static uint8_t bpf_encode_jt_jf_offset(int off,
> int i)
>  {
>         int delta = off - i - 1;
>  
> -       if (delta < 0 || delta > 255)
> -               fprintf(stderr, "warning: insn #%d jumps to insn #%d, "
> +       if (delta < 0 || delta > 255) {
> +               fprintf(stderr, "error: insn #%d jumps to insn #%d, "
>                                 "which is out of range\n", i, off);
> +               exit(1);
> +       }
>         return (uint8_t) delta;
>  }
>  

Acked-by: Ilya Leoshkevich <iii@linux.ibm.com>

