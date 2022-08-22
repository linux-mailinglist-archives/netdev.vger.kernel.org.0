Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7CDCF59C4A2
	for <lists+netdev@lfdr.de>; Mon, 22 Aug 2022 19:07:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236904AbiHVRGl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Aug 2022 13:06:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55076 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236974AbiHVRGj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Aug 2022 13:06:39 -0400
Received: from mx0a-00364e01.pphosted.com (mx0a-00364e01.pphosted.com [148.163.135.74])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 43AF941D2A
        for <netdev@vger.kernel.org>; Mon, 22 Aug 2022 10:06:38 -0700 (PDT)
Received: from pps.filterd (m0167069.ppops.net [127.0.0.1])
        by mx0a-00364e01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 27MH57V6011597
        for <netdev@vger.kernel.org>; Mon, 22 Aug 2022 13:06:38 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=columbia.edu; h=mime-version :
 references : in-reply-to : from : date : message-id : subject : to : cc :
 content-type : content-transfer-encoding; s=pps01;
 bh=KCj0FjEs6uK4eYbvPTyi5BPv9COVt9zzyk1syStqmCs=;
 b=eW6EC4v92GOJMN5FH/DJOZIdw52yNRNjSYe0hi/goVuUP3vI/cnLd9kHPrilJCYUEsD/
 k3Ym+hcyfl3Gpn4BRHxZUIYoKXzKfA1ApHjE2PB1i0/QQTNIDaqPdKn2xtrQnEpLQ0ue
 hRXuAI2Nx4MsYklE3uy/R/plKWJ6jdWZMvxcBpbCpdULWeuemFxQxI0CU3yXg22T/yvJ
 Qnryt3obcVzoLlXbAzAvtQ2N4YfQTbRVsIZtFRSJLFyjlkKKYxSsNEP1cw0FHrOKuDIJ
 nHMaWiRbtnWTD72Jtk2Mp9SEBcgK+ajkOAQA+ar8LLibIe5s14FIMDnGVlZ2HQfygcVL xA== 
Received: from sendprdmail22.cc.columbia.edu (sendprdmail22.cc.columbia.edu [128.59.72.24])
        by mx0a-00364e01.pphosted.com (PPS) with ESMTPS id 3j2wj83tes-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Mon, 22 Aug 2022 13:06:37 -0400
