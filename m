Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3BB312A0EA7
	for <lists+netdev@lfdr.de>; Fri, 30 Oct 2020 20:30:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727335AbgJ3TaD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Oct 2020 15:30:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53756 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727294AbgJ3T35 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Oct 2020 15:29:57 -0400
Received: from mail-pg1-x543.google.com (mail-pg1-x543.google.com [IPv6:2607:f8b0:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 55B11C0613CF;
        Fri, 30 Oct 2020 12:29:57 -0700 (PDT)
Received: by mail-pg1-x543.google.com with SMTP id i26so6052456pgl.5;
        Fri, 30 Oct 2020 12:29:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=YOgHdhZIEd64eNDa8CxRps5jUXOHmn+cHeZG00HJhac=;
        b=lp0CPZncjIw03fBNmJrplPRjBhZrg4Rjz+JD1ql3lCXlgLlQa/TiSj7R4S7npjyARZ
         36FAM2tHs7HIN+ir18VNylFWSXmW2Df3j0cVE5lxDc+2P+D2j8YpRh+B0xzr26Y7GByB
         Ted/IPUwmA+IO/hXKImgQd4Sz/vbbHevQNT2CXnNFsVrN0304LIVskfxRlqTFFJ/LIiu
         oPQrSAXK0CH+mE58ZYcJIxKBcQ+/Hrf8QyRvHWs926d4kwsD4TJAlJ9ZDpPmNZSn+Tcf
         AD6Y05ePm2ix27/WMF5fAqOuNx/EDj5u+IotbqPJX2YgPOoilkhYP2AckABoArKDAlAA
         KkXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=YOgHdhZIEd64eNDa8CxRps5jUXOHmn+cHeZG00HJhac=;
        b=cYyEFtsaMBHGaK6/Hpw7aZwc3VUnj6PCAoHmP6y39fSYfDqwILfvnBACGPcVIY8Osx
         x/+0Y/YqEsfpiP2IcYgE01FGDU6vQhfjpPOhEa8QYQUTPMj/gkpkmzoFkOBwqJnOLDyZ
         KLRC7mO5gAHkJ2wSKxFgPXC2TnGjrK+FSRx1CDzwuZVwlrQviR6hQvO7AmCPGaHQO1uT
         dbeuDYRlpK0urTjS5zv+v+VxpsRv5wZ9NV/fUZdx4n5anG9UF/V4SJJwxvjx+JZdPDgW
         ExkRFoTrvpv7LUW6FClAsFjv8zi3NgsNJEmSMRVf4aNpBbjKbwg/Am9AcY6MGZ53/7qB
         jV1Q==
X-Gm-Message-State: AOAM531KlbnoF9fJAk62gSo4TA1T4pea4R/E+YA+Xz2mnjvHnIlWtv64
        47dkaXnSdF9gFwI7uAnZ0ekRuQ3EXZt/LhKk0ogRfkiM+To=
X-Google-Smtp-Source: ABdhPJzykSxcC/p++6d9QM7bswZRdjMDXmjH6gB9gnM6tQCSNoF8NqLGJiYnkmBNafCPbj/A2K9pMeU99L6vdICRZ3g=
X-Received: by 2002:a63:3581:: with SMTP id c123mr3453239pga.233.1604086196803;
 Fri, 30 Oct 2020 12:29:56 -0700 (PDT)
MIME-Version: 1.0
References: <20201030022839.438135-1-xie.he.0141@gmail.com>
 <20201030022839.438135-6-xie.he.0141@gmail.com> <CA+FuTSdS86GtG15y17G0nNaqHjHTeYzFn+0N5+nTjXM8u=hpJw@mail.gmail.com>
In-Reply-To: <CA+FuTSdS86GtG15y17G0nNaqHjHTeYzFn+0N5+nTjXM8u=hpJw@mail.gmail.com>
From:   Xie He <xie.he.0141@gmail.com>
Date:   Fri, 30 Oct 2020 12:29:46 -0700
Message-ID: <CAJht_EMgWwAdo5Z3ZMs50k5tYnFetLa=zKO6unoU2mdOuXkU5g@mail.gmail.com>
Subject: Re: [PATCH net-next v4 5/5] net: hdlc_fr: Add support for any Ethertype
To:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Network Development <netdev@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Krzysztof Halasa <khc@pm.waw.pl>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Oct 30, 2020 at 9:33 AM Willem de Bruijn
<willemdebruijn.kernel@gmail.com> wrote:
>
> Should this still check data[5] == FR_PAD?

No, the 6th byte (data[5]) is not a padding field. It is the first
byte of the SNAP header. The original code is misleading. That is part
of the reasons why I want to fix it with this patch.

The frame format is specified in RFC 2427
(https://tools.ietf.org/html/rfc2427). We can see in Section 4.1 and
4.2 that the 6th byte is the first byte of the SNAP header.
