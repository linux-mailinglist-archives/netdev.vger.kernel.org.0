Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7EA9645297D
	for <lists+netdev@lfdr.de>; Tue, 16 Nov 2021 06:21:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233574AbhKPFWo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Nov 2021 00:22:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54266 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233498AbhKPFWi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Nov 2021 00:22:38 -0500
Received: from mail-ed1-x544.google.com (mail-ed1-x544.google.com [IPv6:2a00:1450:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8145DC0C7C36;
        Mon, 15 Nov 2021 18:29:00 -0800 (PST)
Received: by mail-ed1-x544.google.com with SMTP id z10so54217813edc.11;
        Mon, 15 Nov 2021 18:29:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=dp217kNupJ0KxTcWN8TT3rIBC+AiqHlXmaU04DH6C/M=;
        b=TFv014Ht5eQCMErO+lJysb/PSi8k0MsapBeYuYZwcbqkF4KH8Vi6zF3mH1NXii1w88
         Fa9BrYLjPzaT/uHdVexHAu3GIhu79W7s7wU6mhIsmkQpNjtWWp6E0E4mLwBE3rS+pzQv
         zTHh9Saad/3kv6yf6sVskYhDFDlJA9Yl2D5tuYkTp1XwjQkpsKfbTMi5ExlZbmoXQeX1
         HziR5diIDJMAx/UYlBqLDDWGiCqdv8OdHJ6R7dmv661jqFcCGi3x9rbdzz3yBWsrBu9I
         yIXLNF67ilVKESaU4YuiPg1pHYtVyPpH3x4m15ZgqUPo5fm8yseqsrOscQTJbdyU6mqV
         VBkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=dp217kNupJ0KxTcWN8TT3rIBC+AiqHlXmaU04DH6C/M=;
        b=FUyeqxBjN7Y84kylC/ijLzwtdRG1S0kJ2Qp86JugXL4iGdUuQViVKQEfKAkaGA89iD
         a3tcxf7646T/Te1FKbjd6KVa63/9z80e4RPL9e+df1pKRQIom/BtDBV1cSI7XBt/6FpW
         FtoG6p/aJ7yN8Zk6EQjAw8ofkrw+nyN10Hd5q21AaPkFhHnheC8km+vPp8Rds+DFAXiN
         BC1pTWtYMa1UIGpZwLghqFEfztDBdPm0rHGGHXbQ8Tj9P5HRPq+qqob/2M1+ueiyQgy8
         BU1kdTTP2T0JLSiHqbe4a7L4ciPfYjg63lV2FLxpKv8G7p8nmDPDRB9YoiXtNsr4ZMxa
         NtXA==
X-Gm-Message-State: AOAM531jCyKo3P61vQPalr1Rxr2EB24ivS8Ti2AtJis0qrPKECNZrw6R
        EgxQ1dc1sZLqb2wWaguKNtaXo7NzH8GAxi/e+vo=
X-Google-Smtp-Source: ABdhPJwFwYZnDh8ckzOAqwhULxVQ50Uwp8XoInh/wXZmgan9QPaoXA33gtUaNSHuv2mon8NV+WKYs1HrL5qYK+R2U18=
X-Received: by 2002:a17:906:58c6:: with SMTP id e6mr5110855ejs.524.1637029738847;
 Mon, 15 Nov 2021 18:28:58 -0800 (PST)
MIME-Version: 1.0
References: <20211111133530.2156478-1-imagedong@tencent.com>
 <20211111060827.5906a2f9@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <CADxym3bk5+3t9jFmEgCBBYHWvNJx6BJGdjk+-zqiQaJPtLM=Ug@mail.gmail.com>
 <20211111175032.14999302@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <CADxym3YzMGG3gZ1X6gc=qF182Ow0iO+782Hjn3QvnFnRhfEbRA@mail.gmail.com> <20211112093140.373da4f7@gandalf.local.home>
In-Reply-To: <20211112093140.373da4f7@gandalf.local.home>
From:   Menglong Dong <menglong8.dong@gmail.com>
Date:   Tue, 16 Nov 2021 10:27:41 +0800
Message-ID: <CADxym3ZuywS5uDs+PZyMdw+5_eWFUuGXuaTy+FqWZHZy8V036A@mail.gmail.com>
Subject: Re: [PATCH net-next 0/2] net: snmp: tracepoint support for snmp
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>, mingo@redhat.com,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        dsahern@kernel.org, Menglong Dong <imagedong@tencent.com>,
        LKML <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello~

On Fri, Nov 12, 2021 at 10:31 PM Steven Rostedt <rostedt@goodmis.org> wrote:
>
> On Fri, 12 Nov 2021 14:42:23 +0800
> Menglong Dong <menglong8.dong@gmail.com> wrote:
>
> > What's more, I have also realized another version: create tracepoint for every
> > statistics type, such as snmp_udp_incsumerrors, snmp_udp_rcvbuferrors, etc.
> > This can solve performance issue, as users can enable part of them, which
> > may be triggered not frequently. However, too many tracepoint are created, and
> > I think it may be not applicable.
>
> If possible, it would be great to have a single tracepoint to handle all
> statistics (not sure what data it will be having). Or at least break it
> down to one tracepoint per group of statistics.
>
> There's two approaches that can be taken.
>
> 1) Create a DECLARE_EVENT_CLASS() template that the group of tracepoints
> use, and then create a DEFINE_EVENT() for each one. This will create a
> separate trace event for each stat. Most the footprint of a trace event is
> in the CLASS portion, so having a single class helps keep the size overhead
> down.
>

In fact, I think I'm using the first idea. I defined the DEFINE_SNMP_EVENT() in
https://lore.kernel.org/all/20211111133530.2156478-2-imagedong@tencent.com/,
which is used to create the tracepoint for each group. And I plan to create
tracepoint by protocols. such as: events/snmp/snmp_udp, events/snmp/snmp_tcp,
events/snmp/snmp_icmp, etc. And every trace event have a type field, which is
used to simply filter by statistics type:

+DECLARE_EVENT_CLASS(snmp_template,
+
+       TP_PROTO(struct sk_buff *skb, int field, int val),
+
+       TP_ARGS(skb, field, val),
+
+       TP_STRUCT__entry(
+               __field(void *, skbaddr)
+               __field(int, field)
+               __field(int, val)
+       ),
+
+       TP_fast_assign(
+               __entry->skbaddr = skb;
+               __entry->field = field;
+               __entry->val = val;
+       ),
+
+       TP_printk("skbaddr=%p, field=%d, val=%d", __entry->skbaddr,
+                 __entry->field, __entry->val)
+);
+
+#define DEFINE_SNMP_EVENT(proto)                               \
+DEFINE_EVENT(snmp_template, snmp_##proto,                      \
+       TP_PROTO(struct sk_buff *skb, int field, int val),      \
+       TP_ARGS(skb, field, val)                                \
+)

I think using a single trace event may have performance impact?

I will post the complete patch series after netdev opens.

Thanks!
Menglong Dong

> 2) Just use a single trace event for all stats in a group, but perhaps have
> a type field for each to use. That way it can be easy to filter on a set of
> stats to trace.
>
> -- Steve
