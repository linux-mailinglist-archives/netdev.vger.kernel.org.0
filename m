Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3791C48A1A2
	for <lists+netdev@lfdr.de>; Mon, 10 Jan 2022 22:15:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240735AbiAJVPr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Jan 2022 16:15:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44450 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240441AbiAJVPq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Jan 2022 16:15:46 -0500
Received: from mail-qk1-x733.google.com (mail-qk1-x733.google.com [IPv6:2607:f8b0:4864:20::733])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0E38C06173F
        for <netdev@vger.kernel.org>; Mon, 10 Jan 2022 13:15:45 -0800 (PST)
Received: by mail-qk1-x733.google.com with SMTP id m2so16806956qkd.8
        for <netdev@vger.kernel.org>; Mon, 10 Jan 2022 13:15:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=tdZh+l9wm6XSStX2jchA6Q0jinu9DwwUz5sMLzDkQnQ=;
        b=av/0ts1Sm/iMx2BsRXz22bG2oqg7zRKHHksDN8WOaZ1P+tNq4+K/XknD9NrTjb8KPj
         YD9Ussv2PNJTXh1DOPbC1LODAMw4k2Cf/oAhpV4zn7Ym/0IfpK3P1N+lcbZAw5Uvjyfg
         AFHoIveswVyuk424iVUYbHYTQhmoD/yShUJ5Y=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=tdZh+l9wm6XSStX2jchA6Q0jinu9DwwUz5sMLzDkQnQ=;
        b=DWPDqCl5/qRwMMQVkwJ/4v7AljBCE6PtmD/bJ4MbYjoC7GY7uBcsOPlpxz5NpX6QWp
         7s1x2tO1q0ia+JQUzOfFk1/To18K/SIkuD3Y5WRzZEEAUJYujDVccXZqjVKlFTZjgnQJ
         MD94heMyWuw6oss6MeVcp259KONasEhGDxoGgptw+Vw1CZXGZMMf8ZTwhedNBcKYotXY
         S5HzZsvO1ny6c3av+Ye5wgpkXL2ARMtKlAVqpRtLBPX4erlDeQHgt1KbnV+sgGXOYUxS
         JVclDoNi08YgT5Upqm0j7FZ4X3Kyuj/IoJyamOJWGxfn4v9NduER+1qDzw2Pj8xhEbRz
         WP6Q==
X-Gm-Message-State: AOAM530IWYjwFW55rKfhG3rLDTaNVl9N26j9Jydewd2iIvFQ0In6VOtw
        ajapgKjEtbUkV8TafVnN3wORNHoT+kSywqMGJNr/Z96kmC5dcg==
X-Google-Smtp-Source: ABdhPJyU55Jsrb8L7JBswHv0HnHBAMsYzQ7f5AzPGH7tjEQsVwgz5769fJ9LaWkypLSm05MlQc1g/KybaY+UjFGNIwo=
X-Received: by 2002:a37:6411:: with SMTP id y17mr1223491qkb.250.1641849344893;
 Mon, 10 Jan 2022 13:15:44 -0800 (PST)
MIME-Version: 1.0
References: <f7bcc68d-289d-4c13-f73d-77e349f4674e@linux.microsoft.com>
In-Reply-To: <f7bcc68d-289d-4c13-f73d-77e349f4674e@linux.microsoft.com>
From:   Michael Chan <michael.chan@broadcom.com>
Date:   Mon, 10 Jan 2022 13:15:34 -0800
Message-ID: <CACKFLim=ENcZMk+8UUwg87PPdu6zDC1Ld5b54Pp+_WSow9g_Og@mail.gmail.com>
Subject: Re: [bnxt] Error: Unable to read VPD
To:     Vijay Balakrishna <vijayb@linux.microsoft.com>
Cc:     Netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jan 10, 2022 at 1:02 PM Vijay Balakrishna
<vijayb@linux.microsoft.com> wrote:
>
>
> Since moving to 5.10 from 5.4 we are seeing
>
> > Jan 01 00:00:01 localhost kernel: bnxt_en 0008:01:00.0 (unnamed net_device) (uninitialized): Unable to read VPD
> >
> > Jan 01 00:00:01 localhost kernel: bnxt_en 0008:01:00.1 (unnamed net_device) (uninitialized): Unable to read VPD
>
> these appear to be harmless and introduced by
>
> > https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=a0d0fd70fed5cc4f1e2dd98b801be63b07b4d6ac
> Does "Unable to read VPD" need to be an error or can it be a warning
> (netdev_warn)?
>

We can change these to warnings.  Thanks.
