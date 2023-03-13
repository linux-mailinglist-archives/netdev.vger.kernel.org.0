Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5B4C76B733C
	for <lists+netdev@lfdr.de>; Mon, 13 Mar 2023 10:55:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230117AbjCMJzw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Mar 2023 05:55:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37624 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229616AbjCMJzu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Mar 2023 05:55:50 -0400
Received: from mail-pf1-x430.google.com (mail-pf1-x430.google.com [IPv6:2607:f8b0:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A420F25E21;
        Mon, 13 Mar 2023 02:55:49 -0700 (PDT)
Received: by mail-pf1-x430.google.com with SMTP id n16so1078121pfa.12;
        Mon, 13 Mar 2023 02:55:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678701349;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9MhHEvNZe13+TDFjC8K3erYv+7/DolQnJIs4c1a8yKY=;
        b=U5wrvJW3qwYOYhADEVAhz9jV+8xWEkZNx25s3zOcGpVuQTnIR7WGW1OQBAh5+E8LXt
         IX7S2L6EaQ7J9407dzl+Ldc6P+1Z/U3KcM5huhREdl9SX4Aow65D2oC5VGric6FKaiBx
         iJ4YuQRlPOKYxu1zOhLffrlEKD7V6cJj7VmSuJ6Lmdvev8oBsXQAtiZ/HCi797gUUp4z
         gwcsnCcl9YzJSq3d2mrat1/Q/13zGSrb8Q4AL9cbda/Fup9ABBV25hbkVhrj0tMfUmrR
         zTs1rtV4tW2hznFujgd1ADwCQAgOBK8C5VOdWBDMozTBfmtC6/osSIdlGWI1SAUJFwxk
         52LA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678701349;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=9MhHEvNZe13+TDFjC8K3erYv+7/DolQnJIs4c1a8yKY=;
        b=NWWoulzZAb8pTwC84A0w2IioAzhKAF6Qhx3lORzV0HCeK7JGuYOeVEt3n3PsQcb7iZ
         0QPXcV9hvy+T0xS4tuPTWPZPEknypE7Pm2wCwG/18tz2Qy1U1cem+TXwOCP7smhINrHd
         yvB7AkXRHqaYDOVTYS1Ycw6uC99Mrq2bfwR4cjHhGOTjH+8mW7LWLCtbQlFsdmw4mneK
         2dOgM3Ma6gfJzEqBgPty8HZYqwkjkdGMTcdewle/dhWrSziCVlaKcpGesRj/x4kfaVnc
         9qPZ0CG9/ITdKq4Mz5mqXN5oRyepAbQCJl94+U+Sk0+KFbxKbmpR07raVuV03OWHlcni
         zleA==
X-Gm-Message-State: AO0yUKXacWFpWr8RPnDieVusnFvWBgG4h87RZXCFY2yO1yoZb3OCWArs
        08mM2FuJGVD4NSaj5qZalOpyamuK7+oILYzsitI=
X-Google-Smtp-Source: AK7set+xOSxu/T7WJBh17bxSEY8zfdEMaDlHePZIaxLS/tZaVg6a4odXZh1RWW27FYxxjUrnKm6eM5Cf7aWMdYEHGpI=
X-Received: by 2002:a62:1c13:0:b0:622:c6ad:b373 with SMTP id
 c19-20020a621c13000000b00622c6adb373mr1903656pfc.3.1678701349107; Mon, 13 Mar
 2023 02:55:49 -0700 (PDT)
MIME-Version: 1.0
References: <20230217100223.702330-1-zyytlz.wz@163.com>
In-Reply-To: <20230217100223.702330-1-zyytlz.wz@163.com>
From:   Zheng Hacker <hackerzheng666@gmail.com>
Date:   Mon, 13 Mar 2023 17:55:35 +0800
Message-ID: <CAJedcCxUNBWOpkcaN2aLbwNs_xvqi=LC8mhFWh-jWeh6q-cBCQ@mail.gmail.com>
Subject: Re: [PATCH v2] Bluetooth: hci_core: Fix poential Use-after-Free bug
 in hci_remove_adv_monitor
To:     Zheng Wang <zyytlz.wz@163.com>
Cc:     marcel@holtmann.org, alex000young@gmail.com,
        johan.hedberg@gmail.com, luiz.dentz@gmail.com, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        linux-bluetooth@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, pmenzel@molgen.mpg.de
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

friendly ping

Zheng Wang <zyytlz.wz@163.com> =E4=BA=8E2023=E5=B9=B42=E6=9C=8817=E6=97=A5=
=E5=91=A8=E4=BA=94 18:05=E5=86=99=E9=81=93=EF=BC=9A
>
> In hci_remove_adv_monitor, if it gets into HCI_ADV_MONITOR_EXT_MSFT case,
> the function will free the monitor and print its handle after that.
> Fix it by removing the logging into msft_le_cancel_monitor_advertisement_=
cb
> before calling hci_free_adv_monitor.
>
> Signed-off-by: Zheng Wang <zyytlz.wz@163.com>
> ---
> v2:
> - move the logging inside msft_remove_monitor suggested by Luiz
> ---
>  net/bluetooth/hci_core.c | 2 --
>  net/bluetooth/msft.c     | 2 ++
>  2 files changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/net/bluetooth/hci_core.c b/net/bluetooth/hci_core.c
> index b65c3aabcd53..69b82c2907ff 100644
> --- a/net/bluetooth/hci_core.c
> +++ b/net/bluetooth/hci_core.c
> @@ -1981,8 +1981,6 @@ static int hci_remove_adv_monitor(struct hci_dev *h=
dev,
>
>         case HCI_ADV_MONITOR_EXT_MSFT:
>                 status =3D msft_remove_monitor(hdev, monitor);
> -               bt_dev_dbg(hdev, "%s remove monitor %d msft status %d",
> -                          hdev->name, monitor->handle, status);
>                 break;
>         }
>
> diff --git a/net/bluetooth/msft.c b/net/bluetooth/msft.c
> index bee6a4c656be..4b35f0ed1360 100644
> --- a/net/bluetooth/msft.c
> +++ b/net/bluetooth/msft.c
> @@ -286,6 +286,8 @@ static int msft_le_cancel_monitor_advertisement_cb(st=
ruct hci_dev *hdev,
>                  * suspend. It will be re-monitored on resume.
>                  */
>                 if (!msft->suspending) {
> +                       bt_dev_dbg(hdev, "%s remove monitor %d status %d"=
, hdev->name,
> +                                  monitor->handle, status);
>                         hci_free_adv_monitor(hdev, monitor);
>
>                         /* Clear any monitored devices by this Adv Monito=
r */
> --
> 2.25.1
>
