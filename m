Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 308D93E18B5
	for <lists+netdev@lfdr.de>; Thu,  5 Aug 2021 17:50:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242618AbhHEPuu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Aug 2021 11:50:50 -0400
Received: from smtp-relay-canonical-0.canonical.com ([185.125.188.120]:50050
        "EHLO smtp-relay-canonical-0.canonical.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S242644AbhHEPus (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Aug 2021 11:50:48 -0400
Received: from mail-ej1-f72.google.com (mail-ej1-f72.google.com [209.85.218.72])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-canonical-0.canonical.com (Postfix) with ESMTPS id 2B4EA3F22F
        for <netdev@vger.kernel.org>; Thu,  5 Aug 2021 15:50:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1628178626;
        bh=D1l7i5Vb28UXsgNtCBHcCcosslzh2sOmteJR8SBleRE=;
        h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
         To:Cc:Content-Type;
        b=g2AAadfmeyKla1dH/Y+Xk1fHUWovHttV+mLNaoWNrMugWEcRlIF2iLfSy+B+yuVb+
         VU0X09spn5cxjmwDlhVkSJpd7LIK0URshF5JWtde5lW6o92OvqlOnBetFF31parjIk
         DMNaeNryvmULBtBoQAIXvojjkVChBI8ep9bo7Jk+efKC3xX6QxcXwrjI52j6vmmlWZ
         A0CDEW0hZpW0jg8pKILrTxTPcXbSijIBCzipwRnC9MxX4ifb0W2BMfa5DgWm3rFAb2
         YWcvKSva2VJHHgrDLq5ThgNgRR4vMdPTgW7O1o6/bc8dMyNB6rlYURBKivRzO47MbD
         71U7sDa9yC81Q==
Received: by mail-ej1-f72.google.com with SMTP id qh25-20020a170906ecb9b02905a655de6553so2084372ejb.19
        for <netdev@vger.kernel.org>; Thu, 05 Aug 2021 08:50:26 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=D1l7i5Vb28UXsgNtCBHcCcosslzh2sOmteJR8SBleRE=;
        b=mK+uyGjU3QF8A7VJJqal1ZjU9E0IhA1+sxFpnSWUZhFrjmwOlR+Wz/LbCVcBj5fe0X
         OXFHfiTABbvOJJyM3iVIX1nhnv97RkpbPu+2BLBdTYiktAVpuiJ9UspOTQX1le0crfqS
         lLf0o88r+XQ8RL+jN6ZKNImXSOX6pPKiZaORkWU4aWKDvUTxkWTWLCP70W3xHNPqq/s6
         cREJ8Yna2fz2cnBk/v9Helll9pB07PbL7K6DKp/a7RnfCZm41inwjXaRi1xS4qS7hyZj
         vu9X6x9vXRqIQc+4t1PPvMwur2wEJCTNcq3X601tp2Ku00CTRqmEUSZ1L1y5Xjew4STd
         GmxQ==
X-Gm-Message-State: AOAM530sLQUbepTkpVatwo30rnnXAZavTtolaU4Vh964o8S3yqyj/834
        RDNiLW0oIGgh6elRpMDLB4/AY5878Gt+IG3IU9j98E5H57dNWNkHWwUEsXuFVjxFOLZw3lbJQ5M
        dE3Vw9KKNHdsiR9ga8Dg1wcx77wYg7+Gisp9SDmEGjF0HXpVm8A==
X-Received: by 2002:a17:907:9d2:: with SMTP id bx18mr5515901ejc.117.1628178625867;
        Thu, 05 Aug 2021 08:50:25 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzv/WSADBZGHTodg1DBbwRBVFcjOn0YB5R69RD6u/wvTjmlwPTmtgTeS5cInQdde63/dbkb+r7CykRPnppdfSg=
X-Received: by 2002:a17:907:9d2:: with SMTP id bx18mr5515871ejc.117.1628178625561;
 Thu, 05 Aug 2021 08:50:25 -0700 (PDT)
MIME-Version: 1.0
References: <20210514071452.25220-1-kai.heng.feng@canonical.com>
 <576B26FD-81F8-4632-82F6-57C4A7C096C4@holtmann.org> <8735ryk0o7.fsf@baylibre.com>
 <CAAd53p7Zc3Zk21rwj_x1BLgf8tWRxaKBmXARkM6d7Kpkb+fDZA@mail.gmail.com>
 <87y29o58su.fsf@baylibre.com> <CAAd53p4Ss1Z-7CB4g=_xZYxo1xDz6ih6GHUuMcgncy+yNAfU4w@mail.gmail.com>
 <87a6lzx7jf.fsf@baylibre.com> <CAAd53p6T_K67CPthLPObF=OWWCEChW4pMFMwuq87qWmTmzP2VA@mail.gmail.com>
 <87bl6cnzy2.fsf@baylibre.com>
In-Reply-To: <87bl6cnzy2.fsf@baylibre.com>
From:   Kai-Heng Feng <kai.heng.feng@canonical.com>
Date:   Thu, 5 Aug 2021 23:50:09 +0800
Message-ID: <CAAd53p5TVJk3G4cArS_UO7cgUpJLONNGVHnpezXy0XTYoXd_uw@mail.gmail.com>
Subject: Re: [PATCH v2] Bluetooth: Shutdown controller after workqueues are
 flushed or cancelled
To:     Mattijs Korpershoek <mkorpershoek@baylibre.com>
Cc:     Marcel Holtmann <marcel@holtmann.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        Luiz Augusto von Dentz <luiz.dentz@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Fabien Parent <fparent@baylibre.com>,
        Sean Wang <sean.wang@mediatek.com>,
        "open list:BLUETOOTH SUBSYSTEM" <linux-bluetooth@vger.kernel.org>,
        "open list:NETWORKING [GENERAL]" <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Mattijs,

On Thu, Aug 5, 2021 at 2:55 PM Mattijs Korpershoek
<mkorpershoek@baylibre.com> wrote:
>
> Hi Kai-Heng,
>
> Thanks for your patch,
>
> Kai-Heng Feng <kai.heng.feng@canonical.com> writes:
>

[snipped]

> I confirm this diff works for me:
>
> root@i500-pumpkin:~# hciconfig hci0 up
> root@i500-pumpkin:~# hciconfig hci0 down
> root@i500-pumpkin:~# hciconfig hci0 up
> root@i500-pumpkin:~# hciconfig hci0
> hci0:   Type: Primary  Bus: SDIO
>         BD Address: 00:0C:E7:55:FF:12  ACL MTU: 1021:8  SCO MTU: 244:4
>         UP RUNNING
>         RX bytes:11268 acl:0 sco:0 events:829 errors:0
>         TX bytes:182569 acl:0 sco:0 commands:829 errors:0
>
> root@i500-pumpkin:~# hcitool scan
> Scanning ...
>         <redacted>       Pixel 3 XL
>
> Tested-by: Mattijs Korpershoek <mkorpershoek@baylibre.com>

I found that btmtksdio_flush() only cancels the work instead of doing
flush_work(). That probably explains why putting ->shutdown right
before ->flush doesn't work.
So can you please test the following again:
diff --git a/drivers/bluetooth/btmtksdio.c b/drivers/bluetooth/btmtksdio.c
index 9872ef18f9fea..b33c05ad2150b 100644
--- a/drivers/bluetooth/btmtksdio.c
+++ b/drivers/bluetooth/btmtksdio.c
@@ -649,9 +649,9 @@ static int btmtksdio_flush(struct hci_dev *hdev)
 {
        struct btmtksdio_dev *bdev = hci_get_drvdata(hdev);

-       skb_queue_purge(&bdev->txq);
+       flush_work(&bdev->tx_work);

-       cancel_work_sync(&bdev->tx_work);
+       skb_queue_purge(&bdev->txq);

        return 0;
 }
diff --git a/net/bluetooth/hci_core.c b/net/bluetooth/hci_core.c
index 2560ed2f144d4..a61e610a400cb 100644

--- a/net/bluetooth/hci_core.c
+++ b/net/bluetooth/hci_core.c
@@ -1785,6 +1785,14 @@ int hci_dev_do_close(struct hci_dev *hdev)
        aosp_do_close(hdev);
        msft_do_close(hdev);

+       if (!hci_dev_test_flag(hdev, HCI_UNREGISTER) &&
+           !hci_dev_test_flag(hdev, HCI_USER_CHANNEL) &&
+           test_bit(HCI_UP, &hdev->flags)) {
+               /* Execute vendor specific shutdown routine */
+               if (hdev->shutdown)
+                       hdev->shutdown(hdev);
+       }
+
        if (hdev->flush)
                hdev->flush(hdev);

@@ -1798,14 +1806,6 @@ int hci_dev_do_close(struct hci_dev *hdev)
                clear_bit(HCI_INIT, &hdev->flags);
        }

-       if (!hci_dev_test_flag(hdev, HCI_UNREGISTER) &&
-           !hci_dev_test_flag(hdev, HCI_USER_CHANNEL) &&
-           test_bit(HCI_UP, &hdev->flags)) {
-               /* Execute vendor specific shutdown routine */
-               if (hdev->shutdown)
-                       hdev->shutdown(hdev);
-       }
-
        /* flush cmd  work */
        flush_work(&hdev->cmd_work);

Kai-Heng
