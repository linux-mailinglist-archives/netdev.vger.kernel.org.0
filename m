Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 391C643B1A1
	for <lists+netdev@lfdr.de>; Tue, 26 Oct 2021 13:54:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235624AbhJZL5D (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Oct 2021 07:57:03 -0400
Received: from mx1.tq-group.com ([93.104.207.81]:45713 "EHLO mx1.tq-group.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232392AbhJZL45 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 26 Oct 2021 07:56:57 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=tq-group.com; i=@tq-group.com; q=dns/txt; s=key1;
  t=1635249274; x=1666785274;
  h=message-id:subject:from:to:cc:date:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=I0mJPUZnz8Ih8VZRAIF3bxoM4Pju8m9zD0yQsSiG5Ao=;
  b=HqHBmYdvkUQVYXSG3NSGerDv+7udjMiPwRxwgjEE/RbtpTcO6lhn9vLq
   7TdFLlfhSSIRYu7xF4eJy1594VSRsAL9xCdFp7PosS2fg09PtfQ2ONiPr
   O9DJEzbbpRMtFPK8ujWXxgBqnKPK9BB52gH/EAP1AY219lWXkTJbq9BgN
   kUg6qKpmlOhrhzxITgRy0jzb4VZ/K6Th0F9KCldZU30oFyVnsTaUNtZ3D
   TgSefrHOksogow5OuEf9pnd9B/zUnrSdmdidkG8uFieBwJmH8c+/eE2bp
   umki6vlhjQoi2Dlgrn9X1ZxKPgLdhl/17YwYlsWfs5c5/9sYaZrmgMn4p
   g==;
X-IronPort-AV: E=Sophos;i="5.87,182,1631570400"; 
   d="scan'208";a="20226884"
Received: from unknown (HELO tq-pgp-pr1.tq-net.de) ([192.168.6.15])
  by mx1-pgp.tq-group.com with ESMTP; 26 Oct 2021 13:54:31 +0200
Received: from mx1.tq-group.com ([192.168.6.7])
  by tq-pgp-pr1.tq-net.de (PGP Universal service);
  Tue, 26 Oct 2021 13:54:31 +0200
X-PGP-Universal: processed;
        by tq-pgp-pr1.tq-net.de on Tue, 26 Oct 2021 13:54:31 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=tq-group.com; i=@tq-group.com; q=dns/txt; s=key1;
  t=1635249271; x=1666785271;
  h=message-id:subject:from:to:cc:date:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=I0mJPUZnz8Ih8VZRAIF3bxoM4Pju8m9zD0yQsSiG5Ao=;
  b=X7l16yywGH+sm+q9IzCCkVUKCcCBhvH99wmMq9j+wjFGjPQuRiNGVjaq
   JkB/7EL6Ktc2vHXiDLcvAT8avoYiRbEBT/sKDcF80th0pz1JKX177I+WF
   A52bcYHe7WFBqMzqeyOUazi0FeRBnMZcWwdNMs2TordB4XcPXCT9py8rW
   mjfx15o76VMsUj1wBiaQlTdvVdB3+RogIxnX7xISh1z+G+n1Ywvpfv0Gv
   39cYOe8aMusB7I86hl7HA2PZa3XULkg87TfMxYulC45/clO02v/xS9TiZ
   +zNO5uUfBQcPxXbPjRUMLmCQK1E52OvHWmOgrgrUQirfW5AnnZx/mEk8s
   Q==;
X-IronPort-AV: E=Sophos;i="5.87,182,1631570400"; 
   d="scan'208";a="20226883"
Received: from vtuxmail01.tq-net.de ([10.115.0.20])
  by mx1.tq-group.com with ESMTP; 26 Oct 2021 13:54:31 +0200
Received: from schifferm-ubuntu4.tq-net.de (schifferm-ubuntu4.tq-net.de [10.121.48.12])
        by vtuxmail01.tq-net.de (Postfix) with ESMTPA id 642C2280065;
        Tue, 26 Oct 2021 13:54:31 +0200 (CEST)
Message-ID: <e8e0f07afbae8333c94c198a20a66a9448c32ce6.camel@ew.tq-group.com>
Subject: Re: [PATCH] net: fec: defer probe if PHY on external MDIO bus is
 not available
From:   Matthias Schiffer <matthias.schiffer@ew.tq-group.com>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Joakim Zhang <qiangqing.zhang@nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date:   Tue, 26 Oct 2021 13:54:29 +0200
In-Reply-To: <YXK1E9LLDCfajzmR@lunn.ch>
References: <20211014113043.3518-1-matthias.schiffer@ew.tq-group.com>
         <YW7SWKiUy8LfvSkl@lunn.ch>
         <aae9573f89560a32da0786dc90cb7be0331acad4.camel@ew.tq-group.com>
         <YXBk8gwuCqrxDbVY@lunn.ch>
         <c286107376a99ca2201db058e1973e2b2264e9fb.camel@ew.tq-group.com>
         <YXFh/nLTqvCsLAXj@lunn.ch>
         <7a478c1f25d2ea96ff09cee77d648e9c63b97dcf.camel@ew.tq-group.com>
         <YXK1E9LLDCfajzmR@lunn.ch>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5-0ubuntu0.18.04.2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 2021-10-22 at 14:56 +0200, Andrew Lunn wrote:
> > Hmm, lots of network drivers? I tried to find an example, but all
> > drivers that generate -EPROBE_DEFER for missing PHYs at all don't have
> > an internal MDIO bus and thus avoid the circular dependency.
> 
> Try drivers/net/dsa.
> 
> These often have mdio busses which get registered and then
> unregistered. There are also IRQ drivers which do the same.
> 
> 	Andrew


All drivers I looked at were careful to register the MDIO bus in the
last part of the probe function, so that the only errors that could 
happen after that (and thus require to unregister the bus device again)
would not be -EPROBE_DEFER.

The documented infinite loop is easy to reproduce: You just need two
separate device instances with misbehaving probe() functions that
return -EPROBE_DEFER after registering and unregistering some
subdevice. If the missing device that causes the deferral never appears
(for example because its driver is not available), the two devices will
be probed ad infinitum.

I agree with the documentation that a driver should not do this, and
thus we need another way to deal with the cyclic dependency between an
Ethernet interface and a PHY on its internal MDIO bus.

While I think that a generic solution would be theoretically possible
by ensuring that the probing loop makes some kind of "progress", I
think this would set a precedent for "expensive" operations happening
before a -EPROBE_DEFER return, which should be avoided even when no
infinite loop results.

Matthias

