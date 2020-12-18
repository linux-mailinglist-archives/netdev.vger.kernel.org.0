Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A88282DDE02
	for <lists+netdev@lfdr.de>; Fri, 18 Dec 2020 06:25:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732029AbgLRFYu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Dec 2020 00:24:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32916 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727150AbgLRFYt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Dec 2020 00:24:49 -0500
Received: from mail-lf1-x129.google.com (mail-lf1-x129.google.com [IPv6:2a00:1450:4864:20::129])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 494C2C0617B0;
        Thu, 17 Dec 2020 21:24:09 -0800 (PST)
Received: by mail-lf1-x129.google.com with SMTP id m12so2322836lfo.7;
        Thu, 17 Dec 2020 21:24:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=jX44ZPL55asabwkQzLkhgcKHKlN7+aA9+rXnNNw2E2o=;
        b=n/dGqS31k7Swa7Q3KF/IFsI+zgXuecnX2lbygMeiGzrTxZoTck3QjBcKuHB4qNUOwA
         jwamRuZTIlJXHCHxGMPSpa+/WX/HJeOsDWW0Gr04ExP6rAtszXr3k21XdQTI7hjjMXBG
         o8rwMYhJ0ZrBMfjJuf/lHKO1gl+D4AR64+kkf/TJHrPnHgyMDxF9ZOoAj9zD+Q7xcY7O
         UCOA03axsqgeNpuSaqNz10n/NUkSFsZ8ts9DCK0+Qiz658o4mbmjfwk0lWNmkzivG8P/
         Ay9mmbBiL09eN8MAqnjKohoJE9OGhQzHykIyIDWyIrNTWQ+Pm7jnVEKe3Ke5PDdKK+af
         w7xQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=jX44ZPL55asabwkQzLkhgcKHKlN7+aA9+rXnNNw2E2o=;
        b=DsIM3r+h0aqjm1J7ECdcEd284+6wX2ezA2XKuhk/dV0M4K9GJVPMSHjZByaCaXFhHd
         h75aiUuZSH8+hiX33umt7rYomX7rbMR25OA5Wnp8u8OhqgPXMOAhxEJ8+fytHrABjSar
         zkOgnYlEF7sBdtq0G3yaEHWZJ3kmN92P/3TNu1se/ZQBNWiFlFsmGUtgBT2OILOR+uyx
         hWoMPhrpI3glWEeTEd38MdbUUtB3/lWAyuUWRkQYsdefkfZanFonkKqDwaxLCnPqL7Mm
         aDTJt1yIUK0v/I80xYuMkrn5jUWfJHJJ+PHIPJ//zbgl64sibjhAhNMR6ejaoxLoevMz
         PAFw==
X-Gm-Message-State: AOAM530s+/m8KF7+u0UWNSo0yfHeGzuEDMcNqCCNyB3gUKGbZ6ISXdjg
        HtEXHIdbxeVYerxeu7KYQNxcR2W+nekM2c3c0lU=
X-Google-Smtp-Source: ABdhPJwXw9PLTZ92JMwNuYjfVr8vvzmmiUosRPtsfidqJzjyZIOLFytJpGYorrxS72Mqw7CryE/hqUjPtJPCi9jGd1c=
X-Received: by 2002:a2e:86d4:: with SMTP id n20mr1060727ljj.486.1608269047780;
 Thu, 17 Dec 2020 21:24:07 -0800 (PST)
MIME-Version: 1.0
References: <20201215233702.3301881-1-songliubraving@fb.com>
 <20201215233702.3301881-2-songliubraving@fb.com> <20201217190308.insbsxpf6ujapbs3@ast-mbp>
 <C4D9D25A-C3DD-4081-9EAD-B7A5B6B74F45@fb.com> <20201218023444.i6hmdi3bp5vgxou2@ast-mbp>
 <D964C66B-2C25-4C3D-AFDE-E600364A721C@fb.com>
In-Reply-To: <D964C66B-2C25-4C3D-AFDE-E600364A721C@fb.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Thu, 17 Dec 2020 21:23:56 -0800
Message-ID: <CAADnVQJyTVgnsDx6bJ1t-Diib9r+fiph9Ax-d97qSMvU3iKcRw@mail.gmail.com>
Subject: Re: [PATCH v2 bpf-next 1/4] bpf: introduce task_vma bpf_iter
To:     Song Liu <songliubraving@fb.com>
Cc:     "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "ast@kernel.org" <ast@kernel.org>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        "andrii@kernel.org" <andrii@kernel.org>,
        "john.fastabend@gmail.com" <john.fastabend@gmail.com>,
        "kpsingh@chromium.org" <kpsingh@chromium.org>,
        Kernel Team <Kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Dec 17, 2020 at 8:33 PM Song Liu <songliubraving@fb.com> wrote:
> >
> > ahh. I missed that. Makes sense.
> > vm_file needs to be accurate, but vm_area_struct should be accessed as ptr_to_btf_id.
>
> Passing pointer of vm_area_struct into BPF will be tricky. For example, shall we
> allow the user to access vma->vm_file? IIUC, with ptr_to_btf_id the verifier will
> allow access of vma->vm_file as a valid pointer to struct file. However, since the
> vma might be freed, vma->vm_file could point to random data.

I don't think so. The proposed patch will do get_file() on it.
There is actually no need to assign it into a different variable.
Accessing it via vma->vm_file is safe and cleaner.

> >> [1] ff9f47f6f00c ("mm: proc: smaps_rollup: do not stall write attempts on mmap_lock")
> >
> > Thanks for this link. With "if (mmap_lock_is_contended())" check it should work indeed.
>
> To make sure we are on the same page: I am using slightly different mechanism in
> task_vma_iter, which doesn't require checking mmap_lock_is_contended(). In the
> smaps_rollup case, the code only unlock mmap_sem when the lock is contended. In
> task_iter, we always unlock mmap_sem between two iterations. This is because we
> don't want to hold mmap_sem while calling the BPF program, which may sleep (calling
> bpf_d_path).

That part is clear. I had to look into mmap_read_lock_killable() implementation
to realize that it's checking for lock_is_contended after acquiring
and releasing
if there is a contention. So it's the same behavior at the end.
