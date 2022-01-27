Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DEC9749DFFC
	for <lists+netdev@lfdr.de>; Thu, 27 Jan 2022 11:59:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239839AbiA0K7y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Jan 2022 05:59:54 -0500
Received: from new2-smtp.messagingengine.com ([66.111.4.224]:38077 "EHLO
        new2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229652AbiA0K7x (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Jan 2022 05:59:53 -0500
Received: from compute2.internal (compute2.nyi.internal [10.202.2.46])
        by mailnew.nyi.internal (Postfix) with ESMTP id DBECD5804F0;
        Thu, 27 Jan 2022 05:59:52 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute2.internal (MEProxy); Thu, 27 Jan 2022 05:59:52 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=cc
        :cc:content-type:date:date:from:from:in-reply-to:in-reply-to
        :message-id:mime-version:references:reply-to:sender:subject
        :subject:to:to; s=fm2; bh=bDcwjJ5ZnieAgtzbO8SLYXhzFo561DMijbQ3uO
        68Syo=; b=Vghcrz6AIsVEe/5xHoue0wq4zQcJRtoP8AV4YwMJtK4yWJv/S+DMOa
        Sk48K7VP9B8vJFD4MlyhR82GCjixwIqnCHd+V/fxUk2HtQSiIpfaZjsM+zY4GOCb
        WR8v/4E3oMRW4PnvYfJ2pmI7iWIWHp19EB3zwxTqgVYgHkbzRJxVFtVThotXVJ6W
        ElrlKHepQcES6YzUHSYWcCyVfsRPH3gQy47onhvTAmz393/AGsj6DstqedEiIsGl
        PZkebfDJm4uh9AmBsjDGF7QIcx2Emi9zRVliqaMFYrV0CrSRcjOR2z0NrP+LfXzQ
        yrLa34W4k5uEEHTK+txO1ibiun72LBWQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-type:date:date:from:from
        :in-reply-to:in-reply-to:message-id:mime-version:references
        :reply-to:sender:subject:subject:to:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=bDcwjJ5ZnieAgtzbO
        8SLYXhzFo561DMijbQ3uO68Syo=; b=j8xcXx9mEPeY4UilV4djb1nzrxayxMGng
        iWH3aEvxWueNH1Ckhz5oDhaCMDPaPNUQj8n1g4hIhtVGOTuUUFxgSnyX9XcDLZLG
        01HfO/8oo//z6WFut33j1diHUc9NPlBnSn9u4Id3nzbG/8zaRfRpwUtJHUrPZP0T
        T1d0n9cuArWY6R0b1hvGwVRUs5ecMR5jy6OpPuEai0yU3E8o9P3GlW/w/GNSfnao
        OP/lOOwLZ8O7uyKSy8hhVUOwN7sk4/dhda2OnG+RAJZS4lRoRuZIWwQQZ9ieTOI1
        pwQeWoLzNOBmXusdaIKnhPbqFg3Ro+1sES9PuBamzc8sSKmu8aujA==
X-ME-Sender: <xms:KHvyYejlFOjLY6qog2DpiDQw3CIEh0gNbQMORKQNYWewFT0v0vv9vw>
    <xme:KHvyYfBvSgGguGXPxTO1HMH6_yBxO5pmRm6Sr2aFrASUSHZKhu8OedgVPGLIII91P
    58hUJKPuATpIw>
X-ME-Received: <xmr:KHvyYWGh47UqAUI3_niellU6rJvfUnD1o-dpI--Zxgmx5Rb5homugfrTQZCUrBUXn948OmtVDiFbeRNu4zoXeLbcpY2Bus5q>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvvddrfeefgddvvdcutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpeffhffvuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepifhrvghgucfm
    jfcuoehgrhgvgheskhhrohgrhhdrtghomheqnecuggftrfgrthhtvghrnhepveeuheejgf
    ffgfeivddukedvkedtleelleeghfeljeeiueeggeevueduudekvdetnecuvehluhhsthgv
    rhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrd
    gtohhm
X-ME-Proxy: <xmx:KHvyYXRIOB0T-n_07CHQZ-tfN0jYsRyWCXUsUkZ1hh12QbOvl7Iq3g>
    <xmx:KHvyYbzVQqFzCZm-10Sc4mb6uymAxtu2jdqlrp0c5s4q6u87a6mTlQ>
    <xmx:KHvyYV6FskfobxngkFVj_feclqTx6FmY7Dw5F0t_aBiR3T7h5gjPzA>
    <xmx:KHvyYcpX0sKVnXpMYDolycMH0dFyVw7x8X0pKlaWaYwCO0YK9meK4Q>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 27 Jan 2022 05:59:51 -0500 (EST)
Date:   Thu, 27 Jan 2022 11:59:49 +0100
From:   Greg KH <greg@kroah.com>
To:     Oleksij Rempel <o.rempel@pengutronix.de>
Cc:     Oliver Neukum <oneukum@suse.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>, kernel@pengutronix.de,
        linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
        netdev@vger.kernel.org, devicetree@vger.kernel.org
Subject: Re: [PATCH net-next v1 1/4] dt-bindings: net: add schema for ASIX
 USB Ethernet controllers
Message-ID: <YfJ7JXrqEEybRLCi@kroah.com>
References: <20220127104905.899341-1-o.rempel@pengutronix.de>
 <20220127104905.899341-2-o.rempel@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220127104905.899341-2-o.rempel@pengutronix.de>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 27, 2022 at 11:49:02AM +0100, Oleksij Rempel wrote:
> Create initial schema for ASIX USB Ethernet controllers and import all
> currently supported USB IDs form drivers/net/usb/asix_devices.c

Again, you are setting yourself to play a game you are always going to
loose and be behind on.  This is not acceptable, sorry.

greg k-h
