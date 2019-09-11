Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9EED2AFD62
	for <lists+netdev@lfdr.de>; Wed, 11 Sep 2019 15:06:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727879AbfIKNGK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Sep 2019 09:06:10 -0400
Received: from s3.sipsolutions.net ([144.76.43.62]:39898 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727837AbfIKNGJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Sep 2019 09:06:09 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <johannes@sipsolutions.net>)
        id 1i82Jw-0007pA-9M; Wed, 11 Sep 2019 15:06:04 +0200
Message-ID: <d0de07f0918863c8bc9bebccd8c6a7402a2ad173.camel@sipsolutions.net>
Subject: Re: [PATCH] mac80211: Do not send Layer 2 Update frame before
 authorization
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Jouni Malinen <jouni@codeaurora.org>
Cc:     linux-wireless@vger.kernel.org, David Miller <davem@davemloft.net>,
        netdev@vger.kernel.org
Date:   Wed, 11 Sep 2019 15:06:03 +0200
In-Reply-To: <20190911130305.23704-1-jouni@codeaurora.org>
References: <20190911130305.23704-1-jouni@codeaurora.org>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.30.5 (3.30.5-1.fc29) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 2019-09-11 at 16:03 +0300, Jouni Malinen wrote:
> The Layer 2 Update frame is used to update bridges when a station roams
> to another AP even if that STA does not transmit any frames after the
> reassociation. This behavior was described in IEEE Std 802.11F-2003 as
> something that would happen based on MLME-ASSOCIATE.indication, i.e.,
> before completing 4-way handshake. However, this IEEE trial-use
> recommended practice document was published before RSN (IEEE Std
> 802.11i-2004) and as such, did not consider RSN use cases. Furthermore,
> IEEE Std 802.11F-2003 was withdrawn in 2006 and as such, has not been
> maintained amd should not be used anymore.
> 
> Sending out the Layer 2 Update frame immediately after association is
> fine for open networks (and also when using SAE, FT protocol, or FILS
> authentication when the station is actually authenticated by the time
> association completes). However, it is not appropriate for cases where
> RSN is used with PSK or EAP authentication since the station is actually
> fully authenticated only once the 4-way handshake completes after
> authentication and attackers might be able to use the unauthenticated
> triggering of Layer 2 Update frame transmission to disrupt bridge
> behavior.
> 
> Fix this by postponing transmission of the Layer 2 Update frame from
> station entry addition to the point when the station entry is marked
> authorized. Similarly, send out the VLAN binding update only if the STA
> entry has already been authorized.

Reviewed-by: Johannes Berg <johannes@sipsolutions.net>

Dave, if you were still planning to send a pull request to Linus before
he closes the tree on Sunday this would be good to include (and we
should also backport it to stable later).

If not, I can pick it up afterwards, let me know.

Thanks,
johannes


