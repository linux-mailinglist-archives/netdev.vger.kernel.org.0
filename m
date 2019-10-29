Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EC4EDE89B2
	for <lists+netdev@lfdr.de>; Tue, 29 Oct 2019 14:39:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388520AbfJ2NjT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Oct 2019 09:39:19 -0400
Received: from mail-lj1-f193.google.com ([209.85.208.193]:45571 "EHLO
        mail-lj1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388274AbfJ2NjT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Oct 2019 09:39:19 -0400
Received: by mail-lj1-f193.google.com with SMTP id q64so15270940ljb.12;
        Tue, 29 Oct 2019 06:39:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=laTNHgj4HpbBRBIsBqfezJevLx13witg271INBvhRno=;
        b=qeAPoavZLIvEkTS86AJxk5MvvNogwBfsbb1MfWfQ5fZGEGU17GzR3DspvoQewCDe0b
         OiKx9ne54vTO1iRszcrW7zzD3H/fM0KGPpeWELb3Ix73tKGwYz+eqnfSUC8Yp0yl1PWg
         DzSi6ahQBP2F/t+rcwQnHXwGTgaNuDmJYJgNaaFBr/UzL+bQ3TsctDTpVR70c6QAvVvw
         86VatX2xkljXRX1SgIAsrA5xLEG6df3VPTyOZMXGRnOPJ1PfAXlXZHUWfUJft7K7Ffjj
         Q98kCDvlvwQx8+QaDBjCWbAVv4IrNkdz5U8ILnWbkJO7/3g+riZGDxEx1TNX4J10WKRO
         K2Ug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=laTNHgj4HpbBRBIsBqfezJevLx13witg271INBvhRno=;
        b=kgoQ8KpXtudtNRtjsBSsENPdL5O14QeP2p0+Tqee9+cLeobykL+/kaUteOKnr9VwyY
         q+728Z++F8XOG9C+zWmwEbXFeHQ/IkQwk52QWp6o63olDqliphxC1KZqQv8UEwgbchx8
         acbYJPHW2eR+bsC+3+wFHRU4VgaG0X8VywxAHPHb3yYdR6RmyZ/On9ExNAAUmTKALXeE
         ZOK6otk4ULqJr34EeJXyg/N+GFnZK8+3+kkOhim0zYT7rhOx26i3pCkAWpjoOkmYEIKL
         Eamph8e6erLSacObQbwYW4jsco7LkeN8PmT+PNdCfifw20QFEFlpmWUAFSNz0IyMcrpJ
         po8g==
X-Gm-Message-State: APjAAAWrikKzMIgqQl0wut2Y8D45GnUBbtsSgAU4d091UzHKlnyijp3P
        UC9lqm9qRQAWHnrhEn82ricaH5aBIObhfn6mHQI=
X-Google-Smtp-Source: APXvYqyfmgXX2CB5tqiSB9rb2n6+UVUXdcxQ1r2Pnj9E01O3EqUFsEP6s2TwxzNWQ/fumRPzJ7mbHsNHRErefgvsvwc=
X-Received: by 2002:a2e:85c2:: with SMTP id h2mr2732886ljj.188.1572356356116;
 Tue, 29 Oct 2019 06:39:16 -0700 (PDT)
MIME-Version: 1.0
References: <20191029055953.2461336-1-andriin@fb.com>
In-Reply-To: <20191029055953.2461336-1-andriin@fb.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Tue, 29 Oct 2019 06:39:03 -0700
Message-ID: <CAADnVQJ_ebZ76D7WP_X-W3q2DgqWXmxmrwZVBQ2RceSnn-n_AA@mail.gmail.com>
Subject: Re: [PATCH bpf-next] libbpf: don't use kernel-side u32 type in xsk.c
To:     Andrii Nakryiko <andriin@fb.com>
Cc:     bpf <bpf@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Kernel Team <kernel-team@fb.com>,
        Magnus Karlsson <magnus.karlsson@intel.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Oct 29, 2019 at 12:26 AM Andrii Nakryiko <andriin@fb.com> wrote:
>
> u32 is a kernel-side typedef. User-space library is supposed to use __u32.
> This breaks Github's projection of libbpf. Do u32 -> __u32 fix.
>
> Fixes: 94ff9ebb49a5 ("libbpf: Fix compatibility for kernels without need_wakeup")
> Cc: Magnus Karlsson <magnus.karlsson@intel.com>
> Signed-off-by: Andrii Nakryiko <andriin@fb.com>

Applied. Thanks
