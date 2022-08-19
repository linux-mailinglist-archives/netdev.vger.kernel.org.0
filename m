Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 41BB1599942
	for <lists+netdev@lfdr.de>; Fri, 19 Aug 2022 11:59:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347834AbiHSJ5W (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Aug 2022 05:57:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57428 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348349AbiHSJ45 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Aug 2022 05:56:57 -0400
Received: from mail-ed1-x531.google.com (mail-ed1-x531.google.com [IPv6:2a00:1450:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A2DDF994F
        for <netdev@vger.kernel.org>; Fri, 19 Aug 2022 02:56:00 -0700 (PDT)
Received: by mail-ed1-x531.google.com with SMTP id x21so5028065edd.3
        for <netdev@vger.kernel.org>; Fri, 19 Aug 2022 02:56:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=blackwall-org.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc;
        bh=t6W9x+WyR9aEmeKvb5RR9lUuSahG1sgA3A2JFCHzAnw=;
        b=vuKJeSl9JaPfAzsNJQ1aTpwqs71OASgH95FDetNyeGm+4UteAQukVux8PoDlviDBfZ
         VdNlqmv0Ig9/AzO7NQ9JTXNjaJ5wNtodagQ6jqj+iZrG3J8KwJf3YEWUh/wmjW1OUgjw
         yDlPsaLdE2KlVIpXAEamJcfjtdaO6HpVU7fEB0qdak/lOSLAwlO82fE7Tj6+3PqcxdeX
         Np1aoXVZCw8WUm/FSdOuhwKo6PGAv6Zf9y3yLFvAqW3XOuOLVxNu661oxgKLn0Q3QpLn
         DkOmldvHiNoUrcT4oDB+5QX1Vqwlje2G8LZBPR5O5VGQ46dC2YnD7ynFglYda+aRJFcb
         4+1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc;
        bh=t6W9x+WyR9aEmeKvb5RR9lUuSahG1sgA3A2JFCHzAnw=;
        b=GHON6kP2SoENuMIVxjaXchXcdDBgTuL+1gij61ZzPVpMwvmw6weGfi6ghW+rQK1DRI
         LaRYchWsWFeW5kSN9bpw04eYvphUaakt1zQalM8CtRZ4FXCmO0D4cFcURU9pT6FZfBUM
         uReErlFse7IRfh6Vq4Y2Co8ug4CnFhP7MmENbIT/wXPcPyNjWJ681Uzj/X9jd3Hjw1vl
         v/d3CYp4fzxAxctZVo08mLMzfqRnYIl49/792OM6bcJZv1GdMUWTbWuqUbupmVxHZyUY
         3YvS45BImEt3rGOsPjJCpc3V/iky0dee64jfe5ioehnmDvuCGDeoHeWQ10bo4a1hdVyj
         Gfjg==
X-Gm-Message-State: ACgBeo058pd8zZS4FoGDvtriC2Ns5qRZMwE1hqILXVfXNCtwKCDBoRUx
        ZVBbMsaQcOepNpPMzXxpobsHjw==
X-Google-Smtp-Source: AA6agR7wtKqyRGfnjcuvxsrl/dlt1fADSTrCDXQsKf/bE0fFyZzXgvCiscSIepGAJJArj7TFfEl6HA==
X-Received: by 2002:a05:6402:369:b0:445:d379:d233 with SMTP id s9-20020a056402036900b00445d379d233mr5469265edw.395.1660902958421;
        Fri, 19 Aug 2022 02:55:58 -0700 (PDT)
Received: from [192.168.0.111] (87-243-81-1.ip.btc-net.bg. [87.243.81.1])
        by smtp.gmail.com with ESMTPSA id ss2-20020a170907c00200b007309f007d3asm2022802ejc.128.2022.08.19.02.55.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 19 Aug 2022 02:55:57 -0700 (PDT)
Message-ID: <4a6120dc-6a7a-a718-86a4-6fd8bd9a8ed4@blackwall.org>
Date:   Fri, 19 Aug 2022 12:55:56 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [PATCH] bridge: move from strlcpy with unused retval to strscpy
Content-Language: en-US
To:     Wolfram Sang <wsa+renesas@sang-engineering.com>,
        linux-kernel@vger.kernel.org
Cc:     Roopa Prabhu <roopa@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        bridge@lists.linux-foundation.org, netdev@vger.kernel.org,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org
References: <20220818210212.8347-1-wsa+renesas@sang-engineering.com>
From:   Nikolay Aleksandrov <razor@blackwall.org>
In-Reply-To: <20220818210212.8347-1-wsa+renesas@sang-engineering.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 19/08/2022 00:02, Wolfram Sang wrote:
> Follow the advice of the below link and prefer 'strscpy' in this
> subsystem. Conversion is 1:1 because the return value is not used.
> Generated by a coccinelle script.
> 
> Link: https://lore.kernel.org/r/CAHk-=wgfRnXz0W3D37d01q3JFkr_i_uTL=V6A6G1oUZcprmknw@mail.gmail.com/
> Signed-off-by: Wolfram Sang <wsa+renesas@sang-engineering.com>
> ---
>  net/bridge/br_device.c          | 8 ++++----
>  net/bridge/br_sysfs_if.c        | 4 ++--
>  net/bridge/netfilter/ebtables.c | 2 +-
>  3 files changed, 7 insertions(+), 7 deletions(-)
> 

Looks good, but should be targeted at net-next.
Acked-by: Nikolay Aleksandrov <razor@blackwall.org>

