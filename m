Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 66B5E4EB30D
	for <lists+netdev@lfdr.de>; Tue, 29 Mar 2022 20:05:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240399AbiC2SGy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Mar 2022 14:06:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38720 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240348AbiC2SGx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Mar 2022 14:06:53 -0400
Received: from mail-ej1-x62c.google.com (mail-ej1-x62c.google.com [IPv6:2a00:1450:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C1DCA36164
        for <netdev@vger.kernel.org>; Tue, 29 Mar 2022 11:05:09 -0700 (PDT)
Received: by mail-ej1-x62c.google.com with SMTP id j15so36710807eje.9
        for <netdev@vger.kernel.org>; Tue, 29 Mar 2022 11:05:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=79K59R70/GKL72cko2cFy9cH4ry9GTfRtjFHDFLmu70=;
        b=nSKY1fPZkUOsnDVUkmTXhti0brCLk3DyTDOphD/E5PTQYfsIUWLvLhzDThTXinhbQQ
         T6uWbPEHesrtfn+fFeDRIQlB/hoS+X3uMybrCvGowhsxBMe/vEBd1ptcS/gxZRT3lNjd
         qPiNXpD7NcccerUokoeBv12RpO74l9temrPtFSCCx6t8Lc8rinLOz9Le29GGpZME4/44
         cuveAokSmgtbxSAI4XXgOjVlGXfrF+25tKxnsMbsQyugptWDiGrifF26EJyOdfAjq78T
         reThxoJWTTAQqT+ibfyXet9cHTSeDzSb5R8yJyECQh3VRHKOgLWXjmS5vwiDsn5tt1uG
         JwpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=79K59R70/GKL72cko2cFy9cH4ry9GTfRtjFHDFLmu70=;
        b=NSM0LAycq1/Io5iimCzFTKX18nDPEd11JNk57t4qhzlo+y0lxPJuxhcNcS1F4YHXE9
         fAIMKB3D1Po/oiWkeban9oKOIVZm1GBSrgI2KxqplijWLu1tVU30Ddhs/eelo/VKbZia
         Lahe3fOBTG4lQaExAXlxIkAmPai8xo/32Gs3FKoGVV3TOGsmos8wo1NVp/mnmLY1cY9l
         gjPr/5hYNtWNusb0Izg0QvC8wUcSXqtkgHT5ZmkibEX1T3s7iZmvvvVR9dDY9+tEhqJP
         PpWOci1q/5kiXaB/G/88KySR1JrxeTHWTwabztxzDi6BY7E0Wdn2Viy2BG7qk+pLrGrV
         F1ZA==
X-Gm-Message-State: AOAM532rCGG6IvgaWOM36iPcsu84e6uaUsZ0YHU8Vdh5ffpmZRtkjoMW
        QgfGfDmBEARGapKXn0iJTrTFoY0I35pNpe7e+jed8iCrfpiFGQ==
X-Google-Smtp-Source: ABdhPJyw4CaSruE4yFsKPlQoxP/hu+YSWDquwlDk30FrdhFIVlqDcmIIZzFsHbhYqdMyGnleyEc8BeRuE4NFMkCzMGQ=
X-Received: by 2002:a17:906:d554:b0:6df:a6f8:799a with SMTP id
 cr20-20020a170906d55400b006dfa6f8799amr35820341ejc.492.1648577108023; Tue, 29
 Mar 2022 11:05:08 -0700 (PDT)
MIME-Version: 1.0
References: <20220329175431.3175472-1-mfaltesek@google.com>
In-Reply-To: <20220329175431.3175472-1-mfaltesek@google.com>
From:   Guenter Roeck <groeck@google.com>
Date:   Tue, 29 Mar 2022 11:04:56 -0700
Message-ID: <CABXOdTcTzS-qcYX3kXQWdu=C051PVs+S9deioHymz2WjmpAiGg@mail.gmail.com>
Subject: Re: [PATCH] nfc: st21nfca: Refactor EVT_TRANSACTION
To:     Martin Faltesek <mfaltesek@chromium.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        christophe.ricard@gmail.com, jordy@pwning.systems,
        sameo@linux.intel.com, William K Lin <wklin@google.com>,
        Suren Baghdasaryan <surenb@google.com>,
        Martin Faltesek <mfaltesek@google.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 29, 2022 at 10:54 AM Martin Faltesek <mfaltesek@chromium.org> wrote:
>
> EVT_TRANSACTION has four different bugs:
>
> 1. First conditional has logical AND but should be OR. It should
>    always check if it isn't NFC_EVT_TRANSACTION_AID_TAG, then
>    bail.
>
> 2. Potential under allocating memory:devm_kzalloc (skb->len - 2)
>    when the aid_len specified in the packet is less than the fixed
>    NFC_MAX_AID_LENGTH in struct nfc_evt_transaction. In addition,
>    aid_len is u32 in the data structure, and u8 in the packet,
>    under counting 3 more bytes.
>
> 3. Memory leaks after kzalloc when returning error.
>
> 4. The final conditional check is also incorrect, for the same reasons
>    explained in #2.
>
> Fixes: 26fc6c7f02cb ("NFC: st21nfca: Add HCI transaction event support")
> Fixes: 4fbcc1a4cb20 ("nfc: st21nfca: Fix potential buffer overflows in EVT_TRANSACTION")
> Signed-off-by: Martin Faltesek <mfaltesek@google.com>

You'll probably be asked to use networking-style multi-line comments.
Other than that, LGTM.

Reviewed-by: Guenter Roeck <groeck@google.com>

Guenter

> ---
>  drivers/nfc/st21nfca/se.c | 65 ++++++++++++++++++++++++++-------------
>  1 file changed, 43 insertions(+), 22 deletions(-)
>
> diff --git a/drivers/nfc/st21nfca/se.c b/drivers/nfc/st21nfca/se.c
> index c922f10d0d7b..acc8d831246a 100644
> --- a/drivers/nfc/st21nfca/se.c
> +++ b/drivers/nfc/st21nfca/se.c
> @@ -292,6 +292,8 @@ int st21nfca_connectivity_event_received(struct nfc_hci_dev *hdev, u8 host,
>         int r = 0;
>         struct device *dev = &hdev->ndev->dev;
>         struct nfc_evt_transaction *transaction;
> +       u32 aid_len;
> +       u8 params_len;
>
>         pr_debug("connectivity gate event: %x\n", event);
>
> @@ -306,37 +308,56 @@ int st21nfca_connectivity_event_received(struct nfc_hci_dev *hdev, u8 host,
>                  * Description  Tag     Length
>                  * AID          81      5 to 16
>                  * PARAMETERS   82      0 to 255
> +                *
> +                * The key differences are aid storage length is variably sized
> +                * in the packet, but fixed in nfc_evt_transaction, and that the aid_len
> +                * is u8 in the packet, but u32 in the structure, and the tags in
> +                * the packet are not part of nfc_evt_transaction.
> +                *
> +                * size in bytes: 1          1       5-16  1             1            0-255
> +                * offset:                   1       2     aid_len + 2   aid_len + 3  aid_len + 4
> +                * member name  : aid_tag(M) aid_len aid   params_tag(M) params_len   params
> +                * example      :  0x81      5-16     X    0x82          0-255        X
>                  */
> -               if (skb->len < NFC_MIN_AID_LENGTH + 2 &&
> -                   skb->data[0] != NFC_EVT_TRANSACTION_AID_TAG)
> -                       return -EPROTO;
> -
> -               transaction = devm_kzalloc(dev, skb->len - 2, GFP_KERNEL);
> -               if (!transaction)
> -                       return -ENOMEM;
>
> -               transaction->aid_len = skb->data[1];
> +               /*
> +                * Validate the packet is large enough to read the first two bytes
> +                * containing the aid_tag and aid_len, and then read both. Capacity
> +                * checks are expanded incrementally after this, for clarity.
> +                */
> +               if (skb->len < 2 || skb->data[0] != NFC_EVT_TRANSACTION_AID_TAG)
> +                       return -EPROTO;
>
> -               /* Checking if the length of the AID is valid */
> -               if (transaction->aid_len > sizeof(transaction->aid))
> -                       return -EINVAL;
> +               aid_len = skb->data[1];
> +               /*
> +                * With the actual aid_len, verify there is enough space in
> +                * the packet to read params_tag and params_len, and that
> +                * aid_len does not exceed destination capacity. Reference
> +                * offset comment above for +4 +3 +2 offsets used.
> +                */
> +               if (skb->len < aid_len + 4 || aid_len > sizeof(transaction->aid))
> +                       return -EPROTO;
>
> -               memcpy(transaction->aid, &skb->data[2],
> -                      transaction->aid_len);
> +               params_len = skb->data[aid_len + 3];
>
> -               /* Check next byte is PARAMETERS tag (82) */
> -               if (skb->data[transaction->aid_len + 2] !=
> -                   NFC_EVT_TRANSACTION_PARAMS_TAG)
> +               /*
> +                * Verify PARAMETERS tag is (82), and final validation that enough
> +                * space in packet to read everything.
> +                */
> +               if ((skb->data[aid_len + 2] != NFC_EVT_TRANSACTION_PARAMS_TAG) ||
> +                   (skb->len < aid_len + 4 + params_len))
>                         return -EPROTO;
>
> -               transaction->params_len = skb->data[transaction->aid_len + 3];
> +               transaction = devm_kzalloc(dev, sizeof(struct nfc_evt_transaction) +
> +                       params_len, GFP_KERNEL);
> +               if (!transaction)
> +                       return -ENOMEM;
>
> -               /* Total size is allocated (skb->len - 2) minus fixed array members */
> -               if (transaction->params_len > ((skb->len - 2) - sizeof(struct nfc_evt_transaction)))
> -                       return -EINVAL;
> +               transaction->aid_len = aid_len;
> +               transaction->params_len = params_len;
>
> -               memcpy(transaction->params, skb->data +
> -                      transaction->aid_len + 4, transaction->params_len);
> +               memcpy(transaction->aid, &skb->data[2], aid_len);
> +               memcpy(transaction->params, &skb->data[aid_len + 4], params_len);
>
>                 r = nfc_se_transaction(hdev->ndev, host, transaction);
>         break;
> --
> 2.35.1.1021.g381101b075-goog
>
