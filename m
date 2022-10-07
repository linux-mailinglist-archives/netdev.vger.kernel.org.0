Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9305D5F7FB8
	for <lists+netdev@lfdr.de>; Fri,  7 Oct 2022 23:19:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230102AbiJGVS5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Oct 2022 17:18:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60644 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230170AbiJGVS3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Oct 2022 17:18:29 -0400
Received: from mail-pf1-x42b.google.com (mail-pf1-x42b.google.com [IPv6:2607:f8b0:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1951311C6D4
        for <netdev@vger.kernel.org>; Fri,  7 Oct 2022 14:18:04 -0700 (PDT)
Received: by mail-pf1-x42b.google.com with SMTP id y8so5919104pfp.13
        for <netdev@vger.kernel.org>; Fri, 07 Oct 2022 14:18:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:subject:to:from
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=+GETzOAH5GKc5WsbRD9x0xSb326sHIZPUJb5V6xHKRE=;
        b=4DOGKo/Bkv1ODBQNIL2e00eIS4PDubv9ni1z6VyGh7SahRSDDLKx1pr+Kmdp6cfBM0
         FHZ6iXB6RZtx3Ut2+KEZAxT4GAPSciWOeCI7rD12q4oO7K7FvD96ZKKUgACcZcjTH3uA
         BZhXdNbMTYHkQYFnN068i2qSVPGOLB/x4DOHNnLJpVMjvw6ZWQcnWfoxTIRyH6tF4M7d
         ZTpdmkyxgvThwsFieD7FMDoHJ/OiJ4zItjIMTNX3QiK8I+A1KB6VlWkmoNOGhd9qAdZ0
         GbwVKgpTzHNrVQO90dWnKLu7YyfmRs/YYtu7ieVpaN70+0kJCRb1Mk6U4N7k6wws/NDd
         JjSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:subject:to:from
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=+GETzOAH5GKc5WsbRD9x0xSb326sHIZPUJb5V6xHKRE=;
        b=lb2153aEEOAJYSR6mmwnLqxEkvJsO2//Pq9FE0gd7qb/CQoJ35RfuBcEVBJMdpnJfH
         jjx5WKj/Jp8it4Oyzrz+M0leUlUaxQ1XMEeRIFjAx09WlNRTD39RSICSxZ1AzkBCcHU7
         6pIFa4xH6BaARiFPlj9ZQM1L+CnBMcaz6SXyi4nmjVbrfYqGPOKO5c+qoD2hiMOOiip2
         +rMMHepox6Ptzk0P7I7N8xcrCmCSh94/fH0xM7nJp219UadIzbRdLtZ96f50DalPLzpv
         8L9ONdL7ZCObYsI1j/Kzf4b2dMzY/ot5PfQs8WwkLzdtpc+6feGQktMtp+7Wy58GXb4j
         XrsQ==
X-Gm-Message-State: ACrzQf3/66NKWTphziq6WpoEHqxg7YbZziZiqSbPGd27DXv4K9lWG3fb
        YZZAZ4rVQmLQHkzP0J4C02gCsYQTbqp9Iw==
X-Google-Smtp-Source: AMsMyM4r4smY+aIgN+ZW8YrcAdlFaqbAsxclHcaGZ37M4d32EX48fiu7a0kkamk7pLSflINM6MaVXg==
X-Received: by 2002:a62:1744:0:b0:562:4e9b:3e0c with SMTP id 65-20020a621744000000b005624e9b3e0cmr7096354pfx.63.1665177473350;
        Fri, 07 Oct 2022 14:17:53 -0700 (PDT)
Received: from hermes.local (204-195-120-218.wavecable.com. [204.195.120.218])
        by smtp.gmail.com with ESMTPSA id x12-20020a17090300cc00b0017dd8c8009esm1964100plc.4.2022.10.07.14.17.52
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 07 Oct 2022 14:17:53 -0700 (PDT)
Date:   Fri, 7 Oct 2022 14:17:51 -0700
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     netdev@vger.kernel.org
Subject: Fw: [Bug 216557] New: tcp connection not working over ip_vti
 interface
Message-ID: <20221007141751.1336e50b@hermes.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



Begin forwarded message:

Date: Fri, 07 Oct 2022 20:51:12 +0000
From: bugzilla-daemon@kernel.org
To: stephen@networkplumber.org
Subject: [Bug 216557] New: tcp connection not working over ip_vti interface


https://bugzilla.kernel.org/show_bug.cgi?id=216557

            Bug ID: 216557
           Summary: tcp connection not working over ip_vti interface
           Product: Networking
           Version: 2.5
    Kernel Version: 5.15.53
          Hardware: All
                OS: Linux
              Tree: Mainline
            Status: NEW
          Severity: high
          Priority: P1
         Component: IPV4
          Assignee: stephen@networkplumber.org
          Reporter: monil191989@gmail.com
        Regression: No

TCP protocol is not working, when ipsec tunnel has been setup and ip_vti tunnel
is used for route based ipsec.

After the below changes merged with latest kernel. xfrm4_policy_check in
tcp_v4_rcv drops all packets except first syn packet under XfrmInTmplMismatch
when local destined packets are received over ip_vti tunnel.

author  Eyal Birger <eyal.birger@gmail.com>     2022-05-13 23:34:02 +0300
committer       Greg Kroah-Hartman <gregkh@linuxfoundation.org> 2022-05-25
09:57:30 +0200
commit  952c2464963895271c31698970e7ec1ad6f0fe45 (patch)
tree    9e8300c45a0eb5a9555eae017f8ae561f3e8bc51 /include/net/xfrm.h
parent  36d8cca5b46fe41b59f8011553495ede3b693703 (diff)
download        linux-952c2464963895271c31698970e7ec1ad6f0fe45.tar.gz
xfrm: fix "disable_policy" flag use when arriving from different devices


setup:
1) create road warrior ipsec tunnel with local ip x.x.x.x remote ip y.y.y.y.
2) create vti interface using ip tunnel add vti_test local x.x.x.x remote
y.y.y.y mode vti 
3) echo 1 > /proc/sys/net/ipv4/conf/vti_test/disable_policy
4) Add default route over vti_test.
5) ping remote ip, ping works.
6) ssh remote ip, ssh dont work. check tcp connection not working.

Root cause:
-> with above mentioned commit, now xfrm4_policy_check depends on skb's  
IPSKB_NOPOLICY flag which need to be set per skb and it only gets set in
ip_route_input_noref .

-> before above change, xfrm4_policy_check was using DST_NOPOLICY which was  
checked against dst set in skb.

-> ip_rcv_finish_core calls ip_route_input_noref only if dst is not valid in  
skb.

-> By default in kernel sysctl_ip_early_demux = 1, which means when skb with  
syn is received, tcp stack will set DST from skb to sk and in subsequent
packets it will copy dst from sk to skb and skip calling ip_route_input_nore
inside ip_rcv_finish_core.

-> so for all the subsequent  received packets, IPSKB_NOPOLICY will not get set  
and they will get drop.

workaround:
only work-aroud is to disable early tcp demux.
echo 0 > /proc/sys/net/ipv4/ip_early_demux

-- 
You may reply to this email to add a comment.

You are receiving this mail because:
You are the assignee for the bug.
