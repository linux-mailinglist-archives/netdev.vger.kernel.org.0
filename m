Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2717258D950
	for <lists+netdev@lfdr.de>; Tue,  9 Aug 2022 15:22:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242961AbiHINW2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Aug 2022 09:22:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39116 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242879AbiHINW0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Aug 2022 09:22:26 -0400
Received: from mail-ed1-x52e.google.com (mail-ed1-x52e.google.com [IPv6:2a00:1450:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 768055FF2
        for <netdev@vger.kernel.org>; Tue,  9 Aug 2022 06:22:25 -0700 (PDT)
Received: by mail-ed1-x52e.google.com with SMTP id s11so15032596edd.13
        for <netdev@vger.kernel.org>; Tue, 09 Aug 2022 06:22:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:content-language:in-reply-to:mime-version
         :user-agent:date:message-id:from:references:cc:to:subject:from:to:cc;
        bh=jCHvkarYQga6K4Xno/xbezdrd3WIPS8ksoI1Qi06Tfk=;
        b=HPi0cbge6Kf6JT7s1tkoVGxrlSBLG7fi0U6tYe3DYhiyUp7ZlxcVUapRrEojGTOF4r
         P34vP/piSb/tlBJNa5N2xGTcPwa0A2lsSOVqoMYc+EAfXfmOKx56yoy0RF/WtuR1gy7P
         MHMHltK/pEI5ISdFcbyH6aRtngN3E3fOweZJCm61imZfmynm8BgXvoGzuwj3g3VHvUiA
         3ENtn7kAZd+GtVw/w3bvXBUDoTBoEU0IC+GvWul1JYBh8TUXj5dfqqqTUfbOhTjilXmP
         HhlDa39MUItppQowei968tpMuUDNfCyB49I0wIWoOvPB6gkBY/Z5ulbKGq/NqG2rihHa
         lrfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:content-language:in-reply-to:mime-version
         :user-agent:date:message-id:from:references:cc:to:subject
         :x-gm-message-state:from:to:cc;
        bh=jCHvkarYQga6K4Xno/xbezdrd3WIPS8ksoI1Qi06Tfk=;
        b=Lw/oFtu46vePBpyB0I0OXpfSOGxXQhHBmlhBKMCdSL9u0y9UrArsD4LelsLYPsNc23
         mk/7eQne+dYV7WPDEDWjfNcbVEvSa7/0/1SOdiNL6a/LE7CGhlqKH1YIEVQPs1qD5bAL
         FsLrHZrJpXu7zLeAIv+BGKXH+77a1Ruyra8Pwlz87zYOiHfGP3krv78R+exuH2Kx2ENr
         9nJcKKLlomSWHUge4m2Y5RCbYg3zS+mE1ITtOh4n92PljR4Ztb19b++CK/6zbN4A7KNo
         Y9YV2JAPoarDxXoZjtTHVgX/1D40rQkyiKORn3TAnD2vwI2R/wO+AkbChhDOqhdUVT4b
         RxDg==
X-Gm-Message-State: ACgBeo20Sw1Z2sBquR9PEPTpfVi2Kv7LCnbD1b8brDlzNNFECFmZXpxk
        Hnr84tyZa+cgXAO8FMiA7FxUuimXGyY=
X-Google-Smtp-Source: AA6agR63EO0wXeyyNrTV9Wkq1uqy3kDzwmITNkcpQJsPohzvI5fZDJcoEXl/puugV2beatHCMAFNkw==
X-Received: by 2002:a05:6402:35c:b0:43c:8f51:130 with SMTP id r28-20020a056402035c00b0043c8f510130mr21796403edw.393.1660051344017;
        Tue, 09 Aug 2022 06:22:24 -0700 (PDT)
Received: from [192.168.1.122] (cpc159313-cmbg20-2-0-cust161.5-4.cable.virginm.net. [82.0.78.162])
        by smtp.gmail.com with ESMTPSA id f23-20020a17090631d700b00722e8c47cc9sm1116144ejf.181.2022.08.09.06.22.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 09 Aug 2022 06:22:23 -0700 (PDT)
Subject: Re: [PATCH net-next 3/3] sfc: support PTP over Ethernet
To:     =?UTF-8?B?w43DsWlnbyBIdWd1ZXQ=?= <ihuguet@redhat.com>,
        habetsm.xilinx@gmail.com
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, netdev@vger.kernel.org
References: <20220809092002.17571-1-ihuguet@redhat.com>
 <20220809092002.17571-4-ihuguet@redhat.com>
From:   Edward Cree <ecree.xilinx@gmail.com>
Message-ID: <30015b7a-3f29-4f53-6a03-3acc7eb476bb@gmail.com>
Date:   Tue, 9 Aug 2022 14:22:23 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <20220809092002.17571-4-ihuguet@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 09/08/2022 10:20, Íñigo Huguet wrote:
> The previous patch add support for PTP over IPv6/UDP (only for 8000
> series and newer) and this one add support for PTP over 802.3.
> 
> Tested: sync as master and as slave is correct with ptp4l. PTP over IPv4
> and IPv6 still works fine.
> 
> Suggested-by: Edward Cree <ecree.xilinx@gmail.com>
> Signed-off-by: Íñigo Huguet <ihuguet@redhat.com>

Reviewed-by: Edward Cree <ecree.xilinx@gmail.com>
