Return-Path: <netdev+bounces-3162-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 6F8AF705D7F
	for <lists+netdev@lfdr.de>; Wed, 17 May 2023 04:53:30 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C31B4281409
	for <lists+netdev@lfdr.de>; Wed, 17 May 2023 02:53:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CCD9329113;
	Wed, 17 May 2023 02:53:26 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C219929105
	for <netdev@vger.kernel.org>; Wed, 17 May 2023 02:53:26 +0000 (UTC)
Received: from mail-yw1-x1133.google.com (mail-yw1-x1133.google.com [IPv6:2607:f8b0:4864:20::1133])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 62CE04215;
	Tue, 16 May 2023 19:53:24 -0700 (PDT)
Received: by mail-yw1-x1133.google.com with SMTP id 00721157ae682-55a64f0053fso1783887b3.3;
        Tue, 16 May 2023 19:53:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1684292003; x=1686884003;
        h=to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=XXYwxLpP/GEMBXRmxYSZ2oaxOMKxzAtpkKiPcFNbLA0=;
        b=Ys2DnB3QYX4sLuJE2Da1GwKZHMyCLSIUNrEhk6IbitMv5CqfYspugxavQRwqKOdqjH
         mCMvk1KSHEiycjeXh0trgv2d1OvZeS4owfV4enznM7MwA4fAQf8XZDRilmiYo6Bobufe
         BpeaGdzlHb4pgwHWE9ti5XL879dR9TwLnIcqdA/0pZqe7g30tubhh6vQbcp/ZHTMe5RC
         MjklOK1nfadVe2bcbNi1/E+udr0ZVpGah/Yoe2kA79eVzr7YEOD3fhFG1NCswgD9yiN7
         x1nwQcji3DgNdenFUNKkThA0QC3Q4KMY00f+0VgvvT+ryyMiNKqeN1YUoSUelBU1ymqz
         yK6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684292003; x=1686884003;
        h=to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=XXYwxLpP/GEMBXRmxYSZ2oaxOMKxzAtpkKiPcFNbLA0=;
        b=QrXfXazf44zu8W5yHgP8BI+DDItCo8ixhrx99z16adQ75Y8EMvqREwto/H/rZ/p2F3
         peQpEVE8tka7Bi/JSK+2hsSKp5iJKdiUjyyq+Q06QI7evajVllbqQR4k3eOfpitBLwnk
         /yQvaQt65yZA5Mz7W6tpJWbT1AlUzH9Iy7UsiFI8jZlIsDFh7odbp1A3z3/dOoCh1D2D
         9DCY+1yy4RXjKz0YcoNnz66jztCEDzIXMlklPc3pecYMQlRM2nw1kchUDEArbCSnHQFF
         P4g/mPFFlC1FEoynEcttgDu+RPcMXSlV92hrRAPAyaInYHL1Y5/79OdFJXCV8lnkhtuK
         gfKA==
X-Gm-Message-State: AC+VfDx5BGHbrvdCNkmCKv9umPpidZ4b3kq23GuegiVCoRaShg8HK4+w
	GHNaQW+fkOSGZeqK19AJ8wo1euPVlQID9gpe1ou6y9mmFOcvKQ==
X-Google-Smtp-Source: ACHHUZ7af9ke9UuR65hNaNXAii5tGlPzjYZFPVP4V3IoDU5NqKvlw3ACEDqY+W+P8fHaAMflH2ReOvKiiiZas+ZC1Gw=
X-Received: by 2002:a0d:eb91:0:b0:561:902c:61d3 with SMTP id
 u139-20020a0deb91000000b00561902c61d3mr3445371ywe.40.1684292003064; Tue, 16
 May 2023 19:53:23 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Murphy Zhou <jencce.kernel@gmail.com>
Date: Wed, 17 May 2023 10:53:11 +0800
Message-ID: <CADJHv_sDK=0RrMA2FTZQV5fw7UQ+qY=HG21Wu5qb0V9vvx5w6A@mail.gmail.com>
Subject: WARNING since next-20230516 about ipfrag_low_thresh_unused
To: netdev@vger.kernel.org, Linux-Next <linux-next@vger.kernel.org>, 
	Angus Chen <angus.chen@jaguarmicro.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Hi,

This warning keeps hitting the dmesg since the 0516 tree.

Might be this commit:

commit b2cbac9b9b28730e9e53be20b6cdf979d3b9f27e
Author: Angus Chen <angus.chen@jaguarmicro.com>
Date:   Fri May 12 09:01:52 2023 +0800

    net: Remove low_thresh in ip defrag

Please help to take a look at.

Thanks,
Murphy




