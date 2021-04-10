Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 391D535AEF3
	for <lists+netdev@lfdr.de>; Sat, 10 Apr 2021 17:55:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234761AbhDJPzl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 10 Apr 2021 11:55:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46828 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234334AbhDJPzk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 10 Apr 2021 11:55:40 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0368DC06138A;
        Sat, 10 Apr 2021 08:55:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=CzOBLJLIpMaSm2apRythmsTcqiiwrKSDjrbInU9e0SA=; b=c5UKjvS8rNqagvElEmnq5mWQ2
        sOG6gW99tI6xwZXqcrM0Omsn7OTm2fu3665e5SLzAUZcWgmuvpx4LsuO8/sfRyv5AHrB1VxlWAb+2
        zb8sbnGIvkTUbOVv1OeaDlPYJRbaBVxn9aQ7OEXrvQXVMJ89mFmJItp1FPI6+1z4kCSLRgjYKV6Eq
        1ehY/+L/+7Sd24BuLZQuq1uqmViCX215IU2khq8hUKbTdXz6jbowwCm1+k1w9WhYpo20Mm1p3GXMQ
        lWvTKWoggbyjkpAqlg4ihTHh2CWrkU497gIFI6Q5aTR6qrgU8es4zjrms5ywWgA05k/kw4Fv0Ni50
        rysPj65UQ==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:52272)
        by pandora.armlinux.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <linux@armlinux.org.uk>)
        id 1lVFwk-0003Cf-AS; Sat, 10 Apr 2021 16:54:54 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1lVFwf-0005Xb-GK; Sat, 10 Apr 2021 16:54:49 +0100
Date:   Sat, 10 Apr 2021 16:54:49 +0100
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Matthew Wilcox <willy@infradead.org>
Cc:     Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        kernel test robot <lkp@intel.com>,
        Linux-MM <linux-mm@kvack.org>, kbuild-all@lists.01.org,
        clang-built-linux@googlegroups.com,
        open list <linux-kernel@vger.kernel.org>,
        linux-fsdevel@vger.kernel.org,
        Michael Ellerman <mpe@ellerman.id.au>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        linuxppc-dev@lists.ozlabs.org,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        "David S. Miller" <davem@davemloft.net>,
        Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>,
        Matteo Croce <mcroce@linux.microsoft.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Grygorii Strashko <grygorii.strashko@ti.com>
Subject: Re: Bogus struct page layout on 32-bit
Message-ID: <20210410155449.GI1463@shell.armlinux.org.uk>
References: <20210409185105.188284-3-willy@infradead.org>
 <202104100656.N7EVvkNZ-lkp@intel.com>
 <20210410024313.GX2531743@casper.infradead.org>
 <20210410082158.79ad09a6@carbon>
 <CAC_iWjLXZ6-hhvmvee6r4R_N64u-hrnLqE_CSS1nQk+YaMQQnA@mail.gmail.com>
 <20210410140652.GY2531743@casper.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210410140652.GY2531743@casper.infradead.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: Russell King - ARM Linux admin <linux@armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Apr 10, 2021 at 03:06:52PM +0100, Matthew Wilcox wrote:
> How about moving the flags into the union?  A bit messy, but we don't
> have to play games with __packed__.

Yes, that is probably the better solution, avoiding the games to try
and get the union appropriately placed on 32-bit systems.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
