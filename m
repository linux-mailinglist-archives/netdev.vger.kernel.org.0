Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BF073571B36
	for <lists+netdev@lfdr.de>; Tue, 12 Jul 2022 15:28:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232902AbiGLN2M (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Jul 2022 09:28:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41214 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232433AbiGLN2B (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Jul 2022 09:28:01 -0400
Received: from ssl.serverraum.org (ssl.serverraum.org [IPv6:2a01:4f8:151:8464::1:2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BCFC4B4BDE;
        Tue, 12 Jul 2022 06:27:58 -0700 (PDT)
Received: from ssl.serverraum.org (web.serverraum.org [172.16.0.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ssl.serverraum.org (Postfix) with ESMTPSA id 02C9722239;
        Tue, 12 Jul 2022 15:27:57 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=walle.cc; s=mail2016061301;
        t=1657632477;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=LwObfXaiRiyA2E8lhuZyZlmOcK4lNfz9a7H3acXXh2k=;
        b=kiQw74SGiTE9A+JgaHnVR490CtXakg7wbq0e8ItGjSna/G+geLo8CYDa6vwY2NHkYHrsZO
        iTn4OosDsNX54kajO5zqODXYqUDLhLxOLZTTGXlnAeKSCyRyYE4xLcz2RSNLEKZiWBwCC0
        LGGKoeWcKq/MY6r+1p0VXYYb+srWVGY=
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Tue, 12 Jul 2022 15:27:56 +0200
From:   Michael Walle <michael@walle.cc>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Xu Liang <lxu@maxlinear.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next 2/4] net: phy: mxl-gpy: cache PHY firmware
 version
In-Reply-To: <Ys12E0mVdc3rd7it@lunn.ch>
References: <20220712131554.2737792-1-michael@walle.cc>
 <20220712131554.2737792-3-michael@walle.cc> <Ys12E0mVdc3rd7it@lunn.ch>
User-Agent: Roundcube Webmail/1.4.13
Message-ID: <50952529a0523a9259cc312007b76202@walle.cc>
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

Am 2022-07-12 15:24, schrieb Andrew Lunn:
>> +	priv->fw_type = FIELD_GET(PHY_FWV_TYPE_MASK, fw_version);
>> +	priv->fw_minor = FIELD_GET(PHY_FWV_MINOR_MASK, fw_version);
>> 
>>  	ret = gpy_hwmon_register(phydev);
>>  	if (ret)
>>  		return ret;
>> 
>> +	/* Show GPY PHY FW version in dmesg */
>>  	phydev_info(phydev, "Firmware Version: 0x%04X (%s)\n", fw_version,
>>  		    (fw_version & PHY_FWV_REL_MASK) ? "release" : "test");
> 
> Maybe use fw_type and fw_minor. It makes the patch a bit bigger, but
> makes the code more consistent.

See next patches ;) And fw_{type,minor} doesn't contain the REL_MASK.
I chose not to cached that as it just used during this reporting.

-michael
