Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B75FC198798
	for <lists+netdev@lfdr.de>; Tue, 31 Mar 2020 00:50:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729129AbgC3Wuk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Mar 2020 18:50:40 -0400
Received: from mail-lf1-f68.google.com ([209.85.167.68]:39978 "EHLO
        mail-lf1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728876AbgC3Wuk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Mar 2020 18:50:40 -0400
Received: by mail-lf1-f68.google.com with SMTP id j17so15632683lfe.7;
        Mon, 30 Mar 2020 15:50:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=sPkC0XX2iBY0yYjGTnxVOP9pK5BC05S2dgxzKmJdJTo=;
        b=pXuibOOfcPQhiq1oPWkObgd3ZMnVXAQW8uQSnrPw/JWoHBlyBLNDK6gaXLx30b708/
         cfC3n8Oda3JFxmGQZTecF3aawPmu41X85VwPl0KlzOv8x8/acv6ShqnhlFsaVVprGdWl
         4VD5YXEwqzJdokpg/gVbawTJxuINwLgu8/tTRqGjBqNbj5gSSZ2FSq00S4lf8SnvCKJ7
         n3OGtaczbWFBg5+5AuhmlosmRf2JWpL+Ul4did/NMA547Zvcel78l9V6m2DhW9WsQg9D
         5KHThkZ37OUJmwBiCzMXHvtA+7Qh3S1RWB77kRx2/1+gr5PZ2Y8iJkSoBnfn7/CJivr3
         upwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=sPkC0XX2iBY0yYjGTnxVOP9pK5BC05S2dgxzKmJdJTo=;
        b=DzOfMsq87l28Xj5nhoUtNYIwZwf0L0dcMOpF8XmdrjyHFmnkNpvnk5i5nNbn5seacl
         VgLLv23R4tZqevRHAOcSZiNfYBfeeQDeq7wU5LV2QjfUnvQk5Acuj+MA/+3gyY0/oorm
         QD+APhIKHWQmPh09ZOMV52G8SHljKdk53vU4azZIL7mp33HrkBUopDBvJwUAMbIzavAD
         M+Jt4h7NsRC8O3BrhFZCcOgZ46DUIo1ak3oupOxR821zorXFkop7hmVW5C20hU2MJuw7
         PfmtiLW4UQeF2PwCQh0/C6A/KICaMIFSvFFRe+TsVH1bLCK+XWDHIz6llEBfGIU5wXex
         bhpw==
X-Gm-Message-State: AGi0PuZwvqWexOEMF6KQSCShV3IcEN+KT5c+tEHtQo0M9+ASZE6Psnvl
        FObSijlEjuI2kO5MDHtcW+fPSGgQQ4x+fLocoFo=
X-Google-Smtp-Source: APiQypKxUPGWoBW3ts7L57YJ6uczfJxRayL8vb/b8LSxkZUaCAugjMtkhd1CegqX9+BxTWZHzjE0lTJr3FBF3lGbolQ=
X-Received: by 2002:ac2:418b:: with SMTP id z11mr9432593lfh.134.1585608635677;
 Mon, 30 Mar 2020 15:50:35 -0700 (PDT)
MIME-Version: 1.0
References: <20200330030001.2312810-1-andriin@fb.com> <c9f52288-5ea8-a117-8a67-84ba48374d3a@gmail.com>
 <CAEf4BzZpCOCi1QfL0peBRjAOkXRwGEi_DAW4z34Mf3Tv_sbRFw@mail.gmail.com> <662788f9-0a53-72d4-2675-daec893b5b81@gmail.com>
In-Reply-To: <662788f9-0a53-72d4-2675-daec893b5b81@gmail.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Mon, 30 Mar 2020 15:50:24 -0700
Message-ID: <CAADnVQK8oMZehQVt34=5zgN12VBc2940AWJJK2Ft0cbOi1jDhQ@mail.gmail.com>
Subject: Re: [PATCH v3 bpf-next 0/4] Add support for cgroup bpf_link
To:     David Ahern <dsahern@gmail.com>
Cc:     Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Andrii Nakryiko <andriin@fb.com>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrey Ignatov <rdna@fb.com>, Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Mar 30, 2020 at 1:46 PM David Ahern <dsahern@gmail.com> wrote:
> release. As it stands it is a half-baked feature.

speaking of half-baked.
I think as it stands (even without link_query) it's already extremely
useful addition and doesn't take anything away from existing cgroup-bpf
and doesn't hinder observability. 'bpftool cgroup' works just fine.
So I've applied the set.

Even if it was half-baked it would still be applie-able.
Many features are developed over the course of multiple
kernel releases. Example: your nexthops, mptcp, bpf-lsm.
