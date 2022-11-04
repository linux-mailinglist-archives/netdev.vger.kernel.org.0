Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 111F9619D17
	for <lists+netdev@lfdr.de>; Fri,  4 Nov 2022 17:24:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230324AbiKDQX5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Nov 2022 12:23:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51272 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230194AbiKDQXx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Nov 2022 12:23:53 -0400
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 214E3267B;
        Fri,  4 Nov 2022 09:23:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=sipsolutions.net; s=mail; h=MIME-Version:Content-Transfer-Encoding:
        Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender
        :Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
        Resent-Cc:Resent-Message-ID; bh=QPfTEW1yEsUmv2SnsC8Z/iqqatNA8YdvlM9LwrrznSE=;
        t=1667579033; x=1668788633; b=wFm8vAEfwSC93OcWSskboyN2Bkn107w4oC4lMLI8lI2XSxX
        yeHnsyXy+j8mKPHZWk45hXassq9y4gDTkKkFkHxIGROiDsG5U35+2s3juuzmZ0FYYeSU5fBUxgTaB
        EZ7Bv8rZIeHxCW4HuH1SqEPW8J1/uOAJUKVP9asdit9Xc0MXt/KjPlbZzhrLKqhyl/aNh0T3XAg1L
        XYTcV/Dr6jHN1Nth6Lk068o7BvucvEsh2keuKJztvj9/W31hlFXKHj9x4zBYRPpbWUQTqbrlfFt+C
        LgvwNqdhqn0cJkfplMbEc5CD6M9sTe7Fw0GGPYvMoGrhBqEhHOlRynbQXhjJwAEg==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.96)
        (envelope-from <johannes@sipsolutions.net>)
        id 1oqzTp-008uqO-2L;
        Fri, 04 Nov 2022 17:23:42 +0100
Message-ID: <d6c8594159368034d47a169ccdd50bc65a1ad894.camel@sipsolutions.net>
Subject: Re: [PATCH v3] wifi: rsi: Fix handling of 802.3 EAPOL frames sent
 via control port
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Marek Vasut <marex@denx.de>, linux-wireless@vger.kernel.org
Cc:     Amitkumar Karwar <amit.karwar@redpinesignals.com>,
        Angus Ainslie <angus@akkea.ca>,
        Jakub Kicinski <kuba@kernel.org>,
        Kalle Valo <kvalo@kernel.org>,
        Martin Fuzzey <martin.fuzzey@flowbird.group>,
        Martin Kepplinger <martink@posteo.de>,
        Prameela Rani Garnepudi <prameela.j04cs@gmail.com>,
        Sebastian Krzyszkowiak <sebastian.krzyszkowiak@puri.sm>,
        Siva Rebbagondla <siva8118@gmail.com>, netdev@vger.kernel.org
Date:   Fri, 04 Nov 2022 17:23:40 +0100
In-Reply-To: <a3ef782d-9c85-d752-52b5-589d5e1f1bd5@denx.de>
References: <20221104155841.213387-1-marex@denx.de>
         <cf7da8e9a135fee1a9ac0e8f768a2a13bbba058d.camel@sipsolutions.net>
         <a3ef782d-9c85-d752-52b5-589d5e1f1bd5@denx.de>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.44.4 (3.44.4-2.fc36) 
MIME-Version: 1.0
X-malware-bazaar: not-scanned
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 2022-11-04 at 17:09 +0100, Marek Vasut wrote:
>=20
> In V2 it was suggested I deduplicate this into a separate function,=20
> since the test is done in multiple places. I would like to keep it=20
> deduplicated.

Well, it's now a lot simpler, so one might argue that it's not needed.

But anyway you're touching the hot-path of this driver, and making it an
inline still keeps it de-duplicated, so not sure why you wouldn't just
move the rsi_is_tx_eapol into the header file as static inline?

johannes
