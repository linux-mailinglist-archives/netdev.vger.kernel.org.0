Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EC21117940F
	for <lists+netdev@lfdr.de>; Wed,  4 Mar 2020 16:50:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729764AbgCDPue (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Mar 2020 10:50:34 -0500
Received: from mail-lf1-f67.google.com ([209.85.167.67]:33769 "EHLO
        mail-lf1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727084AbgCDPud (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Mar 2020 10:50:33 -0500
Received: by mail-lf1-f67.google.com with SMTP id c20so1932649lfb.0;
        Wed, 04 Mar 2020 07:50:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=OBYCuoBLY5+NeCQ8btRKM4ahbrPedZvSO1tq9tM4tMI=;
        b=qBANVzxV7w+ympSCrE8ndF4HV/U+X6xoOtxtX5Kpp2S3iVFZ8gdCTz09djhgwTPsrP
         zQXdfX3wfTor5S/4bMPHCh1yedh/f8mTd0Lyeb22b8g24KPgOJrLTny66PaCvAagPe4F
         dzYQmnwK9x6S3cIkoYCnEZm6WQOU75Ptk+1wij3ioRy0Xnj7jTnzu729OlOXv+c6idwM
         goWLigmMhLUHiKl0Shjs4zS+BxMdeOYFMrZ0uaBRfkpn2GBvoiVrb5DWIPOJsyVOnctP
         0EIXMb5rnM7c9r60UzSXarkuysEZhJnsSzshja3FHEeSgk8ibMf+cjJ4yfbM7V0sBiGz
         1ySw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=OBYCuoBLY5+NeCQ8btRKM4ahbrPedZvSO1tq9tM4tMI=;
        b=F71K6bQJjSDjLG3Zj2/l7B7IEI0ybobNCHkKIyP+xn014K4fJ6vKJGP9Iz9CUJ4yp+
         r9TwNGDQvsj655AYIfHUWwKpXEGLeCz0LIMCbLI855oWNzejptD11MHNDwELZ21tgNGd
         REYcKDJlxS4cfGTE6qXowYtRjU2tUeJE2AIPZ8QjabXHMk3McC2pLL0iUeP0K1f33g26
         68K9xuWQBmDB73bQV8R8el63m+MDmc2ptRiVhAURsTIdeSdBffPF08s2o+KmXZBU4xaL
         PhP/eFCCe85xJyhMx5IgwJ+UNpmnL3ZtmY1D/rKdiI3cx/+Hcx6cJRjSDz44K1oLXDhi
         i2NA==
X-Gm-Message-State: ANhLgQ0AiXdGa7UMECLkkDEFeH/un26+IpG+K2hYdI1uTXR8yzAe30IE
        gwM2warB1GDqSRVDI6Gq129rxuvi9mAOlqCI7GI=
X-Google-Smtp-Source: ADFU+vu/zmV33R5WG1qsWW282XglHRgxL9NLwFAJHp8D1eeHKQ6QQUMuGtgILE/tGz3x9BIqA70TXAYRp4aPNbDlK4U=
X-Received: by 2002:ac2:4211:: with SMTP id y17mr2340642lfh.157.1583337031447;
 Wed, 04 Mar 2020 07:50:31 -0800 (PST)
MIME-Version: 1.0
References: <20200303003233.3496043-1-andriin@fb.com> <20200303003233.3496043-2-andriin@fb.com>
 <fb80ddac-d104-d0b7-8bed-694d20b62d61@iogearbox.net> <CAEf4BzZWXRX_TrFSPb=ORcfun8B+GdGOAF6C29B-3xB=NaJO7A@mail.gmail.com>
 <87blpc4g14.fsf@toke.dk> <945cf1c4-78bb-8d3c-10e3-273d100ce41c@iogearbox.net>
In-Reply-To: <945cf1c4-78bb-8d3c-10e3-273d100ce41c@iogearbox.net>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Wed, 4 Mar 2020 07:50:20 -0800
Message-ID: <CAADnVQK4uJRNQzPChvQ==sL02nXHEELFJL_ehqYssuD_xeQx+A@mail.gmail.com>
Subject: Re: [PATCH v3 bpf-next 1/3] bpf: switch BPF UAPI #define constants
 used from BPF program side to enums
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Andrii Nakryiko <andriin@fb.com>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Kernel Team <kernel-team@fb.com>, Yonghong Song <yhs@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 4, 2020 at 7:39 AM Daniel Borkmann <daniel@iogearbox.net> wrote:
>
> I was about to push the series out, but agree that there may be a risk for #ifndefs
> in the BPF C code. If we want to be on safe side, #define FOO FOO would be needed.

There is really no risk.
Let's not be paranoid about it and uglify bpf.h for no reason.
