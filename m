Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DBEA86EF1DF
	for <lists+netdev@lfdr.de>; Wed, 26 Apr 2023 12:25:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240036AbjDZKZq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Apr 2023 06:25:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55204 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229627AbjDZKZp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Apr 2023 06:25:45 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E77C2709
        for <netdev@vger.kernel.org>; Wed, 26 Apr 2023 03:25:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1682504699;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Q6T5nKRf+tLxwFxW8VyBeziXqKPsyv0cvge4JMWu6WE=;
        b=H1CQD98/CqnetQAiKAKQunoU1DIFtlCbCMKBdNwUPHAsICLyuslpz9xcQlEO8axgG6fFfl
        IeIBHaOLolGw3Acz0P0H0QSK1HZBqcfGlDNcGxqGJWe5c4GoMcgjPPYjUBuWGjHs++wEAn
        9yWzhGMjyg6IFq5UJ4yntm+Vb81Wd8E=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-539-jPUI7qm7P7WGr0epTEQHOA-1; Wed, 26 Apr 2023 06:24:55 -0400
X-MC-Unique: jPUI7qm7P7WGr0epTEQHOA-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id B262F185A78F;
        Wed, 26 Apr 2023 10:24:54 +0000 (UTC)
Received: from calimero.vinschen.de (unknown [10.39.194.190])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 142DA40C6E67;
        Wed, 26 Apr 2023 10:24:53 +0000 (UTC)
Received: by calimero.vinschen.de (Postfix, from userid 500)
        id 86AEBA80C97; Wed, 26 Apr 2023 12:24:52 +0200 (CEST)
Date:   Wed, 26 Apr 2023 12:24:52 +0200
From:   Corinna Vinschen <vinschen@redhat.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Heiner Kallweit <hkallweit1@gmail.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>, netdev@vger.kernel.org
Subject: Re: [PATCH net-next] net: stmmac: allow ethtool action on PCI
 devices if device is down
Message-ID: <ZEj79PLEcn7Q78T5@calimero.vinschen.de>
Mail-Followup-To: Jakub Kicinski <kuba@kernel.org>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>, netdev@vger.kernel.org
References: <20230331092341.268964-1-vinschen@redhat.com>
 <45c43618-3368-f780-c8bb-68db4ed5760f@gmail.com>
 <ZCqfwxr2I7xt6zon@calimero.vinschen.de>
 <ZEeLyVNgsFmRvour@calimero.vinschen.de>
 <20230425065441.1bc15b29@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20230425065441.1bc15b29@kernel.org>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
X-Spam-Status: No, score=-2.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Apr 25 06:54, Jakub Kicinski wrote:
> On Tue, 25 Apr 2023 10:14:01 +0200 Corinna Vinschen wrote:
> > is that patch still under review or is it refused, given the
> > current behaviour is not actually incorrect?
> 
> That's not what Heiner said. Does the device not link the netdev
> correctly to the bus device?

No, that's not the problem.

> Core already does pm_get/pm_put
> around ethtool calls.

Yeah, right.  I made a more thorough test now and it appears that
the calls don't even have any effect.

For testing I created a driver which simply skips the check for
netdev_running() and compared with the driver including my patch.
I tested almost all ethtool calls fetching and setting values and
there's no difference in behaviour.

Worse, while it's possible to change a lot of settings when skipping the
netdev_running() check, , some really basic stuff doesn't work as
desired.  I. e., setting autoneg or a fixed speed while the interface is
down is taken without complaints, but it has no effect when the
interface goes up again.

So we can just scratch my patch.  Sorry wasting your time.


Corinna

