Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 278293DE8E9
	for <lists+netdev@lfdr.de>; Tue,  3 Aug 2021 10:51:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234582AbhHCIvK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Aug 2021 04:51:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58982 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234748AbhHCIu6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Aug 2021 04:50:58 -0400
Received: from ssl.serverraum.org (ssl.serverraum.org [IPv6:2a01:4f8:151:8464::1:2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 68126C0613D5
        for <netdev@vger.kernel.org>; Tue,  3 Aug 2021 01:50:46 -0700 (PDT)
Received: from mwalle01.kontron.local (unknown [213.135.10.150])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by ssl.serverraum.org (Postfix) with ESMTPSA id 8B45122205;
        Tue,  3 Aug 2021 10:50:43 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=walle.cc; s=mail2016061301;
        t=1627980643;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=q74rsaNbJ7gTkv/bhUBPZW6ZZ4oW4fkO5Cdctlmceis=;
        b=ptNqapoC/xTYHLblRFwCJ8DO+HrSe4NgrKrGHCI7VE4ryGDTDJfbXEGp87bgFWcP0P/vEE
        KXQ8P2TOM4aff4NU1nJS+gJFSBtLvy5+rjA3SJZiZ83GhewdVFybndOcfiV+eGtLT2wPLJ
        mhR6M4cuPXv42vcUGOroqA/01jziNEw=
From:   Michael Walle <michael@walle.cc>
To:     lescoutinhovr@gmail.com
Cc:     netdev@vger.kernel.org, Michael Walle <michael@walle.cc>
Subject: Re: net: intel/e1000e/netdev.c __ew32_prepare parameter not used?
Date:   Tue,  3 Aug 2021 10:50:32 +0200
Message-Id: <20210803085032.8834-1-michael@walle.cc>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <CAN6UTaw7Rtoz4q-AsDjKbTm7_sU8BrTAmuMp8-wr6FzaxDMe2Q@mail.gmail.com>
References: <CAN6UTaw7Rtoz4q-AsDjKbTm7_sU8BrTAmuMp8-wr6FzaxDMe2Q@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

> It seems the parameter `*hw` is not used.
> Although I didn't find where `FWSM` is defined.
> 
> Should it be removed? Or is the parameter really needed?
> 
> static void __ew32_prepare(struct e1000_hw *hw)
> {
>     s32 i = E1000_ICH_FWSM_PCIM2PCI_COUNT;
> 
>     while ((er32(FWSM) & E1000_ICH_FWSM_PCIM2PCI) && --i)
>         udelay(50);
> }

If you have a look at the definition of er32() (which is a macro and
is defined in e1000.h, you'll see that the hw parameter is used
there without being a parameter of the macro itself. Thus if you'd
rename the parameter you'd get a build error. Not really the best
code to look at when you want to learn coding, because that's an
example how not to do things, IMHO.

-michael
