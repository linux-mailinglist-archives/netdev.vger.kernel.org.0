Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1F4AF48A6FA
	for <lists+netdev@lfdr.de>; Tue, 11 Jan 2022 06:03:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232072AbiAKFDI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Jan 2022 00:03:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40706 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229947AbiAKFDG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Jan 2022 00:03:06 -0500
Received: from mail-ed1-x536.google.com (mail-ed1-x536.google.com [IPv6:2a00:1450:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 668A4C06173F
        for <netdev@vger.kernel.org>; Mon, 10 Jan 2022 21:03:05 -0800 (PST)
Received: by mail-ed1-x536.google.com with SMTP id z22so17287130edd.12
        for <netdev@vger.kernel.org>; Mon, 10 Jan 2022 21:03:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=35NPA15rIkTZFtz4gqGNN7SOblvU+RJZkToSumWgjhg=;
        b=aJ2ii7bA+WaMOzGYCwzcbfOA05gLTXSruke0Cmojk5a7t7B3r+L+OAWokMCmg44Et7
         WzT20SgbMwEswfObDCdhe7A0d4nEtmAn+ScFpoO7VF0smJHcskfK9jsMevY0nmqEk4S1
         K0JVR5i0jBri0SNpA5zfs+3qA1PFCIgJQg2z8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=35NPA15rIkTZFtz4gqGNN7SOblvU+RJZkToSumWgjhg=;
        b=z+0OnemSRgrI2TJSIfaJIBzpbfpjPF3xCi3/bPZxW5JpTgb1HI4OlirOWVx5lPnPY1
         XNu5tEaR/il2a2smJ+Iua1AQnIZEFe2GbKke+A23z4XuqyM++EwZjJCsC2RwxdPLsh9e
         2nN+OpXrE6VMsq46+Cbf3jmkJiriIobvphyw6upGjZb9v1ssEz8Mr6l3nnowaZn7Q4Er
         Et3LA+JJkcCxQfthvltX9aJd5y2tozb+nq+9zRawObQ+mShTAx1EOj3BdPjMrZdgxjfa
         cVUQy40rcWQ7gbaesyGb5wycEFXOI/zrxAlyykwSzW0fIAyWBN3JiGSMWPOfDu8PinKV
         Onug==
X-Gm-Message-State: AOAM531Pq0I/wxpNIkxI3I/E4LDLUY6aSPqQ/4QTe7gAvIdV/Di2lBot
        wYInLFSahEFr/gMgRfoTmJKB66EB5kWNYBb+gHg=
X-Google-Smtp-Source: ABdhPJzjfrY4L+NRK2QLyJwzyI/jTsXpX/m2+uT+0chPG009yAIG19Rn7pbZcnSR/PHHWXBuyN1zPQ==
X-Received: by 2002:a17:906:87c9:: with SMTP id zb9mr2337452ejb.725.1641877383737;
        Mon, 10 Jan 2022 21:03:03 -0800 (PST)
Received: from mail-wr1-f49.google.com (mail-wr1-f49.google.com. [209.85.221.49])
        by smtp.gmail.com with ESMTPSA id qb30sm3161043ejc.119.2022.01.10.21.03.03
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 10 Jan 2022 21:03:03 -0800 (PST)
Received: by mail-wr1-f49.google.com with SMTP id s1so30742866wra.6
        for <netdev@vger.kernel.org>; Mon, 10 Jan 2022 21:03:03 -0800 (PST)
X-Received: by 2002:a5d:6c68:: with SMTP id r8mr2161062wrz.281.1641877383117;
 Mon, 10 Jan 2022 21:03:03 -0800 (PST)
MIME-Version: 1.0
References: <20220110025203.2545903-1-kuba@kernel.org> <CAHk-=wg-pW=bRuRUvhGmm0DgqZ45A0KaH85V5KkVoxGKX170Xg@mail.gmail.com>
 <20220110205603.6bc9b680@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <20220110205603.6bc9b680@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Mon, 10 Jan 2022 21:02:47 -0800
X-Gmail-Original-Message-ID: <CAHk-=wieO-N=XD73D=OKJ88Y_=GiF9OGm2yg3s_nvafPxAFYwg@mail.gmail.com>
Message-ID: <CAHk-=wieO-N=XD73D=OKJ88Y_=GiF9OGm2yg3s_nvafPxAFYwg@mail.gmail.com>
Subject: Re: [GIT PULL] Networking for 5.17
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     David Miller <davem@davemloft.net>,
        Netdev <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jan 10, 2022 at 8:56 PM Jakub Kicinski <kuba@kernel.org> wrote:
>
>   The only explanation I can come up with it's that it was
> done so that people running olddefconfig right after the per-vendor
> split was introduced wouldn't lose all drivers.

Yeah, I think that was the reason. Don't hide existing drivers behind
vendors that got turned off.

I think it would probably be fine to have entirely new vendors (ie "no
existing drivers") default to 'n' when added, just to cut down on the
huge amount of driver questions.

But right now they all act the other way around, and are just a way to
explicitly turn off questions for a vendor you know you don't care
about.

It does perhaps get a bit confusing if some vendors are 'default y'
and others are 'default n'. It's easy enough to explain at the time
when that vendor is added, but then ten years passes, and somebody
asks why something like DEC or 3com is 'default y', while soem big new
vendor migth be 'default n'.

So I dunno.

            Linus
