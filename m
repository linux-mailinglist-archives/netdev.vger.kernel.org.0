Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 82FC2282673
	for <lists+netdev@lfdr.de>; Sat,  3 Oct 2020 21:48:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725901AbgJCTsl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 3 Oct 2020 15:48:41 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:57852 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725850AbgJCTsk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 3 Oct 2020 15:48:40 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1601754519;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Hy5WpkO/Gu95w0OKNDzxdR7UAyBBtQNNsxFWZCduFU8=;
        b=EG/ero3Amp3ymnkxiFSshMsqyhG8cxjAy8CMdg8WLGEdqUkmwVrizRlq1Cr8KRGMGbA/jJ
        8XymOGJqrIyXGbnrk58YGutRWPB9UKA/jVQCbCy/Lpvq1LCEFhsVNo0hSK8r9qRvgHn2i3
        ombS/xBW1rGyi8rb1ZeXq8l92Xf7rq4=
Received: from mail-oo1-f71.google.com (mail-oo1-f71.google.com
 [209.85.161.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-431-ivjc_IhVMiCkYctYAYnlAA-1; Sat, 03 Oct 2020 15:48:37 -0400
X-MC-Unique: ivjc_IhVMiCkYctYAYnlAA-1
Received: by mail-oo1-f71.google.com with SMTP id n19so2717130oof.4
        for <netdev@vger.kernel.org>; Sat, 03 Oct 2020 12:48:37 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Hy5WpkO/Gu95w0OKNDzxdR7UAyBBtQNNsxFWZCduFU8=;
        b=kcedpq52euy6GTRG2+s19CZm9Hpu02XJpCUM5T3Lfy3mxd7JJ4yecCfDDe5+jWqt+l
         nSLmRXTGsjVLKt5z1xjfhkvOHfUftBBHGkRlZPXMx1x6ZC475p6WKryE89xxcQM/85lC
         6JhgCCzcXYds9NaOxLuS+mE+xuVnPGXhIENFEaJXFppjm7VWi2Lgsb7+LKYjcOsVNqNZ
         SZ4SUZL4JNz7WmngYLCRQbdbOWlwYpDKhJGP+XxcHexS+Cw0qwlnlAJRGVX6JBj7bT43
         h5wWVLmt9X/RpW1C8E4uVnT4sYbOf/iAykVO84I6s/HJRTaItFc2hxnF+7Tla1ziQ2EL
         i1fA==
X-Gm-Message-State: AOAM5306WfwhHPC2fyqWxJV59AYl0nrlkz8OMnDgL4QyTQvxsoOErMa+
        2H9/J40fHxijz8RvLVX1Pi6M+aZNDh4ZkicT0v9wi/M9b2YV+W39654Lrk202G6hOJA6tCO8KOS
        eN3T9p9Xy+NU6oCXzEgdCeV8wST0avZhl
X-Received: by 2002:a9d:3ca:: with SMTP id f68mr5704588otf.330.1601754516947;
        Sat, 03 Oct 2020 12:48:36 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJw2wq2Qm+3K0+4uyut/QnW4dmGFfGaay66ulKWiStR9/0e74r3/nykX7vJ+Cq6chVIYYIfwVu6O0sKr5ajDQWY=
X-Received: by 2002:a9d:3ca:: with SMTP id f68mr5704580otf.330.1601754516762;
 Sat, 03 Oct 2020 12:48:36 -0700 (PDT)
MIME-Version: 1.0
References: <20201002174001.3012643-7-jarod@redhat.com> <20201002121317.474c95f0@hermes.local>
 <CAKfmpSc3-j2GtQtdskEb8BQvB6q_zJPcZc2GhG8t+M3yFxS4MQ@mail.gmail.com> <20201002.155718.1670574240166749204.davem@davemloft.net>
In-Reply-To: <20201002.155718.1670574240166749204.davem@davemloft.net>
From:   Jarod Wilson <jarod@redhat.com>
Date:   Sat, 3 Oct 2020 15:48:26 -0400
Message-ID: <CAKfmpSd9NaBFhBsS=3zS5R5LeaVzguZjkwuvxSLYNT-Hwvj5Zw@mail.gmail.com>
Subject: Re: [PATCH net-next v2 6/6] bonding: make Kconfig toggle to disable
 legacy interfaces
To:     David Miller <davem@davemloft.net>
Cc:     Stephen Hemminger <stephen@networkplumber.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Jay Vosburgh <j.vosburgh@gmail.com>,
        Veaceslav Falico <vfalico@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Thomas Davis <tadavis@lbl.gov>, Netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Oct 2, 2020 at 6:57 PM David Miller <davem@davemloft.net> wrote:
>
> From: Jarod Wilson <jarod@redhat.com>
> Date: Fri, 2 Oct 2020 16:23:46 -0400
>
> > I'd had a bit of feedback that people would rather see both, and be
> > able to toggle off the old ones, rather than only having one or the
> > other, depending on the toggle, so I thought I'd give this a try. I
> > kind of liked the one or the other route, but I see the problems with
> > that too.
>
> Please keep everything for the entire deprecation period, unconditionally.

Okay, so 100% drop the Kconfig flag patch, but duplicate sysfs
interface names are acceptable, correct? Then what about the procfs
file having duplicate Slave and Port lines? Just leave them all as
Slave?

-- 
Jarod Wilson
jarod@redhat.com

