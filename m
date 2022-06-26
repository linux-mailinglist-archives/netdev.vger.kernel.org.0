Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EF26C55B3E6
	for <lists+netdev@lfdr.de>; Sun, 26 Jun 2022 21:58:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231815AbiFZT4v (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 26 Jun 2022 15:56:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52274 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231314AbiFZT4u (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 26 Jun 2022 15:56:50 -0400
Received: from ssl.serverraum.org (ssl.serverraum.org [IPv6:2a01:4f8:151:8464::1:2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0EEFF558B;
        Sun, 26 Jun 2022 12:56:50 -0700 (PDT)
Received: from ssl.serverraum.org (web.serverraum.org [172.16.0.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ssl.serverraum.org (Postfix) with ESMTPSA id 3B0D12222E;
        Sun, 26 Jun 2022 21:56:48 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=walle.cc; s=mail2016061301;
        t=1656273408;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=t+Ydlg0tw+uRCOZCn7JbEkD96fE79JZR4UjZLAXo72U=;
        b=C/4btszpoGCu/vS+3u4XvTMqi7Oju7XCGlbKvDUSyUFpw/7woBjd8GtluiUF+EN7G+4zwV
        1NlSMfrpnN5PQBkyLEMso3pyHIG4sYjwCH8OGqVYEQ5kgzqLSdsmNTk3nDiqJ2ABXN6NmF
        rxGTqpASZywWudZj3kJYZknMH9QDLTw=
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Sun, 26 Jun 2022 21:56:48 +0200
From:   Michael Walle <michael@walle.cc>
To:     Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Cc:     Charles Gorand <charles.gorand@effinnov.com>,
        =?UTF-8?Q?Cl=C3=A9ment_?= =?UTF-8?Q?Perrochaud?= 
        <clement.perrochaud@nxp.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] NFC: nxp-nci: Don't issue a zero length
 i2c_master_read()
In-Reply-To: <3c28bc43-4994-8e12-25f4-32b723e6e7ac@linaro.org>
References: <20220626194243.4059870-1-michael@walle.cc>
 <20220626194243.4059870-2-michael@walle.cc>
 <3c28bc43-4994-8e12-25f4-32b723e6e7ac@linaro.org>
User-Agent: Roundcube Webmail/1.4.13
Message-ID: <f9aa0597b22e2282abe7925135eebc4e@walle.cc>
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

Am 2022-06-26 21:51, schrieb Krzysztof Kozlowski:
> On 26/06/2022 21:42, Michael Walle wrote:
>> There are packets which doesn't have a payload. In that case, the 
>> second
>> i2c_master_read() will have a zero length. But because the NFC
>> controller doesn't have any data left, it will NACK the I2C read and
>> -ENXIO will be returned. In case there is no payload, just skip the
>> second i2c master read.
>> 
>> Fixes: 6be88670fc59 ("NFC: nxp-nci_i2c: Add I2C support to NXP NCI 
>> driver")
>> Signed-off-by: Michael Walle <michael@walle.cc>
> 
> Reviewed-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>

Thanks, I'll reorder the patches in the next version otherwise
there will likely be a conflict. That should work with any patch
tools (i.e. b4), shouldn't it?

-michael
