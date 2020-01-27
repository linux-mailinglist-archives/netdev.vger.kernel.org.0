Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F143C149E13
	for <lists+netdev@lfdr.de>; Mon, 27 Jan 2020 02:04:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726761AbgA0BEm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 26 Jan 2020 20:04:42 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:55106 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726382AbgA0BEm (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 26 Jan 2020 20:04:42 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=c9fvEG5Id56ZAJvx9m7EYbTwULGMf6u8BNm+CeOqTKY=; b=HPFqa6hpSYsiFpSILGI40j+7Z1
        F/c13pM+2SKnoU9+E1KYukRKi/4j1if/1500mmEp6niEFRGmFv7XZHha8MQjnlHlt0rkzmHlCq2B1
        8LdBZIq7wMu/S2qbSj8y4eDT1DZtntPL00mMRasQlIOIElnffwPlyEuTktE/INmAjFjo=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1ivspC-0003nT-8c; Mon, 27 Jan 2020 02:04:22 +0100
Date:   Mon, 27 Jan 2020 02:04:22 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Michal Kubecek <mkubecek@suse.cz>
Cc:     David Miller <davem@davemloft.net>, netdev@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>,
        Jiri Pirko <jiri@resnulli.us>,
        Florian Fainelli <f.fainelli@gmail.com>,
        John Linville <linville@tuxdriver.com>,
        Johannes Berg <johannes@sipsolutions.net>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next 3/7] ethtool: set message mask with DEBUG_SET
 request
Message-ID: <20200127010422.GD12816@lunn.ch>
References: <cover.1580075977.git.mkubecek@suse.cz>
 <844bf6bf518640fbfc67b5dd7976d9e8683c2d2d.1580075977.git.mkubecek@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <844bf6bf518640fbfc67b5dd7976d9e8683c2d2d.1580075977.git.mkubecek@suse.cz>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> +	ret = ethnl_parse_header(&req_info, tb[ETHTOOL_A_DEBUG_HEADER],
> +				 genl_info_net(info), info->extack, true);

> +	dev_put(dev);

Hi Michal

While reviewing this patch i noticed this dev_put() and wondered where
the dev_get() was. It is hiding inside ethnl_parse_header(). The
documentation does make it clear it takes a reference on the device,
but how many people read the documentation? I would not be too
surprised if at some point in the future we have bugs from missing
dev_put().

Could we make this a bit more explicit by calling it
ethnl_parse_header_dev_get(). It is rather long though.

     Andrew
