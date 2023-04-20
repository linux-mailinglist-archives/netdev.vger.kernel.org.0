Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E2EF56E9882
	for <lists+netdev@lfdr.de>; Thu, 20 Apr 2023 17:40:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231728AbjDTPkc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Apr 2023 11:40:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39592 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230342AbjDTPka (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Apr 2023 11:40:30 -0400
Received: from out3-smtp.messagingengine.com (out3-smtp.messagingengine.com [66.111.4.27])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C97192117;
        Thu, 20 Apr 2023 08:40:29 -0700 (PDT)
Received: from compute6.internal (compute6.nyi.internal [10.202.2.47])
        by mailout.nyi.internal (Postfix) with ESMTP id 4629F5C00D3;
        Thu, 20 Apr 2023 11:40:27 -0400 (EDT)
Received: from imap51 ([10.202.2.101])
  by compute6.internal (MEProxy); Thu, 20 Apr 2023 11:40:27 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arndb.de; h=cc
        :cc:content-type:content-type:date:date:from:from:in-reply-to
        :in-reply-to:message-id:mime-version:references:reply-to:sender
        :subject:subject:to:to; s=fm2; t=1682005227; x=1682091627; bh=Al
        qUOfOa2kHr8oGUuOGFh2LpW6TOvsZBDKrnI2S7ANc=; b=KkG7wLMbnLTcOvv++O
        4+CR2me9Eu8v2wfJUPP+1bru53dYLbRbtlcFS16z8V1D4y8z3jRREt3VRUk4HGzp
        MJE7IVsJJGGhTpyskgVRab2Ux0dkRZCMxVxIbZCJ+TogQhZKp8kXFkZIRRbq/58I
        I/vSXIs+ENkzjNQK8K2+Dj/Ji1TNVwqpcydGkiITWeBbWfOQqD2pHYuocZRF+0lG
        CeJZeyuV31DxYTAokjeXfGE7bu/dusnorIgZuSsctEXTETvhTYQVTp3xhqNbF80g
        xATk/d9J37pOuSCD37RS21tUt/txAjJia2MGAs219wP6MeznEBqhcnvQtO7QPtQt
        rTiQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-type:content-type:date:date
        :feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
        :message-id:mime-version:references:reply-to:sender:subject
        :subject:to:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
        :x-sasl-enc; s=fm3; t=1682005227; x=1682091627; bh=AlqUOfOa2kHr8
        oGUuOGFh2LpW6TOvsZBDKrnI2S7ANc=; b=NXXxKdYpel3XATPdMjcy2LOplqU5/
        sZHpAx0lc1joZfRni6Q7XUmYH6Vagz6LCYUwI7k7cHiAzJOQn5pfa8yN8X2N62TE
        N7s7nOpDlB51fPCK5xZMZh5vwO8wcLCndwl9kBG9lClK4vkN2IiT1iHaMWdPDzH7
        +77UL4QDYn10CvGp6bAzjRUT8xrePhKEQrjDWWrdTPoJ1Rpzy0trhvc8aSuTnl3Y
        /ViHxA6ai6Z2rxxdkhRYLLvKsZ33UinIcC8k0c0AotgT0py4gI0mJsOO7veNtOxy
        5OMqiCbeR/+WRuoKPATikUFaBHONs1uT1aU0z+RD0D3UgIyX4lUqo3tHQ==
X-ME-Sender: <xms:6lxBZOguJGkVspDGQGA9QHVFRkxt4TN0azq9Q7QFrya4E3NAXtftVA>
    <xme:6lxBZPCEYvzYrqqXSXypO8PV4zyV8V5SxJvNCzRKzyBf9XuuZKokrpR7CgM6Q4LBb
    hmwLb1CeFjBS1EnMRg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvhedrfedtvddgkeelucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepofgfggfkjghffffhvfevufgtsehttdertderredtnecuhfhrohhmpedftehr
    nhguuceuvghrghhmrghnnhdfuceorghrnhgusegrrhhnuggsrdguvgeqnecuggftrfgrth
    htvghrnhepvefhffeltdegheeffffhtdegvdehjedtgfekueevgfduffettedtkeekueef
    hedunecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucevlhhushhtvghrufhiiigvpe
    dtnecurfgrrhgrmhepmhgrihhlfhhrohhmpegrrhhnugesrghrnhgusgdruggv
X-ME-Proxy: <xmx:6lxBZGGSAp5YfCqfIBVUEnNEl2nDn-QwR4mtl4XdQaDhWgNDxMN4lQ>
    <xmx:6lxBZHTl6uq07VtdGUt1AGK1xNAsd0yk7k2KkokzKZ2p_PgRJGaIHg>
    <xmx:6lxBZLyuXWvldqMV3-LxhfztxS46KyJKO9iTcj7Uf4DKslfaQM7Iiw>
    <xmx:61xBZCwrNwknFVp09McHL9-TW3RMMCtmTj_XZ0PmAJhVrEPCY4AKJg>
Feedback-ID: i56a14606:Fastmail
Received: by mailuser.nyi.internal (Postfix, from userid 501)
        id CC6F5B60089; Thu, 20 Apr 2023 11:40:26 -0400 (EDT)
X-Mailer: MessagingEngine.com Webmail Interface
User-Agent: Cyrus-JMAP/3.9.0-alpha0-372-g43825cb665-fm-20230411.003-g43825cb6
Mime-Version: 1.0
Message-Id: <73674ffd-3231-4ca8-af65-3ec621de5072@app.fastmail.com>
In-Reply-To: <2e7f5511-08e2-4ee0-ab3f-481ba6724824@lunn.ch>
References: <202303241935.xRMa6mc6-lkp@intel.com>
 <f16fb810-f70d-40ac-8e9d-2ada008c446d@app.fastmail.com>
 <758fff85-aefc-4e0a-97b1-fe7179fafac6@lunn.ch>
 <91c716f0-bf7f-4fdf-8cb7-83f1bdc0cbd4@app.fastmail.com>
 <2e7f5511-08e2-4ee0-ab3f-481ba6724824@lunn.ch>
Date:   Thu, 20 Apr 2023 17:39:56 +0200
From:   "Arnd Bergmann" <arnd@arndb.de>
To:     "Andrew Lunn" <andrew@lunn.ch>
Cc:     "kernel test robot" <lkp@intel.com>, llvm@lists.linux.dev,
        oe-kbuild-all@lists.linux.dev,
        "Christian Marangi" <ansuelsmth@gmail.com>,
        Netdev <netdev@vger.kernel.org>, linux-kernel@vger.kernel.org,
        "Florian Fainelli" <f.fainelli@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        "Jakub Kicinski" <kuba@kernel.org>
Subject: Re: [lunn:v6.3-rc2-net-next-phy-leds 5/15] ld.lld: error: undefined symbol:
 devm_mdiobus_alloc_size
Content-Type: text/plain
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Apr 20, 2023, at 17:26, Andrew Lunn wrote:
>> I think the best way is to drop your MDIO_DEVRES patch and instead
>> apply mine (or some variation of that) from
>> 
>> https://lore.kernel.org/lkml/20230420084624.3005701-1-arnd@kernel.org/
>> 
>> Once any missing or recursive dependencies are handled, the devres
>> problem should be fixed as well. I have completed around 150
>> randconfig builds with that patch and have not seen any further
>> problems.
>
> Is this on top of my patch? Or does it require mine is reverted?  I
> can send a revert if it is needed.

The two are independent. I think your patch does nothing once
mine is applied, since the indirect 'select MDIO_DEVRES' will
work again. Reverting it might help avoid some confusion though.

     Arnd
