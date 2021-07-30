Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0DA423DBCB9
	for <lists+netdev@lfdr.de>; Fri, 30 Jul 2021 17:59:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231732AbhG3P7F (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Jul 2021 11:59:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36892 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230117AbhG3P7E (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Jul 2021 11:59:04 -0400
Received: from mail-io1-xd34.google.com (mail-io1-xd34.google.com [IPv6:2607:f8b0:4864:20::d34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A5ACC06175F;
        Fri, 30 Jul 2021 08:58:58 -0700 (PDT)
Received: by mail-io1-xd34.google.com with SMTP id h1so11973595iol.9;
        Fri, 30 Jul 2021 08:58:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-disposition:content-transfer-encoding;
        bh=v7wLcGraIB7+Os2DeF31Wd7h/jOBDQcFefcKYyZX/aM=;
        b=LTjGwVLhmYVkOKvJsuihzVCRtdsA9rdixkg8UIrZltd8odZNdgZ4Plx7wV3e9F70+q
         mcN2HD29RnVlI0+xN2cD66zdkNSQMwLngcupdSaJ2YAu9F/I3YNVL0qmAQyxUpi7qlnz
         0vWu3lPVG+LKX3+E6zK+aGDSL7PbyLQ4BM0TJ5o4cdA5MBtgQTs4+Bk5jRBIVdxp/qWj
         If36pFoYpJ6BPLHFoJjcjXpY1/5CgbKBhc2aDAeVr2CaSMjdbYohnqfyZVSAPRWS6o+q
         5xhul5npMk3+twS3V+3P/W/Y6+ecy1ci603XC98j2Qre9poqqTuOSeGdNJVWLpBdV00r
         ZWUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-disposition
         :content-transfer-encoding;
        bh=v7wLcGraIB7+Os2DeF31Wd7h/jOBDQcFefcKYyZX/aM=;
        b=HQyA6AeRZB8cQVhaBFmM1QZsdXTaU5873BiEjG3lIjW/U2Ejm6ZfEXLZZoFrVje3zm
         BFkwQ/o2L58D2TG4WqlyNmrExv1lZKaAkQLly8v/mPc6Im7jxA9XArMsRM/DTYiIqZ1q
         8sC2gOuAh/xIenkDfJ2nr1FTOAaqxvuM0rzwLZmO1IEP4PdWabYXONyboMZT3UJFs3Uj
         sXfXNibTk89ZLcmwZXVF3EnunmKX7CNSLD5AQUgni+3SRVILiDVrO7LMhiFo0hBRxCCm
         Txnby2GWNG7w5ggO7/ZKLrue0xBsbI1lXigvpgLrp1l3bFc0pobb99LXNGDvGhle6qM/
         bk6w==
X-Gm-Message-State: AOAM530HQYjU+AgFQG/kwnXgkNdNS+TSiPcSL5R8jBunOpAVRCJfjjuh
        86MVmdQM/HDVa7neGCx/a3w=
X-Google-Smtp-Source: ABdhPJwLaoFNDAcQsEfM5PN4POvnt4KhHYxRAqUmS/3631qr10ReGC3b5vtcVuWXDzR5kbVdXJcxuw==
X-Received: by 2002:a05:6602:2e11:: with SMTP id o17mr348963iow.55.1627660737073;
        Fri, 30 Jul 2021 08:58:57 -0700 (PDT)
Received: from haswell-ubuntu20.lan ([138.197.212.246])
        by smtp.gmail.com with ESMTPSA id u10sm1292627iop.15.2021.07.30.08.58.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 30 Jul 2021 08:58:56 -0700 (PDT)
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
        netdev <netdev@vger.kernel.org>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        "moderated list:ARM/Mediatek SoC support" 
        <linux-mediatek@lists.infradead.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [RFC net-next 2/2] net: dsa: mt7530: trap packets from standalone ports to the CPU
Date:   Fri, 30 Jul 2021 23:58:46 +0800
Message-Id: <20210730155846.290968-1-dqfext@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <CALW65jYYmpnDou0dC3=1AjL9tmo_9jqLSWmusJkeqRb4mSwCGQ@mail.gmail.com>
References: <20210728175327.1150120-1-dqfext@gmail.com> <20210728175327.1150120-3-dqfext@gmail.com> <20210729152805.o2pur7pp2kpxvvnq@skbuf> <CALW65jbHwRhekX=7xoFvts2m7xTRM4ti9zpTiah8ed0n0fCrRg@mail.gmail.com> <20210729165027.okmfa3ulpd3e6gte@skbuf> <CALW65jYYmpnDou0dC3=1AjL9tmo_9jqLSWmusJkeqRb4mSwCGQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jul 30, 2021 at 11:45:41PM +0800, DENG Qingfang wrote:
> So I came up with a solution: Set PORT_VLAN to fallback mode when in
> VLAN-unaware mode, this way, even VLAN-unaware bridges will use
> independent VLAN filtering. Then assign all standalone ports to a

independent VLAN *learning

> reserved VLAN.
