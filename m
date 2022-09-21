Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ABF4A5BFB2D
	for <lists+netdev@lfdr.de>; Wed, 21 Sep 2022 11:40:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231398AbiIUJkv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Sep 2022 05:40:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41750 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230166AbiIUJku (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Sep 2022 05:40:50 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 43B368275E
        for <netdev@vger.kernel.org>; Wed, 21 Sep 2022 02:40:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1663753249;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=vfl/st5m8Se6ltL60JY32xTNgdDLAMTh+1ursFMAnnc=;
        b=YWt3eM0woOQOdt6OfPJDgSvs+0dcEp6Sy9Xctak38BDL4pycpmN32Yc1h8ZV7PSg0qeWO6
        AtUo++zzORAVZAXcL393gsGlqgHJETaZ2MIdrbAtHd7X/OZweNiQ1+PerH43iSgkomjLT+
        BTzGxwnI0pXWfIh1l7dHvcgvvjK/ETo=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-449-hhpQk35-M_iAQ3wZLeJuUg-1; Wed, 21 Sep 2022 05:40:48 -0400
X-MC-Unique: hhpQk35-M_iAQ3wZLeJuUg-1
Received: by mail-ed1-f72.google.com with SMTP id b16-20020a056402279000b0044f1102e6e2so4031705ede.20
        for <netdev@vger.kernel.org>; Wed, 21 Sep 2022 02:40:48 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:references
         :in-reply-to:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date;
        bh=vfl/st5m8Se6ltL60JY32xTNgdDLAMTh+1ursFMAnnc=;
        b=2OLwoi95Jk51L8GRKGlgj1W7QsQKxDuQdSNzH4pf+raBrynufYpGsG1GYpWEDoscWB
         qXqKT4xsbLME/teKpG1nFVSmE1g7UARupHzMscB2b2Ghy4BxnoVQ6UwkD4VECRjyR2U1
         CgmuVb5P3jns9OgwScDDypirHuoBuBtOBVQ4QiKBsmZej9aq5yEtc9wOZyGeuvsLtima
         xFwTiKleSdRZzy07rK1OwL3zPLpAheJJHIOqkBGdqCB2CTW4UgvRKVjiluBksNWB/imZ
         q7sUiHTsio6FURtX7ZgMPavFK4yvFp6Mwu7+eN+rYUVFSJibqb2a96Lr88YgKf0IPsnU
         0geg==
X-Gm-Message-State: ACrzQf2jWd0wvt88gZdTpSxVhhnEQ3Bfp6OLcaXI5NvfKfdUW7OQG93Y
        BylaBOPMytDXK65T03zL/DQg48Q88cm9YzBfQp1Eaw850Qhf91NU6uDaz18xl3/fZBgqa7K9LBa
        Kcu/ubxyuvFDvlYg1
X-Received: by 2002:a17:907:94ca:b0:77b:542a:4cc4 with SMTP id dn10-20020a17090794ca00b0077b542a4cc4mr19302849ejc.257.1663753247293;
        Wed, 21 Sep 2022 02:40:47 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM4hDKaFsXcDpGvBW7qsS7g0afcmMVDNPrIWCK+FY0bzS4JRPiUwSLUK8z2QrUwdSGY7qf4/BA==
X-Received: by 2002:a17:907:94ca:b0:77b:542a:4cc4 with SMTP id dn10-20020a17090794ca00b0077b542a4cc4mr19302826ejc.257.1663753247016;
        Wed, 21 Sep 2022 02:40:47 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([45.145.92.2])
        by smtp.gmail.com with ESMTPSA id gj22-20020a170906e11600b0073dd1ac2fc8sm1016556ejb.195.2022.09.21.02.40.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Sep 2022 02:40:46 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id D17D861C4E3; Wed, 21 Sep 2022 11:40:45 +0200 (CEST)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Zhengchao Shao <shaozhengchao@huawei.com>, netdev@vger.kernel.org,
        cake@lists.bufferbloat.net, linux-kselftest@vger.kernel.org,
        jhs@mojatatu.com, xiyou.wangcong@gmail.com, jiri@resnulli.us,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, vinicius.gomes@intel.com,
        stephen@networkplumber.org, shuah@kernel.org, victor@mojatatu.com
Cc:     zhijianx.li@intel.com, weiyongjun1@huawei.com,
        yuehaibing@huawei.com, shaozhengchao@huawei.com
Subject: Re: [PATCH net-next,v3 01/18] net/sched: sch_api: add helper for tc
 qdisc walker stats dump
In-Reply-To: <20220921024104.386242-1-shaozhengchao@huawei.com>
References: <20220921024104.386242-1-shaozhengchao@huawei.com>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Wed, 21 Sep 2022 11:40:45 +0200
Message-ID: <87illhvzdu.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Zhengchao Shao <shaozhengchao@huawei.com> writes:

> The walk implementation of most qdisc class modules is basically the
> same. That is, the values of count and skip are checked first. If
> count is greater than or equal to skip, the registered fn function is
> executed. Otherwise, increase the value of count. So we can reconstruct
> them.
>
> Signed-off-by: Zhengchao Shao <shaozhengchao@huawei.com>

Acked-by: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>

