Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9D74F618618
	for <lists+netdev@lfdr.de>; Thu,  3 Nov 2022 18:25:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230363AbiKCRZG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Nov 2022 13:25:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46308 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231880AbiKCRZD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Nov 2022 13:25:03 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [IPv6:2001:67c:2178:6::1c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C47D13EA3
        for <netdev@vger.kernel.org>; Thu,  3 Nov 2022 10:24:54 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 1FD3021BBF;
        Thu,  3 Nov 2022 17:24:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1667496293;
        h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
         cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=RnVvQZnWkDOCHviCtwmIUmNSdii7Gc8sBgULNN/b6n4=;
        b=HmiYzhifpsxcjlsb08bsJ9M3+ePkOpo3UpQL2mRIEIRLmhxlxpe9WBAY4rtdC/ZG2p4XcM
        aI8bpKeSOS643LMpfvZ9WiMMfTfOF6iqwK5ew2zF2zTwr/z1kiN4qG4yfiiWdQZmS7JIVf
        kskAh4ynxrWYsn4ZDUmyqg6ri21OzHg=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1667496293;
        h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
         cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=RnVvQZnWkDOCHviCtwmIUmNSdii7Gc8sBgULNN/b6n4=;
        b=hKnhk2JCEMdERwbwYi4yAr0TRUMAHFu4sPuFkEHkwLcv9gZ7gk9vfaFC+EaoCJjHWFSF27
        OssTAipnQAgLTpCQ==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 84EC913AAF;
        Thu,  3 Nov 2022 17:24:52 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id NgqvHmT5Y2M0YAAAMHmgww
        (envelope-from <pvorel@suse.cz>); Thu, 03 Nov 2022 17:24:52 +0000
Date:   Thu, 3 Nov 2022 18:24:50 +0100
From:   Petr Vorel <pvorel@suse.cz>
To:     Xin Long <lucien.xin@gmail.com>
Cc:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Michal Kubecek <mkubecek@suse.cz>,
        Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        David Ahern <dsahern@gmail.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Vasiliy Kulikov <segoon@openwall.com>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>
Subject: Re: ping (iputils) review (call for help)
Message-ID: <Y2P5YsTuko5tgYJK@pevik>
Reply-To: Petr Vorel <pvorel@suse.cz>
References: <Y2OmQDjtHmQCHE7x@pevik>
 <CADvbK_cA=7czAvftMu9tn+SkDp9-NpdyxeKsf70U8WO7=0i22g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CADvbK_cA=7czAvftMu9tn+SkDp9-NpdyxeKsf70U8WO7=0i22g@mail.gmail.com>
X-Spam-Status: No, score=-3.7 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_SOFTFAIL autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Xin,

> On Thu, Nov 3, 2022 at 7:30 AM Petr Vorel <pvorel@suse.cz> wrote:

> > Hi,

> > I'm sorry to bother you about userspace. I'm preparing new iputils release and
> > I'm not sure about these two patches.  As there has been many regressions,
> > review from experts is more than welcome.

> > If you have time to review them, it does not matter if you post your
> > comments/RBT in github or here (as long as you keep Cc me so that I don't
> > overlook it).

> > BTW I wonder if it make sense to list Hideaki YOSHIFUJI as NETWORKING
> > IPv4/IPv6 maintainer. If I'm not mistaken, it has been a decade since he was active.

> > * ping: Call connect() before sending/receiving
> > https://github.com/iputils/iputils/pull/391
> > => I did not even knew it's possible to connect to ping socket, but looks like
> > it works on both raw socket and on ICMP datagram socket.
> The workaround of not using the PING socket is:

> # sysctl -w net.ipv4.ping_group_range="1 0"

Well raw socket requires capabilities or setuid. Because some distros has moved to
ICMP datagram socket, this approach requires root.


> > * ping: revert "ping: do not bind to device when destination IP is on device
> > https://github.com/iputils/iputils/pull/396
> > => the problem has been fixed in mainline and stable/LTS kernels therefore I
> > suppose we can revert cc44f4c as done in this PR. It's just a question if we
> > should care about people who run new iputils on older (unfixed) kernels.
> cc44f4c has also caused some regression though it's only seen in the
> kselftests, and that is why I made the kernel fix. I don't know which
> regression is more serious regardless of the patch's correctness. :-).
I'd prefer users not being affected than fixed tests and ping not working.

BTW can you be more specific, which kselftests is affected?
Ideally link to lore. In [1] you just mentioned "Jianlin noticed", I haven't
found anything on lore.

> or can we put some changelog to say that this revert should be
> backported together with the kernel commit?
Well, this practically means new iputils (compiled from git) will not work on
older (unfixed) kernel. Probably not many people will be affected, but why
to upset anybody?

If the problem now is just broken kselftests, I'd prefer keeping it long enough
(at least 1 year?) before reverting it.

Kind regards,
Petr

[1] https://lore.kernel.org/all/ea03066bc7256ab86df8d3501f3440819305be57.1644988852.git.lucien.xin@gmail.com/
