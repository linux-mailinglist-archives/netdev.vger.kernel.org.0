Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C60A9519DD9
	for <lists+netdev@lfdr.de>; Wed,  4 May 2022 13:20:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348718AbiEDLXc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 May 2022 07:23:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60918 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348689AbiEDLXb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 May 2022 07:23:31 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id CDC412A703
        for <netdev@vger.kernel.org>; Wed,  4 May 2022 04:19:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1651663195;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=lXMVJx+7jkqkO46ktvyPIT140OLmxQYNMIQN5pPJqZw=;
        b=c4+TVEBZqH1Yk14i2BivlN3Wf8GbYE8y3DLn9eQG7OURhDnQSUYPVYxiGn9N2cBF0pqQOZ
        i83ll15PgXFiIsTBv3A2ajNIjAFN/zlLlbBBjrqRp+4MGBjqbki0AcT022AjoGDdgDpvmn
        I/XT24ulVyZpusxnD1qkO7y97PJifB0=
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com
 [209.85.218.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-428-IM0u5tcuPFi9TX7N-AOv0w-1; Wed, 04 May 2022 07:19:53 -0400
X-MC-Unique: IM0u5tcuPFi9TX7N-AOv0w-1
Received: by mail-ej1-f70.google.com with SMTP id gn26-20020a1709070d1a00b006f453043956so653544ejc.15
        for <netdev@vger.kernel.org>; Wed, 04 May 2022 04:19:53 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=lXMVJx+7jkqkO46ktvyPIT140OLmxQYNMIQN5pPJqZw=;
        b=Teu/Sh16OPV+uYxOAucrgkGlawsTTKb6eSrKZkHRZR0Vy2ye5oQ0E+UupfFNK2kaqw
         CsYASmFSZa+zyTS/1umY1Y5XW/PuBRtRsW98+x76dk3lPkNoYwnw15siED5NdywkNh85
         BZhLKd0IeLCLRUEfgO/D4F86cpEpcGeZWF43NoL2N7t8ehTSDJ/CmAPeCo8nlP1hFCm8
         BfcrN6uaJF/JVP/moHfXE7LAQ4gljeydY+VDFTheYBCVBCBrIT2F1s5tLRkwlURYkC2K
         Kdoo4fV3JWXc7hnlmmfYkrzOovdp6H+d+mnQiIC+iG/mMUP7/uhIDP2ogcRiM0EZUyTY
         sfbA==
X-Gm-Message-State: AOAM531ZLRTgGYwf6zzJhAncv4B0h8JYT9Rk7RpIhSblb9xW5ni1M9pz
        Wr/6xJ5GRhyBV6IlqhniBD0/eb4U2L0HMnUM9SWZGmjjjZ/FUnvrbcFhDRMrQaHT91V2ZYyulzg
        JLmnlSZ7bAZKObnoO
X-Received: by 2002:a17:907:a41f:b0:6f3:e75c:5a77 with SMTP id sg31-20020a170907a41f00b006f3e75c5a77mr18660096ejc.70.1651663192512;
        Wed, 04 May 2022 04:19:52 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzceBB2USpyoo+pVY8+rlawNZ6Is0gHrKs+ouHJgFVE+uPIf9IviOi2f9nkD4t0M0FD3BfvVg==
X-Received: by 2002:a17:907:a41f:b0:6f3:e75c:5a77 with SMTP id sg31-20020a170907a41f00b006f3e75c5a77mr18660073ejc.70.1651663192175;
        Wed, 04 May 2022 04:19:52 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([45.145.92.2])
        by smtp.gmail.com with ESMTPSA id l24-20020a056402029800b0042617ba63a7sm9104938edv.49.2022.05.04.04.19.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 May 2022 04:19:50 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 08C323464C2; Wed,  4 May 2022 13:19:50 +0200 (CEST)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Zhengchao Shao <shaozhengchao@huawei.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, bpf@vger.kernel.org,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com
Cc:     ast@kernel.org, daniel@iogearbox.net, hawk@kernel.org,
        john.fastabend@gmail.com, andrii@kernel.org, kafai@fb.com,
        songliubraving@fb.com, yhs@fb.com, kpsingh@kernel.org,
        bigeasy@linutronix.de, imagedong@tencent.com, petrm@nvidia.com,
        memxor@gmail.com, arnd@arndb.de, weiyongjun1@huawei.com,
        shaozhengchao@huawei.com, yuehaibing@huawei.com
Subject: Re: [PATCH bpf-next] bpf/xdp: Can't detach BPF XDP prog if not exist
In-Reply-To: <20220504035207.98221-1-shaozhengchao@huawei.com>
References: <20220504035207.98221-1-shaozhengchao@huawei.com>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Wed, 04 May 2022 13:19:49 +0200
Message-ID: <875ymlwnmy.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Zhengchao Shao <shaozhengchao@huawei.com> writes:

> if user sets nonexistent xdp_flags to detach xdp prog, kernel should
> return err and tell user that detach failed with detail info.
>
> Signed-off-by: Zhengchao Shao <shaozhengchao@huawei.com>

I kinda see your point, but this will change user-visible behaviour that
applications might be relying on, so I don't think we can make this
change at this stage. Why can't your application just query the link for
whether a program is attached?

-Toke

