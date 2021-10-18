Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BBB024315BE
	for <lists+netdev@lfdr.de>; Mon, 18 Oct 2021 12:17:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229998AbhJRKTM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Oct 2021 06:19:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45034 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229985AbhJRKTG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Oct 2021 06:19:06 -0400
Received: from nbd.name (nbd.name [IPv6:2a01:4f8:221:3d45::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8986EC0617AA;
        Mon, 18 Oct 2021 03:16:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nbd.name;
         s=20160729; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:From:
        References:Cc:To:Subject:MIME-Version:Date:Message-ID:Sender:Reply-To:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
        List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=iosnmQOJWI7XWNeYhYR243+qqN8R1RCG0Hp7iVJ4bxg=; b=gf2eLeWZLk2w6Vi2AU54sQvFrX
        injMvWZyhfNraHIvhffFnRRdadeqE37Xj62GGt9/Izgpf3dB5/q/mBr51WUuTMBCKsgdlZizPMsT6
        yT4yNeT+JOFR377JuEUf8Z/dw7Q7e74JzYaP1D/Mr30DrH9//0C+RF9X69ZpGqZ+1bX4=;
Received: from p4ff1322b.dip0.t-ipconnect.de ([79.241.50.43] helo=nf.local)
        by ds12 with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.89)
        (envelope-from <nbd@nbd.name>)
        id 1mcPgX-0004ZM-2s; Mon, 18 Oct 2021 12:16:01 +0200
Message-ID: <569d434d-cf5b-6ab0-5931-41b21ab047b7@nbd.name>
Date:   Mon, 18 Oct 2021 12:16:00 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.2.0
Subject: Re: [RFC v2] mt76: mt7615: mt7622: fix ibss and meshpoint
Content-Language: en-US
To:     Kalle Valo <kvalo@codeaurora.org>,
        Nick Hainke <vincent@systemli.org>
Cc:     lorenzo.bianconi83@gmail.com, ryder.lee@mediatek.com,
        davem@davemloft.net, kuba@kernel.org, matthias.bgg@gmail.com,
        sean.wang@mediatek.com, shayne.chen@mediatek.com,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, linux-kernel@vger.kernel.org,
        Robert Foss <robert.foss@linaro.org>
References: <20211007225725.2615-1-vincent@systemli.org>
 <87czoe61kh.fsf@codeaurora.org>
From:   Felix Fietkau <nbd@nbd.name>
In-Reply-To: <87czoe61kh.fsf@codeaurora.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2021-10-09 10:32, Kalle Valo wrote:
> Nick Hainke <vincent@systemli.org> writes:
> 
>> Fixes: d8d59f66d136 ("mt76: mt7615: support 16 interfaces").
> 
> The fixes tag should be in the end, before Signed-off-by tags. But I can
> fix that during commit.
> 
>> commit 7f4b7920318b ("mt76: mt7615: add ibss support") introduced IBSS
>> and commit f4ec7fdf7f83 ("mt76: mt7615: enable support for mesh")
>> meshpoint support.
>>
>> Both used in the "get_omac_idx"-function:
>>
>> 	if (~mask & BIT(HW_BSSID_0))
>> 		return HW_BSSID_0;
>>
>> With commit d8d59f66d136 ("mt76: mt7615: support 16 interfaces") the
>> ibss and meshpoint mode should "prefer hw bssid slot 1-3". However,
>> with that change the ibss or meshpoint mode will not send any beacon on
>> the mt7622 wifi anymore. Devices were still able to exchange data but
>> only if a bssid already existed. Two mt7622 devices will never be able
>> to communicate.
>>
>> This commits reverts the preferation of slot 1-3 for ibss and
>> meshpoint. Only NL80211_IFTYPE_STATION will still prefer slot 1-3.
>>
>> Tested on Banana Pi R64.
>>
>> Signed-off-by: Nick Hainke <vincent@systemli.org>
> 
> Felix, can I take this to wireless-drivers? Ack?
Acked-by: Felix Fietkau <nbd@nbd.name>
