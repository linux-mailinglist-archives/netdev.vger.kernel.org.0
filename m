Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 16D8A4EA345
	for <lists+netdev@lfdr.de>; Tue, 29 Mar 2022 00:51:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230202AbiC1WwO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Mar 2022 18:52:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43828 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230204AbiC1WwM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Mar 2022 18:52:12 -0400
Received: from ssl.serverraum.org (ssl.serverraum.org [176.9.125.105])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A875C184B7B;
        Mon, 28 Mar 2022 15:50:30 -0700 (PDT)
Received: from ssl.serverraum.org (web.serverraum.org [172.16.0.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ssl.serverraum.org (Postfix) with ESMTPSA id EB8752223A;
        Tue, 29 Mar 2022 00:50:28 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=walle.cc; s=mail2016061301;
        t=1648507829;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=I3gaFBZ3yrJ/2YMqtccYFL35SLVJmtDTn3J7H7rEt9c=;
        b=hWLUxypQgRZr78sXGVpo5Nkeun38pUDKWStQjgtG3J/2yyhkxgX4DFujkPn4hTI/Bx9W5r
        rPUNcD6anjzaWJ0NHiohCJr6wYCFRjhY2syHsUDQMgGkrB0AyG52ohTbwzoq4BN5kzJJ1k
        VAvt5lWjB+Xa/BkuE3u8OrAfYMiYQPA=
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Tue, 29 Mar 2022 00:50:28 +0200
From:   Michael Walle <michael@walle.cc>
To:     Guenter Roeck <linux@roeck-us.net>
Cc:     Andrew Lunn <andrew@lunn.ch>, Xu Yilun <yilun.xu@intel.com>,
        Tom Rix <trix@redhat.com>, Jean Delvare <jdelvare@suse.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, linux-hwmon@vger.kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH v1 0/2] hwmon: introduce hwmon_sanitize()
In-Reply-To: <ab64105b-c48d-cdf2-598a-3e0a2e261b27@roeck-us.net>
References: <20220328115226.3042322-1-michael@walle.cc>
 <YkGwjjUz+421O2E1@lunn.ch>
 <ab64105b-c48d-cdf2-598a-3e0a2e261b27@roeck-us.net>
User-Agent: Roundcube Webmail/1.4.13
Message-ID: <e87c3ab2a0c188dced27bf83fc444c40@walle.cc>
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

Am 2022-03-28 18:27, schrieb Guenter Roeck:
> On 3/28/22 05:56, Andrew Lunn wrote:
>>> I'm not sure how to handle this correctly, as this touches both the
>>> network tree and the hwmon tree. Also, the GPY PHY temperature senors
>>> driver would use it.
>> 
>> There are a few options:
>> 
>> 1) Get the hwmon_sanitize_name() merged into hwmon, ask for a stable
>> branch, and get it merged into netdev net-next.
>> 
>> 2) Have the hwmon maintainers ACK the change and agree that it can be
>> merged via netdev.
>> 
>> Probably the second option is easiest, and since it is not touching
>> the core of hwmon, it is unlikely to cause merge conflicts.
>> 
> 
> No, it isn't the easiest solution because it also modifies a hwmon
> driver to use it.

So that leaves us with option 1? The next version will contain the
additional patch which moves the hwmon_is_bad_char() from the include
to the core and make it private. That will then need an immutable
branch from netdev to get merged back into hwmon before that patch
can be applied, right?

-michael
