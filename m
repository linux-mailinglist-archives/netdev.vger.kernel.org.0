Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 171524F66C6
	for <lists+netdev@lfdr.de>; Wed,  6 Apr 2022 19:19:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238485AbiDFRLb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Apr 2022 13:11:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50800 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238604AbiDFRK4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Apr 2022 13:10:56 -0400
Received: from mail-il1-x132.google.com (mail-il1-x132.google.com [IPv6:2607:f8b0:4864:20::132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2FE4B6D95A;
        Wed,  6 Apr 2022 07:32:39 -0700 (PDT)
Received: by mail-il1-x132.google.com with SMTP id v13so1994171ilg.5;
        Wed, 06 Apr 2022 07:32:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=rtcILSQF44uh8cnztYzUbajRwvfrsHBjFfoA7i11kT0=;
        b=J/y72/m/tDZLGATSG7PMC/Be5SWiygEyXZi+yFdmV5bf0o1pilW9YReIEjbG889wF1
         kwUeUSDzal5gGs0spz6FFsi7U5VbCiof7h3Az980jv7no9J1tvpD/uR6rb0vvh9bv97g
         A8KQXczl/FfbpoEC8t0gp9HAx3+Dg4fAbpEl/m+Nw1BSQ2qFrV/eIpfYyzQbPLOqeZii
         JrWIn9FdfCl4UPyrylVPZppJvtn8VVsz2dmZMEqICx5ttq7W3adbdvWg1b075aI0qSm6
         fmQ+ONAVsjknCCfV6itfm2YjnAroHCvJFwn1HpD/mZPzEJduHhh+R8OYJiF1lFm9lLeo
         zFDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=rtcILSQF44uh8cnztYzUbajRwvfrsHBjFfoA7i11kT0=;
        b=HTtjJ+UTo0Ptq1OxxeHumnWwOnn4HSBJKycc2QcES/qp9DrqlhCme4JZpcy6dCgCJZ
         GeWju7bpWSyOd1eUXVrwaHfJ0qUmiWpsAINZLBfdp6+OYgHTT4jBDuJYT1E7VCzJSB+c
         WPzBRXDfvmb76Nb0GEOzHHlWUKmnsBhU9A3Rbgwmnd/9NO9CcqXXe8V4zZkVFPmBy7ov
         tmXQ+9Zu4fs9y5wA1Ih+WP9hdbC7YrSC7LBURutEzVBx+vo5+1j/StGlSXHhjGUXoq++
         x3sLX/WPZ0JLRaahs8/ijUoUbsTGlR/VWuiZSq41tlnKkNyrceSwGwAFksQL3IgxagO0
         XwxQ==
X-Gm-Message-State: AOAM532E+uMUxR/9FDXIBXxU4YHs/bxlaRpiFAqaQ7cWgt9wCmCACLGu
        Qsd3Q0NiG4ieKToYfAdoMgDoSTRinMoPiWN/k4nePa0xd/0zQg==
X-Google-Smtp-Source: ABdhPJxU/Z0r802Uvc9FLtIdwBiCzCqf+EBVnJnv8KLOSqlgTSGYMkeIMTKLQDx7DX6Ikkf7ArsVmFqWrwPCgm/LoBc=
X-Received: by 2002:a05:6e02:1889:b0:2ca:2105:78 with SMTP id
 o9-20020a056e02188900b002ca21050078mr4524239ilu.6.1649255558536; Wed, 06 Apr
 2022 07:32:38 -0700 (PDT)
MIME-Version: 1.0
References: <20220405130858.12165-1-laoar.shao@gmail.com> <CAEf4BzaEF013kPkV=gkN6fw7e9hO_h0MLWuDbx4Qd68ZCr=5pw@mail.gmail.com>
In-Reply-To: <CAEf4BzaEF013kPkV=gkN6fw7e9hO_h0MLWuDbx4Qd68ZCr=5pw@mail.gmail.com>
From:   Yafang Shao <laoar.shao@gmail.com>
Date:   Wed, 6 Apr 2022 22:32:02 +0800
Message-ID: <CALOAHbB2tsrcx5LZbrxJ8LZQW7dSCrD7ErKx4HRXj2i29Pq9Ew@mail.gmail.com>
Subject: Re: [PATCH bpf-next v3 00/27] bpf: RLIMIT_MEMLOCK cleanups
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Andrii Nakryiko <andrii@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin Lau <kafai@fb.com>, Song Liu <songliubraving@fb.com>,
        Yonghong Song <yhs@fb.com>,
        john fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, Shuah Khan <shuah@kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        "open list:KERNEL SELFTEST FRAMEWORK" 
        <linux-kselftest@vger.kernel.org>
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

On Wed, Apr 6, 2022 at 4:53 AM Andrii Nakryiko
<andrii.nakryiko@gmail.com> wrote:
>
> On Tue, Apr 5, 2022 at 6:09 AM Yafang Shao <laoar.shao@gmail.com> wrote:
> >
> > We have switched to memcg based memory accouting and thus the rlimit is
> > not needed any more. LIBBPF_STRICT_AUTO_RLIMIT_MEMLOCK was introduced in
> > libbpf for backward compatibility, so we can use it instead now.
> >
> > This patchset cleanups the usage of RLIMIT_MEMLOCK in tools/bpf/,
> > tools/testing/selftests/bpf and samples/bpf. The file
> > tools/testing/selftests/bpf/bpf_rlimit.h is removed. The included header
> > sys/resource.h is removed from many files as it is useless in these files.
> >
> > - v3: Get rid of bpf_rlimit.h and fix some typos (Andrii)
> > - v2: Use libbpf_set_strict_mode instead. (Andrii)
> > - v1: https://lore.kernel.org/bpf/20220320060815.7716-2-laoar.shao@gmail.com/
> >
> > Yafang Shao (27):
> >   bpf: selftests: Use libbpf 1.0 API mode instead of RLIMIT_MEMLOCK in
> >     xdping
> >   bpf: selftests: Use libbpf 1.0 API mode instead of RLIMIT_MEMLOCK in
> >     xdpxceiver
> >   bpf: selftests: No need to include bpf_rlimit.h in test_tcpnotify_user
> >   bpf: selftests: No need to include bpf_rlimit.h in flow_dissector_load
> >   bpf: selftests: Set libbpf 1.0 API mode explicitly in
> >     get_cgroup_id_user
> >   bpf: selftests: Set libbpf 1.0 API mode explicitly in
> >     test_cgroup_storage
> >   bpf: selftests: Set libbpf 1.0 API mode explicitly in
> >     get_cgroup_id_user
> >   bpf: selftests: Set libbpf 1.0 API mode explicitly in test_lpm_map
> >   bpf: selftests: Set libbpf 1.0 API mode explicitly in test_lru_map
> >   bpf: selftests: Set libbpf 1.0 API mode explicitly in
> >     test_skb_cgroup_id_user
> >   bpf: selftests: Set libbpf 1.0 API mode explicitly in test_sock_addr
> >   bpf: selftests: Set libbpf 1.0 API mode explicitly in test_sock
> >   bpf: selftests: Set libbpf 1.0 API mode explicitly in test_sockmap
> >   bpf: selftests: Set libbpf 1.0 API mode explicitly in test_sysctl
> >   bpf: selftests: Set libbpf 1.0 API mode explicitly in test_tag
> >   bpf: selftests: Set libbpf 1.0 API mode explicitly in
> >     test_tcp_check_syncookie_user
> >   bpf: selftests: Set libbpf 1.0 API mode explicitly in
> >     test_verifier_log
> >   bpf: samples: Set libbpf 1.0 API mode explicitly in hbm
> >   bpf: selftests: Get rid of bpf_rlimit.h
> >   bpf: selftests: No need to include sys/resource.h in some files
> >   bpf: samples: Use libbpf 1.0 API mode instead of RLIMIT_MEMLOCK in
> >     xdpsock_user
> >   bpf: samples: Use libbpf 1.0 API mode instead of RLIMIT_MEMLOCK in
> >     xsk_fwd
> >   bpf: samples: No need to include sys/resource.h in many files
> >   bpf: bpftool: Remove useless return value of libbpf_set_strict_mode
> >   bpf: bpftool: Set LIBBPF_STRICT_AUTO_RLIMIT_MEMLOCK for legacy libbpf
> >   bpf: bpftool: remove RLIMIT_MEMLOCK
> >   bpf: runqslower: Use libbpf 1.0 API mode instead of RLIMIT_MEMLOCK
> >
>
> Hey Yafang, thanks for the clean up! It looks good, but please make it
> a bit more manageable in terms of number of patches. There is no need
> to have so many tiny patches. Can you squash together all the
> samples/bpf changes into one patch, all the selftests/bpf changes into
> another, bpftool ones still can be just one patch. runqslower makes
> sense to keep separate. Please also use customary subject prefixes for
> those: "selftests/bpf: ", "bpftool: ", "samples/bpf: ". For runqslower
> probably "tools/runqslower: " would be ok as well.
>

Thanks for your suggestion. I will change it.

-- 
Thanks
Yafang