[ 2180.527227] ------------[ cut here ]------------
[ 2180.531902] sysctl net/ipv4/ipfrag_low_thresh: data points to
kernel global data: ipfrag_low_thresh_unused
[ 2180.541649] WARNING: CPU: 7 PID: 681484 at net/sysctl_net.c:155
ensure_safe_net_sysctl+0x88/0x100
[ 2180.550607] Modules linked in: dm_snapshot dm_bufio dm_flakey
binfmt_misc veth tun brd overlay exfat ext2 ext4 mbcache jbd2 cifs tls
loop nfsv3 rpcsec_gss_krb5 nfsv4 dns_resolver nfs fscache netfs
rpcrdma rdma_cm iw_cm ib_cm ib_core nfsd auth_rpcgss nfs_acl lockd
grace ipmi_ssif rfkill sunrpc vfat fat intel_rapl_msr
intel_rapl_common edac_mce_amd mgag200 kvm_amd drm_shmem_helper
drm_kms_helper kvm syscopyarea acpi_ipmi sysfillrect ipmi_si irqbypass
sysimgblt ipmi_devintf fb_sys_fops rapl pcspkr i2c_piix4 hpilo k10temp
acpi_tad ipmi_msghandler acpi_power_meter drm fuse xfs libcrc32c
sd_mod t10_pi sg igb ahci libahci crct10dif_pclmul crc32_pclmul
i2c_algo_bit crc32c_intel libata ccp hpwdt ghash_clmulni_intel dca
sp5100_tco wmi dm_mirror dm_region_hash dm_log dm_mod [last unloaded:
scsi_debug]
[ 2180.621100] CPU: 7 PID: 681484 Comm: (ostnamed) Kdump: loaded
Tainted: G        W          6.4.0-rc2-next-20230516 #1
[ 2180.631805] Hardware name: HPE ProLiant DL385 Gen11/ProLiant DL385
Gen11, BIOS 1.10 10/18/2022
[ 2180.640495] RIP: 0010:ensure_safe_net_sysctl+0x88/0x100
[ 2180.645789] Code: 85 bb 72 b9 48 81 fd 00 00 a0 bc 73 b0 48 c7 c1
dd f1 75 ba 4c 8b 43 08 48 8b 13 4c 89 e6 48 c7 c7 c0 51 86 ba e8 f8
b8 4b ff <0f> 0b 66 81 63 14 6d ff eb 89 0f b7 4b 14 4c 8b 4b 08 48 c7
c6 90
[ 2180.664701] RSP: 0018:ff5e70190533bd68 EFLAGS: 00010282
[ 2180.669986] RAX: 0000000000000000 RBX: ff40e6cadd6fea40 RCX: 0000000000000000
[ 2180.677189] RDX: ff40e6ce2cbec880 RSI: ff40e6ce2cbdf840 RDI: ff40e6ce2cbdf840
[ 2180.684399] RBP: ffffffffbc781888 R08: 0000000000000000 R09: 00000000ffff7fff
[ 2180.691609] R10: ff5e70190533bc08 R11: ffffffffbade6888 R12: ffffffffba85c61e
[ 2180.698819] R13: ff40e6cb201dc400 R14: 0000000000000000 R15: 0000000000000000
[ 2180.706029] FS:  00007f519be60b40(0000) GS:ff40e6ce2cbc0000(0000)
knlGS:0000000000000000
[ 2180.714194] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 2180.720004] CR2: 00007f519c96efe0 CR3: 000000012878c002 CR4: 0000000000771ee0
[ 2180.727216] PKRU: 55555554
[ 2180.729967] Call Trace:
[ 2180.732462]  <TASK>
[ 2180.734610]  register_net_sysctl+0x20/0x40
[ 2180.738766]  ipv4_frags_init_net+0xdd/0x180
[ 2180.743001]  ops_init+0x33/0xc0
[ 2180.746190]  setup_net+0x12c/0x2c0
[ 2180.749643]  copy_net_ns+0x10a/0x270
[ 2180.753266]  create_new_namespaces+0x113/0x2e0
[ 2180.757767]  unshare_nsproxy_namespaces+0x55/0xb0
[ 2180.762534]  ksys_unshare+0x1a8/0x390
[ 2180.766251]  __x64_sys_unshare+0xe/0x20
[ 2180.770139]  do_syscall_64+0x59/0x90
[ 2180.773764]  ? do_syscall_64+0x69/0x90
[ 2180.777563]  entry_SYSCALL_64_after_hwframe+0x72/0xdc
[ 2180.782672] RIP: 0033:0x7f519c03f90b
[ 2180.786299] Code: 73 01 c3 48 8b 0d 15 a5 1b 00 f7 d8 64 89 01 48
83 c8 ff c3 66 2e 0f 1f 84 00 00 00 00 00 90 f3 0f 1e fa b8 10 01 00
00 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 8b 0d e5 a4 1b 00 f7 d8 64 89
01 48
[ 2180.805214] RSP: 002b:00007ffcd1b70ae8 EFLAGS: 00000246 ORIG_RAX:
0000000000000110
[ 2180.812866] RAX: ffffffffffffffda RBX: 0000558b7f0a95e8 RCX: 00007f519c03f90b
[ 2180.820081] RDX: 0000000000000000 RSI: 00007ffcd1b70a50 RDI: 0000000040000000
[ 2180.827287] RBP: 00007ffcd1b70b20 R08: 0000000000000000 R09: 00007ffcd1b70e20
[ 2180.834493] R10: 0000000000000000 R11: 0000000000000246 R12: 00007f519c6c6c52
[ 2180.841700] R13: 00000000fffffff5 R14: 0000000040000000 R15: 0000000000000000
[ 2180.848912]  </TASK>
[ 2180.851142] ---[ end trace 0000000000000000 ]---

