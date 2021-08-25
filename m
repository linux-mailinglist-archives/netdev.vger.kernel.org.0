Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 054553F6DEF
	for <lists+netdev@lfdr.de>; Wed, 25 Aug 2021 05:56:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236811AbhHYD4v (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Aug 2021 23:56:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35914 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235816AbhHYD4l (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Aug 2021 23:56:41 -0400
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 526D5C061757;
        Tue, 24 Aug 2021 20:55:56 -0700 (PDT)
Received: by mail-pj1-x102d.google.com with SMTP id fz10so4259564pjb.0;
        Tue, 24 Aug 2021 20:55:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-disposition:content-transfer-encoding;
        bh=rIAtfGj5qvVENV9WWVZMFVGBJuT4wuu3+yhzjBnrODs=;
        b=FFLev3F07ILuAs83PdrenjINmyoPq0n77COtk2VIQDbIdEIeXPxZuh6I0B7OU+4Tt1
         /E2LjvMMHnXZrAtRJc68INgHwY+om8QEUIereki+erzJLc59mmv0+1E4hb+pliTjsmta
         ndeTK1oMki5pOWNxKSvJzaJsxln2TScgQ5SamfpiNJoXpv3KMxIBerlRqClBYSqdCooB
         U8lLIVYl7tisFR0hGB6gNqVn0ZCbM4B+L/PJxhQg/O5q8o6fwNJUUyiw2WLrhxzP8wc0
         2Cpx0nIq0CB10pBWCp0R5uPg16kAk9b44mmjvPweTdxHy3yQnIEoIZKrKj6BApCD6lhS
         O8ow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-disposition
         :content-transfer-encoding;
        bh=rIAtfGj5qvVENV9WWVZMFVGBJuT4wuu3+yhzjBnrODs=;
        b=SLThGdUJpMb5UI5c0/7Pl7lsnOPQetayGyiseigS+6jSs7I2sfsmamBV+1mvhdj9VK
         dYlPDrdxzxs2w8jzE/M8T5hA/jSLN30Pa3EuaFYJhI60G6FYqKUWfDmVM2tp4Zix6gI3
         wPXRQLtbdgXJFght3GI5c7EHjbKPbHIAcurD5+2dFJMvhdWwb7y8XE7GHcY33GzXP38G
         CfA8a2x4jIu1a47zvObLiiOLoUwqdJEQKvH/RraEovpDwcuJfOzXFy44ck3IkCjPC/PY
         HJ0m8oklP5riOJ7Wvd3dlW79rB/Dd97TtWPxR2XaTf3w+rvIkLG4sqrvmOaWUkjx8vIh
         8MaA==
X-Gm-Message-State: AOAM5332q9Jtq+5AcfUd9ToGiUmoBzAXJi7QFqpZi/j08M3h3ODGUFIm
        jZ04/cQ/dJaKEp2bA7+p9kM=
X-Google-Smtp-Source: ABdhPJzGY1gLl625kG0Emo3PW5/KunYn2jQ8ZmvIFLtams9OGpbD31KTB44Cic0fv4r3bexeCiy9bA==
X-Received: by 2002:a17:90b:4a82:: with SMTP id lp2mr8271118pjb.103.1629863755885;
        Tue, 24 Aug 2021 20:55:55 -0700 (PDT)
Received: from haswell-ubuntu20.lan ([138.197.212.246])
        by smtp.gmail.com with ESMTPSA id a4sm21298248pfk.0.2021.08.24.20.55.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Aug 2021 20:55:55 -0700 (PDT)
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
        Philipp Zabel <p.zabel@pengutronix.de>,
        Russell King <linux@armlinux.org.uk>,
        "open list:MEDIATEK SWITCH DRIVER" <netdev@vger.kernel.org>,
        "moderated list:ARM/Mediatek SoC support" 
        <linux-arm-kernel@lists.infradead.org>,
        "moderated list:ARM/Mediatek SoC support" 
        <linux-mediatek@lists.infradead.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net-next] net: dsa: mt7530: manually set up VLAN ID 0
Date:   Wed, 25 Aug 2021 11:55:45 +0800
Message-Id: <20210825035545.1836274-1-dqfext@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210824173714.cgpt2addxyjzlbyy@skbuf>
References: <20210824165253.1691315-1-dqfext@gmail.com> <20210824165742.xvkb3ke7boryfoj4@skbuf> <20210824173237.1691654-1-dqfext@gmail.com> <20210824173714.cgpt2addxyjzlbyy@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Aug 24, 2021 at 08:37:14PM +0300, Vladimir Oltean wrote:
> On Wed, Aug 25, 2021 at 01:32:37AM +0800, DENG Qingfang wrote:
> > Okay. So the Fixes tag should be 6087175b7991, which initially adds the
> > software fallback support for mt7530.
> 
> Ok. Did the old code not need VLAN 0 for VLAN-unaware ports, or are you
> saying that since the VLAN table lookup was bypassed completely in the
> old code, 'no VLAN 0' was an inconsequential error?
> 
> I think it's the latter. Just wanted to make sure. So that means, either
> this Fixes: tag or the other, the patch still belongs to net-next. From
> my side you shouldn't need to resend.

You're right. The old code does not use VLAN table lookup for VLAN-unaware
ports, and the current code set VLAN-unaware ports to fallback mode so
missing VLAN 0 will only make them fallback to SVL.

> 
> Reviewed-by: Vladimir Oltean <olteanv@gmail.com>
