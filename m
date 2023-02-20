Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1186469CA76
	for <lists+netdev@lfdr.de>; Mon, 20 Feb 2023 13:05:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231345AbjBTMFy convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Mon, 20 Feb 2023 07:05:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55786 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229671AbjBTMFx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Feb 2023 07:05:53 -0500
Received: from mail-wr1-f45.google.com (mail-wr1-f45.google.com [209.85.221.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6827B10A8A;
        Mon, 20 Feb 2023 04:05:52 -0800 (PST)
Received: by mail-wr1-f45.google.com with SMTP id p8so1042303wrt.12;
        Mon, 20 Feb 2023 04:05:52 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=LD75QQi8Ik5yRSSRI3C+jyBdmjGAjyaI3+hSKA5UW6Q=;
        b=KONHz7wrpGEeGa64vFuhmMnepNRbVxUaGgjeUKNYeDNUvPyMFJ+9q5LIK1YagmaPM1
         THgKW5tApXHTtgbUBQeOl27MM8OLI0JAsd1owiSZhv1kreNePUwlHFrHH5sdjwYmcTRT
         zv9u7RSjNSZuCiNx84innJ0hf9/U2F3HDOqPVP6kzTjeZCoODHJKxMBIqVyRP1MNN6EV
         sx01A8Ps4L1KPBqcXHtvhPx7eYd8giRRARMen83A1UJJxGIPLMDXtqhA/k/84o0aeEX7
         bJ8C7bkNTuTc7zu6wYAmQ5iP+oCv6eu4kf5IsVDMxApysR/r/yYxdrnOnlH/2BTZ6rrj
         pEDA==
X-Gm-Message-State: AO0yUKXIMKex1WyzzgvT9JR3ENE7ZlUieRgPIWJieS4wmdEnpCDYMVDE
        sKDu+zYl802I7d5lB7rfrgo=
X-Google-Smtp-Source: AK7set9jrr4wZKShtET1DyXAEOz7wzBSm4syjpdB6LiMXeNMDMyj3Dk9UAXmYoy+zT4HVa/CzzGmWw==
X-Received: by 2002:adf:e241:0:b0:2c5:4e77:62d with SMTP id bl1-20020adfe241000000b002c54e77062dmr1838954wrb.58.1676894750752;
        Mon, 20 Feb 2023 04:05:50 -0800 (PST)
Received: from [10.148.80.132] ([195.228.69.10])
        by smtp.gmail.com with ESMTPSA id b11-20020adfe30b000000b002c573a6216fsm12376268wrj.37.2023.02.20.04.05.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Feb 2023 04:05:49 -0800 (PST)
Message-ID: <070dd0bcdf24b5c74225faa7c914818b7ba2efef.camel@inf.elte.hu>
Subject: Re: [PATCH v2 net-next 00/12] Add tc-mqprio and tc-taprio support
 for preemptible traffic classes
From:   Ferenc Fejes <fejes@inf.elte.hu>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Gerhard Engleder <gerhard@engleder-embedded.com>,
        Amritha Nambiar <amritha.nambiar@intel.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        Roger Quadros <rogerq@kernel.org>,
        Pranavi Somisetty <pranavi.somisetty@amd.com>,
        Harini Katakam <harini.katakam@amd.com>,
        linux-kernel@vger.kernel.org,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        Wong Vee Khee <vee.khee.wong@linux.intel.com>,
        Michael Sit Wei Hong <michael.wei.hong.sit@intel.com>,
        Jacob Keller <jacob.e.keller@intel.com>
Date:   Mon, 20 Feb 2023 13:05:47 +0100
In-Reply-To: <20230220114816.vfpabqxmkq4zul24@skbuf>
References: <20230219135309.594188-1-vladimir.oltean@nxp.com>
         <d016f61224b293a77969c35d09d65d5cfea7d137.camel@inf.elte.hu>
         <20230220114816.vfpabqxmkq4zul24@skbuf>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
User-Agent: Evolution 3.46.4-1 
MIME-Version: 1.0
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi!

On Mon, 2023-02-20 at 13:48 +0200, Vladimir Oltean wrote:
> On Mon, Feb 20, 2023 at 12:15:57PM +0100, Ferenc Fejes wrote:
> > LGTM.
> > 
> > Reviewed-by: Ferenc Fejes <fejes@inf.elte.hu>
> 
> Thanks a lot for the review!
> 
> Unfortunately I need to send a v3, because the C language apparently
> doesn't like "default" switch cases with no code, and I need to make
> this change (which surprises me, since the code did compile fine with
> my gcc-arm-11.2-2022.02-x86_64-aarch64-none-linux-gnu toolchain):
> 
> 

[...]

> 
> Besides, I'm also taking the opportunity to make one more change, and
> really do a thorough job with the netlink extack: I will be passing
> it
> down to the device driver in v3, via struct tc_mqprio_qopt_offload
> and
> struct tc_taprio_qopt_offload.
> 
> I'll replicate your review tag for all patches from v2 that will be
> present in an unchanged form in v3, ok?

Sure!

Best,
Ferenc
