Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 92A76178240
	for <lists+netdev@lfdr.de>; Tue,  3 Mar 2020 20:03:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730374AbgCCSQG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Mar 2020 13:16:06 -0500
Received: from mail-pj1-f66.google.com ([209.85.216.66]:35642 "EHLO
        mail-pj1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728356AbgCCSQG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Mar 2020 13:16:06 -0500
Received: by mail-pj1-f66.google.com with SMTP id s8so1711260pjq.0
        for <netdev@vger.kernel.org>; Tue, 03 Mar 2020 10:16:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=ruArnbJCT8hQLQ9obT6z9WhWQuzOUk//DHi9CZRORvc=;
        b=QO2HJvSwZJaX8uUsss5zt04eWnxN5aLLT9Hu5Oazg/2WsW35O9uiLOj12X3luBeNuN
         APnFUirYvKkz7byZkeCNe6pQi0MuHcPgMOUm0MvBIhNqKk979ZQi0QzmQxE1jEqF5uFB
         uAD5c/6F/VFX0dZ/JPGElouJf52jf0qGOhe2YaSlFoov1gGAiUK2opnMfPV0FpV7X13p
         Bu9ah3OcejHiaU8whOABGSi8CuhY4u2Z8mlCLPue8JKO9RU6tlkBdX5MH6Qap/mFNw8d
         TJupLL4b9r+H3jwhoWNCbRXBJdYyqAL9k6CI14kXNCxUfjvoOg2slk8FhqxNWuc2PVUw
         Lang==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=ruArnbJCT8hQLQ9obT6z9WhWQuzOUk//DHi9CZRORvc=;
        b=hU9tbtWJ49LL6tNa+a/KsYCWQ72Hn9h5Ip3/Qg9K4bjm4oam9jl+np6hu26JbiW4AS
         2i+luFx5q3Hm9fHa74te0dR9TjfZoaDGx3ZuRpeOe5757Dr5Vb9iqHdOx/5FSz3LG6Dz
         KpanqqKeKQQ+v4YDnHYckEJUs5XK1oH1GjRQ2BqOYRjUHpdRbsMVnOS54Myb2GgRk0ma
         R9ZQlOkLIEYksU18ixGod54L4Z9xGCtWp7Ai2k4haMd1c9+u4U76FswTMTP3f9oe8JoL
         EbkN5RFY7r065aMtOw/IytbWw57BgDN5D0IGuKYu7/KqqJXkRE8xdH6KbJN2w9zSJ++o
         o6IQ==
X-Gm-Message-State: ANhLgQ2/1eXuHD6dFzMPaVV8+HPQrflScyCAXgw0aYprALU1JYIO1zw8
        m2DsZeazAnPKSiXlFg2oo8xpZZCa
X-Google-Smtp-Source: ADFU+vuSw7ovqGdcVfmN9X3nMGrrIDQXzH6rfnGRIKpIJGGzYTOrBwodzFOnk0cEZLXLilgCGSUs9Q==
X-Received: by 2002:a17:902:7612:: with SMTP id k18mr1414394pll.247.1583259364989;
        Tue, 03 Mar 2020 10:16:04 -0800 (PST)
Received: from ast-mbp ([2620:10d:c090:500::4:a0de])
        by smtp.gmail.com with ESMTPSA id z3sm3401039pjr.46.2020.03.03.10.16.02
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 03 Mar 2020 10:16:04 -0800 (PST)
Date:   Tue, 3 Mar 2020 10:16:01 -0800
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     David Ahern <dahern@digitalocean.com>
Cc:     David Ahern <dsahern@kernel.org>, netdev@vger.kernel.org,
        davem@davemloft.net, kuba@kernel.org,
        prashantbhole.linux@gmail.com, jasowang@redhat.com,
        brouer@redhat.com, toke@redhat.com, mst@redhat.com,
        toshiaki.makita1@gmail.com, daniel@iogearbox.net,
        john.fastabend@gmail.com, ast@kernel.org, kafai@fb.com,
        songliubraving@fb.com, yhs@fb.com, andriin@fb.com,
        dsahern@gmail.com
Subject: Re: [PATCH RFC v4 bpf-next 09/11] tun: Support xdp in the Tx path
 for xdp_frames
Message-ID: <20200303181559.7xzzyvyy72od4tte@ast-mbp>
References: <20200227032013.12385-1-dsahern@kernel.org>
 <20200227032013.12385-10-dsahern@kernel.org>
 <20200302183040.tgnrg6tkblrjwsqj@ast-mbp>
 <318c0a44-b540-1c7f-9667-c01da5a8ac73@digitalocean.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <318c0a44-b540-1c7f-9667-c01da5a8ac73@digitalocean.com>
User-Agent: NeoMutt/20180223
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Mar 02, 2020 at 09:27:08PM -0700, David Ahern wrote:
> > 
> > I'm worried that XDP_TX is a silent alias to XDP_PASS.
> > What were the reasons to go with this approach?
> 
> As I stated in the cover letter:
> 
> "XDP_TX on Rx means send the packet out the device it arrived
> on; given that, XDP_Tx for the Tx path is treated as equivalent to
> XDP_PASS - ie., continue on the Tx path."

I saw that, but it states the behavior and doesn't answer my "why" question.

> > imo it's less error prone and extensible to warn on XDP_TX.
> > Which will mean that both XDP_TX and XDP_REDICT are not supported for egress atm.
> 
> I personally don't care either way; I was going with the simplest
> concept from a user perspective.

That's not a good sign when uapi is designed as "dont care either way".

> > 
> > Patches 8 and 9 cover tun only. I'd like to see egress hook to be implemented
> > in at least one physical NIC. Pick any hw. Something that handles real frames.
> > Adding this hook to virtual NIC is easy, but it doesn't demonstrate design
> > trade-offs one would need to think through by adding egress hook to physical
> > nic. That's why I think it's mandatory to have it as part of the patch set.
> > 
> > Patch 11 exposes egress to samples/bpf. It's nice, but without selftests it's
> > no go. All new features must be exercised as part of selftests/bpf.
> 
> Patches that exercise the rtnetlink uapi are fairly easy to do on single
> node; anything traffic related requires multiple nodes or namespace
> level capabilities.  Unless I am missing something that is why all
> current XDP tests ride on top of veth; veth changes are not part of this
> set.
> 
> So to be clear you are saying that all new XDP features require patches
> to a h/w nic, veth and whatever the author really cares about before new
> features like this go in?

I didn't say 'veth'. I really meant 'physical nic'.
The patch set implies that XDP_EGRESS is a generic concept and applicable to
physical and virtual netdevs. There is an implementation for tun. But reading
between the lines I don't see that api was thought through on the physical nic.
Hence I'm requesting to see the patches that implement it. When you'll try to
add xdp_egress to a physical nic I suspect there will be challenges that will
force changes to xdp_egress api and I want that to happen before uapi lands in
the tree and becomes frozen.
