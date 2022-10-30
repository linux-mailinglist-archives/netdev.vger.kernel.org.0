Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 166D36129F3
	for <lists+netdev@lfdr.de>; Sun, 30 Oct 2022 11:11:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230142AbiJ3KL2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 30 Oct 2022 06:11:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55106 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230132AbiJ3KL1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 30 Oct 2022 06:11:27 -0400
Received: from mx1.molgen.mpg.de (mx3.molgen.mpg.de [141.14.17.11])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 80AAEC0B;
        Sun, 30 Oct 2022 03:11:26 -0700 (PDT)
Received: from [192.168.0.2] (ip5f5ae8c4.dynamic.kabel-deutschland.de [95.90.232.196])
        (using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: pmenzel)
        by mx.molgen.mpg.de (Postfix) with ESMTPSA id C1CCE61EA192D;
        Sun, 30 Oct 2022 11:11:23 +0100 (CET)
Message-ID: <80f39eff-d175-785c-c10f-a31a046ec132@molgen.mpg.de>
Date:   Sun, 30 Oct 2022 11:11:23 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.0
Subject: Re: [PATCH v2] Bluetooth: Use kzalloc instead of kmalloc/memset
To:     Kang Minchul <tegongkang@gmail.com>
Cc:     Marcel Holtmann <marcel@holtmann.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        Luiz Augusto von Dentz <luiz.dentz@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        linux-bluetooth@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20221029214058.25159-1-tegongkang@gmail.com>
Content-Language: en-US
From:   Paul Menzel <pmenzel@molgen.mpg.de>
In-Reply-To: <20221029214058.25159-1-tegongkang@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Dear Kang,


Thank you for the patch.


Am 29.10.22 um 23:40 schrieb Kang Minchul:
> This commit replace kmalloc + memset to kzalloc

replace*s*

(Though starting with “This commit …” is redundant.

> for better code readability and simplicity.
> 
> Following messages are related cocci warnings.

Maybe: This addresse the cocci warning below.

> WARNING: kzalloc should be used for d, instead of kmalloc/memset
> 
> Signed-off-by: Kang Minchul <tegongkang@gmail.com>
> ---
> V1 -> V2: Change subject prefix
> 
>   net/bluetooth/hci_conn.c | 6 ++----
>   1 file changed, 2 insertions(+), 4 deletions(-)
> 
> diff --git a/net/bluetooth/hci_conn.c b/net/bluetooth/hci_conn.c
> index 7a59c4487050..287d313aa312 100644
> --- a/net/bluetooth/hci_conn.c
> +++ b/net/bluetooth/hci_conn.c
> @@ -824,11 +824,10 @@ static int hci_le_terminate_big(struct hci_dev *hdev, u8 big, u8 bis)
>   
>   	bt_dev_dbg(hdev, "big 0x%2.2x bis 0x%2.2x", big, bis);
>   
> -	d = kmalloc(sizeof(*d), GFP_KERNEL);
> +	d = kzalloc(sizeof(*d), GFP_KERNEL);
>   	if (!d)
>   		return -ENOMEM;
>   
> -	memset(d, 0, sizeof(*d));
>   	d->big = big;
>   	d->bis = bis;
>   
> @@ -861,11 +860,10 @@ static int hci_le_big_terminate(struct hci_dev *hdev, u8 big, u16 sync_handle)
>   
>   	bt_dev_dbg(hdev, "big 0x%2.2x sync_handle 0x%4.4x", big, sync_handle);
>   
> -	d = kmalloc(sizeof(*d), GFP_KERNEL);
> +	d = kzalloc(sizeof(*d), GFP_KERNEL);
>   	if (!d)
>   		return -ENOMEM;
>   
> -	memset(d, 0, sizeof(*d));
>   	d->big = big;
>   	d->sync_handle = sync_handle;

Reviewed-by: Paul Menzel <pmenzel@molgen.mpg.de>


Kind regards,

Paul
