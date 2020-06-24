Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7FD41207B60
	for <lists+netdev@lfdr.de>; Wed, 24 Jun 2020 20:19:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406000AbgFXSTI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Jun 2020 14:19:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58128 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2405757AbgFXSTH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Jun 2020 14:19:07 -0400
Received: from mail-lj1-x244.google.com (mail-lj1-x244.google.com [IPv6:2a00:1450:4864:20::244])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 49760C061573;
        Wed, 24 Jun 2020 11:19:07 -0700 (PDT)
Received: by mail-lj1-x244.google.com with SMTP id i3so3659659ljg.3;
        Wed, 24 Jun 2020 11:19:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=IohO4dX6aswvrM/weyH3sRtBqi9uWig0qnYuqk65KmU=;
        b=CB/Ffy4Bo7CT3M1ijqsNVEo4zSwvgs0U7L8gAezx1UU/7HVJBqAZSgtge72EqEY3w7
         cBZO0Vj4r4JV6NKq4wJmlsO5do5ejYvzpa+VUXjPPHMq+2cI5Bk1UpVHRQVNXLwjIwm6
         0Cv7aLhR4Bvpl0EjCL/8Fea1IaKl6/jD/S1OXYqLXuYpqcTrRukqziSmpSPkQGX9Snew
         BxmhQBJTzAwSvss/U4uv/NGJ7MbORW2TR4TAcNhecr4s8tgNKqEhddV9b47guB8L+2dJ
         mCDo2dc/8KIex2gPvcMsmxzSJoB0Ee4RWdx5YbDdKpUY3TkHRcdG4W7E6jmkPLiUzJMN
         OTYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=IohO4dX6aswvrM/weyH3sRtBqi9uWig0qnYuqk65KmU=;
        b=fKHWohvLfdNSwCDcv0LmDHoUItf/hKV2foO8/HxwulpUHM25BSjMHaMwz71CRDbFUK
         TAoZweEpBVCfqbZ3ePFVhSWxdJ7xh6QJA37UjgMZH3xNtCp+3aLDCHGWAY78js/N8NDn
         wM6LQ8LMGpGSiV21AK4ncgdnoawl63BS7kGoqEDiGYj3qmf6W3exhwPl4RhgFoLd55+t
         oVuyuC/X67eTKohZDpdV8lsSqBf+LU3IbJnBuB6I9cMZrR1qVkLsqXPXN3RvVRtK2LQ/
         19sTCQ6NSpExbj3xJdcOLqFpfbo2p+TZRnkPyT1H8aXVMfSey5m9fKP4KjGz2qrcDgM8
         frHw==
X-Gm-Message-State: AOAM533rY2peUuLgUSe+VlpAqIn9YfdHTgtvoV8Dx/cuy7NUGOMpv1tM
        Nf1dE9zYw/PJNG5E1zqO3Bfzsy5n3Vtw+vBhlBs=
X-Google-Smtp-Source: ABdhPJwq/vtKPw+tt2c1ahBnb1pLW3r1cTZHD81GHbuKMhX0r7oa2ySaamzi/HnnfUX3FPoCOJSkRiT4jigGwYNTHsQ=
X-Received: by 2002:a2e:98d7:: with SMTP id s23mr15129297ljj.2.1593022745689;
 Wed, 24 Jun 2020 11:19:05 -0700 (PDT)
MIME-Version: 1.0
References: <20200623032224.4020118-1-andriin@fb.com> <20200623032224.4020118-2-andriin@fb.com>
 <7ed6ada5-2539-3090-0db7-0f65b67e4699@iogearbox.net> <CAEf4BzbsRyt5Y4-oMaKTUNu_ijnRD09+WW3iA+bfGLZcLpd77w@mail.gmail.com>
 <ee6df475-b7d4-b8ed-dc91-560e42d2e7fc@iogearbox.net> <20200623232503.yzm4g24rwx7khudf@ast-mbp.dhcp.thefacebook.com>
 <f1ec2d3b-4897-1a40-e373-51bed4fd3b87@fb.com> <CAEf4BzZTWyii7k6MjdygJP+VfAHnnr8jbxjG1Ge96ioKq5ZEeQ@mail.gmail.com>
 <5ef2ecf4b7bd9_37452b132c4de5bcc@john-XPS-13-9370.notmuch> <CAEf4BzZN+iH1zcH9VfYhe8CLS3LOrBW97e2e6SCsCTC=cThRqA@mail.gmail.com>
In-Reply-To: <CAEf4BzZN+iH1zcH9VfYhe8CLS3LOrBW97e2e6SCsCTC=cThRqA@mail.gmail.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Wed, 24 Jun 2020 11:18:53 -0700
Message-ID: <CAADnVQK4kWGUiM0z=-xaqs5-VENVDQmhVYAeByHmXC-pE69dNQ@mail.gmail.com>
Subject: Re: [PATCH v3 bpf-next 2/3] selftests/bpf: add variable-length data
 concatenation pattern test
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     John Fastabend <john.fastabend@gmail.com>,
        Yonghong Song <yhs@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andriin@fb.com>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 23, 2020 at 11:51 PM Andrii Nakryiko
<andrii.nakryiko@gmail.com> wrote:
>
> long
> represent reality, it causes more straightforward code generation, if
> you don't aritifically down-cast types.

yep. s/int/long/ conversion in bpf_helpers_def.h definitely improves
generated code.

> But even better is to just fix types of your local variables to match
> native BPF size.

I've applied int to long conversion for test_get_stack_rawtp.c test for now.

Let's try to keep 100% passing rate for test_progs and test_progs-no_alu32 :)
