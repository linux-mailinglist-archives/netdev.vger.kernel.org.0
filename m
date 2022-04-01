Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CA1CA4EF7C9
	for <lists+netdev@lfdr.de>; Fri,  1 Apr 2022 18:23:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346024AbiDAQY0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Apr 2022 12:24:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58782 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354771AbiDAQUp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Apr 2022 12:20:45 -0400
Received: from mail-qt1-x832.google.com (mail-qt1-x832.google.com [IPv6:2607:f8b0:4864:20::832])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D03B1C9B5F
        for <netdev@vger.kernel.org>; Fri,  1 Apr 2022 08:48:46 -0700 (PDT)
Received: by mail-qt1-x832.google.com with SMTP id bp39so2485424qtb.6
        for <netdev@vger.kernel.org>; Fri, 01 Apr 2022 08:48:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=OdazKsT4zwALASF1clrx3fpK2qYOv74SM0Ti28iF3/A=;
        b=RMzlQlbMGDSKtWYL3rHde+nqXaHK1ey+Mvm2SYxpGZ9ak2AD6PN82NKcOEh51CDdts
         0+6ZXS1jX8CJMD+8neSCEXmnak9kCA2CMsTSvyNfDOgp13heLHaIyZA6Qh00/RuI7MnF
         DO6l+hjYRHAG0fn2FwraH/02MgIKlz6Sn27X8ZeJsfOBEBJyIV7m11JOwSlthTLnzUAT
         DaXcGdgrmeY87AxmnjLS4wLky2QDc2k2CNRz6b6lSPAYZu317yvNKWxUX1c6Z0e8jRkt
         MJeZddoxU3CsRfUinkSqp08J68R4fHWtA75JSWfPQDDf32CUAzNuGEZHdsozh/SRr/x6
         R/jw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=OdazKsT4zwALASF1clrx3fpK2qYOv74SM0Ti28iF3/A=;
        b=BOOZKULmzfFbx/CU5AKnq5HdybAsyT9q37/zWqIorj7Jquiy50QT3YiohFTnoXCO/Z
         Zn2awY8ZUStHdrEJAhxLX0XtcniIsXsmMUq6zA3EhS7dVjntKxRVHhnD4NcoMnNlXiej
         XBGDPjA2sCDHn7R3xboZ0XUiUJgXRcvp7cKWMXZBiwi0ci69bQoe4yGFrP6slKBrjF3b
         kRjhRE0AtKHntrZKhrUHaDVexDQ8DRvpIVFDaDSgutTw4JDj0jugOH4t2pS0mBXNHLho
         0dJIU5fvUAL5XdhYbndc7KIHkYT2PX+MHLbwTK9MH33KM+PkKfsuskuu3TJDVR5qC2g3
         k6xQ==
X-Gm-Message-State: AOAM531yTkf9XPd+mXF66PP1xR60k27famBfvHZHGXTlfVNwtxrETT6J
        /0Se8eOPij7K97Quiu+JPFmUjN3Z45XfTQ6hB/mULAT0/SysSw==
X-Google-Smtp-Source: ABdhPJzav944GWPejGPUlcv6W3f8OuZnqsV/DU/7HYCgcLKNAps6ko20IFI10Js2nAAHafmkOWVBbzBku8KOcCyHqYE=
X-Received: by 2002:a05:622a:507:b0:2e2:3401:49e3 with SMTP id
 l7-20020a05622a050700b002e2340149e3mr8920548qtx.560.1648828125277; Fri, 01
 Apr 2022 08:48:45 -0700 (PDT)
MIME-Version: 1.0
References: <E1nZMdl-0006nG-0J@plastiekpoot> <CADVnQyn=A9EuTwxe-Bd9qgD24PLQ02YQy0_b7YWZj4_rqhWRVA@mail.gmail.com>
 <eaf54cab-f852-1499-95e2-958af8be7085@uls.co.za> <CANn89iKHbmVYoBdo2pCQWTzB4eFBjqAMdFbqL5EKSFqgg3uAJQ@mail.gmail.com>
 <10c1e561-8f01-784f-c4f4-a7c551de0644@uls.co.za> <CADVnQynf8f7SUtZ8iQi-fACYLpAyLqDKQVYKN-mkEgVtFUTVXQ@mail.gmail.com>
 <e0bc0c7f-5e47-ddb7-8e24-ad5fb750e876@uls.co.za> <CANn89i+Dqtrm-7oW+D6EY+nVPhRH07GXzDXt93WgzxZ1y9_tJA@mail.gmail.com>
 <CADVnQyn=VfcqGgWXO_9h6QTkMn5ZxPbNRTnMFAxwQzKpMRvH3A@mail.gmail.com>
 <5f1bbeb2-efe4-0b10-bc76-37eff30ea905@uls.co.za> <CADVnQymPoyY+AX_P7k+NcRWabJZrb7UCJdDZ=FOkvWguiTPVyQ@mail.gmail.com>
 <CADVnQy=GX0J_QbMJXogGzPwD=f0diKDDxLiHV0gzrb4bo=4FjA@mail.gmail.com>
In-Reply-To: <CADVnQy=GX0J_QbMJXogGzPwD=f0diKDDxLiHV0gzrb4bo=4FjA@mail.gmail.com>
From:   Neal Cardwell <ncardwell@google.com>
Date:   Fri, 1 Apr 2022 11:48:29 -0400
Message-ID: <CADVnQy=pOfT+OmXdibc6y6uWMk2i_5ZBC1_1JZyt=vOjWhyQAw@mail.gmail.com>
Subject: Re: linux 5.17.1 disregarding ACK values resulting in stalled TCP connections
To:     Jaco Kroon <jaco@uls.co.za>
Cc:     Eric Dumazet <edumazet@google.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Netdev <netdev@vger.kernel.org>,
        Yuchung Cheng <ycheng@google.com>, Wei Wang <weiwan@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Apr 1, 2022 at 11:39 AM Neal Cardwell <ncardwell@google.com> wrote:
...
> Jaco, to provide some evidence for this hypothesis, can you please
> re-enable fastopen but also enable the TFO blackhole detection that
> was disabled in v5.14 (213ad73d0607), with something like:
>
>   sysctl -w net.ipv4.tcp_fastopen=1
>   sysctl -w tcp_fastopen_blackhole_timeout=3600

I would also suggest using Florian's suggestion to log invalid
packets, so perhaps we can get a clue as to why netfilter thinks these
packets are invalid:

    sysctl net.netfilter.nf_conntrack_log_invalid=6

> And then after a few hours, check to see if this blackholing behavior
> has been detected:
>   nstat -az | grep -i blackhole
> And see if TFO FastOpenActive attempts have been cut to a super-low rate:
>   nstat -az | grep -i fastopenactive

Then I would correspondingly echo Florian's suggestion to check
dmesg/syslog/nflog to learn more about the drops.

neal
