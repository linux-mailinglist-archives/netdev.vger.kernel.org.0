Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CD4AE60D579
	for <lists+netdev@lfdr.de>; Tue, 25 Oct 2022 22:24:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232868AbiJYUYK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Oct 2022 16:24:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37074 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232805AbiJYUYF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Oct 2022 16:24:05 -0400
X-Greylist: delayed 370 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Tue, 25 Oct 2022 13:24:04 PDT
Received: from m-r1.th.seeweb.it (m-r1.th.seeweb.it [5.144.164.170])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B5B7DD0391
        for <netdev@vger.kernel.org>; Tue, 25 Oct 2022 13:24:04 -0700 (PDT)
Received: from cp.tophost.it (vm1054.cs12.seeweb.it [217.64.195.253])
        by m-r1.th.seeweb.it (Postfix) with ESMTPA id 9ECA420210;
        Tue, 25 Oct 2022 22:17:52 +0200 (CEST)
MIME-Version: 1.0
Date:   Tue, 25 Oct 2022 23:01:55 +0300
From:   Jami Kettunen <jami.kettunen@somainline.org>
To:     Caleb Connolly <caleb.connolly@linaro.org>
Cc:     Alex Elder <elder@linaro.org>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Alex Elder <elder@kernel.org>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH] net: ipa: don't configure IDLE_INDICATION on v3.1
In-Reply-To: <20221024234850.4049778-1-caleb.connolly@linaro.org>
References: <20221024234850.4049778-1-caleb.connolly@linaro.org>
User-Agent: Roundcube Webmail/1.4.6
Message-ID: <37e3f35ab495ab26e506a5619172092c@somainline.org>
X-Sender: jami.kettunen@somainline.org
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 25.10.2022 02:48, Caleb Connolly wrote:
> IPA v3.1 doesn't support the IDLE_INDICATION_CFG register, this was
> causing a harmless splat in ipa_idle_indication_cfg(), add a version
> check to prevent trying to fetch this register on v3.1
> 
> Fixes: 6a244b75cfab ("net: ipa: introduce ipa_reg()")
> Signed-off-by: Caleb Connolly <caleb.connolly@linaro.org>

Tested-by: Jami Kettunen <jami.kettunen@somainline.org>

> ---
> This will need to wait for Jami's Tested-by as I don't have any v3.1 
> hardware.
> ---
>  drivers/net/ipa/ipa_main.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/drivers/net/ipa/ipa_main.c b/drivers/net/ipa/ipa_main.c
> index 3461ad3029ab..49537fccf6ad 100644
> --- a/drivers/net/ipa/ipa_main.c
> +++ b/drivers/net/ipa/ipa_main.c
> @@ -434,6 +434,9 @@ static void ipa_idle_indication_cfg(struct ipa 
> *ipa,
>  	const struct ipa_reg *reg;
>  	u32 val;
> 
> +	if (ipa->version < IPA_VERSION_3_5_1)
> +		return;
> +
>  	reg = ipa_reg(ipa, IDLE_INDICATION_CFG);
>  	val = ipa_reg_encode(reg, ENTER_IDLE_DEBOUNCE_THRESH,
>  			     enter_idle_debounce_thresh);
