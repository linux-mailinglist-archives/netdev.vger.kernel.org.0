Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2CCE75ABFDC
	for <lists+netdev@lfdr.de>; Sat,  3 Sep 2022 18:44:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230247AbiICQoJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 3 Sep 2022 12:44:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38234 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229732AbiICQoH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 3 Sep 2022 12:44:07 -0400
Received: from mail-ej1-x632.google.com (mail-ej1-x632.google.com [IPv6:2a00:1450:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D4A9458DDD
        for <netdev@vger.kernel.org>; Sat,  3 Sep 2022 09:44:06 -0700 (PDT)
Received: by mail-ej1-x632.google.com with SMTP id fc24so341758ejc.3
        for <netdev@vger.kernel.org>; Sat, 03 Sep 2022 09:44:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date;
        bh=LiU7+LK7QIZ956P+nAlbuHFlGIUkfFMf+/fB6MzRof4=;
        b=GVDNt7G1Yms4qMBv4RzWcIc1nwwnjhipXPkWyUkdqmE7OsVWaq8+mwIL4d6+0ChQ6y
         eycu+Td1TMhcVaic+0VKPDlzsfi4PqhhI0FgshSzVGWmt80pu4iNf677g+xUPSsQVQTV
         sBviZ+Nez+t5DLKdhxK/BejLorKfLFrpcg3CmadisgJhwQ4O3EwwcJZBOD+qJxAfclIa
         TzWCgDI3cgo7oSLTl4OVm+paqDeqNVzLsiIc05MWuY4l5YSF7lcVU9ZBCFi6UI9s3xRC
         LggEIAfGNdYmyZCdhuvFBLGjW91hChwabj4SwzIZkE07LvnGz/OyckeFkeBbAxQM1B4Q
         QFMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
        bh=LiU7+LK7QIZ956P+nAlbuHFlGIUkfFMf+/fB6MzRof4=;
        b=HX98FAVfBRLdwqdnVrtfpn7/DrY6w84iG+XgzRsW1VYljopDtmep4HpgTfkS1Pt7EE
         WmU3E3NjGPU1w/Uke9Ij4UDIprQIQ45ia0OuEFLFkqQrSlW7hnTel9y9GdTXaZR/2RoV
         T3V9aG4dO3Si+T7LWma/K4OAyiqfIoNTJTjVKouTwCErCsTgEJTfB1mMlbStzkL/PSr+
         Q4ieck4xYODtg54z4QWJn4oXJK1lIt5z80/B8IQVr9um6jSTdhSLf3B5o6wbJ1vY6vv7
         P+yyteqtM4kJyUVxFpjVuPZ1bXg0O1omd1L7BY1/5KrEW0wZmoWpMrzPWrpjVyAWUEtd
         FHfA==
X-Gm-Message-State: ACgBeo181XxdWJU45kTbY68apwdD1yn1c6b5UUWnyujCQeDmxijkpoWE
        iu9rZcIvAkFm3W5F1cYl6aWIiXP6HPU=
X-Google-Smtp-Source: AA6agR6S/qswmY8Fa8gfTOuXfqrmqSY/59J8EIwgSHJiXKmfiTawJI/iOK97+SjUK5YFrXXiGAZi7A==
X-Received: by 2002:a17:907:60c7:b0:739:52ba:cbd0 with SMTP id hv7-20020a17090760c700b0073952bacbd0mr30938681ejc.152.1662223445241;
        Sat, 03 Sep 2022 09:44:05 -0700 (PDT)
Received: from skbuf ([188.27.184.197])
        by smtp.gmail.com with ESMTPSA id 9-20020a170906300900b00742a4debae1sm2620049ejz.6.2022.09.03.09.44.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 03 Sep 2022 09:44:04 -0700 (PDT)
Date:   Sat, 3 Sep 2022 19:44:02 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Kurt Kanzenbach <kurt@linutronix.de>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>, netdev@vger.kernel.org
Subject: Re: [PATCH net-next] net: dsa: hellcreek: Print warning only once
Message-ID: <20220903164402.4gmxipv2iol37r4g@skbuf>
References: <20220830163448.8921-1-kurt@linutronix.de>
 <20220831152628.um4ktfj4upcz7zwq@skbuf>
 <87v8q8jjgh.fsf@kurt>
 <20220831234329.w7wnxy4u3e5i6ydl@skbuf>
 <87czcfzkb6.fsf@kurt>
 <20220901113912.wrwmftzrjlxsof7y@skbuf>
 <87r10sr3ou.fsf@kurt>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87r10sr3ou.fsf@kurt>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Sep 03, 2022 at 03:24:33PM +0200, Kurt Kanzenbach wrote:
> > Yes, some IP forwarding of 60 byte frames at line rate gigabit or higher
> > should do the trick. Testing with MTU sized packets is probably not
> > going to show much of a difference.
> 
> Well, I don't see much of a difference. However, running iperf3 with
> small packets is nowhere near line rate of 100Mbit/s.

Try something smarter than iperf3, like CONFIG_NET_PKTGEN=y on a link
partner as traffic generator. I had this command lying around, I forget
exactly what it does.

/root/git/net-next/samples/pktgen/pktgen_sample03_burst_single_flow.sh \
	-i eth1 -s 64 -m 00:04:9f:05:de:0a -d 20.0.0.2  -t 2 -f 13 -c 4 -p 400 -n 0 -b 4
