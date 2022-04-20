Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AE661508DD2
	for <lists+netdev@lfdr.de>; Wed, 20 Apr 2022 18:55:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1380804AbiDTQ57 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Apr 2022 12:57:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45060 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1380876AbiDTQ5s (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Apr 2022 12:57:48 -0400
Received: from mail-ed1-x52e.google.com (mail-ed1-x52e.google.com [IPv6:2a00:1450:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D590626D7
        for <netdev@vger.kernel.org>; Wed, 20 Apr 2022 09:55:00 -0700 (PDT)
Received: by mail-ed1-x52e.google.com with SMTP id 11so3154019edw.0
        for <netdev@vger.kernel.org>; Wed, 20 Apr 2022 09:55:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:mime-version:content-disposition;
        bh=AVhwXWB2m+bXpnKErBOOZwqaaygODehd/Foni28JqcU=;
        b=eNCMSkbFpTqDKMBZcHRaXP6r8UyecgrRl26r2vmkcFPRlqr+B4/t/KjFVQZ4QpBeR9
         iHK6TciYi/9+BJ2TrKCGk7awWlBF/DDkPh5LbDGPx0KWt4fTaryvUj3KcbmKZTNygAnk
         jTYjx9/NXfHVnzfYTQDAnLfzTYf9JeHq3sYtiBh7AWkM5iQLyJpVl2Tmybs0FkOEsSwD
         k195jZbEban0HCZgwoTAYAWlU8uqf9MT//1t4JhjO5ccz4WSTIn69zVXGUVg0e2Iv44s
         gpch/M3QHzVCAa4BWOkJkG0OlG1J9cY+sgAUCxsylmLqDtRpQ4qq8n0N1LNPd9eVXBi2
         JPvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition;
        bh=AVhwXWB2m+bXpnKErBOOZwqaaygODehd/Foni28JqcU=;
        b=bosDGc6xcr3/5MC/Ky5z7oY6OY1BaR4E6YpYbALAgxvc78Zq5Cq51/49wBG94ipcF0
         GVoBy41siLNK+XbbxWMqMSZKHpveIb6QeWw7uyUmrWkBoiPkV5LS5NSw+g1cJJR+l6Na
         xQGvn16fjfdTqmrFDNawfZdourrnnXNLCTvkic/UOK3j6/vS0ju0NRYtnbZotnj0goDp
         YjxnoUocqXJ7x+HSOTaQu8DXANQZKWaZ+beD5TN5LC+ZxsnFDboGcOpjiS94rhbe4IjA
         5gLnMovdZQRDwlxreighRvbWFm/hAVJWOHgixTfvwtEbrExM+fvDAqPReIJV/J8HDJJ2
         P6jg==
X-Gm-Message-State: AOAM530R1nYUzzQDwU74u9UdbelCB8w47tsuE/l2FMMaBT9MQaLQaDqy
        mXaVaEWgW6RSZvc8LtLVGMdZT2t4Ak0=
X-Google-Smtp-Source: ABdhPJxQ59ECz/PR7dLMYWZUMWDtjGECeKdL3PgWoNsvxlCeZYOVyeAG13MEMPinrdH5nJTtISoKbA==
X-Received: by 2002:a50:ef03:0:b0:41d:7084:13e8 with SMTP id m3-20020a50ef03000000b0041d708413e8mr24444034eds.54.1650473699263;
        Wed, 20 Apr 2022 09:54:59 -0700 (PDT)
Received: from skbuf ([188.26.185.183])
        by smtp.gmail.com with ESMTPSA id fy29-20020a1709069f1d00b006e8d248fc2csm6690019ejc.108.2022.04.20.09.54.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Apr 2022 09:54:58 -0700 (PDT)
Date:   Wed, 20 Apr 2022 19:54:57 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     David Ahern <dsahern@gmail.com>
Cc:     netdev@vger.kernel.org
Subject: IPv6 multicast with VRF
Message-ID: <20220420165457.kd5yz6a6itqfcysj@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

I don't have experience with either IPv6 multicast or VRF, yet I need to
send some IPv6 multicast packets from a device enslaved to a VRF, and I
don't really know what's wrong with the routing table setup.

The system is configured in the following way:

 ip link set dev eth0 up

 # The kernel kindly creates a ff00::/8 route for IPv6 multicast traffic
 # in the local table, and I think this is what makes multicast route
 # lookups find the egress device.
 ip -6 route show table local
local ::1 dev lo proto kernel metric 0 pref medium
local fe80::204:9fff:fe05:f4ab dev eth0 proto kernel metric 0 pref medium
multicast ff00::/8 dev eth0 proto kernel metric 256 pref medium

 ip -6 route get ff02::1
multicast ff02::1 dev eth0 table local proto kernel src fe80::204:9fff:fe05:f4ab metric 256 pref medium

 ip link add dev vrf0 type vrf table 3 && ip link set dev vrf0 up

 ip -4 route add table 3 unreachable default metric 4278198272

 ip -6 route add table 3 unreachable default metric 4278198272

 ip link set dev eth0 master vrf0

The problem seems to be that, although the "ff00::/8 dev eth0" route
migrates from table 255 to table 3, route lookups after this point fail
to find it and return -ENETUNREACH (ip6_null_entry).

 ip -6 route show table local
local ::1 dev lo proto kernel metric 0 pref medium

 ip -6 route show table main
::1 dev lo proto kernel metric 256 pref medium

 ip -6 route show table 3
local fe80::204:9fff:fe05:f4ab dev eth0 proto kernel metric 0 pref medium
fe80::/64 dev eth0 proto kernel metric 256 pref medium
multicast ff00::/8 dev eth0 proto kernel metric 256 pref medium
unreachable default dev lo metric 4278198272 pref medium

 ip -6 route get ff02::1
RTNETLINK answers: Network is unreachable

 ip -6 route get vrf vrf0 ff02::1
RTNETLINK answers: Network is unreachable

I'm not exactly sure what is missing?
