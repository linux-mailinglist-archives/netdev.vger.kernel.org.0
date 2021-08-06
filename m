Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0B6153E20FD
	for <lists+netdev@lfdr.de>; Fri,  6 Aug 2021 03:27:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241540AbhHFB13 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Aug 2021 21:27:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:59876 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234559AbhHFB12 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 5 Aug 2021 21:27:28 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B02B4611C7;
        Fri,  6 Aug 2021 01:27:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1628213234;
        bh=SoicOYPCF17y/01EXt18RtCrEYdiMeZr7K7nnYXbAwY=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Ghbqp84sspt79xYpYgeUEiEWKaq1AXNxLAs/ajW4WdGAhoa6noeUSdOGYOrkNAapX
         G1xpQgmx2K9xEmjuCkTLrEbRf1gzpbUVbges5cO+lraUmxiqiEz/Mubt7yo6HuhcvJ
         /RO+e+ktv0k+N0+SUdi0i2A6cK+NQwEABip+syvgixVYE2iBEx5SZab6LHPI39oS3G
         dxTw0SBbJpbybRuYQQbzPR/BXogtQmohbhqVBIs4cKYIfKZOvHD+YSas1g/Mp5VHvZ
         tj2mvgDSADpHQjok9p/DYm7pjCIuG3+nfhy2uopYoJRyGKu8pT2oocdVk5aW2IsSNF
         CcVOQ9aALFjuQ==
Date:   Thu, 5 Aug 2021 18:27:12 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Alex Elder <elder@linaro.org>
Cc:     davem@davemloft.net, bjorn.andersson@linaro.org,
        evgreen@chromium.org, cpratapa@codeaurora.org,
        subashab@codeaurora.org, elder@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next 2/6] net: ipa: reorder netdev pointer
 assignments
Message-ID: <20210805182712.4f071aa8@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210804153626.1549001-3-elder@linaro.org>
References: <20210804153626.1549001-1-elder@linaro.org>
        <20210804153626.1549001-3-elder@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed,  4 Aug 2021 10:36:22 -0500 Alex Elder wrote:
> Assign the ipa->modem_netdev and endpoint->netdev pointers *before*
> registering the network device.  As soon as the device is
> registered it can be opened, and by that time we'll want those
> pointers valid.
> 
> Similarly, don't make those pointers NULL until *after* the modem
> network device is unregistered in ipa_modem_stop().
> 
> Signed-off-by: Alex Elder <elder@linaro.org>

This one seems like a pretty legit race, net would be better if you
don't mind.
