Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4FC124A58DC
	for <lists+netdev@lfdr.de>; Tue,  1 Feb 2022 09:58:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235786AbiBAI60 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Feb 2022 03:58:26 -0500
Received: from mail-ua1-f49.google.com ([209.85.222.49]:44961 "EHLO
        mail-ua1-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235779AbiBAI6Z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Feb 2022 03:58:25 -0500
Received: by mail-ua1-f49.google.com with SMTP id p26so5211802uaa.11;
        Tue, 01 Feb 2022 00:58:25 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=9UUDL4Djrc/LSpVFUl4ftbiUp0u8Xqi9XMgDbdcXFV4=;
        b=samafSqRjsnmFn2WvV7PwAXxUUbwUpr94NPQ841RRfJ7Ig3jtTtmrb2uiCy/UcceyJ
         xArtMx29bwNYHiGvsCk3LkkcZ0fk9cGzQTVEXpVfQk9Q0i5AMfBtUxyOpxMpuUedj+YU
         5V1+4jqVF1Mj6+XWxfwB5aFHJnoofAWYYsCfUhF80PX5BboFi/Sx237NXq+ay7IxK6Ho
         mrpx69imiVs0Keb2qOumS7CTICzb74dJ30BL2isS2+MGukqye8kyTkqbJT59D0jMPM21
         KBFSimaaJbGCDQL8meJdKIFbGZw2xtovbSgssSE/mnuIMuiG+8VusfqFCZU5GVhtjooI
         Kylg==
X-Gm-Message-State: AOAM532FgoHRW8f7UpeEp5blGcXXLG0LHhNI3gkpawCt7ujLgZDcGwr6
        Xy4gYK3FSu6SQS+6FjQvY/LrEZPKOiGKSA==
X-Google-Smtp-Source: ABdhPJzwjralJMUE5U+7r3sYLQGMjqGhRW7TnFwfhNwrKLONRptkLQ9HCPPUrSzczmsbmR4/80Jjaw==
X-Received: by 2002:ab0:59f0:: with SMTP id k45mr9256897uad.135.1643705904437;
        Tue, 01 Feb 2022 00:58:24 -0800 (PST)
Received: from mail-vs1-f43.google.com (mail-vs1-f43.google.com. [209.85.217.43])
        by smtp.gmail.com with ESMTPSA id ba16sm4632717vkb.39.2022.02.01.00.58.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 01 Feb 2022 00:58:24 -0800 (PST)
Received: by mail-vs1-f43.google.com with SMTP id l14so15183845vsm.3;
        Tue, 01 Feb 2022 00:58:23 -0800 (PST)
X-Received: by 2002:a67:fd63:: with SMTP id h3mr8586084vsa.77.1643705903763;
 Tue, 01 Feb 2022 00:58:23 -0800 (PST)
MIME-Version: 1.0
References: <20220129115517.11891-1-s.shtylyov@omp.ru> <20220129115517.11891-3-s.shtylyov@omp.ru>
In-Reply-To: <20220129115517.11891-3-s.shtylyov@omp.ru>
From:   Geert Uytterhoeven <geert@linux-m68k.org>
Date:   Tue, 1 Feb 2022 09:58:12 +0100
X-Gmail-Original-Message-ID: <CAMuHMdW_AufMOLJjtcO3hp-GwD0Q6iDL1=SD6Fq+Xe5wL46Yow@mail.gmail.com>
Message-ID: <CAMuHMdW_AufMOLJjtcO3hp-GwD0Q6iDL1=SD6Fq+Xe5wL46Yow@mail.gmail.com>
Subject: Re: [PATCH v2 2/2] sh_eth: sh_eth_close() always returns 0
To:     Sergey Shtylyov <s.shtylyov@omp.ru>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Linux-Renesas <linux-renesas-soc@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Sergei,

On Tue, Feb 1, 2022 at 3:00 AM Sergey Shtylyov <s.shtylyov@omp.ru> wrote:
> sh_eth_close() always returns 0, hence the check in sh_eth_wol_restore()
> is pointless (however we cannot change the prototype of sh_eth_close() as
> it implements the driver's ndo_stop() method).
>
> Found by Linux Verification Center (linuxtesting.org) with the SVACE static
> analysis tool.
>
> Signed-off-by: Sergey Shtylyov <s.shtylyov@omp.ru>

Thanks for your patch!

Reviewed-by: Geert Uytterhoeven <geert+renesas@glider.be>

Note that there's a second call in sh_eth_suspend().

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
