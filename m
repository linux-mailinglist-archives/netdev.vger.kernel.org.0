Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 248F8533DFC
	for <lists+netdev@lfdr.de>; Wed, 25 May 2022 15:37:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237625AbiEYNhm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 May 2022 09:37:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59064 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229569AbiEYNhl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 May 2022 09:37:41 -0400
Received: from mail-ej1-x632.google.com (mail-ej1-x632.google.com [IPv6:2a00:1450:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59C2CDFC4;
        Wed, 25 May 2022 06:37:40 -0700 (PDT)
Received: by mail-ej1-x632.google.com with SMTP id gh17so28713512ejc.6;
        Wed, 25 May 2022 06:37:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=32xzrDUStBHgmCZ60mJZDqe8jlYunkyDsm5fnUw7zgg=;
        b=BuagVDvD15lp98anttQopHV7UY6gNGq3AJOBHPXvpaRfIryMWcHppsruIJncReQT4z
         /s199964wNU8pJ/rhs8M+LtAER9hLfWHCM1VzI+oPrG9nWxyxqYyIcbss/TsLgOKOwHS
         fx0DnHhHaZeUJcQn3JEvN+iD8nxpdpEaH1LsE0BoPXFl56RRJk++r9LEIR+zMWPhiUVc
         AF67NC08fM7fgadRzfMFtbegY2KtvJ+/qn55pLMupynup93qgiCx7tWZ7RkVJyGYWZZc
         J/krDvJ8HaIRaCHc28sMCpORMNrGVHMXBbrMMTY4jQe1Y/RS0gNIth5lcJEzJpqYVnoK
         Y58g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=32xzrDUStBHgmCZ60mJZDqe8jlYunkyDsm5fnUw7zgg=;
        b=a5mRRcxHnv1rbOMCrHUYzLQ8PWZsxm9Mcr3C4v4qDWDJb850cUZjsBK2QVvMLv780f
         oXPoXK6PFFfbgld+2cPe+MogsrFFBDSyTgbl6DqYjBWPRLpZdGuzSTs2HWZt90NqGyu1
         SXmbibq/22PyjWXK0nrBQGs+dFTwLRuNKg7RHwnPTkojNP5bcMLgHtTJWX1USa1mqrex
         dfRoLa+QsDz0yp7NC2a88xwgR+FWL4aWks6RGVZDTZ97vG5K+Y0STmPVg5kh+fhsY+jK
         5jH8R3Uganh7mqm3j6+UV0Db1P1rVH6jM09Vupd6576UPjgcHJabAJlwMb8EDTKeKhHW
         HUGQ==
X-Gm-Message-State: AOAM531JGcKV8KzWQEsBX1L55YtrxTdiJOBSmXrVNwWDxaz/27NMLeLN
        rFZAGafAZX9Ocjk5bCypyBjxv4ZEgdzEyCYrFmE=
X-Google-Smtp-Source: ABdhPJxhc82v+selJT7Vf3mDNUrgEjGyupGkiG5hSSkVwovF4jBRDnfmuauz9V/o0YfIbpvTOnrK2TwL85qTwoa5CVw=
X-Received: by 2002:a17:907:3f0f:b0:6ff:11b7:f037 with SMTP id
 hq15-20020a1709073f0f00b006ff11b7f037mr2832343ejc.253.1653485858807; Wed, 25
 May 2022 06:37:38 -0700 (PDT)
MIME-Version: 1.0
References: <20220525103512.3666956-1-gasmibal@gmail.com> <87r14hoox8.fsf@toke.dk>
 <CALxDnQa8d8CGXz2Mxvsz5csLj3KuTDW=z65DSzHk5x1Vg+y-rw@mail.gmail.com> <92ca6224-9232-2648-0123-7096aafa17fb@nbd.name>
In-Reply-To: <92ca6224-9232-2648-0123-7096aafa17fb@nbd.name>
From:   Baligh GASMI <gasmibal@gmail.com>
Date:   Wed, 25 May 2022 15:37:28 +0200
Message-ID: <CALxDnQYHoZuv7hxLfagJRGRxw=UOFNmuBVHS8YghDwtfkLPAvg@mail.gmail.com>
Subject: Re: [RFC PATCH 1/1] mac80211: use AQL airtime for expected throughput.
To:     Felix Fietkau <nbd@nbd.name>
Cc:     =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>,
        Johannes Berg <johannes@sipsolutions.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "open list:MAC80211" <linux-wireless@vger.kernel.org>,
        "open list:NETWORKING [GENERAL]" <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Indeed it's less expensive.

I'll try to make something in this direction to see what it looks like.

- Baligh
