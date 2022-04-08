Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B4E6C4F9D2E
	for <lists+netdev@lfdr.de>; Fri,  8 Apr 2022 20:48:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238591AbiDHSuY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Apr 2022 14:50:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58192 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230307AbiDHSuW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Apr 2022 14:50:22 -0400
X-Greylist: delayed 172 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Fri, 08 Apr 2022 11:48:17 PDT
Received: from mo4-p01-ob.smtp.rzone.de (mo4-p01-ob.smtp.rzone.de [85.215.255.54])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1CF7C1C5924;
        Fri,  8 Apr 2022 11:48:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1649443511;
    s=strato-dkim-0002; d=hartkopp.net;
    h=In-Reply-To:Cc:From:References:To:Subject:Date:Message-ID:Cc:Date:
    From:Subject:Sender;
    bh=6u1TBR7ukFAvpGgrfPifszB9b72XH9Glp8ZeFJje1tQ=;
    b=tiF8UtTL9XVow5CXQB6UULRZqP96I1dr/SaIzPAE9XmfnHjsMNZY1hJYMOAaWG+xSl
    MoD2JEvfgOYrkyZIX2tGJB+HSYVHa5HDJHBdPOpx2PTGWduC6/3tS41JWSt1y4EirMe0
    duwtax0shBcD4SQL1bnrptWQ4Pwb+dFo8IMjx8TUC0W4I87zSK36cK2L1u73SQpL0k0s
    8VvVxh8eL5TwqKvlAsqr0wjAuWTyP9h8p0P6rWuiiqlRUvFyUOx1jrcxoOPOy7QGucpe
    BuwUe1ecLFO7sXibsPDd3ZG9Rdcm2K/9aomU47dYBrkfIw5ROfTqOLcbY7kWmFDa8IwK
    FaZQ==
Authentication-Results: strato.com;
    dkim=none
X-RZG-AUTH: ":P2MHfkW8eP4Mre39l357AZT/I7AY/7nT2yrDxb8mjG14FZxedJy6qgO1qCHSa1GLptZHusx3hdd0DIgVuBOfXW6v7w=="
X-RZG-CLASS-ID: mo00
Received: from [IPV6:2a00:6020:1cfa:f900::b82]
    by smtp.strato.de (RZmta 47.42.2 AUTH)
    with ESMTPSA id 4544c9y38IjAdFD
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
        (Client did not present a certificate);
    Fri, 8 Apr 2022 20:45:10 +0200 (CEST)
Message-ID: <c2e2c7b0-cdfb-8eb0-9550-0fb59b5cd10c@hartkopp.net>
Date:   Fri, 8 Apr 2022 20:45:02 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: peak_usb: urb aborted
Content-Language: en-US
To:     Paul Thomas <pthomas8589@gmail.com>, linux-can@vger.kernel.org,
        =?UTF-8?Q?St=c3=a9phane_Grosjean?= <s.grosjean@peak-system.com>
References: <CAD56B7dMg073f56vfaxp38=dZiAFU0iCn6kmDGiNcNtCijyFoA@mail.gmail.com>
From:   Oliver Hartkopp <socketcan@hartkopp.net>
Cc:     Wolfgang Grandegger <wg@grandegger.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel <linux-kernel@vger.kernel.org>,
        support@peak-system.com
In-Reply-To: <CAD56B7dMg073f56vfaxp38=dZiAFU0iCn6kmDGiNcNtCijyFoA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 08.04.22 18:35, Paul Thomas wrote:
> Folks,
> 
> I'm using a PCAN-USB adapter, and it seems to have a lot of trouble
> under medium load. I'm getting these urb aborted messages.
> [125054.082248] peak_usb 3-2.4.4:1.0 can0: Rx urb aborted (-71)
> [125077.886850] peak_usb 3-2.4.4:1.0 can0: Rx urb aborted (-32)

As I run the same hardware here it is very likely that you have a faulty 
CAN bus setup with

- wrong bitrate setting / sample points / etc
- wrong or no termination
- missing or wrong configured (other) CAN nodes

I added the maintainer of the PEAK USB adapter (Stephane) to the 
recipient list.

Having the linux-can mailing list and Stephane in the recipient list is 
sufficient to answer the above details.

Regards,
Oliver

> 
> Is there anything that can be done about this? This is very
> frustrating because it makes the USB adapter very difficult to use as
> a reliable partner of an embedded CAN device.
> 
> I'm using Ubuntu with 5.4.0-107-generic. Any help would be appreciated.
> 
> -Paul
