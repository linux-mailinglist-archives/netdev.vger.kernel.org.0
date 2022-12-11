Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F3161649403
	for <lists+netdev@lfdr.de>; Sun, 11 Dec 2022 12:57:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230019AbiLKLzW convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Sun, 11 Dec 2022 06:55:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36430 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229656AbiLKLzU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 11 Dec 2022 06:55:20 -0500
X-Greylist: delayed 66 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Sun, 11 Dec 2022 03:55:16 PST
Received: from smtpbgbr2.qq.com (smtpbgbr2.qq.com [54.207.22.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA343E0AA
        for <netdev@vger.kernel.org>; Sun, 11 Dec 2022 03:55:16 -0800 (PST)
X-QQ-mid: bizesmtp76t1670759624ths6i58s
Received: from smtpclient.apple ( [183.129.236.74])
        by bizesmtp.qq.com (ESMTP) with 
        id ; Sun, 11 Dec 2022 19:53:42 +0800 (CST)
X-QQ-SSF: 00400000002000M0N000B00A0000000
X-QQ-FEAT: /15IGBtyjqPkqPrW2W69Jr0qWuPct6qbmoe7YNHeY3ma/dzIy4/NSAZ9JSlh4
        KmPsbuX3KED5T2sg10X/pOyFmeL7Z9lz4NcdJQGyRuEU3uW57RBrcJuMTnEyqekhAk1VzqO
        0C+eGC+CweI58X++WXTSL7POEloomFLPTNIX89BE2kRSRXTrpMCEVkyIslzr/0vv4GhuZI+
        ds3OXasdJxDPKtv+paWpb97QSjGkao58uCJR2pH/mlUS0wqqmBtkau3fkbsZPYYiJ1zALkW
        02xr3LeUTa1VBJ0q0z6WK5Tjg8M+C9edX9IYpV0L3x1KkI1lzw97Ir+7szrNOl7DotgMhgy
        39dhgDIgUHgLkvvdTFLPa+BO7wLIn69DRQw8Tg2G/vxbKQGpoPhOxxt5K6GP2ulisi2JLYD
        0FHs5BvP+gQ=
X-QQ-GoodBg: 2
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3696.120.41.1.1\))
Subject: Re: [PATCH net-next v2] net: ngbe: Add ngbe mdio bus driver.
From:   "mengyuanlou@net-swift.com" <mengyuanlou@net-swift.com>
In-Reply-To: <Y5W+86YXppK2NocE@lunn.ch>
Date:   Sun, 11 Dec 2022 19:53:41 +0800
Cc:     netdev@vger.kernel.org, jiawenwu@trustnetic.com
Content-Transfer-Encoding: 8BIT
Message-Id: <63385120-46C9-4D9E-81C7-9E72C3371C2C@net-swift.com>
References: <20221206114035.66260-1-mengyuanlou@net-swift.com>
 <Y5RjwYgetMdzlQVZ@lunn.ch>
 <8BEEC6D9-EB5F-4A66-8BFD-E8FEE4EB723F@net-swift.com>
 <Y5W+86YXppK2NocE@lunn.ch>
To:     Andrew Lunn <andrew@lunn.ch>
X-Mailer: Apple Mail (2.3696.120.41.1.1)
X-QQ-SENDSIZE: 520
Feedback-ID: bizesmtp:net-swift.com:qybglogicsvr:qybglogicsvr1
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_NONE,
        SPF_HELO_PASS,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> 2022年12月11日 19:28，Andrew Lunn <andrew@lunn.ch> 写道：
> 
>>>> +static void ngbe_up(struct ngbe_adapter *adapter)
>>>> +{
>>>> +	struct ngbe_hw *hw = &adapter->hw;
>>>> +
>>>> +	pci_set_master(adapter->pdev);
>>>> +	if (hw->gpio_ctrl)
>>>> +		/* gpio0 is used to power on control*/
>>>> +		wr32(&hw->wxhw, NGBE_GPIO_DR, 0);
>>> 
>>> Control of what?
>> Control for sfp modules power down/up.
>> The chip has not i2c interface, so I do not use phylink.
> 
> Please give this a better name. Is this connected to the TX_DISABLE
> pin of the SFP, or the transmit and receiver power pins?
> 
The transmit and receiver power pins.
> If you don't have the I2C bus, i'm wondering how you can actually
> driver the SFP and the MAC. You have no idea what has been
> inserted. Is it actually an SFF, not an SFP? Do you have any of the
> GPIOs normally associated with an SFP? TX_DISABLE, LOS, TX_FAULT?
> 
1、Yeah. We can't know what module is inserted
2、There are not enough GPIOs to be associated with other pins. 
> 
> 	  Andrew
> 

