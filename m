Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 221AC3050F4
	for <lists+netdev@lfdr.de>; Wed, 27 Jan 2021 05:34:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239165AbhA0Ec3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Jan 2021 23:32:29 -0500
Received: from mail.kernel.org ([198.145.29.99]:58332 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232438AbhA0DDo (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 26 Jan 2021 22:03:44 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 04B8820639;
        Wed, 27 Jan 2021 02:25:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611714334;
        bh=l+UtnEk9NZADkqnwaQDcJHM4nZ3DDaQzpJK3tX454F4=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=inQK+CUDy79hyiiawvC6uK526DQrUuRtlGFSr14AEEhpbR5j3UEUG6WzI1FSlsLM+
         PW78Ui1zOFdSscXDjFdgLsscDWKkMcFDLIV6Ywf6SRQXDCV/BCjNJZ9XmQvEOkzg0Q
         /AAlsBwJoMXz2PJ8Qzo9WW0ax6gsOMe2vvDN8IG9GfqGfz+hHHOUabit9i6dxGiVuG
         vEq/oIUiOf8JC+YDRLrZDoDFEFYfYtf4gOMsx9wH/eLkhkmxkXmGsLuKaDh9WylERm
         eIteytm6tG53nG4ALSL2iC0Paq8d3IGNnxH7IN1JTq8aiOYtwmEB0y7CUJ1nLUCvTk
         Ca8QmGmN7pHYw==
Date:   Tue, 26 Jan 2021 18:25:33 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Laurent Badel <laurentbadel@eaton.com>
Cc:     Fugang Duan <fugang.duan@nxp.com>,
        "David S . Miller" <davem@davemloft.net>,
        Liam Girdwood <lgirdwood@gmail.com>,
        Mark Brown <broonie@kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 net 1/1] net: fec: Fix temporary RMII clock reset on
 link up
Message-ID: <20210126182533.17ab52a9@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210125100745.5090-2-laurentbadel@eaton.com>
References: <20210125100745.5090-1-laurentbadel@eaton.com>
        <20210125100745.5090-2-laurentbadel@eaton.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 25 Jan 2021 11:07:45 +0100 Laurent Badel wrote:
> =EF=BB=BFfec_restart() does a hard reset of the MAC module when the link =
status
> changes to up. This temporarily resets the R_CNTRL register which controls
> the MII mode of the ENET_OUT clock. In the case of RMII, the clock
> frequency momentarily drops from 50MHz to 25MHz until the register is
> reconfigured. Some link partners do not tolerate this glitch and
> invalidate the link causing failure to establish a stable link when using
> PHY polling mode. Since as per IEEE802.11 the criteria for link validity

I think you meant 802.3, fixed that up and applied, thanks!

> are PHY-specific, what the partner should tolerate cannot be assumed, so
> avoid resetting the MII clock by using software reset instead of hardware
> reset when the link is up. This is generally relevant only if the SoC
> provides the clock to an external PHY and the PHY is configured for RMII.

