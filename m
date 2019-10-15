Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 31E84D8465
	for <lists+netdev@lfdr.de>; Wed, 16 Oct 2019 01:21:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390221AbfJOXU7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Oct 2019 19:20:59 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:55607 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726990AbfJOXU7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Oct 2019 19:20:59 -0400
Received: by mail-wm1-f68.google.com with SMTP id a6so772994wma.5
        for <netdev@vger.kernel.org>; Tue, 15 Oct 2019 16:20:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=i/vLC1YKgN29oZG0iS/VeMHgD2rFWpa5R3KYcg88Zf0=;
        b=w+yTXcN/FJFWla3i2wSBvPULyZJOWsSuZ0wn5Q6+TuJDxLc8Nl5Vxcv3r43GOvpJbv
         2ZGqswsoeXrQmlcxlvWCje/USb4D19XibUdm+v88KV7Izcev3UiDcRZ++Z2c0HluU2Mc
         qsajORL5tkzeHEUKe8U2RaBDFbe6IO/tmv6+t13DjUzkaOnIiXgR32hjMx5c8fwsAv0E
         ol6qBcHW3zCoKuh+wKTR3lFsDaKLM2yFzKkVlLxEACpmuDMl2G2eh1XeNzJEb1GTJO7A
         zUOC9KbfkTTRZEIHPFo2VFJxsuwJ4rU+qFv/64L5zN2xPLoqFIknIyd3HxHHEmswcOH8
         id3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=i/vLC1YKgN29oZG0iS/VeMHgD2rFWpa5R3KYcg88Zf0=;
        b=VQIO7MSpkGxzCqevJBC5NKfPiFyyahROQE7aX4tLRAwB/ne4zguOhGv8YqefHImJ5b
         gtBAKgxOeQxYG8JadUfo+nnjGfZrhjT4DBCiANt3r0Bkfx4AuSrYzTZ5G/LSgVVZhBAk
         9+bpZhm1uR54UItm/zEVmNuKy+0CfkAuXS+cwXVkmn/2+q88AtVzTA7zhifZM0GLW74a
         7NcRcKlyocZG2GcWKo13qJU0lqlXDxOy1veZJpxGD5vlpVTZxYeuIqA0K+6Vda16Adom
         xCzFOy6fsXL5aspYQkHhR23RnTfgrHJJ4c6BXNnQQUQxPQd4VPLebFHQ2o8cdri2/shT
         OTCA==
X-Gm-Message-State: APjAAAXsh7YZXhh9OH088eDMeNrLa/bLlxiAbF+akGI3L5EwXBqss72W
        uSoLpGjJ3cOWLS/uK5Otw4BbNmFwn1I=
X-Google-Smtp-Source: APXvYqyxj/wyKXYe+fk7jTBrxNCtH3NkOe2aXRy32wMZxCdOsuAH+biCpRwqr5GSp7fQnF/0GTQKag==
X-Received: by 2002:a1c:740a:: with SMTP id p10mr711403wmc.130.1571181656679;
        Tue, 15 Oct 2019 16:20:56 -0700 (PDT)
Received: from cakuba.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id t11sm600067wmi.25.2019.10.15.16.20.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Oct 2019 16:20:56 -0700 (PDT)
Date:   Tue, 15 Oct 2019 16:20:47 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Lorenzo Bianconi <lorenzo@kernel.org>
Cc:     netdev@vger.kernel.org, lorenzo.bianconi@redhat.com,
        davem@davemloft.net, thomas.petazzoni@bootlin.com,
        brouer@redhat.com, ilias.apalodimas@linaro.org,
        matteo.croce@redhat.com, mw@semihalf.com
Subject: Re: [PATCH v3 net-next 5/8] net: mvneta: add basic XDP support
Message-ID: <20191015162047.43e0de8b@cakuba.netronome.com>
In-Reply-To: <7c53ff9e148b80613088c7c35444244cbe1358bf.1571049326.git.lorenzo@kernel.org>
References: <cover.1571049326.git.lorenzo@kernel.org>
        <7c53ff9e148b80613088c7c35444244cbe1358bf.1571049326.git.lorenzo@kernel.org>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 14 Oct 2019 12:49:52 +0200, Lorenzo Bianconi wrote:
> @@ -3983,6 +4071,46 @@ static int mvneta_ioctl(struct net_device *dev, struct ifreq *ifr, int cmd)
>  	return phylink_mii_ioctl(pp->phylink, ifr, cmd);
>  }
>  
> +static int mvneta_xdp_setup(struct net_device *dev, struct bpf_prog *prog,
> +			    struct netlink_ext_ack *extack)
> +{
> +	struct mvneta_port *pp = netdev_priv(dev);
> +	struct bpf_prog *old_prog;
> +
> +	if (prog && dev->mtu > MVNETA_MAX_RX_BUF_SIZE) {
> +		NL_SET_ERR_MSG_MOD(extack, "Jumbo frames not supported on XDP");
> +		return -EOPNOTSUPP;
> +	}
> +
> +	if (netif_running(dev))
> +		mvneta_stop(dev);
> +
> +	old_prog = xchg(&pp->xdp_prog, prog);
> +	if (old_prog)
> +		bpf_prog_put(old_prog);
> +
> +	if (netif_running(dev))
> +		mvneta_open(dev);

Ah, the stopping and starting of the interface is sad. If start fails
the interface is left in a funky state until someone does a stop/start
cycle. Not that you introduced that.

> +	return 0;
> +}
> +
> +static int mvneta_xdp(struct net_device *dev, struct netdev_bpf *xdp)
> +{
> +	struct mvneta_port *pp = netdev_priv(dev);
> +
> +	switch (xdp->command) {
> +	case XDP_SETUP_PROG:
> +		return mvneta_xdp_setup(dev, xdp->prog, xdp->extack);
> +	case XDP_QUERY_PROG:
> +		xdp->prog_id = pp->xdp_prog ? pp->xdp_prog->aux->id : 0;
> +		return 0;
> +	default:
> +		NL_SET_ERR_MSG_MOD(xdp->extack, "unknown XDP command");

Please drop this message here, there are commands you legitimately
don't care about, just return -EINVAL, no need to risk leaking a
meaningless warning to the user space.

> +		return -EINVAL;
> +	}
> +}
