Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A8C396A3D85
	for <lists+netdev@lfdr.de>; Mon, 27 Feb 2023 09:55:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230296AbjB0IzD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Feb 2023 03:55:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43508 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229923AbjB0Iyf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Feb 2023 03:54:35 -0500
Received: from out3-smtp.messagingengine.com (out3-smtp.messagingengine.com [66.111.4.27])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 77117244BF;
        Mon, 27 Feb 2023 00:47:00 -0800 (PST)
Received: from compute6.internal (compute6.nyi.internal [10.202.2.47])
        by mailout.nyi.internal (Postfix) with ESMTP id 5F6835C0097;
        Mon, 27 Feb 2023 03:37:31 -0500 (EST)
Received: from imap51 ([10.202.2.101])
  by compute6.internal (MEProxy); Mon, 27 Feb 2023 03:37:31 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arndb.de; h=cc
        :cc:content-type:date:date:from:from:in-reply-to:in-reply-to
        :message-id:mime-version:references:reply-to:sender:subject
        :subject:to:to; s=fm3; t=1677487051; x=1677573451; bh=g9r9vd6/Le
        bwP6b/3KMuSXY3MGtskFDgCJPE8mZ9wWQ=; b=cYd/THi1GEsGQbZSXqBAUX+fVa
        o5kNbsi0otx8q8jrkPuCMH67QiXIH936Suj0L3OMfYKHWH3ajSNXYcQbIbIhI2WP
        diReo5S97blbQYXu2jZzfczx6GbWJgQxMbBqcIofN4Ues19x2sMl88nVG+IhlTTo
        8fNz4jwFGPoL771mQUhaONN6UUVkg8EJmeKBVxO75/ha5fkpL/sic5QkQJtQisSB
        epw3pRz6zv/0qS1QuwvC3bRTKWr+vJYj25soKew7Ke4EWJRlxnvHZPNO4jZSIklX
        LuXd7AhVkw9BW8+eHztR2VJ9qg/V0rdZ3B81Ojb5VCxkgl6QkjSXdHoQd83Q==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-type:date:date:feedback-id
        :feedback-id:from:from:in-reply-to:in-reply-to:message-id
        :mime-version:references:reply-to:sender:subject:subject:to:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm1; t=1677487051; x=1677573451; bh=g9r9vd6/LebwP6b/3KMuSXY3MGts
        kFDgCJPE8mZ9wWQ=; b=YEnqEQkyyeo8rcRi8TQsF044IIoNeJocJiy4T3vi/Nlr
        sf9pOPxmN4FFBGzc5vr66r6Lis4a5Rv4yz47kPguWBpgPzuoGXJDjUr9+tcAERdd
        cEBdmG3oWS+5Ui3nD1ykNu9Un1+P1/gDTUAnpE98G4nai6fDebbveRKgUpjWRnRh
        ZQgCVQUa2Xfbpny0XoKmA8SCstSbJIkCu4nlWibyUUWMolMBViNBxCZ8WZYpNCjA
        FxoYKZa+EHF8oo7Lmlo+twcMz/INp57ugaSH2/FBr2kDYeUU6diK9r+zTCR7bIXw
        dOBCofYupUpICvm6G0RLCuOjYg+2e0xl2IYzsnWjqA==
X-ME-Sender: <xms:ymv8YygRUKmJmReynlRKFbZkfZFvxFuaq3A3jysS7bTjHLCXSz1lww>
    <xme:ymv8YzBaV8885jc6fubbGWv5GoWydSbPXfHQA9B2gsdnxU0K_zlqCYFihWUxVfa3A
    pOcFNEpkOl_LE4RJbI>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvhedrudekledguddukecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
    enucfjughrpefofgggkfgjfhffhffvvefutgesthdtredtreertdenucfhrhhomhepfdet
    rhhnugcuuegvrhhgmhgrnhhnfdcuoegrrhhnugesrghrnhgusgdruggvqeenucggtffrrg
    htthgvrhhnpeffheeugeetiefhgeethfejgfdtuefggeejleehjeeutefhfeeggefhkedt
    keetffenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpe
    grrhhnugesrghrnhgusgdruggv
