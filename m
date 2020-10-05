Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2D649283937
	for <lists+netdev@lfdr.de>; Mon,  5 Oct 2020 17:12:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727153AbgJEPLy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Oct 2020 11:11:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46074 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726574AbgJEPLx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Oct 2020 11:11:53 -0400
Received: from mail-wr1-x441.google.com (mail-wr1-x441.google.com [IPv6:2a00:1450:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3FD62C0613CE
        for <netdev@vger.kernel.org>; Mon,  5 Oct 2020 08:11:53 -0700 (PDT)
Received: by mail-wr1-x441.google.com with SMTP id e18so4099664wrw.9
        for <netdev@vger.kernel.org>; Mon, 05 Oct 2020 08:11:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=6wind.com; s=google;
        h=reply-to:subject:to:cc:references:from:organization:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=5Tky34R99O43DnZHfcfRPW1fBxwnqwTD6f0bUubj1/w=;
        b=MyhsnP5ro6om4Q+jFLCDIkqCPofcMctwzdUXIoLH/+xWCWAHuYn6c0zoDbifTReI9g
         XzOV9mQyG/Nh5wGc9ZFh+ZNhK8SeLDHbfLO+8YFg/skD57NF5flqYzIGZXy9S+BPaSjF
         C7ifg4RFvMjMEFMktulh5pjG5+CP4EamRTlLxEPb3c7LcORjD/M7bDC4BScT0oTRzjkp
         WuOCpOuo5H8ddC2CgrvuJkxhgBInvLBe/DmHfhP8PwpDALvHi/FdTIjeiHCnlqYoD74g
         fEnLmRyVQ4ihzsNUB6yGSpb/3dqEAQiJzjsr4GH35Xg4UL/Pzj2835FPNAIVRNzotCbv
         RRPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:reply-to:subject:to:cc:references:from
         :organization:message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=5Tky34R99O43DnZHfcfRPW1fBxwnqwTD6f0bUubj1/w=;
        b=NFNDrOAU0nxahC6BhpdaH2wQWia+MKgVLxRP26oqRZhdCSyyEvr0HDbPw7pigm3PIy
         ipP6lX8Yx2U+W9drGymN70BLBKSQaZ3Owonb/Bv7RE3wfvfuuN0Cnc4NaIb6vdh8uB0i
         L5Gn0ifQNMRymlvIKt37A66aiI/B5/EtF+6WTbWEhEC1OHE8oTFR3K5G9pyrx27Goy01
         1o+0Nm95q0dU43g8O4gWpmMz+6kh8REMVOTJRtYNjB+W3fDx/0sbCsL1uFdbO3zYj5UF
         7vLkStwnGK9bQhafk1ZuXGvGhfLzTEV+gAGClTmdDnjWBwnLdh34YJJZPRPfr1XEz/zl
         s8Bw==
X-Gm-Message-State: AOAM533DK1T0be4wZVzBT3jVEU6b4DXxEQhPnZaPANeCNq4N6szmUpFA
        ikSYgJTeePkrVu+so5TJkHTEosc8RMdIhg==
X-Google-Smtp-Source: ABdhPJwUmGs/N1PaEflMoXvFTvhMHxI+/bThLgNqEx4HBE0PAu16pfU+P27CGwi6V0QM+Q5lEK+HzQ==
X-Received: by 2002:adf:dd83:: with SMTP id x3mr12179783wrl.333.1601910711308;
        Mon, 05 Oct 2020 08:11:51 -0700 (PDT)
Received: from ?IPv6:2a01:e0a:410:bb00:d146:d085:7412:4af5? ([2a01:e0a:410:bb00:d146:d085:7412:4af5])
        by smtp.gmail.com with ESMTPSA id h4sm386348wrm.54.2020.10.05.08.11.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 05 Oct 2020 08:11:48 -0700 (PDT)
Reply-To: nicolas.dichtel@6wind.com
Subject: Re: [PATCH 10/19] xfrm: interface: support IP6IP6 and IP6IP tunnels
 processing with .cb_handler
To:     Xin Long <lucien.xin@gmail.com>
Cc:     Steffen Klassert <steffen.klassert@secunet.com>,
        David Miller <davem@davemloft.net>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        network dev <netdev@vger.kernel.org>
References: <20200730054130.16923-1-steffen.klassert@secunet.com>
 <20200730054130.16923-11-steffen.klassert@secunet.com>
 <c79acf02-f6a9-8833-fca4-94f990c1f1f3@6wind.com>
 <CADvbK_c6gbV-F9Lv6aiT6JbGGJD96ExWxTj_SWerJsvwvzOoXQ@mail.gmail.com>
From:   Nicolas Dichtel <nicolas.dichtel@6wind.com>
Organization: 6WIND
Message-ID: <621ebebc-c73d-b707-3faf-c315e45cf4a4@6wind.com>
Date:   Mon, 5 Oct 2020 17:11:47 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <CADvbK_c6gbV-F9Lv6aiT6JbGGJD96ExWxTj_SWerJsvwvzOoXQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Le 03/10/2020 à 11:41, Xin Long a écrit :
[snip]
> When xfrmi processes the ipip packets, it does the state lookup and xfrmi
> device lookup both in xfrm_input(). When either of them fails, instead of
> returning err and continuing the next .handler in tunnel4_rcv(), it would
> drop the packet and return 0.
> 
> It's kinda the same as xfrm_tunnel_rcv() and xfrm6_tunnel_rcv().
> 
> So the safe fix is to lower the priority of xfrmi .handler but it should
> still be higher than xfrm_tunnel_rcv() and xfrm6_tunnel_rcv(). Having
> xfrmi loaded will only break IPCOMP, and it's expected. I'll post a fix:
Thanks. This patch fixes my test cases.


Regards,
Nicolas
