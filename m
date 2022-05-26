Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 85F8C535067
	for <lists+netdev@lfdr.de>; Thu, 26 May 2022 16:13:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347611AbiEZONb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 May 2022 10:13:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51308 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231806AbiEZONa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 May 2022 10:13:30 -0400
Received: from wout3-smtp.messagingengine.com (wout3-smtp.messagingengine.com [64.147.123.19])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB393C1ED5;
        Thu, 26 May 2022 07:13:29 -0700 (PDT)
Received: from compute5.internal (compute5.nyi.internal [10.202.2.45])
        by mailout.west.internal (Postfix) with ESMTP id 2BB18320095B;
        Thu, 26 May 2022 10:13:27 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute5.internal (MEProxy); Thu, 26 May 2022 10:13:29 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-type:date:date:feedback-id
        :feedback-id:from:from:in-reply-to:in-reply-to:message-id
        :mime-version:references:reply-to:sender:subject:subject:to:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm1; t=1653574406; x=1653660806; bh=vnwACNqhZoOoXwIiQWU2wL/gnnhq
        0onDp8LHcdhWTNg=; b=OuVZF/6dfxHAylAnDM80GjsVlw5t/W0/v3Ac/hSkZlW3
        6budAzqVou/8FMEF8bHQ3QdbUIZLRaBN6+Os28Hbm5QJzyZTQWOK6NHeuvozpG4X
        Dw6IKF742xWjTvOZGmrHJNkcQ4/nE8in2JOlJP4BZYDtYTde62kx6igeR8uCeLaw
        lqwvqMNvwbUWySqZ0dgh0eUEAl8kttTvhPlDv8Lms6Jmn8JNq/2E0/cIkjolRT16
        dzsbcLrSWh204ftIGEj/i3JiG2LTn1gJ60yBTGlDpbTwsAmMXpxVCzBa1AOlCDl0
        NrjltsJu1VRuvFQMfz7Z7AaD39FdaMLbY5wxNbs+Rw==
X-ME-Sender: <xms:BYuPYrqRIAexR2_L_gBVXKr6byVNV7aHujxd6DXwJKNyvNrsAgSi0w>
    <xme:BYuPYlpEOTeXblN17XiBCOveogzmYPbW-fTtGz_0fc6JKXGSF0H4rLRc1DpCshPCx
    2TuFVL6uR9cz9A>
X-ME-Received: <xmr:BYuPYoNOI_2OxjK1Whx8-npY4qsyGCZ8o9p--VASWEuvNU6rBXIS3W1NFxC2z0wWk5jz3tzdDLz4KAy3tq9QuGfv2cIZwQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvfedrjeejgdejvdcutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpeffhffvvefukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpefkughoucfu
    tghhihhmmhgvlhcuoehiughoshgthhesihguohhstghhrdhorhhgqeenucggtffrrghtth
    gvrhhnpedvudefveekheeugeeftddvveefgfduieefudeifefgleekheegleegjeejgeeg
    hfenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehiug
    hoshgthhesihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:BYuPYu6LOcBOGbfpSYXrF7jWxzX8QW3KrbfG2IwsVcOVQkDRuJ4PGA>
    <xmx:BYuPYq4s5Cu4DqXxPsSLmODY0tulu-Vdn__mr-Tk5LpSVy88CVWrRA>
    <xmx:BYuPYmj2mUW2TQGb_O4uvddrVIX2MtiVnfqzRIUWdobW5Hd-IkGDYA>
    <xmx:BouPYnwL6CZ3no6COUQ1FGwlYR2SWZ-PYihJspZ35uq2Zymi6UllSw>
Feedback-ID: i494840e7:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 26 May 2022 10:13:24 -0400 (EDT)
Date:   Thu, 26 May 2022 17:13:22 +0300
From:   Ido Schimmel <idosch@idosch.org>
To:     Hans Schultz <schultz.hans@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        Hans Schultz <schultz.hans+netdev@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, Jiri Pirko <jiri@resnulli.us>,
        Ivan Vecera <ivecera@redhat.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <razor@blackwall.org>,
        Shuah Khan <shuah@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Ido Schimmel <idosch@nvidia.com>, linux-kernel@vger.kernel.org,
        bridge@lists.linux-foundation.org, linux-kselftest@vger.kernel.org
Subject: Re: [PATCH V3 net-next 1/4] net: bridge: add fdb flag to extent
 locked port feature
Message-ID: <Yo+LAj1vnjq0p36q@shredder>
References: <20220524152144.40527-1-schultz.hans+netdev@gmail.com>
 <20220524152144.40527-2-schultz.hans+netdev@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220524152144.40527-2-schultz.hans+netdev@gmail.com>
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, May 24, 2022 at 05:21:41PM +0200, Hans Schultz wrote:
> Add an intermediate state for clients behind a locked port to allow for
> possible opening of the port for said clients. This feature corresponds
> to the Mac-Auth and MAC Authentication Bypass (MAB) named features. The
> latter defined by Cisco.
> Locked FDB entries will be limited in number, so as to prevent DOS
> attacks by spamming the port with random entries. The limit will be
> a per port limit as it is a port based feature and that the port flushes
> all FDB entries on link down.

Why locked FDB entries need a special treatment compared to regular
entries? A port that has learning enabled can be spammed with random
source MACs just as well.

The authorization daemon that is monitoring FDB notifications can have a
policy to shut down a port if the rate / number of locked entries is
above a given threshold.

I don't think this kind of policy belongs in the kernel. If it resides
in user space, then the threshold can be adjusted. Currently it's hard
coded to 64 and I don't see how user space can change or monitor it.
