Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3E1E845B252
	for <lists+netdev@lfdr.de>; Wed, 24 Nov 2021 03:58:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239618AbhKXDBV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Nov 2021 22:01:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36840 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230488AbhKXDBT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Nov 2021 22:01:19 -0500
Received: from mail-ed1-x544.google.com (mail-ed1-x544.google.com [IPv6:2a00:1450:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 67153C061574;
        Tue, 23 Nov 2021 18:58:10 -0800 (PST)
Received: by mail-ed1-x544.google.com with SMTP id e3so3641651edu.4;
        Tue, 23 Nov 2021 18:58:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=neOHLv9tj3JEjj+cIZNAwEBjSyvmjiIPsQXPGcdecIU=;
        b=KSY76bjtXPNSgzaPev/BmOuVO741WxF/R4yY/DpXuskrt1NQBOTlPWlklBNbkDYxB2
         izOIyMFqr0QqLKC9oxlMbcn5kCVX2lLL6z5L6MwYCToXZ8k8t7DGA5waZ3alxBgI8SeD
         JQthZOPV1+HuTgXzpPZsB0nDmIIZJTyIMB4dxmXqNVChQBrcOf4E7vuM0KA1Fo1fygSq
         roc7gK94eTbNolEYC3x0OA3iSvBC3Ibgb64el8r16rsw37vMJSUDktktgwhkDXmwVT58
         DG70gx5r0LHd401bVMY5/hAxBGocA457FOTGSYwwwCwr/LEuHwMK0PJgP9VdlX4h7yni
         txeA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=neOHLv9tj3JEjj+cIZNAwEBjSyvmjiIPsQXPGcdecIU=;
        b=ulr9QqrPqFSjxeyx+R1pZ4/555J+sPA5Ojc7wUIMEIz6k+MX4GHtAznB8a0lYqyQzy
         ItSbgtRhEOCUNQ3UL6HwbZaI3D7PLtYxJSmph7anIPtvafdKq1MDM/jcxJZ+aPPAiI3k
         9E/xGmCuz+KfxpVriCf04R6/1ZeBhrGXwmAcBlYxeUADNonBLPUS0n+T+4grRAoI1ySv
         Qjw5EAlL2rlAJ3bWP2T/j5nRq8x5o5ScLtAc46agRm2EklykwedvP/Y5JPVAov+Ke9aK
         /xOLTRuggi4YMCUPOv0BvX72jP4iV9VrRF88smJfMHzDL3mduODqqw85GcBQ1XbpgGfI
         Yzcw==
X-Gm-Message-State: AOAM533Ze7de04XPXV5EBq6Y4MbEPAMLHltdcCjr5/J+1QoAdNguB6cE
        bXcktm0ZQAby23LUcmE64bbuGUP6i2iUWN+IIoc=
X-Google-Smtp-Source: ABdhPJytjHxyaXS7ejLs40J7686DY3glXQmF4GpOq+ABZvACBYo3B91s6OUA/VafGQ30r9nTo/ePGujPsPse0rJtzlU=
X-Received: by 2002:a05:6402:100e:: with SMTP id c14mr18766589edu.196.1637722689030;
 Tue, 23 Nov 2021 18:58:09 -0800 (PST)
MIME-Version: 1.0
References: <20211118124812.106538-1-imagedong@tencent.com>
 <67b36bd8-2477-88ac-83a0-35a1eeaf40c9@gmail.com> <CADxym3ZfBVAecK-oFdMVV2gkOV6iUrq5XGkRZx3yXCuXDOS=2A@mail.gmail.com>
 <9ad07da4-8523-b861-6111-729b8d1d6d57@gmail.com> <CADxym3bTScvYzpUzvz62zpUvqksbfW-f=JpCUHbEJCagjY6wuQ@mail.gmail.com>
 <3672df5b-7e23-f51c-c396-c9b8a782233e@gmail.com>
In-Reply-To: <3672df5b-7e23-f51c-c396-c9b8a782233e@gmail.com>
From:   Menglong Dong <menglong8.dong@gmail.com>
Date:   Wed, 24 Nov 2021 10:56:16 +0800
Message-ID: <CADxym3a+fFnr0DVCfCK15q-SoL9Lbfgbr23Wg2OmYYmJqgAjqg@mail.gmail.com>
Subject: Re: [PATCH v2 net-next 0/2] net: snmp: tracepoint support for snmp
To:     David Ahern <dsahern@gmail.com>
Cc:     Steven Rostedt <rostedt@goodmis.org>,
        Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>, mingo@redhat.com,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        dsahern@kernel.org, Menglong Dong <imagedong@tencent.com>,
        Yuchung Cheng <ycheng@google.com>, kuniyu@amazon.co.jp,
        LKML <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 23, 2021 at 12:42 AM David Ahern <dsahern@gmail.com> wrote:
>
> On 11/21/21 3:47 AM, Menglong Dong wrote:
> > On Fri, Nov 19, 2021 at 11:54 AM David Ahern <dsahern@gmail.com> wrote:
> >>
> > [...]
> >>
> >> But it integrates into existing tooling which is a big win.
> >>
> >> Ido gave the references for his work:
> >> https://github.com/nhorman/dropwatch/pull/11
> >> https://github.com/nhorman/dropwatch/commit/199440959a288dd97e3b7ae701d4e78968cddab7
> >>
> >
> > I have been thinking about this all day, and I think your words make sense.
> > Indeed, this can make use of the frame of the 'drop monitor' module of kernel
> > and the userspace tools of wireshark, dropwatch, etc. And this idea is more
> > suitable for the aim of 'get the reason for packet drop'. However, the
> > shortcoming
> > of this idea is that it can't reuse the drop reason for the 'snmp'
> > frame.
> >
> > With creating a tracepoint for 'snmp', it can make use of the 'snmp' frame and
> > the modifications can be easier. However, it's not friendly to the
> > users, such as
> > dropwatch, wireshark, etc. And it seems it is a little redundant with what
> > the tracepoint for 'kfree_sbk()' do. However, I think it's not
> > difficult to develop
> > a userspace tool. In fact, I have already write a tool based on BCC, which is
> > able to make use of 'snmp' tracepoint, such as:
> >
> > $ sudo ./nettrace.py --tracer snmp -p udp --addr 192.168.122.8
> > begin tracing......
> > 785487.366412: [snmp][udplite_noports]: UDP: 192.168.122.8:35310 ->
> > 192.168.122.1:7979
> >
> > And it can monitor packet drop of udp with ip 192.168.122.8 (filter by port,
> > statistics type are supported too).
> >
> > And maybe we can integrate tracepoint of  'snmp' into 'drop monitor' with
> > NET_DM_ATTR_SNMP, just link NET_DM_ATTR_SW_DROPS and
> > NET_DM_ATTR_HW_DROPS?
> >
>
> you don't need to add 'snmp' to drop monitor; you only need to add
> NET_DM_ATTR_ to the existing one.
>
> This is the end of __udp4_lib_rcv:
>
>         __UDP_INC_STATS(net, UDP_MIB_CSUMERRORS, proto == IPPROTO_UDPLITE);
> drop:
>         __UDP_INC_STATS(net, UDP_MIB_INERRORS, proto == IPPROTO_UDPLITE);
>         kfree_skb(skb);
>
> you want to add a tracepoint at both UDP_INC_STATS making 3 consecutive
> lines that give access to the dropped skb with only slight variations in
> metadata.
>
> The last one, kfree_skb, gives you the address of the drop + the skb for
> analysis. Just add the metadata to the existing drop monitor.

Ok, get it! Thanks~

Menglong Dong

>
