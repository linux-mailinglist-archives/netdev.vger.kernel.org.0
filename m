Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 504145EDBE
	for <lists+netdev@lfdr.de>; Wed,  3 Jul 2019 22:41:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727127AbfGCUlT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Jul 2019 16:41:19 -0400
Received: from mail-qt1-f194.google.com ([209.85.160.194]:33762 "EHLO
        mail-qt1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726955AbfGCUlS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Jul 2019 16:41:18 -0400
Received: by mail-qt1-f194.google.com with SMTP id h24so5690138qto.0
        for <netdev@vger.kernel.org>; Wed, 03 Jul 2019 13:41:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=7UrgCJh7ynybyKVyA1NdfWdn/54CS6hsmMgsbu19Pro=;
        b=1xNP2ViByzwg7pUQH7ecLseKnc6Kf20ns0UGpDVoStT7GQGvwmwE6SJ0k1iU5yGYP1
         YkAGhrv0HN2QIN8wQn6mXjkbKkeU5iP2vQLDN2W3vBP0GIuM0QWyFHyFz6ZvUz/PtGTu
         LbFashhUsq2OaHMk3U4qMxU16BQ81vhjqjqPqmmr29MJZE1diWeHz5ZEjXmgySm2Zcwl
         vEonLtxm9XIuu8gCqbEbILaGG75AS6iF8/PterCoeKr5wJQYNeLwGrDFJEKOPk6IN3/W
         Do59BlnuM6zXZnfMXtx78p5hoPPsg3DnI2cUOWPuIIvurACVL6MnBqrNQuyXjnrggF21
         sFAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=7UrgCJh7ynybyKVyA1NdfWdn/54CS6hsmMgsbu19Pro=;
        b=iyQNXi+fs/3OgI5+xG0lZ+n/jhsLxagzL6nEXqVXY3LqbMtHT00O4rce++dxAzxwHS
         sXOIWvDDavEk3lrN914WWwftyU9Xtg1MaX6HMcs1nQIazgdSX9Ay4Q13QfQHsaefFJU0
         PFRKb5+zSA/A8PCsADEBe4Zo7dYU9t+8HbyJaTIr/u1hjtLibBTeJRcF9RSzdB53MprG
         8B6qkRIJNazpUV6EaGQMpjOlmmL3KQbY8mPcqYmQSCF6jUp9iRu9qWqRXWYKQxzmezdt
         iay7AJ/UF0qPFL5gLYpvXdPLb5YOdPxOF+8kzLKGvh4O/UQYzgGAUr41b9rjL0F7I/k9
         cbmw==
X-Gm-Message-State: APjAAAX9UJnEvDGGMEzTDSDfYbopr20mEptVfSE88jMiOlsgWrx0kE5B
        NZqJgNZH9+iBLUcHg6x//AT2KA==
X-Google-Smtp-Source: APXvYqyNeh/RKaf68L+vXqVqLoLkpZavQ2W3Xnd/iPV5JNOmdb39n5515aLelaTUJXaJbjErhrpkTg==
X-Received: by 2002:aed:2fa7:: with SMTP id m36mr33207887qtd.344.1562186477682;
        Wed, 03 Jul 2019 13:41:17 -0700 (PDT)
Received: from cakuba.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id y20sm1452439qka.14.2019.07.03.13.41.15
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Wed, 03 Jul 2019 13:41:17 -0700 (PDT)
Date:   Wed, 3 Jul 2019 13:41:13 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Jose Abreu <Jose.Abreu@synopsys.com>
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org,
        Joao Pinto <Joao.Pinto@synopsys.com>,
        "David S . Miller" <davem@davemloft.net>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Maxime Ripard <maxime.ripard@bootlin.com>,
        Chen-Yu Tsai <wens@csie.org>
Subject: Re: [PATCH net-next 1/3] net: stmmac: Implement RX Coalesce Frames
 setting
Message-ID: <20190703134113.0e256b33@cakuba.netronome.com>
In-Reply-To: <003df660052f33891ab74ee79c5f1272b72bde54.1562149883.git.joabreu@synopsys.com>
References: <cover.1562149883.git.joabreu@synopsys.com>
        <003df660052f33891ab74ee79c5f1272b72bde54.1562149883.git.joabreu@synopsys.com>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed,  3 Jul 2019 12:37:48 +0200, Jose Abreu wrote:
> Add support for coalescing RX path by specifying number of frames which
> don't need to have interrupt on completion bit set.
> 
> This is only available when RX Watchdog is enabled.
> 
> Signed-off-by: Jose Abreu <joabreu@synopsys.com>
> Cc: Joao Pinto <jpinto@synopsys.com>
> Cc: David S. Miller <davem@davemloft.net>
> Cc: Giuseppe Cavallaro <peppe.cavallaro@st.com>
> Cc: Alexandre Torgue <alexandre.torgue@st.com>
> Cc: Maxime Coquelin <mcoquelin.stm32@gmail.com>
> Cc: Maxime Ripard <maxime.ripard@bootlin.com>
> Cc: Chen-Yu Tsai <wens@csie.org>

Acked-by: Jakub Kicinski <jakub.kicinski@netronome.com>
