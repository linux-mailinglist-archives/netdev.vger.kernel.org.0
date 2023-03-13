Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 11A1A6B75BB
	for <lists+netdev@lfdr.de>; Mon, 13 Mar 2023 12:16:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230123AbjCMLQn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Mar 2023 07:16:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52876 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230179AbjCMLQ0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Mar 2023 07:16:26 -0400
Received: from out30-124.freemail.mail.aliyun.com (out30-124.freemail.mail.aliyun.com [115.124.30.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D5DD64850;
        Mon, 13 Mar 2023 04:15:36 -0700 (PDT)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R201e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018045168;MF=tonylu@linux.alibaba.com;NM=1;PH=DS;RN=14;SR=0;TI=SMTPD_---0VdmUiz9_1678706118;
Received: from localhost(mailfrom:tonylu@linux.alibaba.com fp:SMTPD_---0VdmUiz9_1678706118)
          by smtp.aliyun-inc.com;
          Mon, 13 Mar 2023 19:15:18 +0800
Date:   Mon, 13 Mar 2023 19:15:17 +0800
From:   Tony Lu <tonylu@linux.alibaba.com>
To:     Wenjia Zhang <wenjia@linux.ibm.com>
Cc:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-s390@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Karsten Graul <kgraul@linux.ibm.com>,
        Alexandra Winter <wintera@linux.ibm.com>,
        Jan Karcher <jaka@linux.ibm.com>,
        Stefan Raspl <raspl@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>
Subject: Re: [PATCH net 2/2] net/smc: Fix device de-init sequence
Message-ID: <ZA8Fxe8wKM5zrjNO@TONYMAC-ALIBABA.local>
Reply-To: Tony Lu <tonylu@linux.alibaba.com>
References: <20230313100829.13136-1-wenjia@linux.ibm.com>
 <20230313100829.13136-3-wenjia@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230313100829.13136-3-wenjia@linux.ibm.com>
X-Spam-Status: No, score=-9.9 required=5.0 tests=BAYES_00,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        UNPARSEABLE_RELAY,USER_IN_DEF_SPF_WL autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Mar 13, 2023 at 11:08:29AM +0100, Wenjia Zhang wrote:
> From: Stefan Raspl <raspl@linux.ibm.com>
> 
> CLC message initialization was not properly reversed in error handling path.
> 
> Reported-and-suggested-by: Alexander Gordeev <agordeev@linux.ibm.com>
> Signed-off-by: Stefan Raspl <raspl@linux.ibm.com>
> Signed-off-by: Wenjia Zhang <wenjia@linux.ibm.com>

Reviewed-by: Tony Lu <tonylu@linux.alibaba.com>

Thanks, LGTM.

> ---
>  net/smc/af_smc.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/net/smc/af_smc.c b/net/smc/af_smc.c
> index a4cccdfdc00a..50052f53a1dd 100644
> --- a/net/smc/af_smc.c
> +++ b/net/smc/af_smc.c
> @@ -3498,6 +3498,7 @@ static int __init smc_init(void)
>  out_nl:
>  	smc_nl_exit();
>  out_ism:
> +	smc_clc_exit();
>  	smc_ism_exit();
>  out_pernet_subsys_stat:
>  	unregister_pernet_subsys(&smc_net_stat_ops);
> -- 
> 2.37.2
