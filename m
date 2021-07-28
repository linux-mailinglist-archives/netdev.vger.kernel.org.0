Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 57AF63D94FF
	for <lists+netdev@lfdr.de>; Wed, 28 Jul 2021 20:08:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230427AbhG1SI1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Jul 2021 14:08:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34072 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229542AbhG1SIZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Jul 2021 14:08:25 -0400
Received: from mail-ed1-x52a.google.com (mail-ed1-x52a.google.com [IPv6:2a00:1450:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 709F5C061757;
        Wed, 28 Jul 2021 11:08:22 -0700 (PDT)
Received: by mail-ed1-x52a.google.com with SMTP id u12so4485549eds.2;
        Wed, 28 Jul 2021 11:08:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=0ZTJnZtraIG0xPipALR10pj5tmmjQMjK6shf1JTwqpk=;
        b=JgPC/3JBmvWiLoyT2NK/dn+kzAbbqaqEpRXKf55vkck4YPBZRdLOwv2yRCvOoVpMEi
         aBS0ltY4gtDOwISN64UiY7MQyxGOuHwV0pj5KulGZMK1zJRFi8esjjQOPJqeqslDRuTp
         vU3X76haMpN+qSk4DgJ0Org9uNSF9E1aIw//lNjmGZ8/ZCaeCPeci7TU8blJVRXfOhKQ
         kEj+a5p8W1P+P6tEDmYLR/HyaQwIR9dB0neIY9v/YtR3wFu54Cma8AUOFxZgk2t1p5TT
         Mz7LcRtOfkCnqzfc64ZUh+gQuAIbhmD5ZNY0qidALiD6YQPjtlJUY5lKGy4kXkSC7sKU
         NGjg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=0ZTJnZtraIG0xPipALR10pj5tmmjQMjK6shf1JTwqpk=;
        b=Peig9qKTkQFJ/9ToKMIXw4jaZ6b7saZ6jJnb8W8QMFuDP5y0dADmPMtZmDlBZwGjET
         Xm1SCXNfiQjrMbpAfYe4/NrmCe3IjRDWUpVKZeQAg9zeDPt4jDk5G7LmIymq0AjiKsaU
         wjd9qw7HwlXB2bYs+rfeuu11sBEreNtdIt7BhMnMAqrWIJ4B5pYY944T3CrlcoKtx5w9
         coGd7/xR8aioCRZVfJfRS/qIzPQvsEdr5VfTeA4TcvTgaDtaIkwWtjxrGE7mAvzCoagh
         98v5r1+o6gNUQqZXLF8fmUsh9hToz+CUxns3eGEyvvKbXy0MGvHcvB7vszJKNW5avvt0
         a8yQ==
X-Gm-Message-State: AOAM530meEGbc8UfyICquC/DrjE8BgrH22eDvPE0p28uJFCHEKXmQh6W
        UzYNRf8cJFz4avVU7hjrhvo=
X-Google-Smtp-Source: ABdhPJwEqVB8zqyKQ4K2P8TAEa37pHxPMHxMS6a23Sxq7bHR4vQ2I2cH6uzNfreWqKQe++YLwYM31Q==
X-Received: by 2002:a05:6402:291a:: with SMTP id ee26mr1342296edb.220.1627495701024;
        Wed, 28 Jul 2021 11:08:21 -0700 (PDT)
Received: from skbuf ([82.76.66.29])
        by smtp.gmail.com with ESMTPSA id x2sm211241edj.37.2021.07.28.11.08.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Jul 2021 11:08:20 -0700 (PDT)
Date:   Wed, 28 Jul 2021 21:08:19 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     DENG Qingfang <dqfext@gmail.com>
Cc:     Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC net-next 0/2] mt7530 software fallback bridging fix
Message-ID: <20210728180819.egvin5gyllmwqp3n@skbuf>
References: <20210728175327.1150120-1-dqfext@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210728175327.1150120-1-dqfext@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 29, 2021 at 01:53:24AM +0800, DENG Qingfang wrote:
> DSA core has gained software fallback support since commit 2f5dc00f7a3e,
> but it does not work properly on mt7530. This patch series fixes the
> issues.

I haven't looked at the patches, just read the commit messages. Your
approach makes sense considering that mt7530 supports ACL rules. For
switches that don't, I was thinking that we could add a check within DSA
that bridging with software uppers such as LAGs can be allowed only as
long as the bridge is VLAN-aware. If it is, then the classified VLAN for
packets on standalone ports can be made == 0, and if independent VLAN
learning is used, then the FDB entries learned on bridged ports will
always have a VLAN ID != 0, so the standalone switch port won't attempt
to shortcircuit the forwarding process towards the bridge port.
Anyway, we can have both solutions, yours and the generic DSA restriction.
I was just not expecting to see a fix for this already, it makes me
think that the DSA restriction for VLAN-unaware software bridging should
not be unconditional, but we should guard it behind a new bool option
like ds->fdb_shared_across_all_ports = true or something like that.
What do you think?
