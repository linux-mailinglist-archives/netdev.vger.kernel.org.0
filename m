Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5FB8C2FADBA
	for <lists+netdev@lfdr.de>; Tue, 19 Jan 2021 00:28:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731088AbhARX1x (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Jan 2021 18:27:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57022 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727007AbhARX1w (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Jan 2021 18:27:52 -0500
Received: from mail-lj1-x229.google.com (mail-lj1-x229.google.com [IPv6:2a00:1450:4864:20::229])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 68974C061573
        for <netdev@vger.kernel.org>; Mon, 18 Jan 2021 15:27:11 -0800 (PST)
Received: by mail-lj1-x229.google.com with SMTP id e7so19934445ljg.10
        for <netdev@vger.kernel.org>; Mon, 18 Jan 2021 15:27:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=waldekranz-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:in-reply-to:references:date:message-id
         :mime-version:content-transfer-encoding;
        bh=8QyvJv6dtRMO9RoiFML6kOfCNbb/YcNpFN5RS6+uqjg=;
        b=JDPD7gcPSHgQOz/x2hz4FbqVNv21Iys6GBh8fryxRHC6Ro/jNj54Uh3OGGFeuGPLCi
         ztnbxQ9MNHtKXQzrxJjfReItfdqLyZ1euUwgmI5ozenisuKRDy9G8f+nID9tWVuTcoMN
         B48/VbRpuHfhnxHyWz7OulYoO5X9gdO4yQJIYXMd7oYqVGlunLGbrgyc8oew0A2PUc6W
         uc2EcIPrwTxWnioDAJxGmwcRHAhA7+ma48AyDlKuMtSIAthXwRMWcZr+kVUAetMTIRZf
         V8GrMZe320y7ZWHshkcZbpC1pHokhU6feEnrPrm6VE+Ffb/6ae/l/a4ho6a7NQf45qW2
         18wg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=8QyvJv6dtRMO9RoiFML6kOfCNbb/YcNpFN5RS6+uqjg=;
        b=ANimjj/nARKsxonuTfYHrAzgV7+H1s2uuFAViefgElXdvyNAAiX0H31TKjTlbCDdMo
         WQJMLbmRbrrGoNRnvh4nQLdZdYPng8xjMxHwqDZ1uiyLtpfjacEfSgRVuhSMXVxxRnut
         qxassX2FshJTujAKm/+AdB5dqYegSByqhmM/uExI14wl9pXR5zntcTf9QV+bCiruhXfa
         JSdXVrmTZ7Px6hjHB1fK+nd2+8YAlPnXozn1WJCu3qytXb7j1hygJ6eVNwtfEN8e+KPb
         FSliz3VxwC/hnV2TzbN/y0VmHjcjUlmCGoHXzAVDfOCb8vufN5do+Ezn1XZ5YF9ckPFP
         QWfg==
X-Gm-Message-State: AOAM5330JRqMh+xOqP1Tk4Ib+kfOtHAEg1Jr1ypgZABlXKRpgb/01yK3
        v1cvwNsMHEuZJQ0+Ajw7KVr7t53AF05U2+Z7
X-Google-Smtp-Source: ABdhPJzqa7qBsd0XWPnpzuV+QUmqwaZ3VC7w0SkSQCMLX3OodcX8byOvjN+UvqYCiUvZixDC/MnH/g==
X-Received: by 2002:a2e:8085:: with SMTP id i5mr746296ljg.5.1611012429947;
        Mon, 18 Jan 2021 15:27:09 -0800 (PST)
Received: from wkz-x280 (h-236-82.A259.priv.bahnhof.se. [98.128.236.82])
        by smtp.gmail.com with ESMTPSA id e9sm2054201lfc.253.2021.01.18.15.27.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Jan 2021 15:27:09 -0800 (PST)
From:   Tobias Waldekranz <tobias@waldekranz.com>
To:     Pavel =?utf-8?Q?=C5=A0imerda?= <code@simerda.eu>,
        netdev@vger.kernel.org
Cc:     Pavel =?utf-8?Q?=C5=A0imerda?= <code@simerda.eu>
Subject: Re: [PATCH net-next] net: mdio: access c22 registers via debugfs
In-Reply-To: <20210116211916.8329-1-code@simerda.eu>
References: <20210116211916.8329-1-code@simerda.eu>
Date:   Tue, 19 Jan 2021 00:27:08 +0100
Message-ID: <87h7ndker7.fsf@waldekranz.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Jan 16, 2021 at 22:19, Pavel =C5=A0imerda <code@simerda.eu> wrote:
> Provide a debugging interface to read and write MDIO registers directly
> without the need for a device driver.
>
> This is extremely useful when debugging switch hardware and phy hardware
> issues. The interface provides proper locking for communication that
> consists of a sequence of MDIO read/write commands.
>
> The interface binds directly to the MDIO bus abstraction in order to
> provide support for all devices whether there's a hardware driver for
> them or not. Registers are written by writing address, offset, and
> value in hex, separated by colon. Registeres are read by writing only
> address and offset, then reading the value.
>
> It can be easily tested using `socat`:
>
>     # socat - /sys/kernel/debug/mdio/f802c000.ethernet-ffffffff/control
>
> Example: Reading address 0x00 offset 0x00, value is 0x3000
>
>     Input: 00:00
>     Output: 3000
>
> Example: Writing address 0x00 offset 0x00, value 0x2100
>
>     Input: 00:00:2100
>
> Signed-off-by: Pavel =C5=A0imerda <code@simerda.eu>

Hi Pavel,

I also tried my luck at adding an MDIO debug interface to the kernel a
while back:

https://lore.kernel.org/netdev/C42DZQLTPHM5.2THDSRK84BI3T@wkz-x280

The conclusion was that, while nice to have, it makes it too easy for
shady vendors to write out-of-tree drivers.

You might want to have a look at https://github.com/wkz/mdio-tools. It
solves the same issue that your debugfs interface does, and also some
other nice things like clause 45 addressing and atomic read/mask/write
operations.
