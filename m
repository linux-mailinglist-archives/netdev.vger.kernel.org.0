Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 45FFC3DE125
	for <lists+netdev@lfdr.de>; Mon,  2 Aug 2021 22:59:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231659AbhHBU7X (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Aug 2021 16:59:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33790 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231194AbhHBU7W (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Aug 2021 16:59:22 -0400
Received: from mail-ed1-x52a.google.com (mail-ed1-x52a.google.com [IPv6:2a00:1450:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D979C061760;
        Mon,  2 Aug 2021 13:59:11 -0700 (PDT)
Received: by mail-ed1-x52a.google.com with SMTP id x90so26258856ede.8;
        Mon, 02 Aug 2021 13:59:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=w+kjeXZn22Jr79nUGbix7ah/oSHxdioLF/ZCkl2Qub4=;
        b=q9nemMRF/WSOv+S3b/pGwEpZvXruqpf++H8j70fVBSnlwIpv1taA9OCzTyFsY9vCzA
         Hx4o8eXwqyVsauqgTyQ0EaZi34B5MrwytQIPv0+p5ODgyG4RZSwxztKW1jXgQ7ejvVlq
         234NpGtbrFngZaqL5g0uPZqRuhbBz4FUBUJAHqXkvL0hmZX5AIzqNhClFegwv+mc5PeK
         zQlbjihmAOTdT6PeiFB46OgCiIiwNZT3DUP5GmPX5s0rWgYqy5tkpArIxFclX0vun91r
         YvC1qgs8AAE+P7zMzqA5KFJkeRImFCtLdtHHktjiOpiuFM4HML5dO6EBZfTNz3tJuO09
         q99g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=w+kjeXZn22Jr79nUGbix7ah/oSHxdioLF/ZCkl2Qub4=;
        b=eOBQqZKUvh2Su4uuWqoSk7KCcgqQVhDymyZOyrZGcNr+9NSuGhjs8GA+iOG2ppvFf7
         /tVfXdL2+Y5EB6GEHn3/2bSw+NyUrzTsidBtY0w0NikdhN/zuo+G0HCk/d8vHiR9K2Z2
         R7iFc8xi5E4FIrRINsHUym/+5XBZUiRnW4ZZxgT7P6wIWQJwztJos3GOjcxvXZl8/d6Y
         mKLIz6TVw56d+S1tEyNKV8POPe522Ogwj2NY2eAMLj6x3MLka3ISxHXoDSJb8X98D8ps
         /xFwK8hS2vQB3uDP1wSJORXyWzMyTGUBvojl6CfRvt+EwbBzNTZ0fD8cHYfiYBF6EA2Q
         kvFg==
X-Gm-Message-State: AOAM530bL2BC31eWTyL42Ael1r4eXNK4Co1QGZZE0VOX3/WBMHiFMu7Q
        tmrxqkfeiJtGlgH5p26vrtQ=
X-Google-Smtp-Source: ABdhPJxjms0X24JkdPMRhTWj+Di0kYgwkkrV0BbXstM0ANBHXMWsT+FTOdCVkDSPzkC2EulX+M60jg==
X-Received: by 2002:a05:6402:31e6:: with SMTP id dy6mr21666585edb.36.1627937950208;
        Mon, 02 Aug 2021 13:59:10 -0700 (PDT)
Received: from skbuf ([188.25.144.60])
        by smtp.gmail.com with ESMTPSA id w6sm6881617edq.58.2021.08.02.13.59.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Aug 2021 13:59:09 -0700 (PDT)
Date:   Mon, 2 Aug 2021 23:59:08 +0300
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
        linux-mediatek@lists.infradead.org, linux-kernel@vger.kernel.org,
        Eric Woudstra <ericwouds@gmail.com>,
        =?utf-8?B?UmVuw6k=?= van Dorst <opensource@vdorst.com>,
        Frank Wunderlich <frank-w@public-files.de>
Subject: Re: [RFC net-next v2 4/4] Revert "mt7530 mt7530_fdb_write only set
 ivl bit vid larger than 1"
Message-ID: <20210802205908.queaqshisqk24pkf@skbuf>
References: <20210731191023.1329446-1-dqfext@gmail.com>
 <20210731191023.1329446-5-dqfext@gmail.com>
 <20210802134409.dro5zjp5ymocpglf@skbuf>
 <20210802154838.1817958-1-dqfext@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210802154838.1817958-1-dqfext@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Aug 02, 2021 at 11:48:38PM +0800, DENG Qingfang wrote:
> On Mon, Aug 02, 2021 at 04:44:09PM +0300, Vladimir Oltean wrote:
> > Would you mind explaining what made VID 1 special in Eric's patch in the
> > first place?
>
> The default value of all ports' PVID is 1, which is copied into the FDB
> entry, even if the ports are VLAN unaware. So running `bridge fdb show`
> will show entries like `dev sw0p0 vlan 1 self` even on a VLAN-unaware
> bridge.
>
> Eric probably thought VID 1 is the FDB of all VLAN-unaware bridges, but
> that is not true. And his patch probably cause a new issue that FDB is
> inaccessible in a VLAN-**aware** bridge with PVID 1.
>
> This series sets PVID to 0 on VLAN-unaware ports, so `bridge fdb show`
> will no longer print `vlan 1` on VLAN-unaware bridges, and we don't
> need special case in port_fdb_{add,del} for assisted learning.

All things seriously worth mentioning in the commit message.
