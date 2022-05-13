Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 91C3C525F41
	for <lists+netdev@lfdr.de>; Fri, 13 May 2022 12:08:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232778AbiEMJl6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 May 2022 05:41:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52864 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379144AbiEMJkx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 May 2022 05:40:53 -0400
Received: from mail-ej1-x635.google.com (mail-ej1-x635.google.com [IPv6:2a00:1450:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B85EC11C2D
        for <netdev@vger.kernel.org>; Fri, 13 May 2022 02:40:44 -0700 (PDT)
Received: by mail-ej1-x635.google.com with SMTP id kq17so15146769ejb.4
        for <netdev@vger.kernel.org>; Fri, 13 May 2022 02:40:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=3wfH+mMGeRiMGmvaPfF6+EYziM6b0Uzgj8l2qqghrXM=;
        b=qM9boDRny3GvAoEZXemJJxl2i0PV0kwQcDtehh9c7/0L1znEETzOWmoVhnlLrIZnLW
         Nm2W7zj878eRzQgL+ZQjur0cNx49Tq+Wfy7vp5xBK/vzrNXoDWBxcdDNICALg5dej7Nj
         OuihrDsEG614YqijKHSL4Sr14oVm0LajznJFFfDMvuAWefScbk3lyAsJz2VKBfRUnULI
         WjJ16R9Cz8j5ELHny6Gz4KZaugWsLgmSAIrJhc1fjylto6Osif1bKZPdotKGDFAVwCcJ
         VQwiX7I+1kTwrs1bQZnj/iX9kp+5ayRIkaw5/qS4W8jixKTyiDYfAR9ePQBdw7NL3GO6
         m1xQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=3wfH+mMGeRiMGmvaPfF6+EYziM6b0Uzgj8l2qqghrXM=;
        b=qCSkUEWOXwzqTQfWxDFwSijehaI/P85dVUWsmctBPfHre4M+khfHWVSgEa6k+IeAT1
         YMNV8AMGHNz/T+cfe7dnliCQ7hKjtgF6zJb0hClAJuarbMad4ttIHqS2XC2jlU1w8bxU
         B4J2GUrdUI0Gy0A/4UKgByO8m12IP/4MOfel4FE61pAEYKtLqC/SZJH73WiLK+eDF9pO
         d4cr325bKOXGDUlNwjism8cHrnRd/c8rcMFvXrFaTukeXY+w8t7C5wmyhkzbT18m0KjC
         nk/VJmRRw7LD/9TeGCLA4mXJU3LhQc3E+ZpWH5Jcbmmz8rTcb+cFc7R8VoVm9o7NFrMV
         4EtA==
X-Gm-Message-State: AOAM532/0mExvdkHCZRJPiY887eNRgvSWcpccjIa1cOOA9CblBy7z7dG
        NIMJpej1YqRnnpeoAWcPmMA=
X-Google-Smtp-Source: ABdhPJw0U4uYrbRLcGzIjigFNulB8a7CnTZy+JnU79elbSXspFMz8mJoWkU6KFoxdpuAzX1Rdv5kyA==
X-Received: by 2002:a17:907:94c5:b0:6f4:6f30:5083 with SMTP id dn5-20020a17090794c500b006f46f305083mr3438815ejc.507.1652434843217;
        Fri, 13 May 2022 02:40:43 -0700 (PDT)
Received: from ?IPV6:2a04:241e:502:a09c:8226:f006:76f5:f9fb? ([2a04:241e:502:a09c:8226:f006:76f5:f9fb])
        by smtp.gmail.com with ESMTPSA id y24-20020aa7ccd8000000b0042617ba6397sm736294edt.33.2022.05.13.02.40.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 13 May 2022 02:40:42 -0700 (PDT)
Message-ID: <40334043-6740-3317-4672-c559a4a2b567@gmail.com>
Date:   Fri, 13 May 2022 12:40:41 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.1
Subject: Re: [PATCH net] Revert "tcp/dccp: get rid of inet_twsk_purge()"
Content-Language: en-US
To:     Eric Dumazet <eric.dumazet@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev <netdev@vger.kernel.org>, Eric Dumazet <edumazet@google.com>
References: <20220512211456.2680273-1-eric.dumazet@gmail.com>
From:   Leonard Crestez <cdleonard@gmail.com>
In-Reply-To: <20220512211456.2680273-1-eric.dumazet@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 13.05.2022 00:14, Eric Dumazet wrote:
> From: Eric Dumazet <edumazet@google.com>
> 
> This reverts commits:
> 
> 0dad4087a86a2cbe177404dc73f18ada26a2c390 ("tcp/dccp: get rid of inet_twsk_purge()")
> d507204d3c5cc57d9a8bdf0a477615bb59ea1611 ("tcp/dccp: add tw->tw_bslot")
> 
> As Leonard pointed out, a newly allocated netns can happen
> to reuse a freed 'struct net'.
> 
> While TCP TW timers were covered by my patches, other things were not:
> 
> 1) Lookups in rx path (INET_MATCH() and INET6_MATCH()), as they look
>    at 4-tuple plus the 'struct net' pointer.
> 
> 2) /proc/net/tcp[6] and inet_diag, same reason.
> 
> 3) hashinfo->bhash[], same reason.
> 
> Fixing all this seems risky, lets instead revert.
> 
> In the future, we might have a per netns tcp hash table, or
> a per netns list of timewait sockets...
> 
> Fixes: 0dad4087a86a ("tcp/dccp: get rid of inet_twsk_purge()")
> Signed-off-by: Eric Dumazet <edumazet@google.com>
> Reported-by: Leonard Crestez <cdleonard@gmail.com>

Tested-by: Leonard Crestez <cdleonard@gmail.com>
