Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8F922141F8
	for <lists+netdev@lfdr.de>; Sun,  5 May 2019 20:52:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727789AbfEESvx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 5 May 2019 14:51:53 -0400
Received: from mail-qt1-f194.google.com ([209.85.160.194]:36851 "EHLO
        mail-qt1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727232AbfEESvx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 5 May 2019 14:51:53 -0400
Received: by mail-qt1-f194.google.com with SMTP id c35so12414785qtk.3;
        Sun, 05 May 2019 11:51:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=FD4XNmDohB6npAuCOzBWzPy4afYEmCyWIGU7hUhbOk4=;
        b=LGXcHlWGgpo6GNfwghsWKNeOZr1TfQ0b/VaF9iBA5ioN9aIRz1yKDYLrm06DvEZChz
         Mj1XVWR1YlV7ouKZUsAoZMGlCRnjM2rURuGpxEvbxJSc6H0RjBZOoMyj5ctwVoht69gM
         yE7f4u6o8BHV9esBk/oYbazcLw2/Mp6duUUwtdNsC8+syIl1YjISvHj7OYg0kzi/CO9f
         itbeL1ZzHHYLDsFF7TBfZ1Ak44nPgCd6mM72o5gQ8dNZ0VmU12yxu+Od63prXIdvMeH9
         6aSj3z8Ca/C8ThZBdmCnijv4eXjTCcU6uTSHvbIbaG3C2bCOZ6vdAm8wAihtFbC3crdO
         zkzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=FD4XNmDohB6npAuCOzBWzPy4afYEmCyWIGU7hUhbOk4=;
        b=sAuOEFHYWMhPhZ0oPUMs9Wo1CYVGZhKmtbXPQnn6QEuA1OGMopbfcFGJsnUtoYYpOA
         d6uAU2iGHhQo2fVa8jBZUJTjcGy6ohwzKwM8lzlbEFEnf6VM3jb0je5dWAkFA8/sqYn8
         GL+cTsTWffQFipnlSB3xfrkWWuO9v4h74NkPnCD8Pf+FxLkNWBmFc9kN6HB/2V82sguM
         xiTeEs9uMf+DConEcRbU1Gb+dfD58XrllG35BVpfpT2J4SxUOXI00xDxIMuWqK+0OuWr
         eagLqjfJAfLPEe7Ny7c7uXDYDe/UY2FumCnsxSW68aGyfDF4+6AEyOttfDF2HB35z7kD
         Gvfg==
X-Gm-Message-State: APjAAAWo4Xs894LpI9EDexXZOISm1nHBt9PAs186z6e8jdpkFxCT6p4R
        Rqvx4DtLTMuj2Z6CNNef6cmijTN8AT4sNOuUQwE=
X-Google-Smtp-Source: APXvYqxQOvQ/11u8z2azLwb5zq4pf4u7S5DClON1cgsX28i4RjaejkZKr/kXQrZz85nnxe54kkZDfhsXv2uE1ZdCGqo=
X-Received: by 2002:ac8:225a:: with SMTP id p26mr18158257qtp.317.1557082312187;
 Sun, 05 May 2019 11:51:52 -0700 (PDT)
MIME-Version: 1.0
References: <20190502204958.7868-1-joel@joelfernandes.org> <20190503121234.6don256zuvfjtdg6@e107158-lin.cambridge.arm.com>
 <20190503134935.GA253329@google.com> <20190505110423.u7g3f2viovvgzbtn@e107158-lin.cambridge.arm.com>
 <20190505132949.GB3076@localhost> <20190505144608.u3vsxyz5huveuskx@e107158-lin.cambridge.arm.com>
 <20190505155223.GA4976@localhost> <20190505180313.GA80924@google.com>
In-Reply-To: <20190505180313.GA80924@google.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Sun, 5 May 2019 11:51:40 -0700
Message-ID: <CAEf4BzabyytZazUFswzEN6ZaOohxqq0_iRaOY4jc2UkfTfX24w@mail.gmail.com>
Subject: Re: [PATCH RFC] bpf: Add support for reading user pointers
To:     Joel Fernandes <joel@joelfernandes.org>
Cc:     Qais Yousef <qais.yousef@arm.com>, linux-kernel@vger.kernel.org,
        Michal Gregorczyk <michalgr@live.com>,
        Adrian Ratiu <adrian.ratiu@collabora.com>,
        Mohammad Husain <russoue@gmail.com>,
        Srinivas Ramana <sramana@codeaurora.org>,
        duyuchao <yuchao.du@unisoc.com>,
        Manjo Raja Rao <linux@manojrajarao.com>,
        Karim Yaghmour <karim.yaghmour@opersys.com>,
        Tamir Carmeli <carmeli.tamir@gmail.com>,
        Yonghong Song <yhs@fb.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Brendan Gregg <brendan.d.gregg@gmail.com>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Peter Ziljstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Kees Cook <keescook@chromium.org>, kernel-team@android.com,
        Daniel Borkmann <daniel@iogearbox.net>,
        Ingo Molnar <mingo@redhat.com>,
        Networking <netdev@vger.kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Will Deacon <will.deacon@arm.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, May 5, 2019 at 11:08 AM Joel Fernandes <joel@joelfernandes.org> wrote:
>
> On Sun, May 05, 2019 at 03:52:23PM +0000, Joel Fernandes wrote:
> > On Sun, May 05, 2019 at 03:46:08PM +0100, Qais Yousef wrote:
> > > On 05/05/19 13:29, Joel Fernandes wrote:
> > > > On Sun, May 05, 2019 at 12:04:24PM +0100, Qais Yousef wrote:
> > > > > On 05/03/19 09:49, Joel Fernandes wrote:
> > > > > > On Fri, May 03, 2019 at 01:12:34PM +0100, Qais Yousef wrote:
> > > > > > > Hi Joel
> > > > > > >
> > > > > > > On 05/02/19 16:49, Joel Fernandes (Google) wrote:
> > > > > > > > The eBPF based opensnoop tool fails to read the file path string passed
> > > > > > > > to the do_sys_open function. This is because it is a pointer to
> > > > > > > > userspace address and causes an -EFAULT when read with
> > > > > > > > probe_kernel_read. This is not an issue when running the tool on x86 but
> > > > > > > > is an issue on arm64. This patch adds a new bpf function call based
> > > > > > >
> > > > > > > I just did an experiment and if I use Android 4.9 kernel I indeed fail to see
> > > > > > > PATH info when running opensnoop. But if I run on 5.1-rc7 opensnoop behaves
> > > > > > > correctly on arm64.
> > > > > > >
> > > > > > > My guess either a limitation that was fixed on later kernel versions or Android
> > > > > > > kernel has some strict option/modifications that make this fail?
> > > > > >
> > > > > > Thanks a lot for checking, yes I was testing 4.9 kernel with this patch (pixel 3).
> > > > > >
> > > > > > I am not sure what has changed since then, but I still think it is a good
> > > > > > idea to make the code more robust against such future issues anyway. In
> > > > > > particular, we learnt with extensive discussions that user/kernel pointers
> > > > > > are not necessarily distinguishable purely based on their address.
> > > > >
> > > > > Yes I wasn't arguing against that. But the commit message is misleading or
> > > > > needs more explanation at least. I tried 4.9.y stable and arm64 worked on that
> > > > > too. Why do you think it's an arm64 problem?
> > > >
> > > > Well it is broken on at least on at least one arm64 device and the patch I
> > > > sent fixes it. We know that the bpf is using wrong kernel API so why not fix
> > > > it? Are you saying we should not fix it like in this patch? Or do you have
> > > > another fix in mind?
> > >
> > > Again I have no issue with the new API. But the claim that it's a fix for
> > > a broken arm64 is a big stretch. AFAICT you don't understand the root cause of
> > > why copy_to_user_inatomic() fails in your case. Given that Android 4.9 has
> > > its own patches on top of 4.9 stable, it might be something that was introduced
> > > in one of these patches that breaks opensnoop, and by making it use the new API
> > > you might be simply working around the problem. All I can see is that vanilla
> > > 4.9 stable works on arm64.
> >
> > Agreed that commit message could be improved. I believe issue is something to
> > do with differences in 4.9 PAN emulation backports. AIUI PAN was introduced
> > in upstream only in 4.10 so 4.9 needed backports.
> >
> > I did not root cause this completely because "doing the right thing" fixed
> > the issue. I will look more closely once I am home.
> >
> > Thank you.
>
> +Mark, Will since discussion is about arm64 arch code.
>
> The difference between observing the bug and everything just working seems to
> be the set_fs(USER_DS) as done by Masami's patch that this patch is based on.
> The following diff shows 'ret' as 255 when set_fs(KERN_DS) is used, and then
> after we retry with set_fs(USER_DS), the read succeeds.
>
> diff --git a/mm/maccess.c b/mm/maccess.c
> index 78f9274dd49d..d3e01a33c712 100644
> --- a/mm/maccess.c
> +++ b/mm/maccess.c
> @@ -32,9 +32,20 @@ long __probe_kernel_read(void *dst, const void *src, size_t size)
>         pagefault_disable();
>         ret = __copy_from_user_inatomic(dst,
>                         (__force const void __user *)src, size);
> +       trace_printk("KERNEL_DS: __copy_from_user_inatomic: ret=%d\n", ret);
>         pagefault_enable();
>         set_fs(old_fs);
>
> +       if (ret) {
> +       set_fs(USER_DS);
> +       pagefault_disable();
> +       ret = __copy_from_user_inatomic(dst,
> +                       (__force const void __user *)src, size);
> +       trace_printk("RETRY WITH USER_DS: __copy_from_user_inatomic: ret=%d\n", ret);
> +       pagefault_enable();
> +       set_fs(old_fs);
> +       }
> +
>         return ret ? -EFAULT : 0;
>  }
>  EXPORT_SYMBOL_GPL(probe_kernel_read);
>
> In initially thought this was because of the addr_limit pointer masking done
> by this patch from Mark Rutland "arm64: Use pointer masking to limit uaccess
> speculation"
>
> However removing this masking still makes it fail with KERNEL_DS.
>
> Fwiw, I am still curious which other paths in arm64 check the addr_limit
> which might make the __copy_from_user_inatomic fail if the set_fs is not
> setup correctly.
>
> Either way, I will resubmit the patch with the commit message fixed correctly
> as we agreed and also address Alexei's comments.

Can you please also split the sync of tools/include/uapi/linux/bpf.h
into separate commit. Having it along the other changes causes issues
when syncing libbpf code (and headers it depends on) to a github
mirror (github.com/libbpf/libbpf). Thanks!

>
> Thank you!
>
>  - Joel
>
> --
> 2.21.0.1020.gf2820cf01a-goog
>
