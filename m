Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A85331C5F01
	for <lists+netdev@lfdr.de>; Tue,  5 May 2020 19:38:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730472AbgEERiZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 May 2020 13:38:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52804 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1730342AbgEERiY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 May 2020 13:38:24 -0400
Received: from mail-lj1-x243.google.com (mail-lj1-x243.google.com [IPv6:2a00:1450:4864:20::243])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 342B6C061A41
        for <netdev@vger.kernel.org>; Tue,  5 May 2020 10:38:23 -0700 (PDT)
Received: by mail-lj1-x243.google.com with SMTP id h4so2512299ljg.12
        for <netdev@vger.kernel.org>; Tue, 05 May 2020 10:38:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Nv0AIZrWlMo4m0rNhQ0hmb2K7EScYgYrwU3TenVEmog=;
        b=EZSQQZlIteDqtbEIcl/sEkeBUfzjC+YtuCRNGMwWCq1AIeFJ3n4lyDDj8t67g6lgOv
         vG2erCqH5ghfC7q0wRU3CL4Hc1X83XBVUxV/+FOuE8DVCZL3q7jY7Hj7QYyF0Vc85oqH
         jyFcaDUaWWrs9ZE+JHUIH20XmBu1l0lK2xrnU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Nv0AIZrWlMo4m0rNhQ0hmb2K7EScYgYrwU3TenVEmog=;
        b=LL4XOR+jNeubUpmCnkfYIMkQTzYEakMqj9YC8CDHe7tgwtR9CF/VPPUl6ZjeQ/Gs4i
         L5XFHwDU3gMzH4DXBSkEzrQzfrsCx5l1ySj6e1zfHUW3g//wLrXsLycvyk93zy2VbBYx
         z10jG73a8PbqRQo+td0WB4vH9svcC5zFEePDbF03cp7dCTgk0RvnI8Y+go+nTbZEPWyj
         wY0gsl0YYvPZ0Z1BhFHvKli2TD+9kPwmVEgr30wfdGzGI8yQZPtZnhXMOoZTgnaYS7nU
         lAUJ5ysv5pnZsIjW1IWrWehr7rWSeodU73wTMFscA66Takug80si/UpqtsbbaovaA4q9
         O/Xg==
X-Gm-Message-State: AGi0PuZ/AkGvbWVoWa3PWHQZ992vDgdnaD4vqUXifnKXUyVsSwowO7iY
        RN+ffyrA8WtN0wYscDNHCafABck0ors=
X-Google-Smtp-Source: APiQypJWbI/y9dKGi+ZReKRPdLAT2LRgxdryqQE9LNt/02eV3+48kVQf2VaOT9W24onyVt93F7KXGQ==
X-Received: by 2002:a2e:9882:: with SMTP id b2mr2574455ljj.35.1588700300661;
        Tue, 05 May 2020 10:38:20 -0700 (PDT)
Received: from mail-lf1-f54.google.com (mail-lf1-f54.google.com. [209.85.167.54])
        by smtp.gmail.com with ESMTPSA id w9sm168348ljw.39.2020.05.05.10.38.19
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 05 May 2020 10:38:19 -0700 (PDT)
Received: by mail-lf1-f54.google.com with SMTP id w14so2064990lfk.3
        for <netdev@vger.kernel.org>; Tue, 05 May 2020 10:38:19 -0700 (PDT)
X-Received: by 2002:a19:c394:: with SMTP id t142mr2441981lff.129.1588700298965;
 Tue, 05 May 2020 10:38:18 -0700 (PDT)
MIME-Version: 1.0
References: <20200505133602.25987-1-geert+renesas@glider.be>
In-Reply-To: <20200505133602.25987-1-geert+renesas@glider.be>
From:   Brian Norris <briannorris@chromium.org>
Date:   Tue, 5 May 2020 10:38:07 -0700
X-Gmail-Original-Message-ID: <CA+ASDXO8TJ09vNQaCyoMgfoFVouNQRw7Evx2Vfko1k_03q8GHA@mail.gmail.com>
Message-ID: <CA+ASDXO8TJ09vNQaCyoMgfoFVouNQRw7Evx2Vfko1k_03q8GHA@mail.gmail.com>
Subject: Re: [PATCH v4 resend 2] dt-bindings: net: btusb: DT fix s/interrupt-name/interrupt-names/
To:     Geert Uytterhoeven <geert+renesas@glider.be>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Rob Herring <robh+dt@kernel.org>,
        Marcel Holtmann <marcel@holtmann.org>,
        Rajat Jain <rajatja@google.com>,
        "<netdev@vger.kernel.org>" <netdev@vger.kernel.org>,
        devicetree <devicetree@vger.kernel.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, May 5, 2020 at 6:36 AM Geert Uytterhoeven
<geert+renesas@glider.be> wrote:
>
> The standard DT property name is "interrupt-names".
>
> Fixes: fd913ef7ce619467 ("Bluetooth: btusb: Add out-of-band wakeup support")
> Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
> Acked-by: Rob Herring <robh@kernel.org>

If it matters:

Reviewed-by: Brian Norris <briannorris@chromium.org>

We're definitely using the plural ("interrupt-names") not the
singular, so this was just a typo.

Brian