Received: from mail-ua1-f71.google.com (mail-ua1-f71.google.com [209.85.222.71])
        by sendprdmail22.cc.columbia.edu (8.14.7/8.14.4) with ESMTP id 27MH56Rk055326
        (version=TLSv1/SSLv3 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Mon, 22 Aug 2022 13:05:06 -0400
Received: by mail-ua1-f71.google.com with SMTP id c9-20020ab01449000000b0039ef08c94d0so881430uae.23
        for <netdev@vger.kernel.org>; Mon, 22 Aug 2022 10:05:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc;
        bh=KCj0FjEs6uK4eYbvPTyi5BPv9COVt9zzyk1syStqmCs=;
        b=pncOI6U8epuBvHOsuDKvcUjfAkjxMRyV7gYr8XehvhJR+8I17ikixbdio/edyLyLUF
         qLsMgNuOzPbyNvVxxphY09LV+RNZbMFyNSFCGyV7b+eBKNIqiJ3cU/RyyvaOTkq8R8+6
         2toh1dfVfnvrnGNkaS7MAtSsFxFXoeYGfGUEkkFKBG/rDDZMW0d2W9Ud/niS6Lxy4HFz
         yU/0wLwMdP+X+McUgltroOXgqV1ynD1gZcj+e6xR0mXpsBCiD97ePvScUhVlBTFIkoq4
         SaAmD5oqhNkE38zhccKu5Zq00t/0zcGzPqpAnUfBmSOpFxbvZQNIymdlMWQvpf+Z0o/m
         x5AQ==
X-Gm-Message-State: ACgBeo0zBER++LGaqDaDwbya4Cea0qXWjgaARnGuB8XWPhWQvzRgygop
        N0PVXDYZ3nZVYtgtDUMvDW/axr6Wzqjxl2QWUNLGyWkP1l3x2VM10kBKcmEQK5FtDxLpb16bva2
        MI7JvjeAXUVytMb/oaV4gPyCSuVdk7beMYxKkMm9A
X-Received: by 2002:a1f:3f49:0:b0:38a:d56f:b713 with SMTP id m70-20020a1f3f49000000b0038ad56fb713mr4529549vka.26.1661187905927;
        Mon, 22 Aug 2022 10:05:05 -0700 (PDT)
X-Google-Smtp-Source: AA6agR4R9FfLgGQO4Zvs7UjDbs52NCEx+MD/bBCI9qMmTviGJ3OqXM+XfAWbumMUhCDbXdaQjIUO1toLWQ8vEBZvVM4=
X-Received: by 2002:a1f:3f49:0:b0:38a:d56f:b713 with SMTP id
 m70-20020a1f3f49000000b0038ad56fb713mr4529505vka.26.1661187905342; Mon, 22
 Aug 2022 10:05:05 -0700 (PDT)
MIME-Version: 1.0
References: <CAEHB249jcoG=sMGLUgqw3Yf+SjZ7ZkUfF_M+WcyQGCAe77o2kA@mail.gmail.com>
 <20220819072256.fn7ctciefy4fc4cu@wittgenstein>
In-Reply-To: <20220819072256.fn7ctciefy4fc4cu@wittgenstein>
From:   Gabriel Ryan <gabe@cs.columbia.edu>
Date:   Mon, 22 Aug 2022 13:04:58 -0400
Message-ID: <CALbthtdFY+GHTzGH9OujzqpOtWZAqsU3MAsjv5OpwZUW6gVa7A@mail.gmail.com>
Subject: Re: data-race in cgroup_get_tree / proc_cgroup_show
To:     Christian Brauner <brauner@kernel.org>
Cc:     Abhishek Shah <abhishek.shah@columbia.edu>,
        linux-kernel@vger.kernel.org, andrii@kernel.org, ast@kernel.org,
        bpf@vger.kernel.org, cgroups@vger.kernel.org, daniel@iogearbox.net,
        hannes@cmpxchg.org, john.fastabend@gmail.com, kafai@fb.com,
        kpsingh@kernel.org, lizefan.x@bytedance.com,
        netdev@vger.kernel.org, songliubraving@fb.com, tj@kernel.org,
        yhs@fb.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Proofpoint-GUID: ovSPt_Vu5EbUqDHmalajrDuSQIzOtbBh
X-Proofpoint-ORIG-GUID: ovSPt_Vu5EbUqDHmalajrDuSQIzOtbBh
X-CU-OB: Yes
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-08-22_10,2022-08-22_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 malwarescore=0
 adultscore=0 mlxlogscore=999 priorityscore=1501 lowpriorityscore=10
 impostorscore=10 phishscore=0 suspectscore=0 bulkscore=10 clxscore=1015
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2207270000 definitions=main-2208220071
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Christian,

We ran a quick test and confirm your suggestion would eliminate the
data race alert we observed. If the data race is benign (and it
appears to be), using WRITE_ONCE(cgrp_dfl_visible, true) instead of
cmpxchg in cgroup_get_tree() would probably also be ok.

Best,

Gabe

On Fri, Aug 19, 2022 at 3:23 AM Christian Brauner <brauner@kernel.org> wrot=
e:
>
> On Thu, Aug 18, 2022 at 07:24:00PM -0400, Abhishek Shah wrote:
> > Hi all,
> >
> > We found the following data race involving the *cgrp_dfl_visible *varia=
ble.
> > We think it has security implications as the racing variable controls t=
he
> > contents used in /proc/<pid>/cgroup which has been used in prior work
> > <https://urldefense.proofpoint.com/v2/url?u=3Dhttps-3A__www.cyberark.co=
m_resources_threat-2Dresearch-2Dblog_the-2Dstrange-2Dcase-2Dof-2Dhow-2Dwe-2=
Descaped-2Dthe-2Ddocker-2Ddefault-2Dcontainer&d=3DDwIBaQ&c=3D009klHSCxuh5AI=
1vNQzSO0KGjl4nbi2Q0M1QLJX9BeE&r=3DEyAJYRJu01oaAhhVVY3o8zKgZvacDAXd_PNRtaqAC=
Co&m=3DoB43wXi5itVN6tAAOVg5q3rzeXp6QVvxICYqYL6p0wnMMhRB_HrHCwwt0dYa5x44&s=
=3D78sLv2vexAVEQwQPx_CuCJ90is9f3iixNbmbCp0Agpo&e=3D  >
> > in container escapes. Please let us know what you think. Thanks!
>
> One straightforward fix might be to use
> cmpxchg(&cgrp_dfl_visible, false, true) in cgroup_get_tree()
> and READ_ONCE(cgrp_dfl_visible) in proc_cgroup_show() or sm like that.
> I'm not sure this is an issue though but might still be nice to fix it.
>
> >
> > *-----------------------------Report-----------------------------------=
---*
> > *write* to 0xffffffff881d0344 of 1 bytes by task 6542 on cpu 0:
> >  cgroup_get_tree+0x30/0x1c0 kernel/cgroup/cgroup.c:2153
> >  vfs_get_tree+0x53/0x1b0 fs/super.c:1497
> >  do_new_mount+0x208/0x6a0 fs/namespace.c:3040
> >  path_mount+0x4a0/0xbd0 fs/namespace.c:3370
> >  do_mount fs/namespace.c:3383 [inline]
> >  __do_sys_mount fs/namespace.c:3591 [inline]
> >  __se_sys_mount+0x215/0x2d0 fs/namespace.c:3568
> >  __x64_sys_mount+0x67/0x80 fs/namespace.c:3568
> >  do_syscall_x64 arch/x86/entry/common.c:50 [inline]
> >  do_syscall_64+0x3d/0x90 arch/x86/entry/common.c:80
> >  entry_SYSCALL_64_after_hwframe+0x44/0xae
> >
> > *read* to 0xffffffff881d0344 of 1 bytes by task 6541 on cpu 1:
> >  proc_cgroup_show+0x1ec/0x4e0 kernel/cgroup/cgroup.c:6017
> >  proc_single_show+0x96/0x120 fs/proc/base.c:777
> >  seq_read_iter+0x2d2/0x8e0 fs/seq_file.c:230
> >  seq_read+0x1c9/0x210 fs/seq_file.c:162
> >  vfs_read+0x1b5/0x6e0 fs/read_write.c:480
> >  ksys_read+0xde/0x190 fs/read_write.c:620
> >  __do_sys_read fs/read_write.c:630 [inline]
> >  __se_sys_read fs/read_write.c:628 [inline]
> >  __x64_sys_read+0x43/0x50 fs/read_write.c:628
> >  do_syscall_x64 arch/x86/entry/common.c:50 [inline]
> >  do_syscall_64+0x3d/0x90 arch/x86/entry/common.c:80
> >  entry_SYSCALL_64_after_hwframe+0x44/0xae
> >
> > Reported by Kernel Concurrency Sanitizer on:
> > CPU: 1 PID: 6541 Comm: syz-executor2-n Not tainted 5.18.0-rc5+ #107
> > Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.15.0-1
> > 04/01/2014
> >
> >
> > *Reproducing Inputs*
> > Input CPU 0:
> > r0 =3D fsopen(&(0x7f0000000000)=3D'cgroup2\x00', 0x0)
> > fsconfig$FSCONFIG_CMD_CREATE(r0, 0x6, 0x0, 0x0, 0x0)
> > fsmount(r0, 0x0, 0x83)
> >
> > Input CPU 1:
> > r0 =3D syz_open_procfs(0x0, &(0x7f0000000040)=3D'cgroup\x00')
> > read$eventfd(r0, &(0x7f0000000080), 0x8)

--=20
Gabriel Ryan
PhD Candidate at Columbia University
