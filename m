Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 991632B558E
	for <lists+netdev@lfdr.de>; Tue, 17 Nov 2020 01:11:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730311AbgKQAKJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Nov 2020 19:10:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50774 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726310AbgKQAKJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Nov 2020 19:10:09 -0500
Received: from mail-ej1-x643.google.com (mail-ej1-x643.google.com [IPv6:2a00:1450:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E9BBEC0613CF;
        Mon, 16 Nov 2020 16:10:08 -0800 (PST)
Received: by mail-ej1-x643.google.com with SMTP id oq3so26937305ejb.7;
        Mon, 16 Nov 2020 16:10:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=ppRstic7XTJh/uf7Jx+jTLo+WvkvrU+CGv1Rj4lms1E=;
        b=pnzqAwtq+jNVH+avp7WBMiZCJdeqcm33mxvm1datyN/7pceATheh1NiqhSNVIoUfFo
         b8gS+XsZttCOaNiapOq3IITRTgPJ5Apgu411g+b8pDT4PgcIWqVMga1aKrPJMWllbsQY
         onWtZ95q6yFpeQw5q5ES1n8mCFMT8lWuNb/A3p9ustK0ZXofrwhRB1E0GLFSFCce26hs
         Ex0i1WQOYngclSPkfOL4GOcr6JesI/vR5diq13t+gmTgW9a9raELCI6ebqJ3TvkZLB+G
         mLLHHqLmRvgysoNC+gUFuebUrMWlauh24+gaFDpcn92Wg0od1Hbn8Br/DiqA0yj/JNQC
         2J+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=ppRstic7XTJh/uf7Jx+jTLo+WvkvrU+CGv1Rj4lms1E=;
        b=mWUWRAuq1DuxjQNHpKYJFmX/pmfltt4rALOB1YkbwX6KXkVrCYQAXz+9KG4c8gsmbk
         jPM4VkM/EO30SEqwsRz9wI46xMf8B5TpPFRIdNEVrmNCnRmYzMJayVCEF06ISFSN7BVE
         xeawAV5bM5M4hjfvvwATowzirECWLhMvpZgkesi4m+mTLaW5RTj2b6p2unxdjTciPFvw
         zI0Qw0Hrk/1uDPYF0I2tfnnQpzNpqdrNB6HIOrxt58JOaw0KFRUilz8saReFj9ciWuoj
         qf4RHzm0nDisob4kYUE/XFYNiYV+k/LJcIJL4GJxBmuoXhIvLmB6wfqbg0pn9P8OOzFA
         fvYw==
X-Gm-Message-State: AOAM531C6QArKewAxyKLLoziV7OFGeicBKCYxR1dheg48yeUx9SzliNz
        wSzxRVaDhZMNiXPlQTx6UoM=
X-Google-Smtp-Source: ABdhPJzrKJgrdSR+WNmGn4P1hSccyf2PomTB6p98NH9gAwmgdJYqhEPQxP/B3GI5vBW1Upw6XrBOAg==
X-Received: by 2002:a17:906:50e:: with SMTP id j14mr16850435eja.403.1605571807672;
        Mon, 16 Nov 2020 16:10:07 -0800 (PST)
Received: from skbuf ([188.25.2.177])
        by smtp.gmail.com with ESMTPSA id cn8sm11112845edb.18.2020.11.16.16.10.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Nov 2020 16:10:07 -0800 (PST)
Date:   Tue, 17 Nov 2020 02:10:05 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Oleksij Rempel <o.rempel@pengutronix.de>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Russell King <linux@armlinux.org.uk>,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mips@vger.kernel.org
Subject: Re: [PATCH v1 net-next] net: dsa: qca: ar9331: add ethtool stats
 support
Message-ID: <20201117001005.b7o7fytd2stawrm7@skbuf>
References: <20201115073533.1366-1-o.rempel@pengutronix.de>
 <20201116133453.270b8db5@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <20201116222146.znetv5u2q2q2vk2j@skbuf>
 <20201116143544.036baf58@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <20201116230053.ddub7p6lvvszz7ic@skbuf>
 <20201116151347.591925ca@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <20201116232731.4utpige7fguzghsi@skbuf>
 <7cb26c4f-0c5d-0e08-5bbe-676f5d66a858@gmail.com>
 <20201116160213.3de5280c@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201116160213.3de5280c@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 16, 2020 at 04:02:13PM -0800, Jakub Kicinski wrote:
> For a while now we have been pushing back on stats which have a proper
> interface to be added to ethtool -S. So I'd expect the list of stats
> exposed via ethtool will end up being shorter than in this patch.

Hmm, not sure if that's ever going to be the case. Even with drivers
that are going to expose standardized forms of counters, I'm not sure
it's going to be nice to remove them from ethtool -S. Testing teams all
over the world have scripts that grep for those. Unfortunately I think
ethtool -S will always remain a dumping ground of hell, and the place
where you search for a counter based on its name from the hardware block
guide as opposed to its standardized name/function. And that might mean
there's no reason to not accept Oleksij's patch right away. Even if he
might volunteer to actually follow up with a patch where he exposes the
.ndo_get_stats64 from DSA towards drivers, as well as implements
.ndo_has_offload_stats and .ndo_get_offload_stats within DSA, that will
most likely be done as separate patches to this one, and not change in
any way how this patch looks.
