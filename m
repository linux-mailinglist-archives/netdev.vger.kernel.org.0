Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6247C6E6530
	for <lists+netdev@lfdr.de>; Tue, 18 Apr 2023 15:01:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232021AbjDRNBX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Apr 2023 09:01:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54702 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232161AbjDRNBU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Apr 2023 09:01:20 -0400
Received: from mail-qv1-xf34.google.com (mail-qv1-xf34.google.com [IPv6:2607:f8b0:4864:20::f34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B1078F;
        Tue, 18 Apr 2023 06:01:19 -0700 (PDT)
Received: by mail-qv1-xf34.google.com with SMTP id h14so17238620qvr.7;
        Tue, 18 Apr 2023 06:01:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1681822878; x=1684414878;
        h=content-transfer-encoding:mime-version:subject:references
         :in-reply-to:message-id:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=CL9yk8kR8JQHCBiG6XJPcoKIWuAuKCuMXhZTdC/kwrs=;
        b=nKsTehVbZ82XntFvPWdPhF+0TCfRkC9HA8Q+iZ6PVkShou4eoJ2ewuO6YDNeDcnejk
         ja3tNceWubITIcWnV3jUea1VpEO8Em7upC1RXsuJnWiRlMTYfLwFKtslSvhuFKpE2VrC
         qtSOf+g0i/rEfmvvKMhf8DhB+1yIwNn8mqaBeakOeAandQQmb78vaF5E3dIGbn7mgwUj
         5C7Jbf0WOdk4zgL1gae1DJlo0mYbe7/TWCfdpAp1aAtCHIhZFpAWNg30fyMx/S6/4aSU
         ENo1mLyyh5qL3+bmFmL7g4q98gHjegb+ihMuYxqtJ0ciH9g5isNA0OKfBTb9V0C4AwGq
         dLnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681822878; x=1684414878;
        h=content-transfer-encoding:mime-version:subject:references
         :in-reply-to:message-id:cc:to:from:date:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=CL9yk8kR8JQHCBiG6XJPcoKIWuAuKCuMXhZTdC/kwrs=;
        b=MVP/d6Dx30vd78a5WuFGBWelSNtWr2hm+EnwqzxtifLWfLXdgWot81nzVRoGGYUGg6
         i850hQ+7RcbUQqx43wd6XV21oOMjwP07HsMQd0gJ2UzIPOO4WgKglhcZX/CM6kmu4Tf8
         Mp96gPPDvG1wPYPfJyPpBTaYLcOW/XNOmcdJDIAsL5DcKCjv/Jg/8RUyZF/u0qSjCiAG
         9eMCG3ABGmQDr1Dkb87Qglta15hwS+phQINEHS/d84+QJxnXvKaIfhZAsoC+fNDEUSo/
         BWJSt+p0gG0nll4LHohNSQxV7D6ez5KB/nmTkjsTw3s8qWnz3wCo3v6GoCkfJ8Tv6yPr
         YwNg==
X-Gm-Message-State: AAQBX9cLeO5+HnzzR1kpCsr/x67xMWEceouMm0K5holRXvc3FZKXzWBR
        tem5JP8OYa7602c0SuhrZQBW2NlfpNw=
X-Google-Smtp-Source: AKy350bUY+ve5/bYNtJHpsxYFA3wdEg5faDFlBXtu3rCcJ4Dj0VzAq8hz6tem8hH7nW0vAZ+PVjDbg==
X-Received: by 2002:ad4:4eae:0:b0:5ca:83ed:12be with SMTP id ed14-20020ad44eae000000b005ca83ed12bemr26507409qvb.21.1681822878386;
        Tue, 18 Apr 2023 06:01:18 -0700 (PDT)
Received: from localhost (240.157.150.34.bc.googleusercontent.com. [34.150.157.240])
        by smtp.gmail.com with ESMTPSA id dd11-20020ad4580b000000b005dd8b9345a8sm3698594qvb.64.2023.04.18.06.01.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Apr 2023 06:01:17 -0700 (PDT)
Date:   Tue, 18 Apr 2023 09:01:17 -0400
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
To:     Yang Yang <yang.yang29@zte.com.cn>, willemdebruijn.kernel@gmail.com
Cc:     davem@davemloft.net, edumazet@google.com, jiang.xuexin@zte.com.cn,
        kuba@kernel.org, linux-kernel@vger.kernel.org,
        linux-kselftest@vger.kernel.org, netdev@vger.kernel.org,
        pabeni@redhat.com, shuah@kernel.org, xu.xin16@zte.com.cn,
        yang.yang29@zte.com.cn, zhang.yunkai@zte.com.cn
Message-ID: <643e949db6497_328d8929430@willemb.c.googlers.com.notmuch>
In-Reply-To: <20230418012910.194745-1-yang.yang29@zte.com.cn>
References: <643d62b28e413_29adc929416@willemb.c.googlers.com.notmuch>
 <20230418012910.194745-1-yang.yang29@zte.com.cn>
Subject: RE: [PATCH linux-next 1/3] selftests: net: udpgso_bench_rx: Fix
 verifty exceptions
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Yang Yang wrote:
> > Why are you running two senders concurrently? The test is not intended
> > to handle that case.
> 
> Sorry for the inaccuracy of the description here, these two commands,
> i.e. with or without GSO, cause the problem. The same goes for patch 2/3.
> The problem is easily reproducible in the latest kernel, QEMU environment, E1000.
> 
> bash# udpgso_bench_tx -l 4 -4 -D "$DST" 
> udpgso_bench_tx: write: Connection refused
> bash# udpgso_bench_rx -4 -G -S 1472 -v
> udpgso_bench_rx: data[1472]: len 17664, a(97) != q(113)
> 
> bash# udpgso_bench_tx -l 4 -4 -D "$DST" -S 0
> udpgso_bench_tx: sendmsg: Connection refused
> bash# udpgso_bench_rx -4 -G -S 1472 -v
> udpgso_bench_rx: data[61824]: len 64768, a(97) != w(119)

I still don't follow: are you running the tx and rx commands
sequentially or in parallel? On different (virtual) hosts?
 
> In one test, the verification data is printed as follows:
> abcd...xyz
> ...
> abcd...xyz
> abcd...opabcd...xyz
> 
> This is because the sender intercepts from the buf at a certain length,
> which is not aligned according to 26 bytes, and multiple packets are
> merged. The verification of the receiving end needs to be performed
> after splitting.

The 26 bytes is a reference to the pattern printed by the test, which
iterates over A-Z.

Is your point that each individual segment starts at A, so that a test
for pattern {ABC..Z}+ only matches if the segments size is a multiple
of 26, else a the pattern will have discontinuities?


