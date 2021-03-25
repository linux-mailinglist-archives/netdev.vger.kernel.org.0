Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 04B1B349801
	for <lists+netdev@lfdr.de>; Thu, 25 Mar 2021 18:28:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229695AbhCYR15 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Mar 2021 13:27:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33884 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229904AbhCYR1k (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Mar 2021 13:27:40 -0400
Received: from mail-ua1-x929.google.com (mail-ua1-x929.google.com [IPv6:2607:f8b0:4864:20::929])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4722DC06174A
        for <netdev@vger.kernel.org>; Thu, 25 Mar 2021 10:27:40 -0700 (PDT)
Received: by mail-ua1-x929.google.com with SMTP id y20so548833uay.6
        for <netdev@vger.kernel.org>; Thu, 25 Mar 2021 10:27:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=QgkxSr19crUcuKV0Y7vHL51/ZmHB1IOYhrLsu7x2u+M=;
        b=fpppswW5sjQ0PNHpnrEF0gXS5Y7pqnbqlTnn8Nwc4mHc9ysQy/se4keqYeJdysfK8D
         RLEssYesQsu8hHQ6HRmDaqMPYjv/zTh48E7s9LgupkSpRg21/jF+MY31c6gYjOPihPDL
         dP61hJntHpUfFcxQ4C3bbRhdDJEiHCFjixwlNMLzRDmrZIlN4161If9mXUViXoQFVl2Y
         txQiZb5bduKvEdwTn+l8gcYh7fSLMZFn4nwHZ+OAkD3juwpIxgiP1BsYEBY3aazIWhyi
         PVwdVlXXKTKuOphLKovJqf9M/u5A3n/0tj8CV0zLLl4kXuGL/CJrBSGDQFO7YfoKZMBV
         15jg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=QgkxSr19crUcuKV0Y7vHL51/ZmHB1IOYhrLsu7x2u+M=;
        b=GO+x/XRMYPsQbClOgllKA7joWqWzRaLVbQvdCmcu7NK2bA1UqBxSxF083Lhbiz9g2g
         w3m1FcGTZZa70iDh2Pz7Hgx932TTMH/YWGdwbyBcbHOjLnVgQx7ScU6Ch0TgXRXdvdkH
         4s0GiUkNyc4RiuLGmxOUnutngJXHwxTjpxazhG+RI8KgnlBApSQOMbtrMJe4UDehwY2J
         3dS0EsGo0lvogXN2ihbWbam7nAu7BxFzkrPUq9Ar+jlb5T3zq/bn94kl85rWjVVqZ/NQ
         +tO5EtGRR6cRYnJLYRysXKoQPQxktEEmAeq1Z8F6MFji27PVegg2LiYIzTWD/8yONSM3
         cD+Q==
X-Gm-Message-State: AOAM530pxplFvngGzCzK/3pQvcEe+DhuiHIKDbkUtoT04Rf6YmO/qF8J
        1BrgT54xwIgc0nIHXD6m/h8o4RGe+AlbKWpQAUDFTg==
X-Google-Smtp-Source: ABdhPJzY34MCCLvJpTtA7nRIYsKpdCkz5VWQ8fUCzQQcfXOekMIbohBhClAAwgRUsn1Q0xcxl0wm2cOuCrysh9Nx/YY=
X-Received: by 2002:ab0:45e1:: with SMTP id u88mr5706634uau.25.1616693258759;
 Thu, 25 Mar 2021 10:27:38 -0700 (PDT)
MIME-Version: 1.0
References: <20210324114645.v2.1.I53e6be1f7df0be198b7e55ae9fc45c7f5760132d@changeid>
In-Reply-To: <20210324114645.v2.1.I53e6be1f7df0be198b7e55ae9fc45c7f5760132d@changeid>
From:   Daniel Winkler <danielwinkler@google.com>
Date:   Thu, 25 Mar 2021 10:27:27 -0700
Message-ID: <CAP2xMbvooqbwpVUWzLOTBt55ob1R-kZ80OPd8r4K0mQVrQP7kA@mail.gmail.com>
Subject: Re: [PATCH v2] Bluetooth: Always call advertising disable before
 setting params
To:     BlueZ <linux-bluetooth@vger.kernel.org>
Cc:     chromeos-bluetooth-upstreaming 
        <chromeos-bluetooth-upstreaming@chromium.org>,
        Miao-chen Chou <mcchou@chromium.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        Luiz Augusto von Dentz <luiz.dentz@gmail.com>,
        Marcel Holtmann <marcel@holtmann.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "open list:NETWORKING [GENERAL]" <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi all,

It looks like my change breaks the expectations of one mgmt-tester
test, which uses an Adv Enable (True) as a test condition. It is
surprised to first see an Adv Enable (False) in the HCI traffic, and
fails. I think my suggested approach here is the simplest and most
robust to solve this race condition, so if the maintainers are happy
with it, I can look into changing the test expectations to suit the
new scenario. Please advise.

Thanks in advance,
Daniel

On Wed, Mar 24, 2021 at 11:47 AM Daniel Winkler
<danielwinkler@google.com> wrote:
>
> In __hci_req_enable_advertising, the HCI_LE_ADV hdev flag is temporarily
> cleared to allow the random address to be set, which exposes a race
> condition when an advertisement is configured immediately (<10ms) after
> software rotation starts to refresh an advertisement.
>
> In normal operation, the HCI_LE_ADV flag is updated as follows:
>
> 1. adv_timeout_expire is called, HCI_LE_ADV gets cleared in
>    __hci_req_enable_advertising, but hci_req configures an enable
>    request
> 2. hci_req is run, enable callback re-sets HCI_LE_ADV flag
>
> However, in this race condition, the following occurs:
>
> 1. adv_timeout_expire is called, HCI_LE_ADV gets cleared in
>    __hci_req_enable_advertising, but hci_req configures an enable
>    request
> 2. add_advertising is called, which also calls
>    __hci_req_enable_advertising. Because HCI_LE_ADV was cleared in Step
>    1, no "disable" command is queued.
> 3. hci_req for adv_timeout_expire is run, which enables advertising and
>    re-sets HCI_LE_ADV
> 4. hci_req for add_advertising is run, but because no "disable" command
>    was queued, we try to set advertising parameters while advertising is
>    active, causing a Command Disallowed error, failing the registration.
>
> To resolve the issue, this patch removes the check for the HCI_LE_ADV
> flag, and always queues the "disable" request, since HCI_LE_ADV could be
> very temporarily out-of-sync. According to the spec, there is no harm in
> calling "disable" when advertising is not active.
>
> An example trace showing the HCI error in setting advertising parameters
> is included below, with some notes annotating the states I mentioned
> above:
>
> @ MGMT Command: Add Ext Adv.. (0x0055) plen 35  {0x0001} [hci0]04:05.884
>         Instance: 3
>         Advertising data length: 24
>         16-bit Service UUIDs (complete): 2 entries
>           Location and Navigation (0x1819)
>           Phone Alert Status Service (0x180e)
>         Company: not assigned (65283)
>           Data: 3a3b3c3d3e
>         Service Data (UUID 0x9993): 3132333435
>         Scan response length: 0
> @ MGMT Event: Advertising Ad.. (0x0023) plen 1  {0x0005} [hci0]04:05.885
>         Instance: 3
>
> === adv_timeout_expire request starts running. This request was created
> before our add advertising request
> > HCI Event: Command Complete (0x0e) plen 4         #220 [hci0]04:05.993
>       LE Set Advertising Data (0x08|0x0008) ncmd 1
>         Status: Success (0x00)
> < HCI Command: LE Set Scan.. (0x08|0x0009) plen 32  #221 [hci0]04:05.993
>         Length: 24
>         Service Data (UUID 0xabcd): 161718191a1b1c1d1e1f2021222324252627
> > HCI Event: Command Complete (0x0e) plen 4         #222 [hci0]04:05.995
>       LE Set Scan Response Data (0x08|0x0009) ncmd 1
>         Status: Success (0x00)
> < HCI Command: LE Set Adver.. (0x08|0x000a) plen 1  #223 [hci0]04:05.995
>         Advertising: Disabled (0x00)
> > HCI Event: Command Complete (0x0e) plen 4         #224 [hci0]04:05.997
>       LE Set Advertise Enable (0x08|0x000a) ncmd 1
>         Status: Success (0x00)
> < HCI Command: LE Set Adve.. (0x08|0x0006) plen 15  #225 [hci0]04:05.997
>         Min advertising interval: 200.000 msec (0x0140)
>         Max advertising interval: 200.000 msec (0x0140)
>         Type: Connectable undirected - ADV_IND (0x00)
>         Own address type: Public (0x00)
>         Direct address type: Public (0x00)
>         Direct address: 00:00:00:00:00:00 (OUI 00-00-00)
>         Channel map: 37, 38, 39 (0x07)
>         Filter policy: Allow Scan Request, Connect from Any (0x00)
> > HCI Event: Command Complete (0x0e) plen 4         #226 [hci0]04:05.998
>       LE Set Advertising Parameters (0x08|0x0006) ncmd 1
>         Status: Success (0x00)
> < HCI Command: LE Set Adver.. (0x08|0x000a) plen 1  #227 [hci0]04:05.999
>         Advertising: Enabled (0x01)
> > HCI Event: Command Complete (0x0e) plen 4         #228 [hci0]04:06.000
>       LE Set Advertise Enable (0x08|0x000a) ncmd 1
>         Status: Success (0x00)
>
> === Our new add_advertising request starts running
> < HCI Command: Read Local N.. (0x03|0x0014) plen 0  #229 [hci0]04:06.001
> > HCI Event: Command Complete (0x0e) plen 252       #230 [hci0]04:06.005
>       Read Local Name (0x03|0x0014) ncmd 1
>         Status: Success (0x00)
>         Name: Chromebook_FB3D
>
> === Although the controller is advertising, no disable command is sent
> < HCI Command: LE Set Adve.. (0x08|0x0006) plen 15  #231 [hci0]04:06.005
>         Min advertising interval: 200.000 msec (0x0140)
>         Max advertising interval: 200.000 msec (0x0140)
>         Type: Connectable undirected - ADV_IND (0x00)
>         Own address type: Public (0x00)
>         Direct address type: Public (0x00)
>         Direct address: 00:00:00:00:00:00 (OUI 00-00-00)
>         Channel map: 37, 38, 39 (0x07)
>         Filter policy: Allow Scan Request, Connect from Any (0x00)
> > HCI Event: Command Complete (0x0e) plen 4         #232 [hci0]04:06.005
>       LE Set Advertising Parameters (0x08|0x0006) ncmd 1
>         Status: Command Disallowed (0x0c)
>
> Reviewed-by: Miao-chen Chou <mcchou@chromium.org>
> Signed-off-by: Daniel Winkler <danielwinkler@google.com>
> ---
>
> Changes in v2:
> - Added btmon snippet showing HCI command failure
>
>  net/bluetooth/hci_request.c | 6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)
>
> diff --git a/net/bluetooth/hci_request.c b/net/bluetooth/hci_request.c
> index 8ace5d34b01efe..2b4b99f4cedf21 100644
> --- a/net/bluetooth/hci_request.c
> +++ b/net/bluetooth/hci_request.c
> @@ -1547,8 +1547,10 @@ void __hci_req_enable_advertising(struct hci_request *req)
>         if (!is_advertising_allowed(hdev, connectable))
>                 return;
>
> -       if (hci_dev_test_flag(hdev, HCI_LE_ADV))
> -               __hci_req_disable_advertising(req);
> +       /* Request that the controller stop advertising. This can be called
> +        * whether or not there is an active advertisement.
> +        */
> +       __hci_req_disable_advertising(req);
>
>         /* Clear the HCI_LE_ADV bit temporarily so that the
>          * hci_update_random_address knows that it's safe to go ahead
> --
> 2.31.0.291.g576ba9dcdaf-goog
>
