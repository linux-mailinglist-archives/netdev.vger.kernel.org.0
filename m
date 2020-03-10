Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 383E417F066
	for <lists+netdev@lfdr.de>; Tue, 10 Mar 2020 07:16:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726199AbgCJGQX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Mar 2020 02:16:23 -0400
Received: from mail-qt1-f193.google.com ([209.85.160.193]:33616 "EHLO
        mail-qt1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725875AbgCJGQX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Mar 2020 02:16:23 -0400
Received: by mail-qt1-f193.google.com with SMTP id d22so8907863qtn.0
        for <netdev@vger.kernel.org>; Mon, 09 Mar 2020 23:16:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=zqMAcVJ3pxiogTCVRmCnWcqLUai74h88UlP3PJcB88Y=;
        b=YKRUbXaTC/WT+6jRST9JO4e43dxrmgDQ6nRbZ4k+nKDaKuMafS7WUMv7N7IdRF4r6M
         8eCMnWjXCczRLC9NMrmvaorG8LTkl4zlOHp7MJlzsdGhK8vghb765zbt3eDmjisqHJZz
         rY0vi5GTxWf7RHioX70bsNPYyQWLzns1wAxqw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=zqMAcVJ3pxiogTCVRmCnWcqLUai74h88UlP3PJcB88Y=;
        b=gXJLXKRqgivON6bOpnrxn7rrlaDG7ZbkIWckJYm+HFqwD2sRFesVIg5KPhXoUNQYcB
         2C+RVFz7RN8wKres4ElUU8IBxNeAYS9LN9bY3vQNx5W1ztRHTh3o3hjxLKuqGoCfgsW6
         rMNrpt+CvHWvs2692KyU7i0bVhjHhTyXQTFWUDuby15Oeb+tc+TJCk1jmBp8VAicYG/M
         IT1uDX4gh8R9muZSMZW172S0lTtfY8J6f/bsv9LOHw7AzVa/0vz5bgKNLBygy4EAfdFE
         /qOHMoQmijeN/U3IFwi8hXF66VKxBsgUZ/NF5lqb76RWxjlR7biCAoq/9jQXDqSRm2V+
         LDlw==
X-Gm-Message-State: ANhLgQ1Jg4vC1gbQ0ZWuU7KN4cHAhJf6p0l2fiwV/0ZaZyiCU66zFD5W
        xY3UPs0IqB9FK93NA52LgBvswedTczlE6DJhjCWR4i79
X-Google-Smtp-Source: ADFU+vuRo9OAYjxJE0Ukal34OU1v8TJg2GBG19jTfkCALSroNTFd2cCA3F8A6KOru57kudUguZcG53aFfeEV5kUFfWc=
X-Received: by 2002:aed:3c4b:: with SMTP id u11mr8366757qte.208.1583820981960;
 Mon, 09 Mar 2020 23:16:21 -0700 (PDT)
MIME-Version: 1.0
References: <20200310021512.1861626-1-kuba@kernel.org> <20200310021512.1861626-8-kuba@kernel.org>
In-Reply-To: <20200310021512.1861626-8-kuba@kernel.org>
From:   Michael Chan <michael.chan@broadcom.com>
Date:   Mon, 9 Mar 2020 23:16:09 -0700
Message-ID: <CACKFLinc0sTPBbroBgxvo9jcWjwGSOp20x2Amdwd4-UebZJbEw@mail.gmail.com>
Subject: Re: [PATCH net-next 07/15] net: tg3: reject unsupported coalescing params
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     David Miller <davem@davemloft.net>,
        Netdev <netdev@vger.kernel.org>, akiyano@amazon.com,
        netanel@amazon.com, gtzalik@amazon.com, irusskikh@marvell.com,
        Florian Fainelli <f.fainelli@gmail.com>,
        bcm-kernel-feedback-list <bcm-kernel-feedback-list@broadcom.com>,
        Rasesh Mody <rmody@marvell.com>, GR-Linux-NIC-Dev@marvell.com,
        aelior@marvell.com, skalluru@marvell.com,
        GR-everest-linux-l2@marvell.com, opendmb@gmail.com,
        Siva Reddy Kallam <siva.kallam@broadcom.com>,
        "prashant.sreedharan@broadcom.com" <prashant@broadcom.com>,
        "michael.chan@broadcom.com" <mchan@broadcom.com>,
        dchickles@marvell.com, sburla@marvell.com, fmanlunas@marvell.com,
        Tariq Toukan <tariqt@mellanox.com>, vishal@chelsio.com,
        leedom@chelsio.com, ulli.kroll@googlemail.com,
        linus.walleij@linaro.org
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Mar 9, 2020 at 7:15 PM Jakub Kicinski <kuba@kernel.org> wrote:
>
> Set ethtool_ops->supported_coalesce_params to let
> the core reject unsupported coalescing parameters.
>
> This driver did not previously reject unsupported parameters.
>
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>

Reviewed-by: Michael Chan <michael.chan@broadcom.com>

Thanks.
