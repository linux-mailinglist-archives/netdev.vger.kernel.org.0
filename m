Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 543FF3F91DF
	for <lists+netdev@lfdr.de>; Fri, 27 Aug 2021 03:20:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243898AbhH0BRt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Aug 2021 21:17:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38386 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231434AbhH0BRs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Aug 2021 21:17:48 -0400
Received: from mail-pl1-x634.google.com (mail-pl1-x634.google.com [IPv6:2607:f8b0:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 409EDC061757
        for <netdev@vger.kernel.org>; Thu, 26 Aug 2021 18:17:00 -0700 (PDT)
Received: by mail-pl1-x634.google.com with SMTP id q3so2893168plx.4
        for <netdev@vger.kernel.org>; Thu, 26 Aug 2021 18:17:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:from:subject:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=r1nYTq1DhC3Ti9UeEfkaAD7cQ4K/vppa7D4lE9B8SuI=;
        b=jn9y1ilXuQiyaxNNPHVD9fCujUqdXrGeVNxbSyqcF4ceCgNTFuHQEJtQ03XkPHUQkv
         K94P+K9eUAmbGoLpXLiFVNNylHQDk46sA/TD6I8+FIuMIcA4LED18CcHb0v7nrYamGXz
         S+BGc5/WuWbKo0Dp6otdMEfLIayBuvaYpEzHnWXIWYWTpNRCcX6+ff3eHlNKyUlFkGEY
         DYffPWDuZFYZOiZBG8u4afdc9ATkcf0pD1ckGnMhab9hiFQJTOXdapufCg8RIeqlu7Dm
         4RNrIxgUAiUeFbmTAbUXbbVT79EHDXqK2gbLpC1QefwhqZUt1XXZ8DB2W1jG85e8tyke
         p3/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:from:subject:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=r1nYTq1DhC3Ti9UeEfkaAD7cQ4K/vppa7D4lE9B8SuI=;
        b=ZTTl2Ecs/44U5z4VLtorTkJmQuinfEdaRY92/VvmLbPxEVEP4Qb/mhPL/JZvPCiCv7
         BSbHyn/qk19N7eGQ4Th1i8OGSdJAqvCtObiMwOGNcYtIVr+TPTepn+m8ip9+u4nKUPfc
         LKb0MQDFSCF67z/ZwHs/Dbj9jr7ycQg5w2FMOB9FIellMnBGLP87D0Yrc9POPiVp1TPd
         pfypv2CD/+l+mCbjdTRm9SF1dFu1oEwoKVa3dlexwuqhO+zUQX5SThPPAzkRBiVV3MGV
         3JrDkbPF6jP0p/5S8+JMEGtH72Of3zLJEvwkI5GhkZMyCqnz8uM172WRr7reNQhci85/
         B72g==
X-Gm-Message-State: AOAM530qtpnP4NPM2vRCNZSHPZfrNntQD+AeMbOw9aIOjuyrmxz0goet
        X+avTYiICIe/VXWXZExOnsTpN3qf3nU=
X-Google-Smtp-Source: ABdhPJySdsHKic9UsrwUzswUvHtVrWY1R2EdOCakTqWq8H0k+/8SrgcwH6qM30MJR2+ZIS9YHksKiQ==
X-Received: by 2002:a17:90a:168f:: with SMTP id o15mr7771682pja.158.1630027019538;
        Thu, 26 Aug 2021 18:16:59 -0700 (PDT)
Received: from [192.168.86.235] (c-73-241-150-58.hsd1.ca.comcast.net. [73.241.150.58])
        by smtp.gmail.com with ESMTPSA id z131sm4184422pfc.159.2021.08.26.18.16.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 26 Aug 2021 18:16:58 -0700 (PDT)
To:     Roopa Prabhu <roopa@cumulusnetworks.com>,
        Networking <netdev@vger.kernel.org>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Subject: Question about inet_rtm_getroute_build_skb()
Message-ID: <4a0ef868-f4ea-3ec1-52b9-4d987362be20@gmail.com>
Date:   Thu, 26 Aug 2021 18:16:56 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Roopa

I noticed inet_rtm_getroute_build_skb() has this endian issue 
when building an UDP header.

Would the following fix break user space ?

Thanks.

diff --git a/net/ipv4/route.c b/net/ipv4/route.c
index a6f20ee3533554b210d27c4ab6637ca7a05b148b..50133b935f868c2ae9474eea027a0ad864a43936 100644
--- a/net/ipv4/route.c
+++ b/net/ipv4/route.c
@@ -3170,7 +3170,7 @@ static struct sk_buff *inet_rtm_getroute_build_skb(__be32 src, __be32 dst,
                udph = skb_put_zero(skb, sizeof(struct udphdr));
                udph->source = sport;
                udph->dest = dport;
-               udph->len = sizeof(struct udphdr);
+               udph->len = htons(sizeof(struct udphdr));
                udph->check = 0;
                break;
        }
