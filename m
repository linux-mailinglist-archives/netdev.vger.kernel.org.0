Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5AE0DC2186
	for <lists+netdev@lfdr.de>; Mon, 30 Sep 2019 15:12:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731017AbfI3NLd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Sep 2019 09:11:33 -0400
Received: from mail-qk1-f196.google.com ([209.85.222.196]:36213 "EHLO
        mail-qk1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726314AbfI3NLd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Sep 2019 09:11:33 -0400
Received: by mail-qk1-f196.google.com with SMTP id y189so7682169qkc.3;
        Mon, 30 Sep 2019 06:11:32 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=yvTBruD6zaxn4sjv75YBQD/wvJnGfoapWmbizXNwOe4=;
        b=QTle/f5DLXEhlyP1XuY4qJyszbl+i54AIelwGPscZpbMgfqMw00kTq+pYnVQWNwW0O
         LNcKarv2fWT9nJ+6OulbjshHCe3MpGGMIClpjW0OOWCMD1TBFi077e7hLSOk8uzICPds
         3CP03cvDfD+71dy2XUx1rXKbEVZYln3lKaruP3oW+83OfdMuEGcXoswDjeLww0VrQajD
         1+nYF3nIsHj562Fu5xuxIEDIwXcvbcWKb8MRTL0L1D+PubjlOb3dquDi2F+LZ4qfPaVl
         TEEeFIKrzK9K9diCjx4FXCJVuYxXvGb77tN4juHjx2GeYPSU5QAKsUgjcc04rZwfI/se
         E+ww==
X-Gm-Message-State: APjAAAVPBo5ijoyMdXycwEYgLgQBalEFehoBccaoxfQxais/64PI3C50
        2V6aGzoA9gyhKi53wTlhPJjHtgcRpboqCQVXoJvSdpUm
X-Google-Smtp-Source: APXvYqxTTAYfkhCHkzMgXzRRscqOu03R0zgUehRs/wbuLHGGTGki2kNYI5vG0oUjtCDGe/Os6ctHOkQ9bUK6AsOCYAI=
X-Received: by 2002:ae9:ef8c:: with SMTP id d134mr18891406qkg.286.1569849091986;
 Mon, 30 Sep 2019 06:11:31 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1569831228.git.Jose.Abreu@synopsys.com> <8879f74a8cc5dffdb14d553c321d64c63ea9fe2d.1569831229.git.Jose.Abreu@synopsys.com>
In-Reply-To: <8879f74a8cc5dffdb14d553c321d64c63ea9fe2d.1569831229.git.Jose.Abreu@synopsys.com>
From:   Arnd Bergmann <arnd@arndb.de>
Date:   Mon, 30 Sep 2019 15:11:15 +0200
Message-ID: <CAK8P3a0Fzvy=PGDKf-K_xSCpuboSJTVY5voYMFJTNhWHkTw-DA@mail.gmail.com>
Subject: Re: [PATCH v2 net 9/9] net: stmmac: xgmac: Fix RSS writing wrong keys
To:     Jose Abreu <Jose.Abreu@synopsys.com>
Cc:     Networking <netdev@vger.kernel.org>,
        Joao Pinto <Joao.Pinto@synopsys.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        "David S. Miller" <davem@davemloft.net>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        linux-stm32@st-md-mailman.stormreply.com,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Sep 30, 2019 at 10:19 AM Jose Abreu <Jose.Abreu@synopsys.com> wrote:
>
> Commit b6b6cc9acd7b, changed the call to dwxgmac2_rss_write_reg()
> passing it the variable cfg->key[i].
>
> As key is an u8 but we write 32 bits at a time we need to cast it into
> an u32 so that the correct key values are written. Notice that the for
> loop already takes this into account so we don't try to write past the
> keys size.

Right, sorry about my mistake.

> Fixes: b6b6cc9acd7b ("net: stmmac: selftest: avoid large stack usage")
> Signed-off-by: Jose Abreu <Jose.Abreu@synopsys.com>

Reviewed-by: Arnd Bergmann <arnd@arndb.de>
