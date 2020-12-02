Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AC3AB2CC450
	for <lists+netdev@lfdr.de>; Wed,  2 Dec 2020 18:55:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730762AbgLBRyD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Dec 2020 12:54:03 -0500
Received: from mail.kernel.org ([198.145.29.99]:51396 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728444AbgLBRyD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 2 Dec 2020 12:54:03 -0500
Date:   Wed, 2 Dec 2020 09:53:20 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1606931602;
        bh=cwmdyU6NKbjjsZCsVAPbwEXDkqGwHYdB1/A1gSP4eBc=;
        h=From:To:Cc:Subject:In-Reply-To:References:From;
        b=qObwmVBCHZTv4W5y7s2t4hic7HjPi2IpVrV216YDrrDLSMaGPVuEdq5f9WpODDPYU
         TZ21LG5cRUfs/xnfv5lSDqQjYXmiso5RUZZdirNLUnQZcx07tZYgDfiQi/Nu3u0MEE
         75r73L8HSZ+TpQuWyixqxifNSErwqVBVDof0lh20=
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jarod Wilson <jarod@redhat.com>
Cc:     linux-kernel@vger.kernel.org, Ivan Vecera <ivecera@redhat.com>,
        Jay Vosburgh <j.vosburgh@gmail.com>,
        Veaceslav Falico <vfalico@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        "David S. Miller" <davem@davemloft.net>,
        Thomas Davis <tadavis@lbl.gov>, netdev@vger.kernel.org
Subject: Re: [PATCH net v2] bonding: fix feature flag setting at init time
Message-ID: <20201202095320.7768b5b3@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
In-Reply-To: <20201202173053.13800-1-jarod@redhat.com>
References: <20201123031716.6179-1-jarod@redhat.com>
        <20201202173053.13800-1-jarod@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed,  2 Dec 2020 12:30:53 -0500 Jarod Wilson wrote:
> +	if (bond->dev->reg_state != NETREG_REGISTERED)
> +		goto noreg;
> +
>  	if (newval->value == BOND_MODE_ACTIVEBACKUP)
>  		bond->dev->wanted_features |= BOND_XFRM_FEATURES;
>  	else
>  		bond->dev->wanted_features &= ~BOND_XFRM_FEATURES;
> -	netdev_change_features(bond->dev);
> +	netdev_update_features(bond->dev);
> +noreg:

Why the goto?
