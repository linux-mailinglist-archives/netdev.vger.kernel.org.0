Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DCC315809B0
	for <lists+netdev@lfdr.de>; Tue, 26 Jul 2022 04:55:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231313AbiGZCzA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Jul 2022 22:55:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47826 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230133AbiGZCy7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Jul 2022 22:54:59 -0400
Received: from out30-54.freemail.mail.aliyun.com (out30-54.freemail.mail.aliyun.com [115.124.30.54])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DCE13643F;
        Mon, 25 Jul 2022 19:54:57 -0700 (PDT)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R841e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018046060;MF=tonylu@linux.alibaba.com;NM=1;PH=DS;RN=9;SR=0;TI=SMTPD_---0VKTDade_1658804094;
Received: from localhost(mailfrom:tonylu@linux.alibaba.com fp:SMTPD_---0VKTDade_1658804094)
          by smtp.aliyun-inc.com;
          Tue, 26 Jul 2022 10:54:55 +0800
Date:   Tue, 26 Jul 2022 10:54:54 +0800
From:   Tony Lu <tonylu@linux.alibaba.com>
To:     Wenjia Zhang <wenjia@linux.ibm.com>
Cc:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-s390@vger.kernel.org, Heiko Carstens <hca@linux.ibm.com>,
        Karsten Graul <kgraul@linux.ibm.com>,
        Alexandra Winter <wintera@linux.ibm.com>,
        Stefan Raspl <raspl@linux.ibm.com>
Subject: Re: [PATCH net-next 4/4] net/smc: Enable module load on netlink usage
Message-ID: <Yt9Xfv0bN0AGMdGP@TonyMac-Alibaba>
Reply-To: Tony Lu <tonylu@linux.alibaba.com>
References: <20220725141000.70347-1-wenjia@linux.ibm.com>
 <20220725141000.70347-5-wenjia@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220725141000.70347-5-wenjia@linux.ibm.com>
X-Spam-Status: No, score=-9.9 required=5.0 tests=BAYES_00,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        UNPARSEABLE_RELAY,USER_IN_DEF_SPF_WL autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jul 25, 2022 at 04:10:00PM +0200, Wenjia Zhang wrote:
> From: Stefan Raspl <raspl@linux.ibm.com>
> 
> Previously, the smc and smc_diag modules were automatically loaded as
> dependencies of the ism module whenever an ISM device was present.
> With the pending rework of the ISM API, the smc module will no longer
> automatically be loaded in presence of an ISM device. Usage of an AF_SMC
> socket will still trigger loading of the smc modules, but usage of a
> netlink socket will not.
> This is addressed by setting the correct module aliases.
> 
> Signed-off-by: Stefan Raspl <raspl@linux.ibm.com>
> Signed-off-by: Wenjia Zhang < wenjia@linux.ibm.com>

This patch looks good to me.

Reviewed-by: Tony Lu <tonylu@linux.alibaba.com>

> ---
>  net/smc/af_smc.c   | 1 +
>  net/smc/smc_diag.c | 1 +
>  2 files changed, 2 insertions(+)
> 
> diff --git a/net/smc/af_smc.c b/net/smc/af_smc.c
> index 6e70d9c10b78..79c1318af1fe 100644
> --- a/net/smc/af_smc.c
> +++ b/net/smc/af_smc.c
> @@ -3515,3 +3515,4 @@ MODULE_DESCRIPTION("smc socket address family");
>  MODULE_LICENSE("GPL");
>  MODULE_ALIAS_NETPROTO(PF_SMC);
>  MODULE_ALIAS_TCP_ULP("smc");
> +MODULE_ALIAS_GENL_FAMILY(SMC_GENL_FAMILY_NAME);
> diff --git a/net/smc/smc_diag.c b/net/smc/smc_diag.c
> index 1fca2f90a9c7..80ea7d954ece 100644
> --- a/net/smc/smc_diag.c
> +++ b/net/smc/smc_diag.c
> @@ -268,3 +268,4 @@ module_init(smc_diag_init);
>  module_exit(smc_diag_exit);
>  MODULE_LICENSE("GPL");
>  MODULE_ALIAS_NET_PF_PROTO_TYPE(PF_NETLINK, NETLINK_SOCK_DIAG, 43 /* AF_SMC */);
> +MODULE_ALIAS_GENL_FAMILY(SMCR_GENL_FAMILY_NAME);
> -- 
> 2.35.2
