Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0748C193F3E
	for <lists+netdev@lfdr.de>; Thu, 26 Mar 2020 13:50:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728132AbgCZMuy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Mar 2020 08:50:54 -0400
Received: from us-smtp-delivery-74.mimecast.com ([216.205.24.74]:38166 "EHLO
        us-smtp-delivery-74.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728065AbgCZMuy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Mar 2020 08:50:54 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1585227052;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=SGJbUicDWdNrJvF7Xe2FQOUN6Q9YMTMN+4ll8mMwzqE=;
        b=QgJnUp7tWFsU/A/a0ucDX7mH4vCFB/k1rGFZpEhT0vZqIT4Glb+8ZcaDNc1eoin5h0Bi5V
        R3RV7ohZita9qQSx4Eaf1s67WHBkTYL/AnQp5yZIMfIPYBPU7ZA8xtZYEpNVrJEya9h9wc
        9o3v6dBsOhxJGothW+bSE2ET3WXA9bk=
Received: from mail-lf1-f70.google.com (mail-lf1-f70.google.com
 [209.85.167.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-89-05MU_eZ4Oe6cLkVWML21Hg-1; Thu, 26 Mar 2020 08:50:49 -0400
X-MC-Unique: 05MU_eZ4Oe6cLkVWML21Hg-1
Received: by mail-lf1-f70.google.com with SMTP id n16so1493371lfq.18
        for <netdev@vger.kernel.org>; Thu, 26 Mar 2020 05:50:48 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=SGJbUicDWdNrJvF7Xe2FQOUN6Q9YMTMN+4ll8mMwzqE=;
        b=HMqU2e0zRqozPaSbtTHre1OzwkojOL0OiMetoNvV6WU39G6xDI8jF4MVC8KOdbYIX7
         fjEhOAqiKJZGHObDDMkVyDBHVG6wx7GAzDQYvFmYepJ6Py4X/z0/qn8wkDB9mHTY3JrT
         JTjn3AD0YDPz1rT83A9Qf1zA+kfGNauFwePRdzkLj+m5Mebpm/FgqO/RjoZmwYYIR4NN
         +nZ/Z+uM/35Eowb5/zBywWz0QNKxQVTVo+iqPI0D1gAZ4XzQE+EhorEWh1FnDUTocJ20
         Wj3gvlcS9W6JCR3Z//k1rH8zspfWHISvpIxr57Lisf1wUUJpqqGmEgl+Cw0rhv55inzZ
         OVbw==
X-Gm-Message-State: AGi0PuYbqz+10B94PO73lSnksg50GrhQjgqxcUAuo8RgMYXEUMdilOxm
        mKUvx+bHqv5dwd+wLLPoHFD3b8WDVY0oJDNBtFnrvFFfKPzMk412iT7JkaT1IEcizOplN+PxtOM
        i8BMZtTvJo1MsI3HQ
X-Received: by 2002:a05:651c:1203:: with SMTP id i3mr2225463lja.175.1585227047152;
        Thu, 26 Mar 2020 05:50:47 -0700 (PDT)
X-Google-Smtp-Source: APiQypLtxLkwmMCjg864k/GPj0TYI0wirPCIHo7vjlUjIlEVzwBygzg+aUo4PWegnKtOxgQ34g4nAA==
X-Received: by 2002:a05:651c:1203:: with SMTP id i3mr2225447lja.175.1585227046708;
        Thu, 26 Mar 2020 05:50:46 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([2a0c:4d80:42:443::2])
        by smtp.gmail.com with ESMTPSA id h10sm1415218lfc.42.2020.03.26.05.50.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 Mar 2020 05:50:46 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 4E67A18158B; Thu, 26 Mar 2020 13:50:45 +0100 (CET)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Philip Prindeville <philipp_subx@redfish-solutions.com>,
        netdev@vger.kernel.org
Subject: Re: Fwd: tc question about ingress bandwidth splitting
In-Reply-To: <A408B33D-5EC7-4B29-B26D-1A881FA12778@redfish-solutions.com>
References: <74CFEE65-9CE8-4CF7-9706-2E2E67B24E08@redfish-solutions.com> <A408B33D-5EC7-4B29-B26D-1A881FA12778@redfish-solutions.com>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Thu, 26 Mar 2020 13:50:45 +0100
Message-ID: <87mu83nuu2.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Philip Prindeville <philipp_subx@redfish-solutions.com> writes:

> Had originally posted this to LARTC but realized that =E2=80=9Cnetdev=E2=
=80=9D is
> probably the better forum.
>
> Was hoping someone familiar with the nuts and bolts of tc and
> scheduler minutiae could help me come up with a configuration to use
> as a starting point, then I could tweak it, gather some numbers, make
> graphs etc, and write a LARTC or LWN article around the findings.
>
> I=E2=80=99d be trying to do shaping in both directions. Sure, egress shap=
ing
> is trivial and obviously works.
>
> But I was also thinking about ingress shaping on the last hop, i.e. as
> traffic flows into the last-hop CPE router, and limiting/delaying it
> so that the entire end-to-end path is appropriately perceived by the
> sender, since the effective bandwidth of a [non-multipath] route is
> the min bandwidth of all individual hops, right?

Indeed, we have been using ingress shaping to combat bufferbloat for
years, and it works quite well (although you may have to set it a few %
lower than your actual line speed). There's even a separate mode in
sch_cake specifically for this purpose.

> So that min could be experienced at the final hop before the receiver
> as delay injected between packets to shape the bitrate.
>
> How far off-base am I?
>
> And what would some tc scripting look like to measure my thesis?

Take a look at sqm-scripts: https://github.com/tohojo/sqm-scripts

It's basically a collection of scripts to setup the kind of bandwidth
shaper you're talking about, with various configuration options. It
is packaged for OpenWrt, but you can also install it on a regular Linux
box.

Now, it doesn't specifically do the kind of guest/production split
you're talking about. However, it does have a script (simple.qos) that
does a three-tier shaping based on different DiffServ markings. If you
start from that, you should be able to change the classification and
bandwidth tiers to suit your purposes.

Having said that, however...

...Are you sure you really need to split bandwidth that way? Usually,
people do this because they don't want the 'guest' traffic to negatively
impact 'their own' usage of the network. But really, with a correctly
de-bloated link, this is much less of an issue than people think. And
with the per-host isolation feature of sch_cake[0], it becomes even less
so.

Not saying you are definitely wrong to pursue this kind of throttling of
your guest network, of course. Just encouraging you to keep an open mind
and test out the other feature first; you may find that it solves your
the problem well enough to be worth the decrease in complexity :)

-Toke


[0] See the section 'To enable Per-Host Isolation' here: https://openwrt.or=
g/docs/guide-user/network/traffic-shaping/sqm-details#making_cake_sing_and_=
dance_on_a_tight_rope_without_a_safety_net_aka_advanced_features

