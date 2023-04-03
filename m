Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 51AD36D5045
	for <lists+netdev@lfdr.de>; Mon,  3 Apr 2023 20:27:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232506AbjDCS1a (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Apr 2023 14:27:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51768 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231411AbjDCS12 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Apr 2023 14:27:28 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD2A31FD8
        for <netdev@vger.kernel.org>; Mon,  3 Apr 2023 11:26:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1680546407;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=wECXtNlB1W94hSRyJlTOlJrVqdbrkzbNNyHvGEpS1aU=;
        b=Wj5R9zx4hmuNjXLD2b+RfrFPWHWPpHnC1oeKArgoJeQ/kiEmKBonP1APtS1h3HfMOoN/+P
        oJbaL4uNyRoXIF7oeCmVaiz+eVHtzmeO3HDV+fTaPq7iQOkaLu4+4MOc/QwWx3w73qx+jf
        lba0tcP2Fg3YblVu456j6Ky1rXr3eBQ=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-665-woCI0uF-PIeXBwoaoAJHcg-1; Mon, 03 Apr 2023 14:26:45 -0400
X-MC-Unique: woCI0uF-PIeXBwoaoAJHcg-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 0007285A5B1;
        Mon,  3 Apr 2023 18:26:44 +0000 (UTC)
Received: from calimero.vinschen.de (unknown [10.39.192.15])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id B7CD840C20FA;
        Mon,  3 Apr 2023 18:26:44 +0000 (UTC)
Received: by calimero.vinschen.de (Postfix, from userid 500)
        id 9DB34A80CED; Mon,  3 Apr 2023 20:26:43 +0200 (CEST)
Date:   Mon, 3 Apr 2023 20:26:43 +0200
From:   Corinna Vinschen <vinschen@redhat.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>, netdev@vger.kernel.org
Subject: Re: [PATCH net-next] net: stmmac: publish actual MTU restriction
Message-ID: <ZCsaY5ZmXlc9/5lT@calimero.vinschen.de>
Mail-Followup-To: Jakub Kicinski <kuba@kernel.org>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>, netdev@vger.kernel.org
References: <20230331092344.268981-1-vinschen@redhat.com>
 <20230331215208.66d867ff@kernel.org>
 <ZCqYbMOEg9LvgcWZ@calimero.vinschen.de>
 <20230403093011.27545760@kernel.org>
 <ZCsYM4Q8fUWYyS6n@calimero.vinschen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <ZCsYM4Q8fUWYyS6n@calimero.vinschen.de>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.1
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Apr  3 20:17, Corinna Vinschen wrote:
> On Apr  3 09:30, Jakub Kicinski wrote:
> > On Mon, 3 Apr 2023 11:12:12 +0200 Corinna Vinschen wrote:
> > > > Are any users depending on the advertised values being exactly right?  
> > > 
> > > The max MTU is advertised per interface:
> > > 
> > > p -d link show dev enp0s29f1
> > > 2: enp0s29f1: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc mq state UP mode DEFAULT group default qlen 1000
> > >     link/ether [...] promiscuity 0 minmtu 46 maxmtu 9000 [...]
> > > 
> > > So the idea is surely that the user can check it and then set the MTU
> > > accordingly.  If the interface claims a max MTU of 9000, the expectation
> > > is that setting the MTU to this value just works, right?
> > > 
> > > So isn't it better if the interface only claims what it actually supports,
> > > i. .e, 
> > > 
> > >   # ip -d link show dev enp0s29f1
> > >   2: enp0s29f1: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc mq state UP mode DEFAULT group default qlen 1000
> > >       link/ether [...] promiscuity 0 minmtu 46 maxmtu 4096 [...]
> > > 
> > > ?
> > 
> > No doubt that it's better to be more precise.
> > 
> > The question is what about drivers which can't support full MTU with
> > certain features enabled. So far nobody has been updating the max MTU
> > dynamically, to my knowledge, so the max MTU value is the static max
> > under best conditions.
> 
> Yeah, I agree, but what this code does *is* to set the max MTU to the
> best possible value.
> 
> In all(*) drivers using the stmmac core, the max MTU is restricted by
> the size of a single TX queue per the code in stmmac_change_mtu().
> 
> You can change the number of queues within the limits of the HW
> dynamically, but the size of the queues is not configurable.

Wait.  The one thing which never changes after probe is the value
of tx_fifo_size.  It's the size of the buffer for all queues.  And if I
lower tx_queues_to_use, then the value of the queue size computed as

  tx_fifo_size / tx_queues_to_use

actually depends on the number of queues.

So I totally misinterpreted the code at this point.

Ouch.

I withdraw the patch.  Sorry for wasting your time.


Corinna

