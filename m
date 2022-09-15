Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EA5A75BA19A
	for <lists+netdev@lfdr.de>; Thu, 15 Sep 2022 21:50:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229820AbiIOTtX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Sep 2022 15:49:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33488 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229766AbiIOTtV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Sep 2022 15:49:21 -0400
X-Greylist: delayed 2872 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Thu, 15 Sep 2022 12:49:18 PDT
Received: from mx10lb.world4you.com (mx10lb.world4you.com [81.19.149.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F97C6F55E;
        Thu, 15 Sep 2022 12:49:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=engleder-embedded.com; s=dkim11; h=Content-Transfer-Encoding:Content-Type:
        In-Reply-To:From:References:Cc:To:Subject:MIME-Version:Date:Message-ID:Sender
        :Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=OYH7Z+byB/1aOr368+THmqOX44j6sd7O1jhzmR6xE94=; b=jH9G2W9FYD1pnqOk0qyV5O8Pq7
        2lHD+7ddODU8pBfY6LzI21nrnqkkuGkrJmVbDSk4B4XQrLcFvgDSCMJNYkcwaAnJAizGlJIdR4Fth
        NyLs+h1GfhyeqTkR6U0WlC4WzCWeMdyN/m4fG8syw/MDUpBqzg8AQNXG7weKyGA+A3fk=;
Received: from [88.117.54.199] (helo=[10.0.0.160])
        by mx10lb.world4you.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <gerhard@engleder-embedded.com>)
        id 1oYu6x-0005iu-Vx; Thu, 15 Sep 2022 21:01:20 +0200
Message-ID: <ecf497e3-8934-1046-818e-4ee5dc5889eb@engleder-embedded.com>
Date:   Thu, 15 Sep 2022 21:01:19 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [PATCH net-next 10/13] tsnep: deny tc-taprio changes to per-tc
 max SDU
Content-Language: en-US
To:     Vladimir Oltean <vladimir.oltean@nxp.com>, netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        Rui Sousa <rui.sousa@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Michael Walle <michael@walle.cc>,
        Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        Maxim Kochetkov <fido_max@inbox.ru>,
        Colin Foster <colin.foster@in-advantage.com>,
        Richie Pearn <richard.pearn@nxp.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Vladimir Oltean <olteanv@gmail.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        linux-kernel@vger.kernel.org
References: <20220914153303.1792444-1-vladimir.oltean@nxp.com>
 <20220914153303.1792444-11-vladimir.oltean@nxp.com>
From:   Gerhard Engleder <gerhard@engleder-embedded.com>
In-Reply-To: <20220914153303.1792444-11-vladimir.oltean@nxp.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-AV-Do-Run: Yes
X-Spam-Status: No, score=-3.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H3,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Since the driver does not act upon the max_sdu argument, deny any other
> values except the default all-zeroes, which means that all traffic
> classes should use the same MTU as the port itself.
> 
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> ---
>   drivers/net/ethernet/engleder/tsnep_tc.c | 6 +++++-
>   1 file changed, 5 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/net/ethernet/engleder/tsnep_tc.c b/drivers/net/ethernet/engleder/tsnep_tc.c
> index c4c6e1357317..82df837ffc54 100644
> --- a/drivers/net/ethernet/engleder/tsnep_tc.c
> +++ b/drivers/net/ethernet/engleder/tsnep_tc.c
> @@ -320,11 +320,15 @@ static int tsnep_taprio(struct tsnep_adapter *adapter,
>   {
>   	struct tsnep_gcl *gcl;
>   	struct tsnep_gcl *curr;
> -	int retval;
> +	int retval, tc;
>   
>   	if (!adapter->gate_control)
>   		return -EOPNOTSUPP;
>   
> +	for (tc = 0; tc < TC_MAX_QUEUE; tc++)
> +		if (qopt->max_sdu[tc])
> +			return -EOPNOTSUPP;

Does it make any difference if the MAC already guarantees that too
long frames, which would violate the next taprio interval, will not
be transmitted? MACs are able to do that, switches not.

The user could be informed, that the MAC is considering the length of 
the frames by accepting any max_sdu value lower than the MTU of the netdev.
