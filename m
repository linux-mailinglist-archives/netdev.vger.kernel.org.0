Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ADC4F55CE4
	for <lists+netdev@lfdr.de>; Wed, 26 Jun 2019 02:26:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726320AbfFZA0J (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Jun 2019 20:26:09 -0400
Received: from mail-yw1-f68.google.com ([209.85.161.68]:46818 "EHLO
        mail-yw1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726037AbfFZA0I (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Jun 2019 20:26:08 -0400
Received: by mail-yw1-f68.google.com with SMTP id z197so156241ywd.13
        for <netdev@vger.kernel.org>; Tue, 25 Jun 2019 17:26:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=pwaZmBd+sFVaaav+KezPIoqde4SQqPP1nxo6nfT5luA=;
        b=M8cKeEqSmZVnqds41OS8zNw5jFTB5Bdgnzjp03TuaYdw6rlAEKqhaNXJHYVwEofFt/
         11ltuIp7OXyraI/pZDWO4l44zXFY64DR2UV4qfabHY0yclsefU7Q2B2kIcUAlgXKcg1o
         PBWJXL2Hk/eco0lgtoD/V93XmlwLxgNPKV+cfnqNwmRHOuKhMwKuV3Xj2njp+iz8tQ+3
         9+d+9RFZHpoAMWmoQWArqkKhKXilEqbdxcT41+JtzUKe+Y5ixf32FvN7OeUaooNFjLON
         S7nQTkY40m6TOY5/+n/jNbURAG2IchasLBcZB0H8x2+Kva0gL5gSHOS2OE+CAtWWTyMV
         t1qQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=pwaZmBd+sFVaaav+KezPIoqde4SQqPP1nxo6nfT5luA=;
        b=P7UBSc6+LS1BnHZcKALBqQabOPvrGlEmWwv+GQBaSru1FUe0b7NIIPq9HwqQPdR9NL
         Qzw/CQDbQTq1cX6JNfqDNXpKvVPLm7gopgatTxoJD99obY8CFLKy9xFcIjB/tm6bHkr1
         a866gPRO87vXDDAdpZMxuwHf3bZKqopxKr6SaqHJLSc7lCpvJuih/Bh3jyrNVqbXgh42
         jf9pcujDrZpNh19eA2sWjbd+ljuk63lm/3o7WyblhKmvmaFcrHTQRi4550PLasAH6R2F
         CAEM3v+5qVRWddh6l2l50RUoE+3WpiAJyZRskCl8ROlNnm/nhTzlj28/EWr5c8uYa+oV
         6FMg==
X-Gm-Message-State: APjAAAUCXyeJryDqRST5u11yS8YrTdunrhSc3a0izWdZpkBrrQhn8yT2
        tzjcuspK5S4wpYg8vnPP208C8Vys
X-Google-Smtp-Source: APXvYqyos7YtY9QVwcHnQcFwTi3We6EwkoNdaU9UafRnvhBjLfmOIETwrZbeTZ/wah+CwMbHmlWvtw==
X-Received: by 2002:a81:48c:: with SMTP id 134mr915119ywe.387.1561508767646;
        Tue, 25 Jun 2019 17:26:07 -0700 (PDT)
Received: from mail-yb1-f180.google.com (mail-yb1-f180.google.com. [209.85.219.180])
        by smtp.gmail.com with ESMTPSA id l143sm4090017ywl.107.2019.06.25.17.26.06
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Tue, 25 Jun 2019 17:26:06 -0700 (PDT)
Received: by mail-yb1-f180.google.com with SMTP id 189so299364ybh.4
        for <netdev@vger.kernel.org>; Tue, 25 Jun 2019 17:26:06 -0700 (PDT)
X-Received: by 2002:a25:908b:: with SMTP id t11mr878862ybl.473.1561508766319;
 Tue, 25 Jun 2019 17:26:06 -0700 (PDT)
MIME-Version: 1.0
References: <20190625233942.1946-1-olteanv@gmail.com> <20190625233942.1946-2-olteanv@gmail.com>
In-Reply-To: <20190625233942.1946-2-olteanv@gmail.com>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Tue, 25 Jun 2019 20:25:30 -0400
X-Gmail-Original-Message-ID: <CA+FuTSeB60wUxGBCCMXLgWp5uWKc0Z244dL51B=9gz_FU6f8qA@mail.gmail.com>
Message-ID: <CA+FuTSeB60wUxGBCCMXLgWp5uWKc0Z244dL51B=9gz_FU6f8qA@mail.gmail.com>
Subject: Re: [PATCH net-next 01/10] net: dsa: sja1105: Build PTP support in
 main DSA driver
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     f.fainelli@gmail.com, vivien.didelot@gmail.com, andrew@lunn.ch,
        David Miller <davem@davemloft.net>,
        Network Development <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 25, 2019 at 7:40 PM Vladimir Oltean <olteanv@gmail.com> wrote:
>
> As Arnd Bergmann pointed out in commit 78fe8a28fb96 ("net: dsa: sja1105:
> fix ptp link error"), there is no point in having PTP support as a
> separate loadable kernel module.
>
> So remove the exported symbols and make sja1105.ko contain PTP support
> or not based on CONFIG_NET_DSA_SJA1105_PTP.
>
> Signed-off-by: Vladimir Oltean <olteanv@gmail.com>

Acked-by: Willem de Bruijn <willemb@google.com>
