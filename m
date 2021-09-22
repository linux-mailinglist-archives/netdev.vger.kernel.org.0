Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3693E4140D0
	for <lists+netdev@lfdr.de>; Wed, 22 Sep 2021 06:47:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232225AbhIVEsb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Sep 2021 00:48:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34270 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232530AbhIVErv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Sep 2021 00:47:51 -0400
Received: from mail-wr1-x42f.google.com (mail-wr1-x42f.google.com [IPv6:2a00:1450:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F39D9C0613E1
        for <netdev@vger.kernel.org>; Tue, 21 Sep 2021 21:46:13 -0700 (PDT)
Received: by mail-wr1-x42f.google.com with SMTP id q26so2888529wrc.7
        for <netdev@vger.kernel.org>; Tue, 21 Sep 2021 21:46:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Fj3GyCxCD5h7Hk/PvtkI5Z972KshE6Q+roVu92qjC4g=;
        b=DWokMomCe3pDVH1anRoX/8mIhL+TbAMBLGx9u8QR99xaqkrWrQvrschzw69VwGWp0B
         ZMc67wugf07ExkRR/qA91KbmF6RPlwYpFUIh2xTsWeFkV+saEVbeBAeJ1xrXugFKdDpA
         MBsvSRATrTbD8AfA6lY0Xurejg9piCvXAYr3y4SG0vcYQCd6KgmSYnBX5wc9+VgOi3S8
         P8gzFGLpfglxb9SsgpRNsqdTYF2iLeola2Hl+59PGbaG4C+/dTusxglxLil31ro53UbI
         E4rSr+GH4y9PCE4jduRmAHXJuvbqu0PrCRLxEOWiXoGHlbFV5woQtK5hE9XM4aupYkHu
         4cGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Fj3GyCxCD5h7Hk/PvtkI5Z972KshE6Q+roVu92qjC4g=;
        b=yjWSeNwua93uvyf6vD4pwsFYK2i/rHxEaYGMkHYPfDdd9UNBF1dN8ag8hNhg5kP0qv
         qnIvsZHXzPcjiqlRzmeyMtE4Serz5n8+unDNSrFZv7sdd7DV7u6xsrJ0KKqUQiakyZI3
         dOV0FZ/9JiIK9CQPa6PT/kf2S+BU8ATKa4tH8YASLA/P8C2vSIUVz8WOHqC7ONMlql3+
         mZ3xHbdtqFP4c+9HbFOskrF91AitNA6V+z+VAVQ+gu+2WtQ0ukhNbsj12sKr6h32XiPy
         vqiJyRlXb80q9m+O+n+4G4C4PsDBYQvVsSF0+KPeDOLMjPv73Madn1JceshfMbneMAu2
         y7jQ==
X-Gm-Message-State: AOAM532rVZhwNrijaBqGL9mWkLkKRpGc6bJc4+BajkJyNoH3iaZWc+Lw
        QjQrRwuYa/Bwfj6DnnK++CMUCg==
X-Google-Smtp-Source: ABdhPJwgjbPShDOA4ZNUvpK/RI8TCy0ML+6S0VCHYW1SSNCmg4ddHcwe9+bIci6JKimcDGvFTuGeXw==
X-Received: by 2002:adf:f2c4:: with SMTP id d4mr39817644wrp.434.1632285972578;
        Tue, 21 Sep 2021 21:46:12 -0700 (PDT)
Received: from localhost ([86.61.181.4])
        by smtp.gmail.com with ESMTPSA id o26sm4749872wmc.17.2021.09.21.21.46.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Sep 2021 21:46:12 -0700 (PDT)
Date:   Wed, 22 Sep 2021 06:46:11 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     Cong Wang <xiyou.wangcong@gmail.com>
Cc:     Felipe Magno de Almeida <felipe@sipanda.io>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        boris.sukholitko@broadcom.com, vadym.kochan@plvision.eu,
        ilya.lifshits@broadcom.com, Vlad Buslov <vladbu@nvidia.com>,
        Ido Schimmel <idosch@idosch.org>, paulb@nvidia.com,
        Davide Caratti <dcaratti@redhat.com>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Amritha Nambiar <amritha.nambiar@intel.com>,
        "Samudrala, Sridhar" <sridhar.samudrala@intel.com>,
        tom Herbert <tom@sipanda.io>,
        Pedro Tammela <pctammela@mojatatu.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: Re: [PATCH RFC net-next 0/2] net:sched: Introduce tc flower2
 classifier based on PANDA parser in kernel
Message-ID: <YUq1Ez1g8nBvA8Ad@nanopsycho>
References: <20210916200041.810-1-felipe@expertise.dev>
 <CAM_iQpUkdz_EjiuPRF_qKBp_ZHok_c8+pr4skCWGs_QTeLWpwA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAM_iQpUkdz_EjiuPRF_qKBp_ZHok_c8+pr4skCWGs_QTeLWpwA@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Wed, Sep 22, 2021 at 06:38:20AM CEST, xiyou.wangcong@gmail.com wrote:
>On Thu, Sep 16, 2021 at 1:02 PM Felipe Magno de Almeida
><felipe@sipanda.io> wrote:
>>
>> The PANDA parser, introduced in [1], addresses most of these problems
>> and introduces a developer friendly highly maintainable approach to
>> adding extensions to the parser. This RFC patch takes a known consumer
>> of flow dissector - tc flower - and  shows how it could make use of
>> the PANDA Parser by mostly cutnpaste of the flower code. The new
>> classifier is called "flower2". The control semantics of flower are
>> maintained but the flow dissector parser is replaced with a PANDA
>> Parser. The iproute2 patch is sent separately - but you'll notice
>> other than replacing the user space tc commands with "flower2"  the
>> syntax is exactly the same. To illustrate the flexibility of PANDA we
>> show a simple use case of the issues described in [2] when flower
>> consumes PANDA. The PANDA Parser is part of the PANDA programming
>> model for network datapaths, this is described in
>> https://github.com/panda-net/panda.
>
>My only concern is that is there any way to reuse flower code instead
>of duplicating most of them? Especially when you specifically mentioned
>flower2 has the same user-space syntax as flower, this makes code
>reusing more reasonable.

Exactly. I believe it is wrong to introduce new classifier which would
basically behave exacly the same as flower, only has different parser
implementation under the hood.

Could you please explore the possibility to replace flow_dissector by
your dissector optionally at first (kernel config for example)? And I'm
not talking only about flower, but about the rest of the flow_dissector
users too.

Thanks!
