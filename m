Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 374525F2BEC
	for <lists+netdev@lfdr.de>; Mon,  3 Oct 2022 10:36:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231637AbiJCIgb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Oct 2022 04:36:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48972 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231629AbiJCIgK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Oct 2022 04:36:10 -0400
Received: from wout3-smtp.messagingengine.com (wout3-smtp.messagingengine.com [64.147.123.19])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB93927153;
        Mon,  3 Oct 2022 01:08:58 -0700 (PDT)
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.west.internal (Postfix) with ESMTP id A14A232002F9;
        Mon,  3 Oct 2022 04:08:54 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Mon, 03 Oct 2022 04:08:57 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-type:date:date:feedback-id
        :feedback-id:from:from:in-reply-to:in-reply-to:message-id
        :mime-version:references:reply-to:sender:subject:subject:to:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm2; t=1664784534; x=1664870934; bh=aqoxBah/X4GiH9ZDPQqIa9iZT5FE
        /SnWRIkJ33v/MSg=; b=mH/yyc34ZlANnESS3QyuEXuqm3u4UBZ9kLJh2miT5S8x
        Bic1WTsWQFD4GURfAVcHFRCGEYmVOFe58keAeWKTjoCA0AAzBoWyG0HWDmkDXCPs
        cn+kdoaaWeflSeiDlX/F3yYwO2aWv0aGXw0JSlECZ/PRWLyHU7F7thAKNE4xXygr
        RYQtuZbbxOwxvlL4EKpzjMrxdVOnHjz0EcRH5eac/FW+oNcbDOLCKObCw84n6a+C
        HqtWNyJ47FGZJNTx6Ub0IvUER1VgQ10sphr/GXUeJZ9OmPsv2sks9i2Wq+ddjWQ5
        wXRDVJDVs0iAf/A5xh4d4lRp7k+/qta3R9Mh7z/IHQ==
X-ME-Sender: <xms:lJg6Y1vSeEYwvK6MIGOX3vh6XiFqj3M-q9pLmLaY-NBsbIcXmoi33w>
    <xme:lJg6Y-duSayW6YxnecQCxa0PUmCTPXMRxMCD0Wu6RiHqyxhUELQm1p4m82bLkkvVG
    Y9NT3RAWCqXLME>
X-ME-Received: <xmr:lJg6Y4waPNs1klgtzHnzPXIKCA7Q095K0QwAxT0JgYDzThEwOKCMCsvLrobH>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvfedrfeehlecutefuodetggdotefrodftvfcurf
    hrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecuuegr
    ihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenucfjug
    hrpeffhffvvefukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpefkughoucfutghh
    ihhmmhgvlhcuoehiughoshgthhesihguohhstghhrdhorhhgqeenucggtffrrghtthgvrh
    hnpeehhfdtjedviefffeduuddvffegteeiieeguefgudffvdfftdefheeijedthfejkeen
    ucffohhmrghinhepkhgvrhhnvghlrdhorhhgnecuvehluhhsthgvrhfuihiivgeptdenuc
    frrghrrghmpehmrghilhhfrhhomhepihguohhstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:lJg6Y8OBZH4KG04QGKa2G0HYHpxo1AqcM--zbltB46Z2reRKjgjkww>
    <xmx:lJg6Y182aBOMx1a2uigUQ6xA3FLX8OIAOTq-RCKmkWJvgJ9uNl5lBQ>
    <xmx:lJg6Y8Ucs-ZVRe1GcHNU_nU_ubxIyP3Vvf6G6wBjqV9CnD146Dy7ng>
    <xmx:lpg6Y7iZmXp3osCCNVTlcrfJ9ueD79PMTZ5efZb3UeT8l3KgdbzMLQ>
Feedback-ID: i494840e7:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 3 Oct 2022 04:08:51 -0400 (EDT)
Date:   Mon, 3 Oct 2022 11:08:48 +0300
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@kapio-technology.com
Cc:     Ido Schimmel <idosch@nvidia.com>, davem@davemloft.net,
        kuba@kernel.org, netdev@vger.kernel.org,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Hauke Mehrtens <hauke@hauke-m.de>,
        Woojung Huh <woojung.huh@microchip.com>,
        UNGLinuxDriver@microchip.com, Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        DENG Qingfang <dqfext@gmail.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Ivan Vecera <ivecera@redhat.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <razor@blackwall.org>,
        Shuah Khan <shuah@kernel.org>,
        Russell King <linux@armlinux.org.uk>,
        Christian Marangi <ansuelsmth@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Yuwei Wang <wangyuweihx@gmail.com>,
        Petr Machata <petrm@nvidia.com>,
        Florent Fourcot <florent.fourcot@wifirst.fr>,
        Hans Schultz <schultz.hans@gmail.com>,
        Joachim Wiberg <troglobit@gmail.com>,
        Amit Cohen <amcohen@nvidia.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org,
        bridge@lists.linux-foundation.org, linux-kselftest@vger.kernel.org
Subject: Re: [PATCH iproute2-next 1/2] bridge: link: enable MacAuth/MAB
 feature
Message-ID: <YzqYkOsTHNj8Y9da@shredder>
References: <20220929152137.167626-1-netdev@kapio-technology.com>
 <YzhV0hU9v7oQ+g+K@shredder>
 <29ab01c9b8e51a57fb83e4af6fa1193f@kapio-technology.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <29ab01c9b8e51a57fb83e4af6fa1193f@kapio-technology.com>
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Oct 02, 2022 at 05:20:31PM +0200, netdev@kapio-technology.com wrote:
> On 2022-10-01 16:59, Ido Schimmel wrote:
> > 
> > IIRC, in the past David asked to either not send the uAPI files or send
> > them as a first patch which he then uses as a hint to sync the files
> > himself.
> > 
> 
> Does that imply that I make a patch in the beginning for the include/uapi
> changes wrt the Locked flag and another in the same manner for the
> Blackhole, or just one patch for both of them as the very first patch?

One patch for both as the very first patch. Example:

https://lore.kernel.org/netdev/cover.1615985531.git.petrm@nvidia.com/
https://lore.kernel.org/netdev/ad9b63d5c76d9ef045dfed6dc9b5ab946e62e450.1615985531.git.petrm@nvidia.com/

The patch is obviously not needed if the uAPI files were already updated
by David.
