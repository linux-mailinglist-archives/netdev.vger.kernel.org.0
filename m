Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1256D4E2536
	for <lists+netdev@lfdr.de>; Mon, 21 Mar 2022 12:25:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346767AbiCUL0e (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Mar 2022 07:26:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44746 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346742AbiCUL02 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Mar 2022 07:26:28 -0400
Received: from mail-wm1-x32e.google.com (mail-wm1-x32e.google.com [IPv6:2a00:1450:4864:20::32e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A578F8BF6B
        for <netdev@vger.kernel.org>; Mon, 21 Mar 2022 04:25:02 -0700 (PDT)
Received: by mail-wm1-x32e.google.com with SMTP id r64so8305749wmr.4
        for <netdev@vger.kernel.org>; Mon, 21 Mar 2022 04:25:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Un24wEBgk5bhA1VY+799Jn6tFNhlZ1g0bXjsrF2w3T0=;
        b=7YMQf8dX+l/jLbPX1h+u9FhsbVcIrTvluePwHFhs8/IY5RFEScNCGR3xjl9qU25Nwt
         UOJFze1uuSYf1uY9SsZZpRNZyOSC83vD+RSRh3BNeCdGfRlFArLa9cHOwV821qg7Y+s2
         fhER7EQ8/78KiUN7pREU6sWBmpHsSbkbOY3R3TjeDeWK4eMRdTIqpFxkQbcfPIp75Pko
         9F6P43xLOOeJDDa1/RWH+i5UkupxgX/OXC1TUlxmL+n9SvuQzYm5FYFZKprDE+MW4eqp
         9BxHzpCjGtsZ9glUgvxNJjMXaXP3TPD14Cct9bmzLy/DONrUQdMRT414fRMCLMuDQFRq
         3Bnw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Un24wEBgk5bhA1VY+799Jn6tFNhlZ1g0bXjsrF2w3T0=;
        b=oVqtw4nODWsSGWZTFMO/NBfuy/sRnzV5pRCDOagZnehTrpu+smtY+Xmk/ynsBS4vpN
         B/RCYETwvwCFSjAzCp9mlHJC7i7l2GusW5KviSe5ElP7eZLYZJicHpHLPSnnYMBcJ2lW
         uKpN03nrm4oj7PxQqjcmKY/NRk4Qp9gxyLlJEjf8j3HwkszjD1cevRCInHO5vRE7sZ4L
         XlCnIPivkeQY7P/k+KyIaMNeSZbl7YWTBMaitYxdi8OXVSBliVb4i78b72SkDK8hBFEA
         UCJ28c2hdFmOz1dGMIP7ZN/1P+JJoId1jEB4x19ekszcUn7EbjQoSvpKXUJohLEmnN5q
         iQmA==
X-Gm-Message-State: AOAM533NZt1UzGsDkPZhfkZ2s6I3H+aDZAsAnkN2dgUGBDQrSNYtEB92
        KZDFzebM5GR8HSkqFlyIHTHeMw==
X-Google-Smtp-Source: ABdhPJyZnRpU2kuheA3W75M3zH3LMYZ3YMVZ7Qv3/ApJS9yHuMOYmfo4OtaM9ru4+6uNIKi+py9AjQ==
X-Received: by 2002:a05:600c:34ce:b0:38c:a579:944a with SMTP id d14-20020a05600c34ce00b0038ca579944amr4389098wmq.113.1647861901129;
        Mon, 21 Mar 2022 04:25:01 -0700 (PDT)
Received: from localhost (host-213-179-129-39.customer.m-online.net. [213.179.129.39])
        by smtp.gmail.com with ESMTPSA id i10-20020a5d584a000000b00203e8019f2dsm11079005wrf.61.2022.03.21.04.25.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Mar 2022 04:25:00 -0700 (PDT)
Date:   Mon, 21 Mar 2022 12:24:59 +0100
From:   Jiri Pirko <jiri@resnulli.us>
To:     Vlad Buslov <vladbu@nvidia.com>
Cc:     Jiri Pirko <jiri@nvidia.com>, netdev@vger.kernel.org,
        Jamal Hadi Salim <hadi@mojatatu.com>,
        Maor Dickman <maord@nvidia.com>
Subject: Re: cls_flower vlan matching
Message-ID: <Yjhgi48BpTGh6dig@nanopsycho>
References: <8735jkv2nm.fsf@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8735jkv2nm.fsf@nvidia.com>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Mon, Mar 14, 2022 at 06:26:38PM CET, vladbu@nvidia.com wrote:
>Hi Jiri,
>
>I've been debugging an issue that we encounter with OvS-created rules
>for single and double-VLAN packets.
>
>Basically, for flows with single VLAN OvS creates following tc filter:
>
>filter protocol 802.1Q pref 2 flower chain 0 
>filter protocol 802.1Q pref 2 flower chain 0 handle 0x1 
>  vlan_id 10                                                                                                            
>  vlan_prio 0             
>  vlan_ethtype ip                                                                                                       
>  dst_mac e4:2c:0b:08:00:02     
>  src_mac b8:ce:f6:05:e7:3a
>  eth_type ipv4
>  ip_flags nofrag                                                                                                       
>  skip_hw                                                                                                               
>  not_in_hw               
>        action order 1: vlan  pop pipe                                                                                  
>         index 2 ref 1 bind 1 installed 11 sec used 0 sec firstused 10 sec
>        Action statistics:                     
>        Sent 860 bytes 10 pkt (dropped 0, overlimits 0 requeues 0) 
>        backlog 0b 0p requeues 0
>        no_percpu
>
>        action order 2: mirred (Egress Redirect to device enp8s0f0_0) stolen
>        index 2 ref 1 bind 1 installed 11 sec used 0 sec firstused 10 sec
>        Action statistics:
>        Sent 860 bytes 10 pkt (dropped 0, overlimits 0 requeues 0) 
>        backlog 0b 0p requeues 0
>        cookie 16a9b603144b3e0c64a887aeb972a269
>        no_percpu
>
>Such rule also matches packets that have additional second VLAN header,
>even though filter has both eth_type and vlan_ethtype set to "ipv4".
>Looking at the code this seems to be mostly an artifact of the way
>flower uses flow dissector. First, even though looking at the uAPI
>eth_type and vlan_ethtype appear like a distinct fields, in flower they
>are all mapped to the same key->basic.n_proto. Second, flow dissector
>skips following VLAN header as no keys for FLOW_DISSECTOR_KEY_CVLAN are
>set and eventually assigns the value of n_proto to last parsed header.
>With these, such filters ignore any headers present between first VLAN
>header and first "non magic" header (ipv4 in this case) that doesn't
>result FLOW_DISSECT_RET_PROTO_AGAIN.
>
>Is described behavior intentional? Any way to enforce matching for
>header following the VLAN header?

Looks very much like a bug to me.

>
>Regards,
>Vlad
