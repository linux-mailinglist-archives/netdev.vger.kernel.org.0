Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0098246C86D
	for <lists+netdev@lfdr.de>; Wed,  8 Dec 2021 01:04:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242683AbhLHAIG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Dec 2021 19:08:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41232 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242662AbhLHAIG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Dec 2021 19:08:06 -0500
Received: from mail-ed1-x52a.google.com (mail-ed1-x52a.google.com [IPv6:2a00:1450:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34FC7C061574;
        Tue,  7 Dec 2021 16:04:35 -0800 (PST)
Received: by mail-ed1-x52a.google.com with SMTP id r11so2310184edd.9;
        Tue, 07 Dec 2021 16:04:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Nmbu3aWG61qILASHvk+hiCDNK64Hsn0LyV/NvnRhWow=;
        b=CnfFs2U9AA1aEyyh1ETJWBowPNHQUwaNC/eVGXX565ZfeJqrg9qwEbm5YFanM/q9El
         jn1czxTI6xYht0qJ/NaWgqcrZau374Zs+vI3o5q0J7kMEXGgAL+fRCKKeA/TV/sc5Fqn
         cbJ8sqJ6lt0lli5t7wIZ2vKONdvagFPt/nTP0GYnfXKMn2Y/JW2Q363Eew4UU3z7U7NS
         6gZ8MaPR+/ZpdZKxINwGD/OZR9yzq5dMMtAuHk7FblleuR3k8vIczFGc1wOvVSQqVrdY
         WR4dVTkXJJNakgwQfJJE8jiCvELNNMolsLyjp++chzB3m7ZGfkx9nOcUUDYgW2/cC3IG
         Ul/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Nmbu3aWG61qILASHvk+hiCDNK64Hsn0LyV/NvnRhWow=;
        b=cx3BDc/28g3VMbdgci8usEcmCFjmMqAVWb9UFaI/0Eie3scobRDSFAQuU5UfZXAaqF
         gv6klwS4lbfORvMKpEVUgKiBo+lzmygg+NfjRamOVfF61wsaMeSh33ADDd2fNxSIX+U0
         bpJ/chwExej4PEnUIJnktumUxbXnJfI3kMG4Xt/MJ1iwdgyo4a3Ih/3anrYSBrfJHKSi
         z/r0ZMnlX8jvfLOmIUFselR3BjRwh8p+y9uo4xhALt4blTXwTmNiHSni3jhxTeIenSbI
         ZVgwAK70j9irMLTeuTr0tfr/BY66u0pvz4F+aP06iYmheWGUaerPqejxgdBa/vCCbpr9
         lg6g==
X-Gm-Message-State: AOAM533HiDBfxhpkGxKHPkVKc8iT9o7Ynd9Q/Pd2lrR3GJ3EbI07gd1r
        X3leViPt7byoiUFUZhBOcWZW4vxP0C4=
X-Google-Smtp-Source: ABdhPJzIeCw9MWX2WjgP6pLZJ9NkxKHO4Xy3P+qJUn2AxCMsv0u3UQaSZ2+1j93nA+BPIy21CSxqgw==
X-Received: by 2002:a17:906:4f05:: with SMTP id t5mr3326379eju.68.1638921873809;
        Tue, 07 Dec 2021 16:04:33 -0800 (PST)
Received: from skbuf ([188.25.173.50])
        by smtp.gmail.com with ESMTPSA id l18sm549876ejo.114.2021.12.07.16.04.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Dec 2021 16:04:33 -0800 (PST)
Date:   Wed, 8 Dec 2021 02:04:32 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Ansuel Smith <ansuelsmth@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [net-next RFC PATCH 0/6] Add support for qca8k mdio rw in
 Ethernet packet
Message-ID: <20211208000432.5nq47bjz3aqjvilp@skbuf>
References: <20211207145942.7444-1-ansuelsmth@gmail.com>
 <Ya+q02HlWsHMYyAe@lunn.ch>
 <61afadb9.1c69fb81.7dfad.19b1@mx.google.com>
 <Ya+yzNDMorw4X9CT@lunn.ch>
 <61afb452.1c69fb81.18c6f.242e@mx.google.com>
 <20211207205219.4eoygea6gey4iurp@skbuf>
 <61afd6a1.1c69fb81.3281e.5fff@mx.google.com>
 <Ya/esX+GTet9PM+D@lunn.ch>
 <20211207234736.vpqurmattqx4a76h@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211207234736.vpqurmattqx4a76h@skbuf>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Dec 08, 2021 at 01:47:36AM +0200, Vladimir Oltean wrote:
> > 2) is harder. But as far as i know, we have an 1:N setup.  One switch
> > driver can use N tag drivers. So we need the switch driver to be sure
> > the tag driver is what it expects. We keep the shared state in the tag
> > driver, so it always has valid data, but when the switch driver wants
> > to get a pointer to it, it needs to pass a enum dsa_tag_protocol and
> > if it does not match, the core should return -EINVAL or similar.
> 
> In my proposal, the tagger will allocate the memory from its side of the
> ->connect() call. So regardless of whether the switch driver side
> connects or not, the memory inside dp->priv is there for the tagger to
> use. The switch can access it or it can ignore it.

I don't think I actually said something useful here.

The goal would be to minimize use of dp->priv inside the switch driver,
outside of the actual ->connect() / ->disconnect() calls.
For example, in the felix driver which supports two tagging protocol
drivers, I think these two methods would be enough, and they would
replace the current felix_port_setup_tagger_data() and
felix_port_teardown_tagger_data() calls.

An additional benefit would be that in ->connect() and ->disconnect() we
get the actual tagging protocol in use. Currently the felix driver lacks
there, because felix_port_setup_tagger_data() just sets dp->priv up
unconditionally for the ocelot-8021q tagging protocol (luckily the
normal ocelot tagger doesn't need dp->priv).

In sja1105 the story is a bit longer, but I believe that can also be
cleaned up to stay within the confines of ->connect()/->disconnect().

So I guess we just need to be careful and push back against dubious use
during review.
