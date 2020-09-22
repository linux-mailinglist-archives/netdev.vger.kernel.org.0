Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4717E273C6B
	for <lists+netdev@lfdr.de>; Tue, 22 Sep 2020 09:48:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730185AbgIVHsG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Sep 2020 03:48:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60204 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730050AbgIVHsG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Sep 2020 03:48:06 -0400
Received: from mail-wr1-x444.google.com (mail-wr1-x444.google.com [IPv6:2a00:1450:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E1AA3C0613D0
        for <netdev@vger.kernel.org>; Tue, 22 Sep 2020 00:48:05 -0700 (PDT)
Received: by mail-wr1-x444.google.com with SMTP id z4so15911744wrr.4
        for <netdev@vger.kernel.org>; Tue, 22 Sep 2020 00:48:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=q1gQqWOf8efX9sJ/D/OIGJtauHg2OW2WzxS92JQ9fUE=;
        b=SaYeIC5H1bZZrAM9cTd8lgo4ssxkGmovpX/F7UooYhJY5se0onVq7DcsZWbIEA7P0G
         vh6ACScYRo58pGOAVob/93wUzZlpzmSqHUQ/vdULPkYQf/Q4douhr+MNNofETAPKutxF
         BrOnZPs/AJlRF3td8lsmCuI8WCUBiu0d3iULvvf8koDIdQl7BaSR8ObXIR0mJdjYj3pU
         qducdvrUrXgYbN+dTe2IT/NdrlHAdftvvhJhdq+enO4jVvxE0nvVY3JhradQW6o0n1xW
         DdTHcekuqGwi4PRoZfDxytwawSu3zG9mj7oAXHyuNSJjv8VJV7OoOckgXCw/KB+P32NF
         kokA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=q1gQqWOf8efX9sJ/D/OIGJtauHg2OW2WzxS92JQ9fUE=;
        b=UwBDaeq7ipY87TfeVkOAaQa56WmT91qmf+0Sk4J5lNUp0Ny1r6AbBhI0DQ3eoEHcrc
         d9xEwuWai+MhZapIgdufGImPSHzsid91//aIO/CtE9/KRZyUKJSy4wyPsLmAQaQA4F03
         HSDIgPpteeYlOtVhxC7nxmDlmVIiNMLg9ve+uNKFyVTeC7/lRhek/kzEKjGDWzE8wFHL
         mi+hmy/JAZDDzGUFKrPUVkLQAJmc5tU7o3o1a9CoB+kVAgWJ/hQ8K7M80tmFGEmX1bJs
         3uhbcBsDBwWEx3I2RwSQOqt1XROpihSD7ewLuozOQflcCRarrM8yjU5+Ewy4t2UtOlox
         UhMw==
X-Gm-Message-State: AOAM530r5gF5NZgmW6MTEClzLUVOOe4ie5J0eNQ1lvTEFS4WyLB80xia
        y0UPCIZ+BW16EcQ3D3at4FaG6ez3iljSpYa2vc3TsA==
X-Google-Smtp-Source: ABdhPJxIFcifPYTJgkB/1B0+MTkMJ8QpqxtS1lOV0sAjIFDXfiY1b5BBtBuYd8Oy1YlH+O1VByBdp+Wk+CK7bzpq3A4=
X-Received: by 2002:adf:dcc3:: with SMTP id x3mr3778468wrm.120.1600760884252;
 Tue, 22 Sep 2020 00:48:04 -0700 (PDT)
MIME-Version: 1.0
References: <20200921155004.v2.1.I67a8b8cd4def8166970ca37109db46d731b62bb6@changeid>
 <CABBYNZLTZbwyL0ykmFezWrkNVnHoZt2KPtz+aQwo7TvhdC7TiQ@mail.gmail.com>
In-Reply-To: <CABBYNZLTZbwyL0ykmFezWrkNVnHoZt2KPtz+aQwo7TvhdC7TiQ@mail.gmail.com>
From:   Archie Pusaka <apusaka@google.com>
Date:   Tue, 22 Sep 2020 15:47:53 +0800
Message-ID: <CAJQfnxFjL6RicwHyFgYzNp7WPrMePEOa2fgOX9TMju-z5AWsPg@mail.gmail.com>
Subject: Re: [PATCH v2] Bluetooth: Check for encryption key size on connect
To:     Luiz Augusto von Dentz <luiz.dentz@gmail.com>
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

Hi Luiz,

On Tue, 22 Sep 2020 at 01:15, Luiz Augusto von Dentz
<luiz.dentz@gmail.com> wrote:
>
> Hi Archie,
>
>
> On Mon, Sep 21, 2020 at 12:56 AM Archie Pusaka <apusaka@google.com> wrote:
> >
> > From: Archie Pusaka <apusaka@chromium.org>
> >
> > When receiving connection, we only check whether the link has been
> > encrypted, but not the encryption key size of the link.
> >
> > This patch adds check for encryption key size, and reject L2CAP
> > connection which size is below the specified threshold (default 7)
> > with security block.
> >
> > Here is some btmon trace.
> > @ MGMT Event: New Link Key (0x0009) plen 26    {0x0001} [hci0] 5.847722
> >         Store hint: No (0x00)
> >         BR/EDR Address: 38:00:25:F7:F1:B0 (OUI 38-00-25)
> >         Key type: Unauthenticated Combination key from P-192 (0x04)
> >         Link key: 7bf2f68c81305d63a6b0ee2c5a7a34bc
> >         PIN length: 0
> > > HCI Event: Encryption Change (0x08) plen 4        #29 [hci0] 5.871537
> >         Status: Success (0x00)
> >         Handle: 256
> >         Encryption: Enabled with E0 (0x01)
> > < HCI Command: Read Encryp... (0x05|0x0008) plen 2  #30 [hci0] 5.871609
> >         Handle: 256
> > > HCI Event: Command Complete (0x0e) plen 7         #31 [hci0] 5.872524
> >       Read Encryption Key Size (0x05|0x0008) ncmd 1
> >         Status: Success (0x00)
> >         Handle: 256
> >         Key size: 3
> >
> > ////// WITHOUT PATCH //////
> > > ACL Data RX: Handle 256 flags 0x02 dlen 12        #42 [hci0] 5.895023
> >       L2CAP: Connection Request (0x02) ident 3 len 4
> >         PSM: 4097 (0x1001)
> >         Source CID: 64
> > < ACL Data TX: Handle 256 flags 0x00 dlen 16        #43 [hci0] 5.895213
> >       L2CAP: Connection Response (0x03) ident 3 len 8
> >         Destination CID: 64
> >         Source CID: 64
> >         Result: Connection successful (0x0000)
> >         Status: No further information available (0x0000)
> >
> > ////// WITH PATCH //////
> > > ACL Data RX: Handle 256 flags 0x02 dlen 12        #42 [hci0] 4.887024
> >       L2CAP: Connection Request (0x02) ident 3 len 4
> >         PSM: 4097 (0x1001)
> >         Source CID: 64
> > < ACL Data TX: Handle 256 flags 0x00 dlen 16        #43 [hci0] 4.887127
> >       L2CAP: Connection Response (0x03) ident 3 len 8
> >         Destination CID: 0
> >         Source CID: 64
> >         Result: Connection refused - security block (0x0003)
> >         Status: No further information available (0x0000)
> >
> > Signed-off-by: Archie Pusaka <apusaka@chromium.org>
> > Reviewed-by: Alain Michaud <alainm@chromium.org>
> >
> > ---
> > Btw, it looks like the patch sent by Alex Lu with the title
> > [PATCH] Bluetooth: Fix the vulnerable issue on enc key size
> > also solves the exact same issue.
> >
> > Changes in v2:
> > * Add btmon trace to the commit message
> >
> >  net/bluetooth/l2cap_core.c | 3 ++-
> >  1 file changed, 2 insertions(+), 1 deletion(-)
> >
> > diff --git a/net/bluetooth/l2cap_core.c b/net/bluetooth/l2cap_core.c
> > index ade83e224567..b4fc0ad38aaa 100644
> > --- a/net/bluetooth/l2cap_core.c
> > +++ b/net/bluetooth/l2cap_core.c
> > @@ -4101,7 +4101,8 @@ static struct l2cap_chan *l2cap_connect(struct l2cap_conn *conn,
> >
> >         /* Check if the ACL is secure enough (if not SDP) */
> >         if (psm != cpu_to_le16(L2CAP_PSM_SDP) &&
> > -           !hci_conn_check_link_mode(conn->hcon)) {
> > +           (!hci_conn_check_link_mode(conn->hcon) ||
> > +           !l2cap_check_enc_key_size(conn->hcon))) {
>
> I wonder if we couldn't incorporate the check of key size into
> hci_conn_check_link_mode, like I said in the first patch checking the
> enc key size should not be specific to L2CAP.

Yes, I could move the check into hci_conn_check_link_mode.
At first look, this function is also called by AMP which I am not
familiar with. In addition, I found this patch which moves this check
outside hci_conn, so I have my doubts there.
https://git.kernel.org/pub/scm/linux/kernel/git/bluetooth/bluetooth-next.git/commit/?id=693cd8ce3f882524a5d06f7800dd8492411877b3

>
> >                 conn->disc_reason = HCI_ERROR_AUTH_FAILURE;
> >                 result = L2CAP_CR_SEC_BLOCK;
> >                 goto response;
> > --
> > 2.28.0.681.g6f77f65b4e-goog
> >
>
>
> --
> Luiz Augusto von Dentz

Thanks,
Archie
