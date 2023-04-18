Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AD4766E697E
	for <lists+netdev@lfdr.de>; Tue, 18 Apr 2023 18:28:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232489AbjDRQ2I (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Apr 2023 12:28:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41636 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232238AbjDRQ2F (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Apr 2023 12:28:05 -0400
Received: from mail-wm1-x32e.google.com (mail-wm1-x32e.google.com [IPv6:2a00:1450:4864:20::32e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 57D22B744
        for <netdev@vger.kernel.org>; Tue, 18 Apr 2023 09:27:59 -0700 (PDT)
Received: by mail-wm1-x32e.google.com with SMTP id gw13so15831066wmb.3
        for <netdev@vger.kernel.org>; Tue, 18 Apr 2023 09:27:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=6wind.com; s=google; t=1681835278; x=1684427278;
        h=content-transfer-encoding:in-reply-to:organization:from
         :content-language:references:cc:to:subject:reply-to:user-agent
         :mime-version:date:message-id:from:to:cc:subject:date:message-id
         :reply-to;
        bh=VHFAu/Pkzz++wthwM9zpAnztDwxSCp0JA1YrB1N1PrY=;
        b=C03F9yonfiBS3thbAFqIANDsXfPLN8dHmbcS/nCWeiCoKC6efPnCJ+ADGY7GAmz2gh
         L+u/IA4DCfK4s0RLntId9yKbPG6igVQFsdl94JPxsnBurMEewenJtEgzsudMyFPH1FDa
         J437W8pl+XLFUwXRn/0tVUcBoLa6p67Dewy2paw7avM4X+sNoxWZTEDgG/8ZXlwbPKml
         ggfhszyLOp6P4TFZg0xh/JVn14Yu/eBZPSTuJDSiiGpvbdSPw2LlF9ZzWUg5YKy4qsI7
         QXtHhui9DemwnGWXSZRWmNoWNVX+aZxtiyvGo9aYjtztSe5tx/2Q4vASAw7d/I602jzK
         KQiw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681835278; x=1684427278;
        h=content-transfer-encoding:in-reply-to:organization:from
         :content-language:references:cc:to:subject:reply-to:user-agent
         :mime-version:date:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=VHFAu/Pkzz++wthwM9zpAnztDwxSCp0JA1YrB1N1PrY=;
        b=EinvffK9LeJ6TAtxN+tLUpyoob6Av142M3lZNqu8THzztr2NcJbwkVcjVF2dzwrTHY
         vkdE5oZzD7Ze5i3SRYCp4f9bPEYvRcNDQis1uPeF8heeOXYzJiSeufYM8PDFSkmbKB1k
         1Dhr7/1XKU+EyEolGE4mQhjRgoXApeBPn1xr3VD3iJUPEoAgVYahB4fHlgVbB0mVuX+/
         iSerl8UXSi2P9LBPTzWAZ3e23gnJrDfHdO3YJbyfY1mJc5VZMnVTQikMIvta/9a9iifv
         2X+PZfq57sjDFav//voJ4rqO8nN0eI30kKy3MlJhEdf4GxFr5hO22P6s3TxCeNddQ3uy
         LMmA==
X-Gm-Message-State: AAQBX9dspiXBk/ZeiEaqkfS4TMREHSh1m/RWsMvKJj2vsmCskEkYi5Sr
        SwMe8q7kGk1pkQOlgIRKQ9TWVSrnwIE4SZcNdAo=
X-Google-Smtp-Source: AKy350aVrWRnR1WtW0ASoAiOd6k1O9lvBixQEb2mEbtXRFPS4noMn9dV6CNExj2Ut/VBfH2f7qjbWw==
X-Received: by 2002:a05:600c:3644:b0:3f1:738f:d3d1 with SMTP id y4-20020a05600c364400b003f1738fd3d1mr5582067wmq.4.1681835277830;
        Tue, 18 Apr 2023 09:27:57 -0700 (PDT)
Received: from ?IPV6:2a01:e0a:b41:c160:6292:8e04:809:ea49? ([2a01:e0a:b41:c160:6292:8e04:809:ea49])
        by smtp.gmail.com with ESMTPSA id v10-20020a05600c470a00b003ef36ef3833sm19444941wmo.8.2023.04.18.09.27.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 18 Apr 2023 09:27:56 -0700 (PDT)
Message-ID: <6590d33f-6020-81c7-7a7e-f970537ddc8e@6wind.com>
Date:   Tue, 18 Apr 2023 18:27:56 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Reply-To: nicolas.dichtel@6wind.com
Subject: Re: Performance decrease in ipt_do_table
To:     "pengyi (M)" <pengyi37@huawei.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "dsahern@kernel.org" <dsahern@kernel.org>,
        "pablo@netfilter.org" <pablo@netfilter.org>
Cc:     Caowangbao <caowangbao@huawei.com>, liaichun <liaichun@huawei.com>,
        "Yanan (Euler)" <yanan@huawei.com>
References: <53c3ce9d3a6e44b193e89744610c192b@huawei.com>
Content-Language: en-US
From:   Nicolas Dichtel <nicolas.dichtel@6wind.com>
Organization: 6WIND
In-Reply-To: <53c3ce9d3a6e44b193e89744610c192b@huawei.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.7 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Le 18/04/2023 à 16:37, pengyi (M) a écrit :
> Hi, I found after the commit d43b75fbc23f [vrf: don't run conntrack on vrf with !dflt qdisc] in vrf.c , the performance of ipt_do_table decreased. In vrf.c, the locally generated packet was marked as "untracked" in vrf_ip_out, because it won't be processed by the router(also mentioned in commit. d43b75fbc23f). And it will also made the statebit was set to XT_CONNTRACK_STATE_UNTRACKED in conntrack_mt, which means we didn't had the information about in conntrack so we had to re-analysize the packet by calling tcp_mt().
> 
> However, after the commit d43b75fbc23f , all packets in vrf_ip_out was marked as "untracked", which made more times of calling tcp_mt(). Hence the time of processing all packets became longer and it affected the performance of ipt_do_table() in total. I wonder is it an expected behavior to see the performance decrease after the commit d43b75fbc23f ?
It was not the goal of this commit :)
The performance regression seems to be specific to your rule set.
As explained in the commit log, the goal was to have the same packet processing,
whatever qdisc is configured on the vrf interface.
Before this patch, you should have the same performance level (as now) if a
qdisc is configured.


Regards,
Nicolas
