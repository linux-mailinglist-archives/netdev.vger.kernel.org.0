Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D57F9428974
	for <lists+netdev@lfdr.de>; Mon, 11 Oct 2021 11:12:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235424AbhJKJOY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Oct 2021 05:14:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55612 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235366AbhJKJOX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Oct 2021 05:14:23 -0400
Received: from mail1.systemli.org (mail1.systemli.org [IPv6:2a00:c38:11e:ffff::a032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 04031C061570;
        Mon, 11 Oct 2021 02:12:23 -0700 (PDT)
Message-ID: <3ac87582-2a7f-6885-4f5b-c8c91b0a02cb@systemli.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=systemli.org;
        s=default; t=1633943540;
        bh=o/bmAh+lFIOgkU05licr7Un7614a5LZil6pEm849YPw=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=8Y56/Gnb6eHy22GdeeNo71WIjXrnqs3efWarX4x9QiBqcLkP+soH8DKtXz1C7B+Ho
         1CqahENdPatUjVZUT2vEkhDUfa7iVm/c9BsFauST07I8+HAfpgP7oe4BfayHTNGKX2
         Z5Jz0qEAlUvMqb2GgAAjnbzRGGIo10Ob9UWnRMk6ErtnCEwQ0srU4T7jsr/GYmVyJP
         qBpHjVr0hDpWWf6aNLTBWopiWexQslzq8sfn6MMY47gW+it8fs51jP8+OA1uAyQtlA
         cfpMIHI3A4S5EshowSn/pWJhBeDVLce1k2KExuzxwfrKpXnpAm4TJVU9NAHHp9U1LV
         CDm/Nw+VzDhgA==
Date:   Mon, 11 Oct 2021 11:12:16 +0200
MIME-Version: 1.0
Subject: Re: [RFC v2] mt76: mt7615: mt7622: fix ibss and meshpoint
Content-Language: en-US
To:     Daniel Golle <daniel@makrotopia.org>
Cc:     Kalle Valo <kvalo@codeaurora.org>, nbd@nbd.name,
        lorenzo.bianconi83@gmail.com, ryder.lee@mediatek.com,
        davem@davemloft.net, kuba@kernel.org, matthias.bgg@gmail.com,
        sean.wang@mediatek.com, shayne.chen@mediatek.com,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, linux-kernel@vger.kernel.org,
        Robert Foss <robert.foss@linaro.org>
References: <20211007225725.2615-1-vincent@systemli.org>
 <87czoe61kh.fsf@codeaurora.org>
 <274013cd-29e4-9202-423b-bd2b2222d6b8@systemli.org>
 <YWGXiExg1uBIFr2c@makrotopia.org>
From:   Nick <vincent@systemli.org>
In-Reply-To: <YWGXiExg1uBIFr2c@makrotopia.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

My tests on todays OpenWrt Trunk with my and without my patch showed:
- MT7622: AP + AdHoc (only AP is working, in every case)
- BPI-MT7615: AP + AdHoc (with and without my patch still works).

I thought something would change if I apply my patch with the 
HW-Addresses. However everything stays the same:

With my patch:
AdHoc: Shenzhen_4e:4b:dd (38:83:9a:4e:4b:dd)
AP: address: 3a:83:9a:4e:4b:dd (3a:83:9a:4e:4b:dd)

Without my patch:
AdHoc: Shenzhen_4e:4b:dd (38:83:9a:4e:4b:dd)
AP: 3a:83:9a:4e:4b:dd (3a:83:9a:4e:4b:dd)

Bests
Nick

On 10/9/21 15:22, Daniel Golle wrote:
> On Sat, Oct 09, 2021 at 12:37:53PM +0200, Nick wrote:
>> On 10/9/21 10:32, Kalle Valo wrote:
>>
>>> Nick Hainke <vincent@systemli.org> writes:
>>>
>>>> Fixes: d8d59f66d136 ("mt76: mt7615: support 16 interfaces").
>>> The fixes tag should be in the end, before Signed-off-by tags. But I can
>>> fix that during commit.
>> Thanks for feedback. Already changed that locally but I did not want to spam
>> you with another RFC v3. :)
>> I was able to organize me a BPI-MT7615 PCIE Express Card. With and without
>> this patch beacons were sent on the mt7615 pcie, so the patch did not make
>> any difference. However, the mt7622 wifi will only work with my patch.
> Does Mesh+AP or Ad-Hoc+AP also work on MT7622 and does it still work on
> MT7615E card with your patch applied?
