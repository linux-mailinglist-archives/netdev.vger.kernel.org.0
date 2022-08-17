Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AEDBD596732
	for <lists+netdev@lfdr.de>; Wed, 17 Aug 2022 04:04:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238478AbiHQCDl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Aug 2022 22:03:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37576 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238470AbiHQCDb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Aug 2022 22:03:31 -0400
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A1197E838
        for <netdev@vger.kernel.org>; Tue, 16 Aug 2022 19:03:28 -0700 (PDT)
Received: by mail-pj1-x1035.google.com with SMTP id e8-20020a17090a280800b001f2fef7886eso560347pjd.3
        for <netdev@vger.kernel.org>; Tue, 16 Aug 2022 19:03:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:from:to:cc;
        bh=FD0N+l7IYiGpplvHfRKwbi8kEc1l+8Qr04dbIonVhn0=;
        b=ZLKm3jyHstVb6FSHcB6bsSvLoptKCfUCAqjts0BmUFIl6rWqS1gpG+aFUvNd2d1hu9
         6m+2l1yEoHHA1da0XA0tPgZHTse7d9CLQDOFZtqb0hMFnuGBVuPcc/vMF0toEeyDKyqa
         Tn5TBvmM6DpeZT3dYOQnHOSq2Wq5GztiIDSAGXTgMofMhcOJVava231P8Shy994PM01+
         VpE5Ged+1VKTYI0Sm18D83PqHsmttBkFRioXbFWW/7DLnWOwqWYsDbOlOfTWzjwqNS2i
         NckTsyQ8RdkZfIfRXUn83lpS+CVk6a2neJrR4nlfwicpjD24wCcrbfXib+74Wk4Qm7Xf
         vXOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc;
        bh=FD0N+l7IYiGpplvHfRKwbi8kEc1l+8Qr04dbIonVhn0=;
        b=tZD76O7NEqHXh+TEcZWQT42WPguJQUX7ry+yXSqxZGiXvfeNh91PqyLGIO+TrLniCn
         Vw9FoBC/kZVgb2XhU559aMzHaCG1X74cuZEtSmZCUaUOody9qsO+RoRS4bu9NHHc7FK9
         EeAIyRqf7I+dBXOh1kJ7YmMrtqEpMkbp27e9dCgGmu6LwqneJIh9zCJj6Sd5fUnkoiqN
         ZHifArfRj/U3L3rHwZCzEcHcy2V/yiZxnhvjhR9FvvmyoNoK4v8UAKg4OnvzUQIKt6It
         pOTzHzPAcABnYGE8fxvggWehRxQmK8UDqk0gNIjo1FUlbpvjX9A9btqIpNs1JY9J3GJ4
         xOFw==
X-Gm-Message-State: ACgBeo05mLlLfptYN+0oYcJEQ0eA7uY0UecxzfAwfoKHVhSxRG4z4io2
        b+r3jEtpUfbI/rKzLmpLWdkqpIvF3bvDcg==
X-Google-Smtp-Source: AA6agR7mgB4JziUi3w5isqhnEC3EgleExgAcFtJHZgsbshx8puiuGs4pcmWkMKpDjzKKPRtV4J7MFQ==
X-Received: by 2002:a17:903:40cb:b0:16f:196a:2bb4 with SMTP id t11-20020a17090340cb00b0016f196a2bb4mr24707456pld.104.1660701807667;
        Tue, 16 Aug 2022 19:03:27 -0700 (PDT)
Received: from hermes.local (204-195-120-218.wavecable.com. [204.195.120.218])
        by smtp.gmail.com with ESMTPSA id l2-20020a17090af8c200b001f3076970besm234761pjd.26.2022.08.16.19.03.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Aug 2022 19:03:27 -0700 (PDT)
Date:   Tue, 16 Aug 2022 19:03:24 -0700
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Nick Hainke <vincent@systemli.org>
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH iproute2] ipstats: Define MIN function to fix undefined
 references
Message-ID: <20220816190324.65bf01d7@hermes.local>
In-Reply-To: <20220806082406.216286-1-vincent@systemli.org>
References: <20220806082406.216286-1-vincent@systemli.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat,  6 Aug 2022 10:24:06 +0200
Nick Hainke <vincent@systemli.org> wrote:

> Fixes errors in the form of:
>  in function `ipstats_show_64':
>  <artificial>:(.text+0x4e30): undefined reference to `MIN'
> 
> Signed-off-by: Nick Hainke <vincent@systemli.org>
> ---
>  ip/ipstats.c | 4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/ip/ipstats.c b/ip/ipstats.c
> index 5cdd15ae..2f500fc8 100644
> --- a/ip/ipstats.c
> +++ b/ip/ipstats.c
> @@ -6,6 +6,10 @@
>  #include "utils.h"
>  #include "ip_common.h"
>  
> +#ifndef MIN
> +#define MIN(a, b) ((a) < (b) ? (a) : (b))
> +#endif
> +
>  struct ipstats_stat_dump_filters {
>  	/* mask[0] filters outer attributes. Then individual nests have their
>  	 * filtering mask at the index of the nested attribute

Not sure what non-standard headers you are using,
but this already addressed in main branch by:

commit cf6b60c504d4be5e1df2b2745e55d677967831d0
Author: Changhyeok Bae <changhyeok.bae@gmail.com>
Date:   Tue Aug 9 04:01:05 2022 +0000

    ipstats: Add param.h for musl
    
    Fix build error for musl
    | /usr/src/debug/iproute2/5.19.0-r0/iproute2-5.19.0/ip/ipstats.c:231: undefined reference to `MIN'
    
    Signed-off-by: Changhyeok Bae <changhyeok.bae@gmail.com>

