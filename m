Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 25FAF136E02
	for <lists+netdev@lfdr.de>; Fri, 10 Jan 2020 14:27:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728000AbgAJN1c (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Jan 2020 08:27:32 -0500
Received: from mail-oi1-f172.google.com ([209.85.167.172]:33688 "EHLO
        mail-oi1-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727501AbgAJN1b (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Jan 2020 08:27:31 -0500
Received: by mail-oi1-f172.google.com with SMTP id v140so1851857oie.0
        for <netdev@vger.kernel.org>; Fri, 10 Jan 2020 05:27:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=AUwd8glpr6kfXtb89k6x9PBA9ykDSCHrcjOXwyj5hTA=;
        b=Ua35ReYLIwp5dAjcfnRe5d717jLPnKQgnOXgwoQa55EKXMOyC62yk19zvYaYTRpOk9
         W3EkIJ8KAInm0Gi/SBabPmttucc5vhWdBkJCWmCCM2YFIRGDXIl0x1owC9dTR7zBbJaV
         WWz4MAs/RlsTY82k3bvZe1mgkRTBbDbwbYdhg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=AUwd8glpr6kfXtb89k6x9PBA9ykDSCHrcjOXwyj5hTA=;
        b=kheUliBSv/YUJ+dXUtM+tzuMrlYf2QCFKZDUmbcF6+fPim+tTnJaoBVRApacIKsQR/
         4mFGYpjq/JmETcJJ+1L+WP53aE0Q8v0DWpd7+PqrkEKrnqE8FFVGT0ARx5p7SDBsIXh7
         54BvYRbRnKjZR6FU2p95/BgVbLhnXGQX4kCVvx9vb1i/x25JAq46URk3UXmVk99rQVaM
         Eu4qSMMuNBzQEgJRbp6KXcSsTXah4yPX7X1LETHOWg0xvDhWk9eM3o1GHhAVDdSt6cRw
         BWyL5rDXhOSecXbfAGshf79MQXPqM/68WoFF8EYhyrpUmLd+KCK6yoQ1Wg7XSEE76fb7
         Z2DQ==
X-Gm-Message-State: APjAAAV+bHeESorOYOGZAJsFahY+9Sm7OiWD23rJLwPFab5IHhm848aS
        c16Xczwi5NekE4TNBfhoEAzx1WVdkALqddrmBdN5xQ==
X-Google-Smtp-Source: APXvYqxEQdRC03cg2f9SLLL9UIZBDwiOjLVn6ykjZjCp6YeJgL1s35yJA44vdEuwG59QZYLKKl73qp4FjS+FnaXcQI8=
X-Received: by 2002:aca:b60a:: with SMTP id g10mr2064783oif.102.1578662851371;
 Fri, 10 Jan 2020 05:27:31 -0800 (PST)
MIME-Version: 1.0
References: <20200109115749.12283-1-lmb@cloudflare.com> <20200109115749.12283-2-lmb@cloudflare.com>
 <20200109182335.um72tp73krvvubnl@kafai-mbp.dhcp.thefacebook.com>
In-Reply-To: <20200109182335.um72tp73krvvubnl@kafai-mbp.dhcp.thefacebook.com>
From:   Lorenz Bauer <lmb@cloudflare.com>
Date:   Fri, 10 Jan 2020 13:27:19 +0000
Message-ID: <CACAyw98A_Y1r0S9jDQds332whureyxRRZCDhFbXV6Bo9NsG4NQ@mail.gmail.com>
Subject: Re: [PATCH bpf 1/1] net: bpf: don't leak time wait and request sockets
To:     Martin Lau <kafai@fb.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "David S. Miller" <davem@davemloft.net>,
        Joe Stringer <joe@isovalent.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kernel-team@cloudflare.com" <kernel-team@cloudflare.com>,
        "edumazet@google.com" <edumazet@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 9 Jan 2020 at 18:23, Martin Lau <kafai@fb.com> wrote:
>
> Would this work too?
>         if (!sk_fullsock(sk) || !sock_flag(sk, SOCK_RCU_FREE))

Thank you for the suggestion, this makes the patch much nicer.

-- 
Lorenz Bauer  |  Systems Engineer
6th Floor, County Hall/The Riverside Building, SE1 7PB, UK

www.cloudflare.com
