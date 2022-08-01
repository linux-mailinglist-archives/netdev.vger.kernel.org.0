Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E524458656E
	for <lists+netdev@lfdr.de>; Mon,  1 Aug 2022 08:56:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229762AbiHAG4A (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Aug 2022 02:56:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56550 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229555AbiHAGz7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Aug 2022 02:55:59 -0400
Received: from mail-wr1-x42d.google.com (mail-wr1-x42d.google.com [IPv6:2a00:1450:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A4E511A82D;
        Sun, 31 Jul 2022 23:55:55 -0700 (PDT)
Received: by mail-wr1-x42d.google.com with SMTP id j15so4808089wrr.2;
        Sun, 31 Jul 2022 23:55:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=CDcBVXsrd0NrQbcXwpCbvBTDqZ66JWuglUosC0YVlls=;
        b=iwwETTw0Gx8Q0bnHGOSIXSecWZtqQ9ypNBTdOBTDsPhqj47RBVYX847rITz5/KDeFq
         P4joKgJRUnN3wirlwECuTGhdSLwagJQcu0924XhVkTn4zSHzuW2jpANrwF+Qqu5KmKkz
         /CFWbS/MPqP8scp5EnOHV8ZLDkUwdD+okUqkDlbQYR03brHkFeTEflU4pFFytwdeh0ly
         Bw1IPkndK6wzWPkwGxypi8pGp6sCV6nZ4kaUNmW76YcF0xG76cM1jMTFVFg7lXgOOqdH
         lwtDuoTj934IWYRl5WT0HQvuDF6/udxnWaTzSJVeyXYpmxNtkEuJG93QPM03Ta+Q9tZo
         eobg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=CDcBVXsrd0NrQbcXwpCbvBTDqZ66JWuglUosC0YVlls=;
        b=dYUfldQZLM9RwfH6juvSqszlExMEfAJhNKTKo/l5zyjFM/TO+hcZv6L9FaM1qnp36q
         yGwSf7OrVJhbcUtbGFGnUici29fZRPe7VpHLBNz1zgTr/2TmbYjSHNdnmktesnHJvnB3
         IdSKNEG3dyAp2E68avBgFp2bPiH1XyB6rkiqEwD3JK6zeBtvMtWHLsSFYoQWP/52a/1z
         03XFF87666+cIBPL4BJYAnvb40QeEIXu3gouF/tgsBf7aCvncihf67RGvmmxEI4+A+yu
         GD/ZOYTqbnaJGHAbmLHos5QEoG08UOnVBY00dPGvcV5h0hzRamS+5w0k5vwOZXeFRjoJ
         YxwA==
X-Gm-Message-State: ACgBeo3i1uynDxUja1mfFLImhukFZBOSxuOQB4m4/8MZzRKCaSdT81zu
        HKXqQfev2bYBux5YqcPNXQQ=
X-Google-Smtp-Source: AA6agR5zJwc7+hlJdQQ1xlSA09no/Nj4o1nozxAOJTF53UcyeOZKJhnIWvtq4RjcdbGoWYwLEcEHIg==
X-Received: by 2002:a5d:6b50:0:b0:21e:298c:caad with SMTP id x16-20020a5d6b50000000b0021e298ccaadmr8786107wrw.509.1659336953965;
        Sun, 31 Jul 2022 23:55:53 -0700 (PDT)
Received: from [192.168.0.104] ([77.126.166.31])
        by smtp.gmail.com with ESMTPSA id bh15-20020a05600c3d0f00b003a4a5bcd37esm10316906wmb.23.2022.07.31.23.55.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 31 Jul 2022 23:55:53 -0700 (PDT)
Message-ID: <a66792e1-5825-7912-0602-5a0fc47a75c6@gmail.com>
Date:   Mon, 1 Aug 2022 09:55:51 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [net-next PATCH] octeontx2-pf: Use only non-isolated cpus in irq
 affinity
Content-Language: en-US
To:     Sunil Kovvuri <sunil.kovvuri@gmail.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Geetha sowjanya <gakula@marvell.com>,
        Tariq Toukan <tariqt@nvidia.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Linux Netdev List <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>, edumazet@google.com,
        Sunil Kovvuri Goutham <sgoutham@marvell.com>
References: <20220725094402.21203-1-gakula@marvell.com>
 <20220726200804.72deb465@kernel.org>
 <23d40f8c-ad5b-c908-4081-24f882514ad7@gmail.com>
 <CA+sq2CdV=ujVuJswkq5TvK8mM7b6_vBXKR=oNBGQzSTH2cEiXA@mail.gmail.com>
From:   Tariq Toukan <ttoukan.linux@gmail.com>
In-Reply-To: <CA+sq2CdV=ujVuJswkq5TvK8mM7b6_vBXKR=oNBGQzSTH2cEiXA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 7/27/2022 10:03 AM, Sunil Kovvuri wrote:
> 
> 
> On Wed, Jul 27, 2022 at 11:01 AM Tariq Toukan <ttoukan.linux@gmail.com 
> <mailto:ttoukan.linux@gmail.com>> wrote:
> 
> 
> 
>     On 7/27/2022 6:08 AM, Jakub Kicinski wrote:
>      > On Mon, 25 Jul 2022 15:14:02 +0530 Geetha sowjanya wrote:
>      >> This patch excludes the isolates cpus from the cpus list
>      >> while setting up TX/RX queue interrupts affinity
>      >>
>      >> Signed-off-by: Geetha sowjanya <gakula@marvell.com
>     <mailto:gakula@marvell.com>>
>      >> Signed-off-by: Sunil Kovvuri Goutham <sgoutham@marvell.com
>     <mailto:sgoutham@marvell.com>>
>      >
>      > Hm, housekeeping_cpumask() looks barely used by drivers,
>      > do you have any references to discussions indicated drivers
>      > are expected to pay attention to it? Really seems like something
>      > that the core should take care of.
>      >
>      > Tariq, thoughts?
> 
>     I agree.
>     IMO this logic best fits inside the new sched API I proposed last week
>     (pending Ack...), transparent to driver.
> 
>     Find here:
>     https://lore.kernel.org/all/20220719162339.23865-2-tariqt@nvidia.com/ <https://lore.kernel.org/all/20220719162339.23865-2-tariqt@nvidia.com/>
> 
> 
> You mean
> 
> +static bool sched_cpus_spread_by_distance(int node, u16 *cpus, int 
> ncpus) +{ +
> 
> .... + cpumask_copy(cpumask, cpu_online_mask);
> 
> Change cpu_online_mask here to a mask which gives non-isolated cores mask ?
> 

Yes that was the intention.
However, on a second thought, I'm not sure this is a good idea.

In some cases, the device driver is isolated-out for other higher prio 
tasks. While in other cases, the device driver processing is the high 
prio task and is isolated in these cpus for best performance.
As the cpus spread usually affects affinity hints and numa-aware 
allocations, your patch might cause a degradation if always applied.
