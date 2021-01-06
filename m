Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0A2392EBC04
	for <lists+netdev@lfdr.de>; Wed,  6 Jan 2021 11:02:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726358AbhAFKBL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Jan 2021 05:01:11 -0500
Received: from mail-vs1-f44.google.com ([209.85.217.44]:38721 "EHLO
        mail-vs1-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725868AbhAFKBK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Jan 2021 05:01:10 -0500
Received: by mail-vs1-f44.google.com with SMTP id z16so1496445vsp.5;
        Wed, 06 Jan 2021 02:00:54 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ZwCwHGcGyMjPzgAxAk8uPnbRSyy1m6IrO0a6BEkCGaw=;
        b=hOEZMqqQYFAhX2q6nS1ohMzfG02+S/pGdMmBKXYIkSUf2ohHtKghgTKfTcQ1CNF+EB
         Uhff+6JbOcBO4NGP0SQvxKQgYyLz3xOf8DZa2cECGkWpbIkYXLMo8IWYM09TqAtvwAVn
         SPNA3HAuVFXHdHC+DwTm/l1vrAfeZFNRvAS9hLOWPAUUz3Wd2lfiBWLr4LAs8UduoQiN
         qMvVAhKol0IBmumMcqivqmclWrzVkVTRRnTGlXxDbw6tIC5bDbPgPmhKppKp89Iqx6CU
         cBQCJ3N2V2oqEtdC+4AfWChCBYzHEQUcRJl4NJJ2Q8LS63tDTW0IWWcdQa8zMVIXlBcu
         nzmw==
X-Gm-Message-State: AOAM531XATXnHCDjmOUyqh3GgNYss8PBG/gpNqJ/qIJdOjk6JhY1DTyh
        pEp1cAy1mXP/YdpGHlj3vO6zJ0GdeVtPkQ==
X-Google-Smtp-Source: ABdhPJyPWcmniYLhwJQQ2gwBMsTnXTFzOR83PcbR3aUaEjH+FBv7gxsxUCupOifJTD4MYsw6rohaTw==
X-Received: by 2002:a67:3142:: with SMTP id x63mr2481806vsx.37.1609927228593;
        Wed, 06 Jan 2021 02:00:28 -0800 (PST)
Received: from mail-vs1-f49.google.com (mail-vs1-f49.google.com. [209.85.217.49])
        by smtp.gmail.com with ESMTPSA id m186sm313185vkm.15.2021.01.06.02.00.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 06 Jan 2021 02:00:27 -0800 (PST)
Received: by mail-vs1-f49.google.com with SMTP id s85so1503881vsc.3;
        Wed, 06 Jan 2021 02:00:27 -0800 (PST)
X-Received: by 2002:a05:6102:215c:: with SMTP id h28mr2354033vsg.58.1609927226798;
 Wed, 06 Jan 2021 02:00:26 -0800 (PST)
MIME-Version: 1.0
References: <20210103112542.35149-1-samuel@sholland.org> <20210103112542.35149-2-samuel@sholland.org>
In-Reply-To: <20210103112542.35149-2-samuel@sholland.org>
From:   Chen-Yu Tsai <wens@csie.org>
Date:   Wed, 6 Jan 2021 18:00:14 +0800
X-Gmail-Original-Message-ID: <CAGb2v64MUmYVJivNBkF4P=vPpkVN-nwRzZWYQogMdkSdYFHN-w@mail.gmail.com>
Message-ID: <CAGb2v64MUmYVJivNBkF4P=vPpkVN-nwRzZWYQogMdkSdYFHN-w@mail.gmail.com>
Subject: Re: [PATCH net-next 1/5] net: stmmac: dwmac-sun8i: Return void from
 PHY unpower
To:     Samuel Holland <samuel@sholland.org>
Cc:     Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Maxime Ripard <mripard@kernel.org>,
        Jernej Skrabec <jernej.skrabec@siol.net>,
        Corentin Labbe <clabbe@baylibre.com>,
        Ondrej Jirman <megous@megous.com>,
        netdev <netdev@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-sunxi <linux-sunxi@googlegroups.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Jan 3, 2021 at 7:25 PM Samuel Holland <samuel@sholland.org> wrote:
>
> This is a deinitialization function that always returned zero, and that
> return value was always ignored. Have it return void instead.
>
> Signed-off-by: Samuel Holland <samuel@sholland.org>

Reviewed-by: Chen-Yu Tsai <wens@csie.org>
