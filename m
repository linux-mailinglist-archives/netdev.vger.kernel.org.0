Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6FE7B26184F
	for <lists+netdev@lfdr.de>; Tue,  8 Sep 2020 19:52:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732184AbgIHRwH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Sep 2020 13:52:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44014 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731591AbgIHRv6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Sep 2020 13:51:58 -0400
Received: from mail-vk1-xa42.google.com (mail-vk1-xa42.google.com [IPv6:2607:f8b0:4864:20::a42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5FFF0C061573
        for <netdev@vger.kernel.org>; Tue,  8 Sep 2020 10:51:58 -0700 (PDT)
Received: by mail-vk1-xa42.google.com with SMTP id h23so32015vkn.4
        for <netdev@vger.kernel.org>; Tue, 08 Sep 2020 10:51:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=OBeaeAVUKiNmgW/DZzRv0moQ+dMhZppUu0mFG885ArY=;
        b=DT4Xo32KwklPVgNpWLNHtnFChS+582tbkLEL3cAnCSBAWtaQDgdhSUB7nToQBmpLOT
         UzX/8ljGUg9cUpYeCLnNp+cInPenpUYURZaDcZ1HC2siIyVn3RXMrumq54pYUTDyKC9U
         LL+8whyVMZZepNtWOfUeEB75lVHJObHdS1MzmYtp036R7TXh9SeNvo5ViADSKL1vHnRb
         5lsyHM2k5Yka8ePp8Y1OPAn/tGqxOLXDOxdC2nROSFwzl6cZ0gE+ExTaco1jG1nrr3lj
         LeqWXMxmf8Ksj+GBuVLtEvDwMJxrbV05e0aM+AAXv4Azwu5KLwvEa6bvckz5h5nxFE/V
         HLYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=OBeaeAVUKiNmgW/DZzRv0moQ+dMhZppUu0mFG885ArY=;
        b=fFI3u5r72a8L79RPleXhzZ2qCujq4T8pOjLnOohx+vhwLq+mgGlwAfoTKnwxKPFZaK
         JjF0yECaUSUZmMQ5mvmrALKUqrTQjjszUJ6NjphQkboskxVx9QUz3cVSLDz+5dMjDPri
         KM/7ityB0o2iQVR2EA3vwOFfaahiEPvuWQHDhN6U2EXzPcaw93xcLOEWfDv4vX7bcI4W
         7780+ldyEQ5+Xmq5yPJtlaNQXt8rgSIjZmOXSeCVpQwze5o4ghVpwzBEu6o03wmpD8mc
         oRjVIlvCn+tCfL7CK/GYklCBR3Vcpw+q0YwfA2xIq2wUeWantv2Kq7oy3V+yluX/vDyy
         Nqqg==
X-Gm-Message-State: AOAM532ypJPXRtd2S1W4nL2PYOxUD2MtwPfB/TeuDlxjgtVkWS9b9ErS
        o2IO5rYQyt0rc+DPGv9vJO6DYSMPCIH2kQ==
X-Google-Smtp-Source: ABdhPJz3vpjOLEjgqf8OniwapeEAZFCBlWA0X4Hia+baxknEYZOzIVVaMkZ9mn6lccP65egkLyPqzQ==
X-Received: by 2002:a1f:141:: with SMTP id 62mr185212vkb.2.1599587516453;
        Tue, 08 Sep 2020 10:51:56 -0700 (PDT)
Received: from mail-vs1-f44.google.com (mail-vs1-f44.google.com. [209.85.217.44])
        by smtp.gmail.com with ESMTPSA id w69sm3086166vkd.23.2020.09.08.10.51.55
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 08 Sep 2020 10:51:55 -0700 (PDT)
Received: by mail-vs1-f44.google.com with SMTP id q13so9474615vsj.13
        for <netdev@vger.kernel.org>; Tue, 08 Sep 2020 10:51:55 -0700 (PDT)
X-Received: by 2002:a05:6102:150:: with SMTP id a16mr172014vsr.99.1599587514844;
 Tue, 08 Sep 2020 10:51:54 -0700 (PDT)
MIME-Version: 1.0
References: <20200901195415.4840-1-m-karicheri2@ti.com> <d93fbc54-1721-ebec-39ca-dc8b45e6e534@ti.com>
 <15bbf7d2-627b-1d52-f130-5bae7b7889de@ti.com> <CA+FuTSeri93irC9eaQqrFrY2++d0zJ4-F0YAfCXfX6XVVqU6Pw@mail.gmail.com>
 <bf8a22c2-0ebe-7a52-2e79-7dde72d444ba@ti.com>
In-Reply-To: <bf8a22c2-0ebe-7a52-2e79-7dde72d444ba@ti.com>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Tue, 8 Sep 2020 19:51:16 +0200
X-Gmail-Original-Message-ID: <CA+FuTSeE_O_XozfnzDED_S4of-NwtRCN+oWr=O3JPpByfCz3Vg@mail.gmail.com>
Message-ID: <CA+FuTSeE_O_XozfnzDED_S4of-NwtRCN+oWr=O3JPpByfCz3Vg@mail.gmail.com>
Subject: Re: [PATCH net-next 0/1] Support for VLAN interface over HSR/PRP
To:     Murali Karicheri <m-karicheri2@ti.com>
Cc:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>, nsekhar@ti.com,
        Grygorii Strashko <grygorii.strashko@ti.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Sep 8, 2020 at 6:55 PM Murali Karicheri <m-karicheri2@ti.com> wrote:
>
> Hi Willem,
>
> On 9/4/20 11:52 AM, Willem de Bruijn wrote:
> > On Thu, Sep 3, 2020 at 12:30 AM Murali Karicheri <m-karicheri2@ti.com> wrote:
> >>
> >> All,
> >>
> >> On 9/2/20 12:14 PM, Murali Karicheri wrote:
> >>> All,
> >>>
> >>> On 9/1/20 3:54 PM, Murali Karicheri wrote:
> >>>> This series add support for creating VLAN interface over HSR or
> >>>> PRP interface. Typically industrial networks uses VLAN in
> >>>> deployment and this capability is needed to support these
> >>>> networks.
> >>>>
> >>>> This is tested using two TI AM572x IDK boards connected back
> >>>> to back over CPSW  ports (eth0 and eth1).
> >>>>
> >>>> Following is the setup
> >>>>
> >>>>                   Physical Setup
> >>>>                   ++++++++++++++
> >>>>    _______________    (CPSW)     _______________
> >>>>    |              |----eth0-----|               |
> >>>>    |TI AM572x IDK1|             | TI AM572x IDK2|
> >>>>    |______________|----eth1-----|_______________|
> >>>>
> >>>>
> >>>>                   Network Topolgy
> >>>>                   +++++++++++++++
> >>>>
> >>>>                          TI AM571x IDK  TI AM572x IDK
> >>>>
> >>>> 192.168.100.10                 CPSW ports                 192.168.100.20
> >>>>                IDK-1                                        IDK-2
> >>>> hsr0/prp0.100--| 192.168.2.10  |--eth0--| 192.168.2.20 |--hsr0/prp0.100
> >>>>                  |----hsr0/prp0--|        |---hsr0/prp0--|
> >>>> hsr0/prp0.101--|               |--eth1--|              |--hsr0/prp0/101
> >>>>
> >>>> 192.168.101.10                                            192.168.101.20
> >>>>
> >>>> Following tests:-
> >>>>    - create hsr or prp interface and ping the interface IP address
> >>>>      and verify ping is successful.
> >>>>    - Create 2 VLANs over hsr or prp interface on both IDKs (VID 100 and
> >>>>      101). Ping between the IP address of the VLAN interfaces
> >>>>    - Do iperf UDP traffic test with server on one IDK and client on the
> >>>>      other. Do this using 100 and 101 subnet IP addresses
> >>>>    - Dump /proc/net/vlan/{hsr|prp}0.100 and verify frames are transmitted
> >>>>      and received at these interfaces.
> >>>>    - Delete the vlan and hsr/prp interface and verify interfaces are
> >>>>      removed cleanly.
> >>>>
> >>>> Logs for IDK-1 at https://pastebin.ubuntu.com/p/NxF83yZFDX/
> >>>> Logs for IDK-2 at https://pastebin.ubuntu.com/p/YBXBcsPgVK/
> >>>>
> >>>> Murali Karicheri (1):
> >>>>     net: hsr/prp: add vlan support
> >>>>
> >>>>    net/hsr/hsr_device.c  |  4 ----
> >>>>    net/hsr/hsr_forward.c | 16 +++++++++++++---
> >>>>    2 files changed, 13 insertions(+), 7 deletions(-)
> >>>>
> >>> I am not sure if the packet flow is right for this?
> >>>
> >>> VLAN over HSR frame format is like this.
> >>>
> >>> <Start of Frame><VLAN tag><HSR Tag><IP><CRC>
> >>>
> >>> My ifconfig stats shows both hsr and hsr0.100 interfaces receiving
> >>> frames.
> >>>
> >>> So I did a WARN_ON() in HSR driver before frame is forwarded to upper
> >>> layer.
> >>>
> >>> a0868495local@uda0868495:~/Projects/upstream-kernel$ git diff
> >>> diff --git a/net/hsr/hsr_forward.c b/net/hsr/hsr_forward.c
> >>> index de21df30b0d9..545a3cd8c71b 100644
> >>> --- a/net/hsr/hsr_forward.c
> >>> +++ b/net/hsr/hsr_forward.c
> >>> @@ -415,9 +415,11 @@ static void hsr_forward_do(struct hsr_frame_info
> >>> *frame)
> >>>                   }
> >>>
> >>>                   skb->dev = port->dev;
> >>> -               if (port->type == HSR_PT_MASTER)
> >>> +               if (port->type == HSR_PT_MASTER) {
> >>> +                       if (skb_vlan_tag_present(skb))
> >>> +                               WARN_ON(1);
> >>>                           hsr_deliver_master(skb, port->dev,
> >>> frame->node_src);
> >>> -               else
> >>> +               } else
> >>>                           hsr_xmit(skb, port, frame);
> >>>           }
> >>>    }
> >>>
> >>> And I get the trace shown below.
> >>>
> >>> [  275.125431] WARNING: CPU: 0 PID: 0 at net/hsr/hsr_forward.c:420
> >>> hsr_forward_skb+0x460/0x564
> >>> [  275.133822] Modules linked in: snd_soc_omap_hdmi snd_soc_ti_sdma
> >>> snd_soc_core snd_pcm_dmaengine snd_pcm snd_time4
> >>> [  275.199705] CPU: 0 PID: 0 Comm: swapper/0 Tainted: G        W
> >>> 5.9.0-rc1-00658-g473e463812c2-dirty #8
> >>> [  275.209573] Hardware name: Generic DRA74X (Flattened Device Tree)
> >>> [  275.215703] [<c011177c>] (unwind_backtrace) from [<c010b6f0>]
> >>> (show_stack+0x10/0x14)
> >>> [  275.223487] [<c010b6f0>] (show_stack) from [<c055690c>]
> >>> (dump_stack+0xc4/0xe4)
> >>> [  275.230747] [<c055690c>] (dump_stack) from [<c01386ac>]
> >>> (__warn+0xc0/0xf4)
> >>> [  275.237656] [<c01386ac>] (__warn) from [<c0138a3c>]
> >>> (warn_slowpath_fmt+0x58/0xb8)
> >>> [  275.245177] [<c0138a3c>] (warn_slowpath_fmt) from [<c09564bc>]
> >>> (hsr_forward_skb+0x460/0x564)
> >>> [  275.253657] [<c09564bc>] (hsr_forward_skb) from [<c0955534>]
> >>> (hsr_handle_frame+0x15c/0x190)
> >>> [  275.262047] [<c0955534>] (hsr_handle_frame) from [<c07c6704>]
> >>> (__netif_receive_skb_core+0x23c/0xc88)
> >>> [  275.271223] [<c07c6704>] (__netif_receive_skb_core) from [<c07c7180>]
> >>> (__netif_receive_skb_one_core+0x30/0x74)
> >>> [  275.281266] [<c07c7180>] (__netif_receive_skb_one_core) from
> >>> [<c07c72a4>] (netif_receive_skb+0x50/0x1c4)
> >>> [  275.290793] [<c07c72a4>] (netif_receive_skb) from [<c071a55c>]
> >>> (cpsw_rx_handler+0x230/0x308)
> >>> [  275.299272] [<c071a55c>] (cpsw_rx_handler) from [<c0715ee8>]
> >>> (__cpdma_chan_process+0xf4/0x188)
> >>> [  275.307925] [<c0715ee8>] (__cpdma_chan_process) from [<c0717294>]
> >>> (cpdma_chan_process+0x3c/0x5c)
> >>> [  275.316754] [<c0717294>] (cpdma_chan_process) from [<c071dd14>]
> >>> (cpsw_rx_mq_poll+0x44/0x98)
> >>> [  275.325145] [<c071dd14>] (cpsw_rx_mq_poll) from [<c07c8ae0>]
> >>> (net_rx_action+0xf0/0x400)
> >>> [  275.333185] [<c07c8ae0>] (net_rx_action) from [<c0101370>]
> >>> (__do_softirq+0xf0/0x3ac)
> >>> [  275.340965] [<c0101370>] (__do_softirq) from [<c013f5ec>]
> >>> (irq_exit+0xa8/0xe4)
> >>> [  275.348224] [<c013f5ec>] (irq_exit) from [<c0199344>]
> >>> (__handle_domain_irq+0x6c/0xe0)
> >>> [  275.356093] [<c0199344>] (__handle_domain_irq) from [<c056f8fc>]
> >>> (gic_handle_irq+0x4c/0xa8)
> >>> [  275.364481] [<c056f8fc>] (gic_handle_irq) from [<c0100b6c>]
> >>> (__irq_svc+0x6c/0x90)
> >>> [  275.371996] Exception stack(0xc0e01f18 to 0xc0e01f60)
> >>>
> >>> Shouldn't it show vlan_do_receive() ?
> >>>
> >>>       if (skb_vlan_tag_present(skb)) {
> >>>           if (pt_prev) {
> >>>               ret = deliver_skb(skb, pt_prev, orig_dev);
> >>>               pt_prev = NULL;
> >>>           }
> >>>           if (vlan_do_receive(&skb))
> >>>               goto another_round;
> >>>           else if (unlikely(!skb))
> >>>               goto out;
> >>>       }
> >>>
> >>> Thanks
> >>>
> >>
> >> I did an ftrace today and I find vlan_do_receive() is called for the
> >> incoming frames before passing SKB to hsr_handle_frame(). If someone
> >> can review this, it will help. Thanks.
> >>
> >> https://pastebin.ubuntu.com/p/CbRzXjwjR5/
> >
> > hsr_handle_frame is an rx_handler called after
> > __netif_receive_skb_core called vlan_do_receive and jumped back to
> > another_round.
>
> Yes. hsr_handle_frame() is a rx_handler() after the above code that
> does vlan_do_receive(). The ftrace shows vlan_do_receive() is called
> followed by call to hsr_handle_frame(). From ifconfig I can see both
> hsr and vlan interface stats increments by same count. So I assume,
> vlan_do_receive() is called initially and it removes the tag, update
> stats and then return true and go for another round. Do you think that
> is the case?

That was my understanding.

> vlan_do_receive() calls vlan_find_dev(skb->dev, vlan_proto, vlan_id)
> to retrieve the real netdevice (real device). However VLAN device is
> attached to hsr device (real device), but SKB will have HSR slave
> Ethernet netdevice (in our case it is cpsw device) and vlan_find_dev()
> would have failed since there is no vlan_info in cpsw netdev struct. So
> below code  in vlan_do_receive() should have failed and return false.
>
>         vlan_dev = vlan_find_dev(skb->dev, vlan_proto, vlan_id);
>         if (!vlan_dev)
>                 return false;
>
> So how does it goes for another_round ? May be vlan_find_dev is
> finding the hsr netdevice?

It's good to answer this through code inspection and/or
instrumentation. I do not have the answer immediately either.

There certainly is prior art in having vlan with an rx_handler,
judging from the netif_is_macvlan_port(vlan_dev) and
netif_is_bridge_port(vlan_dev) helpers in vlan_do_receive.
> I am not an expert and so the question. Probably I can put a
> traceprintk() to confirm this, but if someone can clarify this
> it will be great. But for that, I will spin v2 with the above comments
> addressed as in my reply and post.

Please don't send a patch before we understand this part.
