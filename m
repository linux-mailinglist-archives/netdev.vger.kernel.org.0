Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 468E6496646
	for <lists+netdev@lfdr.de>; Fri, 21 Jan 2022 21:19:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232921AbiAUUTs convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Fri, 21 Jan 2022 15:19:48 -0500
Received: from coyote.holtmann.net ([212.227.132.17]:43358 "EHLO
        mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229947AbiAUUTr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Jan 2022 15:19:47 -0500
Received: from smtpclient.apple (p4fefca45.dip0.t-ipconnect.de [79.239.202.69])
        by mail.holtmann.org (Postfix) with ESMTPSA id A2BB9CED18;
        Fri, 21 Jan 2022 21:19:45 +0100 (CET)
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 15.0 \(3693.40.0.1.81\))
Subject: Re: [PATCH 26/31] net: bluetooth: changing LED_* from enum
 led_brightness to actual value
From:   Marcel Holtmann <marcel@holtmann.org>
In-Reply-To: <20220121165436.30956-27-sampaio.ime@gmail.com>
Date:   Fri, 21 Jan 2022 21:19:45 +0100
Cc:     Johan Hedberg <johan.hedberg@gmail.com>,
        Luiz Augusto von Dentz <luiz.dentz@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org,
        linux-bluetooth@vger.kernel.org, netdev@vger.kernel.org
Content-Transfer-Encoding: 8BIT
Message-Id: <AB5BDE93-D298-4EB8-91FA-634910C86308@holtmann.org>
References: <20220121165436.30956-1-sampaio.ime@gmail.com>
 <20220121165436.30956-27-sampaio.ime@gmail.com>
To:     Luiz Sampaio <sampaio.ime@gmail.com>
X-Mailer: Apple Mail (2.3693.40.0.1.81)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Luiz,

> The enum led_brightness, which contains the declaration of LED_OFF,
> LED_ON, LED_HALF and LED_FULL is obsolete, as the led class now supports
> max_brightness.
> ---
> net/bluetooth/leds.c | 6 +++---
> 1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/net/bluetooth/leds.c b/net/bluetooth/leds.c
> index f46847632ffa..7f7e3eed9407 100644
> --- a/net/bluetooth/leds.c
> +++ b/net/bluetooth/leds.c
> @@ -22,7 +22,7 @@ void hci_leds_update_powered(struct hci_dev *hdev, bool enabled)
> {
> 	if (hdev->power_led)
> 		led_trigger_event(hdev->power_led,
> -				  enabled ? LED_FULL : LED_OFF);
> +				  enabled ? 255 : 0);
> 
> 	if (!enabled) {
> 		struct hci_dev *d;
> @@ -37,7 +37,7 @@ void hci_leds_update_powered(struct hci_dev *hdev, bool enabled)
> 		read_unlock(&hci_dev_list_lock);
> 	}
> 
> -	led_trigger_event(bt_power_led_trigger, enabled ? LED_FULL : LED_OFF);
> +	led_trigger_event(bt_power_led_trigger, enabled ? 255 : 0);
> }
> 
> static int power_activate(struct led_classdev *led_cdev)
> @@ -48,7 +48,7 @@ static int power_activate(struct led_classdev *led_cdev)
> 	htrig = to_hci_basic_led_trigger(led_cdev->trigger);
> 	powered = test_bit(HCI_UP, &htrig->hdev->flags);
> 
> -	led_trigger_event(led_cdev->trigger, powered ? LED_FULL : LED_OFF);
> +	led_trigger_event(led_cdev->trigger, powered ? 255 : 0);

how is this leading to more readable code?

What is wrong with providing proper constants to use instead of funky numbers now. I
think that changing every user of LED_FULL etc. and replacing it with 255 is stupid.

Seriously, add a #define LED_FULL 255 and leave the users alone.

Regards

Marcel

