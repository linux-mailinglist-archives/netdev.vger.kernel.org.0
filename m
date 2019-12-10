Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5BCA6118E81
	for <lists+netdev@lfdr.de>; Tue, 10 Dec 2019 18:05:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727733AbfLJRFL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Dec 2019 12:05:11 -0500
Received: from mail-qt1-f193.google.com ([209.85.160.193]:38815 "EHLO
        mail-qt1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727505AbfLJRFL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Dec 2019 12:05:11 -0500
Received: by mail-qt1-f193.google.com with SMTP id z15so3422131qts.5;
        Tue, 10 Dec 2019 09:05:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=hq2orN4bzDs9BZngQDWA2aITI2xBOitIAgMk0BXVEwA=;
        b=WWXv43wIlp0HKLM3kWoMGnq9uaaEz9bhi+hGeEMPp3r2LKNQIzkMrNSibXD7krKKI+
         8rHdKjand3Ybvs06G269oQ9hvTGI0s7wge5KYo1rnKCnL2K8ZSQLODuBRjfEaOySKbkw
         P2XBgfUMaZp0A3828TLPirQbQUq9ymSa6KD/+2TvsZPF/h6GQPnQ1rzfJOovu6dT7yLV
         qpUxxJfsAHxC4h++amw5BIIClWAiixNa7pXpJh7GKA/DUDlK7o5TedCjvFo6CaocCRx2
         xXwbGKmoKvG7meIT+5699bmYGXF8lmNlsT4GQ6N/PRjBOKdGdcfaGRza7uSwJ9cm/7Gx
         MAZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=hq2orN4bzDs9BZngQDWA2aITI2xBOitIAgMk0BXVEwA=;
        b=uQapl5Pcvo5AwZerF1gidkkh378MCwXOT9RAaVB9PSfF5VQaBLHPIKaldch80QIK6s
         XXN8x82B/9CgeXlXyp20MkV96WWeP0zbB6gdK01ngFk8y3p3B+cYZU24NrkuzAUZNLAs
         OnkeocUhmHLiPyGpK9SjkoEwx2r/6dTfSAFByGEubmlUbS6m607SLXOH093d0YED8hMv
         uSr5rf+5bC+vzZDmoMUlAxRhBXojlz/qjjbvsFSS5IH9UudvVYQ0uwWCdY6C2jiLOohe
         yhl2FEXcAfCGHUabY/q5kkiM3so/pjinejTTCAsOv6WVGnGpBZ0hhyzZJy3G2H9M5no9
         UszA==
X-Gm-Message-State: APjAAAXFik/J+W7sRywfsrh9FN3TBbNxtP2KnmT3k2gy+xyjV1Hv3NWC
        K/VNuzPQlUWgE6XpCKdu+hYOVbiv0SK7EWFCo7o=
X-Google-Smtp-Source: APXvYqzSQflsEC0jC2jtW8BiBz9tYg4DZXsAOLjBW3t240EedldhaWO9bSdWgP2FXUgvyVENBRY01HqWEsutx435+y4=
X-Received: by 2002:ac8:5457:: with SMTP id d23mr29370437qtq.93.1575997509922;
 Tue, 10 Dec 2019 09:05:09 -0800 (PST)
MIME-Version: 1.0
References: <20191210011438.4182911-1-andriin@fb.com> <20191210011438.4182911-4-andriin@fb.com>
 <20191209173353.64aeef0a@cakuba.netronome.com>
In-Reply-To: <20191209173353.64aeef0a@cakuba.netronome.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Tue, 10 Dec 2019 09:04:58 -0800
Message-ID: <CAEf4BzbYvNJ0VV2jHLVK3jwk+_GvVhSWk_-YM2Twu5XkZduZVQ@mail.gmail.com>
Subject: Re: [PATCH bpf-next 03/15] libbpf: move non-public APIs from libbpf.h
 to libbpf_internal.h
To:     Jakub Kicinski <jakub.kicinski@netronome.com>
Cc:     Andrii Nakryiko <andriin@fb.com>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Dec 9, 2019 at 5:33 PM Jakub Kicinski
<jakub.kicinski@netronome.com> wrote:
>
> On Mon, 9 Dec 2019 17:14:26 -0800, Andrii Nakryiko wrote:
> > Few libbpf APIs are not public but currently exposed through libbpf.h to be
> > used by bpftool. Move them to libbpf_internal.h, where intent of being
> > non-stable and non-public is much more obvious.
> >
> > Signed-off-by: Andrii Nakryiko <andriin@fb.com>
> > ---
> >  tools/bpf/bpftool/net.c         |  1 +
> >  tools/lib/bpf/libbpf.h          | 17 -----------------
> >  tools/lib/bpf/libbpf_internal.h | 17 +++++++++++++++++
> >  3 files changed, 18 insertions(+), 17 deletions(-)
> >
> > diff --git a/tools/bpf/bpftool/net.c b/tools/bpf/bpftool/net.c
> > index 4f52d3151616..d93bee298e54 100644
> > --- a/tools/bpf/bpftool/net.c
> > +++ b/tools/bpf/bpftool/net.c
> > @@ -18,6 +18,7 @@
> >
> >  #include <bpf.h>
> >  #include <nlattr.h>
> > +#include "libbpf_internal.h"
> >  #include "main.h"
> >  #include "netlink_dumper.h"
>
> I thought this idea was unpopular when proposed?

There was a recent discussion about the need for unstable APIs to be
exposed to bpftool and we concluded that libbpf_internal.h is the most
appropriate place to do this.
