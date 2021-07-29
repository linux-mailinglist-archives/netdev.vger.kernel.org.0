Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 45A383DA89A
	for <lists+netdev@lfdr.de>; Thu, 29 Jul 2021 18:12:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231236AbhG2QMv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Jul 2021 12:12:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58318 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229676AbhG2QMl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Jul 2021 12:12:41 -0400
Received: from mail-lf1-x12f.google.com (mail-lf1-x12f.google.com [IPv6:2a00:1450:4864:20::12f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A656C061799;
        Thu, 29 Jul 2021 09:11:57 -0700 (PDT)
Received: by mail-lf1-x12f.google.com with SMTP id a26so11961236lfr.11;
        Thu, 29 Jul 2021 09:11:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=N/ukz9Nxovf/wu6f2u5vCaEbaJjcjA44qpNIta3Aiwk=;
        b=Qw/ib0YrQysCpDvVZE3IzXPLC/imDhK/VxXHvnOOthIj1PRxXYA6+vexaM47HToVoA
         tTETxJbo3lLqGZKs6DB2vebtNnLp0IUDdbcm5f/Uvm1VdwuYwcCjqhwZddHqSu63vP23
         DVVWLBUwnPtdtGpCE7RH6RNe9sYe11mmVHuagF1lsJuFu/PBS9JQedVLgUWmUS1BxVu4
         rBNTbSIWrpyNoKx7THwvlCyIvvupKo4hF2bC2PXeKOJ00q9temZJhrNsalW2ZTYTj5jV
         Fs5OhQ3VRC93qLEu2YF4tIwz+h9Pt84HoNL3+eHXhD2r8r8NDCm3Bs6okrzCMBA23Rk7
         pr+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=N/ukz9Nxovf/wu6f2u5vCaEbaJjcjA44qpNIta3Aiwk=;
        b=k0SlWvnPpPazq0rgu+Fs8+uV74IEo1Cv+6UwMdpjhIe7CTuVi525ffuCe4Un2+4imA
         8m9/9QnKY07mY2venh0nWxts2dVzHSTE6r9sGMJE2bmkmWCuhP/p3ysSX4lbzAMIIcoW
         p6ots3qI7h7H1WjtfcS4+p8snyIljXI3rEwPnMiDR4IK/ogi+Ye2qzOqx5Vt4UDYU7Sr
         goMWU+nd0u5ZUeLxHQ9HYBlyUb8CDMQc2/apLdKbF/xWzUN/OXxK7/lwzZ5w9jIwXCX6
         Dxlsi3Jhy3nKKyXlj/i2tfl0BtV+M9pasRp5x8waVQb5sQdT0UIWz1yFDHaVHFGwqw8X
         OaHg==
X-Gm-Message-State: AOAM533kQEUYss+K/ql13kwyKovB73/3UusD7WVYt3LHfkQoIo0gDpoE
        s/Cnj6SwGmamcQkFNWBVT6/TZgYdQCDksy1DZSc=
X-Google-Smtp-Source: ABdhPJx8Sflz71gf1mhhsuMz8oCEiGzHhbGVCNN3UMpN5Pi+BQfxX6fNmF2Fo+tsOPc1VWB60X/9nAL2qJZgLb2fc5I=
X-Received: by 2002:ac2:4341:: with SMTP id o1mr4177642lfl.360.1627575115559;
 Thu, 29 Jul 2021 09:11:55 -0700 (PDT)
MIME-Version: 1.0
References: <20210728175327.1150120-1-dqfext@gmail.com> <20210728175327.1150120-3-dqfext@gmail.com>
 <20210729152805.o2pur7pp2kpxvvnq@skbuf>
In-Reply-To: <20210729152805.o2pur7pp2kpxvvnq@skbuf>
From:   DENG Qingfang <dqfext@gmail.com>
Date:   Fri, 30 Jul 2021 00:11:45 +0800
Message-ID: <CALW65jbHwRhekX=7xoFvts2m7xTRM4ti9zpTiah8ed0n0fCrRg@mail.gmail.com>
Subject: Re: [RFC net-next 2/2] net: dsa: mt7530: trap packets from standalone
 ports to the CPU
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
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 29, 2021 at 11:28 PM Vladimir Oltean <olteanv@gmail.com> wrote:
> Actually, on second thought...
> If MT7530 supports 8 FIDs and it has 7 ports, then you can assign one
> FID to each standalone port or VLAN-unaware bridge it is a member of.

The problem is, there is no way to do that..

According to the reference manual:
Filter ID is learned automatically from VLAN Table. 0 is the default value if
VLAN Table is not applicable.

So it is always 0 in VLAN-unaware mode.
