Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3B8AA61D833
	for <lists+netdev@lfdr.de>; Sat,  5 Nov 2022 08:14:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229523AbiKEHOC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 5 Nov 2022 03:14:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54274 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229461AbiKEHOB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 5 Nov 2022 03:14:01 -0400
Received: from mail-wr1-x434.google.com (mail-wr1-x434.google.com [IPv6:2a00:1450:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B3F83054F;
        Sat,  5 Nov 2022 00:13:59 -0700 (PDT)
Received: by mail-wr1-x434.google.com with SMTP id h9so9754281wrt.0;
        Sat, 05 Nov 2022 00:13:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=dxvKh/anYGuSiGPrfs/LiTLvfyTDQwd9he7x1e6EBiU=;
        b=HYCZ+ZsNDKtGQL7otOykXSDQnO1o6rzi8fW0cXmPAwFMFTWNhywZx3y97hKPR/w10N
         y+cy7ipKrn9FJeZJIYoUvp9C4udhl8LNbtaomr9pnHW/XBRenZfpCfwgWlsxANGpLjDf
         ENlsHGv18R+/cmhkLeMP0suZW9740s2UbizPyKCiuaSrwiOMhOp6uDmy7o/MlmOrn2Wo
         TZfqfnQcDlUXqwGQbmLhSzCSRv9eDQHaIbC4NfNdyTLZoylO5zLjx3lVFBB7NbW/cwks
         GoDRa02ppaY8899CWaDP1X9TLFbsRJz/jlNj7mnFhZdW2QjWj34ZOCmd3B7PfXzr1tFs
         TcCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=dxvKh/anYGuSiGPrfs/LiTLvfyTDQwd9he7x1e6EBiU=;
        b=3N1Bq+BC04wHxAxzvv+5h8nk7lwr7QUDjBn4tu4mCgBjG9GfddIeRrfv4J6jhzpQHt
         s9lQTAeQtV07AgwwJ2Ssb76+jjFITFcYE49ItYmNLBjz37ZBzFFSK/MWYePZpA7gmWDm
         nO5HrNL02uF11E12GxK9VdgL48RaJpwy+SSySmvBRPhm2njrbsPbNhsEWNuDxiY+j21q
         Q5pFYsL4rr9jxHt2QCw7MOI29gRSYdGt8E/CPMMUrCJbKxcAU73vgJyFvcjcx0tLhaqT
         +tquNb0xafGtEm1mbMXaGnK4Oq+Y5do+q/noEDSUyGeMqNQGl4UMNxxbWu2Zml91cDP4
         AH7Q==
X-Gm-Message-State: ACrzQf38jtW23lOw6tgGigUTvrTSGduAw+e/G6VfnwUR1YxOBirUaVlV
        ZQ6wESEaj18vIIJSslSvuLIJNjySW54OZDMcqBU=
X-Google-Smtp-Source: AMsMyM76FEIAgi3v06UJ9fLDK+7INtqxxZu+G9UgLNenpG3DbcrankgqSi3GIoF7OZffPoIW5QmMDS0yOVzgLgTtfb0=
X-Received: by 2002:a5d:5c0f:0:b0:236:c429:361a with SMTP id
 cc15-20020a5d5c0f000000b00236c429361amr21314804wrb.475.1667632437864; Sat, 05
 Nov 2022 00:13:57 -0700 (PDT)
MIME-Version: 1.0
References: <20220524212155.16944-1-bage@debian.org> <20220524212155.16944-2-bage@debian.org>
 <78EC62F6-40D5-4E18-B2FA-DA2EB9D67986@holtmann.org>
In-Reply-To: <78EC62F6-40D5-4E18-B2FA-DA2EB9D67986@holtmann.org>
From:   Vasily Khoruzhick <anarsoul@gmail.com>
Date:   Sat, 5 Nov 2022 00:13:30 -0700
Message-ID: <CA+E=qVd6sRCnKZz2gizxqP=DVQPttW4JgmhE7SHYJhbnQADpwA@mail.gmail.com>
Subject: Re: [PATCH v2 1/3] Bluetooth: Add new quirk for broken local ext
 features max_page
To:     Marcel Holtmann <marcel@holtmann.org>
Cc:     Bastian Germann <bage@debian.org>,
        Rob Herring <robh+dt@kernel.org>,
        Maxime Ripard <mripard@kernel.org>,
        Chen-Yu Tsai <wens@csie.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kubakici@wp.pl>, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-bluetooth@vger.kernel.org, netdev@vger.kernel.org
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

On Thu, Jun 2, 2022 at 9:10 AM Marcel Holtmann <marcel@holtmann.org> wrote:
>
> Hi Bastian,

Hi Marcel,

> > Some adapters (e.g. RTL8723CS) advertise that they have more than
> > 2 pages for local ext features, but they don't support any features
> > declared in these pages. RTL8723CS reports max_page = 2 and declares
> > support for sync train and secure connection, but it responds with
> > either garbage or with error in status on corresponding commands.
>
>
> please include btmon output for the garbage and/or error.

We had it in v1 thread, here is relevant part:

< HCI Command: Read Local Extend.. (0x04|0x0004) plen 1  #228 [hci0] 6.889869
        Page: 2
> HCI Event: Command Complete (0x0e) plen 14             #229 [hci0] 6.890487
      Read Local Extended Features (0x04|0x0004) ncmd 2
        Status: Success (0x00)
        Page: 2/2
        Features: 0x5f 0x03 0x00 0x00 0x00 0x00 0x00 0x00
          Connectionless Slave Broadcast - Master
          Connectionless Slave Broadcast - Slave
          Synchronization Train
          Synchronization Scan
          Inquiry Response Notification Event
          Coarse Clock Adjustment
          Secure Connections (Controller Support)
          Ping
< HCI Command: Delete Stored Lin.. (0x03|0x0012) plen 7  #230 [hci0] 6.890559
        Address: 00:00:00:00:00:00 (OUI 00-00-00)
        Delete all: 0x01
> HCI Event: Command Complete (0x0e) plen 6              #231 [hci0] 6.891170
      Delete Stored Link Key (0x03|0x0012) ncmd 2
        Status: Success (0x00)
        Num keys: 0
< HCI Command: Read Synchronizat.. (0x03|0x0077) plen 0  #232 [hci0] 6.891199
> HCI Event: Command Complete (0x0e) plen 9              #233 [hci0] 6.891788
      Read Synchronization Train Parameters (0x03|0x0077) ncmd 2
        invalid packet size
        01 ac bd 11 80 80                                ......
= Close Index: 00:E0:4C:23:99:87                              [hci0] 6.891832

> >
> > Signed-off-by: Vasily Khoruzhick <anarsoul@gmail.com>
> > [rebase on current tree]
> > Signed-off-by: Bastian Germann <bage@debian.org>
> > ---
> > include/net/bluetooth/hci.h | 7 +++++++
> > net/bluetooth/hci_event.c   | 4 +++-
> > 2 files changed, 10 insertions(+), 1 deletion(-)
> >
> > diff --git a/include/net/bluetooth/hci.h b/include/net/bluetooth/hci.h
> > index 69ef31cea582..af26e8051905 100644
> > --- a/include/net/bluetooth/hci.h
> > +++ b/include/net/bluetooth/hci.h
> > @@ -265,6 +265,13 @@ enum {
> >        * runtime suspend, because event filtering takes place there.
> >        */
> >       HCI_QUIRK_BROKEN_FILTER_CLEAR_ALL,
> > +
> > +     /* When this quirk is set, max_page for local extended features
> > +      * is set to 1, even if controller reports higher number. Some
> > +      * controllers (e.g. RTL8723CS) report more pages, but they
> > +      * don't actually support features declared there.
> > +      */
> > +     HCI_QUIRK_BROKEN_LOCAL_EXT_FTR_MAX_PAGE,
> > };
>
> Can we just call it _BROKEN_LOCAL_EXT_FEATURES_PAGE_2.
>
> Now with that said, is Secure Connections really broken? We need that bit to indicate support for this.

I don't really see the point in testing any 4.1 features if the chip
vendor claims that they are broken.

I understand your intention to get the max out of the hardware, but it
doesn't look like a good idea to me to use something that the vendor
claims to be broken.

Regards,
Vasily

> Regards
>
> Marcel
>
