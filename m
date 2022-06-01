Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3251153AEF3
	for <lists+netdev@lfdr.de>; Thu,  2 Jun 2022 00:50:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231163AbiFAVB6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Jun 2022 17:01:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59510 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231201AbiFAVB4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Jun 2022 17:01:56 -0400
Received: from proxima.lasnet.de (proxima.lasnet.de [78.47.171.185])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C36B1BF16E;
        Wed,  1 Jun 2022 14:01:54 -0700 (PDT)
Received: from [IPV6:2003:e9:d72e:f86c:6f28:ee17:a8de:98f4] (p200300e9d72ef86c6f28ee17a8de98f4.dip0.t-ipconnect.de [IPv6:2003:e9:d72e:f86c:6f28:ee17:a8de:98f4])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: stefan@datenfreihafen.org)
        by proxima.lasnet.de (Postfix) with ESMTPSA id 97710C0B8E;
        Wed,  1 Jun 2022 23:01:51 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=datenfreihafen.org;
        s=2021; t=1654117312;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=AtxzjEUYUtIu8UNq+jrQ3X2tQDohu0dfc23HDBAGAMc=;
        b=nv5QrKqjQhc8wBJraWhweZofykUyAUDSub85kSQsie77+ACoatwNQHIRFeW4KaWislV1ra
        LEE1YRKjh0GiB4wdGXelVypjEj5HLMre2IhVD3OL63RNHdNFfJB+jD9LrHUghHn0uSbW/6
        lFE6K7UX8KSPdGdZik/3WrfffylpquZB941z3Ud8rbRA2LiH1mMqQmIeGrQDAw1nmrVlxw
        pwwME6ywIa7Fy+rBSnaiF2CckEFiTakIoeZrBaptDmHsGn81msoC+MdEb2Jpu2kArkQ2wW
        4wqyomup4rOW9RSb+IbiTbOKtsFfDNDAvDu+NfZA1WhvDc19/pXQlwT7fqIcXQ==
Message-ID: <d844514c-771f-e720-407b-2679e430243a@datenfreihafen.org>
Date:   Wed, 1 Jun 2022 23:01:51 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
Subject: Re: [PATCH wpan-next v4 00/11] ieee802154: Synchronous Tx support
Content-Language: en-US
To:     Alexander Aring <aahringo@redhat.com>,
        Miquel Raynal <miquel.raynal@bootlin.com>
Cc:     Alexander Aring <alex.aring@gmail.com>,
        linux-wpan - ML <linux-wpan@vger.kernel.org>,
        David Girault <david.girault@qorvo.com>,
        Romuald Despres <romuald.despres@qorvo.com>,
        Frederic Blain <frederic.blain@qorvo.com>,
        Nicolas Schodet <nico@ni.fr.eu.org>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Network Development <netdev@vger.kernel.org>
References: <20220519150516.443078-1-miquel.raynal@bootlin.com>
 <CAK-6q+hmd_Z-xJrz6QVM37gFrPRkYPAnyERit5oyDS=Beb83kg@mail.gmail.com>
From:   Stefan Schmidt <stefan@datenfreihafen.org>
In-Reply-To: <CAK-6q+hmd_Z-xJrz6QVM37gFrPRkYPAnyERit5oyDS=Beb83kg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.7 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Hello.

On 01.06.22 05:30, Alexander Aring wrote:
> Hi,
> 
> On Thu, May 19, 2022 at 11:06 AM Miquel Raynal
> <miquel.raynal@bootlin.com> wrote:
>>
>> Hello,
>>
>> This series brings support for that famous synchronous Tx API for MLME
>> commands.
>>
>> MLME commands will be used during scan operations. In this situation,
>> we need to be sure that all transfers finished and that no transfer
>> will be queued for a short moment.
>>
> 
> Acked-by: Alexander Aring <aahringo@redhat.com>

These patches have been applied to the wpan-next tree. Thanks!

> There will be now functions upstream which will never be used, Stefan
> should wait until they are getting used before sending it to net-next.

Indeed this can wait until we have a consumer of the functions before 
pushing this forward to net-next. Pretty sure Miquel is happy to finally 
move on to other pieces of his puzzle and use them. :-)

regards
Stefan Schmidt