X-ME-Proxy: <xmx:ymv8Y6He2H7lZCXXRAS9FgTenJU2GpdLuhs6LdLYbe7eex9i_CHuqg>
    <xmx:ymv8Y7TcqvkBMVWseaGn0MyJKOkCwYZ6eaaKkzLkCb-h427OnLO-0Q>
    <xmx:ymv8Y_x0PZqJylU36Vj2YcvYt6fJtNRZRjpWwDtwXMOKk3mjgPTBpg>
    <xmx:y2v8Y2zQCyRtpeICrVwDTnJEMiRYLIM527AXjAzy-gQtP0M5llv5nA>
Feedback-ID: i56a14606:Fastmail
Received: by mailuser.nyi.internal (Postfix, from userid 501)
        id D2D36B60086; Mon, 27 Feb 2023 03:37:30 -0500 (EST)
X-Mailer: MessagingEngine.com Webmail Interface
User-Agent: Cyrus-JMAP/3.9.0-alpha0-172-g9a2dae1853-fm-20230213.001-g9a2dae18
Mime-Version: 1.0
Message-Id: <d888d651-0ea6-4d0e-9e34-c27acbc7388a@app.fastmail.com>
In-Reply-To: <04374e51-c7e5-b1d9-d617-d1abf47ec44b@redhat.com>
References: <20230219150321.2683358-1-trix@redhat.com>
 <Y/JnZwUEXycgp8QJ@corigine.com> <Y/LKpsjteUAXVIb0@lunn.ch>
 <Y/MXNWKrrI3aRju+@corigine.com> <Y/QskwGx+A1jACB2@lunn.ch>
 <Y/TvS+D76/N0WyWc@corigine.com>
 <04374e51-c7e5-b1d9-d617-d1abf47ec44b@redhat.com>
Date:   Mon, 27 Feb 2023 09:37:07 +0100
From:   "Arnd Bergmann" <arnd@arndb.de>
To:     "Tom Rix" <trix@redhat.com>,
        "Simon Horman" <simon.horman@corigine.com>,
        "Andrew Lunn" <andrew@lunn.ch>
Cc:     "David S . Miller" <davem@davemloft.net>,
        "Eric Dumazet" <edumazet@google.com>,
        "Jakub Kicinski" <kuba@kernel.org>,
        "Paolo Abeni" <pabeni@redhat.com>, steen.hegelund@microchip.com,
        Netdev <netdev@vger.kernel.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: lan743x: LAN743X selects FIXED_PHY to resolve a link error
Content-Type: text/plain
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Feb 26, 2023, at 16:15, Tom Rix wrote:
> On 2/21/23 8:20 AM, Simon Horman wrote:
>> On Tue, Feb 21, 2023 at 03:29:39AM +0100, Andrew Lunn wrote:
>>> On Mon, Feb 20, 2023 at 07:46:13AM +0100, Simon Horman wrote:
>>>>
>>>> LAN743X=y and FIXED_PHY=m does indeed produce the problem that Tom
>>>> describes. And his patch does appear to resolve the problem.
>>> O.K. So the commit message needs updating to describe the actual
>>> problem.
>> Yes, that would be a good improvement.
>>
>> Perhaps a fixes tag too?
>>
>>>> Unfortunately your proposed solution seems to run foul of a complex
>>>> dependency situation.
>>> I was never any good at Kconfig. Arnd is the expert at solving
>>> problems like this.
>>>
>>> You want either everything built in, or FIXED_PHY built in and LAN743X
>>> modular, or both modular.
>> I _think_ the patch, which uses select FIXED_PHY for LAN743X,
>> achieves that.
>>
>> I CCed Arnd in case he has any input. Though I think I read
>> in an recent email from him that he is out most of this week.

FWIW, the original patch looks good to me,

Reviewed-by: Arnd Bergmann <arnd@arndb.de>

I'm not sure if the #else path in include/linux/phy_fixed.h
is actually helpful, as it does not avoid a link failure but
just makes it less common. Maybe we should just drop that
from the header and require all users of fixed_phy to
'select' that symbol even when they are built-in?

       Arnd
