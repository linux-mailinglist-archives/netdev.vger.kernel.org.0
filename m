Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CB3A51BC75E
	for <lists+netdev@lfdr.de>; Tue, 28 Apr 2020 20:01:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728550AbgD1SBw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Apr 2020 14:01:52 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:57612 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728023AbgD1SBq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 28 Apr 2020 14:01:46 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=S+zv5V8pEKl7jEv6i1WNUlxnbRwh2XNMJgQW8R3h33M=; b=ObH8Xw93wBjCJDAOZ9S3BP0lnq
        hrjI1PvO0sPHmRLUvyVYtzsOXzu6fcK4xAJgo63cr3N5+g7oaeKIs4EVCfmEhxrxs6HzYci1xwy0r
        dyPFa5dLda0fXBe/8r1zpvdhi38sDl500/stMt0Rv7kdThiz3JBkrT4VRyT1V4rvQthA=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1jTUYC-0007z5-KH; Tue, 28 Apr 2020 20:01:44 +0200
Date:   Tue, 28 Apr 2020 20:01:44 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Andy Duan <fugang.duan@nxp.com>
Cc:     netdev <netdev@vger.kernel.org>, Chris Healy <cphealy@gmail.com>,
        Andy Duan <fugang.duan@nxp.com>,
        Leonard Crestez <leonard.crestez@nxp.com>
Subject: Re: [PATCH net-next] net: ethernet: fec: Prevent MII event after
 MII_SPEED write
Message-ID: <20200428180144.GA30612@lunn.ch>
References: <20200428175833.30517-1-andrew@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200428175833.30517-1-andrew@lunn.ch>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 28, 2020 at 07:58:33PM +0200, Andrew Lunn wrote:
> The change to polled IO for MDIO completion assumes that MII events
> are only generated for MDIO transactions. However on some SoCs writing
> to the MII_SPEED register can also trigger an MII event. As a result,
> the next MDIO read has a pending MII event, and immediately reads the
> data registers before it contains useful data. When the read does
> complete, another MII event is posted, which results in the next read
> also going wrong, and the cycle continues.
> 
> By writing 0 to the MII_DATA register before writing to the speed
> register, this MII event for the MII_SPEED is suppressed, and polled
> IO works as expected.

Hi Andy

Could you get your LAVA instances to test this? Or do we need to wait
for it to make its way into net-next?

Thanks
	Andrew
