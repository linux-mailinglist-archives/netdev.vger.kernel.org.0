Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 895CE2CC931
	for <lists+netdev@lfdr.de>; Wed,  2 Dec 2020 22:55:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727107AbgLBVxk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Dec 2020 16:53:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55406 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726330AbgLBVxj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Dec 2020 16:53:39 -0500
Received: from mail-lj1-x242.google.com (mail-lj1-x242.google.com [IPv6:2a00:1450:4864:20::242])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA884C0617A6
        for <netdev@vger.kernel.org>; Wed,  2 Dec 2020 13:52:53 -0800 (PST)
Received: by mail-lj1-x242.google.com with SMTP id f18so151819ljg.9
        for <netdev@vger.kernel.org>; Wed, 02 Dec 2020 13:52:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=waldekranz-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:in-reply-to:references:date:message-id
         :mime-version;
        bh=XyjX/fs9Z7bN9b5QBOdnmNso+3wrDaa2Akw13bXcGw8=;
        b=UwRZ7HvkVE+LhDr+XXJ+ivs8E3y3Sl3PrGrUdo8tOZO/DE8lwHc00xFSQA6PSwJ2iN
         NuPGbRU4JE3XEe9d93fyIWMnzoht9QxN82xZa2m6JqmundUWdRQTd3oJkRtCLMRXGU2X
         UbPSdmcOtLgbGvAkk2Qz5cOr6DKXyWyRFRO+AavpPncxc32pA614pxClZ77AlJw+jBxy
         Q/NlSeSfDjWiwVxJjUJodI8apSTLNnWTkBKrMwAw3VTZKtdWJHP/xsAvsU9Vl5QI1QqA
         quXdGhWR6QVzcMHjsuvztqgjrKw38eLQx0CGxSctVXE5FKIPAGyKL796L16k+YTqyIBD
         0eCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=XyjX/fs9Z7bN9b5QBOdnmNso+3wrDaa2Akw13bXcGw8=;
        b=HwWFCAUHmTASDrfb1RV/huyk8onx9xlQGxanTcCtALtShzyuMxlrY3ZBxAnM+8lwwc
         ytRkXP+/0t8XRi5XMiWSyed7oVtnTUOLmSrjETT2qvme8gCTT1F3KVAA0ZR+ARrXEudD
         xn2vamN/MCA8hqozfHhL477DAR47Q2Ru+PUCVatn/yjyjOGeUuK0D1jZLi8phU5qtCn/
         dn2f74BWMO7/FQjbgI4oyKkwcyHOl1nZQoI+X6/qooXB2IyY8QbI3Kr2QE7JetmPtuyE
         bzZjPtwpiIY6N60IxbqJfjYVgoKGIc+Z8kWtxTjs/H0DAqPiEkd1c1KRf4UT9/9KktUj
         9UJg==
X-Gm-Message-State: AOAM533a3Q0lV9xo6XXeVkL+4AjxDOsWhoSdvXpsWYhe9eT7OMUvc2J+
        eVKTOKhsEwV3wZyWG7Umpu24xOvFg0w/oAKe
X-Google-Smtp-Source: ABdhPJzNJBjVX9RkJv789PtJokxJnwZoc9lKSt3V4Ucf1fSE/sQsC90wDnuaeIByZiwZi3OIr2EvSg==
X-Received: by 2002:a05:651c:2005:: with SMTP id s5mr2182558ljo.36.1606945971913;
        Wed, 02 Dec 2020 13:52:51 -0800 (PST)
Received: from wkz-x280 (h-236-82.A259.priv.bahnhof.se. [98.128.236.82])
        by smtp.gmail.com with ESMTPSA id u28sm883267lfg.232.2020.12.02.13.52.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Dec 2020 13:52:51 -0800 (PST)
From:   Tobias Waldekranz <tobias@waldekranz.com>
To:     Jay Vosburgh <jay.vosburgh@canonical.com>
Cc:     davem@davemloft.net, kuba@kernel.org, andrew@lunn.ch,
        vivien.didelot@gmail.com, f.fainelli@gmail.com, olteanv@gmail.com,
        vfalico@gmail.com, andy@greyhouse.net, netdev@vger.kernel.org
Subject: Re: [PATCH v3 net-next 1/4] net: bonding: Notify ports about their initial state
In-Reply-To: <17902.1606936179@famine>
References: <20201202091356.24075-1-tobias@waldekranz.com> <20201202091356.24075-2-tobias@waldekranz.com> <17902.1606936179@famine>
Date:   Wed, 02 Dec 2020 22:52:50 +0100
Message-ID: <87h7p37u4t.fsf@waldekranz.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Dec 02, 2020 at 11:09, Jay Vosburgh <jay.vosburgh@canonical.com> wrote:
> Tobias Waldekranz <tobias@waldekranz.com> wrote:
>
>>When creating a static bond (e.g. balance-xor), all ports will always
>>be enabled. This is set, and the corresponding notification is sent
>>out, before the port is linked to the bond upper.
>>
>>In the offloaded case, this ordering is hard to deal with.
>>
>>The lower will first see a notification that it can not associate with
>>any bond. Then the bond is joined. After that point no more
>>notifications are sent, so all ports remain disabled.
>>
>>This change simply sends an extra notification once the port has been
>>linked to the upper to synchronize the initial state.
>
> 	I'm not objecting to this per se, but looking at team and
> net_failover (failover_slave_register), those drivers do not send the
> same first notification that bonding does (the "can not associate" one),
> but only send a notification after netdev_master_upper_dev_link is
> complete.
>
> 	Does it therefore make more sense to move the existing
> notification within bonding to take place after the upper_dev_link
> (where you're adding this new call to bond_lower_state_changed)?  If the
> existing notification is effectively useless, this would make the
> sequence of notifications consistent across drivers.

From my point of view that makes more sense. I just assumed that the
current implementation was done this way for a reason. Therefore I opted
for a simple extension instead.

I could look at hoisting up the linking op before the first
notification. My main concern is that this is a new subsystem to me, so
I am not sure how to determine the adequate test coverage for a change
like this.

Another option would be to drop this change from this series and do it
separately. It would be nice to have both team and bond working though.

Not sure why I am the first to run into this. Presumably the mlxsw LAG
offloading would be affected in the same way. Maybe their main use-case
is LACP.
