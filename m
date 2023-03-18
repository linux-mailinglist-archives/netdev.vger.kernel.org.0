Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 721A96BF86C
	for <lists+netdev@lfdr.de>; Sat, 18 Mar 2023 08:06:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229737AbjCRHGY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 18 Mar 2023 03:06:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51914 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229478AbjCRHGX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 18 Mar 2023 03:06:23 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 19D774FCDD;
        Sat, 18 Mar 2023 00:06:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 59A5FB80E8D;
        Sat, 18 Mar 2023 07:06:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 52137C433EF;
        Sat, 18 Mar 2023 07:06:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679123179;
        bh=49KA3iNvSyleR2UVuJjsn11DXyb3q1V2rfZ2s1YjuCg=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=PGVY03EK8gdnEB1pOuQ9qT81m5rreHG+0YJsainUKyEGrqiuh0GPB1hf7iA7qXRCP
         4mRQavKUVsh5I04bxF70f9qjj+a/vJ1867uGlJ4zPaV2ObclItHfLCXE5GZmJxJ4s/
         zeCtWZCg+rvMtuXLzWK6STUZwzqJH/o520nHUdjdDEXNxbYCkSmE0ELE5a9WHAxi2W
         cgnR/vHgs6Q9NAkBXIWPrcu0Y1xbLWU3u5gXsiamDETdL69OsScc1yDl8Bqnbh/7d4
         UsAyiUskYk7Ru7GkEv9NcvzVXzNyGC6Jm2Av6jliMEa1hXHlG43KcaL/W9U9+AwyFS
         0d7Rw40oSnF9w==
From:   Kalle Valo <kvalo@kernel.org>
To:     Nick Morrow <morrownr@gmail.com>
Cc:     Reese Russell <git@qrsnap.io>, Felix Fietkau <nbd@nbd.name>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        Ryder Lee <ryder.lee@mediatek.com>,
        Shayne Chen <shayne.chen@mediatek.com>,
        Sean Wang <sean.wang@mediatek.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Deren Wu <deren.wu@mediatek.com>,
        YN Chen <YN.Chen@mediatek.com>,
        Ben Greear <greearb@candelatech.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Added Netgear AXE3000 (A8000) usb_device_id to mt7921u_device_table[]
References: <20230123090555.21415-1-git@qrsnap.io>
        <CAFktD2eFdaCAdE=zxVx05QYWPRcr5StompKr+ehn7piYpQHjzA@mail.gmail.com>
Date:   Sat, 18 Mar 2023 09:06:09 +0200
In-Reply-To: <CAFktD2eFdaCAdE=zxVx05QYWPRcr5StompKr+ehn7piYpQHjzA@mail.gmail.com>
        (Nick Morrow's message of "Fri, 17 Mar 2023 14:49:56 -0500")
Message-ID: <87wn3ev8ri.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Nick Morrow <morrownr@gmail.com> writes:

>> Issue: Though the Netgear AXE3000 (A8000) is based on the mt7921
>> chipset because of the unique USB VID:PID combination this device
>> does not initialize/register. Thus making it not plug and play.
>>
>> Fix: Adds support for the Netgear AXE3000 (A8000) based on the Mediatek
>> mt7921au chipset. The method of action is adding the USD VID/PID
>> pair to the mt7921u_device_table[] array.
>>
>> Notes: A retail sample of the Netgear AXE3000 (A8000) yeilds the following
>> from lsusb D 0846:9060 NetGear, Inc. Wireless_Device. This pair
>> 0846:9060 VID:PID has been reported by other users on Github.
>>
>> Signed-off-by: Reese Russell <git@qrsnap.io>
>> ---
>>  drivers/net/wireless/mediatek/mt76/mt7921/usb.c | 2 ++
>>  1 file changed, 2 insertions(+)
>>
>> diff --git a/drivers/net/wireless/mediatek/mt76/mt7921/usb.c b/drivers/net/wireless/mediatek/mt76/mt7921/usb.c
>> index 5321d20dcdcb..62e9728588f8 100644
>> --- a/drivers/net/wireless/mediatek/mt76/mt7921/usb.c
>> +++ b/drivers/net/wireless/mediatek/mt76/mt7921/usb.c
>> @@ -15,6 +15,8 @@
>>  static const struct usb_device_id mt7921u_device_table[] = {
>>         { USB_DEVICE_AND_INTERFACE_INFO(0x0e8d, 0x7961, 0xff, 0xff, 0xff),
>>                 .driver_info = (kernel_ulong_t)MT7921_FIRMWARE_WM },
>> +       { USB_DEVICE_AND_INTERFACE_INFO(0x0846, 0x9060, 0xff, 0xff, 0xff),
>> +               .driver_info = (kernel_ulong_t)MT7921_FIRMWARE_WM },
>>         { },
>>  };
>>
>> --
>> 2.37.2
>
>
> I can confirm this VID/PID needs to go into 6.1 LTS and the current
> testing version of the kernel as I am getting an increasing amount of
> traffic from users that have purchased the Netgear A8000.
>
> My site is github.com/morrownr/USB-WiFi
>
> Helping Linux users with USB WiFi is what we do.
>
> The OP could have added a comment to the patch showing the adapter
> that is causing this patch to be submitted. Maybe he can submit a v2
> that can be expedited?
>
> Guidance?

I assigned this to me on patchwork, I'll queue this for v6.3 and change
the commit log to below. Felix&Lorenzo, ack?

wifi: mt76: mt7921: add Netgear AXE3000 (A8000)

Add support for the Netgear AXE3000 (A8000) based on the Mediatek
mt7921au chipset. A retail sample of the Netgear AXE3000 (A8000) yeilds
the following from lsusb D 0846:9060 NetGear, Inc. Wireless_Device. This
has been reported by other users on Github.

-- 
https://patchwork.kernel.org/project/linux-wireless/list/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
