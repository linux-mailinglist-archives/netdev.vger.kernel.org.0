Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 310C33AC7C1
	for <lists+netdev@lfdr.de>; Fri, 18 Jun 2021 11:36:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231923AbhFRJio (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Jun 2021 05:38:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35724 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229782AbhFRJin (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Jun 2021 05:38:43 -0400
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0420BC061574;
        Fri, 18 Jun 2021 02:36:33 -0700 (PDT)
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.94.2)
        (envelope-from <johannes@sipsolutions.net>)
        id 1luAvC-008RHA-0v; Fri, 18 Jun 2021 11:36:18 +0200
Message-ID: <a3589e399e179b389e90df36acb67ae1ec7dea97.camel@sipsolutions.net>
Subject: Re: [PATCH] mac80211_hwsim: correctly handle zero length frames
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Anirudh Rayabharam <mail@anirudhrb.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     gregkh@linuxfoundation.org,
        linux-kernel-mentees@lists.linuxfoundation.org,
        syzbot+b2645b5bf1512b81fa22@syzkaller.appspotmail.com,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date:   Fri, 18 Jun 2021 11:36:16 +0200
In-Reply-To: <20210610161916.9307-1-mail@anirudhrb.com>
References: <20210610161916.9307-1-mail@anirudhrb.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.38.4 (3.38.4-1.fc33) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-malware-bazaar: not-scanned
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 2021-06-10 at 21:49 +0530, Anirudh Rayabharam wrote:
> syzbot, using KMSAN, has reported an uninit-value access in
> hwsim_cloned_frame_received_nl(). This is happening because frame_data_len
> is 0. The code doesn't detect this case and blindly tries to read the
> frame's header.
> 
> Fix this by bailing out in case frame_data_len is 0.

This really seems quite pointless - you should bail out if the frame is
too short for what we need to do, not just when it's 0.

johannes

