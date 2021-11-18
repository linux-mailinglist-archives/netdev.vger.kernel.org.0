Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5DC9745599A
	for <lists+netdev@lfdr.de>; Thu, 18 Nov 2021 12:05:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343586AbhKRLIq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Nov 2021 06:08:46 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:8928 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235730AbhKRLIn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Nov 2021 06:08:43 -0500
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1AIAwmxi008825;
        Thu, 18 Nov 2021 11:05:31 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : to : cc : date : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=pp1;
 bh=ApxElSQyMlVGM7RDKbnBsAOCLuhFJL/9+8+Geyix3GM=;
 b=lf9IpIDUhx/p+v8YQkwfKwhEXJxtw9kaUOdImQNnkpD1Vs9LM5vF94q5yDhfjJIeVuzY
 CZpHfXGYXCBDVuiWqEJxLA+S+l4tw4TfmQQnQP9MAYfO7krsG4IRPNKDTVjN4MMd85K+
 HfZDObWXrkH4HESrrBfHnWuCUN7s9hwSavNFsZWc4ma/O3bNUYBg6mmfrQ3KCA2AlPhO
 WEWmeyCu0esqZz2I0Z7WZlXQ+DPF/FDENj0uTzh2tn//WS9uep8DhPswqobv3EZlSH64
 zXXO1Ha+qTduC1kTpe2Y1uSKMXbUT0cPp9zm60+RyG+eIah0kI1NYcQ32cc/OGMId1cI og== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3cdnj6r681-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 18 Nov 2021 11:05:31 +0000
