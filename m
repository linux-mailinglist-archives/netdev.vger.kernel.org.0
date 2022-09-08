Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C94215B1634
	for <lists+netdev@lfdr.de>; Thu,  8 Sep 2022 10:03:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230455AbiIHIDp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Sep 2022 04:03:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43596 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231295AbiIHIDl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Sep 2022 04:03:41 -0400
Received: from wout4-smtp.messagingengine.com (wout4-smtp.messagingengine.com [64.147.123.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7791C9C201;
        Thu,  8 Sep 2022 01:03:40 -0700 (PDT)
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailout.west.internal (Postfix) with ESMTP id B5555320099A;
        Thu,  8 Sep 2022 04:03:37 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute1.internal (MEProxy); Thu, 08 Sep 2022 04:03:39 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-type:date:date:feedback-id
        :feedback-id:from:from:in-reply-to:in-reply-to:message-id
        :mime-version:references:reply-to:sender:subject:subject:to:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm2; t=1662624217; x=1662710617; bh=d+fPn5Xs3VSo7ZgbtG1zG/IK3f61
        cjEviCJRFTpBFSM=; b=KkGKA4DEn+WBn/aM3jhzfzhf0ydqQp3F9m89B463SfiF
        pb6e6138QqSgMB4Oa/GOdN/hAh3AD1NJ73AQxBYVvPsaTBia1wLiGf+dQKZ5F3KK
        TVnj+ai/Z7dIdIGKnCgUYApDhZkud91w9uZEIq5smonJzcI6g0wdIbCHryQl6J56
        UaLCOl0doJWjZkdjzMArGPOPeTwl/gN4DTYsgyaa8HNqFC/Ek8GAmqNukpbxP1/L
        uAQSiiNcwwsoRNQ5fw06B8jGhGSTaCtgBva0c1r3DuVPnm/6HGEjV8mxktluoeqh
        D8ovrSnRUhvBa9xUAVjPE8UYqwlwsxsUeH4hYpFolg==
X-ME-Sender: <xms:2KEZY1FYxiP-JTVtuKcoN77kkN_8eZt5sOPLs7kKGut_kUKsnNwZ4w>
    <xme:2KEZY6V8bl-RieJ23drVRrLYTJMJ58G5hxSEy4nrIFJTlhgnKn7WMOy6QyKcQUHxN
    CBWJsEbs3GRoBc>
X-ME-Received: <xmr:2KEZY3Kog9tRvV4eSwOYhT0akuhdPtIz5woKIQ_qxZEnQT5roy7VP6J1y-mPZd_z3nkhKN_14FLhkjXDvMLE0J6xGXPUMg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvfedrfedtuddgudeftdcutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
    enucfjughrpeffhffvvefukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpefkugho
    ucfutghhihhmmhgvlhcuoehiughoshgthhesihguohhstghhrdhorhhgqeenucggtffrrg
    htthgvrhhnpedvudefveekheeugeeftddvveefgfduieefudeifefgleekheegleegjeej
    geeghfenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpe
    hiughoshgthhesihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:2KEZY7GQYCpp4IrOpq-N67I-7j664fsVLWeOvFY1r49xPatYPHqMxQ>
    <xmx:2KEZY7VljOoOoJPrLmw59lGYc0jkbN1_7lG-ObW1NE147cDzVfSiUA>
    <xmx:2KEZY2OI6joONKLMcZD7ngDN7ZvUd4-AZOmJs0yNG463YCP9MMNntQ>
    <xmx:2aEZY0tbJ8xPhw0rx9Dn2NCGrfnwxzjPZApL59pQSABB9EuPvIINDA>
Feedback-ID: i494840e7:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 8 Sep 2022 04:03:36 -0400 (EDT)
Date:   Thu, 8 Sep 2022 11:03:32 +0300
From:   Ido Schimmel <idosch@idosch.org>
To:     "Zhou, Jie2X" <jie2x.zhou@intel.com>
Cc:     "kuba@kernel.org" <kuba@kernel.org>,
        "andrii@kernel.org" <andrii@kernel.org>,
        "mykolal@fb.com" <mykolal@fb.com>,
        "ast@kernel.org" <ast@kernel.org>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        "martin.lau@linux.dev" <martin.lau@linux.dev>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "hawk@kernel.org" <hawk@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "linux-kselftest@vger.kernel.org" <linux-kselftest@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Li, Philip" <philip.li@intel.com>,
        "petrm@nvidia.com" <petrm@nvidia.com>
Subject: Re: test ./tools/testing/selftests/bpf/test_offload.py failed
Message-ID: <Yxmh1PBj2BRsArD+@shredder>
References: <20220907051657.55597-1-jie2x.zhou@intel.com>
 <Yxg9r37w1Wg3mvxy@shredder>
 <CY4PR11MB1320E553043DC1D67B5E7D56C5419@CY4PR11MB1320.namprd11.prod.outlook.com>
 <YxjB7RZvVrKxJ4ec@shredder>
 <CY4PR11MB132098D8E47E38FD945E6398C5409@CY4PR11MB1320.namprd11.prod.outlook.com>
 <YxmKdBVkNCPF4Kob@shredder>
 <CY4PR11MB1320BB40A48D230A1A196318C5409@CY4PR11MB1320.namprd11.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CY4PR11MB1320BB40A48D230A1A196318C5409@CY4PR11MB1320.namprd11.prod.outlook.com>
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Sep 08, 2022 at 07:44:06AM +0000, Zhou, Jie2X wrote:
> About netdevsim patch ([2]), do you commit it to kernel mail list?

Yes, I will send it to 'net'. Can I add your Tested-by tag?
