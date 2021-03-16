Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B2C6733D13B
	for <lists+netdev@lfdr.de>; Tue, 16 Mar 2021 10:56:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236432AbhCPJ4G (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Mar 2021 05:56:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235976AbhCPJzc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Mar 2021 05:55:32 -0400
Received: from mail-ej1-x634.google.com (mail-ej1-x634.google.com [IPv6:2a00:1450:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A4B3AC06174A;
        Tue, 16 Mar 2021 02:55:31 -0700 (PDT)
Received: by mail-ej1-x634.google.com with SMTP id r17so71041357ejy.13;
        Tue, 16 Mar 2021 02:55:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=D8pE+gAt6ykTk6iu18Gsykjh2e+iH3BpnPTvA4JqlAY=;
        b=XiFI45IJLFKHVOizWJznMDvgItTaoT+GMKNp70BMoRkEIlCLDvWGkTnZL3tkyyR4FM
         ZhWdpdE5Hmk8vJfqBqgEhOle9ghmPvNAeA7n55zWcfvjMSmei1GV/x4WqAz3c2emWGkk
         QrGZBBRcQffol+xQTy6MuOKTudSL2zukXg8A38i8xu4jmQ/ALPC+9nJ+fuGBzRTsuPlM
         PGZyVuX7N3RXkvlXxvR7kw5DT1murOweNYyB+DmjEpYjYVSaSVEu5pRPG05fNkswD+/l
         +7SYcx2HAiEAheJRqAKckE7v4fa2vT9jISSOpgG8YK4TTbIjkT52UcsydJLXrBljQQvw
         KFVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=D8pE+gAt6ykTk6iu18Gsykjh2e+iH3BpnPTvA4JqlAY=;
        b=W2+G1n3DPcNz49bAO+URBbR035QP9//2yiQLo94VXi3EuE8bR+utm5ZoSVTBcY7gjG
         Hge/2WGJSH9Be34yQVpFC2U2zdRlhZJtF/QMQtc+Csnr8yO2/EuA+/kCM1UeRXpMUIkR
         Vi9UsTKH+9s7Ai+UHCzdVIb5PGKIAzCBjKYfp49bxolxdtO6zt2SFV9t0HGkqgGbF1kw
         z17+9LoBfpxg273kSEjq9togEagaEXIsAMIP1okTG9TmTM7rZddJPQ5n8RJaQ3zVlLBX
         1P7CfG+mZUXqCGjmnzMkQRJHjhAfnCr7mggO8khf3mHVHn0LQQ5tAH+z+WXzXvCm+e0m
         Lg3w==
X-Gm-Message-State: AOAM5315y+dQmLq8rGBemnnV2mg5TH7ueAJw/uAtDEZ4mYuWGh2vrfP0
        YGbi4BO6cM07w1zYfsL0o+jiVaaNeWw=
X-Google-Smtp-Source: ABdhPJwlSzu63hjHYO/dHln4WJdHEkcor0oiJEgjcMH7GmLuqXTnl+VEpGHjveeFrFCE9UX1a5Vj/w==
X-Received: by 2002:a17:906:4d85:: with SMTP id s5mr26962757eju.43.1615888530393;
        Tue, 16 Mar 2021 02:55:30 -0700 (PDT)
Received: from skbuf (5-12-16-165.residential.rdsnet.ro. [5.12.16.165])
        by smtp.gmail.com with ESMTPSA id u14sm8986535ejx.60.2021.03.16.02.55.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Mar 2021 02:55:30 -0700 (PDT)
Date:   Tue, 16 Mar 2021 11:55:28 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     DENG Qingfang <dqfext@gmail.com>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Russell King <linux@armlinux.org.uk>,
        netdev <netdev@vger.kernel.org>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        "moderated list:ARM/Mediatek SoC support" 
        <linux-mediatek@lists.infradead.org>, linux-kernel@vger.kernel.org,
        Frank Wunderlich <frank-w@public-files.de>,
        =?utf-8?B?UmVuw6k=?= van Dorst <opensource@vdorst.com>
Subject: Re: [PATCH net-next] net: dsa: mt7530: support MDB and bridge flag
 operations
Message-ID: <20210316095528.kl37helfv5jblsih@skbuf>
References: <20210315170940.2414854-1-dqfext@gmail.com>
 <892918f1-bee6-7603-b8e1-3efb93104f6f@gmail.com>
 <20210315200939.irwyiru6m62g4a7f@skbuf>
 <84bb93da-cc3b-d2a5-dda8-a8fb973c3bae@gmail.com>
 <20210315211541.pj5mpy2foi3wlhbe@skbuf>
 <CALW65jbZ1_A-HwzKwKfavQQUBfNZuBSdL8xTGuRrS5qDqi6j3A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALW65jbZ1_A-HwzKwKfavQQUBfNZuBSdL8xTGuRrS5qDqi6j3A@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 16, 2021 at 12:36:24PM +0800, DENG Qingfang wrote:
> On Tue, Mar 16, 2021 at 5:15 AM Vladimir Oltean <olteanv@gmail.com> wrote:
> >
> > Actually this is just how Qingfang explained it:
> > https://patchwork.kernel.org/project/netdevbpf/patch/20210224081018.24719-1-dqfext@gmail.com/
> >
> > I just assume that MT7530/7531 switches don't need to enable flooding on
> > user ports when the only possible traffic source is the CPU port - the
> > CPU port can inject traffic into any port regardless of egress flooding
> > setting. If that's not true, I don't see how traffic in standalone ports
> > mode would work after this patch.
> 
> Correct. Don't forget the earlier version of this driver (before my
> attempt to fix roaming) disabled unknown unicast flooding (trapped to
> CPU) in the same way.

Ok, so in practice you don't really need to touch this register if it's
already all ones.
