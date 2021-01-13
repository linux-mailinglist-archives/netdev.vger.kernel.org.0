Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 464292F412F
	for <lists+netdev@lfdr.de>; Wed, 13 Jan 2021 02:29:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727131AbhAMB3F (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Jan 2021 20:29:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38644 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726945AbhAMB3C (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Jan 2021 20:29:02 -0500
Received: from mail-lf1-x12d.google.com (mail-lf1-x12d.google.com [IPv6:2a00:1450:4864:20::12d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 365BBC061575;
        Tue, 12 Jan 2021 17:28:22 -0800 (PST)
Received: by mail-lf1-x12d.google.com with SMTP id 23so317876lfg.10;
        Tue, 12 Jan 2021 17:28:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=/gnIe5vrh3z2zk/rBgVHipnsDtqZSPnamylj09vkYEM=;
        b=QvXhyw9Yd2xUmidy2NlqeifSMU3WS0JHgzg46ipitOFI3gQNtZT6l6uP7C6dXEvfxj
         HaYE/Ou0SOqE8v8XldzMBG8ucIxI/IXhsxjMPw/C8NwKOMPnv5a59Eq0YpCKMxMH0QFb
         tUkIEPaJy2Mvmc93w/lj+j0c0vR8ItGxwAIKD8rVwEs21I3J0jktNeiRWaBEndr7yvB0
         ncXOxcb6KF/6I1SQQsGXdl6zEZItAkbEiNeOyjYWJvbfN+tsE3lFbVFL8h0WfRnRcFjP
         JBm3PMcb91N/DSzjQ7bp2jkO5q0AlbTglMu9y2tb+EzN/d8A/j9HL2j3voc5mAWucbwk
         Hvzw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=/gnIe5vrh3z2zk/rBgVHipnsDtqZSPnamylj09vkYEM=;
        b=K+0lJJaCmpWD/TqeU5s8is3KoHzje2pi6Gm1ir161Sp47KH6R5MMWvE60z1J/9w8EW
         fvzYztHlLuVzUNRwlJocsR+utFT3zSk8m9t4OI7tIi3nyR9Us2BSg9DFO8k5EjS1P0gD
         ZecJbUikC92UfNMtgGMUXGQ2ZSeQNJ2qEVckiZLbRdrRBKf/MjCT7DR+NmfKVm+Z59xE
         WuAR/+tScfCPTj6adlWaMpxkvsAvKg62lsHkuoNc43hq+oByKxqsw6amtKMVT5GQmU2Z
         /+mKUyCu1bfpJ99IuktwaC2hV1WTObf81nWJnLYXdvQ/cVAam3chx9IUTj4yYYId0570
         RmJA==
X-Gm-Message-State: AOAM531oKVMvoNM8hlwwAxwKnzBVRH7uE6T3+gt9htDTaU3/g0ab4Td5
        MUGPuvPtzNeuU02AztOOYEje/+A06GyGj3D4kGs=
X-Google-Smtp-Source: ABdhPJzvqKJpVYHV7agDJmwMKQQC0YJYKuNh8aDJ5ef/59QiFGopb1H+9dlS5Qpr/HgwrI41rIBGBthapLBrtY5+gb0=
X-Received: by 2002:a19:8b83:: with SMTP id n125mr763690lfd.75.1610501300454;
 Tue, 12 Jan 2021 17:28:20 -0800 (PST)
MIME-Version: 1.0
References: <cba44439b801e5ddc1170e5be787f4dc93a2d7f9.1610406333.git.daniel@iogearbox.net>
In-Reply-To: <cba44439b801e5ddc1170e5be787f4dc93a2d7f9.1610406333.git.daniel@iogearbox.net>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Tue, 12 Jan 2021 17:28:09 -0800
Message-ID: <CAADnVQK0iK6maUGtz1xnJcboHO=h-W4YU5CG_Mi+HYqG8XB_1w@mail.gmail.com>
Subject: Re: [PATCH bpf-next v2 1/2] bpf: allow to retrieve sol_socket opts
 from sock_addr progs
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     Alexei Starovoitov <ast@kernel.org>, Yonghong Song <yhs@fb.com>,
        bpf <bpf@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jan 11, 2021 at 3:09 PM Daniel Borkmann <daniel@iogearbox.net> wrote:
>
> The _bpf_setsockopt() is able to set some of the SOL_SOCKET level options,
> however, _bpf_getsockopt() has little support to actually retrieve them.
> This small patch adds few misc options such as SO_MARK, SO_PRIORITY and
> SO_BINDTOIFINDEX. For the latter getter and setter are added. The mark and
> priority in particular allow to retrieve the options from BPF cgroup hooks
> to then implement custom behavior / settings on the syscall hooks compared
> to other sockets that stick to the defaults, for example.
>
> Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
> Acked-by: Yonghong Song <yhs@fb.com>

Applied.
