Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 866C5319BE7
	for <lists+netdev@lfdr.de>; Fri, 12 Feb 2021 10:33:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230162AbhBLJdS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Feb 2021 04:33:18 -0500
Received: from mail.kernel.org ([198.145.29.99]:41658 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229948AbhBLJdH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 12 Feb 2021 04:33:07 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0DC2F64E70;
        Fri, 12 Feb 2021 09:32:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1613122346;
        bh=uH2uH6dNqR1exkOjgcwbR8+KhXrkNWP1fsTyCq0Y+KI=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=PYbfwt0ODuK1neMa7aSKw9g3e9UF5fTWb0hkKVSgweEFpYgDa5iL/ToXHxRpJ76uk
         nqw+QLywy+P8IpeJS8L9FQ7SQVtYIKd8czeiycUKDlrFoSoPiO6dz2701Y7MYdDKxi
         I7DJhRXl6lRQCXcOTPLwOPvRnvH/oaSZ7O1WXzY3InVs67AQunlgDG9eYf6wcqPYTQ
         77EWSFLWy8SpKirs1AiKJjNGImmUrxrOEkzO7wvyvCLrDMXlpObRLtdq1gYSp7SPMF
         uqb1xwrszVZya4eH5auJS1o1hGug6VKhOJKcMjMJYBwQ1kMo64lZ0MTe2h2lX3VCO8
         Zk1Th4G1NtdYg==
Received: by mail-oo1-f42.google.com with SMTP id i11so1100559oov.13;
        Fri, 12 Feb 2021 01:32:26 -0800 (PST)
X-Gm-Message-State: AOAM53273Uw6uOmqGwUu7qCsO1P8T3G1nrzBrRWqCF1EIlnbR51rOcna
        huh96X3gjMM8Dw7YYoSBTrVBQGq1MqjQdZY+tMo=
X-Google-Smtp-Source: ABdhPJyIY5bdiO51KwR00j/VKqhWeWZNxz7A39ipaie90l20cuJ7MHTu+wONfYseRUG8HaxMMQhE9XfXDvrzJvZrZb8=
X-Received: by 2002:a4a:e383:: with SMTP id l3mr1315042oov.66.1613122345259;
 Fri, 12 Feb 2021 01:32:25 -0800 (PST)
MIME-Version: 1.0
References: <20210212025806.556217-1-nobuhiro1.iwamatsu@toshiba.co.jp> <20210212025806.556217-5-nobuhiro1.iwamatsu@toshiba.co.jp>
In-Reply-To: <20210212025806.556217-5-nobuhiro1.iwamatsu@toshiba.co.jp>
From:   Arnd Bergmann <arnd@kernel.org>
Date:   Fri, 12 Feb 2021 10:32:09 +0100
X-Gmail-Original-Message-ID: <CAK8P3a0Wycgn=Dq8KE+-F2keWj4mKaYQ=Y5RLefYn4gc71vVFw@mail.gmail.com>
Message-ID: <CAK8P3a0Wycgn=Dq8KE+-F2keWj4mKaYQ=Y5RLefYn4gc71vVFw@mail.gmail.com>
Subject: Re: [PATCH v2 4/4] arm: dts: visconti: Add DT support for Toshiba
 Visconti5 ethernet controller
To:     Nobuhiro Iwamatsu <nobuhiro1.iwamatsu@toshiba.co.jp>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        DTML <devicetree@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        punit1.agrawal@toshiba.co.jp, yuji2.ishikawa@toshiba.co.jp,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Feb 12, 2021 at 4:03 AM Nobuhiro Iwamatsu
<nobuhiro1.iwamatsu@toshiba.co.jp> wrote:
> @@ -384,6 +398,16 @@ spi6: spi@28146000 {
>                         #size-cells = <0>;
>                         status = "disabled";
>                 };
> +
> +               piether: ethernet@28000000 {
> +                       compatible = "toshiba,visconti-dwmac";

Shouldn't there be a more specific compatible string here, as well as the
particular version of the dwmac you use?

In the binding example, you list the device as "dma-coherent",
but in this instance, it is not marked that way. Can you find out
whether the device is in fact connected properly to a cache-coherent
bus?

Note that failing to mark it as cache-coherent will make the device
rather slow and possibly not work correctly if it is in fact coherent,
but the default is non-coherent since a lot of SoCs are lacking
that hardware support.

       Arnd
