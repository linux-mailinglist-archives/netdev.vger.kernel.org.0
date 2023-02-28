Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BCF6B6A58CF
	for <lists+netdev@lfdr.de>; Tue, 28 Feb 2023 13:05:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231486AbjB1MFC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Feb 2023 07:05:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33126 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231539AbjB1ME6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Feb 2023 07:04:58 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B05352DE62
        for <netdev@vger.kernel.org>; Tue, 28 Feb 2023 04:04:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1677585854;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=KCJidl22u1cKfAyMeW4PYXi3JfewoKCLf6JCBtPv+4E=;
        b=imXD55bt2Gev2i/p6DR6bULaPt8kaQ8CGOQuC/kI2EHs5iMUnSiTVfE6pNlqy2BEE809QJ
        ibgVYLZFzbpbKWGNd4IT3xKS8Vr3YesTjE71JKzcMhpfSBjfLyDDrUA4HoFoud5863mGIZ
        dUkj7xJVEONxt6D2YpkNODvp1R6roU0=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-546-zMsShi3KMS-FbOogds8HIQ-1; Tue, 28 Feb 2023 07:04:13 -0500
X-MC-Unique: zMsShi3KMS-FbOogds8HIQ-1
Received: by mail-wm1-f72.google.com with SMTP id p22-20020a7bcc96000000b003e2036a1516so6804490wma.7
        for <netdev@vger.kernel.org>; Tue, 28 Feb 2023 04:04:13 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=KCJidl22u1cKfAyMeW4PYXi3JfewoKCLf6JCBtPv+4E=;
        b=jNc4n4Fl8wwvauBIHFzyfVALwSDDye2D8H/h6keRG5UgGtqAB0EPnn11mTtCrwlEGB
         FiojOLyVvyEpiMP32UN3vQDj38Y2RIONrbmZKjY4TH/IJFWpjRc2XZaykzQ2WN3h6myo
         pXdto16dd4icuMNtH82k1lDvLf/xgjtrr08LNZo+Mcsc92GuvNXFKpeHoF6M7qGp0UDz
         AC4j/KyhjIln67PsBPUJLfB5t/CUbRe2pNSkTszeILUDOnZVfOEuFgRQP9a7RSHQrtrN
         SW79mRxdXlY51NFvZu4Ryh4R9h6+FUU/6LOcKTaa+LnzfzG/K5fLrBt9i8teiX/5crOF
         QhSA==
X-Gm-Message-State: AO0yUKV3OSRO0MojDPXOCYXsVsrNhNu2l9vWLu+zudVugom1wAaAamP3
        /gyQuolJvoUwa+DukffCrPpn7PHPEjHqPdF2mcdQGQTFWVgtRyLgZ6ah35/kglksyYOxTW8d861
        rn79lsrBr+ltT/5pX
X-Received: by 2002:a05:600c:35cc:b0:3ea:840c:e8ff with SMTP id r12-20020a05600c35cc00b003ea840ce8ffmr2220087wmq.3.1677585852444;
        Tue, 28 Feb 2023 04:04:12 -0800 (PST)
X-Google-Smtp-Source: AK7set+i4oLcSfX/DPlO4reXLr5cplrlWIwAVs7488OSTZEYMFEEjdYGmSLF3oxgzaF/YTdKk1RNSg==
X-Received: by 2002:a05:600c:35cc:b0:3ea:840c:e8ff with SMTP id r12-20020a05600c35cc00b003ea840ce8ffmr2220063wmq.3.1677585852119;
        Tue, 28 Feb 2023 04:04:12 -0800 (PST)
Received: from gerbillo.redhat.com (146-241-121-8.dyn.eolo.it. [146.241.121.8])
        by smtp.gmail.com with ESMTPSA id l8-20020a05600c1d0800b003de2fc8214esm13242664wms.20.2023.02.28.04.04.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Feb 2023 04:04:11 -0800 (PST)
Message-ID: <85dae3d33c5b19b968313069c7c5342d688852b2.camel@redhat.com>
Subject: Re: [PATCH] sched: delete some api is not used
From:   Paolo Abeni <pabeni@redhat.com>
To:     lingfuyi <lingfuyi@126.com>, jhs@mojatatu.com, davem@davemloft.net
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        lingfuyi <lingfuyi@kylinos.cn>, k2ci <kernel-bot@kylinos.cn>
Date:   Tue, 28 Feb 2023 13:04:10 +0100
In-Reply-To: <20230228031241.1675263-1-lingfuyi@126.com>
References: <20230228031241.1675263-1-lingfuyi@126.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.46.4 (3.46.4-1.fc37) 
MIME-Version: 1.0
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 2023-02-28 at 11:12 +0800, lingfuyi wrote:
> From: lingfuyi <lingfuyi@kylinos.cn>
>=20
> fix compile errors like this:
> net/sched/cls_api.c:141:13: error: =E2=80=98tcf_exts_miss_cookie_base_des=
troy=E2=80=99
> defined but not used [-Werror=3Dunused-function]
>=20
> Reported-by: k2ci <kernel-bot@kylinos.cn>
> Signed-off-by: lingfuyi <lingfuyi@kylinos.cn>

This has been already addressed by:

commit 37e1f3acc339b28493eb3dad571c3f01b6af86f6
Author: Nathan Chancellor <nathan@kernel.org>
Date:   Fri Feb 24 11:18:49 2023 -0700

    net/sched: cls_api: Move call to tcf_exts_miss_cookie_base_destroy()

Thanks,

Paolo

