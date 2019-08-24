Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E93EB9BFEC
	for <lists+netdev@lfdr.de>; Sat, 24 Aug 2019 21:53:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727969AbfHXTxV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 24 Aug 2019 15:53:21 -0400
Received: from mail-ed1-f68.google.com ([209.85.208.68]:46057 "EHLO
        mail-ed1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727564AbfHXTxV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 24 Aug 2019 15:53:21 -0400
Received: by mail-ed1-f68.google.com with SMTP id x19so19481011eda.12
        for <netdev@vger.kernel.org>; Sat, 24 Aug 2019 12:53:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=qpNomtoPmxoGGLAnksDjepMPPGWHvtbJMP4Ed4uUC9k=;
        b=lYdxsufi7VRr2oNkqYEhVMikeSnBDQlsEuDfTJVl55aHfkIRWTvt+9OWuHk7BRilkb
         tT8oAI3EeJMmhaDh+HhtwM8BRWCHCwsRmT8PK8pUh195+S0y2VgfatoebkV7H1xgxFSF
         EbrQzgevPj0SQkV48HbaTc8im0srQItKV0ICy6QwmeGd+2GPIYn3gRL2YuDmuk0jBSJK
         OCf9cFZRfXSxLfwnMbCp7mKMhMIFi6mhSeZWTL5K8Uc+Km9k3PV6Qwkwczv+/I3uovuj
         RiGECfEh+gINvyox8rKf9212trnpHS1QIi2keift3qtbVx+8Prla/lWXWWGvY6rlQ9M5
         +OxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=qpNomtoPmxoGGLAnksDjepMPPGWHvtbJMP4Ed4uUC9k=;
        b=LFRAWca4OwBeD7Iw4wA1F196FTiXOkK1zkjOA1GF0QTL2KWzwHgmTU4qimqv/rpXgu
         PCilooKxJ3TcF6LcV8u2a1Z+eBTpcdnU76L8mnec4xCvYK2tNMWzLuHGhq+2ye+S2Ert
         zUC3gOcOCwS2cZmEtUWucE1FU+u3139H9BSIx3s/okgZSBSW7Kyhj7A4PvKR3i+jjUW7
         3njc3tQvS3TRuuMENdYwwTD96f5pGF2P/4XN08G+GaVuAWu0z8icknX6ASkS/DgswfBP
         Oizdvdi56w3EXS4+qyO0pTqXXx2hx7JstQ9jMQRSqB5MadOxWIW64GRrQQp0cbdfZKI4
         N80g==
X-Gm-Message-State: APjAAAWAipOkcIcMxPlFf8SwjdiOZHRUNgghfo6wBpV3hpVnWahyALbT
        CCpv3r44YKdI2mE1LVE8l4vKaTaRDkL1US+tzTk=
X-Google-Smtp-Source: APXvYqwehOMKpZnnJ4p//9nMl3EFRV5tUOxFgqD5+VpKEoHxsHXutycnGtxRy0qDdvf/5H1EwgKbcR3j9zNtLVGGtno=
X-Received: by 2002:a05:6402:1244:: with SMTP id l4mr10759274edw.117.1566676399863;
 Sat, 24 Aug 2019 12:53:19 -0700 (PDT)
MIME-Version: 1.0
References: <20190822201323.1292-1-vivien.didelot@gmail.com>
 <20190822201323.1292-7-vivien.didelot@gmail.com> <aee63928-a99e-3849-c8b4-dee9b660247c@gmail.com>
 <3c88db34-464a-1ab7-a525-66791faad698@gmail.com>
In-Reply-To: <3c88db34-464a-1ab7-a525-66791faad698@gmail.com>
From:   Vladimir Oltean <olteanv@gmail.com>
Date:   Sat, 24 Aug 2019 22:53:08 +0300
Message-ID: <CA+h21hpML8GLQ-n5AsJ4+BAYy8dwTQuAGYRwcZrwHxY9wy=6aQ@mail.gmail.com>
Subject: Re: [PATCH net-next 6/6] net: dsa: clear VLAN flags for CPU port
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     Vivien Didelot <vivien.didelot@gmail.com>,
        netdev <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Andrew Lunn <andrew@lunn.ch>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Florian,

On Fri, 23 Aug 2019 at 20:00, Florian Fainelli <f.fainelli@gmail.com> wrote:
>
> On 8/22/19 4:51 PM, Vladimir Oltean wrote:
> > On 8/22/19 11:13 PM, Vivien Didelot wrote:
> >> When the bridge offloads a VLAN on a slave port, we also need to
> >> program its dedicated CPU port as a member of the VLAN.
> >>
> >> Drivers may handle the CPU port's membership as they want. For example,
> >> Marvell as a special "Unmodified" mode to pass frames as is through
> >> such ports.
> >>
> >> Even though DSA expects the drivers to handle the CPU port membership,
> >> they are unlikely to program such VLANs untagged, and certainly not as
> >> PVID. This patch clears the VLAN flags before programming the CPU port.
> >>
> >> Signed-off-by: Vivien Didelot <vivien.didelot@gmail.com>
> >> Suggested-by: Vladimir Oltean <olteanv@gmail.com>
> >> ---
> >>   net/dsa/slave.c | 6 ++++++
> >>   1 file changed, 6 insertions(+)
> >>
> >> diff --git a/net/dsa/slave.c b/net/dsa/slave.c
> >> index 8267c156a51a..48df48f76c67 100644
> >> --- a/net/dsa/slave.c
> >> +++ b/net/dsa/slave.c
> >> @@ -332,6 +332,12 @@ static int dsa_slave_vlan_add(struct net_device
> >> *dev,
> >>       if (err)
> >>           return err;
> >>   +    /* We need the dedicated CPU port to be a member of the VLAN as
> >> well.
> >> +     * Even though drivers often handle CPU membership in special ways,
> >> +     * CPU ports are likely to be tagged, so clear the VLAN flags.
> >> +     */
> >> +    vlan.flags = 0;
> >> +
> >
> > How does this work exactly?
> > If I run 'sudo bridge vlan add vid 1 dev swp4 pvid untagged', then the
> > CPU port starts sending VLAN-tagged traffic. I see this in tcpdump on
> > the DSA master port, but if I tcpdump on swp4, the VLAN tag is removed.
> > Who is doing that?
>
> If vlan.flags = 0, then it does not have either BRIDGE_VLAN_INFO_PVID or
> BRIDGE_VLAN_INFO_UNTAGGED which means the VLAN should be programmed
> tagged on the CPU.
>
> Since swp4 is part of the same VLAN, but has it configured PVID
> untagged, the tag is removed, that sounds about what I would expect to
> see...
> --
> Florian

The VLAN is "egress untagged", and "ingress tagged" (at least so it
becomes with this patch). Of course in tcpdump I was looking for
ingress traffic.
This patch is relying now on __netif_receive_skb_core[1] to remove the
VLAN header from frames as soon as they exit the DSA master and before
they enter the DSA packet_type handler. My point is that even untagged
traffic gets pvid-tagged on ingress, and the net core has to remove
the tag when it previously didn't have to. I'm not sure of other
implications.
Vivien, can't you just unset the PVID flag? Keeping the same
tagged/untagged setting on ingress as on egress does make more sense.

Regards,
-Vladimir

[1]: https://elixir.bootlin.com/linux/latest/source/net/core/dev.c#L4898
