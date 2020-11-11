Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C82B72AE7E6
	for <lists+netdev@lfdr.de>; Wed, 11 Nov 2020 06:19:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725981AbgKKFTB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Nov 2020 00:19:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58388 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725468AbgKKFTA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Nov 2020 00:19:00 -0500
Received: from mail-pj1-x1041.google.com (mail-pj1-x1041.google.com [IPv6:2607:f8b0:4864:20::1041])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D0A4C0613D1;
        Tue, 10 Nov 2020 21:19:00 -0800 (PST)
Received: by mail-pj1-x1041.google.com with SMTP id gi3so117821pjb.3;
        Tue, 10 Nov 2020 21:19:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=byqajXR51Bxrm2nLNt/skWT4Wzt+z9y1BMUZtfwxw1M=;
        b=TmomcJ3VO/TDdcQd7AqeVYVGrS3mo7rk8oLienr/ePQg5etHVT11FwlvRQoFvdNXOr
         S9P6kq16Cou+eFFSG34H7D66aSKoUQ+cJ13H7bgzHoXPhZWI0933A3fnozo9nXJAuLJu
         sy+g/h8kz5e444vH54MIRt8pCfgaDASD9+15xea7qcCoOZkU2EUtrMqlCV7Ph2jJtpqk
         X1aMuZnZvsZ41CMIU0eaou3n3ytWHSx0bKhXqPPRDO1GXJioA/Zy5DkufFXYYe4iTl5X
         VaWq1WNTxH/S1aNHXvKKppJ+JQzmvWMb8ow6mhHqkvqpknNxKmiG7A6LPSG0AEnnyKuy
         nb6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=byqajXR51Bxrm2nLNt/skWT4Wzt+z9y1BMUZtfwxw1M=;
        b=m4DA2+XQpOLLP37dxPpC9QndRjaukKF1yQT9I9KX3B5BlpzFdCd9eoKgXw8Q1t0nB4
         U/pYqRvgUrViSxTxcURfIon79abj6rLBQ66TK0ikhUjXJOq4rzcGZWY5EfGb/M74M+eM
         H5RZALCGwqkdofkYzz2iC4k7sHJEJN8mS5wXhqJBywvG+VZIemhN8/EEJf44MO32oysk
         q4H77JS9n34F/2JaNRiJGs6tyrRCWV68B6kzCg20RJFWXM6CR2WMICXpspE8SMEAb7I5
         nE17PQAV2X9mIGuqjYCfHA7LF4DTllGGMjJNSL7lHW/PdI+u+VvftMk31yMtfsfEDWIa
         8IoA==
X-Gm-Message-State: AOAM5321BYAs30UcADCFTB0rdJRgMRZFgO/Uwd7laYRYlvSrrJEVL1Ug
        nDsTACu+FBD3/B6AXt/49g==
X-Google-Smtp-Source: ABdhPJwzGr917BcjGZvnhF8M3M9oj/mD9MB7UdcXUskYUWvjxFIwl/G5As2je433FOGzXbhd2T6VIA==
X-Received: by 2002:a17:902:6545:b029:d6:9a59:800d with SMTP id d5-20020a1709026545b02900d69a59800dmr19714495pln.31.1605071939945;
        Tue, 10 Nov 2020 21:18:59 -0800 (PST)
Received: from PWN (59-125-13-244.HINET-IP.hinet.net. [59.125.13.244])
        by smtp.gmail.com with ESMTPSA id s17sm801768pjr.56.2020.11.10.21.18.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Nov 2020 21:18:59 -0800 (PST)
Date:   Wed, 11 Nov 2020 00:18:52 -0500
From:   Peilin Ye <yepeilin.cs@gmail.com>
To:     Marcel Holtmann <marcel@holtmann.org>
Cc:     Johan Hedberg <johan.hedberg@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Bluez mailing list <linux-bluetooth@vger.kernel.org>,
        "open list:NETWORKING [GENERAL]" <netdev@vger.kernel.org>,
        linux-kernel-mentees@lists.linuxfoundation.org,
        linux-kernel@vger.kernel.org
Subject: Re: [Linux-kernel-mentees] [PATCH net v2] Bluetooth: Fix
 slab-out-of-bounds read in hci_le_direct_adv_report_evt()
Message-ID: <20201111051852.GA2491141@PWN>
References: <20200805180902.684024-1-yepeilin.cs@gmail.com>
 <20200909071700.1100748-1-yepeilin.cs@gmail.com>
 <AF20F58E-C800-45A8-A5B8-296DE4C0D906@holtmann.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AF20F58E-C800-45A8-A5B8-296DE4C0D906@holtmann.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 09, 2020 at 01:16:53PM +0100, Marcel Holtmann wrote:
> Hi Peilin,
> 
> > `num_reports` is not being properly checked. A malformed event packet with
> > a large `num_reports` number makes hci_le_direct_adv_report_evt() read out
> > of bounds. Fix it.
> > 
> > Cc: stable@vger.kernel.org
> > Fixes: 2f010b55884e ("Bluetooth: Add support for handling LE Direct Advertising Report events")
> > Reported-and-tested-by: syzbot+24ebd650e20bd263ca01@syzkaller.appspotmail.com
> > Link: https://syzkaller.appspot.com/bug?extid=24ebd650e20bd263ca01
> > Signed-off-by: Peilin Ye <yepeilin.cs@gmail.com>
> > ---
> > Change in v2:
> >    - add "Cc: stable@" tag.
> > 
> > net/bluetooth/hci_event.c | 12 +++++-------
> > 1 file changed, 5 insertions(+), 7 deletions(-)
> > 
> > diff --git a/net/bluetooth/hci_event.c b/net/bluetooth/hci_event.c
> > index 4b7fc430793c..aec43ae488d1 100644
> > --- a/net/bluetooth/hci_event.c
> > +++ b/net/bluetooth/hci_event.c
> > @@ -5863,21 +5863,19 @@ static void hci_le_direct_adv_report_evt(struct hci_dev *hdev,
> > 					 struct sk_buff *skb)
> > {
> > 	u8 num_reports = skb->data[0];
> > -	void *ptr = &skb->data[1];
> > +	struct hci_ev_le_direct_adv_info *ev = (void *)&skb->data[1];
> > 
> > -	hci_dev_lock(hdev);
> > +	if (!num_reports || skb->len < num_reports * sizeof(*ev) + 1)
> > +		return;
> > 
> > -	while (num_reports--) {
> > -		struct hci_ev_le_direct_adv_info *ev = ptr;
> > +	hci_dev_lock(hdev);
> > 
> > +	for (; num_reports; num_reports--, ev++)
> > 		process_adv_report(hdev, ev->evt_type, &ev->bdaddr,
> > 				   ev->bdaddr_type, &ev->direct_addr,
> > 				   ev->direct_addr_type, ev->rssi, NULL, 0,
> > 				   false);
> > 
> > -		ptr += sizeof(*ev);
> > -	}
> > -
> > 	hci_dev_unlock(hdev);
> > }
> 
> patch has been applied to bluetooth-next tree.

Thank you for reviewing it,

Peilin Ye

