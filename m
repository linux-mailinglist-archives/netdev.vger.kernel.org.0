Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DED5F6CC906
	for <lists+netdev@lfdr.de>; Tue, 28 Mar 2023 19:19:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230160AbjC1RTL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Mar 2023 13:19:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59490 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229900AbjC1RTJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Mar 2023 13:19:09 -0400
Received: from out2-smtp.messagingengine.com (out2-smtp.messagingengine.com [66.111.4.26])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C7F0BB9E;
        Tue, 28 Mar 2023 10:19:07 -0700 (PDT)
Received: from compute2.internal (compute2.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id 2A7115C00E6;
        Tue, 28 Mar 2023 13:19:04 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute2.internal (MEProxy); Tue, 28 Mar 2023 13:19:04 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=animalcreek.com;
         h=cc:cc:content-type:content-type:date:date:from:from
        :in-reply-to:in-reply-to:message-id:mime-version:references
        :reply-to:sender:subject:subject:to:to; s=fm3; t=1680023944; x=
        1680110344; bh=Q/g40OzEJquv4huUDAm+c8e4yUOS6UKgNKno06kWqks=; b=Q
        3acXJ++9rZQrvryO4vdPMbqtWmWehs/ilG+pT0P78I44+4HAnpv9GqUvOt5vZUko
        laC+3usbYbZxGcxBeuLr6DvogIo3Q8Tf/WsRIrMpeH4+IkITFHH6KgTeO28ymlEI
        n/AvQ9k9Lk+TkedKWL0KsBbdlY8wlQw/7p7mt3glRxacCuPeFU7aIx3sshecDYHz
        ImOi6I4lz1XtEyYaL0hFZtCkl+AVmQ0MT6F4JEPGwn2WuXNSyeUUT2m537UiATvi
        L54MtHoGyT8RtW/OBf5qFhvtiCgZVHXe9oKe0PlwuNhxYh/7jYVRljF6sqNmqGzm
        vbZ8VXCPX2QcPXQdgHOHQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-type:content-type:date:date
        :feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
        :message-id:mime-version:references:reply-to:sender:subject
        :subject:to:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
        :x-sasl-enc; s=fm2; t=1680023944; x=1680110344; bh=Q/g40OzEJquv4
        huUDAm+c8e4yUOS6UKgNKno06kWqks=; b=LI1EuuQf9gzui4isgvA9FHAIk1tEc
        qFefyqTM8yXMgjtJPv0ee6XvNoM4CJ/q6HwtSlI7b/MIIuynKdzy1AxCkWmPm6dR
        C/kfl3qrQ/7YhMVNJHnXSC4bamKZFHBDVRw7NcwDGbc5Y+TAioduMCk+UM5A2MCi
        4RbTc2ugJBNs3aDEfbN4hYzhkFypAIM7OwZiNLfPsqTt4YH3PJc6zgwqKYSHtEYo
        bZj1mSy6XyNFPml1QqM8wwj8W4qMvV8iGO7Wj1+II0H/Z24rd+cq/wmETXR9Zy4S
        GtjNeJDNqi8cQU35g8xHWeILHU6YdWcf3PvUz210AIVGMSVfPQGbOxCFA==
X-ME-Sender: <xms:hyEjZFwL1L1JpmZujdIwKxGNFYLoDiVF3vHC3NOMUyU3113d5qJKpw>
    <xme:hyEjZFSaQ95MC3OGpqE60edSUc46CtQwsI9DgOXl_iM7KW1GxoRrn8BEpHee8lkHj
    KbzEYz_RHvTYCYDJg>
X-ME-Received: <xmr:hyEjZPWFQHQs2pkWQDsfqEChcqK1oZhsurpsax9y6blVFZaDUaAqYsJ9rIGrIva3ezxI48OQenwcueqods2h1y7iTarW538JE4BrHth8GA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvhedrvdehgedguddutdcutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
    enucfjughrpeffhffvvefukfhfgggtuggjohesthdtredttddtvdenucfhrhhomhepofgr
    rhhkucfirhgvvghruceomhhgrhgvvghrsegrnhhimhgrlhgtrhgvvghkrdgtohhmqeenuc
    ggtffrrghtthgvrhhnpeejjedufedvueelkefhfedvhfelvedtjeekieduhfejtedvuddv
    tdefffefkeffhfenucffohhmrghinheptddurdhorhhgpdhkvghrnhgvlhdrohhrghenuc
    evlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehmghhrvggv
    rhesrghnihhmrghltghrvggvkhdrtghomh
X-ME-Proxy: <xmx:hyEjZHiTkrCaLBCnkQMlBfBKoVCCiSH6fqhOwPiiewLJWaj35xjhlA>
    <xmx:hyEjZHBeyh362ZrkJdPxz08fOMGaaEHDjl-QR181JB3BiSkzjKRrxw>
    <xmx:hyEjZAJyKTA5J9H0Bperz3FtTfwZBCfqQn2oqA9AKzcLdR5QDv8buQ>
    <xmx:iCEjZJBh2FZXLvKXJYtViermF1citDUleDAR3n4y7KPWfz-XmYNw0g>
Feedback-ID: i9cc843c7:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 28 Mar 2023 13:19:03 -0400 (EDT)
Received: by blue.animalcreek.com (Postfix, from userid 1000)
        id 24A6A521076; Tue, 28 Mar 2023 10:19:02 -0700 (MST)
Date:   Tue, 28 Mar 2023 10:19:02 -0700
From:   Mark Greer <mgreer@animalcreek.com>
To:     Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Cc:     Lukas Bulwahn <lukas.bulwahn@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S . Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Bongsu Jeon <bongsu.jeon@samsung.com>,
        Mark Greer <mgreer@animalcreek.com>,
        kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] MAINTAINERS: remove the linux-nfc@lists.01.org list
Message-ID: <ZCMhho3Rc44TYPYz@animalcreek.com>
References: <20230324081613.32000-1-lukas.bulwahn@gmail.com>
 <eb05ac50-fda2-8324-1fd9-fda8579dfd8c@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <eb05ac50-fda2-8324-1fd9-fda8579dfd8c@linaro.org>
Organization: Animal Creek Technologies, Inc.
X-Spam-Status: No, score=-0.9 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H3,
        RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_PASS autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Mar 24, 2023 at 09:26:56AM +0100, Krzysztof Kozlowski wrote:
> On 24/03/2023 09:16, Lukas Bulwahn wrote:
> > Some MAINTAINERS sections mention to mail patches to the list
> > linux-nfc@lists.01.org. Probably due to changes on Intel's 01.org website
> > and servers, the list server lists.01.org/ml01.01.org is simply gone.
> > 
> > Considering emails recorded on lore.kernel.org, only a handful of emails
> > where sent to the linux-nfc@lists.01.org list, and they are usually also
> > sent to the netdev mailing list as well, where they are then picked up.
> > So, there is no big benefit in restoring the linux-nfc elsewhere.
> > 
> > Remove all occurrences of the linux-nfc@lists.01.org list in MAINTAINERS.
> > 
> > Suggested-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
> > Link: https://lore.kernel.org/all/CAKXUXMzggxQ43DUZZRkPMGdo5WkzgA=i14ySJUFw4kZfE5ZaZA@mail.gmail.com/
> > Signed-off-by: Lukas Bulwahn <lukas.bulwahn@gmail.com>
> 
> 
> Reviewed-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>

[Sorry, been traveling the last several days.]

Reviewed-by: Mark Greer <mgreer@animalcreek.com>
