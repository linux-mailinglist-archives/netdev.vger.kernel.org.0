Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7234A3EED89
	for <lists+netdev@lfdr.de>; Tue, 17 Aug 2021 15:35:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239864AbhHQNfw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Aug 2021 09:35:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:58150 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236040AbhHQNfv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 17 Aug 2021 09:35:51 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6B84160F39;
        Tue, 17 Aug 2021 13:35:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629207318;
        bh=PL8wg2Ew7oUxIiiCEp4n17LEc+uWtAwbcF5lGkxuj4I=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=XAeWMnb56Mr/DugarnXgc2odc5CrGJWQsTZ0O4WQLYtegFgghazd9cntag2NgMR3b
         /o9+hfxJZx4Ahb/afV+htcCVKFeYDHVdOM0GNgr2TduxYEgnV9+3ioPk8n019lSwUd
         OucE4kpqlpcReKqJ7w74OpLH2eY6zdIzDVQIHeT2o+ME1FhVBpJVIZRPWi6P3OnMXM
         VqZ7Q/0G/ldfUfkVMlU/7wuIaHk5p4/PY5c8ZV5si5hGgyposv/z3tAoKdkRp7XKDq
         mHBN5V/9PTHs/1k2zEw0xwFDeQrp1xaOKEW8zDuyGQv62kr5TFgaaRZ31PivC4GdH/
         da+0Z059eZdfw==
Date:   Tue, 17 Aug 2021 06:35:17 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Luke Hsiao <luke.w.hsiao@gmail.com>
Cc:     David Miller <davem@davemloft.net>, netdev@vger.kernel.org,
        Luke Hsiao <lukehsiao@google.com>,
        Neal Cardwell <ncardwell@google.com>,
        Yuchung Cheng <ycheng@google.com>,
        Eric Dumazet <edumazet@google.com>
Subject: Re: [PATCH net-next] tcp: enable data-less, empty-cookie SYN with
 TFO_SERVER_COOKIE_NOT_REQD
Message-ID: <20210817063517.410b1233@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210816205105.2533289-1-luke.w.hsiao@gmail.com>
References: <20210816205105.2533289-1-luke.w.hsiao@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 16 Aug 2021 20:51:06 +0000 Luke Hsiao wrote:
> From: Luke Hsiao <lukehsiao@google.com>
> 
> Since the original TFO server code was implemented in commit
> 168a8f58059a22feb9e9a2dcc1b8053dbbbc12ef ("tcp: TCP Fast Open Server -
> main code path") the TFO server code has supported the sysctl bit flag
> TFO_SERVER_COOKIE_NOT_REQD. Currently, when the TFO_SERVER_ENABLE and
> TFO_SERVER_COOKIE_NOT_REQD sysctl bit flags are set, a server connection
> will accept a SYN with N bytes of data (N > 0) that has no TFO cookie,
> create a new fast open connection, process the incoming data in the SYN,
> and make the connection ready for accepting. After accepting, the
> connection is ready for read()/recvmsg() to read the N bytes of data in
> the SYN, ready for write()/sendmsg() calls and data transmissions to
> transmit data.
> 
> This commit changes an edge case in this feature by changing this
> behavior to apply to (N >= 0) bytes of data in the SYN rather than only
> (N > 0) bytes of data in the SYN. Now, a server will accept a data-less
> SYN without a TFO cookie if TFO_SERVER_COOKIE_NOT_REQD is set.
> 
> Caveat! While this enables a new kind of TFO (data-less empty-cookie
> SYN), some firewall rules setup may not work if they assume such packets
> are not legit TFOs and will filter them.
> 
> Signed-off-by: Luke Hsiao <lukehsiao@google.com>
> Acked-by: Neal Cardwell <ncardwell@google.com>
> Acked-by: Yuchung Cheng <ycheng@google.com>
> Signed-off-by: Eric Dumazet <edumazet@google.com>

Applied, thanks!
