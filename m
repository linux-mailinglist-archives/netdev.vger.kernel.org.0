Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F14384DC7CA
	for <lists+netdev@lfdr.de>; Thu, 17 Mar 2022 14:44:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234662AbiCQNp1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Mar 2022 09:45:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43610 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233573AbiCQNp0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Mar 2022 09:45:26 -0400
Received: from out4-smtp.messagingengine.com (out4-smtp.messagingengine.com [66.111.4.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 04B3EDD95E;
        Thu, 17 Mar 2022 06:44:09 -0700 (PDT)
Received: from compute2.internal (compute2.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id 41A805C00C2;
        Thu, 17 Mar 2022 09:44:09 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute2.internal (MEProxy); Thu, 17 Mar 2022 09:44:09 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-type:date:date:from:from
        :in-reply-to:in-reply-to:message-id:mime-version:references
        :reply-to:sender:subject:subject:to:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=cgLvCoZ+reMOUxcSz
        Tb0NcXr/MQseBQTzNT+xFvmncU=; b=hPKPfuHBJBEX+L4UQ2y043DZBPIh293rI
        doLU9LsgikXoL8Ib3ZEYa7L0VbDSUWgoXRHnUtNA0Qy4F27Yc3omfSGkvDItb/QN
        yK4/gBMjP9D0EFTMxsb0m1u/rowaRgVmRl1scbqYycJpn5AgYVIELxKQshjr6DHt
        BwXij39HpbqmZU4lxQBz4XWgDaQ3/lafgfFemTYAngvEIIJe6iS5NqnNPfehi+Xt
        JB/xy6oFqwEwd+zKcFSl9oM6W6pcCShLAmMcd9Wz1UabX155iPLgWP6AYJKGYQP5
        JU5d4z1vnokvLa/590Krvh8xlCYqP925JjCRXxNxkumgKWdihpecA==
X-ME-Sender: <xms:KDszYnvdAvEu4cVwdNHwn1ASuT1qwlU2-gVpiPrc2-hpdh6p0qVN6g>
    <xme:KDszYofrjlCHSv_gaboa9HwZWAvmu6Ss_yC3rTv26SgN-k7uB1oaeDw-VOMzIHxxg
    49I3EBoByvxUFQ>
X-ME-Received: <xmr:KDszYqzqSd5g1UUOe8q5anZ6MAHqEYDn6XVmnaBDXQzG177n5DWWaeN8YkThEMUQfTqY2nfAO7nIrjF2_rVBbGzZzzs>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvvddrudefgedgheehucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpefkughoucfu
    tghhihhmmhgvlhcuoehiughoshgthhesihguohhstghhrdhorhhgqeenucggtffrrghtth
    gvrhhnpedtffekkeefudffveegueejffejhfetgfeuuefgvedtieehudeuueekhfduheel
    teenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehiug
    hoshgthhesihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:KDszYmPfwtFcAL-L4CUmMSLMAvAlLM3frY0sM4vhnKWF6ODaTf7yMQ>
    <xmx:KDszYn_TM2qjdwpdr2XbT4iAqXl07aV1vvTD9ZqxibXr82zMzlBRYA>
    <xmx:KDszYmXDD2R33H3dsZ8iD_Mf5hwAPog2YY2QH9H-BprZ9sWGQEFeKQ>
    <xmx:KTszYkixf2kmsYBqmOQPODCE6ffMKZnIeRtjvKGGtqiF8Cp9yGXfSg>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 17 Mar 2022 09:44:08 -0400 (EDT)
Date:   Thu, 17 Mar 2022 15:44:03 +0200
From:   Ido Schimmel <idosch@idosch.org>
To:     Hans Schultz <schultz.hans@gmail.com>, razor@blackwall.org
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        Hans Schultz <schultz.hans+netdev@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Ivan Vecera <ivecera@redhat.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <razor@blackwall.org>,
        Shuah Khan <shuah@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Ido Schimmel <idosch@nvidia.com>, linux-kernel@vger.kernel.org,
        bridge@lists.linux-foundation.org, linux-kselftest@vger.kernel.org
Subject: Re: [PATCH v2 net-next 1/4] net: bridge: add fdb flag to extent
 locked port feature
Message-ID: <YjM7Iwx4MDdGEHFA@shredder>
References: <20220317093902.1305816-1-schultz.hans+netdev@gmail.com>
 <20220317093902.1305816-2-schultz.hans+netdev@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220317093902.1305816-2-schultz.hans+netdev@gmail.com>
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,
        SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 17, 2022 at 10:38:59AM +0100, Hans Schultz wrote:
> Add an intermediate state for clients behind a locked port to allow for
> possible opening of the port for said clients. This feature corresponds
> to the Mac-Auth and MAC Authentication Bypass (MAB) named features. The
> latter defined by Cisco.
> Only the kernel can set this FDB entry flag, while userspace can read
> the flag and remove it by deleting the FDB entry.

Can you explain where this flag is rejected by the kernel?

Nik, it seems the bridge ignores 'NDA_FLAGS_EXT', but I think that for
new flags we should do a better job and reject unsupported
configurations. WDYT?

The neighbour code will correctly reject the new flag due to
'NTF_EXT_MASK'.
