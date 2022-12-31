Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 17A5965A3E8
	for <lists+netdev@lfdr.de>; Sat, 31 Dec 2022 13:21:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231520AbiLaMVJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 31 Dec 2022 07:21:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56250 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229451AbiLaMVI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 31 Dec 2022 07:21:08 -0500
Received: from mail-il1-x12d.google.com (mail-il1-x12d.google.com [IPv6:2607:f8b0:4864:20::12d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3683B8FC7
        for <netdev@vger.kernel.org>; Sat, 31 Dec 2022 04:21:04 -0800 (PST)
Received: by mail-il1-x12d.google.com with SMTP id p15so1634306ilg.9
        for <netdev@vger.kernel.org>; Sat, 31 Dec 2022 04:21:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=eHyvwjFgtUAVt21YsLkg4uXGhQ3k3u+3P7bUVoiseTg=;
        b=PNYwRvN67KohL7ytiDP6pZKZozIdVGKqddCyJ8x8xS1CvkG963uhzVPanfgNRudAdC
         FyjLtV/eoJsG6/LiGDJ1HCVwrWluabbWyjoQOKzC9sw/H0W2PbCgQUxBzWrvtevLicPj
         +LKz+CgSTLfYpxbsq7V9xRp4p173EPhzMHwGWYn1KC3t6VjBpOU1Hd6Mhvmv3BjtOmWI
         o3uwTRxRrh8tsjFJYAIXFpUnSPv2qNVybDMbUZYMKtCRF5/5CItL32Qx868BC87vgig8
         TiK+pxwJRJ5mKz5CtN1DotJfA0pY3dDgTdhWWxDozhYRWQ866mJQVh0pwX+7TPpkPiAx
         oFJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=eHyvwjFgtUAVt21YsLkg4uXGhQ3k3u+3P7bUVoiseTg=;
        b=RZMu/tn+K59su4MUP9MuXY9uJwtt8ZMOx0aN7uxaqML6Ua6/okkGRa9uev56ikuGrX
         /NzEMxQXMqZsKrBkncC24KwJUpxd8lQ9/G6He3Vz/ymCh+C1EgFDmvRACr/8afEW/+WE
         q6Dm5CIaJG3TC+X+cgMZatl8vzqUyxme2pkoPU2Hhbgz4V8ENjz02HotZEGCuGYVcGvN
         tQqlh1wq96boRfR65IXvKOGpxTc5Q1ojxYeLiJxSfjYA4/9h9i5bhSCFKa2cBQxHpRSZ
         +j6mEbezbfRKY1WGWH4xf4EhKbK0WzCiIJzEKb0wSnFUNRJ8FH6BNX/Jck5hreNTN0D3
         YRBg==
X-Gm-Message-State: AFqh2kq1qLZ3dxzuqPX5ALsX8ZpY9iEC9754PLXPWkjk8nXdhNBzFh2Y
        YsGib1Fd9N/QVn287Ft8VMOTFg==
X-Google-Smtp-Source: AMrXdXs1PloNm8WS1dZpxGaleJqB1vINRpBdIbKv4RjigCCTdRdhZmGlECyuJcz2RbPovIFXGk6xTw==
X-Received: by 2002:a92:bf0c:0:b0:30c:3c0:7a56 with SMTP id z12-20020a92bf0c000000b0030c03c07a56mr11491172ilh.5.1672489263551;
        Sat, 31 Dec 2022 04:21:03 -0800 (PST)
Received: from [10.211.55.3] ([98.61.227.136])
        by smtp.gmail.com with ESMTPSA id az36-20020a05663841a400b0039db6cffcbasm5956607jab.71.2022.12.31.04.21.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 31 Dec 2022 04:21:02 -0800 (PST)
Message-ID: <e72955ce-5c0c-f335-8deb-8a2893c842b5@linaro.org>
Date:   Sat, 31 Dec 2022 06:21:01 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [PATCH net-next 0/6] net: ipa: simplify IPA interrupt handling
To:     Jakub Kicinski <kuba@kernel.org>, Alex Elder <elder@linaro.org>
Cc:     davem@davemloft.net, edumazet@google.com, pabeni@redhat.com,
        caleb.connolly@linaro.org, mka@chromium.org, evgreen@chromium.org,
        andersson@kernel.org, quic_cpratapa@quicinc.com,
        quic_avuyyuru@quicinc.com, quic_jponduru@quicinc.com,
        quic_subashab@quicinc.com, elder@kernel.org,
        netdev@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20221230232230.2348757-1-elder@linaro.org>
 <20221230195218.65eaaf92@kernel.org>
Content-Language: en-US
From:   Alex Elder <alex.elder@linaro.org>
In-Reply-To: <20221230195218.65eaaf92@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 12/30/22 9:52 PM, Jakub Kicinski wrote:
> On Fri, 30 Dec 2022 17:22:24 -0600 Alex Elder wrote:
>> [PATCH net-next 0/6] net: ipa: simplify IPA interrupt handling
> 
> We kept net-next closed for an extra week due to end-of-the-year
> festivities, back in business next week, sorry.

No, *I* am sorry.  I forgot to even check this time, and I normally do.
   http://vger.kernel.org/~davem/net-next.html

It's perfectly fine, I'll wait.  I won't re-send next week unless it
becomes obvious I should.

Thanks, and happy new year!

					-Alex
