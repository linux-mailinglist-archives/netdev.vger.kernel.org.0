Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0B57553AF79
	for <lists+netdev@lfdr.de>; Thu,  2 Jun 2022 00:50:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231833AbiFAVpW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Jun 2022 17:45:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57852 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231779AbiFAVpV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Jun 2022 17:45:21 -0400
Received: from mail-pl1-x62b.google.com (mail-pl1-x62b.google.com [IPv6:2607:f8b0:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C2E067A455;
        Wed,  1 Jun 2022 14:45:20 -0700 (PDT)
Received: by mail-pl1-x62b.google.com with SMTP id s14so2914058plk.8;
        Wed, 01 Jun 2022 14:45:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=fZXF7GPcAcaOPScOAplIm+VORKBsYKZ17YpBBud/XGc=;
        b=cglP+0SLTIabqtnre/RPxQwVASYfan1tRkC3a/xHKvzzcQ4zJkgkk/DO+wTxzyHp2w
         sS8j3NL7AinwOMUiJylKl1FX+vx1p6YiNM8/2Z1XMI2ceczdnhrQX07a+yMJ11N3mCb4
         byUjIzK6oRruE52OOjVpRmgqQtM8d45cBEj6hBXRJuHMKyGi+c6dHd8F4lXmBOumWkMc
         vaGXS1rowJTmumxKI0Ev9ngKWPSDrHqkAr5TrM8INGMzFYhd511sUTyzpXnDhLQkA9fS
         uJ7U1cewiMaSc2YTtgG6VKDAxX8oRa2M1iOIKMIEeFB4QZeBqFaDYWqrXoSV12cFhiTe
         GX8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=fZXF7GPcAcaOPScOAplIm+VORKBsYKZ17YpBBud/XGc=;
        b=KSMMtDWu89gBdPOO/OHHM44Q7XFj7HRXig/k9P4eYME80U8AWz3ihaKUYd0ktoZIyS
         V3zQT8tzb2D/zL2Yp69qz+R0RdIvjnbukXj528yCexVeB/rlAHE+jcejJsk0k/dt4EUV
         Ogb9lLPVZycsKpptwhPwFcraBFQXBDDnVElkE7iU6Z7a5FX6DrtMrq64QWjIbzyFu8sD
         3kXzOr22sUhHvjob4gzozk9x29/8EdLpQ1TPhI58Wdk2V883gaeUui+WImebLhm0jPwf
         yb3ITIgGT468RW82vWXr7ZwgZQM1WBV0xo1Okvp4Y91OeBu9VUpm2M2pcc+hOBFW4JCL
         xBlg==
X-Gm-Message-State: AOAM532lyrc+LzyRbAex6/tulxnXAeJIMUa8N0lmjVksrHmnPLqjBqeP
        kJwcREWRWkFgcOxtmu0gs7WZzJnmmY8h9eBJmhw=
X-Google-Smtp-Source: ABdhPJySKb591WiK5yBnvRM3WULITW2hegH76WE1JdVYYBbOG6RaJ5hNdMH8s4JKilAocELskGoumioo5HP+Dx/UkHk=
X-Received: by 2002:a17:903:244f:b0:162:4daf:f8bb with SMTP id
 l15-20020a170903244f00b001624daff8bbmr1525626pls.20.1654119919850; Wed, 01
 Jun 2022 14:45:19 -0700 (PDT)
MIME-Version: 1.0
References: <20220601151115.1.Ia503b15be0f366563b4e7c9f93cbec5e756bb0ae@changeid>
In-Reply-To: <20220601151115.1.Ia503b15be0f366563b4e7c9f93cbec5e756bb0ae@changeid>
From:   Luiz Augusto von Dentz <luiz.dentz@gmail.com>
Date:   Wed, 1 Jun 2022 14:45:08 -0700
Message-ID: <CABBYNZK8=RCC0bS3KVyn8y93nW_rSR0DDb=Yyp6CgFLaJGz5bA@mail.gmail.com>
Subject: Re: [PATCH] Bluetooth: clear the temporary linkkey in hci_conn_cleanup
To:     Alain Michaud <alainmichaud@google.com>
Cc:     "linux-bluetooth@vger.kernel.org" <linux-bluetooth@vger.kernel.org>,
        ChromeOS Bluetooth Upstreaming 
        <chromeos-bluetooth-upstreaming@chromium.org>,
        Alain Michaud <alainm@chromium.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        Marcel Holtmann <marcel@holtmann.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "open list:NETWORKING [GENERAL]" <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Alain,

On Wed, Jun 1, 2022 at 8:12 AM Alain Michaud <alainmichaud@google.com> wrote:
>
> From: Alain Michaud <alainm@chromium.org>
>
> If a hardware error occurs and the connections are flushed without a
> disconnection_complete event being signaled, the temporary linkkeys are
> not flushed.
>
> This change ensures that any outstanding flushable linkkeys are flushed
> when the connection are flushed from the hash table.
>
> Signed-off-by: Alain Michaud <alainm@chromium.org>
>
> ---
>
>  net/bluetooth/hci_conn.c  | 3 +++
>  net/bluetooth/hci_event.c | 4 +++-
>  2 files changed, 6 insertions(+), 1 deletion(-)
>
> diff --git a/net/bluetooth/hci_conn.c b/net/bluetooth/hci_conn.c
> index 352d7d612128..85dc1af90fcb 100644
> --- a/net/bluetooth/hci_conn.c
> +++ b/net/bluetooth/hci_conn.c
> @@ -118,6 +118,9 @@ static void hci_conn_cleanup(struct hci_conn *conn)
>         if (test_bit(HCI_CONN_PARAM_REMOVAL_PEND, &conn->flags))
>                 hci_conn_params_del(conn->hdev, &conn->dst, conn->dst_type);
>
> +       if (test_bit(HCI_CONN_FLUSH_KEY, &conn->flags))
> +               hci_remove_link_key(hdev, &conn->dst);
> +
>         hci_chan_list_flush(conn);
>
>         hci_conn_hash_del(hdev, conn);
> diff --git a/net/bluetooth/hci_event.c b/net/bluetooth/hci_event.c
> index 6b83f9b0082c..09f4ff71e747 100644
> --- a/net/bluetooth/hci_event.c
> +++ b/net/bluetooth/hci_event.c
> @@ -3372,8 +3372,10 @@ static void hci_disconn_complete_evt(struct hci_dev *hdev, void *data,
>                                 reason, mgmt_connected);
>
>         if (conn->type == ACL_LINK) {
> -               if (test_bit(HCI_CONN_FLUSH_KEY, &conn->flags))
> +               if (test_bit(HCI_CONN_FLUSH_KEY, &conn->flags)) {
>                         hci_remove_link_key(hdev, &conn->dst);
> +                       clear_bit(HCI_CONN_FLUSH_KEY, &conn->flags);
> +               }

Could we use test_and_clean_bit instead? In theory there could be
other threads trying to clean up so I guess it would be safer to
reduce the risk of having concurrency problems although hci_dev_lock
would prevent that, better to be safe than sorry.

>                 hci_req_update_scan(hdev);
>         }
> --
> 2.36.1.255.ge46751e96f-goog
>


-- 
Luiz Augusto von Dentz
