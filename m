Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D7F8A5139D7
	for <lists+netdev@lfdr.de>; Thu, 28 Apr 2022 18:29:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350047AbiD1Qc3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Apr 2022 12:32:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48366 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349411AbiD1Qc3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Apr 2022 12:32:29 -0400
Received: from mail-lf1-x12c.google.com (mail-lf1-x12c.google.com [IPv6:2a00:1450:4864:20::12c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 64243AC054
        for <netdev@vger.kernel.org>; Thu, 28 Apr 2022 09:29:14 -0700 (PDT)
Received: by mail-lf1-x12c.google.com with SMTP id n14so9544113lfu.13
        for <netdev@vger.kernel.org>; Thu, 28 Apr 2022 09:29:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=semihalf-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=fi5gI7ef4mwp91otHHkwHj5sdYmxVPM1pXL74ie6/D8=;
        b=MWuyvS3el5s/vzJHyrfxWWD7MmASld87qW+KvyZZbe2/UYg2qGR3/B7R90WtNpMOvi
         8V0dUXRMBLR90u5yNvdIb3WLYczPV60NBwRCuye53m2eNsZWP8SCogYbmTQvAm1QkT+u
         qt4JGEHhck6j6OzwGHtQC4Cgmuy4mvL2pfarTlrHRoNsFanfI0r2JX7Tl2+G2tBwbhBu
         0LJjA/1h7jRmryV8b6wf/OjjkZnNAYLKLsC1r9hpKXFZBuYm30IdKWuzhTe4obznIgIC
         7/yKkXUEMNbp2CZS4TD0jcfOOyjvq2bBLstFv2eooJPbE7t4HqH/CvaowmDx8qpNdDYc
         hsqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=fi5gI7ef4mwp91otHHkwHj5sdYmxVPM1pXL74ie6/D8=;
        b=eHB8xbHY1HOoRuNixX5i0st+rs8oQ9zRiy+Sg4oJhuBegcdfHN8lVz8ZpnNgQnf97T
         P4MuuMkXvZ0T35gpOx95Poo7e7+abuZtNv+W0tRM9A30Pe40VaIrrFNMNf0N6LdIcmCA
         9RjaXSKBeWBsfYL0UfVu67A/qYXn5y089Lxyw+o2fnp2EpXLVDt9XLeR4W6ZXbZUFfao
         FOTtqaXvZ/Fu0chfkZhJExU1fgiix+/EDt69e9zWKj9qfm//JUgZPS7Q4juEGqgQChxT
         VnszsAVZWazOIRhDJjZG2YI6A5642lZz0UzSEji8PVLffDIQEz4X9tEPt5KhyWkG3/x8
         adVQ==
X-Gm-Message-State: AOAM533CbQ9ddivYQF4f7jTl/EAUO+aRVCAGpbX2RxTzx9sZzndKvS47
        5hk6M/HAY/Ifk1hh/RSc4ZbM1NUS59YEIUXRVUXTYA==
X-Google-Smtp-Source: ABdhPJxwcJoAnZ9cHwLjWmiy+Gk6hzN8kcsRWnlFp7/qPAdD+Z5NuX1+YgoAehb3zMgUertegMQX+vacm3jA0umobs4=
X-Received: by 2002:a05:6512:3f89:b0:44a:f5bf:ec7e with SMTP id
 x9-20020a0565123f8900b0044af5bfec7emr24749845lfa.671.1651163352536; Thu, 28
 Apr 2022 09:29:12 -0700 (PDT)
MIME-Version: 1.0
References: <2460cc37a4138d3cfb598349e78f0c5f3cfa59c7.1651071936.git.baruch@tkos.co.il>
 <20220428072803.76490cbd@kernel.org>
In-Reply-To: <20220428072803.76490cbd@kernel.org>
From:   Marcin Wojtas <mw@semihalf.com>
Date:   Thu, 28 Apr 2022 18:29:02 +0200
Message-ID: <CAPv3WKfdJ5cM_-Mm7cHHXJJehQo9tTbJtGnU36D464Syu4zFkQ@mail.gmail.com>
Subject: Re: [PATCH] net: mvpp2: add delay at the end of .mac_prepare
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Baruch Siach <baruch@tkos.co.il>,
        Russell King <linux@armlinux.org.uk>,
        netdev <netdev@vger.kernel.org>,
        Baruch Siach <baruch.siach@siklu.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Jakub,

czw., 28 kwi 2022 o 16:28 Jakub Kicinski <kuba@kernel.org> napisa=C5=82(a):
>
> On Wed, 27 Apr 2022 18:05:36 +0300 Baruch Siach wrote:
> > From: Baruch Siach <baruch.siach@siklu.com>
> >
> > Without this delay PHY mode switch from XLG to SGMII fails in a weird
> > way. Rx side works. However, Tx appears to work as far as the MAC is
> > concerned, but packets don't show up on the wire.
> >
> > Tested with Marvell 10G 88X3310 PHY.
> >
> > Signed-off-by: Baruch Siach <baruch.siach@siklu.com>
> > ---
> >
> > Not sure this is the right fix. Let me know if you have any better
> > suggestion for me to test.
> >
> > The same issue and fix reproduce with both v5.18-rc4 and v5.10.110.
>
> Let me mark it as RFC in patchwork, then. If the discussion concludes
> with an approval please repost as [PATCH net] and preferably with a
> Fixes tag; failing that a stable tag, since you indicate 5.10 needs it.

Please do, that's a good idea.

Thanks,
Marcin
