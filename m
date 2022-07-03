Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E34515644D5
	for <lists+netdev@lfdr.de>; Sun,  3 Jul 2022 06:43:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229994AbiGCEne (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 3 Jul 2022 00:43:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60906 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229902AbiGCEnd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 3 Jul 2022 00:43:33 -0400
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D00863C5
        for <netdev@vger.kernel.org>; Sat,  2 Jul 2022 21:43:32 -0700 (PDT)
Received: by mail-pj1-x1031.google.com with SMTP id x1-20020a17090abc8100b001ec7f8a51f5so10371892pjr.0
        for <netdev@vger.kernel.org>; Sat, 02 Jul 2022 21:43:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Qs7BMNe2vh/Hl5mZuFlxI1rw3KRPw+Sod4ZQ4Os/vNs=;
        b=nSKFvMh54BIiiNfujs3O6HHzF5iyTRi/CldkBAu7egV6HARrHaNEObF9WO/oP5vo6h
         lozITYHmglXlIr4Alyd9mJYvLSDTaZzkXJ3NWg/c8lf+lDl4wTyH9NJRXYaXEUIJNgKj
         5zxLqn2rCWegXSCf7XTQ9jB+uMWcYw9L2Ee1yPBzoOPgPIpS4zgMGF703USIwQCjVO5f
         RIsihpPNJ82byiK7mwLb8ZcTkEhgMkeOCvFXrlVpIg++akDvPMirAlJ9jQy2sg4Lj965
         f9jbrTSqc53S0pgXU7zCCjy932uTJbL1ndsaFukmHQ5V1qkJalWDiPygPBk4MDRqdFX0
         kvsA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Qs7BMNe2vh/Hl5mZuFlxI1rw3KRPw+Sod4ZQ4Os/vNs=;
        b=qpvrg3I+CYG3m+hZDDEZukUblILQV7OADuEGn5VeMsYZb8O+S07okbZ+4oYj6JtE+t
         i7xIVCuHPBDlMzuUuJYMAhMR152hN+xWNOQkuEKi/35VuBN5YMtbKeuPqcAx726COil7
         FFG61gHaKxwn8aVh3vNWmuVxvc2+nZ/a9ROcr3eor1y2M8WhTq+9Cd9i0C8y1ixh43v2
         CmpYEeOWqzWLlHkiCQv/RX6aPkfO7ylnmpUKS4o529EIbguGbU7GwMtAPCC12CHK3Wm0
         Wm7RzsYxnLwDhRMYd38EbtLfDtLtTWDvSpJCkpfjCvMvFI9Zdk1I1xBCELSEubUwlLtH
         NijQ==
X-Gm-Message-State: AJIora8dUxBbHzXQxdi/6AAc30VopEAggf0lCEVJmC9EI/732nrFhoKV
        s2jdY712HbWVIVqRyShWb9C5W+qSf4H12SKidC0=
X-Google-Smtp-Source: AGRyM1uZ283eESVhTocAl5yi65kS5NEny6noCbmhXGkQ5IZunIQB+rP+/S0Bnj2n8j8iwCC5yTDTlCQotV3+uBsGPeQ=
X-Received: by 2002:a17:902:d50c:b0:16b:a1fb:c71e with SMTP id
 b12-20020a170902d50c00b0016ba1fbc71emr21149229plg.140.1656823411887; Sat, 02
 Jul 2022 21:43:31 -0700 (PDT)
MIME-Version: 1.0
References: <1656050956-9762-1-git-send-email-quic_subashab@quicinc.com>
 <CANn89iJ_HBEkiU3ToAjcv_KHz3f77DJpycKcU=74X3rNst-V6g@mail.gmail.com>
 <YroEC3NV3d1yTnqi@pop-os.localdomain> <CANn89i+X4+w91MwZNW7qsb9dK3W0s72iehh5Kkb077ApTis_Vg@mail.gmail.com>
 <CAM_iQpXF4cvuMe3yM_G2Xzab_3Q_D1oUcfchaAZE6cYNcMoe9Q@mail.gmail.com> <CANn89iKRU6QDfmRa=YikyGHjC=v-8RepTWHtHPMQivAqP=gt2Q@mail.gmail.com>
In-Reply-To: <CANn89iKRU6QDfmRa=YikyGHjC=v-8RepTWHtHPMQivAqP=gt2Q@mail.gmail.com>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Sat, 2 Jul 2022 21:43:20 -0700
Message-ID: <CAM_iQpU9f4XmvPve5ex_ya6Xqugxo3RTm1f08uquBmJz+qbKBQ@mail.gmail.com>
Subject: Re: [PATCH net-next] net: Print real skb addresses for all net events
To:     Eric Dumazet <edumazet@google.com>
Cc:     Subash Abhinov Kasiviswanathan <quic_subashab@quicinc.com>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        netdev <netdev@vger.kernel.org>, quic_jzenner@quicinc.com,
        Cong Wang <cong.wang@bytedance.com>,
        Qitao Xu <qitao.xu@bytedance.com>,
        Sean Tranchetti <quic_stranche@quicinc.com>
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

On Mon, Jun 27, 2022 at 12:46 PM Eric Dumazet <edumazet@google.com> wrote:
>
> We have ways for developers : no_hash_pointers

I have no idea why you keep generalizing this topic to all pointers.

You have to realize no one even argues about any other pointers
than just skb's. You must be kidding when you suggest to disable
all hash pointers when people only want skb.
