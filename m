Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 09EDB273191
	for <lists+netdev@lfdr.de>; Mon, 21 Sep 2020 20:11:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726436AbgIUSLO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Sep 2020 14:11:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47578 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727298AbgIUSLN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Sep 2020 14:11:13 -0400
Received: from mail-yb1-xb44.google.com (mail-yb1-xb44.google.com [IPv6:2607:f8b0:4864:20::b44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3FBA4C061755;
        Mon, 21 Sep 2020 11:11:13 -0700 (PDT)
Received: by mail-yb1-xb44.google.com with SMTP id k2so10928770ybp.7;
        Mon, 21 Sep 2020 11:11:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Iran+WgVhdlsQfKFCm73PoLF/rw6U4lizgfQFR7EXB4=;
        b=af9bYBOCOjJaU7YetVNIRMx6qpb5uzI7ETLMsTS/DSVoj/OZLFxUjR2VEAZxjU4BKV
         XHUxACrJhn82vQLADlEttESx0Dp8VllIZBYE5FZNMKH8Sn3S03krwMicrTS6SwUpz7vB
         HTngdBLXmwjKUP+tjx3tNMW/GxSpCGuTuH7OB+097xdryRnd84QyU7ylqEEHlJc1UUEN
         ybv0SvxLvwbIkQRAhdwTH8C1wX2XAABxum9dmUrwXx/uwNAM7wSp/vFwVTuqrxHvz8vv
         l2nBSAC6fFTCRYjdObjo+31xhxGABeoq96d77AYDiarbr2H/qJ0Bfsxt3EIKP3ALpbe0
         Qlbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Iran+WgVhdlsQfKFCm73PoLF/rw6U4lizgfQFR7EXB4=;
        b=C9bmekN3nA20gbnh4qXwMhhezIg6ifqxRcwOZvWGrXEudhHgSrL7pwfpnmN3dsx6GJ
         sFDWdIqcSRoiIEBa2ewJB82ZowUDyZM5LVrEu9I/jO5dlFeUeOTpweYou0dBaqMu5uYQ
         b09u4Y0PucE4t1dQBx4r36PEXGukm9DA530+Br+5sDVRd+LIX4QRT0PUJEPc2yvq4cTf
         +KGdYKlDFksrwDGyn7a1gOR4tdRoieW+WpLJdegh9IIAqNlN7Ee7drMPKUcGmUzOTD6k
         r+vLyDvaBKzHgVaFBdMOieRsbRezHRmTzs0vaEguZ0I9KpTw7bMrLcmxjmXoztbLQq0T
         h0jA==
X-Gm-Message-State: AOAM5330SsAxuCydToqEEAI6lOWmXEn2J9hMBhwO/1aX+reApwGq3S7L
        AcXt58SzrTaLEHUKc3lSz3pYoY1+pIAT6duZS+Q=
X-Google-Smtp-Source: ABdhPJzEDzrM11Lh9nsc9d5TYxFBP9IUPG/UohJ6zC0Y4JYQvMlgHbN1hOieK4c1VokR6Exk/64uTdf1dMpFhtW/JjA=
X-Received: by 2002:a25:8541:: with SMTP id f1mr1427472ybn.230.1600711872522;
 Mon, 21 Sep 2020 11:11:12 -0700 (PDT)
MIME-Version: 1.0
References: <20200916223512.2885524-5-haoluo@google.com> <202009170943.rYEs5XMN%lkp@intel.com>
 <CA+khW7iDK+g_W30doEtjse1BSHmB62GcrtmkH3pMk7shymw=XA@mail.gmail.com>
In-Reply-To: <CA+khW7iDK+g_W30doEtjse1BSHmB62GcrtmkH3pMk7shymw=XA@mail.gmail.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Mon, 21 Sep 2020 11:11:01 -0700
Message-ID: <CAEf4BzbBQ6E_ARewNvrevFBsxoey=oK6irAObfHTzYD_UQnWSA@mail.gmail.com>
Subject: Re: [PATCH bpf-next v3 4/6] bpf: Introduce bpf_per_cpu_ptr()
To:     Hao Luo <haoluo@google.com>
Cc:     kernel test robot <lkp@intel.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        "open list:KERNEL SELFTEST FRAMEWORK" 
        <linux-kselftest@vger.kernel.org>, kbuild-all@lists.01.org,
        Shuah Khan <skhan@linuxfoundation.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andriin@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Sep 17, 2020 at 12:14 PM Hao Luo <haoluo@google.com> wrote:
>
> I need to cast the pointer to "const void __percpu *" before passing
> into per_cpu_ptr. I will update and resend.

You can try just declaring it as __percpu in BPF_CALL_2 macro. That
might work, or not, depending on how exactly BPF_CALL macros are
implemented (I haven't checked).

>
> On Wed, Sep 16, 2020 at 6:14 PM kernel test robot <lkp@intel.com> wrote:
> >
> > Hi Hao,
> >
> > Thank you for the patch! Perhaps something to improve:
> >
> > [auto build test WARNING on bpf-next/master]
> >
> > url:    https://github.com/0day-ci/linux/commits/Hao-Luo/bpf-BTF-support-for-ksyms/20200917-064052
> > base:   https://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf-next.git master
> > config: powerpc-randconfig-s032-20200916 (attached as .config)
> > compiler: powerpc64-linux-gcc (GCC) 9.3.0
> > reproduce:
> >         wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
> >         chmod +x ~/bin/make.cross
> >         # apt-get install sparse
> >         # sparse version: v0.6.2-201-g24bdaac6-dirty
> >         # save the attached .config to linux build tree
> >         COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-9.3.0 make.cross C=1 CF='-fdiagnostic-prefix -D__CHECK_ENDIAN__' ARCH=powerpc
> >
> > If you fix the issue, kindly add following tag as appropriate
> > Reported-by: kernel test robot <lkp@intel.com>
> >
> >
> > sparse warnings: (new ones prefixed by >>)
> >
> > >> kernel/bpf/helpers.c:631:31: sparse: sparse: incorrect type in initializer (different address spaces) @@     expected void const [noderef] __percpu *__vpp_verify @@     got void const * @@
> > >> kernel/bpf/helpers.c:631:31: sparse:     expected void const [noderef] __percpu *__vpp_verify
> > >> kernel/bpf/helpers.c:631:31: sparse:     got void const *
> >
> > # https://github.com/0day-ci/linux/commit/3f6ea3c1c73efe466a96ff7499219fe3b03b8f48
> > git remote add linux-review https://github.com/0day-ci/linux
> > git fetch --no-tags linux-review Hao-Luo/bpf-BTF-support-for-ksyms/20200917-064052
> > git checkout 3f6ea3c1c73efe466a96ff7499219fe3b03b8f48
> > vim +631 kernel/bpf/helpers.c
> >
> >    625
> >    626  BPF_CALL_2(bpf_per_cpu_ptr, const void *, ptr, u32, cpu)
> >    627  {
> >    628          if (cpu >= nr_cpu_ids)
> >    629                  return (unsigned long)NULL;
> >    630
> >  > 631          return (unsigned long)per_cpu_ptr(ptr, cpu);
> >    632  }
> >    633
> >    634  const struct bpf_func_proto bpf_per_cpu_ptr_proto = {
> >    635          .func           = bpf_per_cpu_ptr,
> >    636          .gpl_only       = false,
> >    637          .ret_type       = RET_PTR_TO_MEM_OR_BTF_ID_OR_NULL,
> >    638          .arg1_type      = ARG_PTR_TO_PERCPU_BTF_ID,
> >    639          .arg2_type      = ARG_ANYTHING,
> >    640  };
> >    641
> >  > 642  const struct bpf_func_proto bpf_get_current_task_proto __weak;
> >    643  const struct bpf_func_proto bpf_probe_read_user_proto __weak;
> >    644  const struct bpf_func_proto bpf_probe_read_user_str_proto __weak;
> >    645  const struct bpf_func_proto bpf_probe_read_kernel_proto __weak;
> >    646  const struct bpf_func_proto bpf_probe_read_kernel_str_proto __weak;
> >    647
> >
> > ---
> > 0-DAY CI Kernel Test Service, Intel Corporation
> > https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org
