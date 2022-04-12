Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 896DE4FDB94
	for <lists+netdev@lfdr.de>; Tue, 12 Apr 2022 12:58:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242426AbiDLKFR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Apr 2022 06:05:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46764 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1381032AbiDLIXC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Apr 2022 04:23:02 -0400
Received: from mail-lj1-x22b.google.com (mail-lj1-x22b.google.com [IPv6:2a00:1450:4864:20::22b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF22940E60
        for <netdev@vger.kernel.org>; Tue, 12 Apr 2022 00:55:34 -0700 (PDT)
Received: by mail-lj1-x22b.google.com with SMTP id r18so7382489ljp.0
        for <netdev@vger.kernel.org>; Tue, 12 Apr 2022 00:55:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:in-reply-to:references:date:message-id
         :mime-version;
        bh=1tI3iJnrQlcw0Ck+JWSm8F+BSpbNuEevk2Gd0ETM/CU=;
        b=KBThr/QmH0sNYswb91CdCeH7vHTersHZTKhK9LgK5z9JOlBMl88JDFcUaD8xdyspzj
         3f3PwOUp1XWW+zQl7eetNAFTqNB5RO92A2YLKPvXKcxcw4EyIGyfnMaYW4PDFYa2pYyA
         ZaQq9W4YMjWr1wlLNe77jOAYXrhoHNca35dqJly7IPwqP2QWxa3apCVSso3DjkVQPs54
         E+72+yK+8LuFfe/b8PwgssOY1UMDRZUFklXKimFtPREp0bURQPBtSc83rM/QO9x+tQzS
         TsZqxltKygzyhV5um9vT/ptE0sGxWl/zReXX0f27MDKDqdTDVORg1uYZTFymRfdG5mGl
         4lVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=1tI3iJnrQlcw0Ck+JWSm8F+BSpbNuEevk2Gd0ETM/CU=;
        b=l1HEW9mf8LwezfJyiizg408Mfmo/b0kj182XXtjoH2vilbeFjCCOwWb8cKcMo9kSji
         /4ITf6sEWAvMtryqw8uEZMaOUjFfQBQ2C5a1t3k8gvtvWyAG5AfwbN4JAUTQefwNl4Ri
         WwuBgAXshuWmPKBK3OkBivbDYijBxJ2Iv2EZsaCP1cOofbnKxrn/cpxydWIXzXlVzG1y
         Rco5zz7yv8ZOqijZsA7dev4FP9LoW5RomrbTyvR0XbI/n95Z/eMnGXb/Y5Yep1QFd2um
         sAt+lbA49SSOim2teRlDUVZqMcuPs9Ys2HBqzYEhQRtB6HgoKIma4ZjUDBE2WBDLFUFp
         EadA==
X-Gm-Message-State: AOAM531mE0Wqeq4HRA0FFd273sBul+ziYqZ4x6uJUD3buRIlVCTiVENO
        rdBX6A1ZvIXpSbcKZ+uc2tA=
X-Google-Smtp-Source: ABdhPJz4GZBT1duBnis0ry7E7ajhHd11VlRygX+nPK1Ms8AYdppCeCfQAN3a2Kg55fKkQ+yrD1eexw==
X-Received: by 2002:a05:651c:54c:b0:249:9d06:24ef with SMTP id q12-20020a05651c054c00b002499d0624efmr22986905ljp.331.1649750132854;
        Tue, 12 Apr 2022 00:55:32 -0700 (PDT)
Received: from wbg (h-158-174-22-128.NA.cust.bahnhof.se. [158.174.22.128])
        by smtp.gmail.com with ESMTPSA id t1-20020a19dc01000000b0046ba600f866sm596403lfg.180.2022.04.12.00.55.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Apr 2022 00:55:32 -0700 (PDT)
From:   Joachim Wiberg <troglobit@gmail.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <razor@blackwall.org>,
        "netdev\@vger.kernel.org" <netdev@vger.kernel.org>,
        "bridge\@lists.linux-foundation.org" 
        <bridge@lists.linux-foundation.org>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Tobias Waldekranz <tobias@waldekranz.com>
Subject: Re: [PATCH RFC net-next 07/13] selftests: forwarding: new test, verify bridge flood flags
In-Reply-To: <20220411202128.n4dafks4mnkbzr2k@skbuf>
References: <20220411133837.318876-1-troglobit@gmail.com> <20220411133837.318876-8-troglobit@gmail.com> <20220411202128.n4dafks4mnkbzr2k@skbuf>
Date:   Tue, 12 Apr 2022 09:55:31 +0200
Message-ID: <87fsmiburw.fsf@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Apr 11, 2022 at 20:21, Vladimir Oltean <vladimir.oltean@nxp.com> wrote:
> On Mon, Apr 11, 2022 at 03:38:31PM +0200, Joachim Wiberg wrote:
>> +# Verify per-port flood control flags of unknown BUM traffic.
>> +#
>> +#                     br0
>> +#                    /   \
>> +#                  h1     h2
>
> I think the picture is slightly inaccurate. From it I understand that h1
> and h2 are bridge ports, but they are stations attached to the real
> bridge ports, swp1 and swp2. Maybe it would be good to draw all interfaces.

Hmm, yeah either that or drop it entirely.  I sort of assumed everyone
knew about the h<-[veth]->swp (or actual cable) setup, but you're right
this is a bit unclear.  Me and Tobias have internally used h<-->p (for
host<-->bridge-port) and other similar nomenclature.  Finding a good
name that fits easily, and is still readable, in ASCII drawings is hard.
I'll give it a go in the next drop, thanks!

>> +#set -x
> stray debug line

thx

>> +# Disable promisc to ensure we only receive flooded frames
>> +export TCPDUMP_EXTRA_FLAGS="-pl"
> Exporting should be required only for sub-shells, doesn't apply when you
> source a script.

Ah thanks, will fix!

>> +# Port mappings and flood flag pattern to set/detect
>> +declare -A ports=([br0]=br0 [$swp1]=$h1 [$swp2]=$h2)
> Maybe you could populate the "ports" and the "flagN" arrays in the same
> order, i.e. bridge first for all?

Good point, thanks!

> Also, to be honest, a generic name like "ports" is hard to digest,
> especially since you have another generic variable name "iface".
> Maybe "brports" and "station" is a little bit more specific?

Is there a common naming standard between bridge tests, or is it more
important to be consistent the test overview (test heading w/ picture)?

Anyway, I'll have a look at the naming for the next drop.

>> +declare -A flag1=([$swp1]=off [$swp2]=off [br0]=off)
>> +declare -A flag2=([$swp1]=off [$swp2]=on  [br0]=off)
>> +declare -A flag3=([$swp1]=off [$swp2]=on  [br0]=on )
>> +declare -A flag4=([$swp1]=off [$swp2]=off [br0]=on )
> If it's not too much, maybe these could be called "flags_pass1", etc.
> Again, it was a bit hard to digest on first read.

More like flags_pass_fail, but since its the flooding flags, maybe
flood_patternN would be better?

>> +do_flood_unknown()
>> +{
>> +	local type=$1
>> +	local pass=$2
>> +	local flag=$3
>> +	local pkt=$4
>> +	local -n flags=$5
> I find it slightly less confusing if "flag" and "flags" are next to each
> other in the parameter list, since they're related.

Hmm, OK.

>> +#		echo "Dumping PCAP from $iface, expecting ${flags[$port]}:"
>> +#		tcpdump_show $iface
> Do something about the commented lines.

Oups, thanks!

>> +		tcpdump_show $iface |grep -q "$SRC_MAC"
> Space between pipe and grep.

Will fix!

>> +		check_err_fail "${flags[$port]} = on"  $? "failed flooding from $h1 to port $port"
> I think the "failed" word here is superfluous, since check_err_fail
> already says "$what succeeded, but should have failed".

Ah, good point!

Thank you for the review! <3

 /J
 
