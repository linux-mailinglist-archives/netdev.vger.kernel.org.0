Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4BAC03DF176
	for <lists+netdev@lfdr.de>; Tue,  3 Aug 2021 17:30:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236726AbhHCPaK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Aug 2021 11:30:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45452 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236897AbhHCP30 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Aug 2021 11:29:26 -0400
Received: from mail-pl1-x629.google.com (mail-pl1-x629.google.com [IPv6:2607:f8b0:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D2268C0617B9;
        Tue,  3 Aug 2021 08:29:11 -0700 (PDT)
Received: by mail-pl1-x629.google.com with SMTP id a20so24242061plm.0;
        Tue, 03 Aug 2021 08:29:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-disposition:content-transfer-encoding;
        bh=TlfK2VJ6iI6/r4Nhmzrn4xmy7cO/lNNzYPI68RNrCFQ=;
        b=fTs/Iloe6nn8kpH7p7BX16GKQoe81CLly2hJENeR9Qj7CindAwu9tAhFbrRRZC/euG
         tlf8FkOzthBGdNkPoTCoo0xxHvFBmdThHm35IOUzwelepzVFbWtp2DylyW1T9NOhUHgx
         5iqBvvdKtq1Kz3d/6cfa9fM9ntigN6X/W92bEWf3bCdLdU3idj5tm9FNOmA2ZqkYBI9l
         3yz4iUNpJqVPtEt6mvAxkf7gzM97Mg7VwLFa4TRLY+JPA4XhX90KDfMh7UoPbtuJrqYH
         YZwcchAzRdB0mFb9b4zBTXmCEpkYvFM1qIc6kqhH18gxRPU88ZXYZshWCsOhBJbKoqcM
         TVmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-disposition
         :content-transfer-encoding;
        bh=TlfK2VJ6iI6/r4Nhmzrn4xmy7cO/lNNzYPI68RNrCFQ=;
        b=sWeLGbh3hyMMVL4J2moHMb+m/LT/oOEq8HifmArxe/pOhYkDROFTrNYFzi15WcfnZj
         UcC7UuTS+NkbUgAHnFooU+a1cw4yvCZCLWtjDO31MKenfjnapq8zt4Rmv1SLPk3O1hn+
         EsizjUUX4duAntrxQXKMylVLpWIDBrP7OY8quBF9bM9DhisKNK06fgu+hnZpEy/NkVrp
         EPUhJlCjL4bikEdwR+7jYxboz3I8FkYyTE2lAhq0IPrb/GMyfsP60Tikhlo+JQWU2PoO
         RWdlF+m3WMJhtrptGw9Hx9VY9xlRUVywJqD4730f3ngo/G+z9mW1tNhE8pYYAlEfgWGG
         1euw==
X-Gm-Message-State: AOAM5327k/S62x+sUCN3L/8yB6jJdvBqRXkNELblVOCk53LwRtlG0uTV
        9kLVhqYZuNQIyKbdCOZGsPU=
X-Google-Smtp-Source: ABdhPJyWy13jq6LAmzzH+btwVFS22zDWog94fqgmyTGBy8+HveSaFu8pfbjvptmpLz0rQ/dMQhP5PA==
X-Received: by 2002:a17:902:d383:b029:12c:bebe:725a with SMTP id e3-20020a170902d383b029012cbebe725amr7086064pld.24.1628004551377;
        Tue, 03 Aug 2021 08:29:11 -0700 (PDT)
Received: from haswell-ubuntu20.lan ([138.197.212.246])
        by smtp.gmail.com with ESMTPSA id g1sm9205786pfo.0.2021.08.03.08.29.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Aug 2021 08:29:10 -0700 (PDT)
From:   DENG Qingfang <dqfext@gmail.com>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, linux-kernel@vger.kernel.org,
        Eric Woudstra <ericwouds@gmail.com>,
        =?iso-8859-1?Q?Ren=E9?= van Dorst <opensource@vdorst.com>,
        Frank Wunderlich <frank-w@public-files.de>,
        Ilya Lipnitskiy <ilya.lipnitskiy@gmail.com>
Subject: Re: [PATCH net-next 4/4] net: dsa: mt7530: always install FDB entries with IVL and FID 1
Date:   Tue,  3 Aug 2021 23:29:01 +0800
Message-Id: <20210803152901.2913035-1-dqfext@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210803144552.fluxxfoey2tbqyyu@skbuf>
References: <20210803124022.2912298-1-dqfext@gmail.com> <20210803124022.2912298-5-dqfext@gmail.com> <20210803144552.fluxxfoey2tbqyyu@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Aug 03, 2021 at 05:45:52PM +0300, Vladimir Oltean wrote:
> 
> Maybe it would be good to resend with a set of #defines for the
> standalone/bridged port FID values after all, what do you think?

Will do.
