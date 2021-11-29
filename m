Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5F4A146286C
	for <lists+netdev@lfdr.de>; Tue, 30 Nov 2021 00:38:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232149AbhK2Xls (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Nov 2021 18:41:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49414 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230045AbhK2Xls (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Nov 2021 18:41:48 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD792C061574;
        Mon, 29 Nov 2021 15:38:29 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 0366CCE16B9;
        Mon, 29 Nov 2021 23:38:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E15BBC53FC7;
        Mon, 29 Nov 2021 23:38:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1638229106;
        bh=Yf/yrcqa84AktFsnnvwR+QA+g8bUz4NRzA50pnGN5oM=;
        h=Date:From:To:Cc:Subject:In-Reply-To:From;
        b=VBSzNbkS98dymG6V9Ul4cBFRGhr2K/BzHf4KscC0pqjIe894xR6UslfcnJ6kHILGk
         aisz8MdpPHdQSB0aMlYwJ5feMvXg/+SM10YmHrR+hXo1xIT5+WDl8QnrSZxYnHy+vi
         GoO6FAhJcDVAT9BwuJhSTDKcLXUmx6Ok633l3MSpLarlIN3J1cRK1ox4mlZvoI6YeQ
         f5lbq47Tpdrn75LQhBVb/16OPS+dOcTnQ9P/ekRbQVAL3+TydnWj5S0omNA/MA/YZX
         8brn/A70dk/7ad4ZbEvHJljIfo85g0+TzK7I+GVmocL1+IQEcnaMrLUGkaEryuWj+l
         KGwR8d7Qr+RLw==
Date:   Mon, 29 Nov 2021 17:38:24 -0600
From:   Bjorn Helgaas <helgaas@kernel.org>
To:     Jonas =?iso-8859-1?Q?Dre=DFler?= <verdre@v0yd.nl>
Cc:     Amitkumar Karwar <amitkarwar@gmail.com>,
        Ganapathi Bhat <ganapathi017@gmail.com>,
        Xinming Hu <huxinming820@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Tsuchiya Yuto <kitakar@gmail.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Maximilian Luz <luzmaximilian@gmail.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Pali =?iso-8859-1?Q?Roh=E1r?= <pali@kernel.org>
Subject: Re: [PATCH] mwifiex: Ignore BTCOEX events from the 88W8897 firmware
Message-ID: <20211129233824.GA2703817@bhelgaas>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20211129233209.GA2702252@bhelgaas>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 29, 2021 at 05:32:11PM -0600, Bjorn Helgaas wrote:
> On Wed, Nov 03, 2021 at 09:58:27PM +0100, Jonas Dreßler wrote:
> > The firmware of the 88W8897 PCIe+USB card sends those events very
> > unreliably, sometimes bluetooth together with 2.4ghz-wifi is used and no
> > COEX event comes in, and sometimes bluetooth is disabled but the
> > coexistance mode doesn't get disabled.
> 
> s/sends those events/sends BTCOEX events/ so it reads well without the
> subject.
> 
> s/coexistance/coexistence/
> 
> Is BTCOEX a standard Bluetooth thing?  Is there a spec reference that
> could be useful here?  I've never seen those specs, so this is just
> curiosity.  I did download the "Bluetooth Core Spec v5.3", which does
> have a "Wireless Coexistence Signaling and Interfaces" chapter, but
> "BTCOEX" doesn't appear in that doc.
> 
> > This means we sometimes end up capping the rx/tx window size while
> > bluetooth is not enabled anymore, artifically limiting wifi speeds even
> > though bluetooth is not being used.
> 
> s/artifically/artificially/
> 
> > Since we can't fix the firmware, let's just ignore those events on the
> > 88W8897 device. From some Wireshark capture sessions it seems that the
> > Windows driver also doesn't change the rx/tx window sizes when bluetooth
> > gets enabled or disabled, so this is fairly consistent with the Windows
> > driver.

I hadn't read far enough to see that the patch was already applied,
sorry for the noise :)
