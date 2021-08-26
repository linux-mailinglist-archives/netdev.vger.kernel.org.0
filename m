Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7AD0D3F8212
	for <lists+netdev@lfdr.de>; Thu, 26 Aug 2021 07:30:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238509AbhHZFay (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Aug 2021 01:30:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48418 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229753AbhHZFax (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Aug 2021 01:30:53 -0400
Received: from mail-pg1-x52a.google.com (mail-pg1-x52a.google.com [IPv6:2607:f8b0:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 37417C061757;
        Wed, 25 Aug 2021 22:30:07 -0700 (PDT)
Received: by mail-pg1-x52a.google.com with SMTP id n18so2085123pgm.12;
        Wed, 25 Aug 2021 22:30:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-disposition:content-transfer-encoding;
        bh=x4RmyD5fclG+LrgWWesbcdVQE97Kggxj6lIU2hXpp1s=;
        b=Iwld+o5kE3cC7dKFDVPDZ5uAL6M+SDCzXILZlsoW4OOYMm1/e0Pz1EuVluvNGV+rop
         Vd7AzU0ZiFZWltIItaqBiQH8BFMyJCN11+7Hg0sWlJQq3YRn2FjbESWBmqHttTe0L3L0
         4zywT7UMIMUTmOUt8yeDuQdSyFNUrWkcJFlAUM4Gh5AU6SinB9cNKI6CyB2qEne/VZO5
         dFeQ9aOT/l5wfnPAhkUi2zi3V3+K6tvp3WZ0yOMf3ZePhkzSV8+iA4qsPMg325NJrN3T
         c0TdPGJn/xdGWEn9vHLJoRcl5l+zhTLrJsnc477kPc37YLpR46u2Sf5O3cycGwttBe8M
         8rvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-disposition
         :content-transfer-encoding;
        bh=x4RmyD5fclG+LrgWWesbcdVQE97Kggxj6lIU2hXpp1s=;
        b=bTHFN4OWPKneT1ISfaQxwbBxJjrrjFw2tXKkTyGHIgHeLJcx6YmeooxSBABY+b3Yn0
         XC7pGGOte0XQQzy22C5nSVN2C9wNnDvELPHqrCIxa8XUtAZugCSf4/MAdu2OHEf8A+wl
         VfoAh8rg5nOR/OQGHXx9lVxwgk2d/U0/G3pt51Q9EIVMKs7HmkrZtcOdADBh5KvJr4Wf
         3M6iyo2FczMkHILjfgLKnvKEnFg9dmGtsge/pythil4Hzd+7Zen7BH9uj8Bf6wtF3kPt
         qV38dyR2v6PD9W+GyCuSrSt11RA3AdqvshAZR+T87noMNucrPZ+VKLJDFa9l/QVBYp+X
         6+VQ==
X-Gm-Message-State: AOAM53222UuaXuG9ppFlqLSX85jkh80eK16E9r+dBsPcx7SKZQgZZrjh
        EKyF6cYocoUPswmb99RWD5E9LSO1qWqMcWIp
X-Google-Smtp-Source: ABdhPJwXQo89ZTUyaW5hgncilg4Qn18/2ISbQ2HecVAww0acCXr7JAbk83ELloXGBqr8+KhTkkp1xQ==
X-Received: by 2002:a62:e90b:0:b029:30e:4530:8dca with SMTP id j11-20020a62e90b0000b029030e45308dcamr2041539pfh.17.1629955806691;
        Wed, 25 Aug 2021 22:30:06 -0700 (PDT)
Received: from haswell-ubuntu20.lan ([138.197.212.246])
        by smtp.gmail.com with ESMTPSA id u3sm1316019pfg.58.2021.08.25.22.30.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Aug 2021 22:30:06 -0700 (PDT)
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
        linux-mediatek@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC net-next 2/2] net: dsa: tag_mtk: handle VLAN tag insertion on TX
Date:   Thu, 26 Aug 2021 13:29:56 +0800
Message-Id: <20210826052956.3101243-1-dqfext@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210826000349.q3s5gjuworxtbcna@skbuf>
References: <20210825083832.2425886-1-dqfext@gmail.com> <20210825083832.2425886-3-dqfext@gmail.com> <20210826000349.q3s5gjuworxtbcna@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Aug 26, 2021 at 03:03:49AM +0300, Vladimir Oltean wrote:
> 
> You cannot just remove the old code. Only things like 8021q uppers will
> send packets with the VLAN in the hwaccel area.
> 
> If you have an application that puts the VLAN in the actual AF_PACKET
> payload, like:
> 
> https://github.com/vladimiroltean/tsn-scripts/blob/master/isochron/send.c
> 
> then you need to handle the VLAN being in the skb payload.

I've actually tested this (only apply patch 2 without .features) and it
still worked.

The comment says the VLAN tag need to be combined with the special tag in
order to perform VLAN table lookup, so we can set its destination port
vector to all zeroes and the switch will forward it like a data frame
(TX forward offload), but as we allow multiple bridges which are either
VLAN-unaware or VLAN-aware with the same VID, there is no way to determine
the destination bridge unless we maintain some VLAN translation mapping.
