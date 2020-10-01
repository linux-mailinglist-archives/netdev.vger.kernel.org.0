Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E072F27FE7B
	for <lists+netdev@lfdr.de>; Thu,  1 Oct 2020 13:34:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731839AbgJALeh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Oct 2020 07:34:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59252 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731243AbgJALeh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Oct 2020 07:34:37 -0400
Received: from mail-qk1-x741.google.com (mail-qk1-x741.google.com [IPv6:2607:f8b0:4864:20::741])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7443CC0613D0;
        Thu,  1 Oct 2020 04:34:37 -0700 (PDT)
Received: by mail-qk1-x741.google.com with SMTP id o5so4806068qke.12;
        Thu, 01 Oct 2020 04:34:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=eWf42gDunz8ZrbJJsjLaSFxrKzsO9JLaDRpK146NntU=;
        b=fhDnGMZLvPDKqI2zu+jzp3o3WiOwYCWIf48nl66PbEI6cLI8yr8A2APYf0VpLp9oMI
         F/6pSIrqzIddXmkX1qI+8SBmldLN2O85YCdFd2fu1dO8pbRSKho83ZJaARnQhboxLEZk
         JyOVaveHSRN+k5scKgBfq2Z5Q4uLHzbrC0zwod3SVBBMnqXwQeTly6/7+QZhy3IjZVjl
         KPLpUR3h4bu/WTUrrpdirK+uwwLfin7vcj6DMUXDjZxcDxB8CNN667EYkGnxFoT4jw1y
         +cRTo6439q5RNeRsRC4Ni25qfdOiKwwIkzLP/2WbjLw9Ar9vbyv8MyACoy0KCZyxzJNe
         GLSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=eWf42gDunz8ZrbJJsjLaSFxrKzsO9JLaDRpK146NntU=;
        b=HhEbEkpmHjZX9XO62PxPLizz/QR8I6pNzBB8H0Mz18yVuDTdvRHZwumuEuGBJqo5pD
         7KkU+FXpaHofgVcN4mtzWMkUHpLRpbCDgUlxkjlkBq6TNiG4Cv/iELXbgrJ5AkNOeKJI
         aVVuQiWlvJ8yPgsTGnJ8vKSCwh/Cw+4812lPqBroxBpcCRohgqzFgh4vGHZ9yqnenbrb
         YUuuTcjm56x+At3rLkocOvxZNLK8KfV1fMr7/QeSi+XDFtygBZSvr+cmlZU04jZrDc9j
         FGhMrgP1zjIFPo1KHJrPmbDgtwH/aecBNI7ABhVkro/PvEbfWCilFbUO5PrpTD/m6yj7
         QqSw==
X-Gm-Message-State: AOAM531E3hc/vFROXFfmqpkPKPzRllFNAxEMq5SGxUkXjA04+eDWRQAu
        1col6mZm5jQktog/J+0fneib+gzom50aYfF+U4I=
X-Google-Smtp-Source: ABdhPJy+BjvzZv06nMIu2x9g81kW+OJlA7shogMnOw+3PYeBroGr8l/KZTjVAQXxm1FPchQhP2aogyys742hXqfy+as=
X-Received: by 2002:a37:5cc2:: with SMTP id q185mr6605016qkb.35.1601552076714;
 Thu, 01 Oct 2020 04:34:36 -0700 (PDT)
MIME-Version: 1.0
References: <20200929031845.751054-1-liuhangbin@gmail.com> <CAEf4BzYKtPgSxKqduax1mW1WfVXKuCEpbGKRFvXv7yNUmUm_=A@mail.gmail.com>
 <20200929094232.GG2531@dhcp-12-153.nay.redhat.com> <CAEf4BzZy9=x0neCOdat-CWO4nM3QYgWOKaZpN31Ce5Uz9m_qfg@mail.gmail.com>
 <20200930023405.GH2531@dhcp-12-153.nay.redhat.com> <CAEf4BzYVVUq=eNwb4Z1JkVmRc4i+nxC4zWxbv2qGQAs-2cxkhw@mail.gmail.com>
In-Reply-To: <CAEf4BzYVVUq=eNwb4Z1JkVmRc4i+nxC4zWxbv2qGQAs-2cxkhw@mail.gmail.com>
From:   Hangbin Liu <liuhangbin@gmail.com>
Date:   Thu, 1 Oct 2020 19:34:25 +0800
Message-ID: <CAPwn2JT6KGPxKD0fGZLfR8EsRHhYcfbvCATWO9WsiH_wqhheFg@mail.gmail.com>
Subject: Re: [PATCH bpf-next] libbpf: export bpf_object__reuse_map() to libbpf api
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>,
        Jiri Benc <jbenc@redhat.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 1 Oct 2020 at 02:30, Andrii Nakryiko <andrii.nakryiko@gmail.com> wrote:
> > diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
> > index 32dc444224d8..5412aa7169db 100644
> > --- a/tools/lib/bpf/libbpf.c
> > +++ b/tools/lib/bpf/libbpf.c
> > @@ -4215,7 +4215,7 @@ bpf_object__create_maps(struct bpf_object *obj)
> >                 if (map->fd >= 0) {
> >                         pr_debug("map '%s': skipping creation (preset fd=%d)\n",
> >                                  map->name, map->fd);
> > -                       continue;
> > +                       goto check_pin_path;
> >                 }
> >
> >                 err = bpf_object__create_map(obj, map);
> > @@ -4258,6 +4258,7 @@ bpf_object__create_maps(struct bpf_object *obj)
> >                         map->init_slots_sz = 0;
> >                 }
> >
> > +check_pin_path:
> >                 if (map->pin_path && !map->pinned) {
> >                         err = bpf_map__pin(map, NULL);
> >                         if (err) {
> >
> >
> > Do you think if this change be better?
>
> Yes, of course. Just don't do it through use of goto. Guard map
> creation with that if instead.

Hi Andrii,

Looks I missed something, Would you like to explain why we should not use goto?
And for "guard map creation with the if", do you mean duplicate the
if (map->pin_path && !map->pinned) in if (map->fd >= 0)? like

diff --git a/src/libbpf.c b/src/libbpf.c
index 3df1f4d..705abcb 100644
--- a/src/libbpf.c
+++ b/src/libbpf.c
@@ -4215,6 +4215,15 @@ bpf_object__create_maps(struct bpf_object *obj)
                if (map->fd >= 0) {
                        pr_debug("map '%s': skipping creation (preset fd=%d)\n",
                                 map->name, map->fd);
+                       if (map->pin_path && !map->pinned) {
+                               err = bpf_map__pin(map, NULL);
+                               if (err) {
+                                       pr_warn("map '%s': failed to
auto-pin at '%s': %d\n",
+                                               map->name, map->pin_path, err);
+                                       zclose(map->fd);
+                                       goto err_out;
+                               }
+                       }
                        continue;
                }

(Sorry if the code format got corrupted as I replied in web gmail....)

Thanks
Hangbin
