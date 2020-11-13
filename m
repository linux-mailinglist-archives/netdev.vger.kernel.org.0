Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ED1812B28B8
	for <lists+netdev@lfdr.de>; Fri, 13 Nov 2020 23:44:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726199AbgKMWoi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Nov 2020 17:44:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52776 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725981AbgKMWoi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Nov 2020 17:44:38 -0500
Received: from mail-oo1-xc42.google.com (mail-oo1-xc42.google.com [IPv6:2607:f8b0:4864:20::c42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E4DF3C0613D1;
        Fri, 13 Nov 2020 14:44:37 -0800 (PST)
Received: by mail-oo1-xc42.google.com with SMTP id h10so974084ooi.10;
        Fri, 13 Nov 2020 14:44:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=M+RKsRTfKbrIPE1hDDxEvgt0KtI4mBFpkqDt+GvcZ7M=;
        b=HkjJtPkC9ifnKgdn63sJtfwNYDRr1fgt08qo4uFQgqXO7UlsdDoKw2C+dYMqL29nPR
         +gjE3TvWcEA80rD0swzAznq3Tb90WsqWz4oNhyDhPjl6uxnrhdCMqwB4n0vv2P/Ywd+B
         IKOpH/dEsRNPYaGl69HWnH/EBPsUWTOS50r8olocR4XF3GBwF/5scK6GkxlU+u9845FA
         WY1XCDuXmxoygT8ldcsbA4un3Wm2zv5JLmmb8aPxcvCHPRwJDx4ceTBo465t+ApCPHHH
         hcckUDj9aZ/ZsnezuQ9mNpaercs9zjOK5r69j6ROWbtXK6NrZHAZHEaNkX9hVsGHFd8y
         WKVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=M+RKsRTfKbrIPE1hDDxEvgt0KtI4mBFpkqDt+GvcZ7M=;
        b=mNipxGGSQWUU2hdW9IBPQ4KrkyI4oEpsvZL1m/Ad6BaSnkjI3Yi1bqQPhEQf8/Dj7T
         w0GLeA3nzx8Q7rtpbXDouVZrLlAlUruKm+QuaesnPLz+mXcDA6JbtECWkta4Ix7BNOSW
         J9r6xiZWBlLuNPsj3TTCbEUGK/xaynjpNOtQsteSetBxHQsCuTGv+gTmYiOh3bQYVL52
         CGCjHtrj+vHUY3Mp6qcTNE1QxTs5r00tJaLAK8VOiyu9KtfvzZiZVYlrH56rxwf/l57B
         KlI7ZCI7H81rzmfwScflSHKpJbpSSh2I9pUyLnQiANqeZDNia5OxsPGf9E32YP3mq3Sb
         sGUw==
X-Gm-Message-State: AOAM5303FWXq24VZt4GBzfPllXbnXwXowXPZA4/18kJ7Tgcor0BpoaYm
        VweOSJqVX3uqFl6RIgeDm3qaEDi1J/n+6WEnUao=
X-Google-Smtp-Source: ABdhPJybAOYAyJFnKqkljlBGO06iJ1cEj58pkH0pNBFAZb0j3GrdRTsiEZ7l5L3gYVZGjR/ewSe0CeRqis2H+V9KRWM=
X-Received: by 2002:a4a:a445:: with SMTP id w5mr3194142ool.63.1605307476652;
 Fri, 13 Nov 2020 14:44:36 -0800 (PST)
MIME-Version: 1.0
References: <20200911153141.RESEND.1.Ib022565452fde0c02fbcf619950ef868715dd243@changeid>
 <A3FDD177-8552-4BDD-941A-0BD8FF495AFE@holtmann.org>
In-Reply-To: <A3FDD177-8552-4BDD-941A-0BD8FF495AFE@holtmann.org>
From:   Luiz Augusto von Dentz <luiz.dentz@gmail.com>
Date:   Fri, 13 Nov 2020 14:44:25 -0800
Message-ID: <CABBYNZKRbE97jXoyvPrA=1WS6ZHFViV5XQfJPRD-jcrB6VOb6A@mail.gmail.com>
Subject: Re: [RESEND PATCH] bluetooth: Set ext scan response only when it exists
To:     Marcel Holtmann <marcel@holtmann.org>
Cc:     Abhishek Pandit-Subedi <abhishekpandit@chromium.org>,
        CrosBT Upstreaming <chromeos-bluetooth-upstreaming@chromium.org>,
        linux-bluetooth <linux-bluetooth@vger.kernel.org>,
        Daniel Winkler <danielwinkler@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        "open list:NETWORKING [GENERAL]" <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Marcel, Abhishek,

On Sun, Sep 13, 2020 at 12:51 AM Marcel Holtmann <marcel@holtmann.org> wrote:
>
> Hi Abhishek,
>
> > Only set extended scan response only when it exists. Otherwise, clear
> > the scan response data.
> >
> > Per the core spec v5.2, Vol 4, Part E, 7.8.55
> >
> > If the advertising set is non-scannable and the Host uses this command
> > other than to discard existing data, the Controller shall return the
> > error code Invalid HCI Command Parameters (0x12).
> >
> > On WCN3991, the controller correctly responds with Invalid Parameters
> > when this is sent.  That error causes __hci_req_hci_power_on to fail
> > with -EINVAL and LE devices can't connect because background scanning
> > isn't configured.
> >
> > Here is an hci trace of where this issue occurs during power on:
> >
> > < HCI Command: LE Set Extended Advertising Parameters (0x08|0x0036) plen 25
> >        Handle: 0x00
> >        Properties: 0x0010
> >          Use legacy advertising PDUs: ADV_NONCONN_IND
> >        Min advertising interval: 181.250 msec (0x0122)
> >        Max advertising interval: 181.250 msec (0x0122)
> >        Channel map: 37, 38, 39 (0x07)
> >        Own address type: Random (0x01)
> >        Peer address type: Public (0x00)
> >        Peer address: 00:00:00:00:00:00 (OUI 00-00-00)
> >        Filter policy: Allow Scan Request from Any, Allow Connect...
> >        TX power: 127 dbm (0x7f)
> >        Primary PHY: LE 1M (0x01)
> >        Secondary max skip: 0x00
> >        Secondary PHY: LE 1M (0x01)
> >        SID: 0x00
> >        Scan request notifications: Disabled (0x00)
> >> HCI Event: Command Complete (0x0e) plen 5
> >      LE Set Extended Advertising Parameters (0x08|0x0036) ncmd 1
> >        Status: Success (0x00)
> >        TX power (selected): 9 dbm (0x09)
> > < HCI Command: LE Set Advertising Set Random Address (0x08|0x0035) plen 7
> >        Advertising handle: 0x00
> >        Advertising random address: 08:FD:55:ED:22:28 (OUI 08-FD-55)
> >> HCI Event: Command Complete (0x0e) plen 4
> >      LE Set Advertising Set Random Address (0x08|0x0035) ncmd
> >        Status: Success (0x00)
> > < HCI Command: LE Set Extended Scan Response Data (0x08|0x0038) plen 35
> >        Handle: 0x00
> >        Operation: Complete scan response data (0x03)
> >        Fragment preference: Minimize fragmentation (0x01)
> >        Data length: 0x0d
> >        Name (short): Chromebook
> >> HCI Event: Command Complete (0x0e) plen 4
> >      LE Set Extended Scan Response Data (0x08|0x0038) ncmd 1
> >        Status: Invalid HCI Command Parameters (0x12)
> >
> > Signed-off-by: Abhishek Pandit-Subedi <abhishekpandit@chromium.org>
> > Reviewed-by: Daniel Winkler <danielwinkler@google.com>
> > ---
> >
> > net/bluetooth/hci_request.c | 7 +++++--
> > 1 file changed, 5 insertions(+), 2 deletions(-)
>
> patch has been applied to bluetooth-next tree.

Look like this breaks the mgmt-tester:

Add Ext Advertising - Success (Complete name)        Timed out    2.648 seconds
Add Ext Advertising - Success (Shortened name)       Timed out    1.993 seconds
Add Ext Advertising - Success (Short name)           Timed out    2.004 seconds

These tests expect the Set Extended Scan Response Data to be send but
it is not and then it times out, the problem seems to be that
get_adv_instance_scan_rsp_len does check for things like include
local-name on instances other than 0, also we probably need to include
some logic to check if the instance is really scannable to begin with.

-- 
Luiz Augusto von Dentz
