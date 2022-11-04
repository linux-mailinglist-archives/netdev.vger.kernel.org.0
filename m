Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8000C619E0B
	for <lists+netdev@lfdr.de>; Fri,  4 Nov 2022 18:04:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231359AbiKDREP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Nov 2022 13:04:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51904 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231309AbiKDREN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Nov 2022 13:04:13 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C5BF3317CA
        for <netdev@vger.kernel.org>; Fri,  4 Nov 2022 10:04:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7EB79B82EFA
        for <netdev@vger.kernel.org>; Fri,  4 Nov 2022 17:04:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A40B3C433D7;
        Fri,  4 Nov 2022 17:04:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1667581450;
        bh=02up0D8KxrG2mC+39uGRjUxfW9WYUdA/gqv2kDDTVZU=;
        h=In-Reply-To:References:Date:From:To:Cc:Subject:From;
        b=BUPv5aN5vyIvx3DJU39btf/Q6Ud/5RAknhdltYvX+hNVbd7s9Hw2MbNaUJPOJFkdu
         +vmy+l9+bFXexqllhxw2+pebVrFZiOrSvlzvYq3er0KLtx86cYRMUyE9LUGxrNKzOZ
         5Gm+z2GDMoiTcmEGh61x/tLu1BU/P82w9VTg8tUAWHKnSLiyeiXYxvD3AT3PeW3yq5
         LFR+8WhdA2SCl+MEP+OLIikUhyFM+MMnRv4bPqo8LGBFUQhufRRma8E7jPlySNZ55o
         WgIByYXfJI/htshalAGyZy7YgxhEQ3vKR5lyLH7GGF3qg3kLnaviXbE1w8ckurY/Vm
         zsvrRhAiXT8UA==
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailauth.nyi.internal (Postfix) with ESMTP id 5588627C0054;
        Fri,  4 Nov 2022 13:04:08 -0400 (EDT)
Received: from imap51 ([10.202.2.101])
  by compute3.internal (MEProxy); Fri, 04 Nov 2022 13:04:08 -0400
X-ME-Sender: <xms:B0ZlYzfXSO_Hfra0LDWAU8VPaWr3RHbTTJWbAn_FBV3PfdWWRur3nw>
    <xme:B0ZlY5MoCbSWZ902D1jAxpOCH6m7KVKjVlfbmEZyJCFr2xAR-7_45g5-tPflgDZo9
    exTfSYlKnbEL3_omVs>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvgedrvddugdelfecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpefofgggkfgjfhffhffvvefutgesthdtredtreertdenucfhrhhomhepfdetrhhn
    ugcuuegvrhhgmhgrnhhnfdcuoegrrhhnugeskhgvrhhnvghlrdhorhhgqeenucggtffrrg
    htthgvrhhnpedvveeigfetudegveeiledvgfevuedvgfetgeefieeijeejffeggeehudeg
    tdevheenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpe
    grrhhnugdomhgvshhmthhprghuthhhphgvrhhsohhnrghlihhthidquddvkeehudejtddv
    gedqvdekjedttddvieegqdgrrhhnugeppehkvghrnhgvlhdrohhrghesrghrnhgusgdrug
    gv
X-ME-Proxy: <xmx:B0ZlY8iwPrvlRW9Sr165qYCSwv4gY43jh-KJQ1mIGf8axtwmYm1FyA>
    <xmx:B0ZlY09hyLltdObrJnXPr_FJ6jz9ouq3H9yqTATI8zfOUMWebzWVkA>
    <xmx:B0ZlY_ss1pTZ4mOSYO9IU5q53a_w8UJqfWj3_CHaFoey1-CkvVBywQ>
    <xmx:CEZlY4EsuKA-H12CQiRj-wumtQeBiJLvYNCcgNAQOvKAf9SoSk-vUw>
Feedback-ID: i36794607:Fastmail
Received: by mailuser.nyi.internal (Postfix, from userid 501)
        id 479BEB603ED; Fri,  4 Nov 2022 13:04:07 -0400 (EDT)
X-Mailer: MessagingEngine.com Webmail Interface
User-Agent: Cyrus-JMAP/3.7.0-alpha0-1087-g968661d8e1-fm-20221021.001-g968661d8
Mime-Version: 1.0
Message-Id: <36bb910c-4874-409b-ac71-d141cd1d8ecb@app.fastmail.com>
In-Reply-To: <c2c0ba34-2985-21ea-0809-b96a3aa5e401@siemens.com>
References: <20220825134449.18803-1-harald.mommer@opensynergy.com>
 <20220827093909.ag3zi7k525k4zuqq@pengutronix.de>
 <40e3d678-b840-e780-c1da-367000724f69@opensynergy.com>
 <c2c0ba34-2985-21ea-0809-b96a3aa5e401@siemens.com>
Date:   Fri, 04 Nov 2022 18:03:50 +0100
From:   "Arnd Bergmann" <arnd@kernel.org>
To:     "Jan Kiszka" <jan.kiszka@siemens.com>,
        "Harald Mommer" <hmo@opensynergy.com>,
        "Marc Kleine-Budde" <mkl@pengutronix.de>,
        "Harald Mommer" <harald.mommer@opensynergy.com>
Cc:     virtio-dev@lists.oasis-open.org, linux-can@vger.kernel.org,
        Netdev <netdev@vger.kernel.org>, linux-kernel@vger.kernel.org,
        "Wolfgang Grandegger" <wg@grandegger.com>,
        "David S . Miller" <davem@davemloft.net>,
        "Eric Dumazet" <edumazet@google.com>,
        "Jakub Kicinski" <kuba@kernel.org>,
        "Paolo Abeni" <pabeni@redhat.com>,
        "Dariusz Stojaczyk" <Dariusz.Stojaczyk@opensynergy.com>,
        stratos-dev@op-lists.linaro.org
Subject: Re: [virtio-dev] Re: [RFC PATCH 1/1] can: virtio: Initial virtio CAN driver.
Content-Type: text/plain
X-Spam-Status: No, score=-8.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Nov 4, 2022, at 16:32, Jan Kiszka wrote:
> On 03.11.22 14:55, Harald Mommer wrote:
>> 
>> On 27.08.22 11:39, Marc Kleine-Budde wrote:
>>> Is there an Open Source implementation of the host side of this
>>> interface?
>> there is neither an open source device nor is it currently planned. The
>> device I'm developing is closed source.
>
> Likely not helpful long-term /wrt kernel QA - how should kernelci or
> others even have a chance to test the driver? Keep in mind that you are
> not proposing a specific driver for an Opensynergy hypervisor, rather
> for the open and vendor-agnostic virtio spec.
>
> But QEMU already supports both CAN and virtio, thus should be relatively
> easy to augment with this new device.

Agreed, either hooking into the qemu support, or having a separate
vhost-user backend that forwards data to the host stack would be
helpful here, in particular to see how the flow control works.

IIRC when we discussed virtio-can on the stratos list, one of the
issues that was pointed out was filtering of frames for specific
CAN IDs in the host socketcan for assigning individual IDs to
separate guests.  It would be good to understand whether a generic
host implementation has the same problems, and what can be
done in socketcan to help with that.

      Arnd
