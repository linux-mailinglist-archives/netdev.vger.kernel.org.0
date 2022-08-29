Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 72FFA5A50DB
	for <lists+netdev@lfdr.de>; Mon, 29 Aug 2022 18:00:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229552AbiH2QA4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Aug 2022 12:00:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43248 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229481AbiH2QAz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Aug 2022 12:00:55 -0400
Received: from out30-42.freemail.mail.aliyun.com (out30-42.freemail.mail.aliyun.com [115.124.30.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7692165554;
        Mon, 29 Aug 2022 09:00:51 -0700 (PDT)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R121e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018046056;MF=tonylu@linux.alibaba.com;NM=1;PH=DS;RN=10;SR=0;TI=SMTPD_---0VNg0tWl_1661788845;
Received: from localhost(mailfrom:tonylu@linux.alibaba.com fp:SMTPD_---0VNg0tWl_1661788845)
          by smtp.aliyun-inc.com;
          Tue, 30 Aug 2022 00:00:46 +0800
Date:   Tue, 30 Aug 2022 00:00:45 +0800
From:   Tony Lu <tonylu@linux.alibaba.com>
To:     liuyacan@corp.netease.com
Cc:     kgraul@linux.ibm.com, davem@davemloft.net, wenjia@linux.ibm.com,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        linux-s390@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net] net/smc: Remove redundant refcount increase
Message-ID: <YwzirUcxlQW3ydT7@TonyMac-Alibaba>
Reply-To: Tony Lu <tonylu@linux.alibaba.com>
References: <20220829145329.2751578-1-liuyacan@corp.netease.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220829145329.2751578-1-liuyacan@corp.netease.com>
X-Spam-Status: No, score=-9.9 required=5.0 tests=BAYES_00,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,UNPARSEABLE_RELAY,
        USER_IN_DEF_SPF_WL autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Aug 29, 2022 at 10:53:29PM +0800, liuyacan@corp.netease.com wrote:
> From: liuyacan <liuyacan@corp.netease.com>
> 
> For passive connections, the refcount increment has been done in
> smc_clcsock_accept()-->smc_sock_alloc().
> 
> Fixes: 3b2dec2603d5("net/smc: restructure client and server code in af_smc")
> Signed-off-by: liuyacan <liuyacan@corp.netease.com>
> ---
>  net/smc/af_smc.c | 1 -
>  1 file changed, 1 deletion(-)
> 
> diff --git a/net/smc/af_smc.c b/net/smc/af_smc.c
> index 79c1318af..0939cc3b9 100644
> --- a/net/smc/af_smc.c
> +++ b/net/smc/af_smc.c
> @@ -1855,7 +1855,6 @@ static void smc_listen_out_connected(struct smc_sock *new_smc)
>  {
>  	struct sock *newsmcsk = &new_smc->sk;
>  
> -	sk_refcnt_debug_inc(newsmcsk);
>  	if (newsmcsk->sk_state == SMC_INIT)

Thank you for the fixes, I will test it in the CI.

Thanks.
Tony Lu
