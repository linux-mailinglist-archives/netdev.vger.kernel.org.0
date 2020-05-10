Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AC52F1CCC2A
	for <lists+netdev@lfdr.de>; Sun, 10 May 2020 18:15:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729154AbgEJQPN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 10 May 2020 12:15:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58694 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728762AbgEJQPN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 10 May 2020 12:15:13 -0400
Received: from mail-lf1-x142.google.com (mail-lf1-x142.google.com [IPv6:2a00:1450:4864:20::142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA8FFC061A0C;
        Sun, 10 May 2020 09:15:12 -0700 (PDT)
Received: by mail-lf1-x142.google.com with SMTP id 188so5372476lfa.10;
        Sun, 10 May 2020 09:15:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=cj0uMGGwd/aWJgBMokAal66cvuwiS2g36X+NWguojiY=;
        b=Jlt5FkVzswaK4nE0BIJUqjEXdPhLaPJUgdGwQETpurC/Hwdg9AHJHmz6srE7pxssOc
         NbWw4pOYo/js5Te2N0lv4bJ1K1MWgN8EKX8X4jeGXrTuKg2+45/n2Dd3SLnWJxO1nA8g
         HQo2x3s2s8fpuXU3r6unls8MwQcOruG8XeS+vMfZSMl5H6ePnHhgsgY/K/dqM2hJ+d5I
         nLCEx6uMdIdZU9jxrH+6jyErJrC5OGogp1ykLm0DIp/MJN+Op/PWUFggC2ry1i+taEyg
         XYfVfV9phhdJVvYKTZvJL8NvJB8G3mtypdQ2nlRp04zUAxsBV4lS/14Mt8HP9OkPdBk9
         YJGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=cj0uMGGwd/aWJgBMokAal66cvuwiS2g36X+NWguojiY=;
        b=SpE+bUKYJCbQGpbkoQsaHWVGqiB0WUny9tJUwAMG2Dw5YAekdx/sGXKDJ8Nmx5hJFx
         ZQidqPXrhmFeLdXB4F8Yse0s4fbthYjQs1gWuMAk+D7jFQVOgnUo++YJ8PelxoQTHGP2
         SWw9M3AtWeSHsuBHcipE+/IlXibjlWl+jT4MnsMiObco5hBJtWsxepWB4873Ala7ymy7
         FUV+7hZ5EixeJLFkcrWf4safuViYWTBmimCY7mD6yytK0MeAFpMMmIyaQK80NhPxTpPX
         nlTtkiyObfeZ42WAntXVL5LKzrEw0fjqDbwJfYsubFUOyrJYNDgyVSdp0Ozt3+9toRdI
         ScTA==
X-Gm-Message-State: AOAM532feYuK38FtIoxTZjXk81vIKVpMsAJeHsQ8ozXCWZ9kN4btdsz5
        kv2E5NPyk5e5A3EDYGkMwhYNsS4J5Y+mgTUT1Ds=
X-Google-Smtp-Source: ABdhPJxD3btVu2OOBq0kZn2lxFPTk2vwYWgoa5FclsYSd09vt5Xzwx7dl3WUot4Ax6LXHA1zWgD7h0oyg97g+3dIkNk=
X-Received: by 2002:a19:cbd3:: with SMTP id b202mr8193938lfg.157.1589127311156;
 Sun, 10 May 2020 09:15:11 -0700 (PDT)
MIME-Version: 1.0
References: <20200509175859.2474608-1-yhs@fb.com> <20200509175923.2477637-1-yhs@fb.com>
 <20200510003402.3a4ozoynwm4mryi5@ast-mbp> <3b2b2e40-4e80-2a5d-e479-fc12a95162f2@fb.com>
In-Reply-To: <3b2b2e40-4e80-2a5d-e479-fc12a95162f2@fb.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Sun, 10 May 2020 09:14:59 -0700
Message-ID: <CAADnVQKtSV=yjV9UjHQ5SRmAx9LB+ma6AOJstyCuAFbU0j40QA@mail.gmail.com>
Subject: Re: [PATCH bpf-next v4 21/21] tools/bpf: selftests: add bpf_iter selftests
To:     Yonghong Song <yhs@fb.com>
Cc:     Andrii Nakryiko <andriin@fb.com>, bpf <bpf@vger.kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Network Development <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, May 9, 2020 at 10:01 PM Yonghong Song <yhs@fb.com> wrote:
>
>
>
> On 5/9/20 5:34 PM, Alexei Starovoitov wrote:
> > On Sat, May 09, 2020 at 10:59:23AM -0700, Yonghong Song wrote:
> >> +static volatile const __u32 ret1;
> >> +
> >> +SEC("iter/bpf_map")
> >> +int dump_bpf_map(struct bpf_iter__bpf_map *ctx)
> >> +{
> >> +    struct seq_file *seq = ctx->meta->seq;
> >> +    struct bpf_map *map = ctx->map;
> >> +    __u64 seq_num;
> >> +    int i, ret = 0;
> >> +
> >> +    if (map == (void *)0)
> >> +            return 0;
> >> +
> >> +    /* only dump map1_id and map2_id */
> >> +    if (map->id != map1_id && map->id != map2_id)
> >> +            return 0;
> >> +
> >> +    seq_num = ctx->meta->seq_num;
> >> +    if (map->id == map1_id) {
> >> +            map1_seqnum = seq_num;
> >> +            map1_accessed++;
> >> +    }
> >> +
> >> +    if (map->id == map2_id) {
> >> +            if (map2_accessed == 0) {
> >> +                    map2_seqnum1 = seq_num;
> >> +                    if (ret1)
> >> +                            ret = 1;
> >> +            } else {
> >> +                    map2_seqnum2 = seq_num;
> >> +            }
> >> +            map2_accessed++;
> >> +    }
> >> +
> >> +    /* fill seq_file buffer */
> >> +    for (i = 0; i < print_len; i++)
> >> +            bpf_seq_write(seq, &seq_num, sizeof(seq_num));
> >> +
> >> +    return ret;
> >> +}
> >
> > I couldn't find where 'return 1' behavior is documented clearly.
>
> It is in the commit comments:
>
> commit 15d83c4d7cef5c067a8b075ce59e97df4f60706e
> Author: Yonghong Song <yhs@fb.com>
> Date:   Sat May 9 10:59:00 2020 -0700
>
>      bpf: Allow loading of a bpf_iter program
> ...
>      The program return value must be 0 or 1 for now.
>        0 : successful, except potential seq_file buffer overflow
>            which is handled by seq_file reader.
>        1 : request to restart the same object
>
> Internally, bpf program returning 1 will translate
> show() return -EAGAIN and this error code will
> return to user space.
>
> I will add some comments in the code to
> document this behavior.
>
> > I think it's a workaround for overflow.
>
> This can be used for overflow but overflow already been taken
> care of by bpf_seq_read(). This is mostly used for other use
> cases:
>     - currently under RT-linux, bpf_seq_printf() may return
>       -EBUSY. In this case, bpf program itself can request
>       retrying the same object.
>     - for other conditions where bpf program itself wants
>       to retry the same object. For example, hash table full,
>       the bpf progam can return 1, in which case, user space
>       read() will receive -EAGAIN and may check and make room
>       for hash table and then read() again.
>
> > When bpf prog detects overflow it can request replay of the element?
>
> It can. But it can return 0 too since bpf_seq_read() handles
> this transparently.
>
> > What if it keeps returning 1 ? read() will never finish?
>
> The read() will finish and return -EAGAIN to user space.
> It is up to user space to decide whether to call read()
> again or not.

Ahh. Got it. So that EAGAIN returned by bpf_iter_run_prog()
propagates by bpf_seq_read() all the way to read() syscall.
Now I see it. Thanks for explaining.
