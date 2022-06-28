Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D3F6E55CF5D
	for <lists+netdev@lfdr.de>; Tue, 28 Jun 2022 15:06:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343591AbiF1Gmu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jun 2022 02:42:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50868 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343578AbiF1Gmc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Jun 2022 02:42:32 -0400
Received: from ssl.serverraum.org (ssl.serverraum.org [176.9.125.105])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A8A22657B;
        Mon, 27 Jun 2022 23:42:30 -0700 (PDT)
Received: from ssl.serverraum.org (web.serverraum.org [172.16.0.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ssl.serverraum.org (Postfix) with ESMTPSA id 778E122247;
        Tue, 28 Jun 2022 08:42:27 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=walle.cc; s=mail2016061301;
        t=1656398548;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=hUd8P/SkVlofXTKn9syJL1n/rWoIOtj/5SMImykU6LQ=;
        b=b2FEBhqfx7igAaLX4nfAElU9OpHoPtLryraU7I08s85hpQG5v10ddCtJur/x8Sa3YG/vVa
        XqGFiUgr9NDIZpjlvKn5C6WtmtEMwe6rFVD6N9VnqyvEt7BU5AstCsWs4+MxCZXap6fZGC
        2BKcCcbYu3XZ+mcYLvybfM/fR+363PM=
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Tue, 28 Jun 2022 08:42:26 +0200
From:   Michael Walle <michael@walle.cc>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        =?UTF-8?Q?Cl?= =?UTF-8?Q?=C3=A9ment_Perrochaud?= 
        <clement.perrochaud@nxp.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] NFC: nxp-nci: Don't issue a zero length
 i2c_master_read()
In-Reply-To: <20220627220320.29ca05ec@kernel.org>
References: <20220626194243.4059870-1-michael@walle.cc>
 <20220626194243.4059870-2-michael@walle.cc>
 <20220627220320.29ca05ec@kernel.org>
User-Agent: Roundcube Webmail/1.4.13
Message-ID: <6a429e1e42178d863ce54cf2497b86b3@walle.cc>
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

Am 2022-06-28 07:03, schrieb Jakub Kicinski:
> On Sun, 26 Jun 2022 21:42:43 +0200 Michael Walle wrote:
>> There are packets which doesn't have a payload. In that case, the 
>> second
>> i2c_master_read() will have a zero length. But because the NFC
>> controller doesn't have any data left, it will NACK the I2C read and
>> -ENXIO will be returned. In case there is no payload, just skip the
>> second i2c master read.
> 
> Whoa, are you using this code or just found the problem thru code
> inspection? NFC is notorious for having no known users.

Ha! Well, I *try* to use it with a PN7160. No luck so far, we'll see.
At least the communication with the chip works now. I was also kinda
tricked by the Supported status ;)

-michael
