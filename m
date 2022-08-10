Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0653D58F35D
	for <lists+netdev@lfdr.de>; Wed, 10 Aug 2022 21:58:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233260AbiHJT6x (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Aug 2022 15:58:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53512 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232343AbiHJT6u (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Aug 2022 15:58:50 -0400
Received: from mail-ed1-x533.google.com (mail-ed1-x533.google.com [IPv6:2a00:1450:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A59B84EF5;
        Wed, 10 Aug 2022 12:58:49 -0700 (PDT)
Received: by mail-ed1-x533.google.com with SMTP id x21so20472523edd.3;
        Wed, 10 Aug 2022 12:58:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc;
        bh=nDY+MzOA939XxE3jhJSlYqnecUbFSkw44Nyv5TZ/3Nw=;
        b=RHpKXefMdCvcSaxJs90WPqeb12bzBuMW5gtTTAlZPM2Oc2CILkvKgc6tmPaGk8f/6C
         f3zwx4oAyE8s6Y/f8Uvof6iUci6SmxyqWr1Xo6YzuQigUTiAg5eR+/LWXMYFWsGwb/s4
         OZDP1+AB+V6cN3QS2JK4edGftTkshf1SwdnbJXaUDcVRbWlY7aoPDArpL7d+SvPJZCQu
         W2t1rbHeG48sKQhJ/9CTQx09yTMsdWeN4DmhBpI7hA2TxPxtOO1MlgQSraEWlQ2MSeNE
         /f3v+kr1CoGIsFnvYF9/9yYFCFGxzO51rhD7/ZKJlKb9xSLjzbl+iBdC3/pJoUarrVmM
         vvFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc;
        bh=nDY+MzOA939XxE3jhJSlYqnecUbFSkw44Nyv5TZ/3Nw=;
        b=rs+HVQkAl2w/ltO8E1FXT4bqs0QmsIVDUWlq/M9m+8HBF7MzULQpbL5t6Igqi94Isj
         K+F1tdwQlrXuDeN5BK/PeV+AV+EcRpA2RORwGDqVbnDgAF6CSE4F9oVPfdbYpp85oSx7
         nMt2To9MY9vp423q9/MHNpRIsCD8JjrgfDLtIe+Mnof4ZjbGT2cvyDNXQ9F6xS9zr+ke
         ckhMdfAiFvVQV9kVzIv0KkvDaHO968Zw8i9SL7lZyrPZIu1AGlPMlEP4Mxbo52tjkHpz
         iNVz6pROVxKDOShMe6PkKiEl2ulY6vt2aiEl4qgCkqh+5mDSHvqzmn7uwFDKzpMkE6En
         Svdw==
X-Gm-Message-State: ACgBeo1bLQmqbXk20vASUX1pwh6aAbitFGWGpOkZXKk0Jhmib4wQo/IM
        KaPoPCyD5CH1TxrcaaAeFWjJ/hf4ta+NUKznj+Q=
X-Google-Smtp-Source: AA6agR6oTDXuk8G8UR8BAfpgCXfdDaIOs5Qg1RTFNKTBvFlSiv67uBG6zv/ijDDk+/1sCuqlzTTCp58GDgf8k4PAjbA=
X-Received: by 2002:aa7:d88a:0:b0:440:916e:706d with SMTP id
 u10-20020aa7d88a000000b00440916e706dmr15619429edq.167.1660161527720; Wed, 10
 Aug 2022 12:58:47 -0700 (PDT)
MIME-Version: 1.0
References: <20220810164627.1.Id730b98f188a504d9835b96ddcbc83d49a70bb36@changeid>
In-Reply-To: <20220810164627.1.Id730b98f188a504d9835b96ddcbc83d49a70bb36@changeid>
From:   Luiz Augusto von Dentz <luiz.dentz@gmail.com>
Date:   Wed, 10 Aug 2022 12:58:36 -0700
Message-ID: <CABBYNZLhhdKLqYu-5OWQcHs22aeEJw0tSjVNhgpMCj_ctH+Ldg@mail.gmail.com>
Subject: Re: [PATCH] Bluetooth: Honor name resolve evt regardless of discov state
To:     Archie Pusaka <apusaka@google.com>
Cc:     linux-bluetooth <linux-bluetooth@vger.kernel.org>,
        Marcel Holtmann <marcel@holtmann.org>,
        CrosBT Upstreaming <chromeos-bluetooth-upstreaming@chromium.org>,
        Archie Pusaka <apusaka@chromium.org>,
        Ying Hsu <yinghsu@chromium.org>,
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
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_FILL_THIS_FORM_SHORT,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Archie,

On Wed, Aug 10, 2022 at 1:47 AM Archie Pusaka <apusaka@google.com> wrote:
>
> From: Archie Pusaka <apusaka@chromium.org>
>
> Currently, we don't update the name resolving cache when receiving
> a name resolve event if the discovery phase is not in the resolving
> stage.
>
> However, if the user connect to a device while we are still resolving
> remote name for another device, discovery will be stopped, and because
> we are no longer in the discovery resolving phase, the corresponding
> remote name event will be ignored, and thus the device being resolved
> will stuck in NAME_PENDING state.
>
> If discovery is then restarted and then stopped, this will cause us to
> try cancelling the name resolve of the same device again, which is
> incorrect and might upset the controller.

Please add the Fixes tag.

> Signed-off-by: Archie Pusaka <apusaka@chromium.org>
> Reviewed-by: Ying Hsu <yinghsu@chromium.org>
>
> ---
> The following steps are performed:
>     (1) Prepare 2 classic peer devices that needs RNR. Put device A
>         closer to DUT and device B (much) farther from DUT.
>     (2) Remove all cache and previous connection from DUT
>     (3) Put both peers into pairing mode, then start scanning on DUT
>     (4) After ~8 sec, turn off peer B.
>     *This is done so DUT can discover peer B (discovery time is 10s),
>     but it hasn't started RNR. Peer is turned off to buy us the max
>     time in the RNR phase (5s).
>     (5) Immediately as device A is shown on UI, click to connect.
>     *We thus know that the DUT is in the RNR phase and trying to
>     resolve the name of peer B when we initiate connection to peer A.
>     (6) Forget peer A.
>     (7) Restart scan and stop scan.
>     *Before the CL, stop scan is broken because we will try to cancel
>     a nonexistent RNR
>     (8) Restart scan again. Observe DUT can scan normally.
>
>
>  net/bluetooth/hci_event.c | 17 ++++++++++-------
>  1 file changed, 10 insertions(+), 7 deletions(-)
>
> diff --git a/net/bluetooth/hci_event.c b/net/bluetooth/hci_event.c
> index 395c6479456f..95e145e278c9 100644
> --- a/net/bluetooth/hci_event.c
> +++ b/net/bluetooth/hci_event.c
> @@ -2453,6 +2453,16 @@ static void hci_check_pending_name(struct hci_dev *hdev, struct hci_conn *conn,
>             !test_and_set_bit(HCI_CONN_MGMT_CONNECTED, &conn->flags))
>                 mgmt_device_connected(hdev, conn, name, name_len);
>
> +       e = hci_inquiry_cache_lookup_resolve(hdev, bdaddr, NAME_PENDING);
> +
> +       if (e) {
> +               list_del(&e->list);
> +
> +               e->name_state = name ? NAME_KNOWN : NAME_NOT_KNOWN;
> +               mgmt_remote_name(hdev, bdaddr, ACL_LINK, 0x00, e->data.rssi,
> +                                name, name_len);
> +       }
> +
>         if (discov->state == DISCOVERY_STOPPED)
>                 return;
>
> @@ -2462,7 +2472,6 @@ static void hci_check_pending_name(struct hci_dev *hdev, struct hci_conn *conn,
>         if (discov->state != DISCOVERY_RESOLVING)
>                 return;
>
> -       e = hci_inquiry_cache_lookup_resolve(hdev, bdaddr, NAME_PENDING);
>         /* If the device was not found in a list of found devices names of which
>          * are pending. there is no need to continue resolving a next name as it
>          * will be done upon receiving another Remote Name Request Complete
> @@ -2470,12 +2479,6 @@ static void hci_check_pending_name(struct hci_dev *hdev, struct hci_conn *conn,
>         if (!e)
>                 return;
>
> -       list_del(&e->list);
> -
> -       e->name_state = name ? NAME_KNOWN : NAME_NOT_KNOWN;
> -       mgmt_remote_name(hdev, bdaddr, ACL_LINK, 0x00, e->data.rssi,
> -                        name, name_len);
> -
>         if (hci_resolve_next_name(hdev))
>                 return;
>
> --
> 2.37.1.595.g718a3a8f04-goog
>


-- 
Luiz Augusto von Dentz
