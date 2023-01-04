Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 07A3E65D2A0
	for <lists+netdev@lfdr.de>; Wed,  4 Jan 2023 13:28:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234476AbjADM2w (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Jan 2023 07:28:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51986 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234206AbjADM2u (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Jan 2023 07:28:50 -0500
Received: from proxima.lasnet.de (proxima.lasnet.de [IPv6:2a01:4f8:121:31eb:3::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE3B21A21E;
        Wed,  4 Jan 2023 04:28:47 -0800 (PST)
Received: from [192.168.2.51] (p4fc2f177.dip0.t-ipconnect.de [79.194.241.119])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: stefan@datenfreihafen.org)
        by proxima.lasnet.de (Postfix) with ESMTPSA id 8C6B8C0871;
        Wed,  4 Jan 2023 13:28:45 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=datenfreihafen.org;
        s=2021; t=1672835325;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=vwpZNbYeT0ksVzOzPB2dURq4Fy55K9yQ/3TgNCRglGs=;
        b=Hk0jJINHRooh6PPgB9fUJ8O2VwRX3MI/hk4h6fuoXHK5gI5aISUMISwNzvCeNuw2cBcFYR
        20tw28BP4E78xkEN2lDAe57okgAZ9sapkUYULOfjVEDSi4Ed3GifzEEXocf5eYj1pszxdp
        3c9NCrwg2pd8tu3Ra3xbJ2aXwnyZpHfBoQmAgM1OdqvNBVPQC9HtO0DOWtDpPoIFEtqmFb
        e9iQFGzD77P/FJEges9oq+dyS9tW5CEdFveTyzl3jn0W8YHxQMZyDRjNjJKrzNSXKLu2hr
        tpW/qh/SeBhFSaMo673Ei95GoEPH37EWiQwzCzNyvsKFiSr4UiC60pSm2MsOEA==
Message-ID: <ec93100f-8c55-2f54-d3d5-63f31c2602f4@datenfreihafen.org>
Date:   Wed, 4 Jan 2023 13:28:44 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
Subject: Re: [PATCH wpan-next v3 0/6] IEEE 802.15.4 passive scan support
Content-Language: en-US
To:     Miquel Raynal <miquel.raynal@bootlin.com>
Cc:     Alexander Aring <alex.aring@gmail.com>, linux-wpan@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>, netdev@vger.kernel.org,
        David Girault <david.girault@qorvo.com>,
        Romuald Despres <romuald.despres@qorvo.com>,
        Frederic Blain <frederic.blain@qorvo.com>,
        Nicolas Schodet <nico@ni.fr.eu.org>,
        Guilhem Imberton <guilhem.imberton@qorvo.com>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>
References: <20230103165644.432209-1-miquel.raynal@bootlin.com>
 <9828444e-d047-40ac-6550-0bde4a9b5230@datenfreihafen.org>
 <20230104132037.0c49a4ed@xps-13>
From:   Stefan Schmidt <stefan@datenfreihafen.org>
In-Reply-To: <20230104132037.0c49a4ed@xps-13>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-6.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello Miquel.

On 04.01.23 13:20, Miquel Raynal wrote:
> Hi Stefan,
> 
> stefan@datenfreihafen.org wrote on Tue, 3 Jan 2023 20:43:02 +0100:
> 
>> Hello Miquel.
>>
>> On 03.01.23 17:56, Miquel Raynal wrote:
>>> Hello,
>>>
>>> We now have the infrastructure to report beacons/PANs, we also have the
>>> capability to transmit MLME commands synchronously. It is time to use
>>> these to implement a proper scan implementation.
>>>
>>> There are a few side-changes which are necessary for the soft MAC scan
>>> implementation to compile/work, but nothing big. The two main changes
>>> are:
>>> * The introduction of a user API for managing scans.
>>> * The soft MAC implementation of a scan.
>>>
>>> In all the past, current and future submissions, David and Romuald from
>>> Qorvo are credited in various ways (main author, co-author,
>>> suggested-by) depending of the amount of rework that was involved on
>>> each patch, reflecting as much as possible the open-source guidelines we
>>> follow in the kernel. All this effort is made possible thanks to Qorvo
>>> Inc which is pushing towards a featureful upstream WPAN support.
>>>
>>> Example of output:
>>>
>>> 	# iwpan monitor
>>> 	coord1 (phy #1): scan started
>>> 	coord1 (phy #1): beacon received: PAN 0xabcd, addr 0xb2bcc36ac5570abe
>>> 	coord1 (phy #1): scan finished
>>> 	coord1 (phy #1): scan started
>>> 	coord1 (phy #1): scan aborted
>>
>> These patches have been applied to the wpan-next tree and will be
>> part of the next pull request to net-next. Thanks!
>>
>> Before I would add them to a pull request to net-next I would like to have an updated patchset for iwpan to reflect these scan changes. We would need something to verify the kernel changes and try to coordinate a new iwpan release with this functionality with the major kernel release bringing the feature.
> 
> So far I did not made a single change for the scan, but a common
> changeset for scan+beaconing (which I am about to send), should I split
> it or should we assume we could introduce scanning and beaconing in the
> same kernel release?

 From my side I do not mind to introduce scanning and beaconing in the 
same release. I just want to make you aware that scanning would slip if 
beaconing slips and we have no support in iwpan to test and release 
together.

If you have the beaconing patchset ready, let's start with it and if it 
turns out it will not be ready for the next release (let's hope it will) 
you can think again if you want to have the scan part split of to 
release that earlier.

regards
Stefan Schmidt
