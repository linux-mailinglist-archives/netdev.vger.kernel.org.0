Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9509A5A4AED
	for <lists+netdev@lfdr.de>; Mon, 29 Aug 2022 14:04:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230486AbiH2MEO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Aug 2022 08:04:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33212 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229509AbiH2MDs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Aug 2022 08:03:48 -0400
Received: from mail-wr1-f49.google.com (mail-wr1-f49.google.com [209.85.221.49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C1ED89810;
        Mon, 29 Aug 2022 04:48:54 -0700 (PDT)
Received: by mail-wr1-f49.google.com with SMTP id az27so9831033wrb.6;
        Mon, 29 Aug 2022 04:48:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=user-agent:content-disposition:mime-version:message-id:subject:to
         :from:date:from:to:cc;
        bh=/Di7lkoE4PMDXxx+KkgEBZLTyvjkUh6iLYQL6rsJ/+4=;
        b=kaLiTO3uz69oCN4+obPyA7IvFEwMUQt4ZXB/gpCbSytpTKaDsW0nIRGyUJlrfFsdvE
         mTMdi/Z4w215r5xJBREm+A9DCZWdKMDh9eP4c8/x3R5xGY1Hj6pf8n0K/p2+vM2pyS5q
         EH0TfHmeSyxe2CLjCBzM+P4TTrUSlSTU/5kLYioLrW6im0+coy5EfOhPV1wi9aFRYsKQ
         hdcV+CcTtuR2pH8q0XIYhRZxh8JLh0rNtGd2NdQ2X3bDN1rkv3ZahAOHeRI+AXcweHvy
         isZDOgf8r2OYCTu57efimyUr2retjmscs1Oo6dcHFsHyruJqIe81Jp4UvEJuyYovbuz2
         4y9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=user-agent:content-disposition:mime-version:message-id:subject:to
         :from:date:x-gm-message-state:from:to:cc;
        bh=/Di7lkoE4PMDXxx+KkgEBZLTyvjkUh6iLYQL6rsJ/+4=;
        b=chtjH6W5gh6gGEp5VMHs68GGc3Nr+S0YFlEU2je8FdMhdQbHelfiKvHhH8GKOikjVf
         QU7XLyuDHXLZUzPfNrSvWqlA6Vl6IZelO2BkJdTn4DQYry147GqCAbAh67vV5fEPdRqN
         PJuaI/LH96yullbCgk6yYc2CY+cWL0IEMV658D6lia+VWJLuqLmIXC4Sx92UgXI86a0D
         XksO4wJotQ5LsO2e0hdE/w62dUOm4IpufRH/ktdfyz/jSl/mE/ju+WAMRB+PDYetTXn2
         LqG3JLyDH9NXsIc+SHIYedpPGSaMucumE2FB4K+OJdvEquQMnLBtT3k6ZswgGiSNQRi3
         W6nQ==
X-Gm-Message-State: ACgBeo2dGpJAmrz/DzEbvpwZVbkqKsImg1/+K8tQS117HBZBW6F+e7TU
        Ooj9Jfufj9PjSWk5LeAOOEE=
X-Google-Smtp-Source: AA6agR6Q8pcDSR2sGpo6Z+/Xk8vC5hvOIOH6YppdFlNOZIdRGVsL+2Mi1+jD+E1YNRyMMa7NoROLsA==
X-Received: by 2002:a5d:64e9:0:b0:220:7dd7:63eb with SMTP id g9-20020a5d64e9000000b002207dd763ebmr6085539wri.590.1661773583790;
        Mon, 29 Aug 2022 04:46:23 -0700 (PDT)
Received: from debian ([89.238.191.199])
        by smtp.gmail.com with ESMTPSA id i13-20020a05600c354d00b003a5f4fccd4asm8896858wmq.35.2022.08.29.04.46.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 29 Aug 2022 04:46:23 -0700 (PDT)
Date:   Mon, 29 Aug 2022 13:44:35 +0200
From:   Richard Gobert <richardbgobert@gmail.com>
To:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, corbet@lwn.net, yoshfuji@linux-ipv6.org,
        dsahern@kernel.org, alex.aring@gmail.com,
        stefan@datenfreihafen.org, pablo@netfilter.org,
        kadlec@netfilter.org, fw@strlen.de, kafai@fb.com,
        netdev@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-wpan@vger.kernel.org,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org
Subject: [PATCH 0/4] net-next: frags: add adaptive per-peer timeout under load
Message-ID: <20220829114427.GA2311@debian>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch series introduces an optimization of fragment queues under
load.

The goal is to improve upon the current approach of static timeouts
(frag_timeout, 30 seconds by default) by implementing Eric's
suggestion of reducing timeouts under load [1], with additional
considerations for peer-specific load.

The timeout reduction is done dynamically per peer, based on both
global and peer-specific load. low_thresh is reintroduced and now acts 
as a knob for adjusting per-peer memory limits.

A comparison of netperf results before and after applying the patch:

Before:
    [vm1 ~]# ./super_netperf.sh 10 -H 172.16.43.3 -l 60 -t UDP_STREAM
    103.23

After:
    [vm1 ~]# ./super_netperf.sh 10 -H 172.16.43.3 -l 60 -t UDP_STREAM
    576.17

And another benchmark of a more specific use case.
One high-bandwidth memory-hogging peer (vm1), and another "average"
client (vm2), attempting to communicate with the same server:

Before:
    [vm1 ~]# ./super_netperf.sh 10 -H 172.16.43.3 -l 60 -t UDP_STREAM
	42.57
	[vm2 ~]# ./super_netperf.sh 1 -H 172.16.43.3 -l 60 -t UDP_STREAM
	50.93

After:
    [vm1 ~]# ./super_netperf.sh 10 -H 172.16.43.3 -l 60 -t UDP_STREAM
	420.65
	[vm2 ~]# ./super_netperf.sh 1 -H 172.16.43.3 -l 60 -t UDP_STREAM
	624.79


These benchmarks were done using the following configuration:

[vm3 ~]# grep . /proc/sys/net/ipv4/ipfrag_*
/proc/sys/net/ipv4/ipfrag_high_thresh:104857600
/proc/sys/net/ipv4/ipfrag_low_thresh:78643200
/proc/sys/net/ipv4/ipfrag_max_dist:64
/proc/sys/net/ipv4/ipfrag_secret_interval:0
/proc/sys/net/ipv4/ipfrag_time:30

Regards,
Richard

[1] https://www.mail-archive.com/netdev@vger.kernel.org/msg242228.html

Richard Gobert (4):
  net-next: frags: move inetpeer from ip4 to inet
  net-next: ip6: fetch inetpeer in ip6frag_init
  net-next: frags: add inetpeer frag_mem tracking
  net-next: frags: dynamic timeout under load

 Documentation/networking/ip-sysctl.rst  |  3 +
 include/net/inet_frag.h                 | 13 ++---
 include/net/inetpeer.h                  |  1 +
 include/net/ipv6_frag.h                 |  3 +
 net/ieee802154/6lowpan/reassembly.c     |  2 +-
 net/ipv4/inet_fragment.c                | 77 ++++++++++++++++++++++---
 net/ipv4/inetpeer.c                     |  1 +
 net/ipv4/ip_fragment.c                  | 25 ++------
 net/ipv6/netfilter/nf_conntrack_reasm.c |  2 +-
 net/ipv6/reassembly.c                   |  2 +-
 10 files changed, 89 insertions(+), 40 deletions(-)

-- 
2.36.1

