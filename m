Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2F5926EAE92
	for <lists+netdev@lfdr.de>; Fri, 21 Apr 2023 18:00:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233013AbjDUP7x (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Apr 2023 11:59:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49914 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233025AbjDUP7t (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Apr 2023 11:59:49 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EDBC9AD2D
        for <netdev@vger.kernel.org>; Fri, 21 Apr 2023 08:58:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1682092702;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=AZIvYSLh9Q4sp07dxk0J+SNkN9VKvd5ch6za5MQEoCY=;
        b=NWgzChOczSLFt9mbsNG8DSeRjitDiEN31lwlpCd3mYA4Cu55/+QF0ZCr7FAyh1IcgUtptQ
        Khwl4enhc5MHzy2HV+EC9N+BSvLF36ob2vY9omSFR9jByRTDf/gYzwiH7IteQOceWzkpi0
        Bu1CTyLFTrvSa+Uix/AecTbZ4WKTXlE=
Received: from mail-lf1-f70.google.com (mail-lf1-f70.google.com
 [209.85.167.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-479-FG_dUzn6MSe1NxE6l06nSQ-1; Fri, 21 Apr 2023 11:58:21 -0400
X-MC-Unique: FG_dUzn6MSe1NxE6l06nSQ-1
Received: by mail-lf1-f70.google.com with SMTP id 2adb3069b0e04-4ec81706fc9so847239e87.2
        for <netdev@vger.kernel.org>; Fri, 21 Apr 2023 08:58:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682092700; x=1684684700;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=AZIvYSLh9Q4sp07dxk0J+SNkN9VKvd5ch6za5MQEoCY=;
        b=MyD4Jauhl9De6fZ7WVMaWExb0/IpwacedfeuaV7IDASV73Q8cC9hej3tXamZOEl+VU
         63G/fIwHB6rsYqzNp33G2CUgTSyUTSRK1qxkxMLpNbk82TpfD25emyp/mHftIrAyBAFk
         t809uIRHTx9X3/fuDp5HK6+s+p5TZCyLESMF5Q9+VfUfcKXit2sFUEv+aFX8YS5J5T2I
         djtzBsabYLIne/TLOdiRXJz3yrF9hHwqKG2H8Yxe49fEvjaXC8BjS1IkZi7sCFAuYnna
         1dFUD62rP5aok3Q9FcRXxMQKs3Z/+Se/1diPssGCJ8+2Fk9tBydmYSg+ZCg71O/9N6rL
         SAYw==
X-Gm-Message-State: AAQBX9fzmDt+YD2rp3yontX9s7Heo8TtHSOX2jtTlojj25R25p2fTlG0
        lfWplpQE+iV3BoDsX9in4RSig/ZrjQy4KtmT5xclU/tZLqKV+xjDKU3axkYG/QOx5+KVBdAVPz7
        VL8GquoXERDOjPkaenGq1wI4Q1FmauJ9x
X-Received: by 2002:ac2:454c:0:b0:4de:e802:b7e3 with SMTP id j12-20020ac2454c000000b004dee802b7e3mr1600843lfm.19.1682092699985;
        Fri, 21 Apr 2023 08:58:19 -0700 (PDT)
X-Google-Smtp-Source: AKy350YG57Kg0OTP942MEAM8Z39S4TPlkqOeixCX6dcT66n0slq5pYHOij3IH7aiDDgE2zGJMvfbcXZCMfCPk6/0uG8=
X-Received: by 2002:ac2:454c:0:b0:4de:e802:b7e3 with SMTP id
 j12-20020ac2454c000000b004dee802b7e3mr1600836lfm.19.1682092699666; Fri, 21
 Apr 2023 08:58:19 -0700 (PDT)
MIME-Version: 1.0
References: <7b3a3c7e36d03068707a021760a194a8eb5ad41a.1682002300.git.dcaratti@redhat.com>
 <4e8324cf-e6de-acff-5e30-373d015a3cb4@mojatatu.com> <20230420162435.1d5a79df@kernel.org>
 <a0acecb6-6af7-9353-e3ed-cef69a88d4f2@mojatatu.com>
In-Reply-To: <a0acecb6-6af7-9353-e3ed-cef69a88d4f2@mojatatu.com>
From:   Davide Caratti <dcaratti@redhat.com>
Date:   Fri, 21 Apr 2023 17:58:07 +0200
Message-ID: <CAKa-r6t1vOjGXK0NiSNj1-NaA87STmXpkZGUCXYNOx5tGbEDRQ@mail.gmail.com>
Subject: Re: [PATCH net v2] net/sched: sch_fq: fix integer overflow of "credit"
To:     Pedro Tammela <pctammela@mojatatu.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>, netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

hi,

On Fri, Apr 21, 2023 at 4:24=E2=80=AFPM Pedro Tammela <pctammela@mojatatu.c=
om> wrote:
>
> On 20/04/2023 20:24, Jakub Kicinski wrote:

[...]

> > IIRC the preference of stable folks is to backport more not fewer
> > selftests. Practicality of that aside, I think the patch is good as is.
>
> My concern here was mostly due to conflicts with the tdc code base.
> Davide explained to me privately that he will take care of this so it's
> all good.

right, and I should color this reply-to-all button in a way that
catches better my attention :)

the tdc code will be a merge conflict on kernels that don't have [1]
(v6.0 and v5.x), so I will skip the tdc testcase for the stable
backport (unless somebody has objections).

thanks,
--=20
davide

[1] https://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git/commit/?=
id=3D9e274718cc050874761

