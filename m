Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BC9B73BBAA0
	for <lists+netdev@lfdr.de>; Mon,  5 Jul 2021 11:57:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230461AbhGEKAN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Jul 2021 06:00:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48212 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230438AbhGEKAJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Jul 2021 06:00:09 -0400
Received: from mail-ej1-x62a.google.com (mail-ej1-x62a.google.com [IPv6:2a00:1450:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 22896C061574
        for <netdev@vger.kernel.org>; Mon,  5 Jul 2021 02:57:31 -0700 (PDT)
Received: by mail-ej1-x62a.google.com with SMTP id o5so28313729ejy.7
        for <netdev@vger.kernel.org>; Mon, 05 Jul 2021 02:57:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=UywVHfIXA8Il15KCHtfEgZv5xfnhEZ34vLyTargXKlk=;
        b=TkeqJE48gZCnOXcVOxTCrulvm2g32F0N95QRYIoHW8IUD1AEDNjNqxLopGWCXJc9vH
         Bs8lRfpcJpieitfTEOJ86r1RIsZqRRaiPMWTTYQougcp2aFv0I0cArcZOK0J+CzoE56M
         aUxSqECi9itQJP1u61fNWMplURkFXuG3W2YIyNPMBVh9aQ4Wbo5b2WYx3k2r+XSEct5e
         Z2SGaeTIxGNX/AdHR7PqPmobVQUolTpkNPpCPC0h8opJGonwl1af9yDM0t54/LaJmz0W
         ty27zSlpkch6V65rdOaEF6cTEjWMpcZ8tKQmkfpq+wtU7ueoxoxB6tHQY28JYNEWpXKW
         1QAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=UywVHfIXA8Il15KCHtfEgZv5xfnhEZ34vLyTargXKlk=;
        b=RsUEWxKoZCIjP4F5ZQombstcARu1c0LThzP9vtiwzVwEq1/vjnFU8A8gea/9hST/Kg
         BFKXZObkciWNLeO0X+m4yA0DtTMyWmMXtKjTlEqfEOjUUaUStrZAne2590PhseHxbAgo
         DUClMMmEEL/d4P9fLH4y4FyM0K1HpfgWOgpjYx5f/LEluFqOtwcIYGb9oqvVk+K/L/3x
         B2RP7TlsZLCSStCeeYYtnVgz+lWZe7/GEkp6hlKGsmXYAvtuiPJR+dL9PUy/t6Z2RRpd
         pURD1oKpGS9SGVfto6CoZRZjpClJeuu2MerXQO/oXKVOkK5Ll39+NRNWb9q5SHZ2XmjO
         Pd2w==
X-Gm-Message-State: AOAM530GZfxdSTpDHqdfzz2umZNUn+J77++ajNA2eOTR+V65HAhDztAE
        A9aa5M23lalPDgxC4vDKv40=
X-Google-Smtp-Source: ABdhPJzLp/vyjce7xVcMJsWfJpmfULAy25MDSrrAaO9oSanq+e597oeQJw7jLVzGFCqDX2T8DKfbCg==
X-Received: by 2002:a17:907:94c4:: with SMTP id dn4mr12276614ejc.363.1625479049653;
        Mon, 05 Jul 2021 02:57:29 -0700 (PDT)
Received: from skbuf ([188.26.224.68])
        by smtp.gmail.com with ESMTPSA id p23sm5139087edt.71.2021.07.05.02.57.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 Jul 2021 02:57:29 -0700 (PDT)
Date:   Mon, 5 Jul 2021 12:57:27 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Tobias Waldekranz <tobias@waldekranz.com>
Cc:     DENG Qingfang <dqfext@gmail.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Ido Schimmel <idosch@idosch.org>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        bridge@lists.linux-foundation.org,
        Alexander Duyck <alexander.duyck@gmail.com>
Subject: Re: [RFC PATCH v2 net-next 00/10] Allow forwarding for the software
 bridge data path to be offloaded to capable devices
Message-ID: <20210705095727.w7iigb3goaorzef5@skbuf>
References: <20210703115705.1034112-1-vladimir.oltean@nxp.com>
 <20210705042018.137390-1-dqfext@gmail.com>
 <87v95p6u0r.fsf@waldekranz.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87v95p6u0r.fsf@waldekranz.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jul 05, 2021 at 10:32:04AM +0200, Tobias Waldekranz wrote:
> > Many DSA taggers use port bit field in their TX tags, which allows
> > replication in hardware. (multiple bits set = send to multiple ports)
> > I wonder if the tagger API can be updated to support this.
>
> I think you could, but it would be tricky.
>
> The bridge does not operate using vectors/bitfields, rather it is
> procedural code that you have to loop through before knowing the set of
> destination ports.
>
> This series just sends the skb to the first port in the hardware domain
> and trusts the HW to calculate the same port set as the code in
> br_forward.c would have.
>
> To do what you suggest, the bridge would have to translate each nbp into
> a position in a bitfield (or call out to the underlying driver to do it)
> as it is looping through ports, then send the aggregated mask along with
> the skb. Knowing if a port is the first one you have come across for a
> given domain is very easy (just maintain a bitfield), knowing if it is
> the last one is harder. So you would likely end up having to queue up
> the actual transmission until after the loop has been executed, which
> hard to combine with the "lazy cloning" that you really want to get
> decent performance.

In addition to changing the bridge in order to get the entire bit mask,
one also has to somehow propagate that bit mask per skb down to the
driver which might be tricky in itself. There is currently no bridge
specific data structure passed between the bridge and the switchdev
driver, it is just the struct net_device *sb_dev. A hacky solution I
might imagine is for the bridge to kzalloc() a small data structure
like:

struct bridge_fwd_offload_accel_priv {
	struct net_device *sb_dev; /* Must be first! */
	unsigned long port_mask;
};

and call as follows:

int br_dev_queue_push_xmit(struct net *net, struct sock *sk, struct sk_buff *skb)
{
	struct bridge_fwd_offload_accel_priv *accel_priv = NULL;

	if (br_switchdev_accels_skb(skb)) {
		accel_priv = kzalloc(sizeof(*accel_priv), GFP_ATOMIC);
		if (!accel_priv)
			return -ENOMEM;

		accel_priv->sb_dev = BR_INPUT_SKB_CB(skb)->brdev;
		accel_priv->port_mask = port_mask;
	}

	dev_queue_xmit_accel(skb, accel_priv);
}

This way, the code in net/core/dev.c can be left unmodified. We give it
an accel_priv pointer but it can think it is only looking at a sb_dev
pointer, since that is the first element in the structure.

But then the switchdev driver must kfree(accel_priv) in the xmit function.

Not really nice, but for a cuter solution, I think we would need to extend struct sk_buff.
