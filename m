Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A143F4E54CC
	for <lists+netdev@lfdr.de>; Wed, 23 Mar 2022 16:03:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245020AbiCWPFW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Mar 2022 11:05:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47874 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245028AbiCWPFT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Mar 2022 11:05:19 -0400
Received: from mail-lj1-x231.google.com (mail-lj1-x231.google.com [IPv6:2a00:1450:4864:20::231])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B5F281661;
        Wed, 23 Mar 2022 08:03:49 -0700 (PDT)
Received: by mail-lj1-x231.google.com with SMTP id r22so2241112ljd.4;
        Wed, 23 Mar 2022 08:03:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:in-reply-to:references:date:message-id
         :mime-version;
        bh=NLLuXYwkRNkVyFDY51FXyNkaCFkba+6fr2X11U+G9DE=;
        b=YRs40Gj0HQMshTwfj0Y/+Jq+4v31gsdfBF16Dg9Cp4Tv3TtN42HlSBHk4V2d5f7ldX
         PvE6gw0UlWv2VEcHw47aT25u7AEt2DyrIO03eKXeJRwRYKF64NSn1qkfPTSKqAz1dVXi
         Iel+0wgbe3azPvZZXdopxJ72zUdTaMwjTPWAO0of/dKZRmUsdOsWe5RJ2EjGW1LK3kUL
         Vhgh+0P5ZkdRbngfjnhq7XC9eHMLvo3HUlkWxSEzVVn4O4xSHrDBqDksPFty/DmO+QoO
         tj+l/aPSWR3VYcluOcmitwH+cC4g0LMfvpX7UO/NJPjlm2HSk/GugBhwZI6e3hyf4zei
         BMsQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=NLLuXYwkRNkVyFDY51FXyNkaCFkba+6fr2X11U+G9DE=;
        b=3l8WB/d5KGMU7roUfgUwsFcfEu2ScyMVrnmoYmujYw+z4247ZqPxIpBjzYCfF+up0R
         klFLdwXpn6eMO6bHvmmxY5gbmURV0JjGyDNgverQXxxEYQd3+nIPh6ZKcgm0M7TW/Tdq
         J95kYU7U889q3KSpzxtN8JoCgva0bhkbR0hV2MMeDqWZx3gVRx3jkUXqlsk/oTws83vf
         EH3025lpekfOWPaIRcsnZZMNEpdl+wygLPqx8c9ZQxblzNRJmVghFdZnbfDxV6w6WYSE
         2qad41ysMhm53AhTktmCikhKRkHv5PhqzXULuQ5WyWjSKgglTE5Z7uBgDHSuOPYngxv+
         v9tA==
X-Gm-Message-State: AOAM532Vfan+1xcESx5UZZ7PE0ooEtXs8JTvWrrjnR8C0MgNU9n2NLTC
        Y6Bu2H4uHQ3rDB8MH9cu0LBawvucXoxbqQ==
X-Google-Smtp-Source: ABdhPJy0XQ28+VtrhdgFCZAFvWjTQlsczCuWe+fu8QEBcCgfGJlmPu4hBcpBggIIQ5nC2+CRlpGAAw==
X-Received: by 2002:a2e:a7ca:0:b0:249:862b:525 with SMTP id x10-20020a2ea7ca000000b00249862b0525mr301404ljp.491.1648047827365;
        Wed, 23 Mar 2022 08:03:47 -0700 (PDT)
Received: from wse-c0127 ([208.127.141.29])
        by smtp.gmail.com with ESMTPSA id p7-20020ac24ec7000000b00443d65ea161sm13170lfr.291.2022.03.23.08.03.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Mar 2022 08:03:46 -0700 (PDT)
From:   Hans Schultz <schultz.hans@gmail.com>
X-Google-Original-From: Hans Schultz <schultz.hans+netdev@gmail.com>
To:     Vladimir Oltean <olteanv@gmail.com>,
        Hans Schultz <schultz.hans@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Ivan Vecera <ivecera@redhat.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <razor@blackwall.org>,
        Shuah Khan <shuah@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Ido Schimmel <idosch@nvidia.com>, linux-kernel@vger.kernel.org,
        bridge@lists.linux-foundation.org, linux-kselftest@vger.kernel.org
Subject: Re: [PATCH v2 net-next 2/4] net: switchdev: add support for
 offloading of fdb locked flag
In-Reply-To: <20220323144304.4uqst3hapvzg3ej6@skbuf>
References: <20220317093902.1305816-1-schultz.hans+netdev@gmail.com>
 <20220317093902.1305816-3-schultz.hans+netdev@gmail.com>
 <86o81whmwv.fsf@gmail.com> <20220323123534.i2whyau3doq2xdxg@skbuf>
 <86wngkbzqb.fsf@gmail.com> <20220323144304.4uqst3hapvzg3ej6@skbuf>
Date:   Wed, 23 Mar 2022 16:03:43 +0100
Message-ID: <86ils4vhgw.fsf@gmail.com>
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

On ons, mar 23, 2022 at 16:43, Vladimir Oltean <olteanv@gmail.com> wrote:
> On Wed, Mar 23, 2022 at 01:49:32PM +0100, Hans Schultz wrote:
>> >> Does someone have an idea why there at this point is no option to add a
>> >> dynamic fdb entry?
>> >> 
>> >> The fdb added entries here do not age out, while the ATU entries do
>> >> (after 5 min), resulting in unsynced ATU vs fdb.
>> >
>> > I think the expectation is to use br_fdb_external_learn_del() if the
>> > externally learned entry expires. The bridge should not age by itself
>> > FDB entries learned externally.
>> >
>> 
>> It seems to me that something is missing then?
>> My tests using trafgen that I gave a report on to Lunn generated massive
>> amounts of fdb entries, but after a while the ATU was clean and the fdb
>> was still full of random entries...
>
> I'm no longer sure where you are, sorry..
> I think we discussed that you need to enable ATU age interrupts in order
> to keep the ATU in sync with the bridge FDB? Which means either to
> delete the locked FDB entries from the bridge when they age out in the
> ATU, or to keep refreshing locked ATU entries.
> So it seems that you're doing neither of those 2 things if you end up
> with bridge FDB entries which are no longer in the ATU.

Right, there was much that needed my attention, so after the other
issues are taken care of, I can focus on this. So I thought there was
some general machanism in place already, but I see that Ineed to enable
the IntOnAgeOut interrupt and handle ATU age out violations.
