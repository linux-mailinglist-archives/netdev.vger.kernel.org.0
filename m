Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 839583BE9EF
	for <lists+netdev@lfdr.de>; Wed,  7 Jul 2021 16:42:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232105AbhGGOoj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Jul 2021 10:44:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43378 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232052AbhGGOoi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Jul 2021 10:44:38 -0400
Received: from proxima.lasnet.de (proxima.lasnet.de [IPv6:2a01:4f8:121:31eb:3::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C510C061574;
        Wed,  7 Jul 2021 07:41:58 -0700 (PDT)
Received: from [IPv6:2003:e9:d72a:e927:359b:e3fc:a5d5:7a7a] (p200300e9d72ae927359be3fca5d57a7a.dip0.t-ipconnect.de [IPv6:2003:e9:d72a:e927:359b:e3fc:a5d5:7a7a])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: stefan@datenfreihafen.org)
        by proxima.lasnet.de (Postfix) with ESMTPSA id 7102EC03B9;
        Wed,  7 Jul 2021 16:41:55 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=datenfreihafen.org;
        s=2021; t=1625668915;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=lRjLDhVpuuPa/gMOaGrixw4j52qteoeLZp3RaASCXjM=;
        b=km81V+BClsvauNOS6MNQTc+L/Z5F1sfMzfJFXaKzwkVYiSwZSbfKMojrltyPlEh4UImnr2
        4h5sRmDcTRwa9WwvRIj01Si+WEDkSkjD/1pUdsoq0ryqIUx89S/Rzoq3W9Ki6oP5AybXtb
        mlml/HZF4pcqIsmd0iAniVhhBjlkoS3YPNao5EgN21vryIlcmfnz4sznsSOhYFAq1Vcix7
        rrMIeaxiWGIG5KlSG26lvPsIxqud1s6LRUG/wqRvTLy56hXbgwbyy9b0SH/98yUpz971Wx
        B7rYoetMpuAjj8aRB8Jhp7snwqG1w9D0M+JOiEa6N1VlPVoMskxCK3LfBuRbjw==
Subject: Re: [PATCH] ieee802154: hwsim: fix GPF in hwsim_set_edge_lqi
To:     Dongliang Mu <mudongliangabcd@gmail.com>,
        Alexander Aring <alex.aring@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexander Aring <aring@mojatatu.com>,
        linux-wpan - ML <linux-wpan@vger.kernel.org>,
        "open list:NETWORKING [GENERAL]" <netdev@vger.kernel.org>,
        kernel list <linux-kernel@vger.kernel.org>
References: <20210705131321.217111-1-mudongliangabcd@gmail.com>
 <CAB_54W5ceXFPaYGs0T4pVq8AzRqUSvaBDWdBjvRurBYyihqfVg@mail.gmail.com>
 <CAD-N9QWykP2CBq1bPvz=HQRdeaR+Mg06hezrgOm4g3N1J_jT1g@mail.gmail.com>
From:   Stefan Schmidt <stefan@datenfreihafen.org>
Message-ID: <b3783b1c-0874-d16e-c51c-55cbec3b29fa@datenfreihafen.org>
Date:   Wed, 7 Jul 2021 16:41:54 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <CAD-N9QWykP2CBq1bPvz=HQRdeaR+Mg06hezrgOm4g3N1J_jT1g@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello.

On 07.07.21 16:40, Dongliang Mu wrote:
> On Wed, Jul 7, 2021 at 9:44 PM Alexander Aring <alex.aring@gmail.com> wrote:
>>
>> Hi,
>>
>> On Mon, 5 Jul 2021 at 09:13, Dongliang Mu <mudongliangabcd@gmail.com> wrote:
>>>
>>> Both MAC802154_HWSIM_ATTR_RADIO_ID and MAC802154_HWSIM_ATTR_RADIO_EDGE,
>>> MAC802154_HWSIM_EDGE_ATTR_ENDPOINT_ID and MAC802154_HWSIM_EDGE_ATTR_LQI
>>> must be present to fix GPF.
>>>
>>> Fixes: f25da51fdc38 ("ieee802154: hwsim: add replacement for fakelb")
>>> Signed-off-by: Dongliang Mu <mudongliangabcd@gmail.com>
>>
>> Acked-by: Alexander Aring <aahringo@redhat.com>
>>
>> Thanks, but there are more places than this one. Can you send patches
>> for them as well? Thanks! :)
> 
> Sure. I will double-check those places and send patches to fix them.

I will take this one in as-is. All new patches should be done with this 
one applied.

regards
Stefan Schmidt
