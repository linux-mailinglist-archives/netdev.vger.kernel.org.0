Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D6B765839C6
	for <lists+netdev@lfdr.de>; Thu, 28 Jul 2022 09:46:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233314AbiG1Hqr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Jul 2022 03:46:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39538 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233586AbiG1Hqq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Jul 2022 03:46:46 -0400
Received: from smtp97.ord1d.emailsrvr.com (smtp97.ord1d.emailsrvr.com [184.106.54.97])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B1D9961703
        for <netdev@vger.kernel.org>; Thu, 28 Jul 2022 00:46:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=openvpn.net;
        s=20170822-45nk5nwl; t=1658994027;
        bh=Ll3lGOHj0SIoQtOcdzdr6ctTpQ/ZQPVtYA+Y55SrikI=;
        h=Date:Subject:To:From:From;
        b=Z+RYzJuxAeKcyyVCRG3+2jFgDavsQBuV36JsLrJ1tPe6u6BeRqO7P0IcZ69LFe9vV
         lGgfrW8ycInrKG6wT9NRcN/Sc9JEvBC82riV6ifFmXWMWd5utc79AuQ2qMWarTnMqq
         NNCmN9WnTCLd0BWqeYZfBlQN5Qjegc+XwMF76YSk=
X-Auth-ID: antonio@openvpn.net
Received: by smtp5.relay.ord1d.emailsrvr.com (Authenticated sender: antonio-AT-openvpn.net) with ESMTPSA id B74C6A00C2;
        Thu, 28 Jul 2022 03:40:26 -0400 (EDT)
Message-ID: <c490b87c-085b-baca-b7e4-c67a3ee2c25e@openvpn.net>
Date:   Thu, 28 Jul 2022 09:41:11 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [RFC 1/1] net: introduce OpenVPN Data Channel Offload (ovpn-dco)
Content-Language: en-US
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     netdev@vger.kernel.org, David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org
References: <20220719014704.21346-1-antonio@openvpn.net>
 <20220719014704.21346-2-antonio@openvpn.net> <YtbNBUZ0Kz7pgmWK@lunn.ch>
From:   Antonio Quartulli <antonio@openvpn.net>
Organization: OpenVPN Inc.
In-Reply-To: <YtbNBUZ0Kz7pgmWK@lunn.ch>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Classification-ID: 82aa384a-5660-44d4-8ad5-96a212e0778c-1-1
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On 19/07/2022 17:25, Andrew Lunn wrote:
>> +static void ovpn_get_drvinfo(struct net_device *dev,
>> +			     struct ethtool_drvinfo *info)
>> +{
>> +	strscpy(info->driver, DRV_NAME, sizeof(info->driver));
>> +	strscpy(info->version, DRV_VERSION, sizeof(info->version));
>> +	strscpy(info->bus_info, "ovpn", sizeof(info->bus_info));
> 
> version is generally considered useless information if it comes from
> the driver. You have no idea if this is version 42 in net-next, or
> some backported version in an enterprise kernel with lots of out of
> tree patches. The driver is not standalone, it runs inside the
> kernel. So in order to understand a bug report, you need to know what
> kernel it is. If you don't fill in version, the core will with the
> kernel version, which is much more useful.

True.

However, I guess I will still fill MODULE_VERSION() with a custom 
string. This may also be useful when building the module out-of-tree.

Thanks for the hint!

Regards,

-- 
Antonio Quartulli
OpenVPN Inc.
