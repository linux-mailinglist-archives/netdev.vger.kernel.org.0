Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 455065025E8
	for <lists+netdev@lfdr.de>; Fri, 15 Apr 2022 08:56:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350796AbiDOG7E (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Apr 2022 02:59:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42296 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232878AbiDOG7D (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Apr 2022 02:59:03 -0400
Received: from alexa-out-sd-01.qualcomm.com (alexa-out-sd-01.qualcomm.com [199.106.114.38])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F24803E0C5;
        Thu, 14 Apr 2022 23:56:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=quicinc.com; i=@quicinc.com; q=dns/txt; s=qcdkim;
  t=1650005796; x=1681541796;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=t2JyKHgJzNVEtMBMT1fofHfCUqQE1R9r4NG3h8NrjI8=;
  b=pvbwW0C11+qnWdAWxaMiAxY+2P/cTne0DGa4ZqeS6O+jLKCD5Tj+W/wF
   cFRNpBX53q3wRFllrI8Aen0FbYMqKnuy+c/KU+6jILOY/4qx6o9mA95YC
   RWSvuo0kYbOqVEobHODd5yw9r+ZZ8hqZibQ7uVnrEX17oi3qoTPKLpU2o
   4=;
Received: from unknown (HELO ironmsg02-sd.qualcomm.com) ([10.53.140.142])
  by alexa-out-sd-01.qualcomm.com with ESMTP; 14 Apr 2022 23:56:35 -0700
X-QCInternal: smtphost
Received: from nasanex01c.na.qualcomm.com ([10.47.97.222])
  by ironmsg02-sd.qualcomm.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Apr 2022 23:56:36 -0700
Received: from nalasex01a.na.qualcomm.com (10.47.209.196) by
 nasanex01c.na.qualcomm.com (10.47.97.222) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.22; Thu, 14 Apr 2022 23:56:34 -0700
Received: from [10.253.8.85] (10.80.80.8) by nalasex01a.na.qualcomm.com
 (10.47.209.196) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.22; Thu, 14 Apr
 2022 23:56:31 -0700
Message-ID: <c503b9b8-062d-d8c8-1d9f-106602dd31c4@quicinc.com>
Date:   Fri, 15 Apr 2022 14:56:29 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [PATCH] ath11k: simplify if-if to if-else
Content-Language: en-US
To:     Benjamin Poirier <benjamin.poirier@gmail.com>,
        Yihao Han <hanyihao@vivo.com>
CC:     Kalle Valo <kvalo@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, <ath11k@lists.infradead.org>,
        <linux-wireless@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <kernel@vivo.com>
References: <20220414092042.78152-1-hanyihao@vivo.com> <YlkN1FsTd0Bozz0K@d3>
From:   Wen Gong <quic_wgong@quicinc.com>
In-Reply-To: <YlkN1FsTd0Bozz0K@d3>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.80.80.8]
X-ClientProxiedBy: nasanex01a.na.qualcomm.com (10.52.223.231) To
 nalasex01a.na.qualcomm.com (10.47.209.196)
X-Spam-Status: No, score=-6.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 4/15/2022 2:16 PM, Benjamin Poirier wrote:
> On 2022-04-14 02:20 -0700, Yihao Han wrote:
...
> It seems there is no synchronization around is_reset but is it
> guaranteed that it cannot be changed by ath11k_core_reset() between the
> two tests? I'm not familiar with the driver.

ath11k_core_reset() has logic to avoid muti-reset in the same time.

it means it has one recovery work doing for each time.

