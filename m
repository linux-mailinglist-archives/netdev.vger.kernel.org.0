Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7FEBD53D29E
	for <lists+netdev@lfdr.de>; Fri,  3 Jun 2022 22:08:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345573AbiFCUI2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Jun 2022 16:08:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55278 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231804AbiFCUI1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Jun 2022 16:08:27 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD96E289A7
        for <netdev@vger.kernel.org>; Fri,  3 Jun 2022 13:08:26 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 33AEF1F385;
        Fri,  3 Jun 2022 20:08:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1654286905;
        h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
         cc:cc:mime-version:mime-version:content-type:content-type;
        bh=bodED2swraf2B57rhswpaS2GJowIKa+Sy8Qq/XtavYY=;
        b=qSe18lDeLIZ0qOFloIhebTXgEkzIfW3X11uVjCTll1Bh8FbHhN8AKDTuAsbLpaVRtxxDPp
        o95Zyjo62sSJy826WB9hgku6Zr/nTZPy2GmFLKkdfCUi2kbcN9TTkotGS530zliwrv6raz
        1D33EwCWKS6Q798rIUiVYbYLQ6hPMX8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1654286905;
        h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
         cc:cc:mime-version:mime-version:content-type:content-type;
        bh=bodED2swraf2B57rhswpaS2GJowIKa+Sy8Qq/XtavYY=;
        b=3fPWAjbWLaPkAf3xdlq+cXFpDHTBRujSdH3FaxQ7NQHqX5Zl9oeeL+wEpHvprofcpH0kwh
        zNZ6s+QNiG4N3vCg==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 6530213638;
        Fri,  3 Jun 2022 20:08:24 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id yZTRFjhqmmIkDwAAMHmgww
        (envelope-from <pvorel@suse.cz>); Fri, 03 Jun 2022 20:08:24 +0000
Date:   Fri, 3 Jun 2022 22:08:22 +0200
From:   Petr Vorel <pvorel@suse.cz>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        David Ahern <dsahern@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [RFC] Backporting "add second dif to raw, inet{6,}, udp, multicast
 sockets" to LTS 4.9
Message-ID: <YppqNtTmqjeR5cZV@pevik>
Reply-To: Petr Vorel <pvorel@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi all,

David (both), would it be possible to backport your commits from merge
9bcb5a572fd6 ("Merge branch 'net-l3mdev-Support-for-sockets-bound-to-enslaved-device'")
from v4.14-rc1 to LTS 4.9?

These commits added second dif to raw, inet{6,}, udp, multicast sockets.
The change is not a fix but a feature - significant change, therefore I
understand if you're aginast backporting it.

My motivation is to get backported to LTS 4.9 these fixes from v5.17 (which
has been backported to all newer stable/LTS trees):
2afc3b5a31f9 ("ping: fix the sk_bound_dev_if match in ping_lookup")
35a79e64de29 ("ping: fix the dif and sdif check in ping_lookup")
cd33bdcbead8 ("ping: remove pr_err from ping_lookup")

which fix small issue with IPv6 in ICMP datagram socket ("ping" socket).

These 3 commits depend on 9bcb5a572fd6, particularly on:
3fa6f616a7a4d ("net: ipv4: add second dif to inet socket lookups")
4297a0ef08572 ("net: ipv6: add second dif to inet6 socket lookups")

Kind regards,
Petr
