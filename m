Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 664C76F15D3
	for <lists+netdev@lfdr.de>; Fri, 28 Apr 2023 12:38:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346096AbjD1Kiz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Apr 2023 06:38:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36172 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346085AbjD1Kic (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Apr 2023 06:38:32 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 521A365AF;
        Fri, 28 Apr 2023 03:37:25 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EF4BE642BD;
        Fri, 28 Apr 2023 10:37:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F35DC433D2;
        Fri, 28 Apr 2023 10:37:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1682678236;
        bh=eQ9xBGX1D8+UsnYpVKT1xrfqrnmge5hf6pL7SNX8uV8=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=tSpIYkzO+xF3i0eu48LUXJdw3UTD/mm+XlpnP/iitRKdPTW+fyvPXUX4L4Cy17o31
         ry1wMlddQd42+p1DN3+qkzBqWhDH57kze8VDGugSQ6TKv8Jb6D1tsU7JIEDQXE8U7n
         6Kax4ae43fKgQgv3vWCaKfxMoQmbhq3ZqalKA2PBiNpvQNYH9m+fxiaCSeEa2GIBoq
         tBuXKLBiqmEFtQYL0sm0DX1CG6W/0hmtNdvkWhIQIVZwamrKYc+/A5IUXOT66OWSGi
         OQ3pjX+B6X5BK1bj4UZVMIXnep3cjn2XBNu64E1TmG5IHLR+g9YfCN0L3LaYwz10V9
         +TwLh6qnsJ46A==
From:   Kalle Valo <kvalo@kernel.org>
To:     Ping-Ke Shih <pkshih@realtek.com>
Cc:     Johannes Berg <johannes@sipsolutions.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "netdev\@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-wireless\@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: pull-request: wireless-next-2023-04-21
References: <20230421104726.800BCC433D2@smtp.kernel.org>
        <20230421075404.63c04bca@kernel.org>
        <e31dae6daa6640859d12bf4c4fc41599@realtek.com>
        <87leigr06u.fsf@kernel.org> <20230425071848.6156c0a0@kernel.org>
        <77cf7fa9de20be55d50f03ccbdd52e3c8682b2b3.camel@sipsolutions.net>
        <c69f151c77f34ae594dc2106bc68f2ac@realtek.com>
        <1a38a4289ef34672a2bc9a880e8608a8@realtek.com>
        <7214a6a800e4af80b9319c30b13cc52286bba50a.camel@sipsolutions.net>
        <ecaaf616d04d4e0b9303e1c680eefea7@realtek.com>
Date:   Fri, 28 Apr 2023 13:37:11 +0300
In-Reply-To: <ecaaf616d04d4e0b9303e1c680eefea7@realtek.com> (Ping-Ke Shih's
        message of "Thu, 27 Apr 2023 00:38:45 +0000")
Message-ID: <87h6t0s36w.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-4.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Ping-Ke Shih <pkshih@realtek.com> writes:

>> > > If loading a table_v1 table, for example, we need to convert to table_cpu by
>> > > some rules. Also, maybe we need to disable some features relay on the values
>> > > introduced by table_cpu. I think it will work, but just add some flags and
>> > > rules to handle them.
>> 
>> But wouldn't this basically be tied to a driver? I mean you could have a
>> file called "rtlwifi/rtlxyz.v1.tables" that the driver in kernel 6.4
>> loads, and ...v2... that the driver in 6.5 loads, and requires for
>> operation?
>> 
>> Then again - it'd be better if the driver in 6.5 can deal with it if a
>> user didn't install the v2 file yet, is that what you meant?
>
> Yes, this is my point, and I think 6.5 _must_ deal with v1 file.

I agree. In this example the time between v6.4 and v6.5 is roughly three
months, so we can't drop v1 support that fast as there will be people
upgrading their kernels but don't have the v2 firmware file yet.

I would say supporting one year is too short (think LTS distros etc) so
to be on the safe side we should support old firmware files at least for
two years. That's a long time.

> Considering below artificial drama: 
>
> 1. kernel 6.4, driver support 2GHz channels only (table v1)
>    __le32 channel_tx_power_v1[2GHz_NUM]
>
> 2. kernel 6.5, driver support 2 + 5GHz channels (table v2)
>    __le32 channel_tx_power_v2[2GHz_NUM + 5GHz_NUM]
>
>    A user could not install v2, so I need a conversion, like
>    convert_v1_to_v2(struct table_v1 *v1, struct table_v2 *v2) // also
> disable 5GHz channels
>
> 3. kernel 6.6, driver support 2 + 5 + 6GHz channels (table v3)
>    __le32 channel_tx_power_v2[2GHz_NUM + 5GHz_NUM + 6GHz_NUM]
>    A user could not install v3, so I need an additional conversion, like
>    convert_v2_to_v3(struct table_v2 *v2, struct table_v3 *v3) // also
> disable 6GHz channels

This is exactly what I'm worried about. And we have also the case that
user space doesn't have the initval.bin file at all so we need to have
initvals in kernel for something like two years.

> If more table versions are introduced, more conversions are needed. Also,
> I'm not sure how these tables can change in the future, so the conversion
> may be complicated if they have a big change for certain reason. 
>
> My point is that this work is possible, but introduce some extra works that
> maybe look a little dirty. 

Also I agree here. This creates complexity and that of course increases
the risk of bugs. Even if it sounds simple, in practise it's not. Of
course if the initvals don't change then it's easier, but I would not
rely on that.

-- 
https://patchwork.kernel.org/project/linux-wireless/list/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
