Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EFF1910978E
	for <lists+netdev@lfdr.de>; Tue, 26 Nov 2019 02:23:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727186AbfKZBXp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Nov 2019 20:23:45 -0500
Received: from mail-qt1-f179.google.com ([209.85.160.179]:44716 "EHLO
        mail-qt1-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726029AbfKZBXo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Nov 2019 20:23:44 -0500
Received: by mail-qt1-f179.google.com with SMTP id g24so12735806qtq.11
        for <netdev@vger.kernel.org>; Mon, 25 Nov 2019 17:23:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=FsDRk4EAML9Y4QvMYiS6ndyIoyHisqLZs8klfxC7Kas=;
        b=UOZ61pA+asCGex6uSWl3urkfZd9i0Q8+XGw4W2qdom7jSVsEQzUNTSu8Z1RMwHChs1
         PCaLOzYuIZHseBv2x4Hz0cjO6qShOiWPNSCJ92/BGCCEdZ95xlithNLjOG/WZCnxkX5A
         WHTrH50+23kjz0ckchWblfzz5qC76xnwgLOQg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=FsDRk4EAML9Y4QvMYiS6ndyIoyHisqLZs8klfxC7Kas=;
        b=e92fjZhlUqg01lLsLRR1xDCn6GLMA6mWUNfFijYS5lW4xpUVTj1eaJN0iRNdkQf7JK
         /y/4wIEoGqtwh0XCrTaHuZTgmL6WvkKWB3xGwWYRJkTjEAd37/PEvlSCt/xPQZoRa9Ws
         4m8pjHKKQr8UfXOHXz4Y9SRqbuUIY66vnhjxLb4IzQXbqdRMtPByJpvQHK46PgWQSvsu
         B66OEi45UanrCuCIT5JIsK0frFVBweFfzEO2Uh/nu0xhh47NDBlL+L7h6HtYX0KIdyLf
         x19xRsqU7Nmth1SjBh9FrG+pweOw6/KG+XesP9hcxqx4oA0r1SP8bD2OeC0hkCDWk9rf
         p79g==
X-Gm-Message-State: APjAAAWXOSaMSP8TlSNTcRniR7/jKptPDyuWhhrBA1DKws/+paza/l7U
        Dj2QLd/jd1Nk/TUDTnryky2nKS3vXog=
X-Google-Smtp-Source: APXvYqzxVKU/yUXUXjhH7Gic+K86mTFHPg4QQBzSn7oYjZBOYwJHZZSgcT7auLyTLZD0CXX6MLnW7Q==
X-Received: by 2002:ac8:7186:: with SMTP id w6mr32813001qto.220.1574731423267;
        Mon, 25 Nov 2019 17:23:43 -0800 (PST)
Received: from mail-qt1-f180.google.com (mail-qt1-f180.google.com. [209.85.160.180])
        by smtp.gmail.com with ESMTPSA id z17sm4850122qtq.69.2019.11.25.17.23.41
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 25 Nov 2019 17:23:42 -0800 (PST)
Received: by mail-qt1-f180.google.com with SMTP id 59so14050817qtg.8
        for <netdev@vger.kernel.org>; Mon, 25 Nov 2019 17:23:41 -0800 (PST)
X-Received: by 2002:ac8:53c4:: with SMTP id c4mr18110935qtq.305.1574731421193;
 Mon, 25 Nov 2019 17:23:41 -0800 (PST)
MIME-Version: 1.0
References: <20191113005816.37084-1-briannorris@chromium.org>
 <32422b2d-6cab-3ea2-aca3-3e74d68599a3@gmail.com> <20191123005054.GA116745@google.com>
 <115a9e13-c7ae-a919-b61b-0ea05ed162d7@gmail.com>
In-Reply-To: <115a9e13-c7ae-a919-b61b-0ea05ed162d7@gmail.com>
From:   Brian Norris <briannorris@chromium.org>
Date:   Mon, 25 Nov 2019 17:23:29 -0800
X-Gmail-Original-Message-ID: <CA+ASDXO_-ZZ5iwDMGgaT9Ah3L8P63O2kwYO9Dv8erwQmYXKEGg@mail.gmail.com>
Message-ID: <CA+ASDXO_-ZZ5iwDMGgaT9Ah3L8P63O2kwYO9Dv8erwQmYXKEGg@mail.gmail.com>
Subject: Re: [PATCH] [RFC] r8169: check for valid MAC before clobbering
To:     Heiner Kallweit <hkallweit1@gmail.com>
Cc:     Realtek linux nic maintainers <nic_swsd@realtek.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        "<netdev@vger.kernel.org>" <netdev@vger.kernel.org>,
        Chun-Hao Lin <hau@realtek.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Nov 23, 2019 at 1:59 AM Heiner Kallweit <hkallweit1@gmail.com> wrote:
> Realtek doesn't provide any public datasheets, only very few leaked
> old datasheets are available. Only public source of information is
> the vendor drivers: r8168/r8101/r8125.
> Check the vendor drivers for where they read the MAC from.

Thanks, I looked it up, and IIUC the chips I'm using would fall under
the vendor driver's 'CFG_METHOD_21', which does indeed check the GMAC
registers as a priority. (It's also even worse than the upstream
driver here: although it reads out the active MAC register first, it
doesn't end up using the value and instead just clobbers it, even if
the GMAC value is empty/garbage.)

So I guess the vendor driver "always" failed me in the same way, and
it's just the Coreboot authors who were misinformed. :(

Thanks for the pointers,
Brian
