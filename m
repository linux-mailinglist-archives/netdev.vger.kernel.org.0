Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3FC1C57D6CA
	for <lists+netdev@lfdr.de>; Fri, 22 Jul 2022 00:21:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233774AbiGUWVA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Jul 2022 18:21:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32940 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229739AbiGUWU7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Jul 2022 18:20:59 -0400
Received: from mail-lf1-x129.google.com (mail-lf1-x129.google.com [IPv6:2a00:1450:4864:20::129])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 115AB3ED5F;
        Thu, 21 Jul 2022 15:20:54 -0700 (PDT)
Received: by mail-lf1-x129.google.com with SMTP id z25so4983290lfr.2;
        Thu, 21 Jul 2022 15:20:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=AtN6gulMYbqP3+fY69GMk0mlu2+ICdpG/rlaOpmP9kg=;
        b=L5j/czwAEe3eDIA00+fewJmRQqUi6MnwCDxFzWEaC+QbXoztR8DcSEon29xAR4IGDU
         nzJFDsqUmN5waOhCK7EVmzf7vdcrPD2l5NscYpKgJrO2u9rTQv33GlVUoYqzzXCUWdUo
         maaGtnP44iNKHHrIRHZYJqTjBhDA7SqKtYualzXSACnGDNWanaKwSQ0zi1VCv69TrJRf
         Be0rQCCTILUdR668oLSCQJz0BnZhxVg87GI/zz22VPTDevRUYCb560zXcbTgolJfOMJK
         rXuZZZluOYD5fvDjSTIYHssGC1kn73Pt+sgXKJcfhwjnwDs5wsYf7LVYZ6sASVnHbYuL
         ZQuA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=AtN6gulMYbqP3+fY69GMk0mlu2+ICdpG/rlaOpmP9kg=;
        b=wAdVDhOu7kaTdgdhrjcxTsOeUOF/65uvjQBHMJr58H7XzsOoZZPtnCLTXJ23q+jGJ9
         DMoOV5HNzb+rSZq69fJishkVnUtIkdkTU5seb28DyeyS76n+L6XDA48uRVKdGSt8Wy6B
         3NkkQL6nB24bq9ZyfxiyaXubkF+u5ywKyY1ABJcxgLB7tzKUQEsfmLS7j0COku8UBJcT
         dUSnr8I0aqEL2kphs3ZlsbE8PPQdztrSn/ZRP6adI+5xti1ndoj9lFqFgaA1zms6oSmu
         8A1AUavsyxa69yokg/eGxJBhormOVDunVU5GcFVbk6GGn1wGqHuyWMgKpXXFX45sUxaA
         t/1A==
X-Gm-Message-State: AJIora/d4gr91xz9btPkiHsJLR1yBF/xiMDz3zlYQB9X7fawSjk7YoaM
        oEztfJSTTp3MX/ei4bRq2++r9Dj4iFfk2DHdR/4=
X-Google-Smtp-Source: AGRyM1siTfwUv7VyD52f6LlsVhZy5imr5rWtaDhp8fctaWwi3MpZqylx5kD7vZbamU067PD55xLB1OC9VK65wMdXkQM=
X-Received: by 2002:a05:6512:1513:b0:48a:468c:e2aa with SMTP id
 bq19-20020a056512151300b0048a468ce2aamr178726lfb.106.1658442052249; Thu, 21
 Jul 2022 15:20:52 -0700 (PDT)
MIME-Version: 1.0
References: <20220720233601.3648471-1-jiangzp@google.com> <20220720163548.kernel.v1.1.I4058a198aa4979ee74a219fe6e315fad1184d78d@changeid>
In-Reply-To: <20220720163548.kernel.v1.1.I4058a198aa4979ee74a219fe6e315fad1184d78d@changeid>
From:   Luiz Augusto von Dentz <luiz.dentz@gmail.com>
Date:   Thu, 21 Jul 2022 15:20:40 -0700
Message-ID: <CABBYNZ+ao6r4ZHaVNGRe-Wp6077R2xmkYufOK7tN=B8rEJL1yg@mail.gmail.com>
Subject: Re: [kernel PATCH v1 1/1] Bluetooth: Fix get clock info
To:     Zhengping Jiang <jiangzp@google.com>
Cc:     "linux-bluetooth@vger.kernel.org" <linux-bluetooth@vger.kernel.org>,
        Marcel Holtmann <marcel@holtmann.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "open list:NETWORKING [GENERAL]" <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Zhengping,

On Wed, Jul 20, 2022 at 4:36 PM Zhengping Jiang <jiangzp@google.com> wrote:
>
> If connection exists, set the connection data before calling
> get_clock_info_sync, so it can be verified the connection is still
> connected, before retrieving clock info.
>
> Signed-off-by: Zhengping Jiang <jiangzp@google.com>
> ---
>
> Changes in v1:
> - Fix input connection data
>
>  net/bluetooth/mgmt.c | 13 +++++++------
>  1 file changed, 7 insertions(+), 6 deletions(-)
>
> diff --git a/net/bluetooth/mgmt.c b/net/bluetooth/mgmt.c
> index ef8371975c4eb..947d700574c54 100644
> --- a/net/bluetooth/mgmt.c
> +++ b/net/bluetooth/mgmt.c
> @@ -6971,11 +6971,16 @@ static int get_clock_info(struct sock *sk, struct hci_dev *hdev, void *data,
>         }
>
>         cmd = mgmt_pending_new(sk, MGMT_OP_GET_CLOCK_INFO, hdev, data, len);
> -       if (!cmd)
> +       if (!cmd) {
>                 err = -ENOMEM;
> -       else
> +       } else {
> +               if (conn) {
> +                       hci_conn_hold(conn);
> +                       cmd->user_data = hci_conn_get(conn);
> +               }
>                 err = hci_cmd_sync_queue(hdev, get_clock_info_sync, cmd,
>                                          get_clock_info_complete);
> +       }

Having seconds though if this is actually the right thing to do,
hci_cmd_sync_queue will queue the command so get_clock_info_sync
shouldn't execute immediately if that happens that actually would be
quite a problem since we are holding the hci_dev_lock so if the
callback executes and blocks waiting a command that would likely cause
a deadlock because no command can be completed while hci_dev_lock is
being held, in fact I don't really like the idea of holding hci_conn
reference either since we are doing a lookup by address on
get_clock_info_sync Id probably just remove this code as it seem
unnecessary.

Btw, there are tests for this command in mgmt-tester so if this is
actually attempting to fix a problem Id like to have a test to
reproduce it.

>         if (err < 0) {
>                 err = mgmt_cmd_complete(sk, hdev->id, MGMT_OP_GET_CLOCK_INFO,
> @@ -6984,12 +6989,8 @@ static int get_clock_info(struct sock *sk, struct hci_dev *hdev, void *data,
>                 if (cmd)
>                         mgmt_pending_free(cmd);
>
> -       } else if (conn) {
> -               hci_conn_hold(conn);
> -               cmd->user_data = hci_conn_get(conn);
>         }
>
> -
>  unlock:
>         hci_dev_unlock(hdev);
>         return err;
> --
> 2.37.0.170.g444d1eabd0-goog
>


-- 
Luiz Augusto von Dentz
