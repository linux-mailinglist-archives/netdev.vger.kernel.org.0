Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 46EEF2FAE37
	for <lists+netdev@lfdr.de>; Tue, 19 Jan 2021 01:57:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732958AbhASA4l (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Jan 2021 19:56:41 -0500
Received: from fox.pavlix.cz ([185.8.165.163]:52174 "EHLO fox.pavlix.cz"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732238AbhASA4j (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 18 Jan 2021 19:56:39 -0500
Received: from [172.16.63.206] (unknown [217.30.64.218])
        by fox.pavlix.cz (Postfix) with ESMTPSA id 62832E8316;
        Tue, 19 Jan 2021 01:55:56 +0100 (CET)
Subject: Re: [PATCH net-next] net: mdio: access c22 registers via debugfs
To:     Tobias Waldekranz <tobias@waldekranz.com>, netdev@vger.kernel.org
References: <20210116211916.8329-1-code@simerda.eu>
 <87h7ndker7.fsf@waldekranz.com>
From:   =?UTF-8?Q?Pavel_=c5=a0imerda?= <code@simerda.eu>
Message-ID: <6eadc811-783d-2fc9-60c5-b765ecc87f5a@simerda.eu>
Date:   Tue, 19 Jan 2021 01:55:56 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <87h7ndker7.fsf@waldekranz.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 1/19/21 12:27 AM, Tobias Waldekranz wrote:
> On Sat, Jan 16, 2021 at 22:19, Pavel Šimerda <code@simerda.eu> wrote:
>> Provide a debugging interface to read and write MDIO registers directly
>> without the need for a device driver.
>>
>> This is extremely useful when debugging switch hardware and phy hardware
>> issues. The interface provides proper locking for communication that
>> consists of a sequence of MDIO read/write commands.
>>
>> The interface binds directly to the MDIO bus abstraction in order to
>> provide support for all devices whether there's a hardware driver for
>> them or not. Registers are written by writing address, offset, and
>> value in hex, separated by colon. Registeres are read by writing only
>> address and offset, then reading the value.
>>
>> It can be easily tested using `socat`:
>>
>>      # socat - /sys/kernel/debug/mdio/f802c000.ethernet-ffffffff/control
>>
>> Example: Reading address 0x00 offset 0x00, value is 0x3000
>>
>>      Input: 00:00
>>      Output: 3000
>>
>> Example: Writing address 0x00 offset 0x00, value 0x2100
>>
>>      Input: 00:00:2100
>>
>> Signed-off-by: Pavel Šimerda <code@simerda.eu>
> 
> Hi Pavel,
> 
> I also tried my luck at adding an MDIO debug interface to the kernel a
> while back:
> 
> https://lore.kernel.org/netdev/C42DZQLTPHM5.2THDSRK84BI3T@wkz-x280

Hey Tobias,

nice to meet you!

> The conclusion was that, while nice to have, it makes it too easy for
> shady vendors to write out-of-tree drivers.

That was exactly what I was afraid of.

> You might want to have a look at https://github.com/wkz/mdio-tools. It
> solves the same issue that your debugfs interface does, and also some
> other nice things like clause 45 addressing and atomic read/mask/write
> operations.

Thank you very much!

Cheers,

Pavel
