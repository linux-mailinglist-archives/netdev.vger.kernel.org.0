Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 203F4540223
	for <lists+netdev@lfdr.de>; Tue,  7 Jun 2022 17:09:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244960AbiFGPJn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Jun 2022 11:09:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57372 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233904AbiFGPJm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Jun 2022 11:09:42 -0400
Received: from mail-ej1-x62a.google.com (mail-ej1-x62a.google.com [IPv6:2a00:1450:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3BE2EBCE85
        for <netdev@vger.kernel.org>; Tue,  7 Jun 2022 08:09:41 -0700 (PDT)
Received: by mail-ej1-x62a.google.com with SMTP id o7so2533318eja.1
        for <netdev@vger.kernel.org>; Tue, 07 Jun 2022 08:09:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=wWh4qt2Tou6AuW2Lo8VafMuYjv5z/qFbleS7hC0bCQc=;
        b=PxPk6sAPYV/f1XEe24CgwGcCoqTphYw00e7W/1tzX5oPCfrBFHfDjPmLcO60S8+TRc
         N/k71OSr7O/zpuLSP7VHyfMHqhnaZxDz25VsO5CUPCx5PkFXyCL2jTA+eCZB59FU49hz
         v74We946ODsklSH+CgMF9NRCDguaJTdHXr0TdTCSWcWUqQq0p4H0+WI3h/QC8Flx+LRA
         J/W4rwUzSps2GuzmJMkdXWaG7UjNTczKQKK/TPjPLu0c4C9u+yMCudH80b7byam9wkS1
         t5agLdC49e9+SgWLl25KmN2HRCMHwGpS5kzD1uwkZ/7dzr8zL1pMb5QKFIzFUfeQla7A
         YShA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=wWh4qt2Tou6AuW2Lo8VafMuYjv5z/qFbleS7hC0bCQc=;
        b=pLH1mR7gZ+KtEF066KqTOCEaV3fECiuVvRrJsTWWilKixyBiv3lmmicNCYroB0lQuo
         GEWT1x6dqBEPrOTpFlBoYyiYyuwv+GqSbBh4MTzMrVDol2ujQWhQClNQRhcdpfrvkqfe
         jDFdeas2CGEH34bGFm0mFGhZzINgvteOISKTeVyQz73g3pyNoW3e0wy4KPNPPV+Iyg7N
         RA0x8hiQwPUiiy6ygf83EH6mle5GknIT8Rj7I6+axPfeh+d7H20JJoj7u63cfdWFzJci
         Ah4TuZn4Xiw/iBunBop2lU9UGe5Q38x65zlr1puxBFz+8OYVKhafYe0WxLDGFj0q0vud
         AZzQ==
X-Gm-Message-State: AOAM53285XfoGjgasu0ca/zt5ctx2bhLQQFH/z1PsarJR5nAchC9ZKPj
        hpggDkl7kynMtLoknYuI/43zCpUr0KNs7kJMbEQshg==
X-Google-Smtp-Source: ABdhPJyJBZaCJ49kEXRW4ZROuflIkxzehJrYShZNW4TLvepnxZFoxezapSzDryQXv0lAFsxSRBo+8nZmgpxZTDm/Nn4=
X-Received: by 2002:a17:907:8689:b0:6fe:e525:ea9c with SMTP id
 qa9-20020a170907868900b006fee525ea9cmr27389504ejc.720.1654614579475; Tue, 07
 Jun 2022 08:09:39 -0700 (PDT)
MIME-Version: 1.0
References: <20220607025729.1673212-1-mfaltesek@google.com> <20220607025729.1673212-4-mfaltesek@google.com>
In-Reply-To: <20220607025729.1673212-4-mfaltesek@google.com>
From:   Guenter Roeck <groeck@google.com>
Date:   Tue, 7 Jun 2022 08:09:28 -0700
Message-ID: <CABXOdTcZWtoGzqqRWN4MWXh2se=rB=xtuMbSNe598-R0Mt=peg@mail.gmail.com>
Subject: Re: [PATCH net v3 3/3] nfc: st21nfca: fix incorrect sizing
 calculations in EVT_TRANSACTION
To:     Martin Faltesek <mfaltesek@google.com>
Cc:     Jakub Kicinski <kuba@kernel.org>, krzysztof.kozlowski@linaro.org,
        christophe.ricard@gmail.com,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        jordy@pwning.systems, Krzysztof Kozlowski <krzk@kernel.org>,
        martin.faltesek@gmail.com, netdev <netdev@vger.kernel.org>,
        linux-nfc@lists.01.org, sameo@linux.intel.com,
        William K Lin <wklin@google.com>, theflamefire89@gmail.com,
        "# v4 . 10+" <stable@vger.kernel.org>
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

On Mon, Jun 6, 2022 at 7:57 PM Martin Faltesek <mfaltesek@google.com> wrote:
>
> The transaction buffer is allocated by using the size of the packet buf,
> and subtracting two which seem intended to remove the two tags which are
> not present in the target structure. This calculation leads to under
> counting memory because of differences between the packet contents and the
> target structure. The aid_len field is a u8 in the packet, but a u32 in
> the structure, resulting in at least 3 bytes always being under counted.
> Further, the aid data is a variable length field in the packet, but fixed
> in the structure, so if this field is less than the max, the difference is
> added to the under counting.
>
> The last validation check for transaction->params_len is also incorrect
> since it employs the same accounting error.
>
> To fix, perform validation checks progressively to safely reach the
> next field, to determine the size of both buffers and verify both tags.
> Once all validation checks pass, allocate the buffer and copy the data.
> This eliminates freeing memory on the error path, as those checks are
> moved ahead of memory allocation.
>
> Fixes: 26fc6c7f02cb ("NFC: st21nfca: Add HCI transaction event support")
> Fixes: 4fbcc1a4cb20 ("nfc: st21nfca: Fix potential buffer overflows in EVT_TRANSACTION")
> Cc: stable@vger.kernel.org
> Signed-off-by: Martin Faltesek <mfaltesek@google.com>

Reviewed-by: Guenter Roeck <groeck@chromium.org>

> ---
>  drivers/nfc/st21nfca/se.c | 60 +++++++++++++++++++--------------------
>  1 file changed, 30 insertions(+), 30 deletions(-)
>
> diff --git a/drivers/nfc/st21nfca/se.c b/drivers/nfc/st21nfca/se.c
> index 8e1113ce139b..df8d27cf2956 100644
> --- a/drivers/nfc/st21nfca/se.c
> +++ b/drivers/nfc/st21nfca/se.c
> @@ -300,6 +300,8 @@ int st21nfca_connectivity_event_received(struct nfc_hci_dev *hdev, u8 host,
>         int r = 0;
>         struct device *dev = &hdev->ndev->dev;
>         struct nfc_evt_transaction *transaction;
> +       u32 aid_len;
> +       u8 params_len;
>
>         pr_debug("connectivity gate event: %x\n", event);
>
> @@ -308,50 +310,48 @@ int st21nfca_connectivity_event_received(struct nfc_hci_dev *hdev, u8 host,
>                 r = nfc_se_connectivity(hdev->ndev, host);
>         break;
>         case ST21NFCA_EVT_TRANSACTION:
> -               /*
> -                * According to specification etsi 102 622
> +               /* According to specification etsi 102 622
>                  * 11.2.2.4 EVT_TRANSACTION Table 52
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
> +                * example:       0x81       5-16    X    0x82 0-255    X
>                  */
> -               if (skb->len < NFC_MIN_AID_LENGTH + 2 ||
> -                   skb->data[0] != NFC_EVT_TRANSACTION_AID_TAG)
> +               if (skb->len < 2 || skb->data[0] != NFC_EVT_TRANSACTION_AID_TAG)
>                         return -EPROTO;
>
> -               transaction = devm_kzalloc(dev, skb->len - 2, GFP_KERNEL);
> -               if (!transaction)
> -                       return -ENOMEM;
> -
> -               transaction->aid_len = skb->data[1];
> +               aid_len = skb->data[1];
>
> -               /* Checking if the length of the AID is valid */
> -               if (transaction->aid_len > sizeof(transaction->aid)) {
> -                       devm_kfree(dev, transaction);
> -                       return -EINVAL;
> -               }
> +               if (skb->len < aid_len + 4 || aid_len > sizeof(transaction->aid))
> +                       return -EPROTO;
>
> -               memcpy(transaction->aid, &skb->data[2],
> -                      transaction->aid_len);
> +               params_len = skb->data[aid_len + 3];
>
> -               /* Check next byte is PARAMETERS tag (82) */
> -               if (skb->data[transaction->aid_len + 2] !=
> -                   NFC_EVT_TRANSACTION_PARAMS_TAG) {
> -                       devm_kfree(dev, transaction);
> +               /* Verify PARAMETERS tag is (82), and final check that there is enough
> +                * space in the packet to read everything.
> +                */
> +               if ((skb->data[aid_len + 2] != NFC_EVT_TRANSACTION_PARAMS_TAG) ||
> +                   (skb->len < aid_len + 4 + params_len))
>                         return -EPROTO;
> -               }
>
> -               transaction->params_len = skb->data[transaction->aid_len + 3];
> +               transaction = devm_kzalloc(dev, sizeof(*transaction) + params_len, GFP_KERNEL);
> +               if (!transaction)
> +                       return -ENOMEM;
>
> -               /* Total size is allocated (skb->len - 2) minus fixed array members */
> -               if (transaction->params_len > ((skb->len - 2) -
> -                   sizeof(struct nfc_evt_transaction))) {
> -                       devm_kfree(dev, transaction);
> -                       return -EINVAL;
> -               }
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
> 2.36.1.255.ge46751e96f-goog
>
