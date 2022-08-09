Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E2C3958DC7A
	for <lists+netdev@lfdr.de>; Tue,  9 Aug 2022 18:52:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245052AbiHIQw0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Aug 2022 12:52:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35258 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231377AbiHIQwZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Aug 2022 12:52:25 -0400
Received: from mail-ej1-x633.google.com (mail-ej1-x633.google.com [IPv6:2a00:1450:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE9DB205DC;
        Tue,  9 Aug 2022 09:52:23 -0700 (PDT)
Received: by mail-ej1-x633.google.com with SMTP id qn6so11440575ejc.11;
        Tue, 09 Aug 2022 09:52:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=b//2P5QQ32/pGyn6aed1lkkzkqr+LSUGlrXbbSDazfc=;
        b=RGA5z9FT4OHrVAMVkvoHsCzR0eQTkvTeVZfrNbEIPNqbqbaG+Dcq/YMe6cignJqOBY
         5AG7fH4loTNQbt45XunkZT9tiEkGNrwZM1iM7AkUFOmNdQgBY3wHdWLVm9dLrlXsm7G7
         ngXHVDPrSNK+AMWs/yXjpjD3fk/lQeU22J3CsnIUjdZNAH2QTGRwDUuKxuI3iM5qUxFc
         mBlsfHYZfyp2g8Zve3rZS/J0cef/pWktWMrEGm7S66PeDg2JvnOjd7xHj98+6HYdUcf2
         af9zbL+6ez6Hrh5eAQ6IAyavp+mW3wdd8YQdBdOOV7CoKyQBN7bgMv+uJ9F+qsd17mRy
         yj+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=b//2P5QQ32/pGyn6aed1lkkzkqr+LSUGlrXbbSDazfc=;
        b=X+7henlGnlkixlWHfJHgW7FOWRIevObU5SBVcCIkempKhXc8XyDAopxB0JdOhE5IK9
         1f2zGjhcFJ6hLyVQIlg3e7a0uHIhfWcQ3z59nbU1xdPTXNX2wrtKa1sCSVPN7Qm8LuIe
         Il3H9YWNRC5TpVN11cpLgtq9Ftwd69c9VVqAZDVU8STyn96BUycVP2p/y9xUl5lJ0BjC
         mkk0+t9TWFmgYGMwXVDrgfOSokOe+huJ9DbMWQgOZBUQjvc9U8K1rKlgBI/gkx/ESX7x
         wCNUz0LI+fnSPQGWrwTMZE2WeUoIDHv+8Z01ovXEVpaxPwugWGEFHg4RlDeXoSU3Fw5p
         9MQw==
X-Gm-Message-State: ACgBeo1MYXkXhdnRWdDY9ku9wduZDmihFCj8ElOMCVpB19JpojYk9Da/
        AcwKSf7N4dvZZcAzhrXdz/tx2EAnaW3HE6TClwIfmet4
X-Google-Smtp-Source: AA6agR7MYkhah9c4C2KEdtZV7/vFdlFIGyuB0Bsdr+Hvk93tOu+RmtOHoHIuxxiXV2wfOtm3iuNNAml1ExUyKAF706U=
X-Received: by 2002:a17:907:7da0:b0:730:fe97:f899 with SMTP id
 oz32-20020a1709077da000b00730fe97f899mr13880237ejc.369.1660063941996; Tue, 09
 Aug 2022 09:52:21 -0700 (PDT)
MIME-Version: 1.0
References: <20220722195406.1304948-2-joannelkoong@gmail.com>
 <Yt1RXVnI27iLwxr0@xsang-OptiPlex-9020> <CAJnrk1aX6x79AzFPVk1QwU4ivd5AeYwz6Fe2z6HLunBSBA20yg@mail.gmail.com>
 <cdf30331-483b-a96c-7f6a-336099ebdfe1@intel.com>
In-Reply-To: <cdf30331-483b-a96c-7f6a-336099ebdfe1@intel.com>
From:   Joanne Koong <joannelkoong@gmail.com>
Date:   Tue, 9 Aug 2022 09:52:10 -0700
Message-ID: <CAJnrk1Y4WOHohQFp_+_OUuAQfKS7BewgmKp4V+MF3EMGTxcR=w@mail.gmail.com>
Subject: Re: [net] 03d56978dd: BUG:Bad_page_map_in_process
To:     Yujie Liu <yujie.liu@intel.com>
Cc:     0day robot <lkp@intel.com>, LKML <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>, dccp@vger.kernel.org,
        lkp@lists.01.org, Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        David Miller <davem@davemloft.net>,
        kernel test robot <oliver.sang@intel.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Aug 5, 2022 at 12:30 AM Yujie Liu <yujie.liu@intel.com> wrote:
>
> Hi Joanne,
>
> On 7/28/2022 07:41, Joanne Koong wrote:
> > On Sun, Jul 24, 2022 at 7:05 AM kernel test robot <oliver.sang@intel.com> wrote:
> >>
> >>
> >>
> >> Greeting,
> >>
> >> FYI, we noticed the following commit (built with gcc-11):
> >>
> >> commit: 03d56978dd246147e151916e4dc72af7bc24d5c9 ("[PATCH net-next v3 1/3] net: Add a bhash2 table hashed by port + address")
> >> url: https://github.com/intel-lab-lkp/linux/commits/Joanne-Koong/Add-a-second-bind-table-hashed-by-port-address/20220723-035903
> >> base: https://git.kernel.org/cgit/linux/kernel/git/davem/net-next.git 949d6b405e6160ae44baea39192d67b39cb7eeac
> >> patch link: https://lore.kernel.org/netdev/20220722195406.1304948-2-joannelkoong@gmail.com
> >>
> >> in testcase: boot
> >>
> >> on test machine: qemu-system-x86_64 -enable-kvm -cpu SandyBridge -smp 2 -m 16G
> >>
> >> caused below changes (please refer to attached dmesg/kmsg for entire log/backtrace):
> >>
> >>
> >>
> >> If you fix the issue, kindly add following tag
> >> Reported-by: kernel test robot <oliver.sang@intel.com>
> >>
> >>
> >> [  103.871133][  T486] BUG: Bad page map in process rsync  pte:ffff92f93b759508 pmd:13fc1e067
> >> [  103.873143][  T486] addr:00007f9fe52a2000 vm_flags:00000075 anon_vma:0000000000000000 mapping:ffff92f928adcb58 index:1a1
> >> [  103.875128][  T486] file:libcrypto.so.1.1 fault:filemap_fault mmap:generic_file_mmap read_folio:simple_read_folio
> >> [  103.877339][  T486] CPU: 0 PID: 486 Comm: rsync Not tainted 5.19.0-rc7-01443-g03d56978dd24 #1
> >> [  103.879032][  T486] Call Trace:
> >> [  103.879742][  T486]  <TASK>
> >> [  103.880329][  T486]  ? simple_write_end+0x140/0x140
> >> [  103.881338][  T486]  dump_stack_lvl+0x3b/0x53
> >> [  103.882274][  T486]  ? __filemap_get_folio+0x780/0x780
> >> [  103.883270][  T486]  print_bad_pte.cold+0x15b/0x1c5
> >> [  103.884202][  T486]  vm_normal_page+0x65/0x140
> >> [  103.885062][  T486]  zap_pte_range+0x23b/0x9c0
> >> [  103.885897][  T486]  unmap_page_range+0x263/0x5c0
> >> [  103.886846][  T486]  unmap_vmas+0x121/0x200
> >> [  103.887628][  T486]  exit_mmap+0xb5/0x240
> >> [  103.888401][  T486]  mmput+0x3b/0x140
> >> [  103.889134][  T486]  exit_mm+0xff/0x180
> >> [  103.889877][  T486]  do_exit+0x100/0x400
> >> [  103.890661][  T486]  do_group_exit+0x3e/0x100
> >> [  103.891514][  T486]  __x64_sys_exit_group+0x18/0x40
> >> [  103.892494][  T486]  do_syscall_64+0x5d/0x80
> >> [  103.893294][  T486]  ? do_user_addr_fault+0x257/0x6c0
> >> [  103.894238][  T486]  ? lock_release+0x6e/0x100
> >> [  103.895171][  T486]  ? up_read+0x12/0x40
> >> [  103.896036][  T486]  ? exc_page_fault+0xb2/0x2c0
> >> [  103.897021][  T486]  entry_SYSCALL_64_after_hwframe+0x5d/0xc7
> >> [  103.898243][  T486] RIP: 0033:0x7f9fe5007699
> >> [  103.899149][  T486] Code: Unable to access opcode bytes at RIP 0x7f9fe500766f.
> >> [  103.900511][  T486] RSP: 002b:00007fff7e32c3a8 EFLAGS: 00000246 ORIG_RAX: 00000000000000e7
> >> [  103.902027][  T486] RAX: ffffffffffffffda RBX: 00007f9fe50fc610 RCX: 00007f9fe5007699
> >> [  103.903477][  T486] RDX: 000000000000003c RSI: 00000000000000e7 RDI: 0000000000000000
> >> [  103.904943][  T486] RBP: 0000000000000000 R08: ffffffffffffff80 R09: 0000000000000001
> >> [  103.906384][  T486] R10: 000000000000000b R11: 0000000000000246 R12: 00007f9fe50fc610
> >> [  103.907823][  T486] R13: 0000000000000001 R14: 00007f9fe50fcae8 R15: 0000000000000000
> >> [  103.909290][  T486]  </TASK>
> >> [  103.910423][  T486] Disabling lock debugging due to kernel taint
> >> [  107.503093][  T508] BUG: Bad page map in process rsync  pte:ffff92f93b7fe508 pmd:13aa1c067
> >> [  107.504948][  T508] addr:00007fced9aa2000 vm_flags:00000075 anon_vma:0000000000000000 mapping:ffff92f92891ab58 index:9a
> >> [  107.507070][  T508] file:libzstd.so.1.4.8 fault:filemap_fault mmap:generic_file_mmap read_folio:simple_read_folio
> >> [  107.508825][  T508] CPU: 0 PID: 508 Comm: rsync Tainted: G    B             5.19.0-rc7-01443-g03d56978dd24 #1
> >> [  107.510762][  T508] Call Trace:
> >> [  107.511458][  T508]  <TASK>
> >> [  107.512058][  T508]  ? simple_write_end+0x140/0x140
> >> [  107.513072][  T508]  dump_stack_lvl+0x3b/0x53
> >> [  107.513990][  T508]  ? __filemap_get_folio+0x780/0x780
> >> [  107.519166][  T508]  print_bad_pte.cold+0x15b/0x1c5
> >> [  107.520032][  T508]  vm_normal_page+0x65/0x140
> >> [  107.520802][  T508]  zap_pte_range+0x23b/0x9c0
> >> [  107.521548][  T508]  unmap_page_range+0x263/0x5c0
> >> [  107.522355][  T508]  unmap_vmas+0x121/0x200
> >> [  107.523247][  T508]  exit_mmap+0xb5/0x240
> >> [  107.524107][  T508]  mmput+0x3b/0x140
> >> [  107.524908][  T508]  exit_mm+0xff/0x180
> >> [  107.525716][  T508]  do_exit+0x100/0x400
> >> [  107.526613][  T508]  do_group_exit+0x3e/0x100
> >> [  107.527541][  T508]  __x64_sys_exit_group+0x18/0x40
> >> [  107.528450][  T508]  do_syscall_64+0x5d/0x80
> >> [  107.529368][  T508]  ? up_read+0x12/0x40
> >> [  107.530228][  T508]  ? do_user_addr_fault+0x257/0x6c0
> >> [  107.531121][  T508]  ? rcu_read_lock_sched_held+0x5/0x40
> >> [  107.532046][  T508]  ? exc_page_fault+0xb2/0x2c0
> >> [  107.532843][  T508]  entry_SYSCALL_64_after_hwframe+0x5d/0xc7
> >> [  107.533866][  T508] RIP: 0033:0x7fced95ff699
> >> [  107.534781][  T508] Code: Unable to access opcode bytes at RIP 0x7fced95ff66f.
> >> [  107.536225][  T508] RSP: 002b:00007fff162474c8 EFLAGS: 00000246 ORIG_RAX: 00000000000000e7
> >> [  107.537871][  T508] RAX: ffffffffffffffda RBX: 00007fced96f4610 RCX: 00007fced95ff699
> >> [  107.539506][  T508] RDX: 000000000000003c RSI: 00000000000000e7 RDI: 0000000000000000
> >> [  107.541126][  T508] RBP: 0000000000000000 R08: ffffffffffffff80 R09: 0000000000000001
> >> [  107.542743][  T508] R10: 000000000000000b R11: 0000000000000246 R12: 00007fced96f4610
> >> [  107.544310][  T508] R13: 0000000000000001 R14: 00007fced96f4ae8 R15: 0000000000000000
> >> [  107.545881][  T508]  </TASK>
> >>
> >>
> >>
> >> To reproduce:
> >>
> >>          # build kernel
> >>          cd linux
> >>          cp config-5.19.0-rc7-01443-g03d56978dd24 .config
> >>          make HOSTCC=gcc-11 CC=gcc-11 ARCH=x86_64 olddefconfig prepare modules_prepare bzImage modules
> >>          make HOSTCC=gcc-11 CC=gcc-11 ARCH=x86_64 INSTALL_MOD_PATH=<mod-install-dir> modules_install
> >>          cd <mod-install-dir>
> >>          find lib/ | cpio -o -H newc --quiet | gzip > modules.cgz
> >>
> >>
> >>          git clone https://github.com/intel/lkp-tests.git
> >>          cd lkp-tests
> >>          bin/lkp qemu -k <bzImage> -m modules.cgz job-script # job-script is attached in this email
> >>
> >>          # if come across any failure that blocks the test,
> >>          # please remove ~/.lkp and /lkp dir to run from a clean state.
> >>
> > I ran this in a loop ~20 times but I'm not able to repro the crash.
> > This is a snippet of what I see (and I can also attach or paste the
> > entire log if that would be helpful):
> >
> > I examined more closely the changes between v2 and v3 and I don't see
> > anything that would lead to this error either (I'm assuming  v2 is
> > okay because this report wasn't generated for it). Looking at the
> > stack trace too, I'm not seeing anything that sticks out (eg this
> > looks like a memory mapping failure and bhash2 didn't modify mapping
> > or paging code).
>
> We chose commit 949d6b405e61 (net: add missing includes and forward
> declarations under net/) as base, which used to be the head of
> net-next/master branch then, and apply your v3 patches on top of it.
> So the test result is a comparison between 949d6b405e61 and v3.
>
> Refer to the bug info:
>
> [  103.871133][  T486] BUG: Bad page map in process rsync  pte:ffff92f93b759508 pmd:13fc1e067
>
> The BUG happens in rsync, and it reminds me that we have some extra
> steps when running the test in our infrastructure. We will use some
> commands such as `wget` and `rsync` to transfer the test result to
> our server, but these steps are not included when reproducing locally.
>
> Then I come up with an idea that maybe the kernel can boot successfully,
> but the v3 patch may have some impacts on the command involving network
> operations.
>
> Could you please help to apply below hack on the latest version of
> lkp-tests, and retry to see if can reproduce the crash? It is just
> a meaningless `wget` command to involve network in local test and align
> with the steps in our testing environment.

I will try to repro this this week. I'll let you know what I find.

>
> diff --git a/lib/upload.sh b/lib/upload.sh
> index 257b498db..e8801736e 100755
> --- a/lib/upload.sh
> +++ b/lib/upload.sh
> @@ -181,7 +181,8 @@ upload_files()
>                  fi
>          else
>                  # 9pfs, copy directly
> -               upload_files_copy "$@"
> +               wget 127.0.0.1
>                  return
>          fi
>   }
>
> After applying above hack, I've tried to run 20 times on base and v3 patch
> respectively. All runs of base are good, but there are 8 crash runs of v3.
>
> Reproducing steps:
>
>         cd linux
>         git remote add net-next https://git.kernel.org/cgit/linux/kernel/git/davem/net-next.git
>         git fetch net-next master
>         git checkout 949d6b405e61 # checkout to base
>         git am <v3.patch>
>
>         cp config-5.19.0-rc7-01443-g03d56978dd24 .config # config file is attached
>         make ARCH=x86_64 olddefconfig prepare modules_prepare bzImage modules
>         mkdir <mod-install-dir>
>         make ARCH=x86_64 INSTALL_MOD_PATH=<mod-install-dir> modules_install
>         cd <mod-install-dir>
>         find lib/ | cpio -o -H newc --quiet | gzip > modules.cgz
>
>          git clone https://github.com/intel/lkp-tests.git
>          cd lkp-tests
>         # apply the hack mentioned above
>          bin/lkp qemu -k <bzImage> -m <mod-install-dir>/modules.cgz job-script # job-script is attached in this email
>
> --
> Best Regards,
> Yujie
>
> >
> > I don't think this bug report is related to the bhash2 changes. But
> > please let me know if you disagree.
> >
> > Thanks,
> > Joanne
> >
> >>
> >>
> >> --
> >> 0-DAY CI Kernel Test Service
> >> https://01.org/lkp
> >>
> >>
