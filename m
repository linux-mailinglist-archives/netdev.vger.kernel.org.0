Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 435A636959
	for <lists+netdev@lfdr.de>; Thu,  6 Jun 2019 03:42:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726626AbfFFBme (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Jun 2019 21:42:34 -0400
Received: from mail-pg1-f193.google.com ([209.85.215.193]:45998 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726561AbfFFBme (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Jun 2019 21:42:34 -0400
Received: by mail-pg1-f193.google.com with SMTP id w34so343918pga.12
        for <netdev@vger.kernel.org>; Wed, 05 Jun 2019 18:42:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Y+7cTPfZsXLz5Lv4gyKxZWp6vwGWmIXUSzrtqIwayL8=;
        b=KPNGoskLSOsFamSJanF+N0grFYgVNU35p9d9vMjmrWC2VY2DYwO2Q2a/OujIHKrI5b
         LD7SNYiz9KwIcB1G5J11+KrLsSoG7wKKpKXi9SxIoglIiMJ6fg37kVIruC576Dixrt7f
         rwD0U07Z/spWxBHu87hW/uCDRedXsb3P90RDUf4r2BKnt2C/BU3OI0Dr6+Ll1f3zb4Ki
         dtJ5/S1s32OU9y+rAWq0tPtp4S4DKaC+jYoMcwFPeNIr4zg4rn3Wnzs+yzPLRC2JsO7p
         vYGppoqFr0+cjbRWqevjuTpG9wgmvOzoYTTeakPHm3QtOwSKIMcUJIV6rVsPDgppFYE5
         m5pw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Y+7cTPfZsXLz5Lv4gyKxZWp6vwGWmIXUSzrtqIwayL8=;
        b=YBL3rr4MssTVhX+laaF5pixoO2Fa77yjwU03Fhmb8BulIqHblaw2wJFIcdJQ6QkHCl
         82nYUBDTZeci8KWvcLskp/Bcivfaad3TWadlrmnvcKNvxI4RQvsHq4AufHAhbTpSnOQ4
         XQ2aTF+mqcBooOQPj/YZlHLzjcRM1wT3lwDbGWScW3smXoQ9KCarc4ZVjRuN2N8sX8uG
         ezXU4wie1/rloMaAkgeMyyLiAU7/35RgcXkDnpR4WneO6IX9dgkppwEB6D1+CaokWAA4
         OV82931n51f62nY3BNeQtAb41tzbpt3Ov5yz0aALMP7m6Em+WRZngPWc0VJYKO+Xjm4P
         HPQw==
X-Gm-Message-State: APjAAAW2OggHZ9Lm4Rsb/+4ryZ+GZk1dFh7u5K0Kgv/qUMrxnYfZ2MaN
        iUUwpEtBa7zBEtzXny0x80FGrUzQOG36p+GRfno=
X-Google-Smtp-Source: APXvYqyBliCuhubASQ8CLbQDhMFix49rllaob/WUOcZCFrQuULVDm1qNYDke5H/73rIC4mxWtpKI5B2otI/y7kxnmos=
X-Received: by 2002:a63:8bc7:: with SMTP id j190mr828116pge.104.1559785353756;
 Wed, 05 Jun 2019 18:42:33 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1559322531.git.dcaratti@redhat.com> <CAM_iQpWir7R3AQ7KSeFA5QNXSPHGK-1Nc7WsRM1vhkFyxB5ekA@mail.gmail.com>
 <739e0a292a31b852e32fb1096520bb7d771f8579.camel@redhat.com>
 <CAM_iQpUmuHH8S35ERuJ-sFS=17aa-C8uHSWF-WF7toANX2edCQ@mail.gmail.com>
 <82ec3877-8026-67f7-90d8-6e9988513fef@mellanox.com> <CAM_iQpXsGc2EpGkLq_3tcgiD+Mshe1GvGuURwcmeBEqpmQaiTw@mail.gmail.com>
 <d480caba-16e2-da3e-be33-ff4aeb5c6420@mellanox.com>
In-Reply-To: <d480caba-16e2-da3e-be33-ff4aeb5c6420@mellanox.com>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Wed, 5 Jun 2019 18:42:20 -0700
Message-ID: <CAM_iQpXqQ_smFtY4E6Jefki=htih_jW+jNzB1XNuzY1BzWqveQ@mail.gmail.com>
Subject: Re: [PATCH net v3 0/3] net/sched: fix actions reading the network
 header in case of QinQ packets
To:     Eli Britstein <elibr@mellanox.com>
Cc:     Davide Caratti <dcaratti@redhat.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        "David S . Miller" <davem@davemloft.net>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        Shuang Li <shuali@redhat.com>,
        Stephen Hemminger <stephen@networkplumber.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 4, 2019 at 11:19 AM Eli Britstein <elibr@mellanox.com> wrote:
>
>
> On 6/4/2019 8:55 PM, Cong Wang wrote:
> > On Sat, Jun 1, 2019 at 9:22 PM Eli Britstein <elibr@mellanox.com> wrote:
> >> I think that's because QinQ, or VLAN is not an encapsulation. There is
> >> no outer/inner packets, and if you want to mangle fields in the packet
> >> you can do it and the result is well-defined.
> > Sort of, perhaps VLAN tags are too short to be called as an
> > encapsulation, my point is that it still needs some endpoints to push
> > or pop the tags, in a similar way we do encap/decap.
> >
> >
> >> BTW, the motivation for my fix was a use case were 2 VGT VMs
> >> communicating by OVS failed. Since OVS sees the same VLAN tag, it
> >> doesn't add explicit VLAN pop/push actions (i.e pop, mangle, push). If
> >> you force explicit pop/mangle/push you will break such applications.
> >  From what you said, it seems act_csum is in the middle of packet
> > receive/transmit path. So, which is the one pops the VLAN tags in
> > this scenario? If the VM's are the endpoints, why not use act_csum
> > there?
>
> In a switchdev mode, we can passthru the VFs to VMs, and have their
> representors in the host, enabling us to manipulate the HW eswitch
> without knowledge of the VMs.
>
> To simplify it, consider the following setup:
>
> v1a <-> v1b and v2a <-> v2b are veth pairs.
>
> Now, we configure v1a.20 and v2a.20 as VLAN devices over v1a/v2a
> respectively (and put the "a" devs in separate namespaces).
>
> The TC rules are on the "b" devs, for example:
>
> tc filter add dev v1b ... action pedit ... action csum ... action
> redirect dev v2b
>
> Now, ping from v1a.20 to v1b.20. The namespaces transmit/receive tagged
> packets, and are not aware of the packet manipulation (and the required
> act_csum).

This is what I said, v1b is not the endpoint which pops the vlan tag,
v1b.20 is. So, why not simply move at least the csum action to
v1b.20? With that, you can still filter and redirect packets on v1b,
you still even modify it too, just defer the checksum fixup to the
endpoint.

And to be fair, if this case is a valid concern, so is VXLAN case,
just replace v1a.20 and v2a.20 with VXLAN tunnels. If you modify
the inner header, you have to fixup the checksum in the outer
UDP header.

Thanks.
