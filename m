Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0A3204958B9
	for <lists+netdev@lfdr.de>; Fri, 21 Jan 2022 05:01:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233800AbiAUEBu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Jan 2022 23:01:50 -0500
Received: from smtp-relay-internal-0.canonical.com ([185.125.188.122]:49754
        "EHLO smtp-relay-internal-0.canonical.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233785AbiAUEBt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Jan 2022 23:01:49 -0500
Received: from mail-ot1-f71.google.com (mail-ot1-f71.google.com [209.85.210.71])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-internal-0.canonical.com (Postfix) with ESMTPS id DBDC43F17B
        for <netdev@vger.kernel.org>; Fri, 21 Jan 2022 04:01:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1642737707;
        bh=4kHu2XYyfVu0N83f5P1MXdyIklLz/98ljBKcgS3bWe0=;
        h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
         To:Cc:Content-Type;
        b=qzuvlzoG5lnNTrVSjlBskSoDIC4dn9KnIi9FUnSl7Jk0aNVZ/0XxL0pT1VpEaapZW
         I6u7/nt9L7af3wxWfCPiwEkqPo9MdflgjPQmLe0kn/J626Wv5nVh+crZ2KF+W++FNd
         jcLHHe3W90R3bQYwyTdz2A6YFEAUuK97+Svu6PxM9AgqWPSBAR2TNwoLZUHtj5HaPw
         IGfo9D2QDPVP3nSEM+xm1cUq1HXNK1w+CKcM2GE1XVywXoo5TNCRT/pnj5DZxZasxg
         22A4Wma28juqgvIKurC5QTrvKQn9PA44MKYa76/5dzmRwvJuIRmFZLxE0npH8sVJOh
         ZwS3V7Qo5FqtA==
Received: by mail-ot1-f71.google.com with SMTP id v22-20020a0568301bd600b00590a8d65e0fso4686511ota.4
        for <netdev@vger.kernel.org>; Thu, 20 Jan 2022 20:01:47 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=4kHu2XYyfVu0N83f5P1MXdyIklLz/98ljBKcgS3bWe0=;
        b=plPsIIKoNbRI/OhUHAGwK/3uz3vVWoOJr9GFhXGZxEO/kQGyjw5r2zY+cjvyBUe5O5
         5KAaQxvc2hOzvliSLk6/o9wI+wBbhCOzea7YLW6liGkm2mBwtZn76pj/LkeXF/T4PEWT
         luGRwgonNDlx+1GPGIoQq6MXGQ5On6F8RMwPONXGfMSxIYX+YEQpGdixFKE2bBX0CK2k
         7nknJM9UycuDl8IN9XZ8Vidz9WI9kp8PXDcY/yUCcmExjR3IVFBLYy0aVKoQTNCu6HBE
         YopUv80jNarEfZp2YVnEQeGdvtXtqfxdwLsBU93ju/YmQPj+5hA3z8NtLMAdUolJ5Ct/
         Fc4w==
X-Gm-Message-State: AOAM532lb/F/q9nYj9tNXn6sSzIpGBhHm5fQBiKql7s3pgRuqNN/7eqw
        PLEllxTajjxK7BnuKqlEQuGvU31t1slGqe4Etrp/lzEW2eea8hZN+capWbp8nztV48iqZzB/DZ1
        G2tr1Jqy8y2yh7W5xi3B5Iuznss9HrPB61HmF716uaQ7wYzX5bQ==
X-Received: by 2002:a9d:480e:: with SMTP id c14mr1511908otf.233.1642737706834;
        Thu, 20 Jan 2022 20:01:46 -0800 (PST)
X-Google-Smtp-Source: ABdhPJyseZj+ek4BeoHOtF//WkmuO66+iqWcXsWmB3o/kKx7ClQ5FpOwebYv2dscfj0+zK6N02U3WyJjFIqj5xm+ybY=
X-Received: by 2002:a9d:480e:: with SMTP id c14mr1511895otf.233.1642737706604;
 Thu, 20 Jan 2022 20:01:46 -0800 (PST)
MIME-Version: 1.0
References: <20220120051929.1625791-1-kai.heng.feng@canonical.com> <YelxMFOiqnfIVmyy@lunn.ch>
In-Reply-To: <YelxMFOiqnfIVmyy@lunn.ch>
From:   Kai-Heng Feng <kai.heng.feng@canonical.com>
Date:   Fri, 21 Jan 2022 12:01:35 +0800
Message-ID: <CAAd53p7NjvzsBs2aWTP-3GMjoyefMmLB3ou+7fDcrNVfKwALHw@mail.gmail.com>
Subject: Re: [PATCH v2] net: phy: marvell: Honor phy LED set by system
 firmware on a Dell hardware
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     hkallweit1@gmail.com, linux@armlinux.org.uk,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 20, 2022 at 10:26 PM Andrew Lunn <andrew@lunn.ch> wrote:
>
> On Thu, Jan 20, 2022 at 01:19:29PM +0800, Kai-Heng Feng wrote:
> > BIOS on Dell Edge Gateway 3200 already makes its own phy LED setting, so
> > instead of setting another value, keep it untouched and restore the saved
> > value on system resume.
> >
> > Introduce config_led() callback in phy_driver() to make the implemtation
> > generic.
>
> I'm also wondering if we need to take a step back here and get the
> ACPI guys involved. I don't know much about ACPI, but shouldn't it
> provide a control method to configure the PHYs LEDs?
>
> We already have the basics for defining a PHY in ACPI. See:
>
> https://www.kernel.org/doc/html/latest/firmware-guide/acpi/dsd/phy.html

These properties seem to come from device-tree.

>
> so you could extend this to include a method to configure the LEDs for
> a specific PHY.

How to add new properties? Is it required to add new properties to
both DT and ACPI?
Looks like many drivers use _DSD freely, but those properties are not
defined in ACPI spec...

Kai-Heng

>
>   Andrew