Received: from m0098399.ppops.net (m0098399.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 1AIAxFZK009662;
        Thu, 18 Nov 2021 11:05:30 GMT
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3cdnj6r667-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 18 Nov 2021 11:05:30 +0000
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 1AIArErB031660;
        Thu, 18 Nov 2021 11:05:28 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma06ams.nl.ibm.com with ESMTP id 3ca4mkcr97-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 18 Nov 2021 11:05:28 +0000
Received: from d06av24.portsmouth.uk.ibm.com (d06av24.portsmouth.uk.ibm.com [9.149.105.60])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 1AIAwSJN59441434
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 18 Nov 2021 10:58:28 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B62BA4236F;
        Thu, 18 Nov 2021 11:05:25 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 355F942374;
        Thu, 18 Nov 2021 11:05:25 +0000 (GMT)
Received: from sig-9-145-38-29.uk.ibm.com (unknown [9.145.38.29])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 18 Nov 2021 11:05:25 +0000 (GMT)
Message-ID: <c5141650259f330ba3a64b17591a04b348d04199.camel@linux.ibm.com>
Subject: Re: [PATCH bpf] selftests: bpf: check map in map pruning
From:   Ilya Leoshkevich <iii@linux.ibm.com>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        KP Singh <kpsingh@kernel.org>
Cc:     Lorenz Bauer <lmb@cloudflare.com>, Shuah Khan <shuah@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        kernel-team <kernel-team@cloudflare.com>,
        "open list:KERNEL SELFTEST FRAMEWORK" 
        <linux-kselftest@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
Date:   Thu, 18 Nov 2021 12:05:24 +0100
In-Reply-To: <CAEf4BzZTiyyKLg2y_dSvEEgzjSsCRCeRgt99DmFAHJyGqht8tw@mail.gmail.com>
References: <20211111161452.86864-1-lmb@cloudflare.com>
         <CAADnVQKWk5VNT9Z_Cy6COO9NMjkUg1p9gYTsPPzH-fi1qCrDiw@mail.gmail.com>
         <CACAyw99EhJ8k4f3zeQMf3pRC+L=hQhK=Rb3UwSz19wt9gnMPrA@mail.gmail.com>
         <20211118010059.c2mixoshcrcz4ywq@ast-mbp>
         <CAEf4Bza=ZipeiwhvUvLLs9r4dbOUQ6JQTAotmgF6tUr1DAc9pw@mail.gmail.com>
         <CAEf4BzZTiyyKLg2y_dSvEEgzjSsCRCeRgt99DmFAHJyGqht8tw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.38.4 (3.38.4-1.fc33) 
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: 9FhMFCYzbo9L9f0yzBtALCcBKcPj6293
X-Proofpoint-GUID: hht4VGw9i15vWzn2W8jM_875cahgsSZv
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-11-18_05,2021-11-17_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 phishscore=0 mlxscore=0 bulkscore=0 priorityscore=1501 impostorscore=0
 spamscore=0 adultscore=0 mlxlogscore=999 clxscore=1011 suspectscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2111180065
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 2021-11-17 at 17:38 -0800, Andrii Nakryiko wrote:
> On Wed, Nov 17, 2021 at 5:29 PM Andrii Nakryiko
> <andrii.nakryiko@gmail.com> wrote:
> > 
> > On Wed, Nov 17, 2021 at 5:01 PM Alexei Starovoitov
> > <alexei.starovoitov@gmail.com> wrote:
> > > 
> > > On Wed, Nov 17, 2021 at 08:47:45AM +0000, Lorenz Bauer wrote:
> > > > On Sat, 13 Nov 2021 at 01:27, Alexei Starovoitov
> > > > <alexei.starovoitov@gmail.com> wrote:
> > > > > 
> > > > > Not sure how you've tested it, but it doesn't work in unpriv:
> > > > > $ test_verifier 789
> > > > > #789/u map in map state pruning FAIL
> > > > > processed 26 insns (limit 1000000) max_states_per_insn 0
> > > > > total_states
> > > > > 2 peak_states 2 mark_read 1
> > > > > #789/p map in map state pruning OK
> > > > 
> > > > Strange, I have a script that I use for bisecting which uses a
> > > > minimal
> > > > .config + virtue to run a vm, plus I was debugging in gdb at
> > > > the same
> > > > time. I might have missed this, apologies.
> > > > 
> > > > I guess vmtest.sh is the canonical way to run tests now?
> > > 
> > > vmtest.sh runs test_progs only. That's the minimum bar that
> > 
> > It runs test_progs by default, unless something else is requested.
> > You
> > can run anything inside it, e.g.:
> > 
> > ./vmtest.sh -- ./test_maps
> > 
> > BTW, we recently moved configs around in libbpf repo on Github, so
> > this script broke. I'm sending a fix in a few minutes, hopefully.
> 
> ... and of course it's not that simple. [0] recently changed how we
> build qemu image and vmtest.sh had some assumptions. Some trivial
> things I fixed, but I'm not too familiar with the init scripts stuff.
> Adding Ilya and KP to hopefully help with this. Ilya, KP, can you
> please help restore vmtest.sh functionality?
> 
> After fixing few paths:
> 
> diff --git a/tools/testing/selftests/bpf/vmtest.sh
> b/tools/testing/selftests/bpf/vmtest.sh
> index 027198768fad..7ea40108b85d 100755
> --- a/tools/testing/selftests/bpf/vmtest.sh
> +++ b/tools/testing/selftests/bpf/vmtest.sh
> @@ -13,8 +13,8 @@ DEFAULT_COMMAND="./test_progs"
>  MOUNT_DIR="mnt"
>  ROOTFS_IMAGE="root.img"
>  OUTPUT_DIR="$HOME/.bpf_selftests"
> -
> KCONFIG_URL="https://raw.githubusercontent.com/libbpf/libbpf/master/travis-ci/vmtest/configs/latest.config
> "
> -
> KCONFIG_API_URL="https://api.github.com/repos/libbpf/libbpf/contents/travis-ci/vmtest/configs/latest.config
> "
> +KCONFIG_URL="https://raw.githubusercontent.com/libbpf/libbpf/master/travis-ci/vmtest/configs/config-latest.x86_64
> "
> +KCONFIG_API_URL="https://api.github.com/repos/libbpf/libbpf/contents/travis-ci/vmtest/configs/config-latest.x86_64
> "
>  INDEX_URL="https://raw.githubusercontent.com/libbpf/libbpf/master/travis-ci/vmtest/configs/INDEX
> "
>  NUM_COMPILE_JOBS="$(nproc)"
>  LOG_FILE_BASE="$(date +"bpf_selftests.%Y-%m-%d_%H-%M-%S")"
> @@ -85,7 +85,7 @@ newest_rootfs_version()
>  {
>         {
>         for file in "${!URLS[@]}"; do
> -               if [[ $file =~ ^libbpf-vmtest-rootfs-(.*)\.tar\.zst$
> ]]; then
> +               if [[ $file =~
> ^x86_64/libbpf-vmtest-rootfs-(.*)\.tar\.zst$ ]]; then
>                         echo "${BASH_REMATCH[1]}"
>                 fi
>         done
> 
> ... the next problem is more severe. Script complains about missing
> /etc/rcS.d, if I just force-created it, when kernel boots we get:
> 
> 
> [    1.050803] ---[ end Kernel panic - not syncing: No working init
> found.  Try passing init= option to kernel. See Linux
> Documentation/admin-guide/init.rst for guidance. ]---
> 
> 
> Please help.

I'll have a look.

Do you think whether it would make sense to reference a fixed
libbpf commitid instead of master in vmtest.sh? So that updates like
this could be done in a controlled manner.

Best regards,
Ilya

