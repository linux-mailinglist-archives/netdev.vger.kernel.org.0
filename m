Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5B8441322FA
	for <lists+netdev@lfdr.de>; Tue,  7 Jan 2020 10:53:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727714AbgAGJxK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Jan 2020 04:53:10 -0500
Received: from mail-ot1-f68.google.com ([209.85.210.68]:37397 "EHLO
        mail-ot1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726485AbgAGJxJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Jan 2020 04:53:09 -0500
Received: by mail-ot1-f68.google.com with SMTP id k14so75721552otn.4;
        Tue, 07 Jan 2020 01:53:09 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=rcKJiBOHF/a0+MDVGltwkYmA7kAiSShXv3OfBucNo/w=;
        b=spnwUusnFCnaGf0nGyhvYIrZK7fZxpchw6XZAQvKRpfSTstjz1xbvLHYrIer0tt1NQ
         pOmR9iHuZCi+Xad2SBPYWR6XjJkc4WH7f3RhtWQkE6vD+CgiLwJIigIoZNqKDFrTCOi7
         ekkK6FQuLloN7K5IWcCA84W2PhEU4sDup6KXC05A4Xxe9Lasl3W4GTxQgROtxvrI9bd6
         q9tMJfTKCxvF+uud38NFqdU1SayNNThFi/oRzzlSbqgduMZHY3uh04R+StFmSVF4ESxl
         NTcdfFFqTxRKvTLoH8H8z21jlPBhA70Ue0eYGza7RPMIyHLRyx+YU+ZjKOKrdfSJXYgf
         EnLA==
X-Gm-Message-State: APjAAAU2zApQ8IQFnvMckrK9/w5ky0goBRLpYuAYc5ANu/OU/zxkuzeR
        TbAhQBPYuloBuxZ1Rhvfa5fE9o92Le7TkqYwgCQ=
X-Google-Smtp-Source: APXvYqyijdjeyq4HJ5FCDcI015uTWnvTRQoFeaQRgxTWy1DfLN1zgBL6llgNmNnOtPrGgkpTZXmDGjkn5Is6S8EHkt8=
X-Received: by 2002:a9d:62c7:: with SMTP id z7mr111166052otk.189.1578390788841;
 Tue, 07 Jan 2020 01:53:08 -0800 (PST)
MIME-Version: 1.0
References: <20200106045833.1725-1-masahiroy@kernel.org>
In-Reply-To: <20200106045833.1725-1-masahiroy@kernel.org>
From:   "Rafael J. Wysocki" <rafael@kernel.org>
Date:   Tue, 7 Jan 2020 10:52:57 +0100
Message-ID: <CAJZ5v0jBEq+GiTP8V4ZzQvR9qbSBdEz_P8EZNX7yNZMzTjB86Q@mail.gmail.com>
Subject: Re: [PATCH] treewide: remove redundent IS_ERR() before error code check
To:     Masahiro Yamada <masahiroy@kernel.org>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        Julia Lawall <julia.lawall@lip6.fr>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        linux-clk <linux-clk@vger.kernel.org>,
        linux-crypto@vger.kernel.org, linux-gpio@vger.kernel.org,
        linux-i2c <linux-i2c@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-mtd@lists.infradead.org, netdev <netdev@vger.kernel.org>,
        "moderated list:SOUND - SOC LAYER / DYNAMIC AUDIO POWER MANAGEM..." 
        <alsa-devel@alsa-project.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jan 6, 2020 at 6:11 AM Masahiro Yamada <masahiroy@kernel.org> wrote:
>
> 'PTR_ERR(p) == -E*' is a stronger condition than IS_ERR(p).
> Hence, IS_ERR(p) is unneeded.
>
> The semantic patch that generates this commit is as follows:
>
> // <smpl>
> @@
> expression ptr;
> constant error_code;
> @@
> -IS_ERR(ptr) && (PTR_ERR(ptr) == - error_code)
> +PTR_ERR(ptr) == - error_code
> // </smpl>
>
> Signed-off-by: Masahiro Yamada <masahiroy@kernel.org>
> ---

Acked-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

for the acpi/scan.c change, but there seems to be a typo in the subject:

s/redundent/redundant/
