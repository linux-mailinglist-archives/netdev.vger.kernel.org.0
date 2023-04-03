Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0992D6D3FC7
	for <lists+netdev@lfdr.de>; Mon,  3 Apr 2023 11:13:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231683AbjDCJNI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Apr 2023 05:13:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60534 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231310AbjDCJNI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Apr 2023 05:13:08 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C00B7687
        for <netdev@vger.kernel.org>; Mon,  3 Apr 2023 02:12:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1680513140;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=TKYwrzpn2DjSpsf9pdJe2f5o+6lx3z/x5moUB122YRc=;
        b=bYT3/EUxiz7Ibx3Vo6S3RMFJsgbHE5FD8u478lS2AVoJLEtXbVd9kEOFZ8sE/VV7p/uP07
        mCJy8Kxj6TyyaP/mbJ72l/ce7CQMWEQs8DAWOxH6Wxud49CwpWFj7oSbe+RGjVOScDT5cp
        O7zRmY8UnBEfWtDZsrb0TVYx0HMQ4Qw=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-660-fdA_0It1NxugImgZFqHU8g-1; Mon, 03 Apr 2023 05:12:14 -0400
X-MC-Unique: fdA_0It1NxugImgZFqHU8g-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id C2565811E7C;
        Mon,  3 Apr 2023 09:12:13 +0000 (UTC)
Received: from calimero.vinschen.de (unknown [10.39.192.15])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 81814492C13;
        Mon,  3 Apr 2023 09:12:13 +0000 (UTC)
Received: by calimero.vinschen.de (Postfix, from userid 500)
        id 0F7BCA80CED; Mon,  3 Apr 2023 11:12:12 +0200 (CEST)
Date:   Mon, 3 Apr 2023 11:12:12 +0200
From:   Corinna Vinschen <vinschen@redhat.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>, netdev@vger.kernel.org
Subject: Re: [PATCH net-next] net: stmmac: publish actual MTU restriction
Message-ID: <ZCqYbMOEg9LvgcWZ@calimero.vinschen.de>
Mail-Followup-To: Jakub Kicinski <kuba@kernel.org>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>, netdev@vger.kernel.org
References: <20230331092344.268981-1-vinschen@redhat.com>
 <20230331215208.66d867ff@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20230331215208.66d867ff@kernel.org>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.9
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mar 31 21:52, Jakub Kicinski wrote:
> On Fri, 31 Mar 2023 11:23:44 +0200 Corinna Vinschen wrote:
> > Fixes: 2618abb73c895 ("stmmac: Fix kernel crashes for jumbo frames")
> > Fixes: a2cd64f30140c ("net: stmmac: fix maxmtu assignment to be within valid range")
> > Fixes: ebecb860ed228 ("net: stmmac: pci: Add HAPS support using GMAC5")
> > Fixes: 58da0cfa6cf12 ("net: stmmac: create dwmac-intel.c to contain all Intel platform")
> > Fixes: 30bba69d7db40 ("stmmac: pci: Add dwmac support for Loongson")
> 
> I'm not sure if we need fixes tags for this.

I can remove those in v2.

> Are any users depending on the advertised values being exactly right?

The max MTU is advertised per interface:

p -d link show dev enp0s29f1
2: enp0s29f1: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc mq state UP mode DEFAULT group default qlen 1000
    link/ether [...] promiscuity 0 minmtu 46 maxmtu 9000 [...]

So the idea is surely that the user can check it and then set the MTU
accordingly.  If the interface claims a max MTU of 9000, the expectation
is that setting the MTU to this value just works, right?

So isn't it better if the interface only claims what it actually supports,
i. .e, 

  # ip -d link show dev enp0s29f1
  2: enp0s29f1: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc mq state UP mode DEFAULT group default qlen 1000
      link/ether [...] promiscuity 0 minmtu 46 maxmtu 4096 [...]

?

> > +	/* stmmac_change_mtu restricts MTU to queue size.
> > +	 * Set maxmtu accordingly, if it hasn't been set from DT.
> > +	 */
> > +	if (priv->plat->maxmtu == 0) {
> > +		priv->plat->maxmtu = priv->plat->tx_fifo_size ?:
> > +				     priv->dma_cap.tx_fifo_size;
> > +		priv->plat->maxmtu /= priv->plat->tx_queues_to_use;
> 
> tx_queues_to_use may change due to reconfiguration, no?
> What will happen then?

Nothing.  tx_fifo_size is tx_queues_to_use multiplied by the size of the
queue.  All the above code does is to compute the size of the queues,
which is a fixed value limiting the size of the MTU.  It's the same
check the stmmac_change_mtu() function performs to allow or deny the MTU
change, basically:

  txfifosz = priv->plat->tx_fifo_size;
  if (txfifosz == 0)
    txfifosz = priv->dma_cap.tx_fifo_size;
  txfifosz /= priv->plat->tx_queues_to_use;
  if (txfifosz < new_mtu)
    return -EINVAL;


Corinna

