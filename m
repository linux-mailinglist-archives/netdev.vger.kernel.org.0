Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 56928699C94
	for <lists+netdev@lfdr.de>; Thu, 16 Feb 2023 19:44:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229483AbjBPSov (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Feb 2023 13:44:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49268 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229534AbjBPSop (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Feb 2023 13:44:45 -0500
Received: from mail.ispras.ru (mail.ispras.ru [83.149.199.84])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C3632054D;
        Thu, 16 Feb 2023 10:44:44 -0800 (PST)
Received: from [192.168.0.114] (unknown [46.242.14.200])
        by mail.ispras.ru (Postfix) with ESMTPSA id 4C231419E9E6;
        Thu, 16 Feb 2023 18:44:42 +0000 (UTC)
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.ispras.ru 4C231419E9E6
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ispras.ru;
        s=default; t=1676573082;
        bh=EqOQx83BdAzg6o/suuDu9950m4TfKh84CKhroiqDSbU=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=gGw4XYyKx4goSLSPfdiNg0By5V0rh5fLI1+NxBntSDeVGdTG0wTDu5pqFRMK43QYB
         K8yTN/rB/B7+cNKj9qDegisZxHu21G9Ky6ZeVxULL71PBnzBHd6ZXlJ3+ZZO3GEdEm
         Qr2lIslyM3rxs0b5y3ef1TAskBBZ1m6YN/dqtTmg=
Message-ID: <b867a165-3ca2-6ce7-4373-2a69d0a1341b@ispras.ru>
Date:   Thu, 16 Feb 2023 21:44:42 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [PATCH 1/1] wifi: ath9k: hif_usb: fix memory leak of remain_skbs
Content-Language: en-US
To:     =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgensen?= <toke@toke.dk>
Cc:     Kalle Valo <kvalo@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "John W. Linville" <linville@tuxdriver.com>,
        Vasanthakumar Thiagarajan <vasanth@atheros.com>,
        Senthil Balasubramanian <senthilkumar@atheros.com>,
        Sujith <Sujith.Manoharan@atheros.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Alexey Khoroshilov <khoroshilov@ispras.ru>,
        lvc-project@linuxtesting.org
References: <20230212145238.123055-1-pchelkin@ispras.ru>
 <20230212145238.123055-2-pchelkin@ispras.ru> <87a61dsi1n.fsf@toke.dk>
 <5d67552f-88dd-7bbe-ebeb-888d1efad985@ispras.ru> <87ttzlqyd4.fsf@toke.dk>
From:   Fedor Pchelkin <pchelkin@ispras.ru>
In-Reply-To: <87ttzlqyd4.fsf@toke.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 16.02.2023 21:05, Toke Høiland-Jørgensen wrote:
> Fedor Pchelkin <pchelkin@ispras.ru> writes:
>
>> On 16.02.2023 19:15, Toke Høiland-Jørgensen wrote:
>>   > Erm, does this actually fix the leak? AFAICT, ath9k_hif_usb_dev_deinit()
>>   > is only called on the error path of ath9k_hif_usb_firmware_cb(), not
>>   > when the device is subsequently torn down in
>>   > ath9k_htc_disconnect_device()?
>>
>> ath9k_hif_usb_dev_deinit() is also called inside
>> ath9k_hif_usb_disconnect().
> No it's not, as of:
>
> f099c5c9e2ba ("wifi: ath9k: Fix use-after-free in ath9k_hif_usb_disconnect()")
>
> I guess you're looking at an older tree? Please base your patches on an
> up-to-date ath-next tree.
>
Oops, that's my fault, I indeed patched the wrong tree.

Thanks for clarifying!

