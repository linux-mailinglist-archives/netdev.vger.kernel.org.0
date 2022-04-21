Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CFDF1509443
	for <lists+netdev@lfdr.de>; Thu, 21 Apr 2022 02:57:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1383549AbiDUAni (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Apr 2022 20:43:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40982 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1380488AbiDUAnd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Apr 2022 20:43:33 -0400
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 08A4523140;
        Wed, 20 Apr 2022 17:40:45 -0700 (PDT)
Received: by mail-pj1-x1034.google.com with SMTP id mm4-20020a17090b358400b001cb93d8b137so6344205pjb.2;
        Wed, 20 Apr 2022 17:40:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=rfclIFAaCRj3lQhBUsZRIMVHC921jKyUGA7KZs0JIxQ=;
        b=ADc9TTJt+cbaLMa570d9rdQUxkG44C+hEEzdxM7Uxvay7RuSoiHTQsXoH8CEtBeb+j
         wPazNyCTBOQAshoOjkhPoZzLNmNAHbDFYYgt3Sj18Fmc+UOtx5I5v4MKSBktYd/LqFoK
         sCqNe//hf5TheNaZXXZ5QCflskmrl2XVTUlxt6qPAFc6V0MQr6iEd+hfTcxVZbU/rUha
         KpA1TR4ikK+hdikR0U5m/TYRQxWMZ4C0TRKE7vpSJMykg1wYgDgvron6BpJzSMngq11f
         Lxvms3zl3Jj3gBEmqhTkLfD2nrdpvA+B7sOd23EEwv0Td44GYP3aG71Yz3ZVQ4tvUWCR
         m1DQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=rfclIFAaCRj3lQhBUsZRIMVHC921jKyUGA7KZs0JIxQ=;
        b=bTNrfEf5kAGmZtimINNGjgDNgesFJhhPO/CbzFqehwlVVHONiPoat+/Ws1C/uAU+QH
         1AiHXkuCWsr+s/DN7NE3pTd65AeHXsuoxYAvjwKG4PKFbwp0xx1MmX4zOIFAQbGdspHi
         ZClrd9upYYQtmTUib5bnx9ghLrjG+N7NBw97+tbQ3zf+mRlcQKbFZq+x1smrAaHUuVoR
         /9njbP1KVW0jXs7BUlvpmEo/PNGdIwcI0XOnLnxPsbOtgF5ELASA7Du+2saGTM4/tnIK
         jQiDTFxRZLs8o/guM3gE4Q28zVbipu7rpcDbSqVJcgRZedia6hZqZ12PBlKzBeGfd47w
         28yw==
X-Gm-Message-State: AOAM531b2DHjRxCuIK8L3BGLVI/Q1E6qjHpbeie9pNZKs8WnIzq26IXl
        CAGmvDt7o+Rj4pJysm7L+V3K/xIUswT062x796M=
X-Google-Smtp-Source: ABdhPJzCd26tkkmotF+5V2NfYiZAWce3+X+m49nMnUeZeWHQtEwNy/n46ZWFZ999vH1JvS7D7LcrMva4bEJF8ckUHM4=
X-Received: by 2002:a17:90a:4f0e:b0:1d2:c449:8484 with SMTP id
 p14-20020a17090a4f0e00b001d2c4498484mr7353875pjh.26.1650501645416; Wed, 20
 Apr 2022 17:40:45 -0700 (PDT)
MIME-Version: 1.0
References: <20220421003152.339542-1-alobakin@pm.me>
In-Reply-To: <20220421003152.339542-1-alobakin@pm.me>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Wed, 20 Apr 2022 17:40:34 -0700
Message-ID: <CAADnVQJJiBO5T3dvYaifhu3crmce7CH9b5ioc1u4=Y25SUxVRA@mail.gmail.com>
Subject: Re: [PATCH v2 bpf 00/11] bpf: random unpopular userspace fixes (32
 bit et al)
To:     Alexander Lobakin <alobakin@pm.me>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        Song Liu <songliubraving@fb.com>,
        Kumar Kartikeya Dwivedi <memxor@gmail.com>,
        bpf <bpf@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 20, 2022 at 5:38 PM Alexander Lobakin <alobakin@pm.me> wrote:

Again?

-----BEGIN PGP MESSAGE-----
Version: ProtonMail

wcFMA165ASBBe6s8AQ/8C9y4TqXgASA5xBT7UIf2GyTQRjKWcy/6kT1dkjkF
FldAOhehhgLYjLJzNAIkecOQfz/XNapW3GdrQDq11pq9Bzs1SJJekGXlHVIW

Sorry I'm tossing the series out of patchwork.
