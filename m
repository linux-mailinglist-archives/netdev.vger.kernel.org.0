Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BADDB6BA748
	for <lists+netdev@lfdr.de>; Wed, 15 Mar 2023 06:41:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231660AbjCOFl4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Mar 2023 01:41:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37176 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231563AbjCOFlv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Mar 2023 01:41:51 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5954952F77;
        Tue, 14 Mar 2023 22:41:34 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 005E3B81C83;
        Wed, 15 Mar 2023 05:41:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 172A4C433D2;
        Wed, 15 Mar 2023 05:41:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678858891;
        bh=YQU1vxB731M/K89LX9wg1MsTuG8C7dV+uuzMj2SjHcM=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=VWHav8H42tVaou8tbrwTl+pZI8gUqH+Zz49ISWuHEuWOBqrxzQAx1YCVwtOZlEYlR
         uMZgOEpILbSo17DmejGWiPwXUpij4+Xz2/2uJFa1aHs8xCHYmzG9BWitK1v49wuZlt
         6OJcAYh0pykfoLHDXBjLUkf3sGDa8nvJP59ScTDEolZv/rT1doJRJKuxYh+YpBsNiX
         qQ0BcCuongibuseYuN/s4HPztCHQ2a+r9G+zqv5puOoKNO70Z+MvSlIfuzdppy1NZW
         mEFBcQYGy1Uq4kJ4SBNpgsS/1LtQxOL0KT4Hh2A00gI0ObrQBo/ZWdhclbPHfSo18t
         Iewf7/8cZVplg==
Date:   Tue, 14 Mar 2023 22:41:30 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Niklas Schnelle <schnelle@linux.ibm.com>
Cc:     Arnd Bergmann <arnd@arndb.de>, Karsten Keil <isdn@linux-pingi.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Uwe =?UTF-8?B?S2xlaW5lLUvDtm5pZw==?= 
        <u.kleine-koenig@pengutronix.de>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Alan Stern <stern@rowland.harvard.edu>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        linux-pci@vger.kernel.org, Arnd Bergmann <arnd@kernel.org>,
        netdev@vger.kernel.org
Subject: Re: [PATCH v3 18/38] mISDN: add HAS_IOPORT dependencies
Message-ID: <20230314224130.4b976e16@kernel.org>
In-Reply-To: <20230314121216.413434-19-schnelle@linux.ibm.com>
References: <20230314121216.413434-1-schnelle@linux.ibm.com>
        <20230314121216.413434-19-schnelle@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 14 Mar 2023 13:11:56 +0100 Niklas Schnelle wrote:
> In a future patch HAS_IOPORT=n will result in inb()/outb() and friends
> not being declared. We thus need to add HAS_IOPORT as dependency for
> those drivers using them. With that the !S390 dependency on ISDN can be
> removed as all drivers without HAS_IOPORT requirement now build.
> 
> Co-developed-by: Arnd Bergmann <arnd@kernel.org>
> Signed-off-by: Niklas Schnelle <schnelle@linux.ibm.com>

I'm guessing this is going via some global route so:

Acked-by: Jakub Kicinski <kuba@kernel.org>
