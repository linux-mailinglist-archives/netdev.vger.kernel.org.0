Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C5F522F5C04
	for <lists+netdev@lfdr.de>; Thu, 14 Jan 2021 09:07:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728091AbhANIFv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Jan 2021 03:05:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38800 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727796AbhANIFt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Jan 2021 03:05:49 -0500
Received: from mail-lf1-x12b.google.com (mail-lf1-x12b.google.com [IPv6:2a00:1450:4864:20::12b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4168CC061575
        for <netdev@vger.kernel.org>; Thu, 14 Jan 2021 00:05:09 -0800 (PST)
Received: by mail-lf1-x12b.google.com with SMTP id o17so6788640lfg.4
        for <netdev@vger.kernel.org>; Thu, 14 Jan 2021 00:05:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=waldekranz-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:in-reply-to:references:date:message-id
         :mime-version;
        bh=rEV99XY3GMDWimSw2llrIOzlEPPsR//pKRSwtzrTB/8=;
        b=NnOsIoGxQeAu5Ye2wWLFfaoI0/Yu2r2UgPyBemjgUrU5jFzvBqOHUwslnOnUdk0RO8
         +SuOQHbI1fRrYS/lB/R37lJ/goNrNdJ/IMTfuiEnh1fG6QepfhOFTw8au6BcIKY8RWWh
         PPa//tktspMsrBce2VeMIruQ1vXkpDBc1j75D4PjFnyLWpzmT1GBt2/sTEzpnhQBFvFW
         6RRXOV9sQlAXf4KzxTKkcsS5BvfrJPNMb/kUIm3D6kJgySrnlmLy3CgTmUZY19ovvrQ9
         R+pcMTkK2ASFjTVvTlXaJuzqo2DGNG+gZSR/lYR9RvP5CbfZkr/pfWfOOKzthsitEGRm
         QUxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=rEV99XY3GMDWimSw2llrIOzlEPPsR//pKRSwtzrTB/8=;
        b=m7fRUb+k7ohY+bYYNypIZyDgWjBLC68nixxjKzR7VhPCBJYbDKnxBT1YS6s+syyBoS
         1C0xdNXJzKqPtKVwjRjoHLijO4pjjwJcL1yZKgT7n/13p2u+e0HunL4gV3bW7hieK6N/
         hjv7NzGhRCDHQXtyVPnTzCM7bccwqvpCZlFwrezocgW6W5ZCb7c5tjLVQFMBJ15IdKjQ
         JUvuHlNbIIHo5yKkY1SLYaOlUOEl0K1QzYWwE/Sp34Gsvp8FyKmi3muF/gwc4z0tlEZD
         hW8+lEYOR0BE/aR7K5ujujv2Sr0CEZwQCBs/JqkpMeViJdTouD85+M5qUmssDTZyY7Uy
         MV6Q==
X-Gm-Message-State: AOAM531G+qS8yQtAYj+/KFUdqEiPHxFzNPtSK9O3ewkDv/yxNo+gjx5H
        UKeUE1GiviixY7ZTT1/GcMh26tQNkFVBMHRN
X-Google-Smtp-Source: ABdhPJxhRXZ7hWGmn7wdUqb+5V6fS4jNWlsM0sgNUjdShvn2zE6uVY3IL1mHuECdJWf1LXWYeieMfw==
X-Received: by 2002:ac2:57d2:: with SMTP id k18mr2643078lfo.500.1610611507649;
        Thu, 14 Jan 2021 00:05:07 -0800 (PST)
Received: from wkz-x280 (h-236-82.A259.priv.bahnhof.se. [98.128.236.82])
        by smtp.gmail.com with ESMTPSA id k25sm468738lfm.236.2021.01.14.00.05.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 Jan 2021 00:05:07 -0800 (PST)
From:   Tobias Waldekranz <tobias@waldekranz.com>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, andrew@lunn.ch,
        vivien.didelot@gmail.com, f.fainelli@gmail.com,
        j.vosburgh@gmail.com, vfalico@gmail.com, andy@greyhouse.net,
        netdev@vger.kernel.org
Subject: Re: [PATCH v5 net-next 4/5] net: dsa: mv88e6xxx: Link aggregation support
In-Reply-To: <20210114005016.2xgdexp2vkp3xmst@skbuf>
References: <20210113084255.22675-1-tobias@waldekranz.com> <20210113084255.22675-5-tobias@waldekranz.com> <20210114005016.2xgdexp2vkp3xmst@skbuf>
Date:   Thu, 14 Jan 2021 09:05:06 +0100
Message-ID: <87pn28kkp9.fsf@waldekranz.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 14, 2021 at 02:50, Vladimir Oltean <olteanv@gmail.com> wrote:
> On Wed, Jan 13, 2021 at 09:42:54AM +0100, Tobias Waldekranz wrote:
>> Support offloading of LAGs to hardware. LAGs may be attached to a
>> bridge in which case VLANs, multicast groups, etc. are also offloaded
>> as usual.
>> 
>> Signed-off-by: Tobias Waldekranz <tobias@waldekranz.com>
>> ---
>
> Reviewed-by: Vladimir Oltean <olteanv@gmail.com>

Thanks!

>> +static bool mv88e6xxx_lag_can_offload(struct dsa_switch *ds,
>> +				      struct net_device *lag,
>> +				      struct netdev_lag_upper_info *info)
>> +{
>> +	struct dsa_port *dp;
>> +	int id, members = 0;
>> +
>> +	id = dsa_lag_id(ds->dst, lag);
>> +	if (id < 0 || id >= ds->num_lag_ids)
>
> This "id >= ds->num_lag_ids" condition is there just in the off chance
> that the mv88e6xxx could be bridged in the same DSA tree with another
> device that reports a higher ds->num_lag_ids such that dst->lags_len
> picks up that larger maximum, but otherwise the two switches have the
> same understanding of the LAG ID, and are compatible with one another?

Exactly so.

> That sounds... plausible?

While improbable, it is possible. Older 6xxx chips can only handle 16
LAGs, newer chips can handle up to 32. This is not supported by the
driver at the moment - still it felt easier to add the check now, rather
than having the future developer chase down the resulting bug in five
years when they add that support.
