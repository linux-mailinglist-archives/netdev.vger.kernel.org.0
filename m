Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5DB1323325A
	for <lists+netdev@lfdr.de>; Thu, 30 Jul 2020 14:40:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728062AbgG3Mkm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Jul 2020 08:40:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38402 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726581AbgG3Mkl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Jul 2020 08:40:41 -0400
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BBAB1C061794;
        Thu, 30 Jul 2020 05:40:41 -0700 (PDT)
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.93)
        (envelope-from <johannes@sipsolutions.net>)
        id 1k17rD-00DWUr-5e; Thu, 30 Jul 2020 14:40:23 +0200
Message-ID: <446c9e45b5e904fa747c3d727a2c39ee904789e0.camel@sipsolutions.net>
Subject: Re: [RFC 1/7] mac80211: Add check for napi handle before WARN_ON
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Rakesh Pillai <pillair@codeaurora.org>, ath10k@lists.infradead.org
Cc:     linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvalo@codeaurora.org, davem@davemloft.net, kuba@kernel.org,
        netdev@vger.kernel.org, dianders@chromium.org, evgreen@chromium.org
Date:   Thu, 30 Jul 2020 14:40:21 +0200
In-Reply-To: <000e01d66368$9a6ece70$cf4c6b50$@codeaurora.org>
References: <1595351666-28193-1-git-send-email-pillair@codeaurora.org>
                         <1595351666-28193-2-git-send-email-pillair@codeaurora.org>
                 <0dbdef912f9d61521011f638200fd451a3530568.camel@sipsolutions.net>
                 <003201d6611e$c54a1c90$4fde55b0$@codeaurora.org>
         <ce380ea1fd1f5db40a92f67673f070a1f88eee50.camel@sipsolutions.net>
          <000e01d66368$9a6ece70$cf4c6b50$@codeaurora.org>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.4 (3.36.4-1.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 2020-07-26 at 21:49 +0530, Rakesh Pillai wrote:

> We do have the usage of napi_gro_receive and netif_receive_skb in mac80211.
>                 /* deliver to local stack */
>                 if (rx->napi)
>                         napi_gro_receive(rx->napi, skb);
>                 else
>                         netif_receive_skb(skb);
> 
> 
> Also all the rx_handlers are called under the " rx->local->rx_path_lock" lock.
> Is the BH disable still required ?

I tend to think so, but you're welcome to show that it's not. The lock
serves a different purpose.

TBH, I don't have all of this in my head at all times either, so please
do your own work and analyse why it may or may not be necessary. But
without any such analysis I'm not going to take patches that change it.

johannes

