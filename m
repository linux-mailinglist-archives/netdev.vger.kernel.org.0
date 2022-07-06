Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1809E568967
	for <lists+netdev@lfdr.de>; Wed,  6 Jul 2022 15:28:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233776AbiGFN2l (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Jul 2022 09:28:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56514 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232435AbiGFN2k (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Jul 2022 09:28:40 -0400
Received: from mail-ed1-x52a.google.com (mail-ed1-x52a.google.com [IPv6:2a00:1450:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D4C9C15A2A;
        Wed,  6 Jul 2022 06:28:38 -0700 (PDT)
Received: by mail-ed1-x52a.google.com with SMTP id m16so3800226edb.11;
        Wed, 06 Jul 2022 06:28:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=rb7S6vKA6tSNNVoIcDf+GZRHLmeFhGnBw8uqyS4EvKE=;
        b=I251BBbKoBayGE5g2oWlZqS5LjG0YRgMzPCPUIWwahKxLJoAdPFxy12b6BrIdZayZA
         cpMMVYpgRHwelBAjYmtk5IrxLZ0r3LqsKVGxJjSU9ClhUJNetNeWjCjOEETfHUaoekoD
         vLIX+z+dwPXXnAWJE+qwbR3+rDxXkDn2UQm2Dkho6gMTPtae76H83ll4Cgti5jGge+uO
         ridSd998Opy2oB9AEcUzA+Kextvgi4A7vkHdpVdxgHAmMtDeS4329C/Wi6o7waEU92/g
         LuiCL2vz18o4hsXUNw47Oa1UA88sa92FUjUkEvTqcZL6wvzqSSe+aAbAupeQKqpvEpNe
         bYZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=rb7S6vKA6tSNNVoIcDf+GZRHLmeFhGnBw8uqyS4EvKE=;
        b=S/Cmg5GcKzvsQPhino4iUXvUCbS2dOxwU1Mj/wtpf04EBLTO85d78wVJJWMIg0eRFD
         0kZiM0u2RTtAqE8H4xnBQilioewj1/STtK5BcMtmiTxUxPUwJK7r49MIZsE5b9WnzyD+
         bRcbb2YQz3TnYPrYQLlTw1Om6XCI/3jyOlWEth5NxQcbvricVn2XeaViv5xa2z6Jay5r
         P6IBFeHYnaIVlCY2A5xBpVyVwCPD0t73p4ukoMHxYgHKKhKm3cMHt1og9f+2dgTRw5a1
         /R6+w8OEUI5fIsFgjxa9vFOVKTt+wYysTojihsJ9HFL6VF+mTyFQ5V66nX8+kqMTfh2+
         9Heg==
X-Gm-Message-State: AJIora81hAf4Yf2rbn9pbwkYotvY9WA3YXirvhUNnDDIp7AgRKutZkN2
        F+A1pRj0id/989UkVL6q6Go=
X-Google-Smtp-Source: AGRyM1vfGSecteEGTYtINQy7ODV05OZ4g3oaZSTycPNxzFhVdRo4kFcUnGTVMurNcH7m3aNpdGQEaw==
X-Received: by 2002:a05:6402:5388:b0:435:71b:5d44 with SMTP id ew8-20020a056402538800b00435071b5d44mr53113203edb.364.1657114117386;
        Wed, 06 Jul 2022 06:28:37 -0700 (PDT)
Received: from skbuf ([188.26.185.61])
        by smtp.gmail.com with ESMTPSA id jw14-20020a170906e94e00b007263481a43fsm17077389ejb.81.2022.07.06.06.28.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 Jul 2022 06:28:36 -0700 (PDT)
Date:   Wed, 6 Jul 2022 16:28:34 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Hans S <schultz.hans@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Hans Schultz <schultz.hans+netdev@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, Jiri Pirko <jiri@resnulli.us>,
        Ivan Vecera <ivecera@redhat.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <razor@blackwall.org>,
        Shuah Khan <shuah@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Ido Schimmel <idosch@nvidia.com>, linux-kernel@vger.kernel.org,
        bridge@lists.linux-foundation.org, linux-kselftest@vger.kernel.org
Subject: Re: [PATCH V3 net-next 3/4] net: dsa: mv88e6xxx: mac-auth/MAB
 implementation
Message-ID: <20220706132834.rdw7mmpbwt55kt4r@skbuf>
References: <20220524152144.40527-1-schultz.hans+netdev@gmail.com>
 <20220524152144.40527-4-schultz.hans+netdev@gmail.com>
 <20220627180557.xnxud7d6ol22lexb@skbuf>
 <CAKUejP7ugMB9d3MVX3m9Brw12_ocFoT+nuJJucYdQH70kzC7=w@mail.gmail.com>
 <CAKUejP5u9rrH8tODODG0a1PLXfLhk7NLe5LUYkefkbs15uU=BQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKUejP5u9rrH8tODODG0a1PLXfLhk7NLe5LUYkefkbs15uU=BQ@mail.gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 05, 2022 at 05:05:52PM +0200, Hans S wrote:
> Hi, does anybody know what it going on with this variable?
> struct dsa_port *dp ->ageing_time;
> 
> I experience that it changes value like a factor ~10 at times.

Could you be a bit more specific? Are you talking about STP Topology
Change Notification BPDUs, which trigger this code path?

diff --git a/net/bridge/br_stp.c b/net/bridge/br_stp.c
index 7d27b2e6038f..9b25bc2dcb3e 100644
--- a/net/bridge/br_stp.c
+++ b/net/bridge/br_stp.c
@@ -671,10 +671,10 @@ void __br_set_topology_change(struct net_bridge *br, unsigned char val)
 
 		if (val) {
 			t = 2 * br->forward_delay;
-			br_debug(br, "decreasing ageing time to %lu\n", t);
+			br_info(br, "decreasing ageing time to %lu\n", t);
 		} else {
 			t = br->bridge_ageing_time;
-			br_debug(br, "restoring ageing time to %lu\n", t);
+			br_info(br, "restoring ageing time to %lu\n", t);
 		}
 
 		err = __set_ageing_time(br->dev, t);

Coincidentally the default values of 2 * br->forward_delay and br->bridge_ageing_time
are 1 order of magnitude apart from each other.

[  139.998310] br0: topology change detected, propagating
[  140.003490] br0: decreasing ageing time to 3000
[  175.193054] br0: restoring ageing time to 30000

What's the problem anyway?
