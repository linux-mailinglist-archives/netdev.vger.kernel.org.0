Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D98D06E3CAD
	for <lists+netdev@lfdr.de>; Mon, 17 Apr 2023 00:43:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229932AbjDPWnU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 16 Apr 2023 18:43:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42370 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229500AbjDPWnU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 16 Apr 2023 18:43:20 -0400
Received: from sonata.ens-lyon.org (sonata.ens-lyon.org [140.77.166.138])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C1341BDD;
        Sun, 16 Apr 2023 15:43:19 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
        by sonata.ens-lyon.org (Postfix) with ESMTP id C769E20187;
        Mon, 17 Apr 2023 00:43:17 +0200 (CEST)
Received: from sonata.ens-lyon.org ([127.0.0.1])
        by localhost (sonata.ens-lyon.org [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id vX8EeMPoLeKL; Mon, 17 Apr 2023 00:43:17 +0200 (CEST)
Received: from begin.home (apoitiers-658-1-118-253.w92-162.abo.wanadoo.fr [92.162.65.253])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by sonata.ens-lyon.org (Postfix) with ESMTPSA id 5F97F20186;
        Mon, 17 Apr 2023 00:43:17 +0200 (CEST)
Received: from samy by begin.home with local (Exim 4.96)
        (envelope-from <samuel.thibault@ens-lyon.org>)
        id 1poB5Y-003fMu-2g;
        Mon, 17 Apr 2023 00:43:16 +0200
Date:   Mon, 17 Apr 2023 00:43:16 +0200
From:   Samuel Thibault <samuel.thibault@ens-lyon.org>
To:     Dominique Martinet <asmadeus@codewreck.org>
Cc:     James Chapman <jchapman@katalix.com>, tparkin@katalix.com,
        edumazet@google.com, davem@davemloft.net, kuba@kernel.org,
        pabeni@redhat.com, corbet@lwn.net, netdev@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] PPPoL2TP: Add more code snippets
Message-ID: <20230416224316.xlvgjor65nejldwh@begin>
Mail-Followup-To: Samuel Thibault <samuel.thibault@ens-lyon.org>,
        Dominique Martinet <asmadeus@codewreck.org>,
        James Chapman <jchapman@katalix.com>, tparkin@katalix.com,
        edumazet@google.com, davem@davemloft.net, kuba@kernel.org,
        pabeni@redhat.com, corbet@lwn.net, netdev@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20230416220704.xqk4q6uwjbujnqpv@begin>
 <ZDx2IUYTmLSdzU6D@codewreck.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZDx2IUYTmLSdzU6D@codewreck.org>
Organization: I am not organized
User-Agent: NeoMutt/20170609 (1.8.3)
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_NONE,
        SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Dominique Martinet, le lun. 17 avril 2023 07:26:41 +0900, a ecrit:
> > +The ppp<ifunit> interface can then be configured as usual with SIOCSIFMTU,
> > +SIOCSIFADDR, SIOCSIFDSTADDR, SIOCSIFNETMASK, and activated by setting IFF_UP
> > +with SIOCSIFFLAGS
> 
> (That somewhat makes it sounds like the "new" netlink interface cannot
> be used (e.g. ip command);

Ah, right...

> although I guess sommeone implementing this would be more likely to
> use the ioctls than not so having the names can be a timesaver?)

It's indeed a timesaver to have the ioctl names, but perhaps we can
replace this part with a pointer to a if-configuration documentation?

> Also, this got me wondering if the 'if' fd can be closed immediately or
> if the interface will be removed when the fd is closed (probably not?)

Closing the fd would close the if, yes. AIUI one really has to keep the
pppox socket (for stats), the ppp chan (for non-data ppp packets), and
the ppp if (for the if).

Samuel
