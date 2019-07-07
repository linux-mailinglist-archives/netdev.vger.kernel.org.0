Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9EE9B615BE
	for <lists+netdev@lfdr.de>; Sun,  7 Jul 2019 19:47:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727315AbfGGRrN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 7 Jul 2019 13:47:13 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:59092 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725928AbfGGRrN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 7 Jul 2019 13:47:13 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=7yW0/yXlFqX5lbmd2ljLlmVXMbq7LtSAFbHsMIJrmdk=; b=RG7iKbkuWNC5ksqSYx4isUJ+UR
        wCH32c5bYSu+NACeovTKA5oIfm0LKPHq2aS4t/RxIrGjLDGkjcF8R7PdnrYfz0hH5wWjzDYmHvGts
        NlDB1gHfEsRZKm4ljbn1GlkaBstZH55AXA26Ta8eds4WEszdGQsIgkxVS4H31m2ARXEs=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1hkBFe-0005uh-Mt; Sun, 07 Jul 2019 19:47:02 +0200
Date:   Sun, 7 Jul 2019 19:47:02 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     f.fainelli@gmail.com, vivien.didelot@gmail.com,
        davem@davemloft.net, vinicius.gomes@intel.com,
        vedang.patel@intel.com, richardcochran@gmail.com,
        weifeng.voon@intel.com, jiri@mellanox.com, m-karicheri2@ti.com,
        Jose.Abreu@synopsys.com, ilias.apalodimas@linaro.org,
        netdev@vger.kernel.org
Subject: Re: [RFC PATCH net-next 0/6] tc-taprio offload for SJA1105 DSA
Message-ID: <20190707174702.GC21188@lunn.ch>
References: <20190707172921.17731-1-olteanv@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190707172921.17731-1-olteanv@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> - Configuring the switch over SPI cannot apparently be done from this
>   ndo_setup_tc callback because it runs in atomic context. I also have
>   some downstream patches to offload tc clsact matchall with mirred
>   action, but in that case it looks like the atomic context restriction
>   does not apply.

There have been similar problems in the past. We can probably have the
DSA layer turn it into a notifier. Look at the dsa_port_mdb_*
functions for example.

	  Andrew
