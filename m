Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 106F26AE772
	for <lists+netdev@lfdr.de>; Tue,  7 Mar 2023 17:58:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230467AbjCGQ6M (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Mar 2023 11:58:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50042 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230367AbjCGQ5q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Mar 2023 11:57:46 -0500
Received: from madras.collabora.co.uk (madras.collabora.co.uk [IPv6:2a00:1098:0:82:1000:25:2eeb:e5ab])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E62BF222DB;
        Tue,  7 Mar 2023 08:53:56 -0800 (PST)
Received: from [192.168.10.12] (unknown [39.45.145.7])
        (using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: usama.anjum)
        by madras.collabora.co.uk (Postfix) with ESMTPSA id 56E156602EC7;
        Tue,  7 Mar 2023 16:53:52 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=collabora.com;
        s=mail; t=1678208034;
        bh=iDRLwy+I9K1uAgspVj4Ndxr8weBRivPlro3rl0BqmeE=;
        h=Date:Cc:Subject:To:References:From:In-Reply-To:From;
        b=Zvs4d7EE8Pxee98prvgIB8JHuFRCHGzpwDbvzQwL5TNlvktQMX46BxF36m+KarELz
         PT/UXxYFHg2lDDT0ef9yleXFHzxZnqqF7u/0JcbboB8j56cr35x8PF8b1Ryh0O7H3u
         2/VYY2qgds+wwXlVzKLr6blior23BAnm5NyGwV3SrN2ESKwqNbOW9A3F4PlIdl9qED
         iIfmM8xYcrz/GWoB13rta+4k5Zzpi3Isg6EJtw6bc/ewkouRWT76xrBJm8trCPNnCl
         MZ7SU/D/HGnhx3suQ5TX2AJb/B1YfTtMEM2tmpOlrMMgttJ8GnlLkhp+S910TObUjV
         JHoH53NfoBuow==
Message-ID: <1107bc10-9b14-98f4-3e47-f87188453ce7@collabora.com>
Date:   Tue, 7 Mar 2023 21:53:48 +0500
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.2
Cc:     Muhammad Usama Anjum <usama.anjum@collabora.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Ariel Elior <aelior@marvell.com>,
        Manish Chopra <manishc@marvell.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, kernel@collabora.com,
        kernel-janitors@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] qede: remove linux/version.h and linux/compiler.h
Content-Language: en-US
To:     Simon Horman <simon.horman@corigine.com>
References: <20230303185351.2825900-1-usama.anjum@collabora.com>
 <20230303155436.213ee2c0@kernel.org>
 <df8a446a-e8a9-3b3d-fd0f-791f0d01a0c9@collabora.com>
 <ZAdoivY94Y5dfOa4@corigine.com>
From:   Muhammad Usama Anjum <usama.anjum@collabora.com>
In-Reply-To: <ZAdoivY94Y5dfOa4@corigine.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_NONE,
        SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/7/23 9:38 PM, Simon Horman wrote:
> On Tue, Mar 07, 2023 at 06:39:20PM +0500, Muhammad Usama Anjum wrote:
>> On 3/4/23 4:54 AM, Jakub Kicinski wrote:
>>> On Fri,  3 Mar 2023 23:53:50 +0500 Muhammad Usama Anjum wrote:
>>>> make versioncheck reports the following:
>>>> ./drivers/net/ethernet/qlogic/qede/qede.h: 10 linux/version.h not needed.
>>>> ./drivers/net/ethernet/qlogic/qede/qede_ethtool.c: 7 linux/version.h not needed.
>>>>
>>>> So remove linux/version.h from both of these files. Also remove
>>>> linux/compiler.h while at it as it is also not being used.
>>>>
>>>> Signed-off-by: Muhammad Usama Anjum <usama.anjum@collabora.com>
>>>
>>> # Form letter - net-next is closed
>>>
>>> The merge window for v6.3 has begun and therefore net-next is closed
>>> for new drivers, features, code refactoring and optimizations.
>>> We are currently accepting bug fixes only.
>>>
>>> Please repost when net-next reopens after Mar 6th.
>> It is Mar 7th. Please review.
> 
> I think that the way it works is that you need to repost the patch.
> Probably with REPOST in the subject if it is unchanged:Sorry, I didn't know. I'll repost it.

> 
> Subject: [PATCH net-next repost v2] ...
> 
> Or bumped to v3 if there are changes.
> 
> Subject: [PATCH net-next v3] ...
> 
> Also, as per the examples above, the target tree, in this case
> 'net-next' should be included in the subject.
I don't know much about net tree and its location. This is why people use
linux-next for sending patches. I'm not sure about the networking sub
system. Would it be accepted if I send it against linux-next as in [PATCH
linux-next repost v2]?


-- 
BR,
Muhammad Usama Anjum
