Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 044E91962A5
	for <lists+netdev@lfdr.de>; Sat, 28 Mar 2020 01:41:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727026AbgC1Alq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Mar 2020 20:41:46 -0400
Received: from mail-qv1-f68.google.com ([209.85.219.68]:45046 "EHLO
        mail-qv1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726225AbgC1Alq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Mar 2020 20:41:46 -0400
Received: by mail-qv1-f68.google.com with SMTP id ef12so3830224qvb.11;
        Fri, 27 Mar 2020 17:41:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=hrLvmijGpNOcwCRJI0CRFmncxEONHTsSBYmIlT7k45s=;
        b=kusI9nyYDUysLuYjjEVco0m+cdAPRoLi/A0HVEqL1GjcyUbDL6rjLGF+L9ufqwh59+
         Iw9ld3ZzEhwNtUuZrkb9Zqi0UZtJxTh5Il9ZSiwqY9sozdP8C0SHJ6Crve7UoipS+v3H
         QCHkCMlnsPH/42qZ1Ov6bQvcOwQKZBjfBf0LwUtBX0V+z9KsS7ARcD/ELk9lJShzKIGN
         b0QHSyfTpmwR3A1mC2HF6Ihe8mso1v+x8OAGHOultZPtZv3tFxlBRXXz2WmzlekdcJck
         xhftY5x6+77lu8Qr/bXsdYq5plV8GqGGlt1CWnP6UoJtRX2Br4svhD6nvahyTNAiUIV4
         fp1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=hrLvmijGpNOcwCRJI0CRFmncxEONHTsSBYmIlT7k45s=;
        b=AI2/tIK0uRTUDixhCVuzmuuJW/v/Y99CfIuyn2gHvbGUF0jyg2GpjUcPWVlhJeTBMo
         8Sm0rVkvDyX/KWlOqRJQ5Vo+M0uIbq4+KH0a4+oioZnILaXzL/0AVlfZXbszdrYKhgiv
         0V0rWfvrozl0GXPMZltTVZF+r6vogBeYX45KGQxje6jotsb0v/teJBbSLj2i+/IR17ez
         Qn0kUeGCquy+e2d0CCQcT/ua2uHDncbv1VQzHdpx/U4R7SzBoDDzBfQ7+inYlYzVglTh
         Z2YE07STXf5put5RCLMqt3xuM9DqveJix7uZgFuH78SLlajkwEMlLPljoJjaN4g6vC5D
         RzkQ==
X-Gm-Message-State: ANhLgQ0D0RggXHWR6eTtvabPY+W9gO1ygJcrD0NotkC4pRYUxMPdwY5M
        DRlu2m857XIla+KsD127LUpptZn7psi3FwF6bFk=
X-Google-Smtp-Source: ADFU+vswRLpJyHsOXP4Pdodw1Twvgz9gd/IO6zvEPwuAWsAs4/JoTj+TMVd/Ko7rmQrSlWV5TE9sh3B/JSQkljjat34=
X-Received: by 2002:a0c:8525:: with SMTP id n34mr1957780qva.224.1585356105512;
 Fri, 27 Mar 2020 17:41:45 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1585323121.git.daniel@iogearbox.net> <555e1c69db7376c0947007b4951c260e1074efc3.1585323121.git.daniel@iogearbox.net>
In-Reply-To: <555e1c69db7376c0947007b4951c260e1074efc3.1585323121.git.daniel@iogearbox.net>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Fri, 27 Mar 2020 17:41:34 -0700
Message-ID: <CAEf4BzY5dd-wXbLziCQJOgikY-qvD+GQC=9HHZGCqmM_R-2mJA@mail.gmail.com>
Subject: Re: [PATCH bpf-next 4/7] bpf: allow to retrieve cgroup v1 classid
 from v2 hooks
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Martynas Pumputis <m@lambda.lt>,
        Joe Stringer <joe@wand.net.nz>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Mar 27, 2020 at 9:00 AM Daniel Borkmann <daniel@iogearbox.net> wrote:
>
> Today, Kubernetes is still operating on cgroups v1, however, it is
> possible to retrieve the task's classid based on 'current' out of
> connect(), sendmsg(), recvmsg() and bind-related hooks for orchestrators
> which attach to the root cgroup v2 hook in a mixed env like in case
> of Cilium, for example, in order to then correlate certain pod traffic
> and use it as part of the key for BPF map lookups.
>

Have you tried getting this classid directly from task_struct in your
BPF program with vmlinux.h and CO-RE? Seems like it should be pretty
straightforward and not requiring a special BPF handler just for that?

> Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
> ---
>  include/net/cls_cgroup.h |  7 ++++++-
>  net/core/filter.c        | 21 +++++++++++++++++++++
>  2 files changed, 27 insertions(+), 1 deletion(-)
>

[...]
