Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B1B9169FCA6
	for <lists+netdev@lfdr.de>; Wed, 22 Feb 2023 21:03:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231931AbjBVUDn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Feb 2023 15:03:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44560 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229603AbjBVUDm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Feb 2023 15:03:42 -0500
Received: from mail.ispras.ru (mail.ispras.ru [83.149.199.84])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 70FB0869A;
        Wed, 22 Feb 2023 12:03:41 -0800 (PST)
Received: from fpc.intra.ispras.ru (unknown [10.10.165.9])
        by mail.ispras.ru (Postfix) with ESMTPSA id 6D70B4077AED;
        Wed, 22 Feb 2023 20:03:35 +0000 (UTC)
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.ispras.ru 6D70B4077AED
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ispras.ru;
        s=default; t=1677096215;
        bh=vUdTngboS0pELBUARWbX4WHg6ejSpSC1AP+vPPz2Qok=;
        h=From:To:Cc:Subject:Date:From;
        b=GdYz5y6/RLsUn+pjSBBi2ns1lMUqPZPhyrshPbhUkld2L1/3QBeUbk2vki3iUkUHi
         yPhgVWde3PaLB3F4yaolyKySd40HsojcjRjjPwHOcdXqYdrvnADIjCInY0eTlpUwhG
         lnImwotspkLrT2S7OREL0L0gPfQjLXR0KgKfJ4Mo=
From:   Fedor Pchelkin <pchelkin@ispras.ru>
To:     stable@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Fedor Pchelkin <pchelkin@ispras.ru>,
        Johannes Berg <johannes@sipsolutions.net>,
        Pavel Skripkin <paskripkin@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Bob Copeland <me@bobcopeland.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Alexey Khoroshilov <khoroshilov@ispras.ru>,
        lvc-project@linuxtesting.org
Subject: [PATCH 5.4/5.10 0/1] mac80211: mesh: embedd mesh_paths and mpp_paths into ieee80211_if_mesh
Date:   Wed, 22 Feb 2023 23:03:00 +0300
Message-Id: <20230222200301.254791-1-pchelkin@ispras.ru>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The null-ptr-deref problem fixed in the following patch is hit on older
branches.

The patch failed to be initially backported into stable branches older
than 5.15 due to the fix-spell-comment commit ab4040df6efb ("mac80211: fix
some spelling mistakes"). Now it can be cleanly applied to the 5.4/5.10
stable branches.

I'm not sure if the comment-fix patch should be backported in these cases,
too (to prevent similar potential future backport fails). Probably not.
So I just adapted the backport patch in-place.
