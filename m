Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CDA9666083C
	for <lists+netdev@lfdr.de>; Fri,  6 Jan 2023 21:24:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229846AbjAFUYe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Jan 2023 15:24:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34678 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230308AbjAFUY1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Jan 2023 15:24:27 -0500
Received: from relay7-d.mail.gandi.net (relay7-d.mail.gandi.net [IPv6:2001:4b98:dc4:8::227])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4DCF663D0;
        Fri,  6 Jan 2023 12:24:26 -0800 (PST)
Received: (Authenticated sender: clement.leger@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPA id 2036420007;
        Fri,  6 Jan 2023 20:24:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1673036663;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=mXLB7qYeHa4vBxvLqa2JDTW+ypBNPll5UV2mYQOZFiQ=;
        b=FxMDIq/5b+4qc8QZ/sXXfdW6wfXGP5CoTI++ELmLTMpcdgQyej7aQP57Z0f0ChZTfC742N
        q62yCwvhXfDM5lLterNs8mapRDFo6kti1cJBcs6NSmL7w7+IHVZ1760qwTJHfhUDryAqaQ
        cb6R7tBiCEZ7u+aJEFXfQDUesoHo0Gc5O3lB8aMQyM3fpqPyJe+WIqj9Ichh7VCldYpGF2
        ugpeakHCnY5dMqvzM9pB4DMw3HPMc2s7TNsg2UG3eO9u3bQWVv3Np5XDiSZKZ/WqZSAPfH
        g+hQcNFuSF49Jfag8sNhaY6oGf2RMTO68JFcDuEoq8SBSFUrl7OwWxMA35OZMA==
MIME-Version: 1.0
Date:   Fri, 06 Jan 2023 21:24:22 +0100
From:   clement.leger@bootlin.com
To:     Horatiu Vultur <horatiu.vultur@microchip.com>
Cc:     UNGLinuxDriver@microchip.com,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Richard Cochran <richardcochran@gmail.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: lan966x: check for ptp to be enabled in
 lan966x_ptp_deinit()
In-Reply-To: <20230106202148.77gkauaikjhyjcvi@soft-dev3-1>
References: <20230106134830.333494-1-clement.leger@bootlin.com>
 <20230106202148.77gkauaikjhyjcvi@soft-dev3-1>
Message-ID: <de966535b41ea9be931083f59ddd3dcb@bootlin.com>
X-Sender: clement.leger@bootlin.com
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Le 2023-01-06 21:21, Horatiu Vultur a écrit :
> The 01/06/2023 14:48, Clément Léger wrote:
> 
> Hi Clement,
> 
>> 
>> If ptp was not enabled due to missing IRQ for instance,
>> lan966x_ptp_deinit() will dereference NULL pointers.
>> 
>> Fixes: d096459494a8 ("net: lan966x: Add support for ptp clocks")
>> Signed-off-by: Clément Léger <clement.leger@bootlin.com>
> 
> You forgot to mark the patch to target the net tree.  But other
> than that looks good.

Hi Horatiu,

I'll resent a V2 to the net tree then. Thanks for reviewing.

Clément

> 
> Reviewed-by: Horatiu Vultur <horatiu.vultur@microchip.com>
> 
>> ---
>>  drivers/net/ethernet/microchip/lan966x/lan966x_ptp.c | 3 +++
>>  1 file changed, 3 insertions(+)
>> 
>> diff --git a/drivers/net/ethernet/microchip/lan966x/lan966x_ptp.c 
>> b/drivers/net/ethernet/microchip/lan966x/lan966x_ptp.c
>> index f9ebfaafbebc..a8348437dd87 100644
>> --- a/drivers/net/ethernet/microchip/lan966x/lan966x_ptp.c
>> +++ b/drivers/net/ethernet/microchip/lan966x/lan966x_ptp.c
>> @@ -1073,6 +1073,9 @@ void lan966x_ptp_deinit(struct lan966x *lan966x)
>>         struct lan966x_port *port;
>>         int i;
>> 
>> +       if (!lan966x->ptp)
>> +               return;
>> +
>>         for (i = 0; i < lan966x->num_phys_ports; i++) {
>>                 port = lan966x->ports[i];
>>                 if (!port)
>> --
>> 2.38.1
>> 
