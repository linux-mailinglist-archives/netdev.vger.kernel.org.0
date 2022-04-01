Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C57734EE7A2
	for <lists+netdev@lfdr.de>; Fri,  1 Apr 2022 07:10:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245024AbiDAFMg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Apr 2022 01:12:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57710 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245001AbiDAFMd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Apr 2022 01:12:33 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1859D1E8CC9;
        Thu, 31 Mar 2022 22:10:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Transfer-Encoding
        :Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:
        Sender:Reply-To:Content-ID:Content-Description;
        bh=V32+zQcO407Oigns62fencqAWiQUbjG3dkYmA/bzFgs=; b=ZfJXByG0vD8l+JFtQ4yjotGAuY
        xAgedtPzZTd8OUi1dzB10Si101BKwG0IYWbUCcMjsIiNuwNVenxVCR/KUkSyd/oDjtfDtwUtY+Mn9
        tnE9E6ckU/QHuJU1mNFHjKGmNRoYXc7KQCx4T17fUppasjeBeiMsnvEfkkgFKrt2669XSgfwMt26e
        EII86iOdGu6w/fzgHJVnCqnoDNPCV3PpARH3CmgKBBJACtqcFtJloyHytdjvZpcXSGPAB9I2RnLLa
        pVcCVcwCoVfPWnVPAvAUEZBYbQyavK/AJMzt4IuTrmRktkBZkumKIQqDVXR1iP+MBwNx5+iddah/E
        9mEWW45w==;
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1na9YU-004W8V-1i; Fri, 01 Apr 2022 05:10:38 +0000
Date:   Thu, 31 Mar 2022 22:10:38 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Andy Shevchenko <andy.shevchenko@gmail.com>
Cc:     Benjamin =?iso-8859-1?Q?St=FCrz?= <benni@stuerz.xyz>,
        Andrew Lunn <andrew@lunn.ch>,
        linux-atm-general@lists.sourceforge.net,
        linux-ia64@vger.kernel.org,
        Linus Walleij <linus.walleij@linaro.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        linux-pci@vger.kernel.org, Robert Moore <robert.moore@intel.com>,
        Harald Welte <laforge@gnumonks.org>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        "H. Peter Anvin" <hpa@zytor.com>, wcn36xx@lists.infradead.org,
        Ping-Ke Shih <pkshih@realtek.com>,
        Linux Samsung SOC <linux-samsung-soc@vger.kernel.org>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        linux-edac@vger.kernel.org,
        dennis.dalessandro@cornelisnetworks.com,
        "open list:HFI1 DRIVER" <linux-rdma@vger.kernel.org>,
        Gregory Clement <gregory.clement@bootlin.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Russell King - ARM Linux <linux@armlinux.org.uk>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Jason Gunthorpe <jgg@ziepe.ca>, Ingo Molnar <mingo@redhat.com>,
        3chas3@gmail.com, linux-input <linux-input@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Len Brown <lenb@kernel.org>,
        mike.marciniszyn@cornelisnetworks.com,
        Robert Richter <rric@kernel.org>,
        Andrew Donnellan <ajd@linux.ibm.com>,
        Arnd Bergmann <arnd@arndb.de>, Kalle Valo <kvalo@kernel.org>,
        "open list:LINUX FOR POWERPC PA SEMI PWRFICIENT" 
        <linuxppc-dev@lists.ozlabs.org>,
        "open list:GPIO SUBSYSTEM" <linux-gpio@vger.kernel.org>,
        Loic Poulain <loic.poulain@linaro.org>,
        Borislav Petkov <bp@alien8.de>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-media@vger.kernel.org, linux@simtec.co.uk,
        linux-arm Mailing List <linux-arm-kernel@lists.infradead.org>,
        "open list:ACPI COMPONENT ARCHITECTURE (ACPICA)" <devel@acpica.org>,
        Karsten Keil <isdn@linux-pingi.de>,
        Tony Luck <tony.luck@intel.com>,
        Nicolas Pitre <nico@fluxnic.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        linux-wireless@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        James Morse <james.morse@arm.com>,
        netdev <netdev@vger.kernel.org>,
        Frederic Barrat <fbarrat@linux.ibm.com>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Pali =?iso-8859-1?Q?Roh=E1r?= <pali@kernel.org>,
        Bartosz Golaszewski <brgl@bgdev.pl>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 05/22] acpica: Replace comments with C99 initializers
Message-ID: <YkaJTh+Bhf+oPQB7@infradead.org>
References: <20220326165909.506926-1-benni@stuerz.xyz>
 <20220326165909.506926-5-benni@stuerz.xyz>
 <CAHp75VeTXMAueQc_c0Ryj5+a8PrJ7gk-arugiNnxtAm03x7XTg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAHp75VeTXMAueQc_c0Ryj5+a8PrJ7gk-arugiNnxtAm03x7XTg@mail.gmail.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Mar 27, 2022 at 10:59:54PM +0300, Andy Shevchenko wrote:
> On Sat, Mar 26, 2022 at 7:39 PM Benjamin Stürz <benni@stuerz.xyz> wrote:
> >
> > This replaces comments with C99's designated
> > initializers because the kernel supports them now.
> 
> Does it follow the conventions which are accepted in the ACPI CA project?

Why would ACPI CA be allowed to make up it's own conventions?  And as
you might imply not allow using a very useful and more than 20 year old
C feature?  This kind of BS need to stop.
