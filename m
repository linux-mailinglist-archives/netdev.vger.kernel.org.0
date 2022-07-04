Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BD99C564D65
	for <lists+netdev@lfdr.de>; Mon,  4 Jul 2022 07:44:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233000AbiGDFoK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Jul 2022 01:44:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46444 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233165AbiGDFnj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 Jul 2022 01:43:39 -0400
Received: from wout5-smtp.messagingengine.com (wout5-smtp.messagingengine.com [64.147.123.21])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F42FAE6A
        for <netdev@vger.kernel.org>; Sun,  3 Jul 2022 22:42:08 -0700 (PDT)
Received: from compute2.internal (compute2.nyi.internal [10.202.2.46])
        by mailout.west.internal (Postfix) with ESMTP id CBEEB32002B6;
        Mon,  4 Jul 2022 01:42:05 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute2.internal (MEProxy); Mon, 04 Jul 2022 01:42:06 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=traverse.com.au;
         h=cc:cc:content-transfer-encoding:date:date:from:from
        :in-reply-to:message-id:mime-version:reply-to:sender:subject
        :subject:to:to; s=fm1; t=1656913325; x=1656999725; bh=cx8X+tzk7v
        HlkNZDVEf9vl6BG9/TB+itb5hcacBmGvQ=; b=G4DpBiJpXgz/K7RghmKoAbPzuq
        7qIkSCU7QPH+G9W3AfORDsWuF6VhXLmZIks9eBFHw6kRQ4B9ZE7Ti+UdyDwPtZ/7
        Voc+AiPqWsndvMIql2hpZn5lO8wAGBJbLnHTX7YGJtUR+T6NKdWOYoKK/gjgndj4
        js5dVLAxW1nZb8NZy9bCBf9NaVXBBdOMSb+1BcaxLdUG4d0QDL5iKn9peozZgc6T
        oiMxQ+O1FoJnLc8amNWVhsBtgl3Ec7dnSb8F8MVYL1+ntxybEX6EPPizk/tnrD+8
        LNIHRVu2Vh8FX7DvXmD7Ai11eTTO+3DFf2Bm0EvsNfzD6x08KLu0gzZIt6wA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-transfer-encoding:date:date
        :feedback-id:feedback-id:from:from:in-reply-to:message-id
        :mime-version:reply-to:sender:subject:subject:to:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; t=
        1656913325; x=1656999725; bh=cx8X+tzk7vHlkNZDVEf9vl6BG9/TB+itb5h
        cacBmGvQ=; b=WKsbodaVlnkx3aZL5hWHgEjKo5Vf/8IThilC2vmRBXTjB7uXpVe
        8QscUoFOMb8Ajnf0ADbSBZ95j5OHqXxeRdmaM5ZQ3EMsKt50SIAounhnSyXfZEYi
        caWyudiHZHRHZMJs6kivmfQcsnzgxowttX/cc1gAnpnQyYQty98upBMn/mmHExdW
        4+0iS3pa2Iqpgq+rAhCSa2hG2xbS76vbgx3HwF0BshKqeSs5yZOGMQ0nPZNZEE+L
        ypYtsNmyWlucuqula4SaykRcH4xB5eQ6ulq2PUDKBA7fIjjpQrXrWZBWxKyAT392
        S+acrklnBquPYgMog2Oqpi4a7Z3tjyztgqA==
X-ME-Sender: <xms:rH3CYiRXpQe7Jaj8hikRVCACG_oA9im1NIcTlM0mBOAIFwQPEd96pQ>
    <xme:rH3CYnyO1qLEHEdWW6pq9CDsMmI1UbFfE2KP5GsS4AaTfCvpwivZrO4tfuR1A59N3
    ma2C6dK7mjy-hvD8C4>
X-ME-Received: <xmr:rH3CYv1qDvOlpaLKuDIULthXVVcS3b6MNun1k6KdmgBFsh7lU7Gaf_-C0gbggJqZLaIba9r3ofnSySyCXIYuA61xkjz0ucX8n-bOPvf_sIWSaUIQIls8lU7AXUOmfAo>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvfedrudehkedgleejucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhephffvvefufffkofgggfestdekredtredttdenucfhrhhomhepofgrthhhvgif
    ucfotgeurhhiuggvuceomhgrthhtsehtrhgrvhgvrhhsvgdrtghomhdrrghuqeenucggtf
    frrghtthgvrhhnpefgveduleeikeffgfffleekfedviefhvdegueeijeegheduhfeltefg
    tdeuffefueenucffohhmrghinhepghhithhlrggsrdgtohhmpdhgihhthhhusgdrtghomh
    enucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehmrght
    thesthhrrghvvghrshgvrdgtohhmrdgruh
X-ME-Proxy: <xmx:rH3CYuBHYr1K31iSuZoE4KH2nLAvbjrF5AICswotyn8x0bDDn5-l7g>
    <xmx:rH3CYrieL67KIWTcyG4MdJMH4vZIneeIIL3-wlqPd8AAzGmAHeGgBA>
    <xmx:rH3CYqqAZlXY-eHQkMFGc-fFFsNBy7mNYFLZUY_LuBmlMJ0XytZ4nQ>
    <xmx:rX3CYjZvBhOHiR7jBMxseBD8LQJ3md2umcnu7gdaPfvd0YpTnPRRDA>
Feedback-ID: i426947f3:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 4 Jul 2022 01:42:03 -0400 (EDT)
From:   Mathew McBride <matt@traverse.com.au>
To:     Michal Kubecek <mkubecek@suse.cz>
Cc:     netdev@vger.kernel.org, Mathew McBride <matt@traverse.com.au>
Subject: [PATCH ethtool 0/2] Add JSON support for SFP EEPROM dump
Date:   Mon,  4 Jul 2022 05:41:12 +0000
Message-Id: <20220704054114.22582-1-matt@traverse.com.au>
X-Mailer: git-send-email 2.30.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch adds JSON output support to ethtool's -m option,
useful for presenting transceiver module option in a web interface.

An example frontend can be found here, for OpenWrt's LuCI:
https://gitlab.com/traversetech/muvirt-feed/-/tree/master/sfp-diagnostics-luci

You can find samples of the output, plus a screenshot here:
10GBASE-LR SFP:
https://gitlab.com/-/snippets/2364354
1/10GBASE-LR dual mode SFP
https://gist.github.com/mcbridematt/7921c795c4835afa807d8f83cc132401

I have tried to make the JSON format easy to consume by including both
the original field values and full text descriptions, so any consumer
of the JSON output doesn't need to replicate ethtool's rendering logic.

I'm open to any suggestions on how the structure of the JSON output
could be improved.

Mathew McBride (2):
  ethtool: add JSON output to --module-info
  ethtool: remove restriction on ioctl commands having JSON output

 ethtool.c    |   8 +-
 sff-common.c | 213 +++++++++++++++--------
 sff-common.h |  17 +-
 sfpdiag.c    |  64 ++++++-
 sfpid.c      | 478 +++++++++++++++++++++++++++++++--------------------
 5 files changed, 522 insertions(+), 258 deletions(-)

-- 
2.30.1

