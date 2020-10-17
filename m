Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E6D1D2914BD
	for <lists+netdev@lfdr.de>; Sat, 17 Oct 2020 23:36:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2439543AbgJQVf4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 17 Oct 2020 17:35:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59132 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2439535AbgJQVf4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 17 Oct 2020 17:35:56 -0400
Received: from mail-ed1-x542.google.com (mail-ed1-x542.google.com [IPv6:2a00:1450:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 27E58C061755;
        Sat, 17 Oct 2020 14:35:54 -0700 (PDT)
Received: by mail-ed1-x542.google.com with SMTP id t21so6336835eds.6;
        Sat, 17 Oct 2020 14:35:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=JbJ9KB4lg+6PAN8UYVsFa7Ig0sAEIA2xZhtAQfi2Mgk=;
        b=J0Ypt8zCrI8BL3DpBtBpwNfeSZKiT3KNRWFdMAwXR88HdK46KKccQPPkIHNlJwPHVj
         Jxrf0nWADPT9nG3bUcjaFQaJ8AfjyfH4i0fL3NG42J2fdxhG6b4/rWdklw+Z3VFVtzMg
         t60eKcHgzqrzmV6jrodVVzgYCxjhsufFEtSFdzjIWD2Tvo+2PKl/d+dykOnd+QSZP0N0
         L/uG1jCLDNVRmCT3hKBAnpfH+Ds2+CPh5MCvql038EnDz4uvUOnPafhbSUCEmsQs35bD
         6sLTEw06y0XGyqkyZdUHKG7hLmN13R4kVS++p3oWDTCfNkdJ84rC1P5b77qIfrk0fxXv
         SBsA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=JbJ9KB4lg+6PAN8UYVsFa7Ig0sAEIA2xZhtAQfi2Mgk=;
        b=aviGWkXV1S/0eANVOQSHa+vdNQueNnLFmQCv+NAoLeFJxlBtJHv/hRv0eILQWe+/vJ
         gdKTi/U9+OqpI96+g+4CzXV3ZCsYe5vDroanKR9DVN8vcy0Mq+9hiMwC0X1LP8UiY6MF
         T6tOC7MLvfpWTpeNitUcqTsZs1PBELnEYjsi4eYDhXX+IPPrm7ExjvSpx9kasBkMZdH1
         8V9GM9vDVXlsovGC8gi7M71ELsuXif40q4DtcfSCS30CCb79lUVfKz4Wp44sLql/D8GF
         wQYoL5/EDCrMt1pbg+ErKUZiPrgGQcwOQMOzX6uGgAinVp1I+fwt2kT/IlLmL4NKa3gd
         u9Sw==
X-Gm-Message-State: AOAM530FjSGFDLwotrVbXNzjAdITikp47TfvolLrledEbnwkiyI7ARJm
        T0lDYbCASxh4TOVHyhOwuIA=
X-Google-Smtp-Source: ABdhPJyCDt8FZ6YT0Y6yRbwDYJDclmHXmamjetF7NDrjj+jGCRyYSASyTUzbd5FNtF7lVh4Mp20vrQ==
X-Received: by 2002:aa7:dac4:: with SMTP id x4mr10588986eds.165.1602970552294;
        Sat, 17 Oct 2020 14:35:52 -0700 (PDT)
Received: from skbuf ([188.26.174.215])
        by smtp.gmail.com with ESMTPSA id z22sm5916838ejw.107.2020.10.17.14.35.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 17 Oct 2020 14:35:51 -0700 (PDT)
Date:   Sun, 18 Oct 2020 00:35:50 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Christian Eggers <ceggers@arri.de>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        "David S . Miller" <davem@davemloft.net>,
        Woojung Huh <woojung.huh@microchip.com>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next 1/3] net: dsa: don't pass cloned skb's to
 drivers xmit function
Message-ID: <20201017213550.5qgiy7tpydutxkis@skbuf>
References: <20201016200226.23994-1-ceggers@arri.de>
 <2130539.dlFve3NVyK@n95hx1g2>
 <20201017191247.ohslc77wkhbhffym@skbuf>
 <1735006.IpzxAEH60n@n95hx1g2>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1735006.IpzxAEH60n@n95hx1g2>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Oct 17, 2020 at 10:56:24PM +0200, Christian Eggers wrote:
> The status page seems to be out of date:
> http://vger.kernel.org/~davem/net-next.html

Yeah, it can do that sometimes. Extremely rarely, but it happens. But
net-next is still closed, nonetheless.

> The FAQ says: "Do not send new net-next content to netdev...". So there is no
> possibility for code review, is it?

You can always send patches as RFC (Request For Comments). In fact
that's what I'm going to do right now.

> > - Actually I was asking you this because sja1105 PTP no longer works
> >   after this change, due to the change of txflags.
> The tail taggers seem to be immune against this change.

How?

> > Do you want me to try and send a version using pskb_expand_head and you
> > can test if it works for your tail-tagging switch?
> I already wanted to ask... My 2nd try (checking for !skb_cloned()) was already
> sufficient (for me). Hacking linux-net is very interesting, but I have many
> other items open... Testing would be no problem.

Ok, incoming.....

> > I think it would be best to use the unlikely(tail_tag) approach though.
> > The reallocation function should still be in the common code path. Even
> > for a non-1588 switch, there are other code paths that clone packets on
> > TX. For example, the bridge does that, when flooding packets.
> You already mentioned that you don't want to pass cloned packets to the tag
> drivers xmit() functions. I've no experience with the problems caused by
> cloned packets, but would cloned packets work anyway? Or must cloned packets
> not be changed (e.g. by tail-tagging)? Is there any value in first cloning in
> dsa_skb_tx_timestamp() and then unsharing in dsa_slave_xmit a few lines later?
> The issue I currently have only affects a very minor number of packets (cloned
> AND < ETH_ZLEN AND CONFIG_SLOB), so only these packets would need a copying.

Yes, we need to clone and then unshare immediately afterwards because
sja1105_xmit calls sja1105_defer_xmit, which schedules a workqueue. The
sja1105 driver assumes that the skb has already been cloned by then. So
basically, the sja1105 driver introduces a strict ordering requirement
that dsa_skb_tx_timestamp needs to be first, then p->xmit second. So we
necessarily must reallocate freshly cloned skbs, as things stand now.
I'll think about avoiding that, but not now. We were always reallocating
those frames before, using skb_cow_head. The only difference now is that
the skb, as it is passed to the tagger's xmit() function, is directly
writable. You'll see...
