Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BA2A26672EC
	for <lists+netdev@lfdr.de>; Thu, 12 Jan 2023 14:09:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233241AbjALNJO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Jan 2023 08:09:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51340 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233571AbjALNIp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Jan 2023 08:08:45 -0500
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 46B8752C43
        for <netdev@vger.kernel.org>; Thu, 12 Jan 2023 05:07:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=ALsHmtNQH50Mi3irMiPtF5j33nfWlDDVri2VVWpBVz8=; b=YJrz/VxZr0+aYRPUOL+yAu4+rf
        1J1TiAwwZIoMM6w+ey6dzkjWT1/pQo1i9rTf+ZuNzOMTsnxK9VGJs81mln+0c2TknJswcYRkje3Lq
        4wbzd0KSC3N0SrLRF3avIehNzv7XTHCA78ETBTepJ27OqDe5bNy/LPRCp5JR1q5b55mQ=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1pFxIq-001rfT-Sf; Thu, 12 Jan 2023 14:07:32 +0100
Date:   Thu, 12 Jan 2023 14:07:32 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Kurt Kanzenbach <kurt@linutronix.de>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Richard Cochran <richardcochran@gmail.com>,
        netdev@vger.kernel.org
Subject: Re: [PATCH net-next v2] net: dsa: mv88e6xxx: Enable PTP receive for
 mv88e6390
Message-ID: <Y8AGFJlQBEhTqQs7@lunn.ch>
References: <20230112091224.43116-1-kurt@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230112091224.43116-1-kurt@linutronix.de>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 12, 2023 at 10:12:24AM +0100, Kurt Kanzenbach wrote:
> The switch receives management traffic such as STP and LLDP. However, PTP
> messages are not received, only transmitted.
> 
> Ideally, the switch would trap all PTP messages to the management CPU. This
> particular switch has a PTP block which identifies PTP messages and traps them
> to a dedicated port. There is a register to program this destination. This is
> not used at the moment.
> 
> Therefore, program it to the same port as the MGMT traffic is trapped to. This
> allows to receive PTP messages as soon as timestamping is enabled.
> 
> In addition, the datasheet mentions that this register is not valid e.g., for
> 6190 variants. So, add a new PTP operation which is only added for the both 6390
> devices.

I assume this also works for the 6290? Please could you also update
its _ops structure?

Otherwise this looks good.

	  Andrew
