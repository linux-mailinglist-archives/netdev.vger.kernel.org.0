Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F006917AAF6
	for <lists+netdev@lfdr.de>; Thu,  5 Mar 2020 17:53:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726173AbgCEQx3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Mar 2020 11:53:29 -0500
Received: from mail-qv1-f66.google.com ([209.85.219.66]:40392 "EHLO
        mail-qv1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726083AbgCEQx3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Mar 2020 11:53:29 -0500
Received: by mail-qv1-f66.google.com with SMTP id u17so1398237qvv.7;
        Thu, 05 Mar 2020 08:53:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=npcqK+CtPgKOdYKCLUdw238cgWR2tdAWLJ+s57xZf+Y=;
        b=jFX60U1lxCSBOa8t/1PdSfb/kdQVkSZh8Mk5VzCBsZTJbt2yo44hS6AtFCV/WHqQpx
         3qbwM6aYWdIajwbaZZ5EhZp4fO+lmJ1e4PZSf/j6PN0nf0VFxyZEKSkBZx3DVD+I9MKa
         xrM4cZ6xC9OoiW7EkAZUI7RYde5/gJi4Mth4cQLIcHl+rewqFyoNnoJMhOUqzbaKaPI2
         U9VBpWGRHvk3QJh6QzrxxibeO+VwGGg4y40MpCL6actTzyPTm1TwfNkLyxEg/XuARz3Q
         Rsa0amnG5coKjjJlF+LpckLtPCNZqvxeoTWlNxc+YliNEl9N/xcqn//D1T2pO8COBC+9
         d6Vw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=npcqK+CtPgKOdYKCLUdw238cgWR2tdAWLJ+s57xZf+Y=;
        b=ajbBZk15DSiKZw2CYsGfBPWMnClC+PbpHLxyRayvQRN85COc1bz+3X4Wemapzs7OAN
         VP/r5E4r7JxgMXIBbOKVaxCc94ygwqiv6FOcdJAK0WQbxqVpkiwzdybCR4rcup+wax3K
         53cBgQ7bafjBVdFZ7Fkwpi0CjW5cceslht3BHA2thUFEzrDT+uFMOn9lzd2APFAbjd8g
         WDDJkSyWW1JF97r8AzKSSXOZYUKlAkLBu4JaP4chTrTBLx7O1kmhjnIs/DWduweD8UzK
         Bt4S+U1VqGG02XLABaLsNu3Eym9lp0W+z3ipmZKD0OLbtUUmld0jf2vxaVHeb7wcZqIB
         fOSQ==
X-Gm-Message-State: ANhLgQ2jYI+EOpbGaMMq4vE86qKkIpd4A9cBn2LlahFzbptGUfM9Ed9R
        q0TNfQLT6FGO/7Ibhwgd1XQZLpDW0vInaZzXchM=
X-Google-Smtp-Source: ADFU+vviwKS4MeppDNv2kpImVhSonDJ24hNChwGak/JUqVXaYc2hp5YiGqyd8YCmOP3NKhW87RY1O4IxPy8g8zMdixs=
X-Received: by 2002:a0c:f985:: with SMTP id t5mr7387374qvn.127.1583427207904;
 Thu, 05 Mar 2020 08:53:27 -0800 (PST)
MIME-Version: 1.0
References: <20200305050207.4159-1-luke.r.nels@gmail.com> <CAJ+HfNjrUxVqpBgC-WLHbZX7_7Gd-Lk7ghrmASTmaNySuXVUfg@mail.gmail.com>
 <4633123d-dc61-ab79-d2ee-e0cef66e4cea@iogearbox.net>
In-Reply-To: <4633123d-dc61-ab79-d2ee-e0cef66e4cea@iogearbox.net>
From:   =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>
Date:   Thu, 5 Mar 2020 17:53:16 +0100
Message-ID: <CAJ+HfNg_cP8DC+C0UGHnumde6+YhqBoTB909A9XwFMPv82tqWw@mail.gmail.com>
Subject: Re: [PATCH bpf-next v5 0/4] eBPF JIT for RV32G
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     Luke Nelson <lukenels@cs.washington.edu>,
        bpf <bpf@vger.kernel.org>, Luke Nelson <luke.r.nels@gmail.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>, Xi Wang <xi.wang@gmail.com>,
        Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Rob Herring <robh@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        linux-doc@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Netdev <netdev@vger.kernel.org>, linux-riscv@lists.infradead.org
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 5 Mar 2020 at 16:19, Daniel Borkmann <daniel@iogearbox.net> wrote:
>
[...]
> Applied, thanks everyone!
>
> P.s.: I fixed the MAINTAINERS entry in the last one to have both netdev and bpf
> to be consistent with all the other JIT entries there.

Ah, I asked specifically Xi and Luke to *remove* the netdev entry, due
to the bpf_devel_QA.rst change. :-)
