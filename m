Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B8A9E617B7B
	for <lists+netdev@lfdr.de>; Thu,  3 Nov 2022 12:30:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229953AbiKCLaO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Nov 2022 07:30:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44202 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229882AbiKCLaN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Nov 2022 07:30:13 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B33E1182C
        for <netdev@vger.kernel.org>; Thu,  3 Nov 2022 04:30:12 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id B266D21D04;
        Thu,  3 Nov 2022 11:30:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1667475010;
        h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
         cc:cc:mime-version:mime-version:content-type:content-type;
        bh=7K4EyUaBFaixIgI9latIoLa1BXKgqesuuFxP/tMTlIc=;
        b=rDra/KeFaFLkkvY9Uya8Xvu0H3jLDrc4Om53idL7SLLA0ie++EQn+4XE+91TlQ1kwIMufi
        9tnipMkTW/7qicabKlJP1+3cbiFq0yh1HfrJvfTudf9M0q3++vPNxqlUSzc0I3fPCQ493k
        lUcMUpSNNGeNLkLLzhAsL/ZG60+qQH0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1667475010;
        h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
         cc:cc:mime-version:mime-version:content-type:content-type;
        bh=7K4EyUaBFaixIgI9latIoLa1BXKgqesuuFxP/tMTlIc=;
        b=7NRxdv5/mTFPflsimWgQ05hgJv4SfIRkUqrtnka31RAIlWeGGtqJ9oD4m6npTV96Mf9+MM
        p23GGNc0nGsJqwBw==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 5CEB613480;
        Thu,  3 Nov 2022 11:30:10 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id 2lpvFUKmY2N2GwAAMHmgww
        (envelope-from <pvorel@suse.cz>); Thu, 03 Nov 2022 11:30:10 +0000
Date:   Thu, 3 Nov 2022 12:30:08 +0100
From:   Petr Vorel <pvorel@suse.cz>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Michal Kubecek <mkubecek@suse.cz>,
        Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        David Ahern <dsahern@gmail.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Xin Long <lucien.xin@gmail.com>,
        Vasiliy Kulikov <segoon@openwall.com>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>
Subject: ping (iputils) review (call for help)
Message-ID: <Y2OmQDjtHmQCHE7x@pevik>
Reply-To: Petr Vorel <pvorel@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

I'm sorry to bother you about userspace. I'm preparing new iputils release and
I'm not sure about these two patches.  As there has been many regressions,
review from experts is more than welcome.

If you have time to review them, it does not matter if you post your
comments/RBT in github or here (as long as you keep Cc me so that I don't
overlook it).

BTW I wonder if it make sense to list Hideaki YOSHIFUJI as NETWORKING
IPv4/IPv6 maintainer. If I'm not mistaken, it has been a decade since he was active.

* ping: Call connect() before sending/receiving
https://github.com/iputils/iputils/pull/391
=> I did not even knew it's possible to connect to ping socket, but looks like
it works on both raw socket and on ICMP datagram socket.

* ping: revert "ping: do not bind to device when destination IP is on device
https://github.com/iputils/iputils/pull/396
=> the problem has been fixed in mainline and stable/LTS kernels therefore I
suppose we can revert cc44f4c as done in this PR. It's just a question if we
should care about people who run new iputils on older (unfixed) kernels.

Kind regards,
Petr
