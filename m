Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5E4B264449B
	for <lists+netdev@lfdr.de>; Tue,  6 Dec 2022 14:33:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234240AbiLFNdS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Dec 2022 08:33:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35856 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234213AbiLFNdR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Dec 2022 08:33:17 -0500
Received: from mail-oa1-x2e.google.com (mail-oa1-x2e.google.com [IPv6:2001:4860:4864:20::2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D67DFBCA6
        for <netdev@vger.kernel.org>; Tue,  6 Dec 2022 05:33:16 -0800 (PST)
Received: by mail-oa1-x2e.google.com with SMTP id 586e51a60fabf-1441d7d40c6so17352087fac.8
        for <netdev@vger.kernel.org>; Tue, 06 Dec 2022 05:33:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=H8ENTwhPhRahc1ArN8EwvE3qHgWKIVAw9b7P7SAKrQk=;
        b=RcpLmQd5wKdLERDnlDQaMsf41Jap2n2n2rnpxatWTsH2PVA0cDPtgy4ChDMogCjGdR
         M73dbDRUkKcZtgGXLBedBdYJ93kswN6IDDja+7Mm1Y3g5+xHWMEr5F9WGilb9aTmkq+8
         F6u+Zpbe0Uj+10EWE3E96ygtFdEmMS3+Ll8fP4Qb9O046G4SQ1Qp8kaUfmNk6mB2b7wo
         qD0QMUAN1uLTQ04gacTVo0KceHmJUMRvw5+RvuNlJERXAY3aK7t+GMemIjrwiNThb4b/
         TA/f6j747t2Czs6V8fiaZJJeUgE+DTRW7ViO38ukZeVSCzoYWUjhm6I1h5ZhYR6OEC5n
         jGrQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=H8ENTwhPhRahc1ArN8EwvE3qHgWKIVAw9b7P7SAKrQk=;
        b=FUfFd+kR4qviLm1GSkFMIf11ROG6HT9wnwyo/XKpSJueLgSH17eQbzlki4nlbMOmA7
         i9dC3uxw/e8t7Y5CVspARpy2pfr/wLz3zaZ+BeIuQ7WxE3cRl1FKU1bRKoIOQ4mERRKY
         tF4WLf48oou0SjSDLCLcK2QoTUINupXkgkKXGdQkC4WLgkuaJJp0XnFA7UcV0MEHMIHK
         h15K+h8zH/rUQoe/aAjVTlor+Aik2mryoldkarOiencpRH2w656fpsuvFQx1ltfd0iLk
         x1PMzXhA/nptz1iRDg+lWarxG40lgZ8VHMivBpLQag7muw5bPRuVdiC5t/G5Hx0F2pwF
         mPog==
X-Gm-Message-State: ANoB5pk2Kd12/7hnPyNWlkoI4akivjyBwG5lb19JWPFLvmMGW7zaKM2/
        G8qC5uwLtXnRm1k4KFs0/8rr6lYXAsZHUNhlVMdS3Dn4+TGCQv/M
X-Google-Smtp-Source: AA0mqf4v/jEZ9lIG9ar65e5JN/JPF92vryTwk1DsTzpK9t4M7vxaYnP0qdWTe4KFInlOvnvIYxyyvMENheFqNJgY+/g=
X-Received: by 2002:a05:6870:b426:b0:142:c277:2e94 with SMTP id
 x38-20020a056870b42600b00142c2772e94mr38536984oap.129.1670333596085; Tue, 06
 Dec 2022 05:33:16 -0800 (PST)
MIME-Version: 1.0
References: <32ee765d2240163f1cbd5d99db6233f276857ccb.1670262365.git.lucien.xin@gmail.com>
 <Y4731q0/oqwhHZod@nanopsycho>
In-Reply-To: <Y4731q0/oqwhHZod@nanopsycho>
From:   Xin Long <lucien.xin@gmail.com>
Date:   Tue, 6 Dec 2022 08:32:25 -0500
Message-ID: <CADvbK_e6dFT6L69g63FOu=uE7b48rubaYOBL0RDTmKRUBFDCjw@mail.gmail.com>
Subject: Re: [PATCH net] team: prevent ipv6 link local address on port devices
To:     Jiri Pirko <jiri@resnulli.us>,
        Stephen Hemminger <stephen@networkplumber.org>
Cc:     network dev <netdev@vger.kernel.org>, davem@davemloft.net,
        kuba@kernel.org, Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, LiLiang <liali@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Dec 6, 2022 at 3:05 AM Jiri Pirko <jiri@resnulli.us> wrote:
>
> Mon, Dec 05, 2022 at 06:46:05PM CET, lucien.xin@gmail.com wrote:
> >The similar fix from commit c2edacf80e15 ("bonding / ipv6: no addrconf
> >for slaves separately from master") is also needed in Team. Otherwise,
> >DAD and RS packets to be sent from the slaves in turn can confuse the
> >switches and cause them to incorrectly update their forwarding tables
> >as Liang noticed in the test with activebackup mode.
> >
> >Note that the patch also sets IFF_MASTER flag for Team dev accordingly
> >while IFF_SLAVE flag is set for port devs. Although IFF_MASTER flag is
> >not really used in Team, it's good to show in 'ip link':
> >
> >  eth1: <BROADCAST,MULTICAST,SLAVE,UP,LOWER_UP>
> >  team0: <BROADCAST,MULTICAST,MASTER,UP,LOWER_UP>
> >
> >Fixes: 3d249d4ca7d0 ("net: introduce ethernet teaming device")
> >Reported-by: LiLiang <liali@redhat.com>
> >Signed-off-by: Xin Long <lucien.xin@gmail.com>
>
> Nack. Please don't do this. IFF_MASTER and IFF_SLAVE are historical
> flags used by bonding and eql. Should not be used for other devices.
I see. I was wondering why it was not used in Team at the beginning. :)

>
> addrconf_addr_gen() should not check IFF_SLAVE. It should use:
> netif_is_lag_port() and netif_is_failover_slave() helpers.
netif_is_failover_slave() should be able to address Stephen's concern
on failover network device.

Will repost, Thanks.
