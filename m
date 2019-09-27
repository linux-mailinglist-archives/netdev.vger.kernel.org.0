Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7E515C0B7F
	for <lists+netdev@lfdr.de>; Fri, 27 Sep 2019 20:44:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728407AbfI0SoS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Sep 2019 14:44:18 -0400
Received: from mail-qt1-f196.google.com ([209.85.160.196]:45577 "EHLO
        mail-qt1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728321AbfI0SoR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Sep 2019 14:44:17 -0400
Received: by mail-qt1-f196.google.com with SMTP id c21so8469646qtj.12;
        Fri, 27 Sep 2019 11:44:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=2og6D8JNGUcFzo2+ZOKB4t8tH7Nwv5RRVJlFtszjd+8=;
        b=unbvXDxnpNpcf8CoeSiwRYEbaguyEnVe7BU2tnKz0HxgW0iup/mqrk+c66d6zG0Jr8
         II95/A/X4I8kXM+g/a8ggxkX7nJMkYT9ij5nqrQEk33ll61o9WeX7MnPz4Kh9FAP1U6w
         d4cy5S1hMCu9Oml+aTdAivYdpB0tnqVlqkjntzfd5AuoRtB/T5J74fjIz8gQHNVw+Y8P
         /h0qSEubAKZtbVGcTy0Eqh0ya8m/WJdKRJYNzfxH2Ya6/iXwevjmn+4XqWXBkUF+El7u
         0WnN6VOXJPuucvvX89TO9VbkZ/oaDGUVgBsmfQb2RLpW9tJEaaM0htpGrjmhR0I6pkZF
         0rWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=2og6D8JNGUcFzo2+ZOKB4t8tH7Nwv5RRVJlFtszjd+8=;
        b=VEi091ae405kHpUMK1amldLAYLRKLUpcTufMQQhAIp4+k+lGFDtWYRsLhIw2XkYLOy
         PD9x5Ga/P3wWuqMdkUNQVB+wU74NjuIuI5wkk4AXyf6nYpBg3bQ/FnmKYAdwEe7Sp8Bj
         y8QtaRTT0bQmpdoYZ0ztkoqoutHA78uffhfxolvq05z6/yDbcd8WLO4qLBneDxHaQ9PT
         ALaiZh6YuPmNeyDBsV1shp0xPPwUPTEZL460/22HvsKgipQ3NC1lheqLu79z1tDM0t1d
         Iwqbd091LVDRowhVjvU6VTwIw/hghA8SglbDGceDdD+0SoHDq8oalfsNXAgVQkg4nFKP
         jS7A==
X-Gm-Message-State: APjAAAV4V5nwtDlrh6vRuwKuRkGZ0XES0b0shoKxzNRfKfKB9QVJefBj
        CipZuqVThavSIr6VoCZG0GglD/VJdp5EJINQ/y8=
X-Google-Smtp-Source: APXvYqwAlwnd4veOBCqFHae+zgONBZFe8cp9ApiFkNKCb8JCy0Kv1XtjK2VEE2CERXOf4DuvZw71LzlZsjVhDobvMHg=
X-Received: by 2002:ac8:1099:: with SMTP id a25mr11275982qtj.308.1569609855302;
 Fri, 27 Sep 2019 11:44:15 -0700 (PDT)
MIME-Version: 1.0
References: <20190927011344.4695-1-skhan@linuxfoundation.org>
In-Reply-To: <20190927011344.4695-1-skhan@linuxfoundation.org>
From:   Song Liu <liu.song.a23@gmail.com>
Date:   Fri, 27 Sep 2019 11:44:04 -0700
Message-ID: <CAPhsuW5EncjNRGjt7F_BN2bNhRkf=uXVeDe6NCbJe=K2J+hdyA@mail.gmail.com>
Subject: Re: [PATCH] tools: bpf: Use !building_out_of_srctree to determine srctree
To:     Shuah Khan <skhan@linuxfoundation.org>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        linux-kselftest@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Sep 26, 2019 at 6:14 PM Shuah Khan <skhan@linuxfoundation.org> wrote:
>
> make TARGETS=bpf kselftest fails with:
>
> Makefile:127: tools/build/Makefile.include: No such file or directory
>
> When the bpf tool make is invoked from tools Makefile, srctree is
> cleared and the current logic check for srctree equals to empty
> string to determine srctree location from CURDIR.
>
> When the build in invoked from selftests/bpf Makefile, the srctree
> is set to "." and the same logic used for srctree equals to empty is
> needed to determine srctree.
>
> Check building_out_of_srctree undefined as the condition for both
> cases to fix "make TARGETS=bpf kselftest" build failure.
>
> Signed-off-by: Shuah Khan <skhan@linuxfoundation.org>

The fix looks reasonable. Thanks!

However, I am still seeing some failure:

make TARGETS=bpf kselftest
[...]
test_verifier.c
/data/users/songliubraving/kernel/linux-git/tools/testing/selftests/bpf/test_stub.o
/data/users/songliubraving/kernel/linux-git/tools/testing/selftests/bpf/libbpf.a
-lcap -lelf -lrt -lpthread -o
/data/users/songliubraving/kernel/linux-git/tools/testing/selftests/bpf/test_verifier
make[3]: test_verifier.c: Command not found

Is this just a problem with my setup?

Thanks,
Song
