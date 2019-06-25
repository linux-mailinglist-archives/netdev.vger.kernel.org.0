Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8769C55C49
	for <lists+netdev@lfdr.de>; Wed, 26 Jun 2019 01:27:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726287AbfFYX1m (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Jun 2019 19:27:42 -0400
Received: from mail-qk1-f196.google.com ([209.85.222.196]:42884 "EHLO
        mail-qk1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726068AbfFYX1m (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Jun 2019 19:27:42 -0400
Received: by mail-qk1-f196.google.com with SMTP id b18so139926qkc.9
        for <netdev@vger.kernel.org>; Tue, 25 Jun 2019 16:27:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=r98c6Tsxl7Z+MphfcFt1gZr4oAL/L4Ex5rwOKxmb6kw=;
        b=P/EjqXIqSyxOWNmeW5BcWI8fSF7udlzy9MLkaFXZE7g2GYFOysHZH7HB0aTLPt+tsA
         WbMpAZWl3+lDiN/XEsSzhlgw6qJngClifT9LZR7J0IDfSA98prmAbPLVKcdYAp/Ip1EQ
         5ov6urvnQT9egRsvJ+v9apIBJodAGEmOAqLVBySxHd9qAlQL5sXhNE4KeozY3MNC4s4c
         OilEL3flIBVQ1ilhrrNAjBdvv8DILC/J48dNLQvM6GzGTrQXbdzEevS/+o3lw2kckH3h
         UPHSekOyuknQJpY9oI2ME/tWVW5YznNRweyVt8Y/kUNIGGaaOb1MUtxmOsS2xfkHi+OS
         SNuA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=r98c6Tsxl7Z+MphfcFt1gZr4oAL/L4Ex5rwOKxmb6kw=;
        b=g1NyEK7aBhLwUoxietAnx9DshRoSrTOBRbmN7J4xATjMcD5WqqIQ0svB4AtGoOkyAX
         5IVdI62fbs1GMD3C59k3TjokCuR3wfQt2kTp7a7ucrURRQjYom/bJTGRQhngBmHQ6B2W
         fdthXxzYawb/I0TlrcBAM4FU8G+CCuZSbZoaktr1WrV2PGAJAw/xwdpLJOAcL3upLKdR
         E1RLVy6fo9FygCJKpdC7r9yRDyCWYlfT1H/5se1BjOx7K4TTRTat++IAupzYL7UC1WVT
         IDXZc3BGj6JUiTkH4dI44jP/1mqiVMsFEtn5OdLKxjYxg2Yzs7IclfF313EVq4OeqT6g
         mvdA==
X-Gm-Message-State: APjAAAUlUhV3hn0NEU2mLkQceepKFIRgMtucfM3+TnICRq3RoCSA0odm
        1+tRg1oddP63hnLUccPlnPfvC3QuCdw=
X-Google-Smtp-Source: APXvYqz450jQSNlaOGnEevQDr0oBw1zCPagSwj675Zb1hIuIHgk1gYdOq+Sh0EcJUOKq+0OTTD0ibA==
X-Received: by 2002:ae9:f20c:: with SMTP id m12mr1172289qkg.58.1561505261499;
        Tue, 25 Jun 2019 16:27:41 -0700 (PDT)
Received: from cakuba.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id l63sm8181451qkb.124.2019.06.25.16.27.40
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Tue, 25 Jun 2019 16:27:41 -0700 (PDT)
Date:   Tue, 25 Jun 2019 16:27:38 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Shannon Nelson <snelson@pensando.io>
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH net-next 09/18] ionic: Add the basic NDO callbacks for
 netdev support
Message-ID: <20190625162738.15049dc7@cakuba.netronome.com>
In-Reply-To: <20190620202424.23215-10-snelson@pensando.io>
References: <20190620202424.23215-1-snelson@pensando.io>
        <20190620202424.23215-10-snelson@pensando.io>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 20 Jun 2019 13:24:15 -0700, Shannon Nelson wrote:
> +static int ionic_set_features(struct net_device *netdev,
> +			      netdev_features_t features)
> +{
> +	struct lif *lif = netdev_priv(netdev);
> +	int err;
> +
> +	netdev_dbg(netdev, "%s: lif->features=0x%08llx new_features=0x%08llx\n",
> +		   __func__, (u64)lif->netdev->features, (u64)features);
> +
> +	err = ionic_set_nic_features(lif, features);

Presumably something gets added here in later patch?

> +	return err;
> +}
> +
> +static int ionic_set_mac_address(struct net_device *netdev, void *sa)
> +{
> +	netdev_info(netdev, "%s: stubbed\n", __func__);
> +	return 0;
> +}
> +
> +static int ionic_change_mtu(struct net_device *netdev, int new_mtu)
> +{
> +	struct lif *lif = netdev_priv(netdev);
> +	struct ionic_admin_ctx ctx = {
> +		.work = COMPLETION_INITIALIZER_ONSTACK(ctx.work),
> +		.cmd.lif_setattr = {
> +			.opcode = CMD_OPCODE_LIF_SETATTR,
> +			.index = cpu_to_le16(lif->index),
> +			.attr = IONIC_LIF_ATTR_MTU,
> +			.mtu = cpu_to_le32(new_mtu),
> +		},
> +	};
> +	int err;
> +
> +	if (new_mtu < IONIC_MIN_MTU || new_mtu > IONIC_MAX_MTU) {
> +		netdev_err(netdev, "Invalid MTU %d\n", new_mtu);
> +		return -EINVAL;
> +	}

We do the min/max checks in the core now (netdev->min_mtu,
netdev->max_mtu).  You'll have to keep this if out of tree,
unfortunately.

> +	err = ionic_adminq_post_wait(lif, &ctx);
> +	if (err)
> +		return err;
> +
> +	netdev->mtu = new_mtu;
> +	err = ionic_reset_queues(lif);
> +
> +	return err;
> +}
