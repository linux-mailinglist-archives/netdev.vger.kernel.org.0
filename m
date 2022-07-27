Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C64F75835B9
	for <lists+netdev@lfdr.de>; Thu, 28 Jul 2022 01:41:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233761AbiG0XlU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Jul 2022 19:41:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33912 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231322AbiG0XlT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Jul 2022 19:41:19 -0400
Received: from mail-ej1-x62c.google.com (mail-ej1-x62c.google.com [IPv6:2a00:1450:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F10152FD3;
        Wed, 27 Jul 2022 16:41:17 -0700 (PDT)
Received: by mail-ej1-x62c.google.com with SMTP id fy29so282287ejc.12;
        Wed, 27 Jul 2022 16:41:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=oDThiYiDSRmRQOIInIgxhbn1r+WMmHVMROMmric+b6o=;
        b=DRAX4yrEc0RafRXoXNMgsCoj+X7aQcFDwtwO8w7hfZKYnkAPKQR1rRPrO7EFh6GYhM
         kMu9hkTdZPaloNnCaAD2SY6qKXFcy/O/ugCh153lpNCOasFFQlx6d5ioQTn3wTBVHY9C
         53ZSEjgc791WtQJhGObraiNlcBcWjpkz7ogU3U+Zr844QM3qnPARy6l5OV42fG15NpZb
         /u251ZLvRez7SDXVt8epIewfcNBj5KCAyHbb9vtgjbcNBOtOQGcHiWOhq23fPg43/Qvb
         It0ar0kQkb6iPfhdFcb5cmWxRDkuEO9OcrTnLJXlqoTbXE7n66K8exMZlqK62fBvcjj2
         qH0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=oDThiYiDSRmRQOIInIgxhbn1r+WMmHVMROMmric+b6o=;
        b=W3BOwlRDG+sd3GNG7w0pzinDBVOdTjQvp37laKckvHyTdHBW0f/v4AcjQ3JUicuKZs
         mOw12On3mrzotEzjTi9zF57fEdQgIpJ/4Ug0MhyxJ6ffb1jz34EpbK6JtPYmi9gadiQ9
         T4Rzmc4b3vUYheA5QKKc9qMOrTmL5NyYYr7icqLbWHnp1ok0GycausS0+N55n44JuGMK
         MUbqkoK5k0BjPVuEgFyVR+a9gaYLyA4W54NXeM/gt8v5QHchWbi0E5UrwfsTobkMKx9a
         9L9jho0NkvA8BLHQYNoDV4jF0uB6jHicbl3WRDy9b/+IIqU0j7ShPzFkWTwaim4lsIP6
         ckXA==
X-Gm-Message-State: AJIora8mXUcvEuN/sCkcubZTRDDeXc+9grBVXWyfU8ztCM5oIBFDWuVq
        h6pT+hAN+JbORY/A4+KVrfdTqm8y/70mGQ0A1J4=
X-Google-Smtp-Source: AGRyM1t5nN1xhygIYxSzDKAzAJE/TyMd4uZe871fBxvqxZL04MSXoQl0CXEdexOomhq+yixbnUwpvbKJqD7onZ1Yz0w=
X-Received: by 2002:a17:907:3d94:b0:72b:54bc:aa38 with SMTP id
 he20-20020a1709073d9400b0072b54bcaa38mr19794000ejc.679.1658965275788; Wed, 27
 Jul 2022 16:41:15 -0700 (PDT)
MIME-Version: 1.0
References: <20220722195406.1304948-2-joannelkoong@gmail.com> <Yt1RXVnI27iLwxr0@xsang-OptiPlex-9020>
In-Reply-To: <Yt1RXVnI27iLwxr0@xsang-OptiPlex-9020>
From:   Joanne Koong <joannelkoong@gmail.com>
Date:   Wed, 27 Jul 2022 16:41:04 -0700
Message-ID: <CAJnrk1aX6x79AzFPVk1QwU4ivd5AeYwz6Fe2z6HLunBSBA20yg@mail.gmail.com>
Subject: Re: [net] 03d56978dd: BUG:Bad_page_map_in_process
To:     kernel test robot <oliver.sang@intel.com>
Cc:     0day robot <lkp@intel.com>, LKML <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>, dccp@vger.kernel.org,
        lkp@lists.01.org, Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        David Miller <davem@davemloft.net>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Jul 24, 2022 at 7:05 AM kernel test robot <oliver.sang@intel.com> w=
rote:
>
>
>
> Greeting,
>
> FYI, we noticed the following commit (built with gcc-11):
>
> commit: 03d56978dd246147e151916e4dc72af7bc24d5c9 ("[PATCH net-next v3 1/3=
] net: Add a bhash2 table hashed by port + address")
> url: https://github.com/intel-lab-lkp/linux/commits/Joanne-Koong/Add-a-se=
cond-bind-table-hashed-by-port-address/20220723-035903
> base: https://git.kernel.org/cgit/linux/kernel/git/davem/net-next.git 949=
d6b405e6160ae44baea39192d67b39cb7eeac
> patch link: https://lore.kernel.org/netdev/20220722195406.1304948-2-joann=
elkoong@gmail.com
>
> in testcase: boot
>
> on test machine: qemu-system-x86_64 -enable-kvm -cpu SandyBridge -smp 2 -=
m 16G
>
> caused below changes (please refer to attached dmesg/kmsg for entire log/=
backtrace):
>
>
>
> If you fix the issue, kindly add following tag
> Reported-by: kernel test robot <oliver.sang@intel.com>
>
>
> [  103.871133][  T486] BUG: Bad page map in process rsync  pte:ffff92f93b=
759508 pmd:13fc1e067
> [  103.873143][  T486] addr:00007f9fe52a2000 vm_flags:00000075 anon_vma:0=
000000000000000 mapping:ffff92f928adcb58 index:1a1
> [  103.875128][  T486] file:libcrypto.so.1.1 fault:filemap_fault mmap:gen=
eric_file_mmap read_folio:simple_read_folio
> [  103.877339][  T486] CPU: 0 PID: 486 Comm: rsync Not tainted 5.19.0-rc7=
-01443-g03d56978dd24 #1
> [  103.879032][  T486] Call Trace:
> [  103.879742][  T486]  <TASK>
> [  103.880329][  T486]  ? simple_write_end+0x140/0x140
> [  103.881338][  T486]  dump_stack_lvl+0x3b/0x53
> [  103.882274][  T486]  ? __filemap_get_folio+0x780/0x780
> [  103.883270][  T486]  print_bad_pte.cold+0x15b/0x1c5
> [  103.884202][  T486]  vm_normal_page+0x65/0x140
> [  103.885062][  T486]  zap_pte_range+0x23b/0x9c0
> [  103.885897][  T486]  unmap_page_range+0x263/0x5c0
> [  103.886846][  T486]  unmap_vmas+0x121/0x200
> [  103.887628][  T486]  exit_mmap+0xb5/0x240
> [  103.888401][  T486]  mmput+0x3b/0x140
> [  103.889134][  T486]  exit_mm+0xff/0x180
> [  103.889877][  T486]  do_exit+0x100/0x400
> [  103.890661][  T486]  do_group_exit+0x3e/0x100
> [  103.891514][  T486]  __x64_sys_exit_group+0x18/0x40
> [  103.892494][  T486]  do_syscall_64+0x5d/0x80
> [  103.893294][  T486]  ? do_user_addr_fault+0x257/0x6c0
> [  103.894238][  T486]  ? lock_release+0x6e/0x100
> [  103.895171][  T486]  ? up_read+0x12/0x40
> [  103.896036][  T486]  ? exc_page_fault+0xb2/0x2c0
> [  103.897021][  T486]  entry_SYSCALL_64_after_hwframe+0x5d/0xc7
> [  103.898243][  T486] RIP: 0033:0x7f9fe5007699
> [  103.899149][  T486] Code: Unable to access opcode bytes at RIP 0x7f9fe=
500766f.
> [  103.900511][  T486] RSP: 002b:00007fff7e32c3a8 EFLAGS: 00000246 ORIG_R=
AX: 00000000000000e7
> [  103.902027][  T486] RAX: ffffffffffffffda RBX: 00007f9fe50fc610 RCX: 0=
0007f9fe5007699
> [  103.903477][  T486] RDX: 000000000000003c RSI: 00000000000000e7 RDI: 0=
000000000000000
> [  103.904943][  T486] RBP: 0000000000000000 R08: ffffffffffffff80 R09: 0=
000000000000001
> [  103.906384][  T486] R10: 000000000000000b R11: 0000000000000246 R12: 0=
0007f9fe50fc610
> [  103.907823][  T486] R13: 0000000000000001 R14: 00007f9fe50fcae8 R15: 0=
000000000000000
> [  103.909290][  T486]  </TASK>
> [  103.910423][  T486] Disabling lock debugging due to kernel taint
> [  107.503093][  T508] BUG: Bad page map in process rsync  pte:ffff92f93b=
7fe508 pmd:13aa1c067
> [  107.504948][  T508] addr:00007fced9aa2000 vm_flags:00000075 anon_vma:0=
000000000000000 mapping:ffff92f92891ab58 index:9a
> [  107.507070][  T508] file:libzstd.so.1.4.8 fault:filemap_fault mmap:gen=
eric_file_mmap read_folio:simple_read_folio
> [  107.508825][  T508] CPU: 0 PID: 508 Comm: rsync Tainted: G    B       =
      5.19.0-rc7-01443-g03d56978dd24 #1
> [  107.510762][  T508] Call Trace:
> [  107.511458][  T508]  <TASK>
> [  107.512058][  T508]  ? simple_write_end+0x140/0x140
> [  107.513072][  T508]  dump_stack_lvl+0x3b/0x53
> [  107.513990][  T508]  ? __filemap_get_folio+0x780/0x780
> [  107.519166][  T508]  print_bad_pte.cold+0x15b/0x1c5
> [  107.520032][  T508]  vm_normal_page+0x65/0x140
> [  107.520802][  T508]  zap_pte_range+0x23b/0x9c0
> [  107.521548][  T508]  unmap_page_range+0x263/0x5c0
> [  107.522355][  T508]  unmap_vmas+0x121/0x200
> [  107.523247][  T508]  exit_mmap+0xb5/0x240
> [  107.524107][  T508]  mmput+0x3b/0x140
> [  107.524908][  T508]  exit_mm+0xff/0x180
> [  107.525716][  T508]  do_exit+0x100/0x400
> [  107.526613][  T508]  do_group_exit+0x3e/0x100
> [  107.527541][  T508]  __x64_sys_exit_group+0x18/0x40
> [  107.528450][  T508]  do_syscall_64+0x5d/0x80
> [  107.529368][  T508]  ? up_read+0x12/0x40
> [  107.530228][  T508]  ? do_user_addr_fault+0x257/0x6c0
> [  107.531121][  T508]  ? rcu_read_lock_sched_held+0x5/0x40
> [  107.532046][  T508]  ? exc_page_fault+0xb2/0x2c0
> [  107.532843][  T508]  entry_SYSCALL_64_after_hwframe+0x5d/0xc7
> [  107.533866][  T508] RIP: 0033:0x7fced95ff699
> [  107.534781][  T508] Code: Unable to access opcode bytes at RIP 0x7fced=
95ff66f.
> [  107.536225][  T508] RSP: 002b:00007fff162474c8 EFLAGS: 00000246 ORIG_R=
AX: 00000000000000e7
> [  107.537871][  T508] RAX: ffffffffffffffda RBX: 00007fced96f4610 RCX: 0=
0007fced95ff699
> [  107.539506][  T508] RDX: 000000000000003c RSI: 00000000000000e7 RDI: 0=
000000000000000
> [  107.541126][  T508] RBP: 0000000000000000 R08: ffffffffffffff80 R09: 0=
000000000000001
> [  107.542743][  T508] R10: 000000000000000b R11: 0000000000000246 R12: 0=
0007fced96f4610
> [  107.544310][  T508] R13: 0000000000000001 R14: 00007fced96f4ae8 R15: 0=
000000000000000
> [  107.545881][  T508]  </TASK>
>
>
>
> To reproduce:
>
>         # build kernel
>         cd linux
>         cp config-5.19.0-rc7-01443-g03d56978dd24 .config
>         make HOSTCC=3Dgcc-11 CC=3Dgcc-11 ARCH=3Dx86_64 olddefconfig prepa=
re modules_prepare bzImage modules
>         make HOSTCC=3Dgcc-11 CC=3Dgcc-11 ARCH=3Dx86_64 INSTALL_MOD_PATH=
=3D<mod-install-dir> modules_install
>         cd <mod-install-dir>
>         find lib/ | cpio -o -H newc --quiet | gzip > modules.cgz
>
>
>         git clone https://github.com/intel/lkp-tests.git
>         cd lkp-tests
>         bin/lkp qemu -k <bzImage> -m modules.cgz job-script # job-script =
is attached in this email
>
>         # if come across any failure that blocks the test,
>         # please remove ~/.lkp and /lkp dir to run from a clean state.
>
I ran this in a loop ~20 times but I'm not able to repro the crash.
This is a snippet of what I see (and I can also attach or paste the
entire log if that would be helpful):

[  OK  ] Created slice system-getty.slice.
[  OK  ] Created slice system-modprobe.slice.
[  OK  ] Created slice User and Session Slice.
[  OK  ] Started Dispatch Password =E2=80=A6ts to Console Directory Watch.
[  OK  ] Started Forward Password R=E2=80=A6uests to Wall Directory Watch.
[UNSUPP] Starting of Arbitrary Exec=E2=80=A6Automount Point not supported.
[  OK  ] Reached target Local Encrypted Volumes.
[  OK  ] Reached target Paths.
[  OK  ] Reached target Slices.
[  OK  ] Reached target Swap.
[  OK  ] Listening on RPCbind Server Activation Socket.
[  OK  ] Listening on Syslog Socket.
[  OK  ] Listening on initctl Compatibility Named Pipe.
[  OK  ] Listening on Journal Socket (/dev/log).
[  OK  ] Listening on Journal Socket.
[  OK  ] Listening on udev Control Socket.
[  OK  ] Listening on udev Kernel Socket.
         Mounting RPC Pipe File System...
         Mounting Kernel Debug File System...
         Mounting Kernel Trace File System...
         Starting Load Kernel Module configfs...
         Starting Load Kernel Module drm...
         Starting Load Kernel Module fuse...
         Starting Journal Service...
         Starting Load Kernel Modules...
         Starting Remount Root and Kernel File Systems...
         Starting Coldplug All udev Devices...
[FAILED] Failed to mount RPC Pipe File System.
See 'systemctl status run-rpc_pipefs.mount' for details.
[DEPEND] Dependency failed for RPC =E2=80=A6curity service for NFS server.
[DEPEND] Dependency failed for RPC =E2=80=A6ice for NFS client and server.
[  OK  ] Mounted Kernel Debug File System.
[  OK  ] Mounted Kernel Trace File System.
[  OK  ] Finished Load Kernel Module configfs.
[  OK  ] Finished Load Kernel Module drm.
[  OK  ] Finished Load Kernel Module fuse.
[  OK  ] Finished Load Kernel Modules.
[  OK  ] Finished Remount Root and Kernel File Systems.
[  OK  ] Reached target NFS client services.
         Mounting Kernel Configuration File System...
         Starting Load/Save Random Seed...
         Starting Apply Kernel Variables...
         Starting Create System Users...
[  OK  ] Mounted Kernel Configuration File System.
[  OK  ] Finished Load/Save Random Seed.
[FAILED] Failed to start Apply Kernel Variables.
See 'systemctl status systemd-sysctl.service' for details.
[  OK  ] Finished Create System Users.
         Starting Create Static Device Nodes in /dev...
[  OK  ] Finished Create Static Device Nodes in /dev.
[  OK  ] Reached target Local File Systems (Pre).
[  OK  ] Reached target Local File Systems.
         Starting Preprocess NFS configuration...
         Starting Rule-based Manage=E2=80=A6for Device Events and Files...
[  OK  ] Finished Preprocess NFS configuration.
[  OK  ] Started Journal Service.
         Starting Flush Journal to Persistent Storage...
[  OK  ] Started Rule-based Manager for Device Events and Files.
[  OK  ] Finished Flush Journal to Persistent Storage.
         Starting Create Volatile Files and Directories...
[  OK  ] Finished Create Volatile Files and Directories.
         Starting RPC bind portmap service...
         Starting Update UTMP about System Boot/Shutdown...
[  OK  ] Started RPC bind portmap service.
[  OK  ] Reached target Remote File Systems (Pre).
[  OK  ] Reached target Remote File Systems.
[  OK  ] Reached target RPC Port Mapper.
[FAILED] Failed to start Update UTMP about System Boot/Shutdown.
See 'systemctl status systemd-update-utmp.service' for details.
[DEPEND] Dependency failed for Upda=E2=80=A6about System Runlevel Changes.
[  OK  ] Finished Coldplug All udev Devices.
[  OK  ] Reached target System Initialization.
[  OK  ] Started Daily apt download activities.
[  OK  ] Started Daily apt upgrade and clean activities.
[  OK  ] Started Periodic ext4 Onli=E2=80=A6ata Check for All Filesystems.
[  OK  ] Started Discard unused blocks once a week.
[  OK  ] Started Daily rotation of log files.
[  OK  ] Started Daily Cleanup of Temporary Directories.
[  OK  ] Reached target Timers.
[  OK  ] Listening on D-Bus System Message Bus Socket.
[  OK  ] Reached target Sockets.
[  OK  ] Reached target Basic System.
[  OK  ] Started Regular background program processing daemon.
[  OK  ] Started D-Bus System Message Bus.
         Starting Remove Stale Onli=E2=80=A6t4 Metadata Check Snapshots...
         Starting Helper to synchronize boot up for ifupdown...
         Starting LSB: Execute the =E2=80=A6-e command to reboot system...
         Starting LSB: OpenIPMI Driver init script...
         Starting System Logging Service...
         Starting User Login Management...
[  OK  ] Finished Remove Stale Onli=E2=80=A6ext4 Metadata Check Snapshots.
[  OK  ] Started System Logging Service.
[  OK  ] Finished Helper to synchronize boot up for ifupdown.
[   15.478773][  T244] systemctl (244) used greatest stack depth:
12824 bytes left
[  OK  ] Started LSB: Execute the k=E2=80=A6c -e command to reboot system.
         Starting LSB: Load kernel image with kexec...
         Starting Raise network interfaces...
[FAILED] Failed to start LSB: OpenIPMI Driver init script.
See 'systemctl status openipmi.service' for details.
[  OK  ] Started LSB: Load kernel image with kexec.
[  OK  ] Started User Login Management.
[  OK  ] Finished Raise network interfaces.
[  OK  ] Reached target Network.
         Starting LKP bootstrap...
         Starting /etc/rc.local Compatibility...
         Starting OpenBSD Secure Shell server...
[   15.720065] rc.local[294]: mkdir: cannot create directory
=E2=80=98/var/lock/lkp-bootstrap.lock=E2=80=99: File exists
         Starting Permit User Sessions...
[  OK  ] Started LKP bootstrap.
[  OK  ] Finished Permit User Sessions.
[  OK  ] Started OpenBSD Secure Shell server.
LKP: ttyS0: 298: Kernel tests: Boot OK!
LKP: ttyS0: 298: HOSTNAME vm-snb, MAC 52:54:00:12:34:56, kernel
5.19.0-rc7-01445-ga151972cddb3 901
LKP: ttyS0: 298:  /lkp/lkp/src/bin/run-lkp
/lkp/jobs/scheduled/vm-meta-162/boot-1-debian-11.1-x86_64-20220510.cgz-03d5=
6978dd246147e151916e4dc72af7bc24d5c9-20220724-47452-y7oq44-5.yaml
LKP: ttyS0: 298: LKP: rebooting forcely
[   24.038119][  T298] sysrq: Emergency Sync
[   24.038784][   T25] Emergency Sync complete
[   24.039170][  T298] sysrq: Resetting

I examined more closely the changes between v2 and v3 and I don't see
anything that would lead to this error either (I'm assuming  v2 is
okay because this report wasn't generated for it). Looking at the
stack trace too, I'm not seeing anything that sticks out (eg this
looks like a memory mapping failure and bhash2 didn't modify mapping
or paging code).

I don't think this bug report is related to the bhash2 changes. But
please let me know if you disagree.

Thanks,
Joanne

>
>
> --
> 0-DAY CI Kernel Test Service
> https://01.org/lkp
>
>
