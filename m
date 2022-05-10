Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EE9A0520D61
	for <lists+netdev@lfdr.de>; Tue, 10 May 2022 07:55:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236893AbiEJF7V (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 May 2022 01:59:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41596 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233186AbiEJF7T (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 May 2022 01:59:19 -0400
Received: from mx1.molgen.mpg.de (mx3.molgen.mpg.de [141.14.17.11])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9268B291CCB;
        Mon,  9 May 2022 22:55:22 -0700 (PDT)
Received: from [192.168.0.2] (ip5f5aeae3.dynamic.kabel-deutschland.de [95.90.234.227])
        (using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: pmenzel)
        by mx.molgen.mpg.de (Postfix) with ESMTPSA id 8353A61E6478B;
        Tue, 10 May 2022 07:55:19 +0200 (CEST)
Message-ID: <76bc568e-4b3e-135c-5a5b-34a7dce42498@molgen.mpg.de>
Date:   Tue, 10 May 2022 07:55:18 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.1
Subject: Re: [PATCH] Bluetooth: Fix Adv Monitor msft_add/remove_monitor_sync()
Content-Language: en-US
To:     Manish Mandlik <mmandlik@google.com>
Cc:     marcel@holtmann.org, luiz.dentz@gmail.com,
        chromeos-bluetooth-upstreaming@chromium.org,
        linux-bluetooth@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        Paolo Abeni <pabeni@redhat.com>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
References: <20220509140403.1.I28d2ec514ad3b612015b28b8de861b8955033a19@changeid>
From:   Paul Menzel <pmenzel@molgen.mpg.de>
In-Reply-To: <20220509140403.1.I28d2ec514ad3b612015b28b8de861b8955033a19@changeid>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.3 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Dear Manish,


Thank you for your patch.

Am 09.05.22 um 23:05 schrieb Manish Mandlik:
> Do not call skb_pull() in msft_add_monitor_sync() as
> msft_le_monitor_advertisement_cb() expects 'status' to be
> part of the skb.

Please reflow for 75 characters per line.

> Same applies for msft_remove_monitor_sync().

Was this found by code review, or were there noticeable problems? If the 
later, please add a note, how to reproduce it.

Also, maybe also add a Fixes tag, referencing the commit introducing the 
problem.


Kind regards,

Paul


> Signed-off-by: Manish Mandlik <mmandlik@google.com>
> ---
> 
>   net/bluetooth/msft.c | 2 --
>   1 file changed, 2 deletions(-)
> 
> diff --git a/net/bluetooth/msft.c b/net/bluetooth/msft.c
> index f43994523b1f..9990924719aa 100644
> --- a/net/bluetooth/msft.c
> +++ b/net/bluetooth/msft.c
> @@ -387,7 +387,6 @@ static int msft_remove_monitor_sync(struct hci_dev *hdev,
>   		return PTR_ERR(skb);
>   
>   	status = skb->data[0];
> -	skb_pull(skb, 1);
>   
>   	msft_le_cancel_monitor_advertisement_cb(hdev, status, hdev->msft_opcode,
>   						skb);
> @@ -506,7 +505,6 @@ static int msft_add_monitor_sync(struct hci_dev *hdev,
>   		return PTR_ERR(skb);
>   
>   	status = skb->data[0];
> -	skb_pull(skb, 1);
>   
>   	msft_le_monitor_advertisement_cb(hdev, status, hdev->msft_opcode, skb);
>   
