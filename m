Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3397D559E92
	for <lists+netdev@lfdr.de>; Fri, 24 Jun 2022 18:33:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230016AbiFXQb0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Jun 2022 12:31:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58304 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229605AbiFXQbZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Jun 2022 12:31:25 -0400
Received: from alexa-out-sd-01.qualcomm.com (alexa-out-sd-01.qualcomm.com [199.106.114.38])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C5C650B2B;
        Fri, 24 Jun 2022 09:31:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=quicinc.com; i=@quicinc.com; q=dns/txt; s=qcdkim;
  t=1656088285; x=1687624285;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=gvN50YTRbbw/CZbnbMbOb1TEK/TeMnMyqf/OR0LURDo=;
  b=Iz9RJy8/dEyC9gJ6UX3YjRORilXyvUEdP3tQk4iq5gnU6wOUL9OLaF+6
   mcHHPn9bRUCq92e+VrXuYWBT91cVA4XZOK/CrdrWFeUy2O8IWQfBtTqP2
   fIPTvk1LpJ3VwAmkTKSQ7I2wCc2zR9hb8oklvOi8sFl3wmYUuryDKSC9D
   U=;
Received: from unknown (HELO ironmsg04-sd.qualcomm.com) ([10.53.140.144])
  by alexa-out-sd-01.qualcomm.com with ESMTP; 24 Jun 2022 09:31:25 -0700
X-QCInternal: smtphost
Received: from nasanex01c.na.qualcomm.com ([10.47.97.222])
  by ironmsg04-sd.qualcomm.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Jun 2022 09:31:24 -0700
Received: from nalasex01a.na.qualcomm.com (10.47.209.196) by
 nasanex01c.na.qualcomm.com (10.47.97.222) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.22; Fri, 24 Jun 2022 09:31:24 -0700
Received: from [10.110.111.5] (10.80.80.8) by nalasex01a.na.qualcomm.com
 (10.47.209.196) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.22; Fri, 24 Jun
 2022 09:31:23 -0700
Message-ID: <3013994a-487c-56eb-42d6-b8cdf7615405@quicinc.com>
Date:   Fri, 24 Jun 2022 09:31:22 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [PATCH v2] brcmfmac: Remove #ifdef guards for PM related
 functions
Content-Language: en-US
To:     Arend Van Spriel <aspriel@gmail.com>,
        Paul Cercueil <paul@crapouillou.net>,
        Franky Lin <franky.lin@broadcom.com>
CC:     <linux-wireless@vger.kernel.org>,
        <brcm80211-dev-list.pdl@broadcom.com>,
        <SHA-cyfmac-dev-list@infineon.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
References: <20220623124221.18238-1-paul@crapouillou.net>
 <9f623bb6-8957-0a9a-3eb7-9a209965ea6e@gmail.com>
From:   Jeff Johnson <quic_jjohnson@quicinc.com>
In-Reply-To: <9f623bb6-8957-0a9a-3eb7-9a209965ea6e@gmail.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.80.80.8]
X-ClientProxiedBy: nasanex01b.na.qualcomm.com (10.46.141.250) To
 nalasex01a.na.qualcomm.com (10.47.209.196)
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 6/24/2022 2:24 AM, Arend Van Spriel wrote:
> On 6/23/2022 2:42 PM, Paul Cercueil wrote:

[snip]

>> -    if (sdiodev->freezer) {
>> +    if (IS_ENABLED(CONFIG_PM_SLEEP) && sdiodev->freezer) {
> 
> This change is not necessary. sdiodev->freezer will be NULL when 
> CONFIG_PM_SLEEP is not enabled.

but won't the compiler be able to completely optimize the code away if 
the change is present?
