Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 418B81C075E
	for <lists+netdev@lfdr.de>; Thu, 30 Apr 2020 22:06:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726520AbgD3UGQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Apr 2020 16:06:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57600 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726338AbgD3UGQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Apr 2020 16:06:16 -0400
Received: from mail-qt1-x844.google.com (mail-qt1-x844.google.com [IPv6:2607:f8b0:4864:20::844])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD6E0C035494;
        Thu, 30 Apr 2020 13:06:14 -0700 (PDT)
Received: by mail-qt1-x844.google.com with SMTP id g16so2202222qtp.11;
        Thu, 30 Apr 2020 13:06:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=JRMIA4aFoeW64rK3vPXAMNc9kim45mQhJnk98nQl66c=;
        b=k0NR+Poj9fsSwcA+7WyWdt0gkJ4CXdGyiLgG8QDjU/zsvCGWuEkQzczKhP8u4aXGdr
         nKH5OynodkSvpS4xDmsJYQmtLUFPLmKVdUlTDdrrDc3rXYEXzWyRR2+ITYe/8fmVXMAa
         aYDBYWGzjtF9m3k62rvYMUSi5ZNHIjAteAYPVXJFdRELVIjXjMYhkcViHTlNlGU57l3F
         i/GIr0aM5ty5vAC9xKl9fM8DfG6IlornutaoMblGFdMpLONDWqqVPI1BiDGNFc9s647I
         nJd10zzlcuC6T/KbBgAk7aItOqAfZTMz/oQg++D+IJlZVvOupA6Hgm+cy5srpeaslADx
         HzHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=JRMIA4aFoeW64rK3vPXAMNc9kim45mQhJnk98nQl66c=;
        b=ovVap0YYlToU6Orh+dnO5mzTcrHsOznTBJCHs8m4oy/bnVZUuj4gKXg/YaxLYmLkIb
         ffrMMc8Qx55ck+Ko44JmokKJgQdnhGLr8BNMS4ZtIZq2fAPdWZYkySOx51xV27JKqEVH
         g5FqBcqv9Fw8I9xPMrI6sWF0seiECLs8d6oBUeaDXvvbriQS6GbQAEYpIFRgn8hTAB4q
         uFbtkHCYgudW1eHSvuyD3Y847UBQTHtkMfKkfUjFBWHFSqjvZ0pJ3tmIY/WEaiO1YCSF
         wHqO08s3GBI6XMCqsj22hOjY57LSl6vfTpUch4QchH76YkS/08Awiy2g/Etkz9d5OOYt
         ut3Q==
X-Gm-Message-State: AGi0PubYEuxskTeIVxJenec1bxJYZ3NMYpEgUigCxzzF2SpZabBXH1vV
        XiF3/jc2sm7IkMNan7sitFyAkOQgkfippD3nrKk=
X-Google-Smtp-Source: APiQypKeGc2mQW/QIyBBc07ZS1wbZrwS0aY4Lr260HR1QwS/PCdKp2F5anYdMFHNr8YuEqGtaGCPCU7h2XkBDsXSRzw=
X-Received: by 2002:ac8:746:: with SMTP id k6mr190731qth.141.1588277173989;
 Thu, 30 Apr 2020 13:06:13 -0700 (PDT)
MIME-Version: 1.0
References: <20200427201249.2995688-1-yhs@fb.com> <202004281302.DSoHBqoM%lkp@intel.com>
 <a9ae1071-a967-57b5-fa1c-e144a1c655d6@fb.com>
In-Reply-To: <a9ae1071-a967-57b5-fa1c-e144a1c655d6@fb.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Thu, 30 Apr 2020 13:06:02 -0700
Message-ID: <CAEf4BzadujQ2YLMzgE+Fkx6pRCnzmesh=QCfnE=bFBSL++kpEw@mail.gmail.com>
Subject: Re: [PATCH bpf-next v1 12/19] bpf: add bpf_seq_printf and
 bpf_seq_write helpers
To:     Yonghong Song <yhs@fb.com>
Cc:     kbuild test robot <lkp@intel.com>,
        Andrii Nakryiko <andriin@fb.com>, bpf <bpf@vger.kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Networking <netdev@vger.kernel.org>, kbuild-all@lists.01.org,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 28, 2020 at 9:36 AM Yonghong Song <yhs@fb.com> wrote:
>
>
>
> On 4/27/20 11:02 PM, kbuild test robot wrote:
> > Hi Yonghong,
> >
> > I love your patch! Perhaps something to improve:
> >
> > [auto build test WARNING on bpf-next/master]
> > [cannot apply to bpf/master net/master vhost/linux-next net-next/master=
 linus/master v5.7-rc3 next-20200424]
