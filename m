Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CFF814DC96E
	for <lists+netdev@lfdr.de>; Thu, 17 Mar 2022 15:59:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234722AbiCQPAw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Mar 2022 11:00:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54470 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233311AbiCQPAv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Mar 2022 11:00:51 -0400
Received: from out4-smtp.messagingengine.com (out4-smtp.messagingengine.com [66.111.4.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD780E6175;
        Thu, 17 Mar 2022 07:59:34 -0700 (PDT)
Received: from compute5.internal (compute5.nyi.internal [10.202.2.45])
        by mailout.nyi.internal (Postfix) with ESMTP id 4E9F25C0151;
        Thu, 17 Mar 2022 10:59:34 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute5.internal (MEProxy); Thu, 17 Mar 2022 10:59:34 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-type:date:date:from:from
        :in-reply-to:in-reply-to:message-id:mime-version:references
        :reply-to:sender:subject:subject:to:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=eq8Q3Wf36/Ac2wsVD
        zrJSDqU/+NPSnDNknTC94Rn3ys=; b=Z+u61UZF2MpFvWSlO9RK9pImFvyFmJi45
        jy6JXcXuXSm3frv6E3GS/SPdGVUx5jdEEFQ+QqdpGZu7HAE6uNYkS9LgMYaQn6Zk
        cRRvPrhYr46PgsDMZ0jQskLD2kuL7U6XppwJNiCHbvB3SxYso8QLkVtRg5Km+CWJ
        +1xP7shOd/FYQ7MTQdkVOZ4nJ5EuGNWy65PAxIBkgpphPWlQKfGyF+RCr0BJocYu
        qpUyh1nzzUhRZPMb7oJAfWWKpsc/EEoUvnPYjgH55dqG/yctgtg5MnjHJHJPuQio
        FPPlokROP7Nb3zWA9Rdjw0C02G7ih2Fp8snt5Brdtr6g8AwFYLxVQ==
X-ME-Sender: <xms:1kwzYvKi6OJoZcDf1ohLpIaz-iALK7M0VXI5dHQp6UvMUhMWETnLwQ>
    <xme:1kwzYjLpgPqNWh6A-lf_RnHAD2c2_4DVSLvJdss0XCoV5bNdpfO4R7MSGJgP44CWc
    xiRAI9SqQoGudc>
X-ME-Received: <xmr:1kwzYnuO3seh2DcMdygVIma-0AZGl6IWGE5MSluGDDx9zVf5JK4XQNL5l6IbZmuGDAwpFQmpTGW6B1qpnT0rdg36Ccc>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvvddrudefgedgieelucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpefkughoucfu
    tghhihhmmhgvlhcuoehiughoshgthhesihguohhstghhrdhorhhgqeenucggtffrrghtth
    gvrhhnpedtffekkeefudffveegueejffejhfetgfeuuefgvedtieehudeuueekhfduheel
    teenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehiug
    hoshgthhesihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:1kwzYoaYDFZUxE0dWyf7_xLUwQ47t76Pr9ikIlA6iCY_xUlUXl45Ww>
    <xmx:1kwzYmYZMQD9FLICF9kfhzXBzZ6BjNCZ7rAwB-MnKldKySbdAHT70A>
    <xmx:1kwzYsAQqJDrpGJXu9P0bYF92lmyFg0yiQvgoCBc85odvVXAettUhg>
    <xmx:1kwzYrJ_GBAM-ZcZmgscS90xvQEe77iMkzH6g9-n1lHskbTXTyUFSg>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 17 Mar 2022 10:59:33 -0400 (EDT)
Date:   Thu, 17 Mar 2022 16:59:30 +0200
From:   Ido Schimmel <idosch@idosch.org>
To:     Hans Schultz <schultz.hans@gmail.com>
Cc:     razor@blackwall.org, davem@davemloft.net, kuba@kernel.org,
        netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Ivan Vecera <ivecera@redhat.com>,
        Roopa Prabhu <roopa@nvidia.com>, Shuah Khan <shuah@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Ido Schimmel <idosch@nvidia.com>, linux-kernel@vger.kernel.org,
        bridge@lists.linux-foundation.org, linux-kselftest@vger.kernel.org
Subject: Re: [PATCH v2 net-next 1/4] net: bridge: add fdb flag to extent
 locked port feature
Message-ID: <YjNM0ugG2dcZSD2r@shredder>
References: <20220317093902.1305816-1-schultz.hans+netdev@gmail.com>
 <20220317093902.1305816-2-schultz.hans+netdev@gmail.com>
 <YjM7Iwx4MDdGEHFA@shredder>
 <86ilsciqfh.fsf@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <86ilsciqfh.fsf@gmail.com>
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,
        SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 17, 2022 at 03:50:26PM +0100, Hans Schultz wrote:
> On tor, mar 17, 2022 at 15:44, Ido Schimmel <idosch@idosch.org> wrote:
> > On Thu, Mar 17, 2022 at 10:38:59AM +0100, Hans Schultz wrote:
> >> Add an intermediate state for clients behind a locked port to allow for
> >> possible opening of the port for said clients. This feature corresponds
> >> to the Mac-Auth and MAC Authentication Bypass (MAB) named features. The
> >> latter defined by Cisco.
> >> Only the kernel can set this FDB entry flag, while userspace can read
> >> the flag and remove it by deleting the FDB entry.
> >
> > Can you explain where this flag is rejected by the kernel?
> >
> Is it an effort to set the flag from iproute2 on adding a fdb entry?

I'm not sure what you are asking, but even if iproute2 can't set the
flag it doesn't mean the kernel shouldn't reject it

> 
> > Nik, it seems the bridge ignores 'NDA_FLAGS_EXT', but I think that for
> > new flags we should do a better job and reject unsupported
> > configurations. WDYT?
> >
> > The neighbour code will correctly reject the new flag due to
> > 'NTF_EXT_MASK'.
