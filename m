Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 62F0E4CB062
	for <lists+netdev@lfdr.de>; Wed,  2 Mar 2022 21:58:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244842AbiCBU7I (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Mar 2022 15:59:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40746 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232801AbiCBU7I (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Mar 2022 15:59:08 -0500
Received: from mail-yw1-x1129.google.com (mail-yw1-x1129.google.com [IPv6:2607:f8b0:4864:20::1129])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 668D7D2050;
        Wed,  2 Mar 2022 12:58:24 -0800 (PST)
Received: by mail-yw1-x1129.google.com with SMTP id 00721157ae682-2dbfe58670cso33061237b3.3;
        Wed, 02 Mar 2022 12:58:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=gUqcADQZPQvyqaonjnYhl1TaoPMyKV8P7rze27ZP3KI=;
        b=N5hUOPiLewMUCD+5KaZBMFUn/haOQVDaN2+TFsgiefTgfSDB3L0BGarLhWkc3S3e6R
         hSaSRV2kSmo2m2GWw0aJ07cybXs2J2cF2RvWIowhPhzEBmvVZ7p5g4YDUzytYOgV0bsu
         aGafKhgfGfEdHlszoLI2vpItjmasBo6wNfuoRH968Z8To3WUqKyos+4fppD1hCZckv+8
         d6BtmIXTWZdfrnXXjKMUmU/nCPIqL0OTGzLtMAEbLh7W6+RJShWDachnrSA1yRwB7cuP
         g28TfoEa9XbBDn7BocwY6DlDEMKrHYBKXR4dJdjY+VQZYC7M0To0hft+yr7OKyAic7u9
         flvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=gUqcADQZPQvyqaonjnYhl1TaoPMyKV8P7rze27ZP3KI=;
        b=FceiW4m0uXcOdfQUIxnVgU2WUgQ3cTIBBXXvifDduLgTuQ/KCNmxKUT7Jd51RdHmSR
         apNX2aWMSZUxmZyNaL2tdDh3vV1mPDIVBoiktpos+LYfd18bLlD58P/9iV36Hh78lHv6
         EW69eV5gJb50uhwInXluJZixyXpSZ8Nx3fx1fytLtjn2eFv9B4kAjMDCW0oMdCZ7X+KA
         srg6uXJhGh7eQUA71FUU5zasLSO3avXVFQePXoqyKZO5cvwhg/p5+DQLbEtbNVXN/l8q
         Fn4xFbOHhrUD4dvMB+K52vGCki5EdGfjayAGvr6pjpXZJUw2CQQ9YTnxOsXq3wNyRTxK
         uKmQ==
X-Gm-Message-State: AOAM531pu54OjCCPzm9Yyb4oCR5/VLvjLVBQfyERnlYh6WiSLQk15cQu
        i0LPoXF/8s2Tg2qhxvZdqv6k3W+3vbFcFcDOpEhGpob2vAk=
X-Google-Smtp-Source: ABdhPJyhnP/LKgkQf+hwmnQFbFT/ZhPe40O2TgJ+0PIiJBYrw0Hr8AGUZNoc/OSbiGZUEN7gVRf9rsSVpJ0Uk7OiJ2M=
X-Received: by 2002:a81:6357:0:b0:2d7:2af4:6e12 with SMTP id
 x84-20020a816357000000b002d72af46e12mr31920195ywb.317.1646254703556; Wed, 02
 Mar 2022 12:58:23 -0800 (PST)
MIME-Version: 1.0
References: <20220302183515.448334-1-caleb.connolly@linaro.org> <21F7790B-8849-4131-AF09-4E622B1A9E9D@holtmann.org>
In-Reply-To: <21F7790B-8849-4131-AF09-4E622B1A9E9D@holtmann.org>
From:   Luiz Augusto von Dentz <luiz.dentz@gmail.com>
Date:   Wed, 2 Mar 2022 12:58:12 -0800
Message-ID: <CABBYNZJPN6o-v2OpAXND0+UfwB3AQL2=r6CDQ0S8PktWZqijMw@mail.gmail.com>
Subject: Re: [PATCH v2] bluetooth: hci_event: don't print an error on vendor events
To:     Marcel Holtmann <marcel@holtmann.org>
Cc:     Caleb Connolly <caleb.connolly@linaro.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "linux-bluetooth@vger.kernel.org" <linux-bluetooth@vger.kernel.org>,
        "open list:NETWORKING [GENERAL]" <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-arm-msm@vger.kernel.org
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

Hi Marcel, Caleb,

On Wed, Mar 2, 2022 at 11:20 AM Marcel Holtmann <marcel@holtmann.org> wrote:
>
> Hi Caleb,
>
> > Since commit 3e54c5890c87 ("Bluetooth: hci_event: Use of a function table to handle HCI events"),
> > some devices see warnings being printed for vendor events, e.g.
> >
> > [   75.806141] Bluetooth: hci0: setting up wcn399x
> > [   75.948311] Bluetooth: hci0: unexpected event 0xff length: 14 > 0
> > [   75.955552] Bluetooth: hci0: QCA Product ID   :0x0000000a
> > [   75.961369] Bluetooth: hci0: QCA SOC Version  :0x40010214
> > [   75.967417] Bluetooth: hci0: QCA ROM Version  :0x00000201
> > [   75.973363] Bluetooth: hci0: QCA Patch Version:0x00000001
> > [   76.000289] Bluetooth: hci0: QCA controller version 0x02140201
> > [   76.006727] Bluetooth: hci0: QCA Downloading qca/crbtfw21.tlv
> > [   76.986850] Bluetooth: hci0: unexpected event 0xff length: 3 > 0
> > [   77.013574] Bluetooth: hci0: QCA Downloading qca/oneplus6/crnv21.bin
> > [   77.024302] Bluetooth: hci0: unexpected event 0xff length: 3 > 0
> > [   77.032681] Bluetooth: hci0: unexpected event 0xff length: 3 > 0
> > [   77.040674] Bluetooth: hci0: unexpected event 0xff length: 3 > 0
> > [   77.049251] Bluetooth: hci0: unexpected event 0xff length: 3 > 0
> > [   77.057997] Bluetooth: hci0: unexpected event 0xff length: 3 > 0
> > [   77.066320] Bluetooth: hci0: unexpected event 0xff length: 3 > 0
> > [   77.075065] Bluetooth: hci0: unexpected event 0xff length: 3 > 0
> > [   77.083073] Bluetooth: hci0: unexpected event 0xff length: 3 > 0
> > [   77.091250] Bluetooth: hci0: unexpected event 0xff length: 3 > 0
> > [   77.099417] Bluetooth: hci0: unexpected event 0xff length: 3 > 0
> > [   77.110166] Bluetooth: hci0: unexpected event 0xff length: 3 > 0
> > [   77.118672] Bluetooth: hci0: unexpected event 0xff length: 3 > 0
> > [   77.127449] Bluetooth: hci0: unexpected event 0xff length: 3 > 0
> > [   77.137190] Bluetooth: hci0: unexpected event 0xff length: 3 > 0
> > [   77.146192] Bluetooth: hci0: unexpected event 0xff length: 3 > 0
> > [   77.154242] Bluetooth: hci0: unexpected event 0xff length: 3 > 0
> > [   77.163183] Bluetooth: hci0: unexpected event 0xff length: 3 > 0
> > [   77.171202] Bluetooth: hci0: unexpected event 0xff length: 3 > 0
> > [   77.179364] Bluetooth: hci0: unexpected event 0xff length: 3 > 0
> > [   77.187259] Bluetooth: hci0: unexpected event 0xff length: 3 > 0
> > [   77.198451] Bluetooth: hci0: QCA setup on UART is completed
> >
> > Avoid printing the event length warning for vendor events, this reverts
> > to the previous behaviour where such warnings weren't printed.
> >
> > Fixes: 3e54c5890c87 ("Bluetooth: hci_event: Use of a function table to handle HCI events")
> > Signed-off-by: Caleb Connolly <caleb.connolly@linaro.org>
> > ---
> > Changes since v1:
> > * Don't return early! Vendor events still get parsed despite the
> >   warning. I should have looked a little more closely at that...
> > ---
> > net/bluetooth/hci_event.c | 2 +-
> > 1 file changed, 1 insertion(+), 1 deletion(-)
>
> patch has been applied to bluetooth-stable tree.
>
> Regards
>
> Marcel

I believe a proper fix has already been pushed to bluetooth-next:

https://git.kernel.org/pub/scm/linux/kernel/git/bluetooth/bluetooth-next.git/commit/?id=314d8cd2787418c5ac6b02035c344644f47b292b

HCI_EV_VENDOR shall be assumed to be variable length and that also
uses bt_dev_warn_ratelimited to avoid spamming the logs in case it
still fails.

-- 
Luiz Augusto von Dentz
