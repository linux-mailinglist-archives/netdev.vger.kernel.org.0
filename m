Return-Path: <netdev+bounces-5277-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3B01B710850
	for <lists+netdev@lfdr.de>; Thu, 25 May 2023 11:08:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E8ED12814E2
	for <lists+netdev@lfdr.de>; Thu, 25 May 2023 09:08:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6C5FED51D;
	Thu, 25 May 2023 09:08:37 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 609D8849C
	for <netdev@vger.kernel.org>; Thu, 25 May 2023 09:08:37 +0000 (UTC)
Received: from relay7-d.mail.gandi.net (relay7-d.mail.gandi.net [217.70.183.200])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D5F11A2;
	Thu, 25 May 2023 02:08:33 -0700 (PDT)
Received: (Authenticated sender: alexis.lothore@bootlin.com)
	by mail.gandi.net (Postfix) with ESMTPSA id 22A442000F;
	Thu, 25 May 2023 09:08:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
	t=1685005711;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=eaf0f8on8F0v4A7b8O5FkakZD4TKew8S3VzKcKXRadk=;
	b=pVnJ1YtyiSFpg6kxr4CkL4foygOhrmaV6OYJpNSfsWd3UTVsQom+k9LVU7Se4IyoPQ+pL7
	bYbWl2KDjhFbQm6UuFxui6JQBiGqoxCzQ11cdWVjFwBH2kci+uv62Yqr8FNklzt/y2ePdL
	jwT+VkqeU1AXZaF9H1kU+eOu6CQvd9uTnOi2x6rTaDjlrJ3yKIixhmo4gCKFiz6uMDGRnK
	rdzIvWdO8BAnuBnMg9xamY8Nx6tpfIHjxFsaItQehmpWjAME1osCqW1lQ9A5eB3BAO95LD
	bfQ2xQWochtkznHYzo3LG254v7s7jTl0pOv33vluWdinQTU8EhsjK3f12kz44w==
Message-ID: <7126e538-0cac-fe1b-fc89-0a4c9e2afcde@bootlin.com>
Date: Thu, 25 May 2023 11:08:49 +0200
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.1
Subject: Re: [PATCH net-next v3 2/7] net: dsa: mv88e6xxx: pass directly chip
 structure to mv88e6xxx_phy_is_internal
Content-Language: en-US
To: Andrew Lunn <andrew@lunn.ch>
Cc: "Russell King (Oracle)" <linux@armlinux.org.uk>,
 Florian Fainelli <f.fainelli@gmail.com>, Vladimir Oltean
 <olteanv@gmail.com>, "David S. Miller" <davem@davemloft.net>,
 Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>,
 Paolo Abeni <pabeni@redhat.com>, Richard Cochran <richardcochran@gmail.com>,
 Rob Herring <robh+dt@kernel.org>,
 Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
 Conor Dooley <conor+dt@kernel.org>, linux-kernel@vger.kernel.org,
 netdev@vger.kernel.org, devicetree@vger.kernel.org,
 Thomas Petazzoni <thomas.petazzoni@bootlin.com>, paul.arola@telus.com,
 scott.roberts@telus.com, =?UTF-8?Q?Marek_Beh=c3=ban?= <kabel@kernel.org>
References: <20230524130127.268201-1-alexis.lothore@bootlin.com>
 <20230524130127.268201-3-alexis.lothore@bootlin.com>
 <ZG4OuWllZp3MZxO8@shell.armlinux.org.uk>
 <9a7fac7b-e04b-27e2-8679-ffbbb23c248e@bootlin.com>
 <325a6737-21b9-4b78-b022-9a540c3c0f33@lunn.ch>
From: =?UTF-8?Q?Alexis_Lothor=c3=a9?= <alexis.lothore@bootlin.com>
In-Reply-To: <325a6737-21b9-4b78-b022-9a540c3c0f33@lunn.ch>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_LOW,
	RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On 5/24/23 19:08, Andrew Lunn wrote:
> On Wed, May 24, 2023 at 04:46:35PM +0200, Alexis Lothoré wrote:
>> Hello Russell,
>>
>> On 5/24/23 15:18, Russell King (Oracle) wrote:
>>> On Wed, May 24, 2023 at 03:01:22PM +0200, Alexis Lothoré wrote:
>>>> Since this function is a simple helper, we do not need to pass a full
>>>> dsa_switch structure, we can directly pass the mv88e6xxx_chip structure.
>>>> Doing so will allow to share this function with any other function
>>>> not manipulating dsa_switch structure but needing info about number of
>>>> internal phys
>>>>
>>>> Reviewed-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
>>>> Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
>>>>
>>>> ---
>>>> Changes since v2:
>>>> - add reviewed-by tags
>>>>
>>>> Signed-off-by: Alexis Lothoré <alexis.lothore@bootlin.com>
>>>> ---
>>>
>>> It never ceases to amaze me the way human beings can find creative ways
>>> to mess things up, no matter how well things are documented. The above
>>> commit message (and the others that I've looked at) are all broken
>>> because of this creativity.
>>>
>>> In effect, because of the really weird format you've come up with here,
>>> your patches are in effect *not* signed off by you.
>>
>> Sorry for that. This was an attempt to provide relevant changelog for each
>> patch, but obviously the way I stored those changelogs was wrong, and I did not
>> catch the consequent broken Signed-off-by lines after re-generating the series.
>> I'll do as suggested and hold off a bit before fixing/re-sending.
> 
> You can put the changelog in the commit message in git commit, you
> just need to add the correct --- separate after the tags. The patch
> created with git format-patch will then have two ---, but that is not
> a problem.

Yes, that is exactly what I intended to do, but digging a bit, I guess the issue
has been that my current configuration relies on git format-patch to insert my
SoB, and it seems to not identify the marker so it inserts the SoB after it
instead of before. Looks like it was broken in the series v2 too.
Fixed my configuration to sign-off right at commit time.

Thanks

> 
>     Andrew
> 
> ---
> pw-bot: cr

-- 
Alexis Lothoré, Bootlin
Embedded Linux and Kernel engineering
https://bootlin.com


