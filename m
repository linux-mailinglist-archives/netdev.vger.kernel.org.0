Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0C67D5A0C03
	for <lists+netdev@lfdr.de>; Thu, 25 Aug 2022 10:58:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234556AbiHYI6M (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Aug 2022 04:58:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43196 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231604AbiHYI6M (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Aug 2022 04:58:12 -0400
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 49B0EA7AAA;
        Thu, 25 Aug 2022 01:58:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=sipsolutions.net; s=mail; h=MIME-Version:Content-Transfer-Encoding:
        Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender
        :Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
        Resent-Cc:Resent-Message-ID; bh=ixxsyxgLb973PnRaZa2775xCgd4CdHjjz5+/rMoW9tU=;
        t=1661417891; x=1662627491; b=GgXpL1ags4HlmSkJh5UdDoT9KDH9BCb89wB5FiUB5iw/Owm
        7xaOMOZkS4S3DMD4rBg6i4hM84uedQpkq9vat+vIEfD64uy+w2CnkrVYp4xvSx1mvehiOO58E21Ev
        9XhhhNq5IlwvYD//MDAtUMLXsni8y4uMRQ4JNu++ENVNeLGSbB9eBW/PEmTfchMjEthT3BKRuRMU1
        2iv1mUJUoJdqM2yIc4+7KuYthD/fKA2Rw1v+fCp4CniF+rCMacti2gGYxnzvxHDiC1SKmPDwK/NHy
        M4NJ55aidbmu5GJDoQdN2xvbEm17hozK6GEaeki0+kl3oeccVXfFvHZkGLkGDT+Q==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.96)
        (envelope-from <johannes@sipsolutions.net>)
        id 1oR8gg-00GzbT-0g;
        Thu, 25 Aug 2022 10:58:06 +0200
Message-ID: <a3361036446058fe386634a9016c6925146a078e.camel@sipsolutions.net>
Subject: Re: [RFC/RFT v5 2/4] mac80211: add periodic monitor for channel
 busy time
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Baligh Gasmi <gasmibal@gmail.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Felix Fietkau <nbd@nbd.name>,
        Toke Hoiland-Jorgensen <toke@redhat.com>,
        Linus Lussing <linus.luessing@c0d3.blue>,
        Kalle Valo <kvalo@kernel.org>
Date:   Thu, 25 Aug 2022 10:58:05 +0200
In-Reply-To: <20220719123525.3448926-3-gasmibal@gmail.com>
References: <20220719123525.3448926-1-gasmibal@gmail.com>
         <20220719123525.3448926-3-gasmibal@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.44.4 (3.44.4-1.fc36) 
MIME-Version: 1.0
X-malware-bazaar: not-scanned
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 2022-07-19 at 14:35 +0200, Baligh Gasmi wrote:
> Add a worker scheduled periodicaly to calculate the busy time average of
> the current channel.
>=20
> This will be used in the estimation for expected throughput.
>=20

I really don't think you should/can do this - having a 1-second periodic
timer (for each interface even!) is going to be really bad for power
consumption.

Please find a way to inline the recalculation with statistics updates
and/or queries.

johannes
