Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 73696586554
	for <lists+netdev@lfdr.de>; Mon,  1 Aug 2022 08:48:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232578AbiHAGsA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Aug 2022 02:48:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45766 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234110AbiHAGri (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Aug 2022 02:47:38 -0400
Received: from mail-wm1-x335.google.com (mail-wm1-x335.google.com [IPv6:2a00:1450:4864:20::335])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C1E265F64
        for <netdev@vger.kernel.org>; Sun, 31 Jul 2022 23:46:37 -0700 (PDT)
Received: by mail-wm1-x335.google.com with SMTP id a18-20020a05600c349200b003a30de68697so5821325wmq.0
        for <netdev@vger.kernel.org>; Sun, 31 Jul 2022 23:46:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=h9QjDfGe68LHuacOvTEPYogMVqO2baNYv3xSXqxo4D8=;
        b=Q42lmCJ3y8nu0nPN4Zk33wxRgj5DFXDAJ39rgWHdMPOYNi5Yc+UQy0FyUxiqmLH0A+
         BZfl+JE8MgoZSbJMvEEsuCM4OLwaurYJY7mey0T8Zn1jO40LXdgBjnkRZ3BiAmTCq5Ql
         jI8iLZJgFf/406CsKjhptkr2rqY0v9gGb1TNg0gyYEwqpjI1HbVTpma/76TZuSWs7meE
         6SXlwOpcn5gT7evQE/aN3ejlJQnJlbCIHaB6XuC60QsQn9v0bb0O1MDzZCwqyxO/uxiL
         raIB0dG/+8/eSAtfqM9UKMp0HzPGSLRNa1Fo0AyMtxbNrqtJgQItXYAC409yM+U5hKHP
         gfSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=h9QjDfGe68LHuacOvTEPYogMVqO2baNYv3xSXqxo4D8=;
        b=bJtrR/1V2wVjEANsgpaNbmW8K0WMz3TFEeXZ9Wk6KbeMiGjImO1mSaV1OaWF6xLjw1
         C3kR38Mtrwd08slnerBxvSpLxhtHfO2Q4DgrhWrHoXttzovtKT5/L9dbpoQLMB/CyNh0
         SEDCMazyzc2i/2lZZnX1kZBffOOBMci8HQWN5U4Af8XREmEIpDBVmWXf7Z4S4x+waP7e
         xgwof1UHTlsg04TdmQkcrD3z7hH04k+P7Dj+fJ9rd1yHOVTs9kQeIcJjQCnHNrhLxJKD
         gw5vxzDP2ZQf4M8DZMOZYuKy19iEOaBk92zH04ZOiXqW5SB4rRU1OPdsDjQWuAX/d8I5
         Z/rA==
X-Gm-Message-State: AJIora/YFL4Zy/YOh42oitY47vEzVpZ0PNoonKM9SHy3S6gm2MRIkm8S
        WfHLMAadJhPK0J76oKI5MFs=
X-Google-Smtp-Source: AGRyM1t6dpJTKhQGMEyUAW2Pc7f0CwZM+TtcayLgVMketyVwaYtzzi3gUxvKid8TsA/rSGCSeo3R3w==
X-Received: by 2002:a05:600c:1c0f:b0:3a3:188b:cb47 with SMTP id j15-20020a05600c1c0f00b003a3188bcb47mr10395018wms.45.1659336396308;
        Sun, 31 Jul 2022 23:46:36 -0700 (PDT)
Received: from [192.168.0.104] ([77.126.166.31])
        by smtp.gmail.com with ESMTPSA id j20-20020a05600c1c1400b003a319b67f64sm28939723wms.0.2022.07.31.23.46.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 31 Jul 2022 23:46:35 -0700 (PDT)
Message-ID: <3eb2c9a2-9626-f9ce-222b-0b858ab08bfa@gmail.com>
Date:   Mon, 1 Aug 2022 09:46:32 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH net-next V3 2/6] net/tls: Multi-threaded calls to TX
 tls_dev_del
Content-Language: en-US
To:     Jakub Kicinski <kuba@kernel.org>, Tariq Toukan <tariqt@nvidia.com>
Cc:     Boris Pismenny <borisp@nvidia.com>,
        John Fastabend <john.fastabend@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        Saeed Mahameed <saeedm@nvidia.com>,
        Gal Pressman <gal@nvidia.com>,
        Maxim Mikityanskiy <maximmi@nvidia.com>
References: <20220727094346.10540-1-tariqt@nvidia.com>
 <20220727094346.10540-3-tariqt@nvidia.com>
 <20220728215613.3dfa0ac9@kernel.org>
From:   Tariq Toukan <ttoukan.linux@gmail.com>
In-Reply-To: <20220728215613.3dfa0ac9@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 7/29/2022 7:56 AM, Jakub Kicinski wrote:
> On Wed, 27 Jul 2022 12:43:42 +0300 Tariq Toukan wrote:
>> +	flush_workqueue(destruct_wq);
>> +	destroy_workqueue(destruct_wq);
> 
> IIRC destroy does a flush internally, please follow up.

I'll followup with a cleanup patch.
Thanks.
