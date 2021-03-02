Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6016232A323
	for <lists+netdev@lfdr.de>; Tue,  2 Mar 2021 16:01:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1381941AbhCBIrh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Mar 2021 03:47:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39644 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238679AbhCBDjb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Mar 2021 22:39:31 -0500
Received: from mail-io1-xd34.google.com (mail-io1-xd34.google.com [IPv6:2607:f8b0:4864:20::d34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99A6FC061788;
        Mon,  1 Mar 2021 19:39:22 -0800 (PST)
Received: by mail-io1-xd34.google.com with SMTP id u8so20209284ior.13;
        Mon, 01 Mar 2021 19:39:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=j5U5ib8S+fw8VfbootPfE9pUr0ORA50B2DUYIWuxP6Y=;
        b=Yv8IF4fDGVJTZ53KtztnL1Cs8lSt7ry5sTH00vYt0Y76ELZvGux2MwEVgcumu5IXTt
         e27ypKOm/fiHKEg0uBQ/bKXTLTv2hzCJbHSMg/rFZMaKiooBx4KNQjSKWiuikS9alrZC
         j/YhQGISY1POF4zwwtHNoBXAWMAjOitojx0q/i2H1x6tS5WfXp4NrFGokyA/nz2OQmmD
         WzdR5okzOwdSHrmQjJR1nbfEIltbt+KEmvV3aOUq6qwXY+Hf8gH9EVmsTFAoj1/nJ5ZR
         GnxL6v3zQII0G89K2R84oJkVT0HIjlU43ePOPCbqeV3MNDs3D9oBiBqSgwWthw/puFwl
         QP/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=j5U5ib8S+fw8VfbootPfE9pUr0ORA50B2DUYIWuxP6Y=;
        b=LnX2vNunBbDRfOUnPA2yBjnOp4gt+hyNldP5hDKGnpzOf4XiVgIWNRnCZCljlQVu5t
         6MVwJQszjXAt/cidlA+BI2RsxHM/kYGCyslxNklgBfUKOg8ZnMiMzI7MPH8xku97alVo
         CCpIAm9cKvAgRI3tU0F4a32EVsICQo1Q7pCEf74R5YMoOEnoQr/OZwXhzTNGmAjJh6l2
         4NMlzJmSFr1NaDbAU+vvCpUHU3l4t/rsJfy/DogySx1IHgu29GLTHce6gUtCzpjMNEdA
         b/553l7KO5WqJge7q/ZHSXLVv+1uOa186Jz5LVg1JBrnbPQaD1Z0MXbzzHVVM8Dn4sXt
         PIqw==
X-Gm-Message-State: AOAM531ig56qj1SoSactSVDhMJNdbW/5Wz1ZVXx3cJK5dcBd+hdzWII+
        xQeJke1zy8gO/Z+vjYrJusgLfS4vnYdjFYHu1Uc=
X-Google-Smtp-Source: ABdhPJzxs6B4pW0ZkjlOs2h/WusoUREEEq90Ugj3AQC9yUzPuBhCKDXD1ogM6IH2JWOYIoCm5pn/bqNfHDFSt1EZ8qI=
X-Received: by 2002:a6b:b447:: with SMTP id d68mr15977269iof.87.1614656362117;
 Mon, 01 Mar 2021 19:39:22 -0800 (PST)
MIME-Version: 1.0
References: <20210224061205.23270-1-dqfext@gmail.com> <CACRpkdZgwW=Zwehn+Bd7TkHq7WDVZ6VDbkXS5WKO0ACQAd2pcg@mail.gmail.com>
In-Reply-To: <CACRpkdZgwW=Zwehn+Bd7TkHq7WDVZ6VDbkXS5WKO0ACQAd2pcg@mail.gmail.com>
From:   DENG Qingfang <dqfext@gmail.com>
Date:   Tue, 2 Mar 2021 11:39:12 +0800
Message-ID: <CALW65jbH1XCWK4ngzfBixqzb+z-r3AySxf24a5MJt8NL2FoYAg@mail.gmail.com>
Subject: Re: [RFC net-next] net: dsa: rtl8366rb: support bridge offloading
To:     Linus Walleij <linus.walleij@linaro.org>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Russell King <linux@armlinux.org.uk>,
        netdev <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Mar 1, 2021 at 9:55 PM Linus Walleij <linus.walleij@linaro.org> wrote:
>
> BTW where did you find this register? It's not in any of my
> vendor driver code dumps.

DD-WRT
https://svn.dd-wrt.com/browser/src/linux/universal/linux-4.14/drivers/net/ethernet/ag7100/RTL8366RB_DRIVER/rtl8368s_reg.h#L581

>
> Curious!
>
> Yours,
> Linus Walleij
