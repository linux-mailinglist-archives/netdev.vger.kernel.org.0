Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 840066892E6
	for <lists+netdev@lfdr.de>; Fri,  3 Feb 2023 09:58:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232261AbjBCI6T (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Feb 2023 03:58:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54422 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232113AbjBCI6R (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Feb 2023 03:58:17 -0500
Received: from mail-ed1-x52c.google.com (mail-ed1-x52c.google.com [IPv6:2a00:1450:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE37F2310D
        for <netdev@vger.kernel.org>; Fri,  3 Feb 2023 00:58:15 -0800 (PST)
Received: by mail-ed1-x52c.google.com with SMTP id cw4so4443850edb.13
        for <netdev@vger.kernel.org>; Fri, 03 Feb 2023 00:58:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=blackwall-org.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=1z40xBZl1s88AVKBaaMT4kPg0/IWGeDII88qOAQgOrM=;
        b=ugJ1ZUxXgqF6M2ADHF0b7CSoiPxc2idiHZ2fRCEKjinDPuJE2buPQtrAgjDPb3eklH
         yExCa7ATGFczL1g330HeaNsvJYxp3uMmFmpgZ5scL1Gv8BDXq+CM8vi+Yy6zCybrbEE1
         yvEnkc+NXR+ivXGx61+N8VusLuYKcwoRKlBJC2qLYRuGCA8ylN4rd7Dusa8F29f1tkss
         DATUANszgU8rquTfwekSlBTrURvimxxPLYMUDnzTjX3g9e5taFjOLQuY2fUcQVY5dnv2
         8vAW/OmHtlY200qBn0iNM/CgVbxDZ8ErDa3qfQMqjybVpO87MwGol2ISPhewfHnDAgQO
         wz/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=1z40xBZl1s88AVKBaaMT4kPg0/IWGeDII88qOAQgOrM=;
        b=aTaNiRGfkbNet9C7ADZE5cWR3Azv27S40Ajsa/hR0Te3Q7Hdo1gI00rU1dYdandW4Q
         JvdEpIQZyREkZaFA4Qvz6/EZKq9wXf4Yuic/hxPcFDNRlj9a65VJ6rWItgDF72ozYyq5
         g5RZRM1QO/0S0KIhbATo5lB0Oa+mAOFwPwv70T5SLAxCW0h/7YqqGynFcuaqgW8vKsET
         /bz5qTjh7bxY0kKqO0nbo5GVBIE4FkQDlhAEoYwa6asNnYP0U+k6N8L2QBmGKLa5z8E4
         Q71NKzVJhzOn0I1Ofl7HHjxRh9gLOPlc+dmREHtkJiRpa4bOUbWAEr6yv1XX/y6B3tHe
         VPYg==
X-Gm-Message-State: AO0yUKVRIG2WazpjF1HfyeRfm9e8s7racVlc8A1O9cdKd3XPFDB/3OEU
        h6+4HgIiUlUIxg4zFJn4uQWPuw==
X-Google-Smtp-Source: AK7set/ZmQCxv0xQUirdGsWOY06LUA2AkD+Yj31SlUyBsvKXs195QxZ3dTLxR/WJF3JVqpCmSNj+gA==
X-Received: by 2002:a05:6402:3647:b0:49e:eb5:ed05 with SMTP id em7-20020a056402364700b0049e0eb5ed05mr9680658edb.9.1675414693697;
        Fri, 03 Feb 2023 00:58:13 -0800 (PST)
Received: from [192.168.0.161] (62-73-72-43.ip.btc-net.bg. [62.73.72.43])
        by smtp.gmail.com with ESMTPSA id k3-20020a056402048300b00499b6b50419sm813274edv.11.2023.02.03.00.58.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 03 Feb 2023 00:58:13 -0800 (PST)
Message-ID: <6e50c1ac-9182-0d86-24fb-afcc2c63db85@blackwall.org>
Date:   Fri, 3 Feb 2023 10:58:12 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.0
Subject: Re: [PATCH net-next v3 06/16] net: bridge: Add a tracepoint for MDB
 overflows
Content-Language: en-US
To:     Petr Machata <petrm@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Roopa Prabhu <roopa@nvidia.com>, netdev@vger.kernel.org
Cc:     bridge@lists.linux-foundation.org,
        Ido Schimmel <idosch@nvidia.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        linux-trace-kernel@vger.kernel.org
References: <cover.1675359453.git.petrm@nvidia.com>
 <a01c188bcbbb0f5f53e333ed9175f938eb2736be.1675359453.git.petrm@nvidia.com>
From:   Nikolay Aleksandrov <razor@blackwall.org>
In-Reply-To: <a01c188bcbbb0f5f53e333ed9175f938eb2736be.1675359453.git.petrm@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=1.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_SBL_CSS,
        SPF_HELO_NONE,SPF_NONE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: *
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 02/02/2023 19:59, Petr Machata wrote:
> The following patch will add two more maximum MDB allowances to the global
> one, mcast_hash_max, that exists today. In all these cases, attempts to add
> MDB entries above the configured maximums through netlink, fail noisily and
> obviously. Such visibility is missing when adding entries through the
> control plane traffic, by IGMP or MLD packets.
> 
> To improve visibility in those cases, add a trace point that reports the
> violation, including the relevant netdevice (be it a slave or the bridge
> itself), and the MDB entry parameters:
> 
> 	# perf record -e bridge:br_mdb_full &
> 	# [...]
> 	# perf script | cut -d: -f4-
> 	 dev v2 af 2 src ::ffff:0.0.0.0 grp ::ffff:239.1.1.112/00:00:00:00:00:00 vid 0
> 	 dev v2 af 10 src :: grp ff0e::112/00:00:00:00:00:00 vid 0
> 	 dev v2 af 2 src ::ffff:0.0.0.0 grp ::ffff:239.1.1.112/00:00:00:00:00:00 vid 10
> 	 dev v2 af 10 src 2001:db8:1::1 grp ff0e::1/00:00:00:00:00:00 vid 10
> 	 dev v2 af 2 src ::ffff:192.0.2.1 grp ::ffff:239.1.1.1/00:00:00:00:00:00 vid 10
> 
> CC: Steven Rostedt <rostedt@goodmis.org>
> CC: linux-trace-kernel@vger.kernel.org
> Signed-off-by: Petr Machata <petrm@nvidia.com>
> Reviewed-by: Steven Rostedt (Google) <rostedt@goodmis.org>
> ---
> 
> Notes:
>     v2:
>     - Report IPv4 as an IPv6-mapped address through the IPv6 buffer
>       as well, to save ring buffer space.
> 
>  include/trace/events/bridge.h | 58 +++++++++++++++++++++++++++++++++++
>  net/core/net-traces.c         |  1 +
>  2 files changed, 59 insertions(+)
> 

Acked-by: Nikolay Aleksandrov <razor@blackwall.org>


