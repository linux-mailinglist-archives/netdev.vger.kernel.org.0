Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B6F613DBEF3
	for <lists+netdev@lfdr.de>; Fri, 30 Jul 2021 21:26:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231147AbhG3T0M (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Jul 2021 15:26:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34034 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230335AbhG3T0M (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Jul 2021 15:26:12 -0400
Received: from mail-io1-xd2f.google.com (mail-io1-xd2f.google.com [IPv6:2607:f8b0:4864:20::d2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 38A3DC061765;
        Fri, 30 Jul 2021 12:26:06 -0700 (PDT)
Received: by mail-io1-xd2f.google.com with SMTP id a13so12752728iol.5;
        Fri, 30 Jul 2021 12:26:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-disposition:content-transfer-encoding;
        bh=1SdEFlqROmHFj3HUxGkbmgw79mMP1UfAqtIWtIV0eqU=;
        b=W6tcu9NK+555WyEu62p2gwpE4VYEJHwTEMZ9/HW2fUxTg0eiytjtEpoPXP/R07aJO9
         0DPVPVRpKTN6fkcgM6/yvBFBHh4BWDZhzn8O8UhXhnz/bzO8pyVW88vPdpSUYe0aG/IQ
         7cw5Y0I09DAKCf5BxKIP4ZISJtVpcvi2PvA7QqqgDqYoG/9DiYMSLrj/N8LrQX6qW/c4
         SVZXEchoKYK8ahbnBArRAO0XnvqbgrsIrEUztQBeNDC5VqOSquCgz1RjD+sxUKQ/jdh8
         b4DKnWNBf0T4CNEzjBpd44goVeksoNOGkEXO3+wg/JNaMQvoQ+GAN4amyxHHG2lf+78X
         C15Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-disposition
         :content-transfer-encoding;
        bh=1SdEFlqROmHFj3HUxGkbmgw79mMP1UfAqtIWtIV0eqU=;
        b=YYDk7cftpocxD3H7RLzu7QRK51cOTaY/wHMmfYlCv9vAg/C4EyPcY/9JWzqAlOA13L
         W45Bqo2R0HWnuoyabhIMop9UEmJDCD5EKb7m7BH3PdgHIHXx6Cgo+wlCX2Xt5vnLgdz8
         vMKFEnZBaT5DpPKvB/qxehuK7V8cJ/6fmb1QRyIfYRiFQ0ojnJQmrtISFOS+p9BUjipB
         4col0nztRhsx7qpGANK7lS4rda6Syn2MKIo9vwiBcmuIp4zp0dHze8vXQ5qnE63eN6WG
         lo1+gjSNXX/ebq2v474agfQAWLN3bc504+N4yg0+djOglM23L27qcDbQcJr/EsrTmmIO
         ZGyA==
X-Gm-Message-State: AOAM532O4Xev+4LRGxDEgi5fxq3+wbi/gk/GFdoeQUHP5cCnZ8fvSvUB
        0uhI43FttXERJvhdCRZbLpsllY6dXpORY8o7
X-Google-Smtp-Source: ABdhPJw3AWyzwHYgQ8HIQ55jKCF389gducqMMPWDj1GfbausUMakuP31ZENQC9HQut62412HBjDN+Q==
X-Received: by 2002:a6b:f714:: with SMTP id k20mr773833iog.148.1627673165677;
        Fri, 30 Jul 2021 12:26:05 -0700 (PDT)
Received: from haswell-ubuntu20.lan ([138.197.212.246])
        by smtp.gmail.com with ESMTPSA id s21sm1560756iot.33.2021.07.30.12.26.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 30 Jul 2021 12:26:04 -0700 (PDT)
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
Subject: Re: [RFC net-next 1/2] net: dsa: tag_mtk: skip address learning on transmit to standalone ports
Date:   Sat, 31 Jul 2021 03:25:55 +0800
Message-Id: <20210730192555.638774-1-dqfext@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210730190706.jm7uizyqltmle2bi@skbuf>
References: <20210728175327.1150120-1-dqfext@gmail.com> <20210728175327.1150120-2-dqfext@gmail.com> <20210728183705.4gea64qlbe64kkpl@skbuf> <20210730162403.p2dnwvwwgsxttomg@skbuf> <20210730190020.638409-1-dqfext@gmail.com> <20210730190706.jm7uizyqltmle2bi@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jul 30, 2021 at 10:07:06PM +0300, Vladimir Oltean wrote:
> > After enabling it, I noticed .port_fdb_{add,del} are called with VID=0
> > (which it does not use now) unless I turn on VLAN filtering. Is that
> > normal?
> 
> They are called with the VID from the learned packet.
> If the bridge is VLAN-unaware, the MAC SA is learned with VID 0.
> Generally, VID 0 is always used for VLAN-unaware bridging. You can
> privately translate VID 0 to whatever VLAN ID you use in VLAN-unaware
> mode.

Now the issue is PVID is always set to the bridge's vlan_default_pvid,
regardless of VLAN awareless.
