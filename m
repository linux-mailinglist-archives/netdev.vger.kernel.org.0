Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F254717AE2
	for <lists+netdev@lfdr.de>; Wed,  8 May 2019 15:41:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727670AbfEHNlf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 May 2019 09:41:35 -0400
Received: from mail-qt1-f195.google.com ([209.85.160.195]:39230 "EHLO
        mail-qt1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727584AbfEHNlf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 May 2019 09:41:35 -0400
Received: by mail-qt1-f195.google.com with SMTP id y42so3734856qtk.6;
        Wed, 08 May 2019 06:41:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:message-id:from:to:cc:subject:in-reply-to:references
         :mime-version:content-disposition:content-transfer-encoding;
        bh=nA3fMKI7/zgpn3qz32bnSjcksgNREGdaMYOqVHhhKG4=;
        b=YU4SsjMpd3rSp33BZthenhW2wDRXloytJNFxp05+2bKdndmcTMnLG6QtbQ5D0Z7f/r
         48lDisJkSAS2tpi9+BQf2REx3YnR7qhFd0fvzjAvpLzJg2NDFi3OcftsJHpTtgZdlH1i
         hDqRI77b2fbNhuoVuOxq2VIsaycFYdee6l5EzrpBMxiVVXe5lwxbsjqIvg3IHhT2JXPb
         kIADBtidxF2+xPEF4w1UmwFFsqXpcd9Kdl8SOFfJ+doOmoxGSoaIMbwrjDeVJK/qPaIV
         reqg7pJJKKTMurMNXe759sPX1Yrwd3bbzfkG/tIPs4t56vye7jkztdpUI5Lk7SU+Yxoz
         S2mA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:from:to:cc:subject:in-reply-to
         :references:mime-version:content-disposition
         :content-transfer-encoding;
        bh=nA3fMKI7/zgpn3qz32bnSjcksgNREGdaMYOqVHhhKG4=;
        b=V6u636sw6kZX6/k8mCCYZMRWBLR+1YmluBtitk/47zAZuN/TBrNpv4pXUI8d7HTCwT
         /tlzii43Ym6dkYtdF5S0IT8acdcW9HTA7V3rQlm9Yulc5NPzoKYO2PRkOJ5z50OKgkq8
         IJLLXq5Y+bdl/ywENfGRg5L12pI8a7/ByrnzhWacgvUcYBJj+GWFsRCXDMgAgmZyGtPC
         RkBxOodERpsR3uw7p87syVbqgNeye42ulUM65ZJlG1op6BdbBi2eRXl98LOri0YtArQw
         U+/4MOa5lXQEG40bNjmlYmFUQMZwSX+11wzPofHNRDm5ebnlLXDY5wwnjjhzc6bbf5Ns
         Hpag==
X-Gm-Message-State: APjAAAVeQieEStfqzS63/e5WDbduOleP6bmRDX+SXtKamCKGdb2CqT9A
        o74sQM+5hIBJqZUyWW3rHdY=
X-Google-Smtp-Source: APXvYqzpMEv6+/ACrNZKi8RXyCkm10LasjzAKUF5qdPwx3lICUOX/T//2fjlz6opK/YWezX3fHvHkQ==
X-Received: by 2002:ac8:18e6:: with SMTP id o35mr32513150qtk.77.1557322894405;
        Wed, 08 May 2019 06:41:34 -0700 (PDT)
Received: from localhost (modemcable249.105-163-184.mc.videotron.ca. [184.163.105.249])
        by smtp.gmail.com with ESMTPSA id b187sm10535817qkd.73.2019.05.08.06.41.33
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 08 May 2019 06:41:33 -0700 (PDT)
Date:   Wed, 8 May 2019 09:41:32 -0400
Message-ID: <20190508094132.GB13389@t480s.localdomain>
From:   Vivien Didelot <vivien.didelot@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Rasmus Villemoes <rasmus.villemoes@prevas.dk>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>
Subject: Re: [RFC PATCH 1/5] net: dsa: mv88e6xxx: introduce support for two
 chips using direct smi addressing
In-Reply-To: <20190508114715.GB30557@lunn.ch>
References: <20190501193126.19196-1-rasmus.villemoes@prevas.dk>
 <20190501193126.19196-2-rasmus.villemoes@prevas.dk>
 <20190501201919.GC19809@lunn.ch>
 <f5924091-352c-c14a-f959-6bb8a32746e3@prevas.dk>
 <20190508114715.GB30557@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Rasmus,

On Wed, 8 May 2019 13:47:15 +0200, Andrew Lunn <andrew@lunn.ch> wrote:
> > > 
> > > This works, but i think i prefer adding mv88e6xxx_smi_dual_chip_write,
> > > mv88e6xxx_smi_dual_chip_read, and create a
> > > mv88e6xxx_smi_single_chip_ops.
> > 
> > Now that Vivien's "net: dsa: mv88e6xxx: refine SMI support" is in
> > master, do you still prefer introducing a third bus_ops structure
> > (mv88e6xxx_smi_dual_direct_ops ?), or would the approach of adding
> > chip->sw_addr in the smi_direct_{read/write} functions be ok (which
> > would then require changing the indirect callers to pass 0 instead of
> > chip->swaddr).
> 
> I would still prefer a new bus_ops.

Even though those are direct read and write operations, having 3
mv88e6xxx_bus_ops structures will make it clear that there are 3 ways
for accessible the internal switch registers through SMI, depending
on the Marvell chip model.  So I would prefer a third ops as well.

Thanks,
Vivien
