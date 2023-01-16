Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4DA3F66B783
	for <lists+netdev@lfdr.de>; Mon, 16 Jan 2023 07:33:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232119AbjAPGds (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Jan 2023 01:33:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57758 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231965AbjAPGdX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Jan 2023 01:33:23 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C8D0772A7;
        Sun, 15 Jan 2023 22:32:43 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 58B0560EBD;
        Mon, 16 Jan 2023 06:32:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CDD38C433D2;
        Mon, 16 Jan 2023 06:32:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1673850762;
        bh=maW64IMMxp+dx1Q+6stgYmvQzPBmd8+mugv2J37ShX4=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=QXEYzfqwYdzycgSOn5gtw7EmKdyiHiCUSf6MbN/U3ZTeN6FPkRW6hGsI9U17NqwQ4
         jIq+ReLCMCRRkeAGwOkBEq3X9/fJRBKu1WZ2k742SUWMB3k7YYcH45bcAOa4/Muqpd
         o4FdkRdbfYLszIKCnOvVmkHKYi7qu2ZRmEwP00X6fCvW7Xg//K4pwVBXHCAvLALGpR
         tKybOu9oxHxqF80poAe9YcB6qN5oh6yxzGIZzptphK0bUB+TJ3W3JVmnFoIdeH6yzJ
         DLlB5DMQbKW87toSuCoHodH4MV4eyUHseKkRVPYjz7+MyFL4Dtj0wGfAFwXbImqqnE
         hgayHBEKNYjhw==
From:   Kalle Valo <kvalo@kernel.org>
To:     Eric Dumazet <edumazet@google.com>
Cc:     Lizhe <sensor1010@163.com>, davem@davemloft.net, kuba@kernel.org,
        pabeni@redhat.com, johannes.berg@intel.com,
        alexander@wetzel-home.de, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v1] wireless/at76c50x-usb.c : Use devm_kzalloc replaces kmalloc
References: <20230113133503.58336-1-sensor1010@163.com>
        <CANn89iKDXQ_nvnXBp5Q99P67AW-jFTNkpEmYdESDWitf0Nt4vw@mail.gmail.com>
Date:   Mon, 16 Jan 2023 08:32:37 +0200
In-Reply-To: <CANn89iKDXQ_nvnXBp5Q99P67AW-jFTNkpEmYdESDWitf0Nt4vw@mail.gmail.com>
        (Eric Dumazet's message of "Fri, 13 Jan 2023 14:44:58 +0100")
Message-ID: <87358bat16.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Eric Dumazet <edumazet@google.com> writes:

> On Fri, Jan 13, 2023 at 2:35 PM Lizhe <sensor1010@163.com> wrote:
>>
>> use devm_kzalloc replaces kamlloc
>>
>> Signed-off-by: Lizhe <sensor1010@163.com>
>> ---
>>  drivers/net/wireless/atmel/at76c50x-usb.c | 3 +--
>>  1 file changed, 1 insertion(+), 2 deletions(-)
>>
>> diff --git a/drivers/net/wireless/atmel/at76c50x-usb.c b/drivers/net/wireless/atmel/at76c50x-usb.c
>> index 009bca34ece3..ebd8ef525557 100644
>> --- a/drivers/net/wireless/atmel/at76c50x-usb.c
>> +++ b/drivers/net/wireless/atmel/at76c50x-usb.c
>> @@ -2444,7 +2444,7 @@ static int at76_probe(struct usb_interface *interface,
>>
>>         udev = usb_get_dev(interface_to_usbdev(interface));
>>
>> -       fwv = kmalloc(sizeof(*fwv), GFP_KERNEL);
>> +       fwv = devm_kzalloc(sizeof(*fwv), GFP_KERNEL);
>
> Have you compiled this patch ?

Clearly not:

https://lore.kernel.org/linux-wireless/202301140533.jMlST9Ur-lkp@intel.com/

Lizhe, do not EVER submit untested patches. In some simple patches doing
just a compilation test might suffice, but please mention the patch is
only compile tested clearly in the commit log. But not even doing a
compilation test is a big no.

-- 
https://patchwork.kernel.org/project/linux-wireless/list/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
