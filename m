Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BF0911F0CD2
	for <lists+netdev@lfdr.de>; Sun,  7 Jun 2020 18:12:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726742AbgFGQMu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 7 Jun 2020 12:12:50 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:38714 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726571AbgFGQMu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 7 Jun 2020 12:12:50 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=ve8B95c5l30hX7coLcqI2L8MIPOjAm4w5ayn1YqBLig=; b=aiCvKANTNtEtiGrk1BrDLbB3ZJ
        SZti8Q+xXBDt8US/IjCxMgTCxMbLY2fcVtYjovce6sJV5NTyO4GNpCNO6xSNPev8dOqDjp7Sg0o69
        m7iaRfoEWmICb20t3+WG2qXgmqAGQGULtA/KTr2o3iB/aMgCHUejmUdXpqZA/H/BadAk=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1jhxuS-004LYx-V6; Sun, 07 Jun 2020 18:12:32 +0200
Date:   Sun, 7 Jun 2020 18:12:32 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Amit Cohen <amitc@mellanox.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        corbet@lwn.net, jiri@mellanox.com, idosch@mellanox.com,
        shuah@kernel.org, mkubecek@suse.cz, gustavo@embeddedor.com,
        cforno12@linux.vnet.ibm.com, f.fainelli@gmail.com,
        linux@rempel-privat.de, alexandru.ardelean@analog.com,
        ayal@mellanox.com, petrm@mellanox.com, mlxsw@mellanox.com,
        liuhangbin@gmail.com, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org
Subject: Re: [RFC PATCH net-next 04/10] ethtool: Add link extended state
Message-ID: <20200607161232.GE1022955@lunn.ch>
References: <20200607145945.30559-1-amitc@mellanox.com>
 <20200607145945.30559-5-amitc@mellanox.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200607145945.30559-5-amitc@mellanox.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> +static void linkstate_get_ext_state(struct net_device *dev,
> +				    struct linkstate_reply_data *data)
> +{
> +	int err;
> +
> +	if (!dev->ethtool_ops->get_ext_state)
> +		return;
> +
> +	err = dev->ethtool_ops->get_ext_state(dev, &data->ethtool_ext_state_info);
> +	if (err) {
> +		data->ext_state_provided = false;
> +		return;
> +	}
> +
> +	data->ext_state_provided = true;
>  }

A void function is rather odd for this sort of thing. It is much more
normal to return an error code, -EOPNOTSUPP if the op is not available,
or 0 if it all went well.

   Andrew
