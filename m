Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 64D154D6BBC
	for <lists+netdev@lfdr.de>; Sat, 12 Mar 2022 02:57:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229965AbiCLB5a (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Mar 2022 20:57:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54152 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229953AbiCLB5a (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Mar 2022 20:57:30 -0500
Received: from mail-qk1-x730.google.com (mail-qk1-x730.google.com [IPv6:2607:f8b0:4864:20::730])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D73AB2738CF
        for <netdev@vger.kernel.org>; Fri, 11 Mar 2022 17:56:24 -0800 (PST)
Received: by mail-qk1-x730.google.com with SMTP id c7so8453418qka.7
        for <netdev@vger.kernel.org>; Fri, 11 Mar 2022 17:56:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fireburn-co-uk.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=xfi+bTCXfqpw9uvIqrCKiFAYx08ePpQMftNlWEai8GI=;
        b=mmi7xLeMizQ9pqcmQrTJGMiaIqx7payr8WRD5COB9uOq5Rl6SSEc+fMBAAj+/z6ZiT
         brWs4DqIBz2pRGQcGP9nCuZoT43l00LGmAo7BUFILFNG9x+MdbB+DqxmBc+k6qfzHGok
         Taiw2rXQtxxYg1HxnAGxJiWzVLCwYlVUUeYTz5i/kBZwcPeGgdI2HaIYOMnnUZc0un9x
         phfCJkdOrOv5d+a6n463OvPH8/N9vxKziFEHXxveumuQYk6HGMEgUSRThTQ5HSwlR8qX
         FqcAUSHKpUvy82CBVYdczzAA6xryKl9ao/SkoqKdBAoWNNZhBitp31Smo7kytZYGI8Rv
         5ePg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=xfi+bTCXfqpw9uvIqrCKiFAYx08ePpQMftNlWEai8GI=;
        b=2IdYsIfJ9XfUNHZ4u2Wuby4aPtNyIZsIqhL4LE8yj8H5GqKzfdLvlmpYK0zcMRbHTz
         y7lu2lH00cFM6JkYE9oVBpdp6cXPdgIi0mx7aTm/teAn4/Kjw6cL+UWGNUZBpFyumvtY
         qGUGas+WfR90Twag1aFqKy08QTh+Jxw/a3wbIMzJ/h34BfOy52hwz9vGne7PyWh4m2n5
         oAdFWcNOzUqBXxhpvXdSUJdH9rBXxbUxX/sKRbxe5uByCyMH2bkqUCNH2+VfjcgbxyTt
         ZO3Fn369vQKtg+7KmxhFRRmdCRG7IlUh6hXEnMXaKedWHnek8IOW6p6GR2J61kKP6uDT
         2juQ==
X-Gm-Message-State: AOAM532S8DyUkJoJz0QNSW+R860MsjUAU1Dyyz9yKtbX7fCBqaIF9LFU
        TVaNbgCLHehse0emHVuv0Ev0NdjcAE9YhLz/vtLopg==
X-Google-Smtp-Source: ABdhPJyDiBjfvy+DNPABDeJ8lQGZ/K1AJn+0jatIIIY6cpB4OWf7W40ok8GNidb/Vcxwmg2+MC6g3kJjZH+3FAe27Gg=
X-Received: by 2002:a05:620a:16c5:b0:67d:47db:8b50 with SMTP id
 a5-20020a05620a16c500b0067d47db8b50mr8486422qkn.77.1647050183941; Fri, 11 Mar
 2022 17:56:23 -0800 (PST)
MIME-Version: 1.0
References: <20211201000215.1134831-13-luiz.dentz@gmail.com> <20220125144639.2226-1-mike@fireburn.co.uk>
In-Reply-To: <20220125144639.2226-1-mike@fireburn.co.uk>
From:   Mike Lothian <mike@fireburn.co.uk>
Date:   Sat, 12 Mar 2022 01:56:13 +0000
Message-ID: <CAHbf0-FEVZZYg7U__YXqPmS=XETb2pObB-8CX+vh8=-HivppJA@mail.gmail.com>
Subject: Re: [PATCH 12/15] Bluetooth: hci_event: Use of a function table to
 handle HCI events
To:     luiz.dentz@gmail.com
Cc:     dan.carpenter@oracle.com, davem@davemloft.net, kuba@kernel.org,
        linux-bluetooth@vger.kernel.org, luiz.von.dentz@intel.com,
        netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 25 Jan 2022 at 14:46, Mike Lothian <mike@fireburn.co.uk> wrote:
>
> Hi
>
> This patch is causing a lot of spam in my dmesg at boot until it seems my wifi connects (or perhaps the bluetooth manager does something)
>
> Bluetooth: hci0: unexpected event 0xff length: 5 > 0
>
> Thanks
>
> Mike

Hi

Has there been any movement on this issue?

I'm currently running with this patch locally to make the dmesg spam go away

From f786c85baac0ee93730998fa52cbd588c9f39286 Mon Sep 17 00:00:00 2001
From: Mike Lothian <mike@fireburn.co.uk>
Date: Tue, 25 Jan 2022 14:52:00 +0000
Subject: [PATCH] Remove excessive bluetooth warning

---
net/bluetooth/hci_event.c | 8 --------
1 file changed, 8 deletions(-)

diff --git a/net/bluetooth/hci_event.c b/net/bluetooth/hci_event.c
index fc30f4c03d29..aa57fccd2e47 100644
--- a/net/bluetooth/hci_event.c
+++ b/net/bluetooth/hci_event.c
@@ -6818,14 +6818,6 @@ static void hci_event_func(struct hci_dev
*hdev, u8 event, struct sk_buff *skb,
               return;
       }

-       /* Just warn if the length is over max_len size it still be
-        * possible to partially parse the event so leave to callback to
-        * decide if that is acceptable.
-        */
-       if (skb->len > ev->max_len)
-               bt_dev_warn(hdev, "unexpected event 0x%2.2x length: %u > %u",
-                           event, skb->len, ev->max_len);
-
       data = hci_ev_skb_pull(hdev, skb, event, ev->min_len);
       if (!data)
               return;
--
2.35.0
