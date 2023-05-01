Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DD2FD6F2EF4
	for <lists+netdev@lfdr.de>; Mon,  1 May 2023 08:56:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229663AbjEAG4W (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 May 2023 02:56:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56058 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229519AbjEAG4U (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 May 2023 02:56:20 -0400
Received: from out2-smtp.messagingengine.com (out2-smtp.messagingengine.com [66.111.4.26])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D2EA91B6
        for <netdev@vger.kernel.org>; Sun, 30 Apr 2023 23:56:19 -0700 (PDT)
Received: from compute2.internal (compute2.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id 062635C00B5;
        Mon,  1 May 2023 02:56:19 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute2.internal (MEProxy); Mon, 01 May 2023 02:56:19 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-type:content-type:date:date
        :feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
        :message-id:mime-version:references:reply-to:sender:subject
        :subject:to:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
        :x-sasl-enc; s=fm3; t=1682924179; x=1683010579; bh=UtL05uruvaDEz
        GzY6rmsomjW9EEj469m3niJCPhmEBo=; b=d7DPnJIsLWbwAAnhIejMHKcRFWkkJ
        QjAH/ncViwWtMQ5H4/SDhrrvewx7j9tenjftfCpQPgZvrMwBTHxWaiWOeyN0/9EV
        Bn8B9mGz6nKby81KChhB3UGf0Xt1SkcpT8ZRI2Z2+1JIn7thxR24512n+wuboXh1
        ryzqKI/MnUcQrIQAr1Bbj1kfhuo177sKWy6ryuPfRe3PwlpIHYgZyZROTq1LFMq2
        N4Zi/GTEyE/xK+NMR6Jfe2oHTaVks1qL/SqAqip9aftpMazjBncLQ37s1csAr64w
        3IK+I/tOUEYrXSPQSasJ05gIT9DPjn7xb6an6XHecV/v5j/i5UivfhEGA==
X-ME-Sender: <xms:kmJPZAQ3aaXH51RKUx_j5a4nU6elaQmPz0UJ_LvdXAZw2kG0lZ5NAA>
    <xme:kmJPZNwg4GwBBst76ClQjUDQsASJVLGG1JZ2vXyC6k6iORXd824qT2J0H4PXXGisM
    GXU3cMeYD7gzBU>
X-ME-Received: <xmr:kmJPZN39I8O2FYS6Q43jcDK2WFAAmPaOyIbcM6F0pTU6oYZhIOFTNXTEI4nn>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvhedrfedvfedguddujecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
    enucfjughrpeffhffvvefukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpefkugho
    ucfutghhihhmmhgvlhcuoehiughoshgthhesihguohhstghhrdhorhhgqeenucggtffrrg
    htthgvrhhnpedvudefveekheeugeeftddvveefgfduieefudeifefgleekheegleegjeej
    geeghfenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpe
    hiughoshgthhesihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:kmJPZEARB18IbQWS0VD4Jb1vwBlkNp7RN1esorWvKSJUBUwj8bRBwA>
    <xmx:kmJPZJicxXJpnSp3OXtFF_7ZKHv_13GrfixRY3Z0z1xm_cz0qwW-FA>
    <xmx:kmJPZArZ2hUjvuwqp6q8o2xthW2se48qTIsXD5HC7r1-5WnKI-Kgxg>
    <xmx:k2JPZOaErDRdyAoqHRDm9hsfUKGp-ZkaTzWPuSljVUTkd8gPHX7d6g>
Feedback-ID: i494840e7:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 1 May 2023 02:56:17 -0400 (EDT)
Date:   Mon, 1 May 2023 09:56:15 +0300
From:   Ido Schimmel <idosch@idosch.org>
To:     Zahari Doychev <zahari.doychev@linux.com>
Cc:     netdev@vger.kernel.org, jhs@mojatatu.com, xiyou.wangcong@gmail.com,
        jiri@resnulli.us, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, hmehrtens@maxlinear.com,
        aleksander.lobakin@intel.com, simon.horman@corigine.com,
        Zahari Doychev <zdoychev@maxlinear.com>
Subject: Re: [PATCH net-next v4 2/3] net: flower: add support for matching
 cfm fields
Message-ID: <ZE9ij6it2lvS0SFB@shredder>
References: <20230425211630.698373-1-zahari.doychev@linux.com>
 <20230425211630.698373-3-zahari.doychev@linux.com>
 <ZE6AFQuv+yi7RxUL@shredder>
 <yabevxsc5uqezsjwjalqbnliu2yspl3v2drspd5a6a76nxdjon@47q7jzo2r3bl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <yabevxsc5uqezsjwjalqbnliu2yspl3v2drspd5a6a76nxdjon@47q7jzo2r3bl>
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,
        SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Apr 30, 2023 at 06:35:13PM +0200, Zahari Doychev wrote:
> On Sun, Apr 30, 2023 at 05:49:57PM +0300, Ido Schimmel wrote:
> > On Tue, Apr 25, 2023 at 11:16:29PM +0200, Zahari Doychev wrote:
> > > +static const struct nla_policy cfm_opt_policy[TCA_FLOWER_KEY_CFM_OPT_MAX] = {
> > > +	[TCA_FLOWER_KEY_CFM_MD_LEVEL]	= NLA_POLICY_MAX(NLA_U8, 7),
> > 
> > Instead of 7, can you use FIELD_MAX(FLOW_DIS_CFM_MDL_MASK) like you did
> > in the previous version?
> > 
> 
> It seems that the macro can be use only inside functions. I wanted to use it
> but I was getting the following error:
> 
> linux/include/linux/bitfield.h:86:9: error: braced-group within expression allowed only inside a function

I see. Another option that I personally find better than hard-coding 7
is the below:

diff --git a/include/net/flow_dissector.h b/include/net/flow_dissector.h
index 479b66b11d2d..52f30906b210 100644
--- a/include/net/flow_dissector.h
+++ b/include/net/flow_dissector.h
@@ -317,6 +317,7 @@ struct flow_dissector_key_cfm {
 };
 
 #define FLOW_DIS_CFM_MDL_MASK GENMASK(7, 5)
+#define FLOW_DIS_CFM_MDL_MAX 7
 
 enum flow_dissector_key_id {
        FLOW_DISSECTOR_KEY_CONTROL, /* struct flow_dissector_key_control */
diff --git a/net/sched/cls_flower.c b/net/sched/cls_flower.c
index 5d77da484a88..85fc77063866 100644
--- a/net/sched/cls_flower.c
+++ b/net/sched/cls_flower.c
@@ -772,7 +772,8 @@ mpls_stack_entry_policy[TCA_FLOWER_KEY_MPLS_OPT_LSE_MAX + 1] = {
 };
 
 static const struct nla_policy cfm_opt_policy[TCA_FLOWER_KEY_CFM_OPT_MAX] = {
-       [TCA_FLOWER_KEY_CFM_MD_LEVEL]   = NLA_POLICY_MAX(NLA_U8, 7),
+       [TCA_FLOWER_KEY_CFM_MD_LEVEL]   = NLA_POLICY_MAX(NLA_U8,
+                                                        FLOW_DIS_CFM_MDL_MAX),
        [TCA_FLOWER_KEY_CFM_OPCODE]     = { .type = NLA_U8 },
 };
