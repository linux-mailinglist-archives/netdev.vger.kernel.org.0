Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0A2393712B4
	for <lists+netdev@lfdr.de>; Mon,  3 May 2021 10:53:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232994AbhECIyd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 May 2021 04:54:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59970 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230490AbhECIyc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 May 2021 04:54:32 -0400
Received: from mail-lf1-x12b.google.com (mail-lf1-x12b.google.com [IPv6:2a00:1450:4864:20::12b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D44A8C06174A
        for <netdev@vger.kernel.org>; Mon,  3 May 2021 01:53:38 -0700 (PDT)
Received: by mail-lf1-x12b.google.com with SMTP id j4so7044731lfp.0
        for <netdev@vger.kernel.org>; Mon, 03 May 2021 01:53:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=waldekranz-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:in-reply-to:references:date:message-id
         :mime-version;
        bh=YtUzOINInaYSLv1I0cAftRc5Acy9OQRqkK2xrgI5y9s=;
        b=elfQnWM43np1UUejnXyHYsWlgZtqbABCywcBfB6eKOjd2FoA7YKFDpjHVC//0Mn/x9
         d66MAXnKjW6y1NmRlxPKRqCsewvsZ4gOzewzrSW2BfGStMwtJ6Y0SOnZka67FJZQwhZy
         7f0E3xIcclfCFhKgOl5c10TmF1jTuhtmyNlLSgmULWOBIMAIzyajLQNhxv/TCiP+qpQb
         OFNB0hVYvZCfMz2qmCa2CQeWmpXk53R9CF8XLfUWMsAWUU0cnHVCXa40oUgJGbAUqOzf
         djdtVT7tCXl1KR4DzWMKnG8v3ZVHkA8Iu8tLScBfz5cfneXyLnvO7xe9uxGUH3Tkyrjo
         C9LA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=YtUzOINInaYSLv1I0cAftRc5Acy9OQRqkK2xrgI5y9s=;
        b=Rhx/L1xiTRryHBqksrPGHGKFkila3h1OmLlAYkZW3Kr7ZgKmKM0xLy172RreMv8Mon
         rT5plrUJPpoB4ZGCE82vFkqj5W4VyNP/MUI/moq+h+5oCqJrIiwZAdfl0xVfoTHgnH8d
         5RKtBev+GG7aCYeWpS1QdJg3FgCny5D9Uuh+Q217NyQV8wpHOHl5iu33Cye3OSgiZ8dZ
         1IcstGJFvIQcaYl0A6FHve3ITG5DPAHAp3nviJgAIgj8BL8p4rc43WzMImx4iGS+PCY3
         gY4+pj2trABdl7zV2+14mQu74KflxAENB7+SD3atlNOToO4EvVHZaEpKy58ouD5ii3y6
         3Bnw==
X-Gm-Message-State: AOAM5313oDU3SeO0e4jga6B+i8PcWnVdxb4DIR9MaojbIjULkZp0wnhM
        BCcaHw2B7x2nzvDd+IP+7bXlAw==
X-Google-Smtp-Source: ABdhPJw/DQYQvuc/bPVXD5sw0KdGL88hPnQaEX3GNcMV+jcEwqOxu6/DVopF927dV95rzopmFxVShA==
X-Received: by 2002:ac2:57c7:: with SMTP id k7mr4882619lfo.606.1620032017411;
        Mon, 03 May 2021 01:53:37 -0700 (PDT)
Received: from wkz-x280 (static-193-12-47-89.cust.tele2.se. [193.12.47.89])
        by smtp.gmail.com with ESMTPSA id o24sm1171591ljj.69.2021.05.03.01.53.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 03 May 2021 01:53:36 -0700 (PDT)
From:   Tobias Waldekranz <tobias@waldekranz.com>
To:     Ido Schimmel <idosch@idosch.org>
Cc:     davem@davemloft.net, kuba@kernel.org, andrew@lunn.ch,
        vivien.didelot@gmail.com, f.fainelli@gmail.com, olteanv@gmail.com,
        roopa@nvidia.com, nikolay@nvidia.com, jiri@resnulli.us,
        stephen@networkplumber.org, netdev@vger.kernel.org,
        bridge@lists.linux-foundation.org
Subject: Re: [RFC net-next 4/9] net: bridge: switchdev: Forward offloading
In-Reply-To: <YI6/li9hwHo8GfCm@shredder>
References: <20210426170411.1789186-1-tobias@waldekranz.com> <20210426170411.1789186-5-tobias@waldekranz.com> <YI6/li9hwHo8GfCm@shredder>
Date:   Mon, 03 May 2021 10:53:36 +0200
Message-ID: <87eeeonqpb.fsf@waldekranz.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, May 02, 2021 at 18:04, Ido Schimmel <idosch@idosch.org> wrote:
> On Mon, Apr 26, 2021 at 07:04:06PM +0200, Tobias Waldekranz wrote:
>> +static void nbp_switchdev_fwd_offload_add(struct net_bridge_port *p)
>> +{
>> +	void *priv;
>> +
>> +	if (!(p->dev->features & NETIF_F_HW_L2FW_DOFFLOAD))
>> +		return;
>> +
>> +	priv = p->dev->netdev_ops->ndo_dfwd_add_station(p->dev, p->br->dev);
>
> Some changes to team/bond/8021q will be needed in order to get this
> optimization to work when they are enslaved to the bridge instead of the
> front panel port itself?

Right you are. We should probably do something similar to the
switchdev_handle_port_* family of helpers that could be reused in
stacked devices. I will look at it for v1.

>> +	if (!IS_ERR_OR_NULL(priv))
>> +		p->accel_priv = priv;
>> +}
>> +
>> +static void nbp_switchdev_fwd_offload_del(struct net_bridge_port *p)
>> +{
>> +	if (!p->accel_priv)
>> +		return;
>> +
>> +	p->dev->netdev_ops->ndo_dfwd_del_station(p->dev, p->accel_priv);
>> +	p->accel_priv = NULL;
>> +}
