Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 20043328631
	for <lists+netdev@lfdr.de>; Mon,  1 Mar 2021 18:07:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236903AbhCARF4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Mar 2021 12:05:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44146 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232760AbhCARDi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Mar 2021 12:03:38 -0500
Received: from mail-ej1-x62c.google.com (mail-ej1-x62c.google.com [IPv6:2a00:1450:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2EEB3C061788
        for <netdev@vger.kernel.org>; Mon,  1 Mar 2021 09:02:55 -0800 (PST)
Received: by mail-ej1-x62c.google.com with SMTP id ci14so10554838ejc.7
        for <netdev@vger.kernel.org>; Mon, 01 Mar 2021 09:02:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=EjDBM9xXF1jfoh9V4Xf6anBYbGgys+ZHVlpjoCg7d4I=;
        b=k7rrFmXVu5sSdUZl2TVGBOBIa+6oB7OtIXvfoPOaBCM/pFwUYwfbc3T6gdXsy0QcQU
         RsuH74BDtV7CB0aQWSEfTFY/YjYco35YpzwSSQkYcBDxGboZzD/fUYAEDWZaYswaI5W3
         XAroWndOiptSqEhMBRNAT1pc8wGWyRJ7Q57sRMWpBqaSeJNy0ALE/MNAPaEpUAfOwxVM
         6vUjPHnECTQNRtuhYnzlZUWRN5guXFKRyUXDiM2LsJxyU0f0fpD8Ul7fjbB/6Rc1Lxbe
         QJgXb1ikUlxk2NGbiVebfYGtLM30d9gIwoese4NXat2Pd8aq0d8zv5+o3fm6RWy6Kxiz
         9TDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=EjDBM9xXF1jfoh9V4Xf6anBYbGgys+ZHVlpjoCg7d4I=;
        b=HH66a6T8zmLpYHxztbWUFsddcsW141nouAn8yWoONZA2JyQ1IO590xn9MkUpIfQP5E
         Qmr4WBnFRb8CwH2k+7aPdOkq4l44kg2wL6Oo208CZq+4mq+8CKadfUZkaMQKYt/PFALZ
         XG+2W++dnlNG9iCKv0PEAgC7Jdw8Phe5R37GLjLZ4B74TpPPpinD8UulVlCQgJs/Ciax
         7IekS233DupLfkCU0KK3fKmdX6/rydh6GNLeaYTZZoIaGAn3uIQa273tjJVBcBaGThz3
         Gvh6rP0o+cnipfT4Y96pan/3JD/kIU8e1ntZadkxNochXg+qOlLfgu0H8bRtjrqONqEL
         5Gsw==
X-Gm-Message-State: AOAM533kXHBdkU4sDsW+wz4NRhDdvy7O9GovQxM/u8UyUX78yw33M34c
        z5km0bwCJcOyvVn2AX10bXDc0R30q68=
X-Google-Smtp-Source: ABdhPJxKFE3hLZXTnXsTUoUhpIlLTOhQodBBAeWBH1yJSQbGwIc4nZ0hOrjzkDle25kaz2/GsJ+eFw==
X-Received: by 2002:a17:906:4993:: with SMTP id p19mr16812414eju.421.1614618173904;
        Mon, 01 Mar 2021 09:02:53 -0800 (PST)
Received: from skbuf ([188.25.217.13])
        by smtp.gmail.com with ESMTPSA id r5sm14817482ejx.96.2021.03.01.09.02.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Mar 2021 09:02:52 -0800 (PST)
Date:   Mon, 1 Mar 2021 19:02:51 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Markus =?utf-8?Q?Bl=C3=B6chl?= <Markus.Bloechl@ipetronik.com>
Cc:     Michael Walle <michael@walle.cc>, Jakub Kicinski <kuba@kernel.org>,
        "David S . Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandru Marginean <alexandru.marginean@nxp.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: Re: [PATCH v2 net 5/6] net: enetc: don't disable VLAN filtering in
 IFF_PROMISC mode
Message-ID: <20210301170251.wz524j2pv4ahytwo@skbuf>
References: <20210225121835.3864036-6-olteanv@gmail.com>
 <20210226152836.31a0b1bb@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <20210226234244.w7xw7qnpo3skdseb@skbuf>
 <20210226154922.5956512b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <20210227001651.geuv4pt2bxkzuz5d@skbuf>
 <7bb61f7190bebadb9b6281cb02fa103d@walle.cc>
 <20210228224804.2zpenxrkh5vv45ph@skbuf>
 <bfb5a084bfb17f9fdd0ea05ba519441b@walle.cc>
 <20210301150852.ejyouycigwu6o5ht@skbuf>
 <20210301162653.xwfi7qoxdegi66x5@ipetronik.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20210301162653.xwfi7qoxdegi66x5@ipetronik.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Mar 01, 2021 at 05:26:53PM +0100, Markus Blöchl wrote:
> The main problem here could also just be that almost everybody _thinks_
> that promiscuity means receiving all frames and no one is aware of the
> standards definition.
> In fact, I can't blame them, as the standard is hard to come by and not
> enjoyable to read, imho. And all secondary documentation I could find
> on the internet explain promiscuous mode as a "mode of operation" in which
> "the card accepts every Ethernet packet sent on the network" or similar.
> Even libpcap, which I consider the reference on network sniffing, thinks
> that "Promiscuous mode [...] sniffs all traffic on the wire."
> 
> Thus I still think that this issue is also fixable by proper
> documentation of promiscuity.
> At least the meaning and guarantees of IFF_PROMISC in this kernel should
> be clearly defined - in one way or the other - such that users with
> different expectations can be directed there and drivers with different
> behavior can be fixed with that definition as justification.

If Jakub and/or David give us the ACK, I will go ahead and update the
documentation (probably Documentation/networking/netdevices.rst) to
mention what does IFF_PROMISC cover, _separate_ from this series.
