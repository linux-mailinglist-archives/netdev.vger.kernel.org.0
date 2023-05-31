Return-Path: <netdev+bounces-6673-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id D244C717658
	for <lists+netdev@lfdr.de>; Wed, 31 May 2023 07:47:09 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 33E2B281380
	for <lists+netdev@lfdr.de>; Wed, 31 May 2023 05:47:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 304614A3E;
	Wed, 31 May 2023 05:47:06 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1FF3010F4
	for <netdev@vger.kernel.org>; Wed, 31 May 2023 05:47:05 +0000 (UTC)
Received: from out4-smtp.messagingengine.com (out4-smtp.messagingengine.com [66.111.4.28])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CAB21EE
	for <netdev@vger.kernel.org>; Tue, 30 May 2023 22:47:04 -0700 (PDT)
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
	by mailout.nyi.internal (Postfix) with ESMTP id 437565C00B9;
	Wed, 31 May 2023 01:47:04 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute1.internal (MEProxy); Wed, 31 May 2023 01:47:04 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-type:content-type:date:date
	:feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
	:message-id:mime-version:references:reply-to:sender:subject
	:subject:to:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
	:x-sasl-enc; s=fm1; t=1685512024; x=1685598424; bh=OURpNO4P3HA/z
	m/bKyveNcmNduwdfwOYHSQG64kVykE=; b=bTm3yKpZRmcPp/WGMlYB/Dj7hjjL7
	6VWPZ1oa3FwUap5YjyxyfskLtQaMID+OHQxj61wW9KlooRaablsQ7EXoxEXR036d
	T0LfTo4fghMy73wXG2vzLBAdXE/fAnPNBcdftSYpiJI9riJCdm1qJVT7zVPceQfb
	BE8OjG+kuamkzdDk9p2SF+CLHGCxTMOdIIzwxv70YTDnTFKxvG8K3YWEANmrvMAh
	avuVirxQaJfr9618gu5MfH1XMZcDsF/4ns2uTcF/IlEPyBlTAFtgkgOfRF3NGhof
	76hgafp2JzUsIsUZ5RFfMWMcYc0Qd/Mr3eaVaA1DsdJdIKK5lSGU/g41Q==
X-ME-Sender: <xms:WN92ZEYAEr6VB-yEvkYm3-cMm5UExag71HvfPF698nJvgfCNFjrVOw>
    <xme:WN92ZPYdZ1YCvK6b2GW1iG-Nf5yKpPxqxzIXSK6YdNQBtVLaSq49D99YCfQSVUr2h
    A6Qe5Xl7SVQlsA>
X-ME-Received: <xmr:WN92ZO8d-1j33EPOukMB-i-HvEloGwyWVcPDXKhK2PCFsia696kDb_LFkBSTKPB2doj0Cawr1ME_uF9w9ifhkWjZXck>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvhedrfeekkedguddtudcutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
    enucfjughrpeffhffvvefukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpefkugho
    ucfutghhihhmmhgvlhcuoehiughoshgthhesihguohhstghhrdhorhhgqeenucggtffrrg
    htthgvrhhnpedvudefveekheeugeeftddvveefgfduieefudeifefgleekheegleegjeej
    geeghfenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpe
    hiughoshgthhesihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:WN92ZOrkB59Q6FLxD2pzix0B86p7R7kaGrl0LLF7KKmelUQ8mFSJFA>
    <xmx:WN92ZPp3Av4c4XI0j0AuCKhhEzW4GLNAz6SJ1RsSI6V_L2AUigdiQQ>
    <xmx:WN92ZMRNNkbnbm6e7j93TIsUhUyFjR_Vri3O4dDrB6KInOMfducwmQ>
    <xmx:WN92ZG3KwqD9S2ONXP_50_ZEp9cwrMsgm_4tYXzSZf_ueytDEBVyHg>
Feedback-ID: i494840e7:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 31 May 2023 01:47:03 -0400 (EDT)
Date: Wed, 31 May 2023 08:47:00 +0300
From: Ido Schimmel <idosch@idosch.org>
To: Andrea Claudi <aclaudi@redhat.com>
Cc: netdev@vger.kernel.org, stephen@networkplumber.org, dsahern@gmail.com,
	leon@kernel.org
Subject: Re: [PATCH iproute2-next] treewide: fix indentation
Message-ID: <ZHbfVC03hq/wsHwG@shredder>
References: <aa496abb20ac66d45db0dcf6456a0ea23508de09.1685466971.git.aclaudi@redhat.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aa496abb20ac66d45db0dcf6456a0ea23508de09.1685466971.git.aclaudi@redhat.com>
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,
	SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Tue, May 30, 2023 at 07:19:53PM +0200, Andrea Claudi wrote:
> Replace multiple whitespaces with tab where appropriate.
> 
> Signed-off-by: Andrea Claudi <aclaudi@redhat.com>
> ---
>  bridge/vni.c   |  2 +-
>  genl/ctrl.c    |  2 +-
>  ip/ipaddress.c |  2 +-
>  ip/ipmacsec.c  |  4 ++--
>  ip/ipprefix.c  |  2 +-
>  ip/ipvrf.c     |  2 +-
>  lib/fs.c       |  2 +-
>  lib/ll_types.c | 10 +++++-----
>  rdma/dev.c     | 10 +++++-----
>  tc/m_ipt.c     |  4 ++--
>  tc/m_xt_old.c  |  4 ++--
>  tc/q_fq.c      |  8 ++++----
>  tc/q_htb.c     |  4 ++--
>  tc/tc_core.c   |  2 +-
>  14 files changed, 29 insertions(+), 29 deletions(-)

Thanks for the patch. Do you mind folding this one as well?

diff --git a/tc/f_flower.c b/tc/f_flower.c
index 48cfafdbc3c0..d68c9d2a194b 100644
--- a/tc/f_flower.c
+++ b/tc/f_flower.c
@@ -88,7 +88,7 @@ static void explain(void)
                "                       enc_ttl MASKED-IP_TTL |\n"
                "                       geneve_opts MASKED-OPTIONS |\n"
                "                       vxlan_opts MASKED-OPTIONS |\n"
-               "                       erspan_opts MASKED-OPTIONS |\n"
+               "                       erspan_opts MASKED-OPTIONS |\n"
                "                       gtp_opts MASKED-OPTIONS |\n"
                "                       ip_flags IP-FLAGS |\n"
                "                       enc_dst_port [ port_number ] |\n"

Before:

$ tc filter add flower help 2>&1 | grep opts
                        geneve_opts MASKED-OPTIONS |
                        vxlan_opts MASKED-OPTIONS |
                       erspan_opts MASKED-OPTIONS |
                        gtp_opts MASKED-OPTIONS |

After:

$ tc filter add flower help 2>&1 | grep opts
                        geneve_opts MASKED-OPTIONS |
                        vxlan_opts MASKED-OPTIONS |
                        erspan_opts MASKED-OPTIONS |
                        gtp_opts MASKED-OPTIONS |

