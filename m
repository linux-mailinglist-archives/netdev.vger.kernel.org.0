Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0E20862C5AE
	for <lists+netdev@lfdr.de>; Wed, 16 Nov 2022 18:00:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233952AbiKPRAt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Nov 2022 12:00:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46790 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234240AbiKPRAY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Nov 2022 12:00:24 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 68C152D1FA;
        Wed, 16 Nov 2022 09:00:08 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 03E3361EE6;
        Wed, 16 Nov 2022 17:00:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D19FFC433D6;
        Wed, 16 Nov 2022 17:00:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668618007;
        bh=bLUlbc/+/0gO3dcznYxH6czWQ+tUlfa7KsA12zfO79k=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=m3mMcdziSW9f8rS4Hhuu3yNRUGrINjlA4uet/i50yYwNuIGx0FjG8n1JPyf9RMW0c
         2NX/6LW6odUqQjlSKw8KivnxZtYrP4ICtnUqHkTfQE04yqLC5erBcoEKi3XD+wLX25
         xBVfjhvT+u0AyrZeOD5BA2QVNkmhrq+gqDKIV3EHcORQdczgtzTNRdH+0eZyu5OjLE
         aiqCvQprlOywqAIR5cSoxacZzaG2zgyx/pvTYdGV37kFDDv60m1LRYl5pwfWDrLfB3
         zJ2/Hn/QUTLYanjvgRhUp8IxtGmLbpQgsqLIYe9H6oAdkWqcvFDJTjS7Rxm/gtlha0
         LhrwNiphWocuA==
Date:   Wed, 16 Nov 2022 09:00:05 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jerry Ray <jerry.ray@microchip.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        "Paolo Abeni" <pabeni@redhat.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [net-next][PATCH v2 2/2] dsa: lan9303: Add 2 ethtool stats
Message-ID: <20221116090005.6eeb961d@kernel.org>
In-Reply-To: <20221115165131.11467-2-jerry.ray@microchip.com>
References: <20221115165131.11467-1-jerry.ray@microchip.com>
        <20221115165131.11467-2-jerry.ray@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 15 Nov 2022 10:51:31 -0600 Jerry Ray wrote:
> Adding RxDropped and TxDropped counters to the reported statistics.
> As these stats are kept by the switch rather than the port instance,
> they are indexed differently.

What are these statistics counting? They are still per port, so should
they be reported in struct rtnl_link_stats::[rt]x_dropped ?
