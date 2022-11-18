Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0EA8D62FFE6
	for <lists+netdev@lfdr.de>; Fri, 18 Nov 2022 23:18:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229925AbiKRWSh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Nov 2022 17:18:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43384 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229470AbiKRWSg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Nov 2022 17:18:36 -0500
Received: from mail-vs1-xe2d.google.com (mail-vs1-xe2d.google.com [IPv6:2607:f8b0:4864:20::e2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9DF3063EC
        for <netdev@vger.kernel.org>; Fri, 18 Nov 2022 14:18:28 -0800 (PST)
Received: by mail-vs1-xe2d.google.com with SMTP id t14so6077677vsr.9
        for <netdev@vger.kernel.org>; Fri, 18 Nov 2022 14:18:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=By5zrlijyhtLHcM+udJ0WGQZdpmEQR1+SwOVn/GwGOQ=;
        b=etNbndGLjoY5L9yj4B6ulQBuoQdxkquLafpXYDBXI05PaZ/vWlkxKbrX599foLLveJ
         I+YM0rTKJNlC7fbyY3TZwcjk2vlSZconbNhF1XgQ2ab19OlWsUCQLLNu7bSXjKXg+xLQ
         khc88+sEnMfBvv38TEZSzXav8wtr0/MiKCx/AzVhaeiYZHQM4dhcrpip0LBw9zUmv1y2
         xgkc/bd5MULR1CG4UkbXT2Lbp7B4dw1xuNuNzRMqs+qNa1zi8B1RyB8rvFt0nBvcwtjh
         aRZplI6+gf91oqsGxoa1ei6q5BHgkq4+pSPJwn1xJemCH1QBU4EJ8fI+SDBSmBzNgw3k
         jmDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=By5zrlijyhtLHcM+udJ0WGQZdpmEQR1+SwOVn/GwGOQ=;
        b=aqSu7Ymx2lf+1A2m6B3YtyMWShp9wvhIH/d6utmZ/8Chl4jR2IztS0a1SO0/FvXlP3
         ZUeBk4WOw0zy+/xTIN47ZtJo/+oI3xAsgE7BVrC2W/yuFuzVfmoQRXOdIqtWKKOC9uBv
         3G0CRm0qhZlpXVkK0kA0WB1d1aHfRnOKIjnAMbG9w14MdRbnkYdqoNoFC9uR8BcouWtZ
         YDt+/q8Mvfr+jdUqfGkv1LppcfnsLXsyQMIAfsvhHjZviWpWZybYQeP+S0soURSIvC5N
         N87EnZwnYYUGEMS65Ze64f394jX2NUfuh8o6SzyHsGsOQzuZpPxNnWDdUEIB4LmHcAxx
         dfPQ==
X-Gm-Message-State: ANoB5pltjCgTs0alZvxjK5IRimADHlrFa/wGSBVeysALpOfCh1eZlL6v
        rAfCOAtrngWKkz3PaURd5q0xGpD0YI2m2k4OyOkeag==
X-Google-Smtp-Source: AA0mqf4xPJVSHTxr2grxrGPaDtnQctaTwK0K9qme45zOZA0Y4UFqxuBTz5D/jbEe9r7ka5rith2YpgYKZNCyyOC4Oj0=
X-Received: by 2002:a67:f74e:0:b0:3aa:3766:7a23 with SMTP id
 w14-20020a67f74e000000b003aa37667a23mr5638220vso.53.1668809907518; Fri, 18
 Nov 2022 14:18:27 -0800 (PST)
MIME-Version: 1.0
References: <20221118220423.4038455-1-mfaltesek@google.com> <20221118220423.4038455-4-mfaltesek@google.com>
In-Reply-To: <20221118220423.4038455-4-mfaltesek@google.com>
From:   Guenter Roeck <groeck@google.com>
Date:   Fri, 18 Nov 2022 14:18:16 -0800
Message-ID: <CABXOdTfJ0hfBaeQL2PSxJkWEocjqo5SJo-=YB2RSBHA-QCex_Q@mail.gmail.com>
Subject: Re: [PATCH net 3/3] nfc: st-nci: fix incorrect sizing calculations in EVT_TRANSACTION
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
> The transaction buffer is allocated by using the size of the packet buf,
> and subtracting two which seems intended to remove the two tags which are
> not present in the target structure. This calculation leads to under
> counting memory because of differences between the packet contents and the
> target structure. The aid_len field is a u8 in the packet, but a u32 in
> the structure, resulting in at least 3 bytes always being under counted.
> Further, the aid data is a variable length field in the packet, but fixed
> in the structure, so if this field is less than the max, the difference is
> added to the under counting.
>
> To fix, perform validation checks progressively to safely reach the
> next field, to determine the size of both buffers and verify both tags.
> Once all validation checks pass, allocate the buffer and copy the data.
> This eliminates freeing memory on the error path, as validation checks are
> moved ahead of memory allocation.
>
> Reported-by: Denis Efremov <denis.e.efremov@oracle.com>
> Fixes: 5d1ceb7f5e56 ("NFC: st21nfcb: Add HCI transaction event support")
> Signed-off-by: Martin Faltesek <mfaltesek@google.com>

Nit below, otherwise

Reviewed-by: Guenter Roeck <groeck@google.com>

> ---
>  drivers/nfc/st-nci/se.c | 47 ++++++++++++++++++++++++++++-------------
>  1 file changed, 32 insertions(+), 15 deletions(-)
>
> diff --git a/drivers/nfc/st-nci/se.c b/drivers/nfc/st-nci/se.c
> index fc59916ae5ae..0c24f4a5c92e 100644
> --- a/drivers/nfc/st-nci/se.c
> +++ b/drivers/nfc/st-nci/se.c
> @@ -312,6 +312,8 @@ static int st_nci_hci_connectivity_event_received(struct nci_dev *ndev,
>         int r = 0;
>         struct device *dev = &ndev->nfc_dev->dev;
>         struct nfc_evt_transaction *transaction;
> +       u32 aid_len;
> +       u8 params_len;
>
>         pr_debug("connectivity gate event: %x\n", event);
>
> @@ -325,28 +327,43 @@ static int st_nci_hci_connectivity_event_received(struct nci_dev *ndev,
>                  * Description  Tag     Length
>                  * AID          81      5 to 16
>                  * PARAMETERS   82      0 to 255
> +                *
> +                * The key differences are aid storage length is variably sized
> +                * in the packet, but fixed in nfc_evt_transaction, and that the aid_len
> +                * is u8 in the packet, but u32 in the structure, and the tags in
> +                * the packet are not included in nfc_evt_transaction.
> +                *
> +                * size in bytes: 1          1       5-16 1             1           0-255
> +                * offset:        0          1       2    aid_len + 2   aid_len + 3 aid_len + 4
> +                * member name:   aid_tag(M) aid_len aid  params_tag(M) params_len  params
> +                * example:       0x81       5-16    X    0x82          0-255       X
>                  */
> -               if (skb->len < NFC_MIN_AID_LENGTH + 2 ||
> -                   skb->data[0] != NFC_EVT_TRANSACTION_AID_TAG)
> +               if (skb->len < 2 || skb->data[0] != NFC_EVT_TRANSACTION_AID_TAG)
>                         return -EPROTO;
>
> -               transaction = devm_kzalloc(dev, skb->len - 2, GFP_KERNEL);
> -               if (!transaction)
> -                       return -ENOMEM;
> +               aid_len = skb->data[1];
>
> -               transaction->aid_len = skb->data[1];
> -               memcpy(transaction->aid, &skb->data[2], transaction->aid_len);
> +               if (skb->len < aid_len + 4 || aid_len > sizeof(transaction->aid))
> +                       return -EPROTO;
>
> -               /* Check next byte is PARAMETERS tag (82) */
> -               if (skb->data[transaction->aid_len + 2] !=
> -                   NFC_EVT_TRANSACTION_PARAMS_TAG) {
> -                       devm_kfree(dev, transaction);
> +               params_len = skb->data[aid_len + 3];
> +
> +               /* Verify PARAMETERS tag is (82), and final check that there is enough
> +                * space in the packet to read everything.
> +                */
> +               if (skb->data[aid_len + 2] != NFC_EVT_TRANSACTION_PARAMS_TAG ||
> +                   (skb->len < aid_len + 4 + params_len))

Unnecessary () after ||

>                         return -EPROTO;
> -               }
>
> -               transaction->params_len = skb->data[transaction->aid_len + 3];
> -               memcpy(transaction->params, skb->data +
> -                      transaction->aid_len + 4, transaction->params_len);
> +               transaction = devm_kzalloc(dev, sizeof(*transaction) + params_len, GFP_KERNEL);
> +               if (!transaction)
> +                       return -ENOMEM;
> +
> +               transaction->aid_len = aid_len;
> +               transaction->params_len = params_len;
> +
> +               memcpy(transaction->aid, &skb->data[2], aid_len);
> +               memcpy(transaction->params, &skb->data[aid_len + 4], params_len);
>
>                 r = nfc_se_transaction(ndev->nfc_dev, host, transaction);
>                 break;
> --
> 2.38.1.584.g0f3c55d4c2-goog
>
