Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8BA726F0F20
	for <lists+netdev@lfdr.de>; Fri, 28 Apr 2023 01:37:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344291AbjD0Xhw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Apr 2023 19:37:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44458 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344305AbjD0Xhs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Apr 2023 19:37:48 -0400
Received: from mail-pl1-x62d.google.com (mail-pl1-x62d.google.com [IPv6:2607:f8b0:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 90C843C32
        for <netdev@vger.kernel.org>; Thu, 27 Apr 2023 16:37:18 -0700 (PDT)
Received: by mail-pl1-x62d.google.com with SMTP id d9443c01a7336-1a814fe0ddeso94144185ad.2
        for <netdev@vger.kernel.org>; Thu, 27 Apr 2023 16:37:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20221208.gappssmtp.com; s=20221208; t=1682638636; x=1685230636;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=1hfm8h4c17GeAnPvR5OmHm69OuFNyK79R7Ez31pu/Hw=;
        b=IXVwZoAG7/m7Iq4/Kno2L9NG5HUfC79g1JXieefyseh9W1TCwelKNTTIJTLEegsQyY
         0wHBcpgICOkbDn2H2g33hUA22KF1Ph3oC1JtBxslGhfv8lkhkpLK99TmAyRiBv3311N3
         zpgORPM1fKERAgVg7nmN0HqobstBLvrJjAcsQasmAB0dhbdFHHh79NyLBARZG54/s/Z/
         oEq2X3LP0vTa775tdUzlWUsxnadWK0jFraSQFtf/8/P6wUbSQaYZpy92K52StBPi5x1J
         B0d8ljQrcrXOnRU/X/TyHdx+wsyFeGL0woIe7tHjEB3ud1vln08OwF0qdameVCryoVUo
         QYjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682638636; x=1685230636;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=1hfm8h4c17GeAnPvR5OmHm69OuFNyK79R7Ez31pu/Hw=;
        b=kM+mkX4UAvZSa//WHeCtRVmF2suLX9KYY4oXkGZ99h8QKNoBXlS4i28uKDi1cqC216
         9UMKQ8p00OV31RDwwekmmM1Svo4B/0rvYcxL6BOlNUKXWMV05BpAorrmf39n4/XqwQPl
         pCdkF3ceMYSGy8eLd+7SZAsujpEnTLmWm9Pxzf14em0v1cBCdf0n74LQ7DSeHK5UF/p9
         UwDmaihTkI5nuDNV2VzKiSg2xHNJpM5lXKwiEcQYxSm+pOlIm7Dq3FcROXMXbxvlTYGE
         t2xS3rIPro+RTNCDpje/SYg1zVw46SghSmp9fjUwBmqYelxansHGqEfhlWwXi40S7f9z
         p2kA==
X-Gm-Message-State: AC+VfDxbx0VSVmBq07GlOHUJhDgRURxFFAe4aeNeoIv1onLumzu2zwA2
        RTLuCuPwVxzzYff5dndPJbh7Hw==
X-Google-Smtp-Source: ACHHUZ7VpXV6ZROC9gCMqoZ4xaVeZT75QQp1J4t2VqEL6gfu8ZHBpaj4rT2TGJN+6X8Ipd1FBXtrDQ==
X-Received: by 2002:a17:902:7790:b0:19c:dbce:dce8 with SMTP id o16-20020a170902779000b0019cdbcedce8mr3312781pll.15.1682638636426;
        Thu, 27 Apr 2023 16:37:16 -0700 (PDT)
Received: from hermes.local (204-195-120-218.wavecable.com. [204.195.120.218])
        by smtp.gmail.com with ESMTPSA id u9-20020a17090341c900b001a9af8ddb64sm1915109ple.298.2023.04.27.16.37.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 27 Apr 2023 16:37:16 -0700 (PDT)
Date:   Thu, 27 Apr 2023 16:37:15 -0700
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Thorsten Glaser <t.glaser@tarent.de>, netdev@vger.kernel.org,
        Haye.Haehne@telekom.de,
        Toke =?UTF-8?B?SMO4aWxhbmQtSsO4cmdlbnNlbg==?= <toke@toke.dk>
Subject: Re: knob to disable locally-originating qdisc optimisation?
Message-ID: <20230427163715.285e709f@hermes.local>
In-Reply-To: <20230427132126.48b0ed6a@kernel.org>
References: <8a8c3e3b-b866-d723-552-c27bb33788f3@tarent.de>
        <20230427132126.48b0ed6a@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 27 Apr 2023 13:21:26 -0700
Jakub Kicinski <kuba@kernel.org> wrote:

> On Wed, 26 Apr 2023 14:54:30 +0200 (CEST) Thorsten Glaser wrote:
> > when traffic (e.g. iperf) is originating locally (as opposed to
> > forward traffic), the Linux kernel seems to apply some optimisations
> > probably to reduce overall bufferbloat: when the qdisc is =E2=80=9Cfull=
=E2=80=9D or
> > (and especially) when its dequeue often returns NULL (because packets
> > are delayed), the sender traffic rate is reduced by as much as =E2=85=
=93 with
> > 40=C2=A0ms extra latency (30 =E2=86=92 20 Mbit/s). =20
>=20
> Doesn't ring a bell, what's your setup?
>=20
> > This is probably good in general but not so good for L4S where we
> > actually want the packets to queue up in the qdisc so they get ECN
> > marking appropriately (I guess there probably are some socket ioctls
> > or something with which the sending application could detect this
> > state; if so, we=E2=80=99d be interested in knowing about them as well).
> >=20
> > This is especially bad in a testbed for writing L4S-aware applications,
> > so if there=E2=80=99s a knob (sysctl or something) to disable this opti=
misation
> > please do tell (I guess probably not, but asking doesn=E2=80=99t hurt).=
 =20

It might be BQL trying to limit outstanding packets locally.
