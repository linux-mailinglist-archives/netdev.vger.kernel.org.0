Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AEDB745F199
	for <lists+netdev@lfdr.de>; Fri, 26 Nov 2021 17:18:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236690AbhKZQVf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Nov 2021 11:21:35 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:53726 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229544AbhKZQTf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 26 Nov 2021 11:19:35 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=F0S05QwaJBFCUctjd90DtJyRQ0nMLkMgtKH49vcnZDE=; b=3/c1p1Lx3Q5VEWQfZngheA8Ha8
        DmbB4JbAQ3ajg41PKhP65MmfW7KjwKuACrH8+kbCu3qWvEMUF3kF7yJjaBsSYmzljc9WMOv+RRuEQ
        ix3noyqsHPFlF2sUyzZ9nbIdnhHWrZZ1gwMmLL/lYvOzc3bPiMkZXQHm9OG2JEF4k7nk=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1mqdtd-00Ei2S-7A; Fri, 26 Nov 2021 17:16:21 +0100
Date:   Fri, 26 Nov 2021 17:16:21 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Holger Brunck <holger.brunck@hitachienergy.com>
Cc:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>
Subject: Re: [PATCH 2/2] dsa: mv88e6xxx: make serdes SGMII/Fiber output
 amplitude configurable
Message-ID: <YaEIVQ6gKOSD1Vf/@lunn.ch>
References: <20211126154249.2958-1-holger.brunck@hitachienergy.com>
 <20211126154249.2958-2-holger.brunck@hitachienergy.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211126154249.2958-2-holger.brunck@hitachienergy.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> +	if (chip->info->ops->serdes_set_out_amplitude && np) {
> +		if (!of_property_read_u32(np, "serdes-output-amplitude",
> +					  &out_amp)) {
> +			err = mv88e6352_serdes_set_out_amplitude(chip, out_amp);
> +			if (err)
> +				goto unlock;
> +		}
> +	}

If the property is in DT, but the device does not have a
ops->serdes_set_out_amplitude(), please return -EOPNOTSUP.  We want to
avoid the case somebody wrongly cut/pastes a DT fragment to a
different switch.

	  Andrew
