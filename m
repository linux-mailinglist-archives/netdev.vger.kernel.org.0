Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1FA2D4B9173
	for <lists+netdev@lfdr.de>; Wed, 16 Feb 2022 20:41:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238130AbiBPTlZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Feb 2022 14:41:25 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:42748 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238152AbiBPTlO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Feb 2022 14:41:14 -0500
Received: from mail-lf1-x132.google.com (mail-lf1-x132.google.com [IPv6:2a00:1450:4864:20::132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 656E72B04A6
        for <netdev@vger.kernel.org>; Wed, 16 Feb 2022 11:41:01 -0800 (PST)
Received: by mail-lf1-x132.google.com with SMTP id p29so4912190lfa.3
        for <netdev@vger.kernel.org>; Wed, 16 Feb 2022 11:41:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:to:cc:references:subject
         :content-language:from:in-reply-to:content-transfer-encoding;
        bh=OZ7GqnC0elPt1mYwyqzceWWUOnOSfETksbED3lr0ReM=;
        b=PyyCaJaL+eaDNyuJXjUykVe7mxPMoBq7ZbRvRbUmoTukjowbmUj2+h0UBsSsnz87fb
         6/DwvLVlN9gmCSduKxaDzQSCOJeomyIcBm/oOR0j6Bfp3sXgX7QPkfQiSLJhnSTnesj8
         5m3co6EE19BoNmTfChMqwSDIDPVWO4NoAS+U8A2nirYmItKqN11cuuNymiPv/NdwPfCW
         S1pVk+6iCf1njDkEAeCCctzHhHkB5g7CTxLVtNOyCf/NtjFXkheeHtzHJBNdB//BKuQh
         W3u/MtT2axQlkwPTRGpPfSXHzm4ndtiE13i5Ag2y3m0THTjoQHS/R78rUqqW3EdRPk55
         Qpkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:to:cc
         :references:subject:content-language:from:in-reply-to
         :content-transfer-encoding;
        bh=OZ7GqnC0elPt1mYwyqzceWWUOnOSfETksbED3lr0ReM=;
        b=23kdkLYG8jLxhPpGaYjUfxa3RQN66KlJY3ZvZzu8lg1DfwYeGS3Xidp0Xzhop9MhKF
         alHJbrmuxdcbKnbB19HxnnIvi9B+rVEhIIFYkQvAwdVq2Hx93R+GI2Gz9Mv0+8QHNmps
         7H2CKSN5WDhmmmIHZ04ZtzIS6Ud+beJBCqc44jddOKt1107m9P0iuuTLGuHUJfNbpQLS
         xvLm6dn9uibbD7O8mwiNXLRJKqfYuvJwWrrrPYZT3GK6kKUx4sGf59uOyhrjzfifOJEF
         KZ4yT4hpYYxmsGEbAeX7SgtuR2UEHSxNpW5h7YophY35LZ6xLnCDlTksZg74aVBI+ICM
         Bo7g==
X-Gm-Message-State: AOAM532do2awe/7q13h84aTxybVxWveHuTflO3GngQgL9+YfMEDAvOy/
        aGrv+N/7stQWphkW57ejT3wCSp6lvpM=
X-Google-Smtp-Source: ABdhPJx3iai0fvHR227o/iqNyJ0t5Q6+UT0723mkpiZ0dj2QcczMKvm5unHdXyhH4Uj5b3RYqbOQdQ==
X-Received: by 2002:a05:6512:12c5:b0:443:5fe5:2d4a with SMTP id p5-20020a05651212c500b004435fe52d4amr3282229lfg.45.1645040459655;
        Wed, 16 Feb 2022 11:40:59 -0800 (PST)
Received: from [192.168.88.200] (pppoe.178-66-239-7.dynamic.avangarddsl.ru. [178.66.239.7])
        by smtp.gmail.com with ESMTPSA id m3sm997078lfg.150.2022.02.16.11.40.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 16 Feb 2022 11:40:59 -0800 (PST)
Message-ID: <5ff8631c-1c57-9bc7-4da8-ae089a7c74a6@gmail.com>
Date:   Wed, 16 Feb 2022 22:40:58 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
To:     stephen@networkplumber.org
Cc:     netdev@vger.kernel.org
References: <20220215144901.1ba007a1@hermes.local>
Subject: Re: [PATCH iproute2] lnstat: fix strdup leak in -w argument parsing
Content-Language: en-US
From:   Maxim Petrov <mmrmaximuzz@gmail.com>
In-Reply-To: <20220215144901.1ba007a1@hermes.local>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2022-02-15 22:49 UTC, Stephen Hemminger wrote:
> Would strdupa() be cleaner/simpler.

strdupa will not free the allocated memory until the caller returns. In our
case the caller is 'main', so despite valgrind will be happy, the memory
will be wasted anyway.

However, I guess that the option is mostly used just like '-w 20', so the
_wasted anyway_ strdupa memory is only about a few bytes in these cases,
and from this perspective I also have no strong preference. But I don't
know how this option is used by others.
