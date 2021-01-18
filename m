Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9EA0C2FAC33
	for <lists+netdev@lfdr.de>; Mon, 18 Jan 2021 22:07:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2394491AbhARVFQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Jan 2021 16:05:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54532 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2394442AbhARVEY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Jan 2021 16:04:24 -0500
Received: from mail-ej1-x634.google.com (mail-ej1-x634.google.com [IPv6:2a00:1450:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2527AC061575
        for <netdev@vger.kernel.org>; Mon, 18 Jan 2021 13:03:44 -0800 (PST)
Received: by mail-ej1-x634.google.com with SMTP id gx5so6327221ejb.7
        for <netdev@vger.kernel.org>; Mon, 18 Jan 2021 13:03:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=0jrE2ur+mtWu2SZ+d5ibw4+aCf7TfoaOlEZ6nboHVOw=;
        b=BzGJ9ejWl99JGUXk78iWCqbEC7RAV00+E/wtUj2DSZmUR7vKXRsPEY9loewPS3RtXh
         kZU2Ejz/x1eUyvQ1ETDjZrAfIZhiqf59qxsAM7u2S+rpXogrcVdd3a4Szd2fp4wF4dLV
         FaTFqrDcU29iQQGPLvWo4KGawor50ZfsYRodj8Co+fwPCOFuBsjHl/OiVwn79ao2PV/B
         O57Xj5i4BYErM2ywimKvN5hD4osTPQ96AImdT5lLUiM8Ipo9Y9To3Gc4+v8WK9ODG4ex
         H6Ve39xmoOgyPXVAnsYOF+I3gOHCQmCGQPVQrMlmUT4BzO4Xe09QE4Lr75x/ouXNgSBS
         NHIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=0jrE2ur+mtWu2SZ+d5ibw4+aCf7TfoaOlEZ6nboHVOw=;
        b=MhDw8rFnhycxwpq4aRfso+ARlx4vrjmnbj0ddZmKRCBQOwX4D/d8pRsYG1mvPmKaYL
         IJtfk5koirtAOVnRpDcSriCskgxUULvyYNkNsCVP1aUEcN2k8VYgIbhLqAdwDiZiiAWQ
         238qtbkdp1jIzPRPYtcnhILPz9i8jajwcXsfotBQDW+E7s7ST95Sm7TUWe9splzB8qVk
         be3qhdnvh+xC7xHqXv1fWPMCiH9kqNR9T4VMe8AS8mqa2136d4F2Hf02Id2ca7BmCPDW
         7p7fgy6adleLTbpgfZMgSgQD9ely6zVdiIiBAbf/IvXIZELl1JzsJzY4j6FSqLDNOFZh
         zcWw==
X-Gm-Message-State: AOAM531emgMxMJ7lgBo4AlG3Z53ekjpFo+aXR9gn5XEbco5WiVSm19pN
        SvHw/mpM9I898/6Xu37jUp4=
X-Google-Smtp-Source: ABdhPJwm7+Jh2nqtIg7VFpNxe3N4pQUlSM5FUsaChU5zMVl0KYwL3R6nJJNmQAQFbHQYQ95ZNCQB7A==
X-Received: by 2002:a17:906:3c04:: with SMTP id h4mr971562ejg.51.1611003822828;
        Mon, 18 Jan 2021 13:03:42 -0800 (PST)
Received: from skbuf (5-12-227-87.residential.rdsnet.ro. [5.12.227.87])
        by smtp.gmail.com with ESMTPSA id q20sm9892558eju.1.2021.01.18.13.03.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Jan 2021 13:03:42 -0800 (PST)
Date:   Mon, 18 Jan 2021 23:03:40 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Tobias Waldekranz <tobias@waldekranz.com>
Cc:     davem@davemloft.net, kuba@kernel.org, andrew@lunn.ch,
        vivien.didelot@gmail.com, f.fainelli@gmail.com, roopa@nvidia.com,
        nikolay@nvidia.com, netdev@vger.kernel.org, jiri@resnulli.us,
        idosch@idosch.org, stephen@networkplumber.org
Subject: Re: [RFC net-next 2/7] net: bridge: switchdev: Include local flag in
 FDB notifications
Message-ID: <20210118210340.5nlr4bq32nssvhvz@skbuf>
References: <20210116012515.3152-1-tobias@waldekranz.com>
 <20210116012515.3152-3-tobias@waldekranz.com>
 <20210117193009.io3nungdwuzmo5f7@skbuf>
 <87turejclo.fsf@waldekranz.com>
 <20210118192757.xpb4ad2af2xpetx3@skbuf>
 <87o8hmj8w0.fsf@waldekranz.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87o8hmj8w0.fsf@waldekranz.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jan 18, 2021 at 09:19:11PM +0100, Tobias Waldekranz wrote:
> > My only hope is that we could just offload the entries pointing towards
> > br0, and ignore the local ones.
> 
> That was my initial approach. Unfortunately that breaks down when the
> bridge inherits its address from a port, i.e. the default case.
> 
> When the address is added to the bridge (fdb->dst == NULL), fdb_insert
> will find the previous local entry that is set on the port and bail out
> before sending a notification:
> 
> 	if (fdb) {
> 		/* it is okay to have multiple ports with same
> 		 * address, just use the first one.
> 		 */
> 		if (test_bit(BR_FDB_LOCAL, &fdb->flags))
> 			return 0;
> 		br_warn(br, "adding interface %s with same address as a received packet (addr:%pM, vlan:%u)\n",
> 		       source ? source->dev->name : br->dev->name, addr, vid);
> 		fdb_delete(br, fdb, true);
> 	}
> 
> You could change this so that a notification always is sent out. Or you
> could give precedence to !fdb->dst and update the existing entry.

I'm afraid my competence ends here.
IMO the problem is really the struct net_bridge_port *source argument of
fdb_insert. The behavior we want is that all is_local FDB entries are
coming from br0, and none from the brports (aka source == NULL, so the
callers that had something non-NULL for source should be deleted).
"You can't always get what you want" though.

> > But for that I would need the bridge maintainers to clarify what is
> > the difference between then, as I asked in your other patch.
> 
> I am pretty sure they mean the same thing, I believe that !fdb->dst
> implies is_local. It is just that "bridge fdb add ADDR dev br0 self" is
> a new(er) thing, and before that there was "local" entries on ports.
> Maybe I should try to get rid of the local flag in the bridge first, and
> then come back to this problem once that is done? Either way, I agree
> that 5/7 is all we want to add to DSA to get this working.

Please expand on what you plan to do. The is_local bit is part of the
bridge UAPI, how do you plan to get rid of it?
