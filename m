Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BBB0F199C76
	for <lists+netdev@lfdr.de>; Tue, 31 Mar 2020 19:03:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731402AbgCaRDc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 Mar 2020 13:03:32 -0400
Received: from mail-qk1-f194.google.com ([209.85.222.194]:44094 "EHLO
        mail-qk1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730556AbgCaRDc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 31 Mar 2020 13:03:32 -0400
Received: by mail-qk1-f194.google.com with SMTP id j4so23743911qkc.11;
        Tue, 31 Mar 2020 10:03:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Sq4gr9JUKKq/v76iqvBt96WTykM4z0Gss+MWdW1HRnY=;
        b=TyAYh3WCpBrli1WidS3iwzzsBK+f7U1rhNGtsmnvE8W71Ivsbkh5bP4zQLaxWYJird
         U9QHCEIcnhVwav45B4pbttstN3P6LoCPSPkMQaiGnqW4TOIOd3H1jP4jEIMNCyWFe95k
         SFucYoxqX3+l+EWIMVIZUqRuC23Krk2qmJPR0LtXBCZdFol8YoozByYBtOugptuDvDZA
         fDgZzkKbtmBCCfXPnsYyb4E81/+upAIXZgwqw7Hm+HDDFBoU3FFcjUqGnxSklw71Pyww
         yWX2F7r+SAnhLX+AGCe8L1ZN/Fg4BTWgmpQjFcCuSfUnJCi67yrN0iUSzV0s5hlacY+x
         AEnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Sq4gr9JUKKq/v76iqvBt96WTykM4z0Gss+MWdW1HRnY=;
        b=EImr2Rzr3D1sEohRQZBil/X1lrsGUPsmp4JD5WmG5PB7sme7cUvY11jjkpEKH+dYbg
         nK2vI+CAS2WheCE59RVodkiPOO8lw7wh0GKG/GpIrxq5pA94HiEUZhMnuX3gfg2QrSzE
         mid3SU5CBTAQDkEbyF0r3Q98JUttWSAxj7unU4FatNslmbMzGJkAXo6xlwgEZxfTOTgE
         8YO22BBRaZ/GY4KI89WQRA73hWJO7XKPdpjLa+FmdNXPBHi6JJzTL1KDNzjZVYBLfkp0
         +XfQnFsLbDqebkIXCaONzwvh7Qei7TDlcXRDpNOndjqRRmptB7PpsF5KAwvu31xfF0ue
         Cq4w==
X-Gm-Message-State: ANhLgQ2E9xuHrxKTBvVfgpwNKpzRXNgN2PYRuuirwPLBle/8/oFQu2Np
        29w2Z/41r0t48RrzKW6il06e4A64Ruqp6+QXE+Q=
X-Google-Smtp-Source: ADFU+vsEqLJc+z/4xaLJGMr2nw6nVaa/DqtJ0D5nNUgUcVuGkAxVGBDiO8sMeAagloNERsQUIi48W8hOvRORMC3v0L4=
X-Received: by 2002:a37:b786:: with SMTP id h128mr5135248qkf.92.1585674209827;
 Tue, 31 Mar 2020 10:03:29 -0700 (PDT)
MIME-Version: 1.0
References: <20200330030001.2312810-1-andriin@fb.com> <c9f52288-5ea8-a117-8a67-84ba48374d3a@gmail.com>
 <CAEf4BzZpCOCi1QfL0peBRjAOkXRwGEi_DAW4z34Mf3Tv_sbRFw@mail.gmail.com>
 <662788f9-0a53-72d4-2675-daec893b5b81@gmail.com> <CAADnVQK8oMZehQVt34=5zgN12VBc2940AWJJK2Ft0cbOi1jDhQ@mail.gmail.com>
 <cdd576be-8075-13a7-98ee-9bc9355a2437@gmail.com> <20200331003222.gdc2qb5rmopphdxl@ast-mbp>
 <58cea4c7-e832-2632-7f69-5502b06310b2@gmail.com> <CAEf4BzZSCdtSRw9mj2W5Vv3C-G6iZdMJsZ8WGon11mN3oBiguQ@mail.gmail.com>
 <61442da0-6162-b786-7917-67e6fcb74ce8@gmail.com>
In-Reply-To: <61442da0-6162-b786-7917-67e6fcb74ce8@gmail.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Tue, 31 Mar 2020 10:03:18 -0700
Message-ID: <CAEf4Bza8aDurkXeDzpJqodkqck-y_-tH_gsRzUjeeNZ=OBVJuQ@mail.gmail.com>
Subject: Re: [PATCH v3 bpf-next 0/4] Add support for cgroup bpf_link
To:     David Ahern <dsahern@gmail.com>
Cc:     Alexei Starovoitov <alexei.starovoitov@gmail.com>,
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

Right, sorry, there were announcements and discussions about drgn on
mailing list before, so I wrongly assumed people are aware. It's here:

https://github.com/osandov/drgn

There is another BPF-related tool, that shows freplace'ed BPF
programs, attached to original program (which I stole some parts of
for my script, thanks Andrey Ignatov!):

https://github.com/osandov/drgn/blob/master/tools/bpf_inspect.py
