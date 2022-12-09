Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D8E016483B4
	for <lists+netdev@lfdr.de>; Fri,  9 Dec 2022 15:23:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229573AbiLIOX4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Dec 2022 09:23:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52222 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229478AbiLIOXz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Dec 2022 09:23:55 -0500
Received: from mail.3ffe.de (0001.3ffe.de [159.69.201.130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 74FBEB4F;
        Fri,  9 Dec 2022 06:23:53 -0800 (PST)
Received: from 3ffe.de (0001.3ffe.de [IPv6:2a01:4f8:c0c:9d57::1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.3ffe.de (Postfix) with ESMTPSA id 9C679AF;
        Fri,  9 Dec 2022 15:23:51 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=walle.cc; s=mail2022082101;
        t=1670595831;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=NifOSNWB92nr9zdJqZWuAae4bxP0JcnlApZOWYNFsvk=;
        b=CSfA2QIN5g1v+j62kncWBfSYn6+ojnC6DlB1u4BE0c9FrTDrrVwdTuN6tLzzovd0nDgmrf
        4px28kLYMCoi6O4h/CSOqjCf807+n5F3HWPXmn4Sa/EyvtfGcnY6vYwXcoCqNd2314dl8F
        Hv+llZo6ZCwrghRjLrQ9XkcrNeIMia8dGtcRrOqacVjQcLWBjhpzfDm6DCgaQG3WoJnXAe
        bayGOBjuD3/9RKtMv7ugrn10nrxqKk6j0rt2l1aJKwsQcfTdLw1bjueWitgg8n0ajNJZuk
        u/tQwGRkHKamcwIznnneV3rXxXac3GHMjt0T65yewZU4mEAcUEa5yQ3oEGXtiw==
MIME-Version: 1.0
Date:   Fri, 09 Dec 2022 15:23:51 +0100
From:   Michael Walle <michael@walle.cc>
To:     Horatiu Vultur <horatiu.vultur@microchip.com>
Cc:     Vladimir Oltean <olteanv@gmail.com>, Steen.Hegelund@microchip.com,
        UNGLinuxDriver@microchip.com, daniel.machon@microchip.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        lars.povlsen@microchip.com, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        pabeni@redhat.com, richardcochran@gmail.com
Subject: Re: [PATCH net-next v3 4/4] net: lan966x: Add ptp trap rules
In-Reply-To: <20221209142058.ww7aijhsr76y3h2t@soft-dev3-1>
References: <20221203104348.1749811-5-horatiu.vultur@microchip.com>
 <20221208092511.4122746-1-michael@walle.cc>
 <c8b2ef73330c7bc5d823997dd1c8bf09@walle.cc>
 <20221208130444.xshazhpg4e2utvjs@soft-dev3-1>
 <adb8e2312b169d13e756ff23c45872c3@walle.cc>
 <20221209092904.asgka7zttvdtijub@soft-dev3-1>
 <c8b755672e20c223a83bc3cd4332f8cd@walle.cc>
 <20221209125857.yhsqt4nj5kmavhmc@soft-dev3-1>
 <20221209125611.m5cp3depjigs7452@skbuf>
 <a821d62e2ed2c6ec7b305f7d34abf0ba@walle.cc>
 <20221209142058.ww7aijhsr76y3h2t@soft-dev3-1>
User-Agent: Roundcube Webmail/1.4.13
Message-ID: <287d650a96aaac34ac2f31c6735a9ecc@walle.cc>
X-Sender: michael@walle.cc
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Am 2022-12-09 15:20, schrieb Horatiu Vultur:
> The 12/09/2022 15:05, Michael Walle wrote:
>> 
>> Am 2022-12-09 13:56, schrieb Vladimir Oltean:
>> > On Fri, Dec 09, 2022 at 01:58:57PM +0100, Horatiu Vultur wrote:
>> > > > Does it also work out of the box with the following patch if
>> > > > the interface is part of a bridge or do you still have to do
>> > > > the tc magic from above?
>> > >
>> > > You will still need to enable the TCAM using the tc command to have it
>> > > working when the interface is part of the bridge.
>> >
>> > FWIW, with ocelot (same VCAP mechanism), PTP traps work out of the box,
>> > no need to use tc. Same goes for ocelot-8021q, which also uses the
>> > VCAP.
>> > I wouldn't consider forcing the user to add any tc command in order for
>> > packet timestamping to work properly.
> 
> On ocelot, the vcap is enabled at port initialization, while on other
> platforms(lan966x and sparx5) you have the option to enable or disable.
> 
>> 
>> +1
>> Esp. because there is no warning. I.e. I tried this patch while
>> the interface was added on a bridge and there was no error
>> whatsoever.
> 
> What error/warning were you expecting to see here?

Scrap that. ptp4l is reporting an error in case the device is part
of a bridge:
Jan  1 02:33:04 buildroot user.info syslog: [9184.261] driver rejected 
most general HWTSTAMP filter

Nevertheless, from a users POV I'd just expect it to work. How
would I know what I need to do here?

-michael
