Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 47D22636857
	for <lists+netdev@lfdr.de>; Wed, 23 Nov 2022 19:13:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239336AbiKWSNb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Nov 2022 13:13:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41608 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239946AbiKWSMy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Nov 2022 13:12:54 -0500
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A3B951025C0;
        Wed, 23 Nov 2022 10:07:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=6EPHZk7UgL3HOkp7SSnW/7HYBO+VZ1nx5CXgoLWNDOo=; b=cLV1lNP4fa31veCKPms29plEmG
        vbF5NQtvJqpdEGXlSsNRNr8ZvFgKCeBW2MQEtyEfhTGqatexoJlStavI0ghaQXgN2dNM2f/o2Cwde
        HjJltiiJld+WzVWmKMqQhTdNVpU1Xhtpa3+CenDfvdEsehELf3t5U0PacRVaFSyhWcFY=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1oxu9L-003FXc-9z; Wed, 23 Nov 2022 19:07:07 +0100
Date:   Wed, 23 Nov 2022 19:07:07 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Rasmus Villemoes <linux@rasmusvillemoes.dk>
Cc:     Joakim Zhang <qiangqing.zhang@nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: fec: don't reset irq coalesce settings to defaults
 on "ip link up"
Message-ID: <Y35hS5mbstSZeF/Z@lunn.ch>
References: <20221123133853.1822415-1-linux@rasmusvillemoes.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221123133853.1822415-1-linux@rasmusvillemoes.dk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 23, 2022 at 02:38:52PM +0100, Rasmus Villemoes wrote:
> Currently, when a FEC device is brought up, the irq coalesce settings
> are reset to their default values (1000us, 200 frames). That's
> unexpected, and breaks for example use of an appropriate .link file to
> make systemd-udev apply the desired
> settings (https://www.freedesktop.org/software/systemd/man/systemd.link.html),
> or any other method that would do a one-time setup during early boot.
> 
> Refactor the code so that fec_restart() instead uses
> fec_enet_itr_coal_set(), which simply applies the settings that are
> stored in the private data, and initialize that private data with the
> default values.
> 
> Signed-off-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
