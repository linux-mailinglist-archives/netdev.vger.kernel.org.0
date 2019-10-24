Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7DF8FE352E
	for <lists+netdev@lfdr.de>; Thu, 24 Oct 2019 16:12:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2502740AbfJXOMX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Oct 2019 10:12:23 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:33604 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2502736AbfJXOMP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 24 Oct 2019 10:12:15 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Transfer-Encoding:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=lZ8lLCKJr4NdYUVi3ZkOTZhKhWlETKgcJa0oIBxTrVk=; b=y3bXiCSrOaWhibxZKs0ofnrKuG
        iC0/V1KDc2YZb74y5/SyV4W56z7fQPjn/tO+ClbGQ2Ka+9qEPf+j9VrYKUI57f7Wc+rS++dGi3uuY
        41+UGrZiFkrrHsRGv3BEoKKniwXtgdKqoMDWs5if6hufScTx07dbB3bSkhXWmyR5sS1E=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.92.2)
        (envelope-from <andrew@lunn.ch>)
        id 1iNdqV-0003zT-Ug; Thu, 24 Oct 2019 16:12:11 +0200
Date:   Thu, 24 Oct 2019 16:12:11 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Michal =?utf-8?B?Vm9rw6HEjQ==?= <michal.vokac@ysoft.com>
Cc:     Vivien Didelot <vivien.didelot@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next] net: dsa: qca8k: Initialize the switch with
 correct number of ports
Message-ID: <20191024141211.GC30147@lunn.ch>
References: <1571924818-27725-1-git-send-email-michal.vokac@ysoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1571924818-27725-1-git-send-email-michal.vokac@ysoft.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 24, 2019 at 03:46:58PM +0200, Michal Vokáč wrote:
> Since commit 0394a63acfe2 ("net: dsa: enable and disable all ports")
> the dsa core disables all unused ports of a switch. In this case
> disabling ports with numbers higher than QCA8K_NUM_PORTS causes that
> some switch registers are overwritten with incorrect content.

Humm.

The same problem might exist in other drivers:

linux/drivers/net/dsa$ grep -r "ds->num_ports = DSA_MAX_PORTS"
qca8k.c:	priv->ds->num_ports = DSA_MAX_PORTS;
b53/b53_common.c:	ds->num_ports = DSA_MAX_PORTS;
mt7530.c:	priv->ds->num_ports = DSA_MAX_PORTS;
microchip/ksz_common.c:	ds->num_ports = DSA_MAX_PORTS;
dsa_loop.c:	ds->num_ports = DSA_MAX_PORTS;

dsa_loop.c looks O.K, it does support DSA_MAX_PORTS ports.

But the others?

    Andrew
