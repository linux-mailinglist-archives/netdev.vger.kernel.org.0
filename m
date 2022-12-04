Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CD585641F05
	for <lists+netdev@lfdr.de>; Sun,  4 Dec 2022 19:58:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230292AbiLDS6e (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 4 Dec 2022 13:58:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57650 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230242AbiLDS6b (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 4 Dec 2022 13:58:31 -0500
Received: from mail-ej1-x62c.google.com (mail-ej1-x62c.google.com [IPv6:2a00:1450:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8409013F56;
        Sun,  4 Dec 2022 10:58:27 -0800 (PST)
Received: by mail-ej1-x62c.google.com with SMTP id fc4so16088738ejc.12;
        Sun, 04 Dec 2022 10:58:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=3vGbnOeq4kzljzirvL5pjkAxrpSozfhAG6ODaOPHYw4=;
        b=SK+J0e+cOF/gJbHdLxeV7lh37lbbvFSCOUHLAc5Bz2c7Gep4IX9vNEDlsq1rBER3C9
         eEcrqt9aSrGir+v/mK8rWOSE1jU9xY5I21o+B3WyW646xZ7o9EgWPM38Z669uLk1lY/R
         53Aer7L/UtA27fo/AQqxuehOcbxuyp1m9zqC1HD56dGoQs7j7wHg0FhAePCMOd+LNof3
         8lk7yILEv2YOHjyedBQg/rDiGO+pST3ju+QQScTTp7TRZjiK7lRrkUdvAPGeS8zvpHh/
         QXvs8k/MigJPFlxy3U46QJDTSyfqvsC+NlK6x+lXXLix61KS4vv08Ni8b9vFUX8OFNu+
         2qEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=3vGbnOeq4kzljzirvL5pjkAxrpSozfhAG6ODaOPHYw4=;
        b=x0soWV+29Y110MFwE1D8BxQV1nlaYrzPFXZRyToh47QA8MmUcdNZCtmUCIPIaCEh3X
         izndXHzYXdfT2pHD0OBCHG7+YAPYp3GceIoJVkSF407WgYHi0E5ewUs3U17WgDZcI8sT
         97c/mWJhH+FDPgPjnrPlA0o+3s9V8KjqGHERriXRT+wgl5o7/ey44yS4hwuCdu0kZuaj
         6p+4v2zfzBqtdt+2tWmH1b2u3DBarQNiFGV+R5I4iNG7v3Qtq0x3hfNCJq/pE9ytG2CT
         ZOG4R7SxFhOXzVOeOxSYWsfhPVP91VUHyftsDmop1gZxK7xBUVlq9aOLuriLM7k8X/6T
         1YOg==
X-Gm-Message-State: ANoB5pnWHj17O6zK+/HrQx2ibvWMTtxuggxBqv3hodeXY1UYaZ57MYJm
        OmxvNYwPHj0tXUqTBO8Bn+I=
X-Google-Smtp-Source: AA0mqf5Gj2MsqoFIDKKOFMrWYTOn+mbcGYyONEEDMSyUgTJV4h6G/l5VpcvYCMpWn0W7OFj1jdllyw==
X-Received: by 2002:a17:906:7953:b0:7bf:944e:cf6e with SMTP id l19-20020a170906795300b007bf944ecf6emr28321277ejo.638.1670180306173;
        Sun, 04 Dec 2022 10:58:26 -0800 (PST)
Received: from [192.168.1.101] ([37.252.91.128])
        by smtp.gmail.com with ESMTPSA id 14-20020a170906318e00b007aed2057ea1sm5342266ejy.167.2022.12.04.10.58.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 04 Dec 2022 10:58:25 -0800 (PST)
Message-ID: <14db8809-6144-1d10-59e7-298079b2e6e2@gmail.com>
Date:   Sun, 4 Dec 2022 22:58:21 +0400
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
Subject: Re: [PATCH net-next v1 02/13] net: wwan: tmi: Add buffer management
Content-Language: en-US
To:     Yanchao Yang <yanchao.yang@mediatek.com>,
        Loic Poulain <loic.poulain@linaro.org>,
        Johannes Berg <johannes@sipsolutions.net>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        netdev ML <netdev@vger.kernel.org>,
        kernel ML <linux-kernel@vger.kernel.org>
Cc:     MTK ML <linux-mediatek@lists.infradead.org>,
        Liang Lu <liang.lu@mediatek.com>,
        Haijun Liu <haijun.liu@mediatek.com>,
        Hua Yang <hua.yang@mediatek.com>,
        Ting Wang <ting.wang@mediatek.com>,
        Felix Chen <felix.chen@mediatek.com>,
        Mingliang Xu <mingliang.xu@mediatek.com>,
        Min Dong <min.dong@mediatek.com>,
        Aiden Wang <aiden.wang@mediatek.com>,
        Guohao Zhang <guohao.zhang@mediatek.com>,
        Chris Feng <chris.feng@mediatek.com>,
        Lambert Wang <lambert.wang@mediatek.com>,
        Mingchuang Qiao <mingchuang.qiao@mediatek.com>,
        Xiayu Zhang <xiayu.zhang@mediatek.com>,
        Haozhe Chang <haozhe.chang@mediatek.com>,
        MediaTek Corporation <linuxwwan@mediatek.com>
References: <20221122111152.160377-1-yanchao.yang@mediatek.com>
 <20221122111152.160377-3-yanchao.yang@mediatek.com>
From:   Sergey Ryazanov <ryazanov.s.a@gmail.com>
In-Reply-To: <20221122111152.160377-3-yanchao.yang@mediatek.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 22.11.2022 15:11, Yanchao Yang wrote:
> From: MediaTek Corporation <linuxwwan@mediatek.com>
> 
> To malloc I/O memory as soon as possible, buffer management comes into being.
> It creates buffer pools that reserve some buffers through deferred works when
> the driver isn't busy.
> 
> The buffer management provides unified memory allocation/de-allocation
> interfaces for other modules. It supports two buffer types of SKB and page.
> Two reload work queues with different priority values are provided to meet
> various requirements of the control plane and the data plane.
> 
> When the reserved buffer count of the pool is less than a threshold (default
> is 2/3 of the pool size), the reload work will restart to allocate buffers
> from the OS until the buffer pool becomes full. When the buffer pool fills,
> the OS will recycle the buffer freed by the user.
> 
> Signed-off-by: Mingliang Xu <mingliang.xu@mediatek.com>
> Signed-off-by: MediaTek Corporation <linuxwwan@mediatek.com>
> ---
>   drivers/net/wwan/mediatek/Makefile  |   3 +-
>   drivers/net/wwan/mediatek/mtk_bm.c  | 369 ++++++++++++++++++++++++++++
>   drivers/net/wwan/mediatek/mtk_bm.h  |  79 ++++++
>   drivers/net/wwan/mediatek/mtk_dev.c |  11 +-
>   drivers/net/wwan/mediatek/mtk_dev.h |   1 +
>   5 files changed, 461 insertions(+), 2 deletions(-)
>   create mode 100644 drivers/net/wwan/mediatek/mtk_bm.c
>   create mode 100644 drivers/net/wwan/mediatek/mtk_bm.h

Yanchao, can you share some numbers, how this custom pool is outperform 
the regular kernel allocator?

--
Sergey
