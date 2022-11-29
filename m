Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F07CC63C03F
	for <lists+netdev@lfdr.de>; Tue, 29 Nov 2022 13:41:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234296AbiK2Mlk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Nov 2022 07:41:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34530 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232559AbiK2Mli (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Nov 2022 07:41:38 -0500
Received: from proxima.lasnet.de (proxima.lasnet.de [78.47.171.185])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4FBF65EFB6;
        Tue, 29 Nov 2022 04:41:37 -0800 (PST)
Received: from [IPV6:2003:e9:d724:11f3:6a8a:fec:d223:2c22] (p200300e9d72411f36a8a0fecd2232c22.dip0.t-ipconnect.de [IPv6:2003:e9:d724:11f3:6a8a:fec:d223:2c22])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: stefan@datenfreihafen.org)
        by proxima.lasnet.de (Postfix) with ESMTPSA id C577EC0438;
        Tue, 29 Nov 2022 13:41:34 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=datenfreihafen.org;
        s=2021; t=1669725695;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=hgpY+NqQsulFa+2pWd5BcoI5h8CmCSGexzhvrO3xo+g=;
        b=UHFUD0ggPNPLNVNfcd+a8r3l8qeqyshayAU+e30y4H4cxefuUNRDTzVj4kX/8OFD5m2rbK
        KqPHaw+ThfqaJNkMfAKPNGzl9tq7voBfb8uAcF9JtsWhyX3qM4yKk1aGCMEkOP8RMUJSOt
        XdgbD+ColMiE/53eFFanXZaMAv2DD3Uub4a4FM1KIg/jlCHFdIicea7heQedhdyL3Fird9
        JZ+zFC3stx6OSC3wnH/UP9BAim8dd88puR5X38vz8RTHolOADl12mp8jvR6yjtFHHIo26m
        QNA3ewa9FOQgBV04OyE5nsGnPgCjtsgfsLFYlXmc4WxArJA/9XsRmXhK+6Bflg==
Message-ID: <ff0e20e9-687c-75f7-12ea-c927df39a1db@datenfreihafen.org>
Date:   Tue, 29 Nov 2022 13:41:32 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
Subject: Re: [PATCH wpan-next v2 0/2] IEEE 802.15.4 PAN discovery handling
Content-Language: en-US
To:     Miquel Raynal <miquel.raynal@bootlin.com>,
        Alexander Aring <aahringo@redhat.com>
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
References: <20221118221041.1402445-1-miquel.raynal@bootlin.com>
 <CAK-6q+iLkYuz5csmbLt=tKcfGmdNGP+Sm42+DQRu5180jafEGw@mail.gmail.com>
 <20221129090321.132a4439@xps-13>
From:   Stefan Schmidt <stefan@datenfreihafen.org>
In-Reply-To: <20221129090321.132a4439@xps-13>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.7 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello.

On 29.11.22 09:03, Miquel Raynal wrote:
> Hi Alexander,
> 
> aahringo@redhat.com wrote on Mon, 28 Nov 2022 17:11:38 -0500:
> 
>> Hi,
>>
>> On Fri, Nov 18, 2022 at 5:13 PM Miquel Raynal <miquel.raynal@bootlin.com> wrote:
>>>
>>> Hello,
>>>
>>> Last preparation step before the introduction of the scanning feature
>>> (really): generic helpers to handle PAN discovery upon beacon
>>> reception. We need to tell user space about the discoveries.
>>>
>>> In all the past, current and future submissions, David and Romuald from
>>> Qorvo are credited in various ways (main author, co-author,
>>> suggested-by) depending of the amount of rework that was involved on
>>> each patch, reflecting as much as possible the open-source guidelines we
>>> follow in the kernel. All this effort is made possible thanks to Qorvo
>>> Inc which is pushing towards a featureful upstream WPAN support.
>>>   
>>
>> Acked-by: Alexander Aring <aahringo@redhat.com>
>>
>> I am sorry, I saw this series today. Somehow I mess up my mails if we
>> are still writing something on v1 but v2 is already submitted. I will
>> try to keep up next time.
> 
> Haha I was asking myself wether or not you saw it, no problem :) I did
> send it after your main review but we continued discussing on v1 (about
> the preambles) so I did not ping for the time the discussion would
> settle.

I was trying to apply these two patches, but the first one does not apply:


Failed to apply patch:
error: patch failed: include/net/nl802154.h:58
error: include/net/nl802154.h: patch does not apply
hint: Use 'git am --show-current-patch=diff' to see the failed patch
Applying: ieee802154: Advertize coordinators discovery
Patch failed at 0001 ieee802154: Advertize coordinators discovery

It seems you need a rebase as there is commit 
8254393663f9b8cb8b84cdce1abb118833c22a54 which touches this area of the 
file and removes a comment and ifdef. Should be fine to go in after the 
rebase.

regards
Stefan Schmidt
