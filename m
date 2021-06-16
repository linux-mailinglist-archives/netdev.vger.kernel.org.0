Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B38033A8DE1
	for <lists+netdev@lfdr.de>; Wed, 16 Jun 2021 02:55:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231784AbhFPA5D (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Jun 2021 20:57:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39742 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230265AbhFPA5C (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Jun 2021 20:57:02 -0400
Received: from mail-ej1-x62a.google.com (mail-ej1-x62a.google.com [IPv6:2a00:1450:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B7BA8C061574;
        Tue, 15 Jun 2021 17:54:56 -0700 (PDT)
Received: by mail-ej1-x62a.google.com with SMTP id ce15so791979ejb.4;
        Tue, 15 Jun 2021 17:54:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=m2o15jWngAsIvUXQVaETyU9KLklExuy5wY7c+QHF2tQ=;
        b=cAnRx4N0zZ+i7fd4TmXxael1qFUfP5BPnd1jGu2zp3Z46L6TnNof8GdIc9XlfIGfdx
         LCFJ9h3yYG0RhV0p8fK+TjtGKKYLhpqBmAv01Z8i3F5BDr28LpqvPd9sqL75aINYold2
         Y3+81yqsEnIyjiauU0T84kOBKyvchXXbeCz+x2bSEJEHk9HvROzFfOv27sR9wJF2YHd2
         PUIjJ0QW8cS/8jorjLEIQ8qKZAXyccFWXl9qTd7iEqYD1/XlR7zEfyT3+mSk946SwH4E
         awfZYVHvqqsPrpPZ1qbEhTT1QktwQsznK/ji/v13aWR3XZUSpMTf1TVfR5BtO9UpHAkn
         C9kw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=m2o15jWngAsIvUXQVaETyU9KLklExuy5wY7c+QHF2tQ=;
        b=q0XrKVt1ceF2syG90NvG56muJh17+y8lwYGQe8uaGfalXXA7FUSkvvgIazxGbgGOvG
         5TeSlFc98N4aYMEr4scQZXgXbOcJnnN76KPQBMFa5scR5ZJllH7aevDwaPYx/9UjtD4D
         W9CD8hgWjLeik84QOUJfeYDy+tuVoKsrcdqqJnyNr6WdofHQFcqTj2B3cngZF9mIL2x8
         CUe2n3KDY9/3D23xXVhF9FqGrmHc8u7hDN0HJqt6Ytv2d8iurwwgAigOHrKUbSxS9Ndn
         hzeuMPgHBagO8yp3G5Qji2pKpTzo10ytNRklndcXMeZ/g5orxThfOPh+3QcfOThiEiGU
         45Gw==
X-Gm-Message-State: AOAM533ydHPMwuNF2tCLBBpnbj6dplZWpgYudXSjNKG4tDf2+tzdjoZg
        IK8030raxA6ElC35IC5lEzDDPcDG9Zs=
X-Google-Smtp-Source: ABdhPJy4glY9KldRr8Paz+ZfVgo67RhdhttLXX7TThHVDs1Y8CudzxUovySeXfIZayzoN7Jw64NSHw==
X-Received: by 2002:a17:906:a95:: with SMTP id y21mr2368783ejf.522.1623804895362;
        Tue, 15 Jun 2021 17:54:55 -0700 (PDT)
Received: from skbuf ([188.26.224.68])
        by smtp.gmail.com with ESMTPSA id x13sm387236ejj.21.2021.06.15.17.54.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Jun 2021 17:54:55 -0700 (PDT)
Date:   Wed, 16 Jun 2021 03:54:53 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Vadym Kochan <vadym.kochan@plvision.eu>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Andrew Lunn <andrew@lunn.ch>,
        Taras Chornyi <tchornyi@marvell.com>,
        linux-kernel@vger.kernel.org,
        Mickey Rachamim <mickeyr@marvell.com>,
        Serhiy Boiko <serhiy.boiko@plvision.eu>,
        Volodymyr Mytnyk <vmytnyk@marvell.com>,
        Vadym Kochan <vkochan@marvell.com>
Subject: Re: [PATCH net-next 1/2] net: marvell: Implement TC flower offload
Message-ID: <20210616005453.cuu3ocedgfcafa7o@skbuf>
References: <20210615125444.31538-1-vadym.kochan@plvision.eu>
 <20210615125444.31538-2-vadym.kochan@plvision.eu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210615125444.31538-2-vadym.kochan@plvision.eu>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 15, 2021 at 03:54:43PM +0300, Vadym Kochan wrote:
> +static int prestera_port_set_features(struct net_device *dev,
> +				      netdev_features_t features)
> +{
> +	netdev_features_t oper_features = dev->features;
> +	int err;
> +
> +	err = prestera_port_handle_feature(dev, features, NETIF_F_HW_TC,
> +					   prestera_port_feature_hw_tc);

Why do you even make NETIF_F_HW_TC able to be toggled and not just fixed
to "on" in dev->features? If I understand correctly, you could then delete
a bunch of refcounting code whose only purpose is to allow that feature
to be disabled per port.

> +
> +	if (err) {
> +		dev->features = oper_features;
> +		return -EINVAL;
> +	}
> +
> +	return 0;
> +}
