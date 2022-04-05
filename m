Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DD8454F2E87
	for <lists+netdev@lfdr.de>; Tue,  5 Apr 2022 14:01:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343912AbiDEJPd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Apr 2022 05:15:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46566 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244976AbiDEIww (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Apr 2022 04:52:52 -0400
Received: from ssl.serverraum.org (ssl.serverraum.org [176.9.125.105])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E55C1D0DD;
        Tue,  5 Apr 2022 01:48:24 -0700 (PDT)
Received: from ssl.serverraum.org (web.serverraum.org [172.16.0.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ssl.serverraum.org (Postfix) with ESMTPSA id D943E221D4;
        Tue,  5 Apr 2022 10:48:21 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=walle.cc; s=mail2016061301;
        t=1649148502;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=x/+zyXUcDmdndIIui1WDqypJvYDMYDrXZERNBQ0ecKk=;
        b=aveEuHEhPZQK2Uwn++JVqUY23++YtQ2Iog5KE9xDadFiSBB9b3U5iB3yh8MN6rQH3Ij9Jq
        W4neXVvnU1lja2kSQ35ur8KKaEpcANmZUPVFd3h1XfmeGmmaenwP4aZ/Jaw3UgCKWoM+A7
        hJOlxIxVSNwizXEPqxE9Sj9Sd59uUbo=
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Tue, 05 Apr 2022 10:48:21 +0200
From:   Michael Walle <michael@walle.cc>
To:     Richard Cochran <richardcochran@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>, davem@davemloft.net,
        grygorii.strashko@ti.com, kuba@kernel.org, kurt@linutronix.de,
        linux-kernel@vger.kernel.org, linux@armlinux.org.uk,
        mlichvar@redhat.com, netdev@vger.kernel.org,
        qiangqing.zhang@nxp.com, vladimir.oltean@nxp.com,
        Horatiu Vultur <horatiu.vultur@microchip.com>
Subject: Re: [PATCH RFC V1 net-next 3/4] net: Let the active time stamping
 layer be selectable.
In-Reply-To: <20220405055954.GB91955@hoboy.vegasvil.org>
References: <20220104014215.GA20062@hoboy.vegasvil.org>
 <20220404150508.3945833-1-michael@walle.cc> <YksMvHgXZxA+YZci@lunn.ch>
 <e5a6f6193b86388ed7a081939b8745be@walle.cc>
 <20220405055954.GB91955@hoboy.vegasvil.org>
User-Agent: Roundcube Webmail/1.4.13
Message-ID: <d38744cbe67474b3c83b84547ec3cb4f@walle.cc>
X-Sender: michael@walle.cc
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Am 2022-04-05 07:59, schrieb Richard Cochran:
> On Mon, Apr 04, 2022 at 07:12:11PM +0200, Michael Walle wrote:
> 
>> That would make sense. I guess what bothers me with the current
>> mechanism is that a feature addition to the PHY in the *future* (the
>> timestamping support) might break a board - or at least changes the
>> behavior by suddenly using PHY timestamping.
> 
> That is a good point, but then something will break in any case.

Can the ethernet driver select the default one? So any current
driver which has "if phy_has_hwtstamp() forward_ioctl;" can set
it to PHY while newer drivers can (or should actually) leave it as
MAC.

This doesn't really fix the problem per se. But at least new
drivers won't be affected. For my problem at hand, I'd need to
convince Microchip to default to MAC although the driver is
already in the tree (but there is no user of it in mainline
right now).

-michael
