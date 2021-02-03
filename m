Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B814430D268
	for <lists+netdev@lfdr.de>; Wed,  3 Feb 2021 05:20:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232483AbhBCEQD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Feb 2021 23:16:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36224 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232415AbhBCEQC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Feb 2021 23:16:02 -0500
Received: from mail-pg1-x52c.google.com (mail-pg1-x52c.google.com [IPv6:2607:f8b0:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F27EDC061786
        for <netdev@vger.kernel.org>; Tue,  2 Feb 2021 20:15:21 -0800 (PST)
Received: by mail-pg1-x52c.google.com with SMTP id z21so16403080pgj.4
        for <netdev@vger.kernel.org>; Tue, 02 Feb 2021 20:15:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:user-agent:in-reply-to:references:mime-version
         :content-transfer-encoding:subject:to:cc:from:message-id;
        bh=ntZZuB4lNRdlEmA1QwdGzboawIbLKUN51trQnhnQNhU=;
        b=Sdc3sNaWQ52HnnDoOGP/5HG0j4k/oLV2QwXxTRbqVZHOtpRufdZ9YVNfKRwqPJ3sAl
         gl1mKpAJHwtmWWQ1+u2oESPzTxoLy1NKUwGfKm+YbvKBJoPGBldUDm/a/Hd6bUZwutIk
         4wyCHArpvAglGApXB4CrLwMnX/64gcwqslmzB1B2MFvwdmNldfDZa7H8qPSsXL7XBxZ4
         Tl3sLKVaBOL8JeVT/Mvypx18RqLsLMILZklVdyfJLpjltOhknEw3uIPTr3zljLJXuXkU
         f4SwUl0wT4p+diG2DXUdWDSeE+ZxSVH7k8AFTDQOkakNMzto46wXUya2vJGONAMmK2LK
         9pbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:user-agent:in-reply-to:references
         :mime-version:content-transfer-encoding:subject:to:cc:from
         :message-id;
        bh=ntZZuB4lNRdlEmA1QwdGzboawIbLKUN51trQnhnQNhU=;
        b=Dm+vxepkcEtFnzBbOMj3hicUQZTB4NkW6+sgjcuERwwKA+XvTXKVxTRFhwftAgmEkm
         12MugwklmSdwVpcA4zofywRnSD3r4PGT/6qppy90KPJEaYgCqvQjS1pLOi8QIBGRVNro
         wbxIT0yLnJxpreoDTdlMS2+aO01FeLrO00IMrqsb2REYHGBfvwYq5enUEnPyp1wv15bu
         1jA70ntqCzOC83h/OJnsLHGwKgmPCZP0WJw/3CfZceu4DuY8miHKM5xq5QtGIv879qvw
         9Em1x1JQxtefCpMqooJ7ZbMZ7tvRuCV6L/332cbMmYPHrz7nOqtFRRAbNDuDr6Fm/w2E
         CYAA==
X-Gm-Message-State: AOAM530q3oVJ22+pHSG0d7Gt049g9dThHAjTcCDg5NZXzH9fdTdyvGPS
        nLCko5TRFAS8yQ0u3ZgHVxQ/
X-Google-Smtp-Source: ABdhPJztdID0w8dWehyys/UHBYBMqIoU4AGL99x/xmLaUN6co6J8MOQwa53NtiNdTj7MLlr83yR5KQ==
X-Received: by 2002:a63:5351:: with SMTP id t17mr1499848pgl.176.1612325721421;
        Tue, 02 Feb 2021 20:15:21 -0800 (PST)
Received: from ?IPv6:2409:4072:619f:ff99:700b:51f3:e28:b00? ([2409:4072:619f:ff99:700b:51f3:e28:b00])
        by smtp.gmail.com with ESMTPSA id p15sm477148pfn.172.2021.02.02.20.15.19
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 02 Feb 2021 20:15:20 -0800 (PST)
Date:   Wed, 03 Feb 2021 09:45:06 +0530
User-Agent: K-9 Mail for Android
In-Reply-To: <20210202201008.274209f9@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
References: <1609958656-15064-1-git-send-email-hemantk@codeaurora.org> <20210113152625.GB30246@work> <YBGDng3VhE1Yw6zt@kroah.com> <20210201105549.GB108653@thinkpad> <YBfi573Bdfxy0GBt@kroah.com> <20210201121322.GC108653@thinkpad> <20210202042208.GB840@work> <20210202201008.274209f9@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable
Subject: Re: [RESEND PATCH v18 0/3] userspace MHI client interface driver
To:     Jakub Kicinski <kuba@kernel.org>
CC:     Greg KH <gregkh@linuxfoundation.org>, davem@davemloft.net,
        linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org,
        jhugo@codeaurora.org, bbhatt@codeaurora.org,
        loic.poulain@linaro.org, netdev@vger.kernel.org
From:   Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Message-ID: <835B2E08-7B84-4A02-B82F-445467D69083@linaro.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Jakub,=20

On 3 February 2021 9:40:08 AM IST, Jakub Kicinski <kuba@kernel=2Eorg> wrot=
e:
>On Tue, 2 Feb 2021 09:52:08 +0530 Manivannan Sadhasivam wrote:
>> > > I don't see the connection here, sorry=2E
>> >=20
>> > For instance USB_NET_CDC_MBIM driver creates the /dev/cdc-wdmX
>chardev node for
>> > configuring the modems which supports MBIM protocol over USB=2E Like
>that, this
>> > driver creates /dev/mhiX_MBIM chardev node for configuring the
>modem over MHI
>> > bus instead of USB=2E The question arised why we are creating a
>chardev node for
>> > each supported configuration (channels in the case of MHI) and why
>can't we use
>> > the existing /dev/cdc-wdmZ interfaces? The anwser is there is no
>standard
>> > subsystem for WWAN and all the drivers represent a chardev which
>gets used by
>> > the userspace tools such a Network manager for establishing
>connection=2E
>> >=20
>> > And /dev/cdc-wdmX is restricted to the USB CDC devices=2E
>> >=20
>> > Hope this clarifies!
>>=20
>> Jakub, Dave, Adding you both to get your reviews on this series=2E I've
>> provided an explanation above and in the previous iteration [1]=2E
>
>Let's be clear what the review would be for=2E Yet another QMI chardev=20
>or the "UCI" direct generic user space to firmware pipe?

The current patchset only supports QMI channel so I'd request you to revie=
w the chardev node created for it=2E The QMI chardev node created will be u=
nique for the MHI bus and the number of nodes depends on the MHI controller=
s in the system (typically 1 but not limited)=2E=20

Thanks,=20
Mani

--=20
Sent from my Android device with K-9 Mail=2E Please excuse my brevity=2E
