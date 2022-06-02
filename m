Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2453E53BFDD
	for <lists+netdev@lfdr.de>; Thu,  2 Jun 2022 22:33:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239094AbiFBUdL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Jun 2022 16:33:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60446 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239089AbiFBUdJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Jun 2022 16:33:09 -0400
Received: from alexa-out.qualcomm.com (alexa-out.qualcomm.com [129.46.98.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 529606347;
        Thu,  2 Jun 2022 13:32:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=quicinc.com; i=@quicinc.com; q=dns/txt; s=qcdkim;
  t=1654201973; x=1685737973;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=+du9GzzlWKEsruJA9NU+7ALtUd7QizBWgQcaYZZVG08=;
  b=js+kgwVj3icCHPEYChJ+I7PlwtEFTudqs24ENkjByXhkaAOgJZBn7lz3
   fYo3Sxgtq9ndotRrU783H9Z0SGyZ2KpT3xxETMusu/SyeXcAVHfyX4p56
   gTTPrgSMzucrx6Aq5xXNxhxW81MXwB5/ygFjYtIr8sObYhW8EjZU8Uejp
   8=;
Received: from ironmsg-lv-alpha.qualcomm.com ([10.47.202.13])
  by alexa-out.qualcomm.com with ESMTP; 02 Jun 2022 13:32:52 -0700
X-QCInternal: smtphost
Received: from nasanex01c.na.qualcomm.com ([10.47.97.222])
  by ironmsg-lv-alpha.qualcomm.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Jun 2022 13:32:51 -0700
Received: from nalasex01a.na.qualcomm.com (10.47.209.196) by
 nasanex01c.na.qualcomm.com (10.47.97.222) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.22; Thu, 2 Jun 2022 13:32:51 -0700
Received: from [10.110.9.238] (10.80.80.8) by nalasex01a.na.qualcomm.com
 (10.47.209.196) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.22; Thu, 2 Jun 2022
 13:32:49 -0700
Message-ID: <e8d9d010-7fa1-da61-feeb-43f0a101a323@quicinc.com>
Date:   Thu, 2 Jun 2022 13:32:48 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [PATCH v4 1/2] devcoredump: remove the useless gfp_t parameter in
 dev_coredumpv
Content-Language: en-US
To:     Duoming Zhou <duoming@zju.edu.cn>,
        <linux-wireless@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC:     <amitkarwar@gmail.com>, <ganapathi017@gmail.com>,
        <sharvari.harisangam@nxp.com>, <huxinming820@gmail.com>,
        <kvalo@kernel.org>, <davem@davemloft.net>, <edumazet@google.com>,
        <kuba@kernel.org>, <pabeni@redhat.com>, <netdev@vger.kernel.org>,
        <gregkh@linuxfoundation.org>, <johannes@sipsolutions.net>,
        <rafael@kernel.org>
References: <cover.1654175941.git.duoming@zju.edu.cn>
 <338a65fe8f30d23339cfc09fe1fb7be751ad655b.1654175941.git.duoming@zju.edu.cn>
From:   Jeff Johnson <quic_jjohnson@quicinc.com>
In-Reply-To: <338a65fe8f30d23339cfc09fe1fb7be751ad655b.1654175941.git.duoming@zju.edu.cn>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.80.80.8]
X-ClientProxiedBy: nasanex01a.na.qualcomm.com (10.52.223.231) To
 nalasex01a.na.qualcomm.com (10.47.209.196)
X-Spam-Status: No, score=-7.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 6/2/2022 6:33 AM, Duoming Zhou wrote:
> The dev_coredumpv() could not be used in atomic context, because
> it calls kvasprintf_const() and kstrdup() with GFP_KERNEL parameter.
> The process is shown below:
> 
> dev_coredumpv(..., gfp_t gfp)
>    dev_coredumpm
>      dev_set_name
>        kobject_set_name_vargs
>          kvasprintf_const(GFP_KERNEL, ...); //may sleep
>            kstrdup(s, GFP_KERNEL); //may sleep
> 
> This patch removes gfp_t parameter of dev_coredumpv() and changes the
> gfp_t parameter of dev_coredumpm() to GFP_KERNEL in order to show
> dev_coredumpv() could not be used in atomic context.

shouldn't you remove the gfp parameter to dev_coredumpm() as well since 
it is actually within that function where dev_set_name() is called which 
cannot be done in atomic context?
