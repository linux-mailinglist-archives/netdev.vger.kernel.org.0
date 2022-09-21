Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 156FA5BFB2A
	for <lists+netdev@lfdr.de>; Wed, 21 Sep 2022 11:40:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231287AbiIUJkp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Sep 2022 05:40:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41470 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230415AbiIUJkn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Sep 2022 05:40:43 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 24B077D1CB
        for <netdev@vger.kernel.org>; Wed, 21 Sep 2022 02:40:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1663753242;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=LhUuJRx2gpuIfpjZ2+oW6pFTAAKEReUIPyoUMqiGOJU=;
        b=FrI646wZn/tnHe6LICa/BEiVUn/wVkRkNLgrtcAWAPTy+PlK8+u90bVTxBxwQNT1Z1SshH
        xZH2ErZ3U1olYvoiUvSdwjZplkg07ahxO8FcV05w7s3b1qkIVLUF+jdL4dRApHgreT+cdn
        VKy/AGMuVTu3nOSWsdCs+jXRZBMFKdc=
Received: from mail-ej1-f72.google.com (mail-ej1-f72.google.com
 [209.85.218.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-248-O1DVYWsBPn-8Jrq-2QdqqA-1; Wed, 21 Sep 2022 05:40:41 -0400
X-MC-Unique: O1DVYWsBPn-8Jrq-2QdqqA-1
Received: by mail-ej1-f72.google.com with SMTP id gv43-20020a1709072beb00b0077c3f58a03eso2808530ejc.4
        for <netdev@vger.kernel.org>; Wed, 21 Sep 2022 02:40:40 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:references
         :in-reply-to:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date;
        bh=LhUuJRx2gpuIfpjZ2+oW6pFTAAKEReUIPyoUMqiGOJU=;
        b=hL+PWjD03TymXZNioHOjBSAw8YdO8LNnHraxAcLH5efWmB8vsSRij/OH+C+RVaqTNv
         ka8kIU5JD9XbRyeOLa2sHalvcL/WRA3J8AG1QmXa1AlN5tnH7NxLhCNsuhM/wB89Rm3B
         O0TOo3miLdGdUzuEEZj19bA3PHpb1OwvG8Wjzq7oeF0wBSwi0MSP/CLv/vNoFgZl35vn
         XkYMpL9UxXjcr67UmoP2uSfISZxfpvEgAW++FD9wPHI/NSrM71lOr83dczdRGv0ToM3V
         nUQyKE6sSO4UlAOSk0ZfKC97wd5XKLineMGzZ7xOBuS6lAkp4YRNKnUUBlid7DFYHgrZ
         W64g==
X-Gm-Message-State: ACrzQf2R5duYwZY7wy54CVJPq0M1DzrKsRpRg7D3gh+km/t7fzsm00Sr
        KLDw28nXBWCDNQFbijemxtkIuY6mCLoqKgn4vE75lTKrm44knIuCcgXwh5yusZVk7Ghz+vJOUDv
        xQ5+4Mrnq18CLALST
X-Received: by 2002:a17:906:328c:b0:780:7574:ced2 with SMTP id 12-20020a170906328c00b007807574ced2mr1001468ejw.634.1663753238398;
        Wed, 21 Sep 2022 02:40:38 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM7iNkNZ8NEmA5Eef9rWoDRK8RoLdOhrzxoLCprjnhClTrEJcAvc5D5cN9ZzokYS37vb9rCXsg==
X-Received: by 2002:a17:906:328c:b0:780:7574:ced2 with SMTP id 12-20020a170906328c00b007807574ced2mr1001327ejw.634.1663753236035;
        Wed, 21 Sep 2022 02:40:36 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([2a0c:4d80:42:443::2])
        by smtp.gmail.com with ESMTPSA id g6-20020a170906538600b0077f324979absm1069305ejo.67.2022.09.21.02.40.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Sep 2022 02:40:34 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 574AD61C4E1; Wed, 21 Sep 2022 11:40:34 +0200 (CEST)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Zhengchao Shao <shaozhengchao@huawei.com>, netdev@vger.kernel.org,
        cake@lists.bufferbloat.net, linux-kselftest@vger.kernel.org,
        jhs@mojatatu.com, xiyou.wangcong@gmail.com, jiri@resnulli.us,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, vinicius.gomes@intel.com,
        stephen@networkplumber.org, shuah@kernel.org, victor@mojatatu.com
Cc:     zhijianx.li@intel.com, weiyongjun1@huawei.com,
        yuehaibing@huawei.com, shaozhengchao@huawei.com
Subject: Re: [PATCH net-next,v3 02/18] net/sched: use tc_qdisc_stats_dump()
 in qdisc
In-Reply-To: <20220921024118.386700-1-shaozhengchao@huawei.com>
References: <20220921024118.386700-1-shaozhengchao@huawei.com>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Wed, 21 Sep 2022 11:40:34 +0200
Message-ID: <87leqdvze5.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Zhengchao Shao <shaozhengchao@huawei.com> writes:

> use tc_qdisc_stats_dump() in qdisc.
>
> Signed-off-by: Zhengchao Shao <shaozhengchao@huawei.com>
> Reviewed-by: Victor Nogueira <victor@mojatatu.com>
> Tested-by: Victor Nogueira <victor@mojatatu.com>

For sch_cake:

Acked-by: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>

