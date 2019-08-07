Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EC40384459
	for <lists+netdev@lfdr.de>; Wed,  7 Aug 2019 08:16:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726700AbfHGGQP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Aug 2019 02:16:15 -0400
Received: from mail-ot1-f65.google.com ([209.85.210.65]:40527 "EHLO
        mail-ot1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726511AbfHGGQP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Aug 2019 02:16:15 -0400
Received: by mail-ot1-f65.google.com with SMTP id l15so42631219oth.7;
        Tue, 06 Aug 2019 23:16:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=tmoJaJ65N6RpIpl9wUDFwE5obm2EhyL0fgpevJUoxnA=;
        b=ILp8d7B1EqjLYt15yXuspNw5AZZfuLoKBpWjx7F5FNFJcjdDfddV+sgTR4hLoX31+h
         xWXIzY/ggOcGw6p+RNGJGlFg4uKvzfz9z1U6nkfKvzdMKX46YkDRnFutAVgVjwn41b4T
         3Nhu23c1Dzh+DODy1UzSiwGkDVZAvYNGTZIzaPb20iA0iCeTxx+mi8/t1jHrkmYAkUyq
         rCHYHpiMYNccOifzM33+wBvhgZOBzeU0VdnWJyx39yq8i4bKTt22wnods/za7ceKaxPk
         vqSXyfC7lGqqJfqtGm/zvYb8PkmEtUgHYAtkiaHeIDpmGYnaVJZZBIOPna1dGTCXtI75
         KkfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=tmoJaJ65N6RpIpl9wUDFwE5obm2EhyL0fgpevJUoxnA=;
        b=YAFFDXZ4BrT0j2LBBgPXqlWXLs1h481LLvgFyGULND1p2IAIPkjg4GKJOuCqO0rykk
         OzDNGZ6hXiz0NuUah9asg4IGjXU71ut1G20HLF40mUlNmK1CnrSKC+lb3DoTdwHIi2DP
         dIfLJZVOW11/Vg4NlzorELSUY66SqoWzGWgZvRXwoTSz5HxgmfK3XqJjK2IorzaZ8ggk
         /4tt4NsYVhOa8gsXdLtoXLZX6onvbGxSsGU3gvsHQ29b2ETc6PQZ9j0tLBgIrGdqBIIP
         7GlMN3nAbkqkDqnWVGjpMYLvBy9m4nIwm+vROk0IZbjEEHPkhyW8Q7a2jVuosJZRnlAz
         jR+g==
X-Gm-Message-State: APjAAAWWlFLz4P+2spH14KC2RHY6CiebVBHRabvrekKIGUxwr209iCgn
        fQYnwSa6zsAyasR37PprNBqtbKQeghnVQX5pruxwB60zoNs=
X-Google-Smtp-Source: APXvYqwYh4iB2zTaItbdFN+sl7QKIcL3y4tLx3w8RJWlMFbKicsVZTFHbCpaA00EkTuky+/zdO/sDYpSrmbeCBacfT8=
X-Received: by 2002:a02:c80d:: with SMTP id p13mr8547369jao.59.1565158574399;
 Tue, 06 Aug 2019 23:16:14 -0700 (PDT)
MIME-Version: 1.0
References: <20190807001923.19483-1-jakub.kicinski@netronome.com>
In-Reply-To: <20190807001923.19483-1-jakub.kicinski@netronome.com>
From:   Y Song <ys114321@gmail.com>
Date:   Tue, 6 Aug 2019 23:15:38 -0700
Message-ID: <CAH3MdRUxrZvTr-fBumsb0UhRkYq+9emig4+Ewpse7JsgQz99LA@mail.gmail.com>
Subject: Re: [PATCH bpf 0/2] tools: bpftool: fix pinning error messages
To:     Jakub Kicinski <jakub.kicinski@netronome.com>
Cc:     Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        netdev <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        oss-drivers@netronome.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Aug 6, 2019 at 5:20 PM Jakub Kicinski
<jakub.kicinski@netronome.com> wrote:
>
> Hi!
>
> First make sure we don't use "prog" in error messages because
> the pinning operation could be performed on a map. Second add
> back missing error message if pin syscall failed.
>
> Jakub Kicinski (2):
>   tools: bpftool: fix error message (prog -> object)
>   tools: bpftool: add error message on pin failure

Looks good to me. Ack the whole series.
Acked-by: Yonghong Song <yhs@fb.com>

>
>  tools/bpf/bpftool/common.c | 8 ++++++--
>  1 file changed, 6 insertions(+), 2 deletions(-)
>
> --
> 2.21.0
>