> > [if your patch is applied to the wrong git tree, please drop us a note =
to help
> > improve the system. BTW, we also suggest to use '--base' option to spec=
ify the
> > base tree in git format-patch, please see https://urldefense.proofpoint=
.com/v2/url?u=3Dhttps-3A__stackoverflow.com_a_37406982&d=3DDwIBAg&c=3D5VD0R=
TtNlTh3ycd41b3MUw&r=3DDA8e1B5r073vIqRrFz7MRA&m=3DecuvAWhErc8x32mTscXvNhgSPk=
wcM7tK05lEVYIQMbI&s=3DrUkkN8hfXpHttD7t9NCfe5OIFTZZ_cn_SQTDjvs1cj0&e=3D ]
> >
> > url:    https://github.com/0day-ci/linux/commits/Yonghong-Song/bpf-impl=
ement-bpf-iterator-for-kernel-data/20200428-115101
> > base:   https://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf-next.gi=
t master
> > config: sh-allmodconfig (attached as .config)
> > compiler: sh4-linux-gcc (GCC) 9.3.0
> > reproduce:
> >          wget https://urldefense.proofpoint.com/v2/url?u=3Dhttps-3A__ra=
w.githubusercontent.com_intel_lkp-2Dtests_master_sbin_make.cross&d=3DDwIBAg=
&c=3D5VD0RTtNlTh3ycd41b3MUw&r=3DDA8e1B5r073vIqRrFz7MRA&m=3DecuvAWhErc8x32mT=
scXvNhgSPkwcM7tK05lEVYIQMbI&s=3Dmm3zd05JFgyD1Fvvg5yehcYq7d9KLZkN7XSYyLaJRkA=
&e=3D  -O ~/bin/make.cross
> >          chmod +x ~/bin/make.cross
> >          # save the attached .config to linux build tree
> >          COMPILER_INSTALL_PATH=3D$HOME/0day GCC_VERSION=3D9.3.0 make.cr=
oss ARCH=3Dsh
> >
> > If you fix the issue, kindly add following tag as appropriate
> > Reported-by: kbuild test robot <lkp@intel.com>
> >
> > All warnings (new ones prefixed by >>):
> >
> >     In file included from kernel/trace/bpf_trace.c:10:
> >     kernel/trace/bpf_trace.c: In function 'bpf_seq_printf':
> >>> kernel/trace/bpf_trace.c:463:35: warning: the frame size of 1672 byte=
s is larger than 1024 bytes [-Wframe-larger-than=3D]
> >       463 | BPF_CALL_5(bpf_seq_printf, struct seq_file *, m, char *, fm=
t, u32, fmt_size,
>
> Thanks for reporting. Currently, I am supporting up to 12 string format
> specifiers and each string up to 128 bytes. To avoid racing and helper
> memory allocation, I put it on stack hence the above 1672 bytes, but
> practically, I think support 4 strings with 128 bytes each is enough.
> I will make a change in the next revision.

It's still quite a lot of data on stack. How about per-CPU buffer that
this function can use for temporary storage?

>
> >           |                                   ^~~~~~~~
> >     include/linux/filter.h:456:30: note: in definition of macro '__BPF_=
CAST'
> >       456 |           (unsigned long)0, (t)0))) a
> >           |                              ^
> >>> include/linux/filter.h:449:27: note: in expansion of macro '__BPF_MAP=
_5'
> >       449 | #define __BPF_MAP(n, ...) __BPF_MAP_##n(__VA_ARGS__)
> >           |                           ^~~~~~~~~~
> >>> include/linux/filter.h:474:35: note: in expansion of macro '__BPF_MAP=
'
> >       474 |   return ((btf_##name)____##name)(__BPF_MAP(x,__BPF_CAST,__=
BPF_N,__VA_ARGS__));\
> >           |                                   ^~~~~~~~~
> >>> include/linux/filter.h:484:31: note: in expansion of macro 'BPF_CALL_=
x'
> >       484 | #define BPF_CALL_5(name, ...) BPF_CALL_x(5, name, __VA_ARGS=
__)
> >           |                               ^~~~~~~~~~
> >>> kernel/trace/bpf_trace.c:463:1: note: in expansion of macro 'BPF_CALL=
_5'
> >       463 | BPF_CALL_5(bpf_seq_printf, struct seq_file *, m, char *, fm=
t, u32, fmt_size,
> >           | ^~~~~~~~~~
> >
> > vim +463 kernel/trace/bpf_trace.c
> >
> >     462
> >   > 463       BPF_CALL_5(bpf_seq_printf, struct seq_file *, m, char *, =
fmt, u32, fmt_size,
> >     464                  const void *, data, u32, data_len)
> >     465       {
> >     466               char bufs[MAX_SEQ_PRINTF_VARARGS][MAX_SEQ_PRINTF_=
STR_LEN];
> >     467               u64 params[MAX_SEQ_PRINTF_VARARGS];
> >     468               int i, copy_size, num_args;
> >     469               const u64 *args =3D data;
> >     470               int fmt_cnt =3D 0;
> >     471
> [...]
