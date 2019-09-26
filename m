Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0125FBF7ED
	for <lists+netdev@lfdr.de>; Thu, 26 Sep 2019 19:51:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727927AbfIZRvd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Sep 2019 13:51:33 -0400
Received: from mail-ot1-f68.google.com ([209.85.210.68]:34358 "EHLO
        mail-ot1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727917AbfIZRvd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Sep 2019 13:51:33 -0400
Received: by mail-ot1-f68.google.com with SMTP id m19so2814531otp.1;
        Thu, 26 Sep 2019 10:51:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=RRBo1U1wJBMBsFedfuu4Oad4gF7xZhsuM6ZSQHPH+qM=;
        b=OnNRSW3XB6s5ucJQXxJXQsBRy1JldMeRW0F4MSDi7HvaLt3VVeS/2XZvGG78q+LmV3
         zI9U4AbwyAfrGneczOJdor/0MrNlSs3XnhKqZudTp7yX0kD5F29H8LYIHfASWTwjj2QY
         i8rv3TqVE6d7qztHTLIUU+pBwVryPrZqexCbJjYFAXhbD73xnHdBKkA2rmGHQ1xH8S9Q
         hESqdAoIP2vBU5qoxbKk8hunfYJAJdooKHZ5PrE/6/teyMN+6kZz7MDkul1xXF757bko
         SiBzKOPSimTW9QAOn6Q+wFJDYd5x7/TAcU05GEowkzM8+Y8Z28iHSlmA5KA7HibUmb1K
         wWAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=RRBo1U1wJBMBsFedfuu4Oad4gF7xZhsuM6ZSQHPH+qM=;
        b=Naq1aOiOwMO+0owbZSn9kNUveOMhwKBsWzR//jJCP2mW7IhxxAanO3s8m+W7rjAYa8
         vzxrCsOz+uAB3BelXA7GPA/DrzVC5HbLqCzyo7ocNRA63jjPkFLdKoE8S+EuyxkZJgpq
         HkgrcGGSG8tkbk1us9vz4XuBxmJpiISDGryaeamEEjKNwAH3Sry0f61nakkJ/qvBBS82
         +ID53QaZKVssjRnBv5TVX2ihJeZT5oB5+NmJeBH/6L9cnDcniDTQq34LZGYF6CtsOYP7
         2z3pjeNJWZWtuZNEQo/w0HGvIA7ePM3vMC6gLbXdESXuAcpW8yPQFOpnwuDSpgY2lLiZ
         ntMw==
X-Gm-Message-State: APjAAAWTIV49EPK2S0nCwBkzegzEZ0U8AcTK9VgihXXNUwdxlA4+Y8y4
        jlFtWy6iZdy8G+fW5Yo9nZ6L5awbkGdqzdKGca0=
X-Google-Smtp-Source: APXvYqwp9A2tjKQPnay8aqFF0fAxzgQxMo9Y09YF2RKzK274POwhGNUxLAVYH1NJYrKPlKizQ1rGrVEl6PEuFg+SeXU=
X-Received: by 2002:a9d:760d:: with SMTP id k13mr3342916otl.96.1569520291787;
 Thu, 26 Sep 2019 10:51:31 -0700 (PDT)
MIME-Version: 1.0
References: <20190925105822.GH3264@mwanda>
In-Reply-To: <20190925105822.GH3264@mwanda>
From:   Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Date:   Thu, 26 Sep 2019 19:51:20 +0200
Message-ID: <CAFBinCDZRkJJa_PnM5aAzG=pZkf15jB2gLDRkCqA5BwHMvM+Mg@mail.gmail.com>
Subject: Re: [PATCH net] net: stmmac: dwmac-meson8b: Fix signedness bug in probe
To:     Dan Carpenter <dan.carpenter@oracle.com>
Cc:     Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S. Miller" <davem@davemloft.net>,
        Kevin Hilman <khilman@baylibre.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        netdev@vger.kernel.org, linux-stm32@st-md-mailman.stormreply.com,
        kernel-janitors@vger.kernel.org, linux-amlogic@lists.infradead.org
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

+Cc linux-amlogic mailing list

On Wed, Sep 25, 2019 at 12:59 PM Dan Carpenter <dan.carpenter@oracle.com> wrote:
>
> The "dwmac->phy_mode" is an enum and in this context GCC treats it as
> an unsigned int so the error handling is never triggered.
>
> Fixes: 566e82516253 ("net: stmmac: add a glue driver for the Amlogic Meson 8b / GXBB DWMAC")
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Reviewed-by: Martin Blumenstingl <martin.blumenstingl@googlemail.com>

thank you for catching and fixing this!


Martin
