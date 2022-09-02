Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1C5595AAC08
	for <lists+netdev@lfdr.de>; Fri,  2 Sep 2022 12:07:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235500AbiIBKHQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Sep 2022 06:07:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33466 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235365AbiIBKHP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Sep 2022 06:07:15 -0400
Received: from mail-wr1-x42c.google.com (mail-wr1-x42c.google.com [IPv6:2a00:1450:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D1DE99265
        for <netdev@vger.kernel.org>; Fri,  2 Sep 2022 03:07:14 -0700 (PDT)
Received: by mail-wr1-x42c.google.com with SMTP id n17so1659997wrm.4
        for <netdev@vger.kernel.org>; Fri, 02 Sep 2022 03:07:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=6wind.com; s=google;
        h=content-transfer-encoding:in-reply-to:organization:from:references
         :cc:to:content-language:subject:reply-to:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date;
        bh=PhHQ8RyBsxuJvvY+8C+AWydzhj3GUNz3lbYvul6n+9o=;
        b=Q/Zq5d9KUmaas79+80zUMAtLh6/rGyaRn5QsFkBCfYTCeA/OjpeGV3QD/ajC0KOQlK
         F46svkKISCGAIU3cKPXCVHdWSIkW9eEljG/gjgtnqpvbuMK/ZFJMfkLf8VIRh6Nghdu8
         +q29dopi5ofKMHI3QBWyPaeObcxB+k60HnTCcXDWdupsZjIlqF33oH0S1St5B1DQBCr9
         cKQM+pq+OnRo6HE7dGGf4K8fqxK52QKjlPpO881tCMlJVuHCRQC8oKTnBYyMF6BXAUJk
         IctkFk43MMuX9XbUEs6YQq1pLNxE9OHtbVHMq1ILyEIEOWbmsbTVOLAs95VQNMilJAea
         yyHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:organization:from:references
         :cc:to:content-language:subject:reply-to:user-agent:mime-version
         :date:message-id:x-gm-message-state:from:to:cc:subject:date;
        bh=PhHQ8RyBsxuJvvY+8C+AWydzhj3GUNz3lbYvul6n+9o=;
        b=lxe3rgwLeQzkSc+fL28+4qBEynMDHojBactNfPwEJL9jm1//lU3hGZgkl5hVW5n1HA
         QKXpDvXiYmzQDc9wnXpNgwrs+qd7qrifkAxnOKjMT3jdjnGJ5+zs1gbr1AdlqJ7CiGnL
         xc98/QwwdpT17I1HSbtNQKaldwyez09ZetN9peblf+mNXSrRh7j5Ej1ekVE+YHAQwgwY
         Dh+OzCtGhOz09ii9InexjyPgOnWTIf9J/sIkEGSlpioK5dcVi42kbgf280n9ZfUTQhr7
         ivOa+/x7hScxaUFMUQlYuqBuHJnQnpyoJSlbOSQshyh5GEN4OuIUCSuoLsGMDTfX0aFg
         7Hlw==
X-Gm-Message-State: ACgBeo07qZ9HPWiUehgEFiGLCk/YRnW5fjENHz/uefv+qB+nxzQOgULW
        w6Op33OMnLVPEIecDXnpCdZRHnmq4u72Vw==
X-Google-Smtp-Source: AA6agR4TI6pNsrKbyQRBgq+Ms6gkRea+0BeON4icM4M54V8iHfzu9nluq0T6BUgjqdzdEVXWEm5m9A==
X-Received: by 2002:a5d:6d8f:0:b0:225:6285:47fb with SMTP id l15-20020a5d6d8f000000b00225628547fbmr17675569wrs.211.1662113232671;
        Fri, 02 Sep 2022 03:07:12 -0700 (PDT)
Received: from ?IPV6:2a01:e0a:b41:c160:5588:d7c8:6470:f973? ([2a01:e0a:b41:c160:5588:d7c8:6470:f973])
        by smtp.gmail.com with ESMTPSA id k2-20020a5d6d42000000b00226f0a00348sm1115490wri.111.2022.09.02.03.07.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 02 Sep 2022 03:07:12 -0700 (PDT)
Message-ID: <fd70dbcd-961f-9edd-78e4-23a7ef20187b@6wind.com>
Date:   Fri, 2 Sep 2022 12:07:11 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Reply-To: nicolas.dichtel@6wind.com
Subject: Re: [PATCH v3 3/3] ipv4: add documentation of two sysctls about icmp
Content-Language: en-US
To:     cgel.zte@gmail.com, davem@davemloft.net, kuba@kernel.org,
        yoshfuji@linux-ipv6.org, dsahern@kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        xu.xin16@zte.com.cn, Yunkai Zhang <zhang.yunkai@zte.com.cn>
References: <20220830091453.286285-1-xu.xin16@zte.com.cn>
 <20220830091718.286452-1-xu.xin16@zte.com.cn>
From:   Nicolas Dichtel <nicolas.dichtel@6wind.com>
Organization: 6WIND
In-Reply-To: <20220830091718.286452-1-xu.xin16@zte.com.cn>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Le 30/08/2022 à 11:17, cgel.zte@gmail.com a écrit :
> From: xu xin <xu.xin16@zte.com.cn>
> 
> Add the descriptions of the sysctls of error_cost and error_burst in
> Documentation/networking/ip-sysctl.rst.
> 
> Signed-off-by: xu xin (CGEL ZTE) <xu.xin16@zte.com.cn>
> Reviewed-by: Yunkai Zhang (CGEL ZTE) <zhang.yunkai@zte.com.cn>
Maybe you could resubmit this one alone?


Thank you,
Nicolas
