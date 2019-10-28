Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 50A57E7114
	for <lists+netdev@lfdr.de>; Mon, 28 Oct 2019 13:13:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728323AbfJ1MNC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Oct 2019 08:13:02 -0400
Received: from s3.sipsolutions.net ([144.76.43.62]:40510 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727085AbfJ1MNC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Oct 2019 08:13:02 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.92.2)
        (envelope-from <johannes@sipsolutions.net>)
        id 1iP3tC-0003GO-4w; Mon, 28 Oct 2019 13:12:50 +0100
Message-ID: <d0fc94581e0dce37d993c55edaae8fc40eaa7601.camel@sipsolutions.net>
Subject: Re: [PATCH] cfg80211: Fix memory leak in
 cfg80211_inform_single_bss_frame_data
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Navid Emamdoost <navid.emamdoost@gmail.com>
Cc:     emamd001@umn.edu, smccaman@umn.edu, kjlu@umn.edu,
        "David S. Miller" <davem@davemloft.net>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date:   Mon, 28 Oct 2019 13:12:47 +0100
In-Reply-To: <20191027181600.11149-1-navid.emamdoost@gmail.com> (sfid-20191027_191610_218836_6E8601E7)
References: <20191027181600.11149-1-navid.emamdoost@gmail.com>
         (sfid-20191027_191610_218836_6E8601E7)
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.30.5 (3.30.5-1.fc29) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 2019-10-27 at 13:15 -0500, Navid Emamdoost wrote:
> In the implementation of cfg80211_inform_single_bss_frame_data() the
> allocated memory for ies is leaked in case of an error. Release ies if
> cfg80211_bss_update() fails.

I'm pretty sure it's more complicated than this patch (and the previous
one) - we already do free this at least in the case that "new =
kzalloc(...)" fails in cfg80211_bss_update().

Your Fixes: tag is also wrong, back then we didn't even have the dynamic
allocation of the IEs.

I'm dropping this patch and the other and will make a note to eventually
look at the lifetime issue here you point out, but if you want to work
on it instead let me know.

johannes

