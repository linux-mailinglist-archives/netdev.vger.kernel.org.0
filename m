Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8BABA5986D9
	for <lists+netdev@lfdr.de>; Thu, 18 Aug 2022 17:06:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344034AbiHRPGK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Aug 2022 11:06:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34090 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344144AbiHRPF5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Aug 2022 11:05:57 -0400
Received: from ssl.serverraum.org (ssl.serverraum.org [176.9.125.105])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC3D377554;
        Thu, 18 Aug 2022 08:05:55 -0700 (PDT)
Received: from ssl.serverraum.org (web.serverraum.org [172.16.0.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ssl.serverraum.org (Postfix) with ESMTPSA id E47F922248;
        Thu, 18 Aug 2022 17:05:53 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=walle.cc; s=mail2016061301;
        t=1660835153;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=HiAnFI7kVMl6PXgrx9Z0nQjSTLDVTqf5Dg5Dp/xCy04=;
        b=Naxxk5zfgMsndAFJBEUHrYsp1llu3XuJV4ZWqdOLoYBgbT9o7K3IXapYC8ZEMnV+K9caT7
        NmAg9mtlrKQNfsLF3W+d3hyXKI4T5YumGvkQyhPGV5YfJwFCSxA1uz1el28u3OjdR/bgmV
        6e9WGMYSE76czWPDCE2RsNXGgThvKnc=
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Thu, 18 Aug 2022 17:05:53 +0200
From:   Michael Walle <michael@walle.cc>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     devicetree@vger.kernel.org, netdev@vger.kernel.org,
        Shawn Guo <shawnguo@kernel.org>, Leo Li <leoyang.li@nxp.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH devicetree 0/3] NXP LS1028A DT changes for multiple switch
 CPU ports
In-Reply-To: <20220818145556.ieg37btfny3o2i4q@skbuf>
References: <20220818140519.2767771-1-vladimir.oltean@nxp.com>
 <8d3d96cdede2f1e40ed9ae5742a0468d@walle.cc>
 <20220818145556.ieg37btfny3o2i4q@skbuf>
User-Agent: Roundcube Webmail/1.4.13
Message-ID: <04fb89b973011bf111795e1f17fac311@walle.cc>
X-Sender: michael@walle.cc
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Am 2022-08-18 16:55, schrieb Vladimir Oltean:
> On Thu, Aug 18, 2022 at 04:49:49PM +0200, Michael Walle wrote:
>> Is it used automatically or does the userspace has to configure 
>> something?
> 
> DSA doesn't yet support multiple CPU ports, but even when it will, the
> second DSA master still won't be used automatically. If you want more
> details about the proposed UAPI to use the second CPU port, see here:
> https://patchwork.kernel.org/project/netdevbpf/cover/20220523104256.3556016-1-olteanv@gmail.com/
> 
>> > Care has been taken that this change does not produce regressions when
>> > using updated device trees with old kernels that do not support multiple
>> > DSA CPU ports. The only difference for old kernels will be the
>> > appearance of a new net device (for &enetc_port3) which will not be very
>> > useful for much of anything.
>> 
>> Mh, I don't understand. Does it now cause regressions or not? I mean
>> besides that there is a new unused interface?
> 
> It didn't cause regressions until kernel 5.13 when commit adb3dccf090b
> ("net: dsa: felix: convert to the new .change_tag_protocol DSA API")
> happened, then commit 00fa91bc9cc2 ("net: dsa: felix: fix tagging
> protocol changes with multiple CPU ports") fixed that regression and 
> was
> backported to the linux-5.15.y stable branch AFAIR. So at least kernels
> 5.15 and newer should work properly with the new device trees.

Thanks for the details!

>> I was just thinking of that systemready stuff where the u-boot might
>> supply its (newer) device tree to an older kernel, i.e. an older 
>> debian
>> or similar.
>> 
>> -michael
> 
> Yeah, I hear you, I'm doing my best to make the driver work with a
> one-size-fits-all device tree, both ways around.

TBH I don't really care much, I was merely curious what to expect.

-michael
