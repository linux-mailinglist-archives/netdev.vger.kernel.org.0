Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 69AD76BAB40
	for <lists+netdev@lfdr.de>; Wed, 15 Mar 2023 09:55:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231638AbjCOIy7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Mar 2023 04:54:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35288 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231405AbjCOIyz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Mar 2023 04:54:55 -0400
Received: from out4-smtp.messagingengine.com (out4-smtp.messagingengine.com [66.111.4.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1894686A6;
        Wed, 15 Mar 2023 01:54:55 -0700 (PDT)
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailout.nyi.internal (Postfix) with ESMTP id 760FD5C03FC;
        Wed, 15 Mar 2023 04:54:54 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute1.internal (MEProxy); Wed, 15 Mar 2023 04:54:54 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-type:content-type:date:date
        :feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
        :message-id:mime-version:references:reply-to:sender:subject
        :subject:to:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
        :x-sasl-enc; s=fm2; t=1678870494; x=1678956894; bh=4VX8MaBaG82aU
        ulFe42jvkdBJtSGGoHr0ACjMYCemvQ=; b=O/bVJoZEqiZXlMCmHGOboPptcloRp
        QuHZ9DxOI5K74DKdEFwQ+s8SpcrvbYpTrJZcQ92+oUm3lKWV5iawS7RhTzX+nhyO
        qNsMN6nXAorRa++tcgV+HSSjpRYOJJ+uTcLh01TFfP7+3cGtjk19wxVnmeHJYJAX
        oNjXMJ4yry4ESO7HcjId/T0zYBXD7wiBYaU7UWg6IrL4UOosduR6Oq7ttLF4PtHG
        j7SG57q5jSHDsPYLjTRbaGKPBVi1o3apFQlwADXmI+1hODtmeqwVSrPFSy5yq0WT
        1UPoKMhm8ni1wTOhujDUiTsOeZscOQx2VxD1d9tDjSm0mK4hHp4h7OnBg==
X-ME-Sender: <xms:3YcRZMvBdY8pBfITlE7E1Kk8II1RPahSvOIn99rsDvUxeoLG20RUjw>
    <xme:3YcRZJcBWtqEBDXEuMppaqVkQTrcivjKeuhzfWvwD1L1l-9wTVbFn5VDn9bz1Xo2-
    rBvNOvw_enMlYk>
X-ME-Received: <xmr:3YcRZHyvVDbS_xnnW7Mkke7ib0yoY-Y6XCqz37WympUh7zp-_MC26hyYCEWfHPez7on3v_lbU9ZbD_YQfC-zmCLIAlc>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvhedrvddvjedguddvvdcutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecunecujfgurhepfffhvfevuffkfhggtggujgesth
    dtredttddtvdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehi
    ughoshgthhdrohhrgheqnecuggftrfgrthhtvghrnhepvddufeevkeehueegfedtvdevfe
    fgudeifeduieefgfelkeehgeelgeejjeeggefhnecuvehluhhsthgvrhfuihiivgeptden
    ucfrrghrrghmpehmrghilhhfrhhomhepihguohhstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:3YcRZPOL68oZGl_kAUcCO74BsIXY7UnSla7rG5F_MKhvIacJ4ih4Dw>
    <xmx:3YcRZM-sTgBLtGG8qu4Voi0wmsO2ALNXiY2kU4n-_wYKCfB-4AONWA>
    <xmx:3YcRZHUqfCIMxR532d2sXKQvXMHXSFCLMGH0FFCzawPhj9vl26rsng>
    <xmx:3ocRZJMfs29CERH-PpxkuWKMD5-7ZXTPZ-S4RDvo6p9jwWqIIWqqKQ>
Feedback-ID: i494840e7:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 15 Mar 2023 04:54:52 -0400 (EDT)
Date:   Wed, 15 Mar 2023 10:54:49 +0200
From:   Ido Schimmel <idosch@idosch.org>
To:     gaoxingwang <gaoxingwang1@huawei.com>
Cc:     davem@davemloft.net, kuba@kernel.org, liaichun@huawei.com,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        pabeni@redhat.com, shuah@kernel.org, yanan@huawei.com,
        yoshfuji@linux-ipv6.org
Subject: Re: ipv4:the same route is added repeatedly
Message-ID: <ZBGH2RMEDGCxhctH@shredder>
References: <ZBCq+KXtxWXLPFNF@shredder>
 <20230315074310.2957080-1-gaoxingwang1@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230315074310.2957080-1-gaoxingwang1@huawei.com>
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,
        SPF_HELO_PASS,SPF_NONE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 15, 2023 at 03:43:10PM +0800, gaoxingwang wrote:
> Thanks for you reply.This patch works for me.

Thanks for testing.

> Can you submit a patch? Hope the problem will be fixed as soon as possible. 

Yes, I will send a patch.
