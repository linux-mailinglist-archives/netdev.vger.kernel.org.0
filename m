Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8A0A14E3C82
	for <lists+netdev@lfdr.de>; Tue, 22 Mar 2022 11:34:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233048AbiCVKgI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Mar 2022 06:36:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47810 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232184AbiCVKgH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Mar 2022 06:36:07 -0400
Received: from lelv0142.ext.ti.com (lelv0142.ext.ti.com [198.47.23.249])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 97F343BFB7;
        Tue, 22 Mar 2022 03:34:40 -0700 (PDT)
Received: from fllv0035.itg.ti.com ([10.64.41.0])
        by lelv0142.ext.ti.com (8.15.2/8.15.2) with ESMTP id 22MAYTd8007542;
        Tue, 22 Mar 2022 05:34:29 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1647945269;
        bh=z85hXA83Hzf523x7WLNEaVagsOyI5OrDZfXKUsO1vKQ=;
        h=Date:Subject:To:CC:References:From:In-Reply-To;
        b=q0RbNM8ZxoaNv/4jNqjL21dmOEO8eeAMpeJMouZURFXpE+vsu4uhgMgntZQIfaxOm
         x1eiuSKMUuddadclhXWETP9gILS7O054NZF44ZtFcy4Y/DZbyAq/y3sl1/kcLQ9yPi
         JpzV3JmrtrcJ1xIbYK9cv/dq0Rber/AcGyYRQ3vA=
Received: from DLEE114.ent.ti.com (dlee114.ent.ti.com [157.170.170.25])
        by fllv0035.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 22MAYTNs001820
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 22 Mar 2022 05:34:29 -0500
Received: from DLEE113.ent.ti.com (157.170.170.24) by DLEE114.ent.ti.com
 (157.170.170.25) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2308.14; Tue, 22
 Mar 2022 05:34:29 -0500
Received: from fllv0039.itg.ti.com (10.64.41.19) by DLEE113.ent.ti.com
 (157.170.170.24) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2308.14 via
 Frontend Transport; Tue, 22 Mar 2022 05:34:29 -0500
Received: from [172.24.222.171] (ileax41-snat.itg.ti.com [10.172.224.153])
        by fllv0039.itg.ti.com (8.15.2/8.15.2) with ESMTP id 22MAYQPt111734;
        Tue, 22 Mar 2022 05:34:27 -0500
Message-ID: <d3fac0ae-6d5c-33d7-4e1e-da9058ef525f@ti.com>
Date:   Tue, 22 Mar 2022 16:04:25 +0530
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [PATCH] drivers: ethernet: cpsw: fix panic when interrupt
 coaleceing is set via ethtool
Content-Language: en-US
To:     =?UTF-8?Q?Sondhau=c3=9f=2c_Jan?= <Jan.Sondhauss@wago.com>,
        "grygorii.strashko@ti.com" <grygorii.strashko@ti.com>
CC:     "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>
References: <20220322063221.28132-1-jan.sondhauss@wago.com>
From:   Vignesh Raghavendra <vigneshr@ti.com>
In-Reply-To: <20220322063221.28132-1-jan.sondhauss@wago.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
X-Spam-Status: No, score=-3.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

Adding netdev list and maintainers

Please cc netdev ML and net maintainers

./scripts/get_maintainer.pl -f drivers/net/ethernet/ti/cpsw_ethtool.c

On 22/03/22 12:02 pm, Sondhauß, Jan wrote:
> cpsw_ethtool uses the power management in the begin and complete
> functions of the ethtool_ops. The result of pm_runtime_get_sync was
> returned unconditionally, which results in problems since the ethtool-
> interface relies on 0 for success and negativ values for errors.
> d43c65b05b84 (ethtool: runtime-resume netdev parent in ethnl_ops_begin)
> introduced power management to the netlink implementation for the
> ethtool interface and does not explicitly check for negative return
> values.
> 
> As a result the pm_runtime_suspend function is called one-too-many
> times in ethnl_ops_begin and that leads to an access violation when
> the cpsw hardware is accessed after using
> 'ethtool -C eth-of-cpsw rx-usecs 1234'. To fix this the call to
> pm_runtime_get_sync in cpsw_ethtool_op_begin is replaced with a call
> to pm_runtime_resume_and_get as it provides a returnable error-code.
> 

pm_runtime_resume_and_get() is just wrapper around pm_runtime_get_sync()
+ error handling (as done in the below code) and both return 0 on
success and -ve error code on failure


> Signed-off-by: Jan Sondhauss <jan.sondhauss@wago.com>
> ---
>  drivers/net/ethernet/ti/cpsw_ethtool.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/net/ethernet/ti/cpsw_ethtool.c b/drivers/net/ethernet/ti/cpsw_ethtool.c
> index 158c8d3793f4..5eda20039cc1 100644
> --- a/drivers/net/ethernet/ti/cpsw_ethtool.c
> +++ b/drivers/net/ethernet/ti/cpsw_ethtool.c
> @@ -364,7 +364,7 @@ int cpsw_ethtool_op_begin(struct net_device *ndev)
>  	struct cpsw_common *cpsw = priv->cpsw;
>  	int ret;
>  
> -	ret = pm_runtime_get_sync(cpsw->dev);
> +	ret = pm_runtime_resume_and_get(cpsw->dev)>  	if (ret < 0) {
>  		cpsw_err(priv, drv, "ethtool begin failed %d\n", ret);
>  		pm_runtime_put_noidle(cpsw->dev);


In fact code now ends up calling pm_runtime_put_noidle() twice in case
of failure, once inside pm_runtime_resume_and_get() and again here?

So something looks fishy?

Regards
Vignesh
