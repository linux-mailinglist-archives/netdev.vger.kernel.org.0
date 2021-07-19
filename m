Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D473F3CCEB1
	for <lists+netdev@lfdr.de>; Mon, 19 Jul 2021 09:42:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234806AbhGSHow (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Jul 2021 03:44:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51526 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233759AbhGSHow (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Jul 2021 03:44:52 -0400
Received: from mail-ej1-x636.google.com (mail-ej1-x636.google.com [IPv6:2a00:1450:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F3FD6C061762
        for <netdev@vger.kernel.org>; Mon, 19 Jul 2021 00:41:51 -0700 (PDT)
Received: by mail-ej1-x636.google.com with SMTP id hc15so27107243ejc.4
        for <netdev@vger.kernel.org>; Mon, 19 Jul 2021 00:41:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=CorYWTYS+AZSVl2A6eCbkMb9gbO0BA3m9gMbqC/pL4k=;
        b=kpdTDoEnwi54KR6A65rYlFI4JLgphFiQMz8WR15BXIM8F/Jz5Frc/Hnk77CxAUCi+W
         Pt1Z1xWy/Od95f4IINaC8d2nHz8GemWFzxFuO5uHqGUsM/W8ejBJzJbHcWJGSFBwADo2
         IfRZnaq0YL37YWhWrcUt+fEqa/D5+BMDNP8oNDY5y2TQR/w3VqheUPwvRlNQFMlDr6k8
         kl+aqtQ7SpuoQRiQXlejWIQNjMIcIAmA8OQugmLCvrNsIXv9WFuYQPyz4ecB5ISTsHBZ
         oJw+dA+Wo4O86rO7/WV8vPdaCacvmwwNtTidTHKM8XZ+X7zNLcUi3x3DlWqGiXdrexnW
         wqcA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=CorYWTYS+AZSVl2A6eCbkMb9gbO0BA3m9gMbqC/pL4k=;
        b=EkXycNXlor1QNn+EK8X1FtbzcFXZ4EJpWyVooyCnGWjyL9tYZArbFaR5lD76l9KF5Q
         /TYxCCPQyUm+a413PB+4O6naZ3eTC2nyrerrc2rOm/rZOsM2W/JLB5NVTJj1NABUBzjI
         QcA4aMZyAqZGCG850p5kiOKOj1EBLMU1J8ab8vMUm29EhmTWfJbGfVMHgJQDZ1SL8XhY
         2ovJyZmgMJmPTtViEFPsQSbYCUICm5+cJK+q1YU8BLxPjUGY/vZKfEACqPQCFEPPcgjb
         Zd9GRTsDs5yhxNzd4zVBM1GTGZJtTLjwBY023S++1ORwgviDAES65hNQF8fkRinbCi41
         5Y6A==
X-Gm-Message-State: AOAM5318SKtq/5/YGvZEM9S5GYdamMBKD5afhkaLeUVlY+IZ7PbXnY/o
        U2FXjhZ0FoOWkAgk1l6hal0+fKh6JIw=
X-Google-Smtp-Source: ABdhPJxB3xCTIGOQlGeNrCtpdZ1wJe/NXomir2ZJqQ5j3mnJrJpXgbuelyjgfZCNtqQIAhHzjc4kjA==
X-Received: by 2002:a17:907:97c9:: with SMTP id js9mr26102224ejc.109.1626680510348;
        Mon, 19 Jul 2021 00:41:50 -0700 (PDT)
Received: from skbuf ([82.76.66.29])
        by smtp.gmail.com with ESMTPSA id o23sm5570846ejc.124.2021.07.19.00.41.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Jul 2021 00:41:50 -0700 (PDT)
Date:   Mon, 19 Jul 2021 10:41:48 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     Vladimir Oltean <vladimir.oltean@nxp.com>, netdev@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Ido Schimmel <idosch@idosch.org>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        bridge@lists.linux-foundation.org,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Marek Behun <kabel@blackhole.sk>,
        DENG Qingfang <dqfext@gmail.com>
Subject: Re: [PATCH v4 net-next 15/15] net: dsa: tag_dsa: offload the bridge
 forwarding process
Message-ID: <20210719074148.xlm7syfm76fuzsxy@skbuf>
References: <20210718214434.3938850-1-vladimir.oltean@nxp.com>
 <20210718214434.3938850-16-vladimir.oltean@nxp.com>
 <7c2b81e8-db72-4665-fe81-7254cba1e797@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7c2b81e8-db72-4665-fe81-7254cba1e797@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Jul 18, 2021 at 07:47:22PM -0700, Florian Fainelli wrote:
> On 7/18/2021 2:44 PM, Vladimir Oltean wrote:
> > From: Tobias Waldekranz <tobias@waldekranz.com>
> >
> > Allow the DSA tagger to generate FORWARD frames for offloaded skbs
> > sent from a bridge that we offload, allowing the switch to handle any
> > frame replication that may be required. This also means that source
> > address learning takes place on packets sent from the CPU, meaning
> > that return traffic no longer needs to be flooded as unknown unicast.
> >
> > Signed-off-by: Tobias Waldekranz <tobias@waldekranz.com>
> > Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
>
> This looks pretty complicated to but if this is how it has to work, it has
> to. For tag_brcm.c we can simply indicate that the frame to be transmitted
> should have a specific bitmask of egress ports.

Complicated in the sense that we need to nail the VLAN ID so that
the FDB / MDB is looked up correctly by the accelerator, to ensure that
it produces a result that is in sync with the software tables?

What you are proposing is not really TX forwarding offload but TX
replication offload. A CPU-injected packet targeting multiple egress
ports is still a control plane packet nonetheless, with all features
that characterize one:
- Ingress stage of the CPU port is bypassed (no hardware address
  learning for that MAC SA)
- FDB lookup is bypassed (we trust the software). This is also perhaps
  an advantage, because for example, if we have a MAC address learned
  towards the CPU port, and then we inject a packet from the CPU towards
  that destination MAC address, then a data plane packet would be
  dropped due to source port pruning (source == destination port), but a
  control plane packet would be sent regardless.
- Can inject into a BLOCKING egress port (we trust the software not to
  do that)

Whereas this patch set is really about laying the ground for data plane
packets to be safely created and sent by the network stack. There are
switches which have a clear distinction between the control plane and
the data plane, and injecting a control packet is a fairly expensive
operation. So it would be very good to support this operating mode,
regardless of whatever else we do.

I can look into adding support for your use case with just the
replication offload, since it should be possible nonetheless, and if you
really don't have the option to send a data plane packet then it is a
valid approach too, however I believe that the brick wall will be where
to encode the destination bit mask in the egress skb. For the full TX
forwarding offload we managed to dodge that because we already had
skb->offload_fwd_mark, but that's just one bit and we would need more.
I'm thinking we would need to add another bit (skb->offload_tx_replication)
and then add a struct list_head tx_dev to the skb which contains all the
net devices that the packet was not cloned to?
