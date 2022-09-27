Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D3D585EC5E7
	for <lists+netdev@lfdr.de>; Tue, 27 Sep 2022 16:22:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231391AbiI0OWz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Sep 2022 10:22:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36608 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230159AbiI0OWy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Sep 2022 10:22:54 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EDDACF3F84;
        Tue, 27 Sep 2022 07:22:51 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 83279619DA;
        Tue, 27 Sep 2022 14:22:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 99478C433C1;
        Tue, 27 Sep 2022 14:22:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1664288571;
        bh=Mxxkud4350xH0dbkE+My1SkNYeXQPaWI88H/h+2brhQ=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=t05Z5nCuQG9Ci/dPWp7QlnW3bigkP/eWso/338NIs7A9tM4TKNshXKlgDIR/J3xnV
         fVMnrFhcmgoEi++p93Cx9KyiZKRxLyE3ltW1odPmoy0F/0qvbcruzhfEB8+qiEVrLn
         DCsZPYZg/qKr5otLVh9XpcwlC/UvY8n5rjyUpCxe6/ia+ZMXllS9ZufRG4aYapMIju
         JujrO2dXMytap0hyOqbZmc8dQbfhq5YVqZdzxGbTn0DJ9I8DrUal8XQOiAAhMZ/Jma
         43lLiHX8/ipKC6NcFx5tKtF1HNCIziHiYY3qk2T0VzE/ExKO64GyY7nWKedMLud1Nv
         2GUk7BXOw/dNQ==
Date:   Tue, 27 Sep 2022 07:22:49 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Christian Langrock <christian.langrock@secunet.com>
Cc:     Steffen Klassert <steffen.klassert@secunet.com>,
        <herbert@gondor.apana.org.au>, <davem@davemloft.net>,
        <edumazet@google.com>, <pabeni@redhat.com>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net-ipsec v2] xfrm: replay: Fix ESN wrap around for GSO
Message-ID: <20220927072249.0e16c09f@kernel.org>
In-Reply-To: <fe554921-104e-2365-a09b-812a1cedac65@secunet.com>
References: <fe554921-104e-2365-a09b-812a1cedac65@secunet.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 27 Sep 2022 14:59:50 +0200 Christian Langrock wrote:
> When using GSO it can happen that the wrong seq_hi is used for the last
> packets before the wrap around. This can lead to double usage of a
> sequence number. To avoid this, we should serialize this last GSO
> packet.

Does not build but please wait for reviews before reposting:

net/xfrm/xfrm_replay.c:773:6: error: conflicting types for =E2=80=98xfrm_re=
play_overflow_check=E2=80=99; have =E2=80=98bool(struct xfrm_state *, struc=
t sk_buff *)=E2=80=99 {aka =E2=80=98_Bool(struct xfrm_state *, struct sk_bu=
ff *)=E2=80=99}
  773 | bool xfrm_replay_overflow_check(struct xfrm_state *x, struct sk_buf=
f *skb)
      |      ^~~~~~~~~~~~~~~~~~~~~~~~~~
