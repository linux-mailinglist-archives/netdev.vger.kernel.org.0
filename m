Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CC82E48CB2A
	for <lists+netdev@lfdr.de>; Wed, 12 Jan 2022 19:43:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356397AbiALSnc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Jan 2022 13:43:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50186 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356406AbiALSna (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Jan 2022 13:43:30 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D8775C06173F
        for <netdev@vger.kernel.org>; Wed, 12 Jan 2022 10:43:28 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id AD564B82049
        for <netdev@vger.kernel.org>; Wed, 12 Jan 2022 18:43:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 26A33C36AE5;
        Wed, 12 Jan 2022 18:43:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642013006;
        bh=fVJPw9zf5JkCC+4ObgfMoYhhTbpfgBxVtdiTAlE+xsY=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=DinvpNrYUnCd2Gq1hwsGDihgRNW4ZmqEFXX2dxJV853G13zS6qDAyHqSJrXOc/J1r
         HnncgcUo4tdWyo6h8aFxsSDrocrNfKeNbIXl0Bln4RB9y7vYLabXZmaMHqwXsqkq07
         AbIKDzd0EFMp3ZPigbT0lZOySzm4vc/I/XTDO8by6oGC10IT8EDO7Cdw+DnObupasK
         xVyXSSsDzyBFGm5gycxb/cg+i99UFuEpv8/HbP2SRcUHcevEny3rJdcm9/eDYaULnG
         O3SpPvZZUYWugJ7c9NtcJKYCj7e704Y9Drec01lj3WITXo3G9FkOrvo39UqWaxKr47
         wF53KIQVv2AUw==
Date:   Wed, 12 Jan 2022 10:43:24 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     ooppublic@163.com
Cc:     davem@davemloft.net, dsahern@kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH] net: fix fragments have the disallowed options
Message-ID: <20220112104324.61b15b51@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <20220107080559.122713-1-ooppublic@163.com>
References: <20220107080559.122713-1-ooppublic@163.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri,  7 Jan 2022 16:05:59 +0800 ooppublic@163.com wrote:
> From: caixf <ooppublic@163.com>
> 
> When in function ip_do_fragment() enter fsat path,

fsat -> fast

> if skb have opthons, all fragments will have the same options.

opthons -> options

> Just guarantee the second fragment not have the disallowed options.

You're right. Can you send a patch which explicitly reverts these
two commits instead:

 1b9fbe813016b08e08b22ddba4ddbf9cb1b04b00
 faf482ca196a5b16007190529b3b2dd32ab3f761

I prefer the code the way it was before them, plus keeping the code how
it was could help backports.

Thanks!
