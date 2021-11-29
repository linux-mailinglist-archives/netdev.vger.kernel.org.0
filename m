Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A06D3462849
	for <lists+netdev@lfdr.de>; Tue, 30 Nov 2021 00:32:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231598AbhK2Xfd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Nov 2021 18:35:33 -0500
Received: from sin.source.kernel.org ([145.40.73.55]:50942 "EHLO
        sin.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229558AbhK2Xfd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Nov 2021 18:35:33 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 45ED9CE16E0;
        Mon, 29 Nov 2021 23:32:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1967C53FAD;
        Mon, 29 Nov 2021 23:32:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1638228731;
        bh=1xAwK1UN6GbP/Kw9DH9ptJJxLz3pyvzNO1N/vlPbgNw=;
        h=Date:From:To:Cc:Subject:In-Reply-To:From;
        b=e24mjV1WWFPS2BQvo73pIos7h237Jil8qHNdfezKaLEKWXhz/+5dVwQFtB5AxRISR
         IGoCg6e627EXd4xbcmhxG/ccDpOrZTftT0QR6W76sPOhvhSrXZ2B0wBzeVuK9nafqI
         /f5qTPJITyX7d/FWga48QhCFw11tBiW+uLPNQRV0fFTVsyaFEKIWfnkjyLQQKDkHhS
         /jVoZdBrQMMtTBwfSAToBBVa2zZtOiA+G0HdGNFHv1zt+1NMkh0jo16Vm4xWnu6Tsw
         M1ju3aZH8ekYeJnqH4ZXiHGE7zcEBxlGSQpP3H+iNDgExvLJ/umvbjH6YOb4CG/vMD
         e/iWqbYaDRyqw==
Date:   Mon, 29 Nov 2021 17:32:09 -0600
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
Message-ID: <20211129233209.GA2702252@bhelgaas>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20211103205827.14559-1-verdre@v0yd.nl>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 03, 2021 at 09:58:27PM +0100, Jonas Dreßler wrote:
> The firmware of the 88W8897 PCIe+USB card sends those events very
> unreliably, sometimes bluetooth together with 2.4ghz-wifi is used and no
> COEX event comes in, and sometimes bluetooth is disabled but the
> coexistance mode doesn't get disabled.

s/sends those events/sends BTCOEX events/ so it reads well without the
subject.

s/coexistance/coexistence/

Is BTCOEX a standard Bluetooth thing?  Is there a spec reference that
could be useful here?  I've never seen those specs, so this is just
curiosity.  I did download the "Bluetooth Core Spec v5.3", which does
have a "Wireless Coexistence Signaling and Interfaces" chapter, but
"BTCOEX" doesn't appear in that doc.

> This means we sometimes end up capping the rx/tx window size while
> bluetooth is not enabled anymore, artifically limiting wifi speeds even
> though bluetooth is not being used.

s/artifically/artificially/

> Since we can't fix the firmware, let's just ignore those events on the
> 88W8897 device. From some Wireshark capture sessions it seems that the
> Windows driver also doesn't change the rx/tx window sizes when bluetooth
> gets enabled or disabled, so this is fairly consistent with the Windows
> driver.
