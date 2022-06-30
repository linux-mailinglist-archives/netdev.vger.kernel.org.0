Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D8D9A5624A7
	for <lists+netdev@lfdr.de>; Thu, 30 Jun 2022 22:56:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232936AbiF3U4g (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Jun 2022 16:56:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48276 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230503AbiF3U4f (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Jun 2022 16:56:35 -0400
Received: from ssl.serverraum.org (ssl.serverraum.org [IPv6:2a01:4f8:151:8464::1:2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A3933403E0;
        Thu, 30 Jun 2022 13:56:33 -0700 (PDT)
Received: from ssl.serverraum.org (web.serverraum.org [172.16.0.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ssl.serverraum.org (Postfix) with ESMTPSA id 1CBF922236;
        Thu, 30 Jun 2022 22:56:31 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=walle.cc; s=mail2016061301;
        t=1656622591;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=82UJBr6ACNE0EKd6nPjOsmQDwDWzYJeTBz8Z22qFb7s=;
        b=LPfRjyOguub3ig8hubkevjW8TfHe97qALfLiNNisD02rx0fodn12ZsD0BNjuTz4wo+xO0S
        5hKfTk6XJjruMs1FmHjsG5z7val4CMh8HJoQrwKB9SxMCGR7nV6TM6C/3B6glXcPcbvycX
        5bDt1VQUwHuAgTtOTl6h3P7X3twR/R8=
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Thu, 30 Jun 2022 22:56:30 +0200
From:   Michael Walle <michael@walle.cc>
To:     Horatiu Vultur <horatiu.vultur@microchip.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        UNGLinuxDriver@microchip.com, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next 0/4] net: lan966x: hardcode port count
In-Reply-To: <20220630204433.hg2a2ws2zk5p73ld@soft-dev3-1.localhost>
References: <20220630140237.692986-1-michael@walle.cc>
 <20220630204433.hg2a2ws2zk5p73ld@soft-dev3-1.localhost>
User-Agent: Roundcube Webmail/1.4.13
Message-ID: <0169b5865944d6522a752b02321a7f4b@walle.cc>
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

Am 2022-06-30 22:44, schrieb Horatiu Vultur:
> The 06/30/2022 16:02, Michael Walle wrote:
>> EXTERNAL EMAIL: Do not click links or open attachments unless you know 
>> the content is safe
>> 
>> Don't rely on the device tree to count the number of physical port. 
>> Instead
>> introduce a new compatible string which the driver can use to select 
>> the
>> correct port count.
>> 
>> This also hardcodes the generic compatible string to 8. The rationale 
>> is
>> that this compatible string was just used for the LAN9668 for now and 
>> I'm
>> not even sure the current driver would support the LAN9662.
> 
> It works also on LAN9662, but I didn't have time to send patches for
> DTs. Then when I send patches for LAN9662, do I need to go in all dts
> files to change the compatible string for the 'switch' node?

I'd assume there is one lan9662.dtsi and yes, there should then be
   compatible = "microchip,lan9662-switch";
or
   compatible = "microchip,lan9662-switch", "microchip,lan966x-switch";
depending on the outcome of the question Krzysztof raised.

And of course adding the compatible string to the driver with a port
count of 4 (?). I can't find anything about the lan9662, and you've
mentioned it has 4 ports. Are there four external ports? I was
under the impression the last digit of the SoC name stands for the
number of ports.

-michael
