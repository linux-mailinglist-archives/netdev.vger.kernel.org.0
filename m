Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BF0041B360C
	for <lists+netdev@lfdr.de>; Wed, 22 Apr 2020 06:14:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726041AbgDVEOF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Apr 2020 00:14:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34910 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725811AbgDVEOF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Apr 2020 00:14:05 -0400
Received: from mail-ej1-x644.google.com (mail-ej1-x644.google.com [IPv6:2a00:1450:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 51645C061BD3;
        Tue, 21 Apr 2020 21:14:04 -0700 (PDT)
Received: by mail-ej1-x644.google.com with SMTP id x1so797608ejd.8;
        Tue, 21 Apr 2020 21:14:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Kg2icj+XoK5z32K73+Ky/IwpjRd8JDVLbZ4vK1dpblg=;
        b=fKfmdlAjjmK8jg1eJvSvHV5q0/GDlVU5mgiBSkk2siru0FaCsYR7TDzluj28w2ykYI
         rBtotEP8Ybp+ikkyTDdYtDCF5749niE/qGwtj7Wi0vOQVDqDPabTDvaqObBHZBCaH2sz
         kD5P+o+VjEcB3y1ohRM4KTR85lwz8xggeIkarMzqnXwHOgeTh3ixzF3PHC4AjvS3QNbs
         glErE9umhqdySH8MsjfA91MnzebjY144oQOJ2IghEXix0p16bfMwYMrrA8H0mXxoOIwm
         r2TuQf4Xg9iMpQojz5tUPRuWc/16xIRNbzSQK71IoO6We8SFpqtnib4UW18zYRoUGQ4C
         AvyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Kg2icj+XoK5z32K73+Ky/IwpjRd8JDVLbZ4vK1dpblg=;
        b=c3tBE1BnmgK1IfiWE4JQesm8lDqeZDiGZCjnO8gUrnTnCv1UXsqd9hTOanml4uWvPS
         krJt7WpExkR85fvEAaeCOQqfPVyUjy2yPOSPimP+FtBrvscy9LOkoKfRwv750JiqUDem
         s8DDnG1EKDGgCEJO+TuxCnBfyXne3d+aj7Hs6NAZqvS7HgQDxkMzvdX8Fm9ZkwPbXkXR
         oQZ17klMQJdyeePzEOebax1y3zVs6lNwB9wKfG8IGSrBfgQczmelfY+YPU80Qek8qTGB
         pKc9zKUmuPlQWIyxU9s53G6BmKc2oYssZv7HiYIbUwHmnQvhWhBqefyfgUVysvu6+qYM
         ckLg==
X-Gm-Message-State: AGi0PubIi9yfmR84LhTRaS6sq2PI8DJDmXHfF4CtBTggPWbL92vAKV3g
        WlThLl+Pgk4oRXfGMdaE8G4hYWr3Yy/Gc8goWUU=
X-Google-Smtp-Source: APiQypI6WXkmtEDcEn4hoI80i3yEhHGQE8peJzOKcK0eRX/He4uM5ZDaJo/shg3UcGKBmW0Dnwh6M7vluM08gr+QaLE=
X-Received: by 2002:a17:906:548:: with SMTP id k8mr23639280eja.259.1587528842861;
 Tue, 21 Apr 2020 21:14:02 -0700 (PDT)
MIME-Version: 1.0
References: <20200421171552.28393-1-luke.r.nels@gmail.com> <6f1130b3-eaea-cc5e-716f-5d6be77101b9@zytor.com>
 <CAKU6vyb38-XcFeAiP7OW0j++0jS-J4gZP6S2E21dpQwvcEFpKQ@mail.gmail.com> <CAMzpN2hpwK00duVmrzuhDeZY+H7doJ+C-O6=SWrzy+KvAsupqw@mail.gmail.com>
In-Reply-To: <CAMzpN2hpwK00duVmrzuhDeZY+H7doJ+C-O6=SWrzy+KvAsupqw@mail.gmail.com>
From:   Xi Wang <xi.wang@gmail.com>
Date:   Tue, 21 Apr 2020 21:13:26 -0700
Message-ID: <CAKU6vybSa3vwxNcgG2oLmYcvYhaeFhtkJGLKT7Rg=24t7Ju0yg@mail.gmail.com>
Subject: Re: [PATCH bpf 1/2] bpf, x32: Fix invalid instruction in BPF_LDX zero-extension
To:     Brian Gerst <brgerst@gmail.com>
Cc:     "H. Peter Anvin" <hpa@zytor.com>,
        Luke Nelson <lukenels@cs.washington.edu>, bpf@vger.kernel.org,
        Luke Nelson <luke.r.nels@gmail.com>,
        Wang YanQing <udknight@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "the arch/x86 maintainers" <x86@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>, netdev@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 21, 2020 at 8:22 PM Brian Gerst <brgerst@gmail.com> wrote:
> You should explain the reason it is invalid, ie. the instruction
> encoding needs a 32-bit immediate but the current code only emits an
> 8-bit immediate.

Thanks!  Will do in v2.
