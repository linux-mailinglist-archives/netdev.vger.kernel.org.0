Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CFB10198379
	for <lists+netdev@lfdr.de>; Mon, 30 Mar 2020 20:37:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726672AbgC3ShC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Mar 2020 14:37:02 -0400
Received: from mail.bugwerft.de ([46.23.86.59]:54928 "EHLO mail.bugwerft.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726017AbgC3ShC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 30 Mar 2020 14:37:02 -0400
Received: from [192.168.178.106] (pD95EFBD9.dip0.t-ipconnect.de [217.94.251.217])
        by mail.bugwerft.de (Postfix) with ESMTPSA id 6917029CCD1;
        Mon, 30 Mar 2020 18:35:03 +0000 (UTC)
Subject: Re: [PATCH] net: dsa: mv88e6xxx: don't force settings on CPU port
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     vivien.didelot@gmail.com, f.fainelli@gmail.com,
        davem@davemloft.net, netdev@vger.kernel.org
References: <20200327195156.1728163-1-daniel@zonque.org>
 <20200327200153.GR3819@lunn.ch>
 <d101df30-5a9e-eac1-94b0-f171dbcd5b88@zonque.org>
 <20200327211821.GT3819@lunn.ch>
 <1bff1da3-8c9d-55c6-3408-3ae1c3943041@zonque.org>
 <20200327235220.GV3819@lunn.ch>
 <64462bcf-6c0c-af4f-19f4-d203daeabec3@zonque.org>
 <20200330134010.GA23477@lunn.ch>
 <7a777bc3-9109-153a-a735-e36718c06db5@zonque.org>
 <20200330182307.GG23477@lunn.ch>
From:   Daniel Mack <daniel@zonque.org>
Message-ID: <82d8e785-ec00-d815-3b11-b694aa9f4d50@zonque.org>
Date:   Mon, 30 Mar 2020 20:37:00 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <20200330182307.GG23477@lunn.ch>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/30/20 8:23 PM, Andrew Lunn wrote:
> On Mon, Mar 30, 2020 at 08:04:08PM +0200, Daniel Mack wrote:
>> Hi Andrew,
>>
>> Thanks for all your input.
>>
>> On 3/30/20 3:40 PM, Andrew Lunn wrote:
>>> On Mon, Mar 30, 2020 at 11:29:27AM +0200, Daniel Mack wrote:
>>>> On 3/28/20 12:52 AM, Andrew Lunn wrote:
>>
>>>>> By explicitly saying there is a PHY for the CPU node, phylink might
>>>>> drive it.
>>>
>>> You want to debug this. Although what you have is unusual, yours is
>>> not the only board. It is something we want to work. And ideally,
>>> there should be something controlling the PHY.
>>
>> I agree, but what I believe is happening here is this. The PHY inside
>> the switch negotiates a link to the 'external' PHY which is forced to
>> 100M maximum speed. That link seems to work fine; the LEDs connected to
>> that external PHY indicate that there is link. However, the internal PHY
>> in the switch does not receive any packets as the MAC connected to it
>> only wants to communicate with 1G.
> 
> Which is what phylink is all about. phylink will talk to the PHY,
> figure out what it has negotiated, and then configure the MAC to
> fit. So you need to debug why this is not happening.

Even when the MAC is *forced* to 1G, which is what the code currently
does? Sorry for the dumb question, but wich code path would undo these
settings? Where would you start debugging this?


Thanks,
Daniel


