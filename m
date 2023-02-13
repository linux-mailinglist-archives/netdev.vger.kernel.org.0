Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BB034694F67
	for <lists+netdev@lfdr.de>; Mon, 13 Feb 2023 19:32:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230321AbjBMSca (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Feb 2023 13:32:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54926 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230290AbjBMSc2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Feb 2023 13:32:28 -0500
Received: from mail-qt1-x830.google.com (mail-qt1-x830.google.com [IPv6:2607:f8b0:4864:20::830])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 65EC544B3
        for <netdev@vger.kernel.org>; Mon, 13 Feb 2023 10:32:21 -0800 (PST)
Received: by mail-qt1-x830.google.com with SMTP id m12so14821958qth.4
        for <netdev@vger.kernel.org>; Mon, 13 Feb 2023 10:32:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=h1npBzk84hHmWmGG/hXz1KCqkRjmkb4jftVy1DPZ5ro=;
        b=i8jjeexU9npxz7IL3gVOosCSM64LgCaSwvipWhfgKP1+IeK6u881JdnPIHJlC2hwK+
         f1oWjcvK3lT7iZFPzvM9hYEzMw5r1sunEWLPQcksG7HqndsrJMBZT9Cwmht0GzvLuIju
         zlk4Fp7wTtb3+KRfNswsJ1icYlFgO2JjN1DTIY8xBGEcZfUKl5INaLmAjv56x+kvIolv
         qCuZxb7xdF3QGny0BrGD3PLYSCib2g98q8CPrsElOcMOHeJFlWAPczfhXqlckjxIslG8
         004cKHkaTOajAzrEpxNOn9uOXmGJDkiIH7Pah6BKGM+VyDPSbMNOpivWgWxH7CjSavG4
         jCZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=h1npBzk84hHmWmGG/hXz1KCqkRjmkb4jftVy1DPZ5ro=;
        b=F8tShUgRiyye2bL0mldkCgAH8CmSD6ZL6Ao/4JE3INQVzB+g6LAWWTKtcZpg48rde3
         piEf8FQf3b41u9k1F611UP7p26KG1eE8H/pMvM377mC7BHWd2GXcm+66NTclKlvBS4jC
         NMwiqe6tdmM32u51kputcIWT353Y49bMxK2LqJOtAo/iLL7HgnyXvIp5T260DTQYakD+
         vNM2qJx4pEsxFiqq2Bc92Fz5BFylKAJeF8bFsgBDoEpUHxDIVV9kev56txMYoipDF72N
         89TDpLEjaxmC47cTVE54jGhXCy/pY22pCtnn1CcgssSYg3MNCRmZTuWHt6OHsVKKRXBP
         3eWQ==
X-Gm-Message-State: AO0yUKXUK2Cqk7H2Zyrwkvih+0fxGStoNGE6Y2KfOP3FgZa2fxtUj5jm
        LV2VrWvUXDmm+txZiOVOGyo=
X-Google-Smtp-Source: AK7set9r8CB0pAuJ/a8ha/sfj3DdnTZHgBxbk72n6Yu9YEwFud8cyij9cqPPYgbHKdXYK5+rrTAxQw==
X-Received: by 2002:ac8:5b85:0:b0:3b9:c074:6e3c with SMTP id a5-20020ac85b85000000b003b9c0746e3cmr48148473qta.43.1676313140323;
        Mon, 13 Feb 2023 10:32:20 -0800 (PST)
Received: from t14s.localdomain (rrcs-24-43-123-84.west.biz.rr.com. [24.43.123.84])
        by smtp.gmail.com with ESMTPSA id t23-20020ac87397000000b003ab7aee56a0sm9667695qtp.39.2023.02.13.10.32.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Feb 2023 10:32:19 -0800 (PST)
Received: by t14s.localdomain (Postfix, from userid 1000)
        id AB9BE4C228E; Mon, 13 Feb 2023 10:32:18 -0800 (PST)
Date:   Mon, 13 Feb 2023 10:32:18 -0800
From:   Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
To:     Paul Blakey <paulb@nvidia.com>
Cc:     netdev@vger.kernel.org, Saeed Mahameed <saeedm@nvidia.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Oz Shlomo <ozsh@nvidia.com>, Jiri Pirko <jiri@nvidia.com>,
        Roi Dayan <roid@nvidia.com>, Vlad Buslov <vladbu@nvidia.com>
Subject: Re: [PATCH net-next v10 0/7] net/sched: cls_api: Support hardware
 miss to tc action
Message-ID: <Y+qCMrjnR1WwxZeR@t14s.localdomain>
References: <20230213181541.26114-1-paulb@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230213181541.26114-1-paulb@nvidia.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Feb 13, 2023 at 08:15:34PM +0200, Paul Blakey wrote:
> Hi,
> 
> This series adds support for hardware miss to instruct tc to continue execution
> in a specific tc action instance on a filter's action list. The mlx5 driver patch
> (besides the refactors) shows its usage instead of using just chain restore.
> 
> Currently a filter's action list must be executed all together or
> not at all as driver are only able to tell tc to continue executing from a
> specific tc chain, and not a specific filter/action.
> 
> This is troublesome with regards to action CT, where new connections should
> be sent to software (via tc chain restore), and established connections can
> be handled in hardware.
> 
> Checking for new connections is done when executing the ct action in hardware
> (by checking the packet's tuple against known established tuples).
> But if there is a packet modification (pedit) action before action CT and the
> checked tuple is a new connection, hardware will need to revert the previous
> packet modifications before sending it back to software so it can
> re-match the same tc filter in software and re-execute its CT action.
> 
> The following is an example configuration of stateless nat
> on mlx5 driver that isn't supported before this patchet:
> 
>  #Setup corrosponding mlx5 VFs in namespaces
>  $ ip netns add ns0
>  $ ip netns add ns1
>  $ ip link set dev enp8s0f0v0 netns ns0
>  $ ip netns exec ns0 ifconfig enp8s0f0v0 1.1.1.1/24 up
>  $ ip link set dev enp8s0f0v1 netns ns1
>  $ ip netns exec ns1 ifconfig enp8s0f0v1 1.1.1.2/24 up
> 
>  #Setup tc arp and ct rules on mxl5 VF representors
>  $ tc qdisc add dev enp8s0f0_0 ingress
>  $ tc qdisc add dev enp8s0f0_1 ingress
>  $ ifconfig enp8s0f0_0 up
>  $ ifconfig enp8s0f0_1 up
> 
>  #Original side
>  $ tc filter add dev enp8s0f0_0 ingress chain 0 proto ip flower \
>     ct_state -trk ip_proto tcp dst_port 8888 \
>       action pedit ex munge tcp dport set 5001 pipe \
>       action csum ip tcp pipe \
>       action ct pipe \
>       action goto chain 1
>  $ tc filter add dev enp8s0f0_0 ingress chain 1 proto ip flower \
>     ct_state +trk+est \
>       action mirred egress redirect dev enp8s0f0_1
>  $ tc filter add dev enp8s0f0_0 ingress chain 1 proto ip flower \
>     ct_state +trk+new \
>       action ct commit pipe \
>       action mirred egress redirect dev enp8s0f0_1
>  $ tc filter add dev enp8s0f0_0 ingress chain 0 proto arp flower \
>       action mirred egress redirect dev enp8s0f0_1
> 
>  #Reply side
>  $ tc filter add dev enp8s0f0_1 ingress chain 0 proto arp flower \
>       action mirred egress redirect dev enp8s0f0_0
>  $ tc filter add dev enp8s0f0_1 ingress chain 0 proto ip flower \
>     ct_state -trk ip_proto tcp \ 
>       action ct pipe \
>       action pedit ex munge tcp sport set 8888 pipe \
>       action csum ip tcp pipe \
>       action mirred egress redirect dev enp8s0f0_0
> 
>  #Run traffic
>  $ ip netns exec ns1 iperf -s -p 5001&
>  $ sleep 2 #wait for iperf to fully open
>  $ ip netns exec ns0 iperf -c 1.1.1.2 -p 8888
> 
>  #dump tc filter stats on enp8s0f0_0 chain 0 rule and see hardware packets:
>  $ tc -s filter show dev enp8s0f0_0 ingress chain 0 proto ip | grep "hardware.*pkt"
>         Sent hardware 9310116832 bytes 6149672 pkt
>         Sent hardware 9310116832 bytes 6149672 pkt
>         Sent hardware 9310116832 bytes 6149672 pkt
> 
> A new connection executing the first filter in hardware will first rewrite
> the dst port to the new port, and then the ct action is executed,
> because this is a new connection, hardware will need to be send this back
> to software, on chain 0, to execute the first filter again in software.
> The dst port needs to be reverted otherwise it won't re-match the old
> dst port in the first filter. Because of that, currently mlx5 driver will
> reject offloading the above action ct rule.
> 
> This series adds supports partial offload of a filter's action list,

As I said on v9, this sentence is very confusing and leads to the
interpretation can some actions can be in_hw and some not. Please
change it, so we don't have to keep fighting this misinterpretation
later on.

> and letting tc software continue processing in the specific action instance
> where hardware left off (in the above case after the "action pedit ex munge tcp
> dport... of the first rule") allowing support for scenarios such as the above.
> 
