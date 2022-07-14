Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4FE1857474E
	for <lists+netdev@lfdr.de>; Thu, 14 Jul 2022 10:39:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237088AbiGNIjX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Jul 2022 04:39:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33268 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235889AbiGNIjJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Jul 2022 04:39:09 -0400
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F2823DBFE;
        Thu, 14 Jul 2022 01:39:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=sipsolutions.net; s=mail; h=MIME-Version:Content-Transfer-Encoding:
        Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender
        :Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
        Resent-Cc:Resent-Message-ID; bh=GDZb6HW14xEWInYiDjDK6Vvijng3PrdzltFTTkvk0sg=;
        t=1657787948; x=1658997548; b=DUR4CntDZsePVnOYwTeW1Xi9PbWbuLVqix4bM+ATXq9WFzn
        BC8O4A0IUVmIE00NbGrWJqudUHoh+qa1FOEPu1Ddzqj6pyIDE46l9Cp19vQXn/Cr8+sWAt3wRNZzR
        lMN1RQC/SxUVLsERXkIdhX7/yYS/BWMQM8XEGIntsSLzN8F54u0Rn05s+CVzgAv9wku77uYekeb1Y
        /xkhZKiKKI0dd/gi8eqTSHpe7nyMig/O4RK1UQUKuyMcpnIKcJ/qd11660gEJIum0FUA2vkar+xe9
        RsbyDzv03N+njLBQWQ8UZEQHftsDSij7m3C8M+ToyMIfZI4OEsV7+zz2QpgpSTkQ==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.95)
        (envelope-from <johannes@sipsolutions.net>)
        id 1oBuN9-00FYgu-LL;
        Thu, 14 Jul 2022 10:38:59 +0200
Message-ID: <86d347821699bac79902608d32e2bfac569347a3.camel@sipsolutions.net>
Subject: Re: [PATCH v1] wifi: mac80211_hwsim: fix race condition in pending
 packet
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Jeongik Cha <jeongik@google.com>, Kalle Valo <kvalo@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     adelva@google.com, kernel-team@android.com, jaeman@google.com,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date:   Thu, 14 Jul 2022 10:38:57 +0200
In-Reply-To: <CAE7E4g=BGzup31AD5zAuZpoR2gMswJhuo67B7cV8=wHOY=Y+qA@mail.gmail.com>
References: <20220704084354.3556326-1-jeongik@google.com>
         <CAE7E4g=BGzup31AD5zAuZpoR2gMswJhuo67B7cV8=wHOY=Y+qA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.44.3 (3.44.3-1.fc36) 
MIME-Version: 1.0
X-malware-bazaar: not-scanned
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 2022-07-14 at 17:37 +0900, Jeongik Cha wrote:
>=20
> It fixes kernel panics during a long test which uses mac80211_hwsim
> driver. So I think it would be beneficial if we could merge this into
> LTS branches. Could you share your opinion?
>=20

It also introduced two build compiler warning issues so I have two more
fixes ... I guess you can request that, but make sure you include the
other fixes (one of which hasn't landed yet) :-)

johannes
