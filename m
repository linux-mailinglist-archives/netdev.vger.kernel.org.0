Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F2E8F682F72
	for <lists+netdev@lfdr.de>; Tue, 31 Jan 2023 15:40:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230329AbjAaOkZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 Jan 2023 09:40:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39382 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229767AbjAaOkZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 31 Jan 2023 09:40:25 -0500
Received: from smtp-relay-internal-1.canonical.com (smtp-relay-internal-1.canonical.com [185.125.188.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A98EC3D931
        for <netdev@vger.kernel.org>; Tue, 31 Jan 2023 06:40:23 -0800 (PST)
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com [209.85.128.69])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-internal-1.canonical.com (Postfix) with ESMTPS id E2AE941AC9
        for <netdev@vger.kernel.org>; Tue, 31 Jan 2023 14:40:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1675176021;
        bh=XHZduMLns3Y7r5k79prz1oAhShsJx/gipbVLJCHhlGk=;
        h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
         Content-Type:In-Reply-To;
        b=ZHSGVeymwhlYOxob1o+xAbOj+J2o71IqdEZocANOLKYtJ5RRehlnmWh/HOw4oGxBc
         rBhQQwyXuDfLlnGrqSOUQHqyzS4gEEI4I67fG08Gk0zDPi7T4JEbCDCXYnd+pf5BGU
         rpDTuJk9kUhcq9osaUHzrP/eQUohsiczVj89Sx9ZT+YDJ6EfSDGvSMur/1kFGGjSET
         2U6UmhYKBRrdkNLSC64BSUru36APVDzVqBHMZu1plmPUjGjYrncGRnAcYGkTuH4QVN
         AYc5bGNVyrC5E22FnnXJ6PSsz1MmVhJcQPj3uOvOX2J78HJWX7i2BnfFZcyDnOlK+E
         P/Lpu+G0ssWoA==
Received: by mail-wm1-f69.google.com with SMTP id r15-20020a05600c35cf00b003d9a14517b2so11399521wmq.2
        for <netdev@vger.kernel.org>; Tue, 31 Jan 2023 06:40:21 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=XHZduMLns3Y7r5k79prz1oAhShsJx/gipbVLJCHhlGk=;
        b=iI1tlJM814YKfDVN6+Ks+2dSpzszs0NlMEicMmYYNslYaOxH3WCVrPQkss0HTe3EQi
         JQ2HfHp/tUYsfGJDN7sHJCdkE59Fa/K6RdK9Xr/2JiHrQGPHm2tCVSwyLMI81rfdtgYu
         ORnkoQD7Sj1I5jU08p3Bl3/O56DSOWkO9fO6LKin/tfVPbkDYXi5iCIEmB+KeBVMaYCU
         +8C/ohhqDB/pAwciq/6WB/u6mYllFhR4GaHspQkWaS+UNHLWqSf4CPLGobkyDVX/Y/AD
         +uhfj23kZVckeYFkaYLitfRgy1FM8QldgHXRLZSf41EZPL8sRgfSj/pclW8zSGJAPcJF
         kOhA==
X-Gm-Message-State: AO0yUKVA+j/DXJ7fkY9dHbFmQ8bmVkAmWxMMZ85d3VsphvGnMv065LQL
        FH1YwRWmXKTFQYyObHoH0zKqrHi/vPYuKvFahDZHPY1Kerm5TNhW8u+/w8+jCbaXudR1r/WWaak
        CfSKVuVjamilXSSlA+dE2hubdlD2cHiSG9Q==
X-Received: by 2002:a05:600c:3b8f:b0:3dc:4633:9844 with SMTP id n15-20020a05600c3b8f00b003dc46339844mr15329504wms.17.1675176021641;
        Tue, 31 Jan 2023 06:40:21 -0800 (PST)
X-Google-Smtp-Source: AK7set+EbSgEyXZd4rdDr0ISKIc/bI1f2vwrKcgwG0bUb2kTOVWw33DTexl9UMEDfIuhWw4JxLpblg==
X-Received: by 2002:a05:600c:3b8f:b0:3dc:4633:9844 with SMTP id n15-20020a05600c3b8f00b003dc46339844mr15329456wms.17.1675176021119;
        Tue, 31 Jan 2023 06:40:21 -0800 (PST)
Received: from qwirkle ([2001:67c:1560:8007::aac:c4dd])
        by smtp.gmail.com with ESMTPSA id c3-20020a1c3503000000b003dc1d668866sm19414222wma.10.2023.01.31.06.40.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 31 Jan 2023 06:40:20 -0800 (PST)
Date:   Tue, 31 Jan 2023 14:40:18 +0000
From:   Andrei Gherzan <andrei.gherzan@canonical.com>
To:     Willem de Bruijn <willemb@google.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Shuah Khan <shuah@kernel.org>,
        netdev@vger.kernel.org, linux-kselftest@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 2/4] selftests: net: udpgso_bench_rx/tx: Stop when
 wrong CLI args are provided
Message-ID: <Y9koUno9kGkNJkma@qwirkle>
References: <20230131130412.432549-1-andrei.gherzan@canonical.com>
 <20230131130412.432549-2-andrei.gherzan@canonical.com>
 <CA+FuTSf1ffpep=wV=__J96Ju_nPkd96=c+ny4mC+SxrhRp0ofA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+FuTSf1ffpep=wV=__J96Ju_nPkd96=c+ny4mC+SxrhRp0ofA@mail.gmail.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 23/01/31 08:35AM, Willem de Bruijn wrote:
> On Tue, Jan 31, 2023 at 8:08 AM Andrei Gherzan
> <andrei.gherzan@canonical.com> wrote:
> >
> > Leaving unrecognized arguments buried in the output, can easily hide a
> > CLI/script typo. Avoid this by exiting when wrong arguments are provided to
> > the udpgso_bench test programs.
> >
> > Signed-off-by: Andrei Gherzan <andrei.gherzan@canonical.com>
> 
> I'm on the fence on this. Test binaries are not necessarily robust
> against bad input. If you insist.

I'll keep it in the set (for next v), but I don't mind if it doesn't end
up applied. It was just something I stumbled into.

> When sending patches to net, please always add a Fixes tag.

I'll keep that in mind.

-- 
Andrei Gherzan
