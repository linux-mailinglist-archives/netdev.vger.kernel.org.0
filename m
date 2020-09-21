Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 014CB2730BD
	for <lists+netdev@lfdr.de>; Mon, 21 Sep 2020 19:17:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728391AbgIURPT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Sep 2020 13:15:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38936 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726818AbgIURPS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Sep 2020 13:15:18 -0400
Received: from mail-oo1-xc44.google.com (mail-oo1-xc44.google.com [IPv6:2607:f8b0:4864:20::c44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B63A2C061755;
        Mon, 21 Sep 2020 10:15:18 -0700 (PDT)
Received: by mail-oo1-xc44.google.com with SMTP id r10so3444661oor.5;
        Mon, 21 Sep 2020 10:15:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=truTd7ocTX1PuSU7rQErYxWj/dIz+vHpcLReSTcVRLQ=;
        b=IYFOmOTKym3fEevV+/lfQdwIKr9kOO2wdlYQum+pLsRktlMnxdpso9HSJO4RH+0s2Z
         UxdUvle1oIN9eZzFit3mrq1OLX6d6iALBByS9J5ZvPg9kIYodA/Y5hxmHLx2y8G9aLHa
         XBkE8XLvSRG7FhDVFcmAWEaRVY7cX/DThKDmj1RPBNPcowTFcnC7IflE/Bsdu8VoFKo6
         Dti1Um01dTCkT0pKU7d7ikjpJRMqtZgN2W98og0TSAYLUfph/LvHClaJBOy24XhrwsUC
         9H6bxtIjo+qPVr90hroYJAVkjzs6qe+Z15zGspfqB0rWO7is4lftdAXREnIlyuOdXNGp
         H6Yw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=truTd7ocTX1PuSU7rQErYxWj/dIz+vHpcLReSTcVRLQ=;
        b=KxXYUcLBYrrA+BYG+D+7SDItZx7OkzWOX7yNZlGXZCGEAUvLMCr99FXEOW2xfYtYC+
         pCTh6LoLfCl38yT/ELPrW/3g9kd9fyy0jq0Tc1GSx7tqqf/OOi0FkZW6syXRquV9gVEd
         W9fDvOlMj8WXbshOE5waL0dt5eiaDbnj5z3/uICPP00ZuWNB4k1PVm0uYU8gW+FHxLO4
         rcPXko06t/jXpMx8TEohw5vveAXI0qkBcjIBaCK9d0NhoqDr/U8jQ4LzO0KMVYmYzIc6
         Ym+ilwJTgJu6CTqmnO7a+q1WgCiNERrUl4yHNX7PVIgQjCGBd0+wKINFPgynemOqrqEy
         7rfg==
X-Gm-Message-State: AOAM533cBYPLxAqCXt6GeaT9aHaZ6x5TCNiTUALp+XBnvj7dphrs9V3q
        oNqBK6dXRYB8ejFBLEI7kaDDi7VnGtc2pO9i4TM=
X-Google-Smtp-Source: ABdhPJyBqC+wVOljuLdYILZoSwG9EtUz6TgN/dCaURqlCsUz+SvJOXocTrSwYx0YZGWVVFvO/VyCzZosJhR5hyMqqpM=
X-Received: by 2002:a4a:bf12:: with SMTP id r18mr272835oop.9.1600708517923;
 Mon, 21 Sep 2020 10:15:17 -0700 (PDT)
MIME-Version: 1.0
References: <20200921155004.v2.1.I67a8b8cd4def8166970ca37109db46d731b62bb6@changeid>
In-Reply-To: <20200921155004.v2.1.I67a8b8cd4def8166970ca37109db46d731b62bb6@changeid>
From:   Luiz Augusto von Dentz <luiz.dentz@gmail.com>
Date:   Mon, 21 Sep 2020 10:15:04 -0700
Message-ID: <CABBYNZLTZbwyL0ykmFezWrkNVnHoZt2KPtz+aQwo7TvhdC7TiQ@mail.gmail.com>
Subject: Re: [PATCH v2] Bluetooth: Check for encryption key size on connect
To:     Archie Pusaka <apusaka@google.com>
Cc:     linux-bluetooth <linux-bluetooth@vger.kernel.org>,
        Marcel Holtmann <marcel@holtmann.org>,
        CrosBT Upstreaming <chromeos-bluetooth-upstreaming@chromium.org>,
        Archie Pusaka <apusaka@chromium.org>,
        Alain Michaud <alainm@chromium.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "open list:NETWORKING [GENERAL]" <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Archie,


On Mon, Sep 21, 2020 at 12:56 AM Archie Pusaka <apusaka@google.com> wrote:
>
> From: Archie Pusaka <apusaka@chromium.org>
>
> When receiving connection, we only check whether the link has been
> encrypted, but not the encryption key size of the link.
>
> This patch adds check for encryption key size, and reject L2CAP
> connection which size is below the specified threshold (default 7)
> with security block.
>
> Here is some btmon trace.
> @ MGMT Event: New Link Key (0x0009) plen 26    {0x0001} [hci0] 5.847722
>         Store hint: No (0x00)
>         BR/EDR Address: 38:00:25:F7:F1:B0 (OUI 38-00-25)
>         Key type: Unauthenticated Combination key from P-192 (0x04)
>         Link key: 7bf2f68c81305d63a6b0ee2c5a7a34bc
>         PIN length: 0
> > HCI Event: Encryption Change (0x08) plen 4        #29 [hci0] 5.871537
>         Status: Success (0x00)
>         Handle: 256
>         Encryption: Enabled with E0 (0x01)
> < HCI Command: Read Encryp... (0x05|0x0008) plen 2  #30 [hci0] 5.871609
>         Handle: 256
> > HCI Event: Command Complete (0x0e) plen 7         #31 [hci0] 5.872524
>       Read Encryption Key Size (0x05|0x0008) ncmd 1
>         Status: Success (0x00)
>         Handle: 256
>         Key size: 3
>
> ////// WITHOUT PATCH //////
> > ACL Data RX: Handle 256 flags 0x02 dlen 12        #42 [hci0] 5.895023
>       L2CAP: Connection Request (0x02) ident 3 len 4
>         PSM: 4097 (0x1001)
>         Source CID: 64
> < ACL Data TX: Handle 256 flags 0x00 dlen 16        #43 [hci0] 5.895213
>       L2CAP: Connection Response (0x03) ident 3 len 8
>         Destination CID: 64
>         Source CID: 64
>         Result: Connection successful (0x0000)
>         Status: No further information available (0x0000)
>
> ////// WITH PATCH //////
> > ACL Data RX: Handle 256 flags 0x02 dlen 12        #42 [hci0] 4.887024
>       L2CAP: Connection Request (0x02) ident 3 len 4
>         PSM: 4097 (0x1001)
>         Source CID: 64
> < ACL Data TX: Handle 256 flags 0x00 dlen 16        #43 [hci0] 4.887127
>       L2CAP: Connection Response (0x03) ident 3 len 8
>         Destination CID: 0
>         Source CID: 64
>         Result: Connection refused - security block (0x0003)
>         Status: No further information available (0x0000)
>
> Signed-off-by: Archie Pusaka <apusaka@chromium.org>
> Reviewed-by: Alain Michaud <alainm@chromium.org>
>
> ---
> Btw, it looks like the patch sent by Alex Lu with the title
> [PATCH] Bluetooth: Fix the vulnerable issue on enc key size
> also solves the exact same issue.
>
> Changes in v2:
> * Add btmon trace to the commit message
>
>  net/bluetooth/l2cap_core.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
>
> diff --git a/net/bluetooth/l2cap_core.c b/net/bluetooth/l2cap_core.c
> index ade83e224567..b4fc0ad38aaa 100644
> --- a/net/bluetooth/l2cap_core.c
> +++ b/net/bluetooth/l2cap_core.c
> @@ -4101,7 +4101,8 @@ static struct l2cap_chan *l2cap_connect(struct l2cap_conn *conn,
>
>         /* Check if the ACL is secure enough (if not SDP) */
>         if (psm != cpu_to_le16(L2CAP_PSM_SDP) &&
> -           !hci_conn_check_link_mode(conn->hcon)) {
> +           (!hci_conn_check_link_mode(conn->hcon) ||
> +           !l2cap_check_enc_key_size(conn->hcon))) {

I wonder if we couldn't incorporate the check of key size into
hci_conn_check_link_mode, like I said in the first patch checking the
enc key size should not be specific to L2CAP.

>                 conn->disc_reason = HCI_ERROR_AUTH_FAILURE;
>                 result = L2CAP_CR_SEC_BLOCK;
>                 goto response;
> --
> 2.28.0.681.g6f77f65b4e-goog
>


--
Luiz Augusto von Dentz
