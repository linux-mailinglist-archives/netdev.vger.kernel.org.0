Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 953EA10E485
	for <lists+netdev@lfdr.de>; Mon,  2 Dec 2019 03:23:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727345AbfLBCXY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 1 Dec 2019 21:23:24 -0500
Received: from mail-pf1-f180.google.com ([209.85.210.180]:39498 "EHLO
        mail-pf1-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727285AbfLBCXY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 1 Dec 2019 21:23:24 -0500
Received: by mail-pf1-f180.google.com with SMTP id x28so17691881pfo.6
        for <netdev@vger.kernel.org>; Sun, 01 Dec 2019 18:23:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=RKHQkROqUsIA1U7zF2OcwdUVM3/MpQ+b/q7sXYQGJPQ=;
        b=UgDroZETrHoK001TuB23HdPKpqy8bxgqLieA1iITRl2MFIprjCOIojjIqNmB5lUegI
         RKp2AHsLM+7Tx7CpnhvcYRN3Zn62il1Q7vAU6aY2aJsBtvZPI7WXJluz3t41/NCI7pzB
         sgGueEf0O7hR/MU9dlelMlChH6e1dpA9ICO1W+qG1yFEjc/oa/5qMwBOB9KIkQfTomYv
         GKnH7CFSkUcUb7a4wyAlzpCCg3WK+7dIFLuACpabure/q9vkCwXW8uDMu5ylJl8mZSA8
         7Zf30eW9z3vAhDHPLcqAUym7miXkwb4eC/b8TYyKSSvSEoTE8k+xcRjTT1bUvgo+3oW4
         Sb4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=RKHQkROqUsIA1U7zF2OcwdUVM3/MpQ+b/q7sXYQGJPQ=;
        b=rtUJfGOQaJqRO/lAlF/aI0HNSArQFn/0+78LnIzekszmBaI75bWLyhRP8IHclXgJPb
         88svJicHzssfT/tgXTfTKohIXjn1zQXNxEL4SzMaaA0K7inKJ/27b7OCd7On5pr1+2K8
         TB65EDHtgxXYTTYIUiNu4qtSQ1DT9cvLDOPbd7JCWTwoQHWObdmY5whiS03a7gU5AngM
         D+AeIUvizh2r+rBT5He2+fj6sf+DoIUwj/q/57KWjWP1ruO2MBYoL+3ulnCeYU4KSIqJ
         PG3fb29SHrBSq2PvdxMb/vDkpu9M327g9om4CaSAB8kjx7Ub19oUBa9j/9HHKKs/K3+l
         Kavg==
X-Gm-Message-State: APjAAAUfs6R1T/93mJQJZjE23vZ6MygoyclgydipemfJ1I8vTzXDgfPm
        9WD3AcAlTuqQMkIf5UJzP24=
X-Google-Smtp-Source: APXvYqxoP3cveq85Vr4bAOOQV+JwWZgqg43KvExSO7KpHzMe/jdQ2v1DuWgBk971AnF6Cnn+HnV9Ug==
X-Received: by 2002:a63:1953:: with SMTP id 19mr23228779pgz.157.1575253403514;
        Sun, 01 Dec 2019 18:23:23 -0800 (PST)
Received: from [192.168.86.235] (c-73-241-150-58.hsd1.ca.comcast.net. [73.241.150.58])
        by smtp.gmail.com with ESMTPSA id m14sm31439883pgn.41.2019.12.01.18.23.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 01 Dec 2019 18:23:22 -0800 (PST)
Subject: Re: Crash when receiving FIN-ACK in TCP_FIN_WAIT1 state
To:     Avinash Patil <avinashapatil@gmail.com>, subashab@codeaurora.org
Cc:     Eric Dumazet <eric.dumazet@gmail.com>,
        Josh Hunt <johunt@akamai.com>,
        Neal Cardwell <ncardwell@google.com>,
        Netdev <netdev@vger.kernel.org>,
        Yuchung Cheng <ycheng@google.com>
References: <68ad6fb82c0edfb788c7ce1a3bdc851b@codeaurora.org>
 <CADVnQynFeJCpv4irANd8O63ck0ewUq66EDSHHRKdv-zieGZ+UA@mail.gmail.com>
 <f7a0507ce733dd722b1320622dfd1caa@codeaurora.org>
 <CADVnQy=SDgiFH57MUv5kNHSjD2Vsk+a-UD0yXQKGNGY-XLw5cw@mail.gmail.com>
 <2279a8988c3f37771dda5593b350d014@codeaurora.org>
 <CADVnQykjfjPNv6F1EtWWvBT0dZFgf1QPDdhNaCX3j3bFCkViwA@mail.gmail.com>
 <f9ae970c12616f61c6152ebe34019e2b@codeaurora.org>
 <CADVnQymqKpMh3iRfrdiAYjb+2ejKswk8vaZCY6EW4-3ppDnv_w@mail.gmail.com>
 <81ace6052228e12629f73724236ade63@codeaurora.org>
 <CADVnQymDSZb=K8R1Gv=RYDLawW9Ju1tuskkk8LZG4fm3yxyq3w@mail.gmail.com>
 <74827a046961422207515b1bb354101d@codeaurora.org>
 <827f0898-df46-0f05-980e-fffa5717641f@akamai.com>
 <cae50d97-5d19-7b35-0e82-630f905c1bf6@gmail.com>
 <5a267a9d-2bf5-4978-b71d-0c8e71a64807@gmail.com>
 <0101016eba384308-7dd6b335-8b75-4890-8733-a4dde8064d11-000000@us-west-2.amazonses.com>
 <CAJwzM1mkR1dO-Jq7XH40MQz6CxU97YON5tembVL2DRPD6RYy9g@mail.gmail.com>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <fb78c016-d421-762c-e0eb-d148b7e55b17@gmail.com>
Date:   Sun, 1 Dec 2019 18:23:21 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <CAJwzM1mkR1dO-Jq7XH40MQz6CxU97YON5tembVL2DRPD6RYy9g@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 11/29/19 9:39 PM, Avinash Patil wrote:
> Hi Eric,
> 
> This crash looks quite similar to the one I am experiencing [1] and
> reported already.
> 
> [1] https://www.spinics.net/lists/netdev/msg611694.html
>

Please start a bisection.

Thanks you.

