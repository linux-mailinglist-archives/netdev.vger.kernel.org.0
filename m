Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9A61A691CAA
	for <lists+netdev@lfdr.de>; Fri, 10 Feb 2023 11:27:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231991AbjBJK07 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Feb 2023 05:26:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43588 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231981AbjBJK04 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Feb 2023 05:26:56 -0500
Received: from proxima.lasnet.de (proxima.lasnet.de [IPv6:2a01:4f8:121:31eb:3::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6697C1CAFC;
        Fri, 10 Feb 2023 02:26:53 -0800 (PST)
Received: from [IPV6:2003:e9:d71c:6322:74ec:14c2:8524:4a70] (p200300e9d71c632274ec14c285244a70.dip0.t-ipconnect.de [IPv6:2003:e9:d71c:6322:74ec:14c2:8524:4a70])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: stefan@datenfreihafen.org)
        by proxima.lasnet.de (Postfix) with ESMTPSA id BB66CC0373;
        Fri, 10 Feb 2023 11:26:46 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=datenfreihafen.org;
        s=2021; t=1676024807;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ju3Hx/jGSJmwOHCOh/WdznTNaA9KP303KEhcoPdeULE=;
        b=XGRkn4bupsqeypu/NCTTutDiU7p1ozkUg6apRleEQ0SoihagXIp9nBt1Of6wIa3WaMSsQ3
        o9LBGGzOi2efvXZ5yxTTtenVf9j4z/UltjuY7DwSjJqTiS3uy+qimbTnS4pvpykiqiIbOp
        u9f1MqzjxOpowOM98QZMnEST1owJd5hzkFqtiBbifAdnnTrxn6LSfrZYN8xI0fecZ/PcHL
        IfpxPpO9p1/XDltEj2gQlBU3BgUCamlS0u1oF1FRMkyVdGXGwSdKNqhkGQssgF7q6dYq35
        wbgSjQqH+QhbP5AbnYcQCia3PBndIT3l9/VRpNtOCFH5oZF+rZr91vP+Fk3/hQ==
Message-ID: <47d8bd5f-a384-41fd-8d42-0b5037c4a7a5@datenfreihafen.org>
Date:   Fri, 10 Feb 2023 11:26:45 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.0
Subject: Re: [PATCH wpan-next 1/6] ieee802154: Add support for user scanning
 requests
Content-Language: en-US
To:     Miquel Raynal <miquel.raynal@bootlin.com>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Alexander Aring <alex.aring@gmail.com>, linux-wpan@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>, netdev@vger.kernel.org,
        David Girault <david.girault@qorvo.com>,
        Romuald Despres <romuald.despres@qorvo.com>,
        Frederic Blain <frederic.blain@qorvo.com>,
        Nicolas Schodet <nico@ni.fr.eu.org>,
        Guilhem Imberton <guilhem.imberton@qorvo.com>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>
References: <20221129160046.538864-1-miquel.raynal@bootlin.com>
 <20221129160046.538864-2-miquel.raynal@bootlin.com>
 <20230203201923.6de5c692@kernel.org> <20230210111843.0817d0d3@xps-13>
From:   Stefan Schmidt <stefan@datenfreihafen.org>
In-Reply-To: <20230210111843.0817d0d3@xps-13>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello.

On 10.02.23 11:18, Miquel Raynal wrote:
> Hi Stefan, Jakub,
> 
> kuba@kernel.org wrote on Fri, 3 Feb 2023 20:19:23 -0800:
> 
>> On Tue, 29 Nov 2022 17:00:41 +0100 Miquel Raynal wrote:
>>> +static int nl802154_trigger_scan(struct sk_buff *skb, struct genl_info *info)
>>> +{
>>> +	struct cfg802154_registered_device *rdev = info->user_ptr[0];
>>> +	struct net_device *dev = info->user_ptr[1];
>>> +	struct wpan_dev *wpan_dev = dev->ieee802154_ptr;
>>> +	struct wpan_phy *wpan_phy = &rdev->wpan_phy;
>>> +	struct cfg802154_scan_request *request;
>>> +	u8 type;
>>> +	int err;
>>> +
>>> +	/* Monitors are not allowed to perform scans */
>>> +	if (wpan_dev->iftype == NL802154_IFTYPE_MONITOR)
>>
>> extack ?
> 
> Thanks for pointing at it, I just did know about it. I did convert
> most of the printk's into extack strings. Shall I keep both or is fine
> to just keep the extack thing?
> 
> For now I've dropped the printk's, please tell me if this is wrong.
> 
>>
>>> +		return -EPERM;
> 
> Stefan, do you prefer a series of patches applying on top of your
> current next or should I re-roll the entire series (scan + beacons)?
> 
> I am preparing a series applying on top of the current list of applied
> patches. This means next PR to net maintainers will include this patch
> as it is today + fixes on top. If this is fine for both parties, I will
> send these (including the other changes discussed with Alexander). Just
> let me know.

On top please. The other patches are already sitting in a published git 
tree and I want to avoid doing a rebase on the published tree.

Once your new patches are in and Jakub is happy I will send an updated 
pull request with them included.

regards
Stefan Schmidt
