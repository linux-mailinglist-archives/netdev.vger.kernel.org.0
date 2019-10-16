Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4EB6BD85C4
	for <lists+netdev@lfdr.de>; Wed, 16 Oct 2019 04:15:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389343AbfJPCO5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Oct 2019 22:14:57 -0400
Received: from mail-lj1-f193.google.com ([209.85.208.193]:37673 "EHLO
        mail-lj1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730455AbfJPCO5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Oct 2019 22:14:57 -0400
Received: by mail-lj1-f193.google.com with SMTP id l21so22287429lje.4;
        Tue, 15 Oct 2019 19:14:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=dZBjgflZUS0VEu2+zyGgxZgBbs6Ispwu0JDsbM63CLE=;
        b=FsMI5jcfDV8QuHHUyk8C6hI6V3hKANoxTut3jPAALDhpSpkUuL+u5sgtcVFb6hwhTH
         MuesHwQ6Q+wu6JLhERHXVd1BY178VDtJquh8PqycvgERReId04sSNaKNPXGTfG2zfLt+
         HaFkEXEZCVN87iM7QJ5Y4jIaHoADJN0SBntJLlZodccARQadmgK+1eQfbZskV9WhX2Ei
         b1vw8Zcf+OgP2Yd7gJXhdJrOiPm1KAMEbjhntCioVfzPx+Bzl+460RrqvzFMWSCeuTs8
         0jQ5SZ1OvomnsnjFKQuusU+udw0mvHGYWRq/w1vX7gF7Qajuy4GQI0Ao2Jw7D11h7oRh
         gREw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=dZBjgflZUS0VEu2+zyGgxZgBbs6Ispwu0JDsbM63CLE=;
        b=hM4L0Q/dJemLZJkRg1FVJgo8P/pSif0HX7CfMEcK4GZA19a6Vbo9DgTQRJHuDyaecT
         N4eEov5Ml3QPA/qTVknyRqTQB2ee1b6GineAK5/iXtIokfp6mO783FdMMqmO2l6DOPMT
         NWqflKxfF5V57JEx50GZ4Fxkm7VoWnyWW1iEoMRM1rCcgtnbbJPEVamW94IKzXm/3rEF
         oEZxVIvx5rXhuBFaTfwSFke6kJUMOW5j5MOTs9uHBR5LikQXzse2pC8Ww9+6G05AwInX
         0tPa7+qJ6dZYup2BZhiclPhchCs3iQBawbhQf4VJ19zsO9W3QUKuCSw3n3IKiePFg4An
         1uRw==
X-Gm-Message-State: APjAAAUR2RzwunbfzsFnomyqHgzTZ6AK6arxGx/Yu7YDr+n53JNzpjHz
        OnVF4I10f0m4e7frTuNeGWYD17fgTof+es/ch1U=
X-Google-Smtp-Source: APXvYqy4d7LLcbur92M48iHdAm6oxdiqE9mK96GX+ha/61CfUjwxGQ427y/eEkfdA1RL3CkDXJV+wXcvciT67X8WbIY=
X-Received: by 2002:a2e:9cc9:: with SMTP id g9mr23396415ljj.188.1571192094476;
 Tue, 15 Oct 2019 19:14:54 -0700 (PDT)
MIME-Version: 1.0
References: <20191009160907.10981-1-christian.brauner@ubuntu.com> <20191016004138.24845-1-christian.brauner@ubuntu.com>
In-Reply-To: <20191016004138.24845-1-christian.brauner@ubuntu.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Tue, 15 Oct 2019 19:14:42 -0700
Message-ID: <CAADnVQ+JmXK4EGtt-6pm+KENPooewfikaRE5dZqi1pMBc_jdxw@mail.gmail.com>
Subject: Re: [PATCH v2 0/3] bpf: switch to new usercopy helpers
To:     Christian Brauner <christian.brauner@ubuntu.com>
Cc:     Alexei Starovoitov <ast@kernel.org>, bpf <bpf@vger.kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Oct 15, 2019 at 5:41 PM Christian Brauner
<christian.brauner@ubuntu.com> wrote:
>
> Hey everyone,
>
> In v5.4-rc2 we added two new helpers check_zeroed_user() and
> copy_struct_from_user() including selftests (cf. [1]). It is a generic
> interface designed to copy a struct from userspace. The helpers will be
> especially useful for structs versioned by size of which we have quite a
> few.

Was it tested?
Either your conversion is incorrect or that generic helper is broken.
./test_progs -n 2
and
./test_btf
are catching the bug:
BTF prog info raw test[8] (line_info (No subprog. zero tailing
line_info): do_test_info_raw:6205:FAIL prog_fd:-1
expected_prog_load_failure:0 errno:7
nonzero tailing record in line_infoprocessed 0 insns (limit 1000000)
max_states_per_insn 0 total_states 0 peak_states 0 mark_read 0
