Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3F9BB199C9F
	for <lists+netdev@lfdr.de>; Tue, 31 Mar 2020 19:12:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731340AbgCaRMA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 Mar 2020 13:12:00 -0400
Received: from mail-lf1-f66.google.com ([209.85.167.66]:45963 "EHLO
        mail-lf1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730216AbgCaRMA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 31 Mar 2020 13:12:00 -0400
Received: by mail-lf1-f66.google.com with SMTP id v4so17924400lfo.12;
        Tue, 31 Mar 2020 10:11:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=yY5RRGPBaqPjaTh5HbCix++s/DCYJl1Ahq3rcY5LSWA=;
        b=LBI5zgMsOXUucGoWIJQEXDWajY51c0FHDhqbX6KhhnHDjY4w5vcY4P10QV4PYKcse6
         H0fD+o+OkQBFTIUqoejcH3Imyn0f+mp6fXXZ77wYzsiTZWm+X335OPlNFNKXYHy/A8z8
         4Rn/aZ6xUmNQ4b1RsFjVLkNALI70rNDL0lLTrnqwXqPU5r9gmYwRgzEzMuSEAJBBuRa6
         CWMzVFv4qwXWPDtdD29/5EhjinozSCD18n3v1eF/zomqe+EsPzwun3ktyDII0TJXhBG2
         HMmtyu7J5h+wIC/luMdHiqqAFlbzQf5lxq1HPu4SyIwDs97wPp3wkYxFvw7cmJcH8pja
         7PeQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=yY5RRGPBaqPjaTh5HbCix++s/DCYJl1Ahq3rcY5LSWA=;
        b=QzrHton7+OMSeYYdcVT7ovn1fWfANuI5SaqlJloM2PNfP/U5/GInqxo6lTxXyahpuw
         kaRh1UxZBPcmFeosjxzrS4XAlkkD/ypx5wwt13YzoYu3+9/VhXSsc9bV/tnAuszlsKTR
         vucbjZzsx/2BKZlW7D8blCiRTylalVxpri/CQ2CnJEjOhr/ITCkEmqn3IZI+o/+xT7fo
         PynDuWu+MxiTT37xplASYE8oPkMBJ00EM/EAKmE7rRu6A0iG4Gr8EdhUxuYvqRGoCOmZ
         e76tnfyrN0CjwKbRntPRhcGcGH0PM+WfN6Esa1piSKtdN/0pz5zrzPIguHmZo+f+bZNR
         vQCw==
X-Gm-Message-State: AGi0PuaMMY9NW4CCZ0yOjwTEMx/jcSRQQugsPLAVkyaraMnaD39dHoCx
        IyHJuaBwnE3atW63viyBbUCdmeoyE7vKpZOBAB0=
X-Google-Smtp-Source: APiQypJHj9hQ/coAcBI0NhjhR53Eg1cuQsMA+TQumqHzNcKi1EcmoyEgLzQ1XRAkVR0jcdzKTchRsTcNBbGJ73ngXyM=
X-Received: by 2002:ac2:5de7:: with SMTP id z7mr12016287lfq.174.1585674715756;
 Tue, 31 Mar 2020 10:11:55 -0700 (PDT)
MIME-Version: 1.0
References: <20200330030001.2312810-1-andriin@fb.com> <c9f52288-5ea8-a117-8a67-84ba48374d3a@gmail.com>
 <CAEf4BzZpCOCi1QfL0peBRjAOkXRwGEi_DAW4z34Mf3Tv_sbRFw@mail.gmail.com>
 <662788f9-0a53-72d4-2675-daec893b5b81@gmail.com> <CAADnVQK8oMZehQVt34=5zgN12VBc2940AWJJK2Ft0cbOi1jDhQ@mail.gmail.com>
 <cdd576be-8075-13a7-98ee-9bc9355a2437@gmail.com> <20200331003222.gdc2qb5rmopphdxl@ast-mbp>
 <58cea4c7-e832-2632-7f69-5502b06310b2@gmail.com> <CAEf4BzZSCdtSRw9mj2W5Vv3C-G6iZdMJsZ8WGon11mN3oBiguQ@mail.gmail.com>
 <61442da0-6162-b786-7917-67e6fcb74ce8@gmail.com>
In-Reply-To: <61442da0-6162-b786-7917-67e6fcb74ce8@gmail.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Tue, 31 Mar 2020 10:11:43 -0700
Message-ID: <CAADnVQL1LdvJWi3RvBxVH=_yn1RpY-Ob+VOFQ+fOz7zZrEfopg@mail.gmail.com>
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

On Tue, Mar 31, 2020 at 9:54 AM David Ahern <dsahern@gmail.com> wrote:
>
> On 3/30/20 9:54 PM, Andrii Nakryiko wrote:
> >
> >    [0] https://gist.github.com/anakryiko/562dff8e39c619a5ee247bb55aa057c7
>
> #!/usr/bin/env drgn
>
> where do I find drgn? Google search is not turning up anything relevant.

It's the link I mentioned in this thread just few emails ago:
"Also there is Documentation/bpf/drgn.rst"
