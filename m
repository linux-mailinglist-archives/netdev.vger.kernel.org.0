Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0D944565DCE
	for <lists+netdev@lfdr.de>; Mon,  4 Jul 2022 21:08:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230340AbiGDTHm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Jul 2022 15:07:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57400 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234583AbiGDTHY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 Jul 2022 15:07:24 -0400
Received: from mail-pf1-x436.google.com (mail-pf1-x436.google.com [IPv6:2607:f8b0:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8634694
        for <netdev@vger.kernel.org>; Mon,  4 Jul 2022 12:07:22 -0700 (PDT)
Received: by mail-pf1-x436.google.com with SMTP id r6so5307488pfq.6
        for <netdev@vger.kernel.org>; Mon, 04 Jul 2022 12:07:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20210112.gappssmtp.com; s=20210112;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=DIxy3WLHCFOQeCKtTl4nvgdoTyWee/HyVk5VW37SzR0=;
        b=j0FedBz6BdXU5BJZ24M9a0JpUUZcfVHQU2xLBUXIw9MNQMFmmq1tiewzTzFWeQo9Cp
         CHRf9SKpvLnsatsN6AJMcHTOeiy5pXozFkZIxWR34QF8Pl2DaPVSnpZeOu+6KoQPM1hm
         ntkE0tTw3mUf10VTkFnefQrDgn70uxc9tu8m5MVC6O8Uo5AiRYh8Kpy7qkuCdiZpeoEf
         /jnjxUI17Y2Zdi8qvfuHovmf1DkgTR6wD5BPp2y3HjFJD1HLECdAmxYSgk1sseRlD3M0
         fuaolxGQVvsku8MhM9HifKk4aQyoB5reKSIrChdEq7NeszOs28Pc00VtTSNZS26JqWtK
         lDYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=DIxy3WLHCFOQeCKtTl4nvgdoTyWee/HyVk5VW37SzR0=;
        b=onMEAEd7JI/+Nmo/R0rbdVSk8kD6M6wQT2sUiJHxVlXs3KiIs8d6iNLv6+jauzEPnQ
         9ZVhqBAxp2YcGnf6xOJYSG8opoibcUF3u7MUrsFfplaxycy/6IfhMNuHTBQYZL77PQEE
         CBNj2/nYdz/aJYnh3xZGl78fq5Y/acTfq940aBqGDplHAbu0rkUdA4G2Z63oZujOGWAH
         KSw9y0z8sdxsvmi100NKx3NpyMIqZfL1UQzYHaH9d5rbuAWGl1k1UiL3pdExYxCqZbgx
         68OqyVbeiMPWIa/z1PYeS58saTmfffYvFtZE1CAvXgmtCwB7/sRjjGevRZlJY7b3yEC+
         1/qg==
X-Gm-Message-State: AJIora89hFZiSAhT1cMD4TcwrlJ0UevlzVePH26UjzzCkwparDxfZNUh
        xM5aY5Wj2Rcr9ZxOlkiw2Fel8M1mfgc/9IZO
X-Google-Smtp-Source: AGRyM1tY+m7sIIvsJ4/+bTgmSKX4oAiNYuH8tpV6fKeAwbTs6stJgxg79ond2JUqAggh7jlLT4EXzw==
X-Received: by 2002:a05:6a00:138b:b0:525:1f0b:3121 with SMTP id t11-20020a056a00138b00b005251f0b3121mr36976602pfg.8.1656961642045;
        Mon, 04 Jul 2022 12:07:22 -0700 (PDT)
Received: from hermes.local (204-195-112-199.wavecable.com. [204.195.112.199])
        by smtp.gmail.com with ESMTPSA id s14-20020a17090302ce00b001678a65d75bsm21597063plk.81.2022.07.04.12.07.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 Jul 2022 12:07:21 -0700 (PDT)
Date:   Mon, 4 Jul 2022 12:07:19 -0700
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Ido Schimmel <idosch@idosch.org>
Cc:     Jamal Hadi Salim <jhs@mojatatu.com>,
        Petr Machata <petrm@nvidia.com>,
        David Ahern <dsahern@gmail.com>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>
Subject: Re: Report: iproute2 build broken?
Message-ID: <20220704120719.505ed58e@hermes.local>
In-Reply-To: <YsMgv2plWTuWcd4X@shredder>
References: <CAM0EoMkWjOYRuJx3ebY-cQr5odJekwCtxeM5_Cmu1G4vxZ5dpw@mail.gmail.com>
        <YsMWpgwY/9GzcMC8@shredder>
        <CAM0EoM=Gycw88wC+tSOXFjEu3jKkqgLU8mNZfe48Zg0JXbtPiQ@mail.gmail.com>
        <YsMgv2plWTuWcd4X@shredder>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 4 Jul 2022 20:17:51 +0300
Ido Schimmel <idosch@idosch.org> wrote:

> On Mon, Jul 04, 2022 at 12:59:45PM -0400, Jamal Hadi Salim wrote:
> > Thanks Ido. That fixed it.
> > General question: do we need a "stable" iproute2?  
> 
> Maybe a new point release is enough (e.g., 5.18.1)?


I don't think this is urgent enough for another release.
