Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 943CA660259
	for <lists+netdev@lfdr.de>; Fri,  6 Jan 2023 15:38:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233789AbjAFOiO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Jan 2023 09:38:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42378 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230511AbjAFOiM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Jan 2023 09:38:12 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 603048099E
        for <netdev@vger.kernel.org>; Fri,  6 Jan 2023 06:37:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1673015846;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=P/zfGuEErfx9YxOb8v5xGvNVY0pRdOYDG3xC/nVLZ30=;
        b=LzahyLOiYxfBw8+iz6KJdvbXLzxyGKM38tJXuvZ99jWXkRaa/pWiyWxnw96ad3VDUa2eXu
        7q4jlekkasA/LqLYg9M/U5fpDBPx9jLNVaQku8V76TftuHrNV3w7hQrjxJbj82bVr65Szq
        yH27ihWZYsAqqHcHol1SvEh7iCg56mw=
Received: from mail-il1-f200.google.com (mail-il1-f200.google.com
 [209.85.166.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-47-NpuSD1ooOF-KHIAnZyPhKA-1; Fri, 06 Jan 2023 09:37:25 -0500
X-MC-Unique: NpuSD1ooOF-KHIAnZyPhKA-1
Received: by mail-il1-f200.google.com with SMTP id l13-20020a056e0212ed00b00304c6338d79so1206701iln.21
        for <netdev@vger.kernel.org>; Fri, 06 Jan 2023 06:37:24 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=P/zfGuEErfx9YxOb8v5xGvNVY0pRdOYDG3xC/nVLZ30=;
        b=dvKRZSa+aI90+FJJpsBfPtjB3VorPVICc5SfdNF67rBOX/GQzo5ByXGZOStGhFewmv
         FZyFwO6QYPLHQFYTPyYE8uhiOPTdDMDcfmGD8YU1DEkrK3z/1Tzv1XcekJDBFIsqZLQh
         XhOpzAcZ+82pclSTtTARak1I55r2lTZG/lBm6gllMS5uWnDDe/FbITdUkKoco8h3OyhO
         x0ZPhWF5RovfS1ydKVXfTmUaRGivSJkQal2veEoeGZfyocRQkwxvTG6RA2VFSYLI8BXy
         wTxj14W9CNkBElMg4l21hmYotFhWE0Ys50KNaIGI8Ua/9/Yy8JU887Y8sM3EzgIiQ+nK
         gkwg==
X-Gm-Message-State: AFqh2kqOV57jt3oHl85V+A85zfgtWkwTWB8C6YwF3EikAN+0WYrLpnVt
        xKWoza7+Sj3YzhYwxPsjCZ5aSiROtVu/DuOeOqvXdAaLNEPMkhNUYw+Q2aM9xlBiuczYd94nbTJ
        wNKYSoo+jANw2JgLmM2083JPKNJie2juH
X-Received: by 2002:a02:54c7:0:b0:38a:757f:dac9 with SMTP id t190-20020a0254c7000000b0038a757fdac9mr4442652jaa.84.1673015844325;
        Fri, 06 Jan 2023 06:37:24 -0800 (PST)
X-Google-Smtp-Source: AMrXdXvM4bw2Ko76z00L7EjKh+skm8JncjwnAQJE6ihiSkxq86ANz2AZ+mFp90pOVnrlYrhleh2gJGZWL4Ra8my8I3c=
X-Received: by 2002:a02:54c7:0:b0:38a:757f:dac9 with SMTP id
 t190-20020a0254c7000000b0038a757fdac9mr4442635jaa.84.1673015844043; Fri, 06
 Jan 2023 06:37:24 -0800 (PST)
MIME-Version: 1.0
References: <20230106102332.1019632-9-benjamin.tissoires@redhat.com> <202301062140.zfdqzE9b-lkp@intel.com>
In-Reply-To: <202301062140.zfdqzE9b-lkp@intel.com>
From:   Benjamin Tissoires <benjamin.tissoires@redhat.com>
Date:   Fri, 6 Jan 2023 15:37:12 +0100
Message-ID: <CAO-hwJK3RetR9T_=4C+3Fmj-ThNx-3XWgrOJGAL9VebM-PdgLw@mail.gmail.com>
Subject: Re: [PATCH HID for-next v1 8/9] HID: bpf: clean up entrypoint
To:     kernel test robot <lkp@intel.com>
Cc:     Greg KH <greg@kroah.com>, Jiri Kosina <jikos@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev,
        Tero Kristo <tero.kristo@linux.intel.com>,
        linux-kernel@vger.kernel.org, linux-input@vger.kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kselftest@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jan 6, 2023 at 2:42 PM kernel test robot <lkp@intel.com> wrote:
>
> Hi Benjamin,
>
> I love your patch! Perhaps something to improve:
>
> [auto build test WARNING on hid/for-next]
> [also build test WARNING on next-20230106]
> [cannot apply to shuah-kselftest/next shuah-kselftest/fixes char-misc/char-misc-testing char-misc/char-misc-next char-misc/char-misc-linus linus/master v6.2-rc2]
> [If your patch is applied to the wrong git tree, kindly drop us a note.
> And when submitting patch, we suggest to use '--base' as documented in
> https://git-scm.com/docs/git-format-patch#_base_tree_information]
>
> url:    https://github.com/intel-lab-lkp/linux/commits/Benjamin-Tissoires/selftests-hid-add-vmtest-sh/20230106-182823
> base:   https://git.kernel.org/pub/scm/linux/kernel/git/hid/hid.git for-next
> patch link:    https://lore.kernel.org/r/20230106102332.1019632-9-benjamin.tissoires%40redhat.com
> patch subject: [PATCH HID for-next v1 8/9] HID: bpf: clean up entrypoint
> config: i386-randconfig-a013
> compiler: clang version 14.0.6 (https://github.com/llvm/llvm-project f28c006a5895fc0e329fe15fead81e37457cb1d1)
> reproduce (this is a W=1 build):
>         wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
>         chmod +x ~/bin/make.cross
>         # https://github.com/intel-lab-lkp/linux/commit/46336953b47885c5111b7c1a92403b3d94cf3d41
>         git remote add linux-review https://github.com/intel-lab-lkp/linux
>         git fetch --no-tags linux-review Benjamin-Tissoires/selftests-hid-add-vmtest-sh/20230106-182823
>         git checkout 46336953b47885c5111b7c1a92403b3d94cf3d41
>         # save the config file
>         mkdir build_dir && cp config build_dir/.config
>         COMPILER_INSTALL_PATH=$HOME/0day COMPILER=clang make.cross W=1 O=build_dir ARCH=i386 olddefconfig
>         COMPILER_INSTALL_PATH=$HOME/0day COMPILER=clang make.cross W=1 O=build_dir ARCH=i386 SHELL=/bin/bash drivers/hid/bpf/
>
> If you fix the issue, kindly add following tag where applicable
> | Reported-by: kernel test robot <lkp@intel.com>
>
> All warnings (new ones prefixed by >>):
>
> >> drivers/hid/bpf/hid_bpf_jmp_table.c:502:6: warning: no previous prototype for function 'call_hid_bpf_prog_put_deferred' [-Wmissing-prototypes]
>    void call_hid_bpf_prog_put_deferred(struct work_struct *work)
>         ^
>    drivers/hid/bpf/hid_bpf_jmp_table.c:502:1: note: declare 'static' if the function is not intended to be used outside of this translation unit
>    void call_hid_bpf_prog_put_deferred(struct work_struct *work)
>    ^
>    static
>    1 warning generated.
>
>
> vim +/call_hid_bpf_prog_put_deferred +502 drivers/hid/bpf/hid_bpf_jmp_table.c
>
> f5c27da4e3c8a2 Benjamin Tissoires 2022-11-03  501
> 0baef37335dd4d Benjamin Tissoires 2022-11-03 @502  void call_hid_bpf_prog_put_deferred(struct work_struct *work)
> f5c27da4e3c8a2 Benjamin Tissoires 2022-11-03  503  {
> ade9207f04dc40 Benjamin Tissoires 2023-01-06  504       /* kept around for patch readability, to be dropped in the next commmit */
> f5c27da4e3c8a2 Benjamin Tissoires 2022-11-03  505  }
> f5c27da4e3c8a2 Benjamin Tissoires 2022-11-03  506
>

Oops, this function should have been dropped in 8/9 "HID: bpf: clean
up entrypoint". It's now dead code. I'll fix it in v2.

Cheers,
Benjamin

> --
> 0-DAY CI Kernel Test Service
> https://github.com/intel/lkp-tests

