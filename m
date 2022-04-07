Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9E51E4F824E
	for <lists+netdev@lfdr.de>; Thu,  7 Apr 2022 16:58:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344375AbiDGPAq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Apr 2022 11:00:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60324 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240568AbiDGPAp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Apr 2022 11:00:45 -0400
Received: from ssl.serverraum.org (ssl.serverraum.org [176.9.125.105])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7EF1D1EF9D7;
        Thu,  7 Apr 2022 07:58:45 -0700 (PDT)
Received: from ssl.serverraum.org (web.serverraum.org [172.16.0.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ssl.serverraum.org (Postfix) with ESMTPSA id BDAF722175;
        Thu,  7 Apr 2022 16:58:43 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=walle.cc; s=mail2016061301;
        t=1649343524;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=F61f4C5OVGJ8qIEodIfj1jV31MSPywO8q/FGuuevK5I=;
        b=HTxX8F6hdNb9QUY+23OfsA9JLqLmwAXjcnbDN7FR0fBJhV9ZIsEMkOttp7/m0aGV0bkkgn
        y0Mb7OKjyqReANN7NCZgGNH6k+jwScdgYtXZm4JiESFwrecLs3ATd2CESlrNw+qWqCplg4
        ITnJilXjp1yDJwHak/tonfJIBufDysk=
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Thu, 07 Apr 2022 16:58:43 +0200
From:   Michael Walle <michael@walle.cc>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, UNGLinuxDriver@microchip.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next] net: dsa: felix: suppress -EPROBE_DEFER errors
In-Reply-To: <20220407141254.3kpg75l4byytwfye@skbuf>
References: <20220407130625.190078-1-michael@walle.cc>
 <20220407135613.rlblrckb2h633bps@skbuf>
 <cd433399998c2f58884f08b4fc0fd66a@walle.cc>
 <20220407141254.3kpg75l4byytwfye@skbuf>
User-Agent: Roundcube Webmail/1.4.13
Message-ID: <c9e8d4940e6c4a3540d67ca3f13ca484@walle.cc>
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


>> > > Should this be a patch with a Fixes tag?
>> >
>> > Whichever way you wish, no preference.
>> 
>> I'll limit it to just the one dev_err() and add a Fixes,
>> there might be scripts out there who greps dmesg for errors.
> 
> Ok.

Hum, it's not that easy. The issue goes back all the way
to the initial commit if I didn't miss anything (56051948773e).
That one was first included in 5.5, but dev_err_probe() wasn't
added until 5.9.

Thus will it work if I add Fixes: 56051948773e (..)?

-michael
