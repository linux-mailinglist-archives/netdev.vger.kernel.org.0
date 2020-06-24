Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 60EDA207B7D
	for <lists+netdev@lfdr.de>; Wed, 24 Jun 2020 20:26:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405961AbgFXS0p (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Jun 2020 14:26:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59302 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2404995AbgFXS0p (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Jun 2020 14:26:45 -0400
Received: from mail-qk1-x744.google.com (mail-qk1-x744.google.com [IPv6:2607:f8b0:4864:20::744])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E61EC061573;
        Wed, 24 Jun 2020 11:26:45 -0700 (PDT)
Received: by mail-qk1-x744.google.com with SMTP id q198so2780962qka.2;
        Wed, 24 Jun 2020 11:26:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=0656yG2r9Ums4nGOghSQqH0qThSj3hBocwJfZfFJF1o=;
        b=rV2CPu81WNoz8NMjP8lK8gzG5vduZEbY31yPYXU0EVLbpMethgL3n8d/TcYZbp6cOa
         C/cvIUbrT3cBB0LXqZvddG2R1SJ+fOPdWAf+K/iRyOZxiKofEPeGv5w54sE37aMpZasr
         /CJE+THR1eANzX54pQaz6YeqV4lCPB9i3zRtgHnB3Yartq+Dl6BTD/j3OgzeSCGcco+R
         q3VJ3VQ3Dk5R5JHUxUw5Kyk3ThbUTu0cx+mKnEhA1JwGfCAl21TF98KJ/i+lvReux+eF
         +CVnH4SY2dv/t0vBJ7LnbYIy5/f7+vLRDbnRhMm3I+7eEiwx+MaKc9HnESr6wkL7d0Zw
         GAWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=0656yG2r9Ums4nGOghSQqH0qThSj3hBocwJfZfFJF1o=;
        b=YawBWB1mVqWMapqmCEFDXQzcuVkrZ+syGTyYkWKsVEz2QpSr5H/nnBubuEQHe/7Dju
         Vdt754yw5FkoTDps5jLfmbSS/4Ug0F4jqt/7KY+gGFIXDY/Lm/5u/BEUvg3KbNl2js75
         yc1KMFYZbneOJPc11hViBZRnKo9EUygrAfFgH4h1Vu0qfTuqsQUcVg9jjMT36W4IEjJI
         JO1PXuBX0XUOVbT+507OKKpCmfkrd2hZDD2OPv6k9wu+nUQ4zbnAiXY4pAEL6CygNaAL
         xN1m/7mwj5g2UFVJzjU2pdjTTyAYvmEOjSOaBEChmrMvbqpZjx5eY+hcVr4RMnM+yolL
         fNlA==
X-Gm-Message-State: AOAM533DO+qDWhyyH6/JU6SfczvD/V1Fqdzz01w5fdjsBIzXpN6ai9ee
        Gmje1SQ0gI8JdsMjlZIw5M32UptltSZU7VWQ85w=
X-Google-Smtp-Source: ABdhPJwk97eEhPOtGcC58WFjn7ghvOnUiZKrHGFi8uKXpJRFw2BakCLuEieQuy5FkY3kEUM9tJ1KGo6gN1fQrGJg3XY=
X-Received: by 2002:a05:620a:12d2:: with SMTP id e18mr27566660qkl.437.1593023204363;
 Wed, 24 Jun 2020 11:26:44 -0700 (PDT)
MIME-Version: 1.0
References: <20200623032224.4020118-1-andriin@fb.com> <20200623032224.4020118-2-andriin@fb.com>
 <7ed6ada5-2539-3090-0db7-0f65b67e4699@iogearbox.net> <CAEf4BzbsRyt5Y4-oMaKTUNu_ijnRD09+WW3iA+bfGLZcLpd77w@mail.gmail.com>
 <ee6df475-b7d4-b8ed-dc91-560e42d2e7fc@iogearbox.net> <20200623232503.yzm4g24rwx7khudf@ast-mbp.dhcp.thefacebook.com>
 <f1ec2d3b-4897-1a40-e373-51bed4fd3b87@fb.com> <CAEf4BzZTWyii7k6MjdygJP+VfAHnnr8jbxjG1Ge96ioKq5ZEeQ@mail.gmail.com>
 <5ef2ecf4b7bd9_37452b132c4de5bcc@john-XPS-13-9370.notmuch>
 <CAEf4BzZN+iH1zcH9VfYhe8CLS3LOrBW97e2e6SCsCTC=cThRqA@mail.gmail.com> <CAADnVQK4kWGUiM0z=-xaqs5-VENVDQmhVYAeByHmXC-pE69dNQ@mail.gmail.com>
In-Reply-To: <CAADnVQK4kWGUiM0z=-xaqs5-VENVDQmhVYAeByHmXC-pE69dNQ@mail.gmail.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Wed, 24 Jun 2020 11:26:33 -0700
Message-ID: <CAEf4BzaZOkgiuhVYbXpVSfDVHZ5CeqoKENsCo1UeY5kWEB6m+g@mail.gmail.com>
Subject: Re: [PATCH v3 bpf-next 2/3] selftests/bpf: add variable-length data
 concatenation pattern test
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     John Fastabend <john.fastabend@gmail.com>,
        Yonghong Song <yhs@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andriin@fb.com>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 24, 2020 at 11:19 AM Alexei Starovoitov
<alexei.starovoitov@gmail.com> wrote:
>
> On Tue, Jun 23, 2020 at 11:51 PM Andrii Nakryiko
> <andrii.nakryiko@gmail.com> wrote:
> >
> > long
> > represent reality, it causes more straightforward code generation, if
> > you don't aritifically down-cast types.
>
> yep. s/int/long/ conversion in bpf_helpers_def.h definitely improves
> generated code.
>
> > But even better is to just fix types of your local variables to match
> > native BPF size.
>
> I've applied int to long conversion for test_get_stack_rawtp.c test for now.
>
> Let's try to keep 100% passing rate for test_progs and test_progs-no_alu32 :)

Yeah, my bad. I was 100% sure that I tested both back when I did the
change, but nothing is 100% in this world, apparently :)

As for test_progs-no_alu32, I'll add them to Travis CI as well (right
now we only run test_progs), that will help. But I'll try to keep
test_progs-no_alu32 in mind when doing tests locally as well.
