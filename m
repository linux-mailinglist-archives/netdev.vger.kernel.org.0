Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4D06262FFDA
	for <lists+netdev@lfdr.de>; Fri, 18 Nov 2022 23:13:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231392AbiKRWNt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Nov 2022 17:13:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40572 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231417AbiKRWNr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Nov 2022 17:13:47 -0500
Received: from mail-vk1-xa29.google.com (mail-vk1-xa29.google.com [IPv6:2607:f8b0:4864:20::a29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E0A123135E
        for <netdev@vger.kernel.org>; Fri, 18 Nov 2022 14:13:45 -0800 (PST)
Received: by mail-vk1-xa29.google.com with SMTP id j24so3111292vkk.0
        for <netdev@vger.kernel.org>; Fri, 18 Nov 2022 14:13:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=9HIZAiSysuw2doUjylAnKlqbhA9PzEfSvbnX1cD3GlI=;
        b=c2btve6LWatThproKL68rwVROlKUsBMnqW2CMKWQojdaXzIyuZMxwd+uMUwiW/hVT3
         XINCiWi9UOs2Y4/YUskv89qfd5sxspSCWH2BKTsF2drLX55FtifiBJhVBDxGMtQNgB0D
         ZY9r6FRAs87AxzUY/7VyAwr+mvXgMfqAWzKuYnNmzsoZVmd+XdimGVHJsa6zX88lQIjA
         gU15AXkqn5o8P2T3ylHjveMc3UEccLoC5zSZcwQ7M1hea4zNKwNXUBDyvI7/3ZwmkfFC
         fW9drTCxI5jYkgaOAKBadlQKFhTb/LgKOKtetUr9hse/w9HuObELqNAiF4JgU3s7E54C
         KGhQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=9HIZAiSysuw2doUjylAnKlqbhA9PzEfSvbnX1cD3GlI=;
        b=G5DRoz4ydTQr0IQOem9hi1gXlQynh+svAO03+ZHWATQYBi3EAEq3R15ZuduXNr0s88
         BtlKBLd9cMi4Mw3OuAiZQ0KLxHjmB0vK+alr2eA7MuTk67axBFKZAQgKXJFy78KxRap4
         lZEQPh/k3502Eq+Or5pk5oYnpc0UhqJYh/Sw6RvvYr0bzTkIbgLKYohUu7zSQIuD6eKr
         p99MzerPd/dE4YupnbKT+eVt5Vpp0ZPvu3DIDSjgiwqA009tDBghCkS3j1JD3l1nzF6g
         G0e9iCLr+yvmEdfKrdFdeVUSTrSbJUs/6J3hf9xgazgqJnoeR45v25oTAPJPv5zWXnqb
         NhnQ==
X-Gm-Message-State: ANoB5pmb/5/77+iDoWHs6270a1pB/KQhY/klCvcFO/kXmBBMOkwJeFBp
        g/m+AzI+6RxzFa9JfvL9SiOdQF8DL81DtlWfAtt8tVYHsQg=
X-Google-Smtp-Source: AA0mqf78NarDLjGCJ3o9B9COQ2AxOr1tClM2YcLB3k9c9AaAVEVvykaYY4wj5Ka7O0wBnyEavY1b7Xd3PQzk05fQ0Q0=
X-Received: by 2002:a1f:6183:0:b0:3b7:9b38:7fb with SMTP id
 v125-20020a1f6183000000b003b79b3807fbmr5363519vkb.7.1668809624938; Fri, 18
 Nov 2022 14:13:44 -0800 (PST)
MIME-Version: 1.0
References: <20221118220423.4038455-1-mfaltesek@google.com> <20221118220423.4038455-2-mfaltesek@google.com>
In-Reply-To: <20221118220423.4038455-2-mfaltesek@google.com>
From:   Guenter Roeck <groeck@google.com>
Date:   Fri, 18 Nov 2022 14:13:34 -0800
Message-ID: <CABXOdTcKkjYRKfiaNH5TGeh1AiyddHLFZF+iJmCa8cC4w_d+Og@mail.gmail.com>
Subject: Re: [PATCH net 1/3] nfc: st-nci: fix incorrect validating logic in EVT_TRANSACTION
To:     Martin Faltesek <mfaltesek@google.com>
Cc:     kuba@kernel.org, netdev@vger.kernel.org, linux-nfc@lists.01.org,
        krzysztof.kozlowski@linaro.org, davem@davemloft.net,
        martin.faltesek@gmail.com, christophe.ricard@gmail.com,
        jordy@pwning.systems, krzk@kernel.org, sameo@linux.intel.com,
        theflamefire89@gmail.com, duoming@zju.edu.cn,
        Denis Efremov <denis.e.efremov@oracle.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Nov 18, 2022 at 2:04 PM Martin Faltesek <mfaltesek@google.com> wrote:
>
> The first validation check for EVT_TRANSACTION has two different checks
> tied together with logical AND. One is a check for minimum packet length,
> and the other is for a valid aid_tag. If either condition is true (fails),
> then an error should be triggered. The fix is to change && to ||.
>
> Reported-by: Denis Efremov <denis.e.efremov@oracle.com>
> Fixes: 5d1ceb7f5e56 ("NFC: st21nfcb: Add HCI transaction event support")
> Signed-off-by: Martin Faltesek <mfaltesek@google.com>

Reviewed-by: Guenter Roeck <groeck@google.com>

> ---
>  drivers/nfc/st-nci/se.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/nfc/st-nci/se.c b/drivers/nfc/st-nci/se.c
> index 7764b1a4c3cf..589e1dec78e7 100644
> --- a/drivers/nfc/st-nci/se.c
> +++ b/drivers/nfc/st-nci/se.c
> @@ -326,7 +326,7 @@ static int st_nci_hci_connectivity_event_received(struct nci_dev *ndev,
>                  * AID          81      5 to 16
>                  * PARAMETERS   82      0 to 255
>                  */
> -               if (skb->len < NFC_MIN_AID_LENGTH + 2 &&
> +               if (skb->len < NFC_MIN_AID_LENGTH + 2 ||
>                     skb->data[0] != NFC_EVT_TRANSACTION_AID_TAG)
>                         return -EPROTO;
>
> --
> 2.38.1.584.g0f3c55d4c2-goog
>
