Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DD04DF7756
	for <lists+netdev@lfdr.de>; Mon, 11 Nov 2019 16:05:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726893AbfKKPF6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Nov 2019 10:05:58 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:34002 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726843AbfKKPF6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 11 Nov 2019 10:05:58 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=zraoHgRrVwHV9ndpLl43GZDJdbcekcyM+MKr3xtWm7Y=; b=5eb4WvDcSD4IOz/+Q77AUbbBls
        mpn+XqfQOLyj6lOxu6Cz5himNqaIp+km8EOksqORGXP26D7VA/Jj6YWjLPrLdFOR14G/8nBpvs7j8
        /zLlXsQLjfAoEcXyGo3cVJa2CRX3El5P1xcXut03z8nBhwMHpfI62Tsv2aGB3gUq53FM=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.92.2)
        (envelope-from <andrew@lunn.ch>)
        id 1iUBGL-0002jf-7j; Mon, 11 Nov 2019 16:05:53 +0100
Date:   Mon, 11 Nov 2019 16:05:53 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Ilias Apalodimas <ilias.apalodimas@linaro.org>
Cc:     brouer@redhat.com, lorenzo@kernel.org,
        netdev <netdev@vger.kernel.org>
Subject: Re: Regression in mvneta with XDP patches
Message-ID: <20191111150553.GC1105@lunn.ch>
References: <20191111134615.GA8153@lunn.ch>
 <20191111143352.GA2698@apalos.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191111143352.GA2698@apalos.home>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 11, 2019 at 04:33:52PM +0200, Ilias Apalodimas wrote:
> Hi Andrew,
> 
> On Mon, Nov 11, 2019 at 02:46:15PM +0100, Andrew Lunn wrote:
> > Hi Lorenzo, Jesper, Ilias
> > 
> > I just found that the XDP patches to mvneta have caused a regression.
> > 
> > This one breaks networking:
> 
> Thaks for the report.
> Looking at the DTS i can see 'buffer-manager' in it. The changes we made were
> for the driver path software buffer manager. 
> Can you confirm which one your hardware uses?

Hi Ilias

Ah, interesting.

# CONFIG_MVNETA_BM_ENABLE is not set

So in fact it is not being compiled in, so should be falling back to
software buffer manager.

If i do enable it, then it works. So we are in a corner cases you
probably never tested. Requested by DT, but not actually available.

	 Andrew
