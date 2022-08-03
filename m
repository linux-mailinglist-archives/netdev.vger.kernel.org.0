Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C9E27589427
	for <lists+netdev@lfdr.de>; Wed,  3 Aug 2022 23:50:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236172AbiHCVuy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Aug 2022 17:50:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59508 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230499AbiHCVuv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Aug 2022 17:50:51 -0400
Received: from mout-p-102.mailbox.org (mout-p-102.mailbox.org [80.241.56.152])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B59012AB4
        for <netdev@vger.kernel.org>; Wed,  3 Aug 2022 14:50:49 -0700 (PDT)
Received: from smtp202.mailbox.org (smtp202.mailbox.org [10.196.197.202])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mout-p-102.mailbox.org (Postfix) with ESMTPS id 4LylsY72Kjz9sWs;
        Wed,  3 Aug 2022 23:50:41 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=hauke-m.de; s=MBO0001;
        t=1659563442;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=HrDB1FJmX3eJcNlh/cbZQbmXSa233OQKWPwEqYZoh1E=;
        b=GuIpO27nQ6ASpePo5DLJj9aErV4Bd59uJNLOoGf5jiCnFZ56t7XkO93W+/MgYgz4GboACO
        Nj+/V+ZY6uUXrBbEKpEMMz5Oxciw3t2BLA9FjNQLtIyc1HL8NVWhd3HBRhqM9qKqEg5YGm
        RT1d9xV6OZpLrjijOiv/baFpSiNJ05M+ub5+hhFvpinQzXxLWOy/nW5ihB59Y9eH+03yO6
        SqlBxq5zKbSFJiaGrajMOsAkyWP0jLgumQ/CNVAr0vOfyHUwrMJi9PrToo6Cw+VZ6bP372
        BQgWdt4CueJOMp5gAfcPwTACxeZvm2NEHmhGz2HRWAgZVPhtm6PvotYFUanQ0Q==
Message-ID: <8c0a6740-3e00-bfc2-0b95-c4fcce8b7314@hauke-m.de>
Date:   Wed, 3 Aug 2022 23:50:40 +0200
MIME-Version: 1.0
Content-Language: en-US
To:     Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
        Vladimir Oltean <olteanv@gmail.com>
Cc:     netdev@vger.kernel.org, andrew@lunn.ch, vivien.didelot@gmail.com,
        f.fainelli@gmail.com, Aleksander Jan Bajkowski <olek2@wp.pl>
References: <CAFBinCDX5XRyMyOd-+c_Zkn6dawtBpQ9DaPkA4FDC5agL-t8CA@mail.gmail.com>
 <20220727224409.jhdw3hqfta4eg4pi@skbuf>
 <CAFBinCD5yQodsv0PoqnqVA6F7uMkoD-_mUxi54uAHc9Am7V-VQ@mail.gmail.com>
From:   Hauke Mehrtens <hauke@hauke-m.de>
Subject: Re: net: dsa: lantiq_gswip: getting the first selftests to pass
In-Reply-To: <CAFBinCD5yQodsv0PoqnqVA6F7uMkoD-_mUxi54uAHc9Am7V-VQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Martin,


On 7/29/22 00:09, Martin Blumenstingl wrote:
......
> The vendor driver lists a bunch of possible tables: [1]
> I'll leave any effort for multicast out for now... it's not the main
> use-case I am looking at right now.

Most of these tables are needed because the switch HW can do layer 3 
(IP) multicast handling. I think normally Linux takes care of this with 
DSA drivers and we only tell the switch where to forward based on MAC 
addresses.

> As always: thank you for your amazing explanations, hints and pointers!
> Also I would like to point out that I am still doing all of this in my
> spare time. Whenever you have other conversations to focus on: please
> do so! For me it's not critical if you're getting back to me a few
> days sooner or later.
> 
> 
> Best regards,
> Martin
> 
> 
> [0] https://github.com/paldier/K3C/blob/ca7353eb397090c363632409d9ca568d3cca09c7/ugw/target/linux/lantiq/patches-3.10/7000-NET-lantiq-adds-eth-drv.patch#L2238-L2259
> [1] https://github.com/paldier/K3C/blob/ca7353eb397090c363632409d9ca568d3cca09c7/ugw/target/linux/lantiq/files/drivers/net/ethernet/lantiq/switch-api/ltq_flow_core.h#L164-L192

