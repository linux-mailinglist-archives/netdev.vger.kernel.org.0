Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 59F4C67ECF2
	for <lists+netdev@lfdr.de>; Fri, 27 Jan 2023 19:00:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235032AbjA0SAA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Jan 2023 13:00:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42632 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234014AbjA0R77 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Jan 2023 12:59:59 -0500
Received: from mail-pf1-x42d.google.com (mail-pf1-x42d.google.com [IPv6:2607:f8b0:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C51FE7D2AA
        for <netdev@vger.kernel.org>; Fri, 27 Jan 2023 09:59:54 -0800 (PST)
Received: by mail-pf1-x42d.google.com with SMTP id u5so3496656pfm.10
        for <netdev@vger.kernel.org>; Fri, 27 Jan 2023 09:59:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=SGRZU6sBKdHYY98vV9P0PZ2VeWaRqM0+iBCYc+44H+M=;
        b=IVFA7hgzBOccvXL/T3nj1r7vg8OyzJbfnFwW/Pu6Twv5vp2nH753sjqOaqqKVkzINN
         LSMpYJbydQ1Ov62v7oQyXisa0xU5welOAZmy0WpxvOhrorcjhodHKMKUKajqlU+Ycjy6
         4IjsFoROanZP0aKvhloB+My0Ai6w44jymWvE6vKmkoBDyuKmYesesajGL+XbKl45SQM6
         KckYXQT7DUceOHVeZJK4z8fBZlnAQBXFXtOyaxr+6Rbdofdiv9b6cie/JnP80S97X4cq
         BXyUcSpnfHRRZVE9RWIRS1vcXxaFEagkTsgQPXkuWML0RUwKE/eREVzaoT5On0JM/H4R
         fJjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=SGRZU6sBKdHYY98vV9P0PZ2VeWaRqM0+iBCYc+44H+M=;
        b=j+r0yC+ORBzcwSBs9lT5T0Mq0yZ+ZVYBob64rq6GBifxv7l4DbYAAHAsaYW32L5aVN
         pAo60wcaiQF146DCdssxfEVai7abye9YyZz/xCqGjmsdDso2f9o02r99tp1lLw/pIjlt
         hReCYTNiBNWcmgRj3xE02I0hufRFgtx4FyzvAmfwwyJtT1XhVlYK+tX5QsUTATPrO+tA
         EYFpvs49XmTUBWl0stClESdH8lMRSrR1qiMBDoLrcLTjPT7NYpgOqsfVYWlWPuHLAmjP
         ZtQaoaROJoPyX0EZmGTnrc96ev+cJ5Wnx15Ax++d6gBZ/ncMkzz/7kGOpXRDbMiK6Hjs
         j1aQ==
X-Gm-Message-State: AO0yUKXYfjWhnnS3SQzQglC3DRbW2CeFfp9V/VfvByHZPCDUCEp1A1Md
        8XrI5Q7GX97+FhFgDkrSvPQrMX0MkZDbJ1k1ilnSnA==
X-Google-Smtp-Source: AK7set+EgMQvBR+QbbBn1xyxGpT3DVQcxryQ4OvzynBHTamIJ/yghEhaej7aGQD6ncamZugEaVIZXUHsFrqOoNB2ZmU=
X-Received: by 2002:a62:3307:0:b0:592:4847:79b0 with SMTP id
 z7-20020a623307000000b00592484779b0mr945654pfz.49.1674842394083; Fri, 27 Jan
 2023 09:59:54 -0800 (PST)
MIME-Version: 1.0
References: <cover.1674737592.git.lorenzo@kernel.org> <0b05b08d4579b017dd96869d1329cd82801bd803.1674737592.git.lorenzo@kernel.org>
 <Y9LIPaojtpTjYlNu@google.com> <Y9QJQHq8X9HZxoW3@lore-desk>
 <CAKH8qBv9wKzkW8Qk+hDKCmROKem6ajkqhF_KRqdEKWSLL6_HsA@mail.gmail.com>
 <874jsblv9h.fsf@toke.dk> <Y9QQxMIVd+1chwm3@lore-desk>
In-Reply-To: <Y9QQxMIVd+1chwm3@lore-desk>
From:   Stanislav Fomichev <sdf@google.com>
Date:   Fri, 27 Jan 2023 09:59:42 -0800
Message-ID: <CAKH8qBsiPNdcPf-20+kKJDpPjLOs=CTvVcNPMAdebJZPQad_qw@mail.gmail.com>
Subject: Re: [PATCH v3 bpf-next 8/8] selftests/bpf: introduce XDP compliance
 test tool
To:     Lorenzo Bianconi <lorenzo@kernel.org>
Cc:     =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>,
        bpf@vger.kernel.org, netdev@vger.kernel.org, ast@kernel.org,
        daniel@iogearbox.net, andrii@kernel.org, davem@davemloft.net,
        kuba@kernel.org, hawk@kernel.org, pabeni@redhat.com,
        edumazet@google.com, memxor@gmail.com, alardam@gmail.com,
        saeedm@nvidia.com, anthony.l.nguyen@intel.com, gospo@broadcom.com,
        vladimir.oltean@nxp.com, nbd@nbd.name, john@phrozen.org,
        leon@kernel.org, simon.horman@corigine.com, aelior@marvell.com,
        christophe.jaillet@wanadoo.fr, ecree.xilinx@gmail.com,
        mst@redhat.com, bjorn@kernel.org, magnus.karlsson@intel.com,
        maciej.fijalkowski@intel.com, intel-wired-lan@lists.osuosl.org,
        lorenzo.bianconi@redhat.com, martin.lau@linux.dev
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jan 27, 2023 at 9:58 AM Lorenzo Bianconi <lorenzo@kernel.org> wrote:
>
> On Jan 27, Toke wrote:
> > Stanislav Fomichev <sdf@google.com> writes:
> >
> > >> > > +
> > >> > > +   ctrl_sockfd = accept(sockfd, (struct sockaddr *)&ctrl_addr, &len);
> > >> > > +   if (ctrl_sockfd < 0) {
> > >> > > +           fprintf(stderr, "Failed to accept connection on DUT socket\n");
> > >> > > +           close(sockfd);
> > >> > > +           return -errno;
> > >> > > +   }
> > >> > > +
> > >>
> > >> [...]
> > >>
> > >> >
> > >> > There is also connect_to_fd, maybe we can use that? It should take
> > >> > care of the timeouts.. (requires plumbing server_fd, not sure whether
> > >> > it's a problem or not)
> > >>
> > >> please correct me if I am wrong, but in order to have server_fd it is mandatory
> > >> both tester and DUT are running on the same process, right? Here, I guess 99% of
> > >> the times DUT and tester will run on two separated devices. Agree?
> > >
> > > Yes, it's targeting more the case where you have a server fd and a
> > > bunch of clients in the same process. But I think it's still usable in
> > > your case, you're not using fork() anywhere afaict, so even if these
> > > are separate devices, connect_to_fd should still work. (unless I'm
> > > missing something, haven't looked too closely)
> >
> > Just to add a bit of context here, "separate devices" can refer to the
> > hosts as well as the netdevs. I.e., it should also be possible to run
> > this in a mode where the client bit runs on a different physical machine
> > than the server bit (as it will not be feasible in any case to connect
> > things with loopback cables).
>
> yes, this is what I meant with 'DUT and tester will run on two separated
> devices' (sorry to have not been so clear). Looking at the code server_fd
> is always obtained from start_server(), while here the client on the tester
> just knows the IPv4/IPv6 address and the port of the server running on the DUT.

Ah, in this case yeah, definitely, connect_to_fd can't be applied
here, ignore me.
Thanks for clarifying! In this case let's just make the tool dualstack aware.

> Regards,
> Lorenzo
>
> >
> > -Toke
> >
