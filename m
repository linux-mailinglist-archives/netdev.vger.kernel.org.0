Return-Path: <netdev+bounces-6075-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A5E67714BCA
	for <lists+netdev@lfdr.de>; Mon, 29 May 2023 16:12:51 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id CFFAE280E5D
	for <lists+netdev@lfdr.de>; Mon, 29 May 2023 14:12:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F220D8475;
	Mon, 29 May 2023 14:12:47 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E577C6FD5
	for <netdev@vger.kernel.org>; Mon, 29 May 2023 14:12:47 +0000 (UTC)
Received: from ms.lwn.net (ms.lwn.net [IPv6:2600:3c01:e000:3a1::42])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B99AFA7;
	Mon, 29 May 2023 07:12:46 -0700 (PDT)
Received: from localhost (mdns.lwn.net [45.79.72.68])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ms.lwn.net (Postfix) with ESMTPSA id 2729E5CC;
	Mon, 29 May 2023 14:12:44 +0000 (UTC)
DKIM-Filter: OpenDKIM Filter v2.11.0 ms.lwn.net 2729E5CC
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=lwn.net; s=20201203;
	t=1685369565; bh=WaLy+ZGIAimUrLNic97W3Ad9vVDRomDNEbSHu/4gO74=;
	h=From:To:Subject:In-Reply-To:References:Date:From;
	b=A/tkhRwgquZs94XkiK4CUDnByq+glDYjl3CxEJNSNsnLCnq7XWPnV635euGtSXaBm
	 pu1yKYnFDMYQDwWSxertyqajRZmRuRVoqdNKJt8HDeiM1q6mFDDQMwa0T7Kk3684+S
	 D6qkmxSSKDMUhWTLFHZRbGF8skV1N1h+i9BlxgGxBrAu9DDtDDEuUCR9zoAU7b2VFE
	 ydaFE/WeQ/c+6qHJt/sNVI4cBfhdp2ylT3RYSZypdtkcKIhgLWgzVZtRRpooBSTUUm
	 J+5MVmF6eTIsA03UpA4Gg1OPD+61FI1YNl/pMRSXuQE6jofAKsvzmjWuwZ/eekbaeN
	 hSW5l3yKbpJOw==
From: Jonathan Corbet <corbet@lwn.net>
To: Bagas Sanjaya <bagasdotme@gmail.com>, Christian Marangi
 <ansuelsmth@gmail.com>, Pavel Machek <pavel@ucw.cz>, Lee Jones
 <lee@kernel.org>, Andrew Lunn <andrew@lunn.ch>, Florian Fainelli
 <f.fainelli@gmail.com>, Vladimir Oltean <olteanv@gmail.com>, "David S.
 Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, Jakub
 Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
 linux-leds@vger.kernel.org, linux-doc@vger.kernel.org,
 linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [net-next PATCH v3 03/13] Documentation: leds: leds-class:
 Document new Hardware driven LEDs APIs
In-Reply-To: <ZHRd5wDnMrWZlwrd@debian.me>
References: <20230527112854.2366-1-ansuelsmth@gmail.com>
 <20230527112854.2366-4-ansuelsmth@gmail.com> <ZHRd5wDnMrWZlwrd@debian.me>
Date: Mon, 29 May 2023 08:12:42 -0600
Message-ID: <871qiz5iqt.fsf@meer.lwn.net>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Bagas Sanjaya <bagasdotme@gmail.com> writes:

>> +    - hw_control_get_device:
>> +                return the device associated with the LED driver in
>> +                hw control. A trigger might use this to match the
>> +                returned device from this function with a configured
>> +                device for the trigger as the source for blinking
>> +                events and correctly enable hw control.
>> +                (example a netdev trigger configured to blink for a
>> +                particular dev match the returned dev from get_device
>> +                to set hw control)
>> +
>> +                Return a device or NULL if nothing is currently attached.
> Returns a device name?

The return type of this function is struct device * - how would you
expect it to return a name?

jon

