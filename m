Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 459F64EDC1D
	for <lists+netdev@lfdr.de>; Thu, 31 Mar 2022 16:51:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237828AbiCaOxj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 31 Mar 2022 10:53:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40368 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236300AbiCaOxi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 31 Mar 2022 10:53:38 -0400
Received: from ssl.serverraum.org (ssl.serverraum.org [IPv6:2a01:4f8:151:8464::1:2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D9D4056407;
        Thu, 31 Mar 2022 07:51:50 -0700 (PDT)
Received: from ssl.serverraum.org (web.serverraum.org [172.16.0.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ssl.serverraum.org (Postfix) with ESMTPSA id 25A7522239;
        Thu, 31 Mar 2022 16:51:48 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=walle.cc; s=mail2016061301;
        t=1648738309;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=mGpDW2FfFUvAKaV7zb7pyf2ya8mPlFPwrdqHHfe9MFA=;
        b=YV+pZYny02JG7m9Zem6mvc9D0ww0wSj8oJC3KGZ7gSEDqc+bKVRfa5g00u1g6ZJDjAFbaJ
        b5ZblmF3sT5zD0UWyA5xCxyJcB1YfwNxQWKMPKNvKvTQaNaoQqrTmTElX69Bg4H7kEmj3F
        8wBuSnFi9bZQGd8mOJ/BACb2MvoSkaA=
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Thu, 31 Mar 2022 16:51:47 +0200
From:   Michael Walle <michael@walle.cc>
To:     "Russell King (Oracle)" <linux@armlinux.org.uk>
Cc:     Guenter Roeck <linux@roeck-us.net>, Xu Yilun <yilun.xu@intel.com>,
        David Laight <David.Laight@aculab.com>,
        Tom Rix <trix@redhat.com>, Jean Delvare <jdelvare@suse.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, linux-hwmon@vger.kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH v2 1/5] hwmon: introduce hwmon_sanitize_name()
In-Reply-To: <YkW+kWXrkAttCbsm@shell.armlinux.org.uk>
References: <20220329160730.3265481-1-michael@walle.cc>
 <20220329160730.3265481-2-michael@walle.cc>
 <20220330065047.GA212503@yilunxu-OptiPlex-7050>
 <5029cf18c9df4fab96af13c857d2e0ef@AcuMS.aculab.com>
 <20220330145137.GA214615@yilunxu-OptiPlex-7050>
 <4973276f-ed1e-c4ed-18f9-e8078c13f81a@roeck-us.net>
 <YkW+kWXrkAttCbsm@shell.armlinux.org.uk>
User-Agent: Roundcube Webmail/1.4.13
Message-ID: <7b3edeabb66e50825cc42ca1edf86bb7@walle.cc>
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

Am 2022-03-31 16:45, schrieb Russell King (Oracle):
> On Wed, Mar 30, 2022 at 08:23:35AM -0700, Guenter Roeck wrote:
>> Michael, let's just drop the changes outside drivers/hwmon from
>> the series, and let's keep hwmon_is_bad_char() in the include file.
>> Let's just document it, explaining its use case.
> 
> Why? There hasn't been any objection to the change. All the discussion
> seems to be around the new function (this patch) rather than the actual
> conversions in drivers.
> 
> I'm entirely in favour of cleaning this up - it irks me that we're 
> doing
> exactly the same cleanup everywhere we have a hwmon.
> 
> At the very least, I would be completely in favour of keeping the
> changes in the sfp and phy code.

FWIW, my plan was to send the hwmon patches first, by then my other
series (the polynomial_calc() one) will also be ready to be picked.
Then I'd ask Guenter for a stable branch with these two series which
hopefully get merged into net-next. Then I can repost the missing
patches on net-next along with the new sensors support for the GPY
and LAN8814 PHYs.

For the last patch, if it should be applied or not, or when, that
will be up to Guenter then.

-michael
