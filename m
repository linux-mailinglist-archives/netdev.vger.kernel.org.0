Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6E6081CB700
	for <lists+netdev@lfdr.de>; Fri,  8 May 2020 20:21:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727071AbgEHSVB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 May 2020 14:21:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55890 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726817AbgEHSVA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 May 2020 14:21:00 -0400
Received: from mail-il1-x144.google.com (mail-il1-x144.google.com [IPv6:2607:f8b0:4864:20::144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B9055C061A0C;
        Fri,  8 May 2020 11:21:00 -0700 (PDT)
Received: by mail-il1-x144.google.com with SMTP id c18so2287884ile.5;
        Fri, 08 May 2020 11:21:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=kwhOhbAsGSmhYozVrBl52LciinlfrNJYa6IJuw+4SD8=;
        b=VvrnU1O22SM0lyDTY+iTSYD7wXS/9IpEaiQEj99Zk7PqOx32gJDlFKlwy8V6pGMw0N
         LEG2PWNSP/6dQhXgwk/251QeJch3IFaVNn/V+jU/QQtJYNpe7gHr5H9e96mR7B1r02KR
         c39P4Qo4fxoLTiDTdzWaCHsqiY1EczjGAU7mv3ROE+kQsEzTVIp9QpLzyIibL50qZMYw
         yWwo8eH8mmOGUK4QbrLFaG/1izPZ0LHRMUZCkCQ4bVjFgar+mpqblqZxOnGDt6+UOJe9
         2lJRc9hbmKAzV0zER3LQYgyf8b3kUhrdTwMcrpgoSe2fF2D7cJ1jkQq+R4Xvjn1KqaPV
         TMFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=kwhOhbAsGSmhYozVrBl52LciinlfrNJYa6IJuw+4SD8=;
        b=ppkecG40MAWl1RXMhF68UGpFJVMjVWylDc8moClM4+LfbtvWSTUbsMWQ5zJB0CTx54
         lmiG8xyvVevh3pMXesaDlgrjK4x2Dg5sndyN8ONgRzzLyviWqhnlukm95/TE32WWLU6R
         0M1eiJhEJoqbE4fyjE5RkJBN7E84nvIymHvs30RBCZsegikaPOd4jcunCtzQ14rBdYnU
         R39V7//Unph3YE8MiBW0PmBAq+7MeYOLwKa2ll0LHeNGOE4TMIqkzXx9/mbx9KF4i9hA
         P5EtWgl4la1F1kf/Se9055CEX9He0mHIRaHhY75aVjbJCxK78sqUAH/PFm9H7g9AvvOw
         oGFg==
X-Gm-Message-State: AGi0PuZ3cValLgYzwThGlUR3X3sDLRs6YmMEIzm8es3sFczA35Z/jDre
        rEp7ZsYcmNZn7pxAlFLMHk6xKXQ5Aa97/Tm8NO3Ps40r
X-Google-Smtp-Source: APiQypIC0FimbZ6kECFoZIMLun6V1vCDM+JhU2+RKYEUzcjynZSJTkk/Zos2jcopKv4OB9NNsqWaqLbAC3CpAo/2Fkw=
X-Received: by 2002:a92:4989:: with SMTP id k9mr4322734ilg.104.1588962060096;
 Fri, 08 May 2020 11:21:00 -0700 (PDT)
MIME-Version: 1.0
References: <20200507053915.1542140-1-yhs@fb.com> <20200507053916.1542319-1-yhs@fb.com>
In-Reply-To: <20200507053916.1542319-1-yhs@fb.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Fri, 8 May 2020 11:20:49 -0700
Message-ID: <CAEf4BzZzaQXx0EJODK5yiR1gi+iT8EJj+bOD6-=vj=6XUAtgDQ@mail.gmail.com>
Subject: Re: [PATCH bpf-next v3 02/21] bpf: allow loading of a bpf_iter program
To:     Yonghong Song <yhs@fb.com>
Cc:     Andrii Nakryiko <andriin@fb.com>, bpf <bpf@vger.kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, May 6, 2020 at 10:40 PM Yonghong Song <yhs@fb.com> wrote:
>
> A bpf_iter program is a tracing program with attach type
> BPF_TRACE_ITER. The load attribute
>   attach_btf_id
> is used by the verifier against a particular kernel function,
> which represents a target, e.g., __bpf_iter__bpf_map
> for target bpf_map which is implemented later.
>
> The program return value must be 0 or 1 for now.
>   0 : successful, except potential seq_file buffer overflow
>       which is handled by seq_file reader.
>   1 : request to restart the same object
>
> In the future, other return values may be used for filtering or
> teminating the iterator.
>
> Signed-off-by: Yonghong Song <yhs@fb.com>
> ---

Looks good.

Acked-by: Andrii Nakryiko <andriin@fb.com>


>  include/linux/bpf.h            |  3 +++
>  include/uapi/linux/bpf.h       |  1 +
>  kernel/bpf/bpf_iter.c          | 36 ++++++++++++++++++++++++++++++++++
>  kernel/bpf/verifier.c          | 21 ++++++++++++++++++++
>  tools/include/uapi/linux/bpf.h |  1 +
>  5 files changed, 62 insertions(+)
>

[...]
