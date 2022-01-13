Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2916A48DF2A
	for <lists+netdev@lfdr.de>; Thu, 13 Jan 2022 21:46:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234616AbiAMUqz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Jan 2022 15:46:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37356 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230515AbiAMUqz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Jan 2022 15:46:55 -0500
Received: from mail-yb1-xb36.google.com (mail-yb1-xb36.google.com [IPv6:2607:f8b0:4864:20::b36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 182D5C061574;
        Thu, 13 Jan 2022 12:46:55 -0800 (PST)
Received: by mail-yb1-xb36.google.com with SMTP id 66so3575867ybf.4;
        Thu, 13 Jan 2022 12:46:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=tc4bxrdsSda67cQFkrLy1YQGDEwzONREQeowDYF99lg=;
        b=MeYw7As0Uuxhnn4BTl5ziXrnvOGnueayzjx+JgreS+F52AGzWmnC/Nab14WQjBkA4s
         aMZKV2jVn9yOGUmjS4yic+HKdijStb/tEwpE2rxLPqvCdhe703O2sF6cNeZYfI5y4v2S
         xMDws6mlLB57/0uNJf0zyj+XSUCCRcmfiNGufny0SGcQkURzxqXyXu9uZsPiJ8iP1AZG
         zPtZVJNzrNiYDXqhCbuwClj05HOoTrGolFLWIAXyyQIMcWvLXY/UhsXEux81meSAsyWC
         105QtUdrC7eYMUSGF4fdQQ1ZjhFdnY7AoUTTAn5uzlVJUw21QaNP9qzekRZd/h8HcNjq
         uW0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=tc4bxrdsSda67cQFkrLy1YQGDEwzONREQeowDYF99lg=;
        b=ZdkAu2DsI/9AS0IMF8Vl5IQ4rGvggOMfYrG8EMUCoh9DWTgZIn5OADrCoii7qvrw8Y
         vEsnB9NSLTUXgh7rzSMFmY66f29wYpPMAQJfLKwVcmkF2lX+DVwzPZJ6nCBysLgreLr2
         jgRjvcJJhs7viebfRF9E1UkSIzFsCqy6yQ3YzyTrVipR9cHMvOkSMfD7e4YIJLYpUGcr
         w492wbXE4sMEuBIQNkH8SB0evJrUmQkaTq0MesbtEibeTYMoW222tyxMwGqPneIuBETT
         eWk94HHkIdhGxkp315KUwfE0VvGAuu2SDf+wHKD63b9/+SRpsPzJNKKkUbgK7Tqt6v2+
         5zjw==
X-Gm-Message-State: AOAM530UFdCjkMX5qAbzI4tfgw2sih/iR0APWF6UojQFZ8kWYr6msE2J
        RPI5JdF0HTUskQtW73gOU+eFIkF3Vf6kfqeSPPo=
X-Google-Smtp-Source: ABdhPJz7n3P1HjlOjdK6te/OAZBRlVgx79lCGxCc8EuDaPN9aWmq87rw+LLwg/K6AGBBtGBiCFmRU4mZxAurLwfhP3k=
X-Received: by 2002:a25:7287:: with SMTP id n129mr8260040ybc.351.1642106814153;
 Thu, 13 Jan 2022 12:46:54 -0800 (PST)
MIME-Version: 1.0
References: <20220113164042.259990-1-soenke.huster@eknoes.de>
In-Reply-To: <20220113164042.259990-1-soenke.huster@eknoes.de>
From:   Luiz Augusto von Dentz <luiz.dentz@gmail.com>
Date:   Thu, 13 Jan 2022 12:46:43 -0800
Message-ID: <CABBYNZ+5XxOAEBKXZ1va-G6WNYAL_NQ0Fw3JLckB4zP7wgT3xA@mail.gmail.com>
Subject: Re: [PATCH v2] Bluetooth: fix null ptr deref on hci_sync_conn_complete_evt
To:     Soenke Huster <soenke.huster@eknoes.de>
Cc:     Marcel Holtmann <marcel@holtmann.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "linux-bluetooth@vger.kernel.org" <linux-bluetooth@vger.kernel.org>,
        "open list:NETWORKING [GENERAL]" <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Soenke,

On Thu, Jan 13, 2022 at 8:41 AM Soenke Huster <soenke.huster@eknoes.de> wrote:
>
> This event is specified just for SCO and eSCO link types.
> On the reception of a HCI_Synchronous_Connection_Complete for a BDADDR
> of an existing LE connection, LE link type and a status that triggers the
> second case of the packet processing a NULL pointer dereference happens,
> as conn->link is NULL.
>
> Signed-off-by: Soenke Huster <soenke.huster@eknoes.de>
> ---
> v2: Fixed the obviously wrong boolean comparison
>
> I found this null pointer dereference while fuzzing bluetooth-next.
> On the described behaviour, a null ptr deref in line 4723 happens, as
> conn->link is NULL. According to the Core spec, Link_Type must be SCO or eSCO,
> all other values are reserved for future use. Checking that mitigates a null
> pointer dereference.
>
>  net/bluetooth/hci_event.c | 5 +++++
>  1 file changed, 5 insertions(+)
>
> diff --git a/net/bluetooth/hci_event.c b/net/bluetooth/hci_event.c
> index 05997dff5666..d68f5640fb38 100644
> --- a/net/bluetooth/hci_event.c
> +++ b/net/bluetooth/hci_event.c
> @@ -4661,6 +4661,11 @@ static void hci_sync_conn_complete_evt(struct hci_dev *hdev, void *data,
>         struct hci_ev_sync_conn_complete *ev = data;
>         struct hci_conn *conn;
>
> +       if (!(ev->link_type == SCO_LINK || ev->link_type == ESCO_LINK)) {
> +               bt_dev_err(hdev, "Ignoring connect complete event for invalid link type");
> +               return;
> +       }

I rather have this as a switch statement:

switch (ev->link_type)
case SCO_LINK:
case ESCO_LINK:
  break;
default:
  /* Add comment where the spec states this is invalid */
  bt_dev_err(hdev, "Ignoring connect complete event for invalid link type");
  return;

>         bt_dev_dbg(hdev, "status 0x%2.2x", ev->status);
>
>         hci_dev_lock(hdev);
> --
> 2.34.1
>


-- 
Luiz Augusto von Dentz
