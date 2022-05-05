Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 244C051C28F
	for <lists+netdev@lfdr.de>; Thu,  5 May 2022 16:28:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1380650AbiEEObU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 May 2022 10:31:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56122 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1380644AbiEEObT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 May 2022 10:31:19 -0400
Received: from us-smtp-delivery-74.mimecast.com (us-smtp-delivery-74.mimecast.com [170.10.133.74])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id B514EAE46
        for <netdev@vger.kernel.org>; Thu,  5 May 2022 07:27:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1651760858;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=hz8cN3gu7AH5J5jQIlr6+13kmwxut9ycO89aQGaXRjo=;
        b=AHQECLSTasaAvQLcJRF9k+vh4GDI+/CWHnyPDrmMtap9R6lesFOYvzQWmoIbcOGDk8nIf2
        Tr2zjsDR9DB3XEd8mzzO9+Bq3hs026L9dMHRuXwIeMAvzTgZ8N+RHqxrK5cAuyiKbVyhcN
        oALCqoPET3v7gCK8hIJY7xpEH750Y4w=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-94-NUScfxcpP_WipErkxC04Gw-1; Thu, 05 May 2022 10:27:37 -0400
X-MC-Unique: NUScfxcpP_WipErkxC04Gw-1
Received: by mail-ed1-f71.google.com with SMTP id cz24-20020a0564021cb800b00425dfdd7768so2436433edb.2
        for <netdev@vger.kernel.org>; Thu, 05 May 2022 07:27:37 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=hz8cN3gu7AH5J5jQIlr6+13kmwxut9ycO89aQGaXRjo=;
        b=MIGlGlN/BEicQWts946QvXV0diP60+aoB3zzw3coG5Vrc6JnDJVHlCQdnaDCKVU8pH
         uH53d8SQ8qi4dam6z4jUtNMYmdH2j9zGOgCTn6QURBHu8xD2nwyG7RkqZydLAaqQw3Bw
         ZOR3XRn8BXmHb26TS9RXvj82IbEVEJT6sCUjTQhxPAJipmthBjXMyErSdT1Jy2sNCeqC
         QVEvGYx2ut5thEbK2KKdQUb9yecXirCxLdQeKBPj1m8tnIP6KXZyvT1RQ6CwTkoE2n21
         vhj/55ISx5qvOvgOO3wLiP0bu3drclYrtMWm2ncyAZUAwbbE9j9xSilX2/fWxczBWIqv
         BXbQ==
X-Gm-Message-State: AOAM530WUoY5Rc3BtuTalWpgV38qTVI2wQD94rNQYnVlfF5rbTDzTVue
        uQETtdNbBcLvaS5wOlc0NRIA7ViaKX0/xU6f40Z/Q1wUTE8018WrDgcyk12iOfl4CYtNRbYIY6Z
        RAt8epCm9MGbBIScl
X-Received: by 2002:a17:907:6294:b0:6e1:ea4:74a3 with SMTP id nd20-20020a170907629400b006e10ea474a3mr26223919ejc.168.1651760854351;
        Thu, 05 May 2022 07:27:34 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwv7wnqPWL1ffvs/IM4PL/CBY4zMVBL4inCsI3m/n3fhEsCLH0JW5UDS797AgWj/J9aY6TrsQ==
X-Received: by 2002:a17:907:6294:b0:6e1:ea4:74a3 with SMTP id nd20-20020a170907629400b006e10ea474a3mr26223834ejc.168.1651760853491;
        Thu, 05 May 2022 07:27:33 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([2a0c:4d80:42:443::2])
        by smtp.gmail.com with ESMTPSA id k20-20020a170906971400b006f3ef214dc9sm805808ejx.47.2022.05.05.07.27.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 May 2022 07:27:32 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id B4CF734D4E7; Thu,  5 May 2022 16:27:31 +0200 (CEST)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     shaozhengchao <shaozhengchao@huawei.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>
Cc:     "ast@kernel.org" <ast@kernel.org>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        "hawk@kernel.org" <hawk@kernel.org>,
        "john.fastabend@gmail.com" <john.fastabend@gmail.com>,
        "andrii@kernel.org" <andrii@kernel.org>,
        "kafai@fb.com" <kafai@fb.com>,
        "songliubraving@fb.com" <songliubraving@fb.com>,
        "yhs@fb.com" <yhs@fb.com>,
        "kpsingh@kernel.org" <kpsingh@kernel.org>,
        "bigeasy@linutronix.de" <bigeasy@linutronix.de>,
        "imagedong@tencent.com" <imagedong@tencent.com>,
        "petrm@nvidia.com" <petrm@nvidia.com>,
        "memxor@gmail.com" <memxor@gmail.com>,
        "arnd@arndb.de" <arnd@arndb.de>,
        "weiyongjun (A)" <weiyongjun1@huawei.com>,
        yuehaibing <yuehaibing@huawei.com>
Subject: Re: =?utf-8?B?562U5aSNOg==?= [PATCH bpf-next] bpf/xdp: Can't detach
 BPF XDP prog if not
 exist
In-Reply-To: <594b5198d54c4c729728c20d167d9c2d@huawei.com>
References: <20220504035207.98221-1-shaozhengchao@huawei.com>
 <875ymlwnmy.fsf@toke.dk> <594b5198d54c4c729728c20d167d9c2d@huawei.com>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Thu, 05 May 2022 16:27:31 +0200
Message-ID: <87tua43vho.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

shaozhengchao <shaozhengchao@huawei.com> writes:

> Thank you for your reply. I wiil change sample application firstly.
> But if kernel does nothing and return 0, maybe user will think setup
> is OK, actually It failed. Is this acceptable?

Your patch was about detach; what has that got to do with "setup is OK"?

As for detaching, it's possible to write the application in a way that
it will always get a consistent result. There are basically two cases
when using netlink to detach an XDP program (bpf_link has its own
semantics, so setting that aside here):

1. The application just wants to turn off XDP entirely on the interface
   (e.g., 'ip link set dev XXX xdp off'). In this case you just send a
   RTM_SETLINK message with an IFLA_XDP_FD of -1, and if you don't get
   an error you can be sure that there is now no XDP program attached.
   Whether this was because there was already no program attached, or
   because you just detached it doesn't really matter in this case,
   since you're doing an unspecific detach anyway.

2. You attached a program earlier, and now you want to detach that (and
   only that) program. Or, equivalently, you queried the link and want
   to detach the program you know is attached there. In this case you
   send an RTM_SETLINK message with an IFLA_XDP_FD of -1 and an
   IFLA_XDP_EXPECTED_FD referring to the existing program. In this case
   you will get an error if that specific program is not in fact
   attached, whether because it was detached or swapped out in the
   meantime.

I don't see how case 1. is improved by returning ENOENT if there is no
program attached; if you care about detaching a specific program you'd
use case 2. anyway, and if you just want to check if a program is
attached, you'd do an RTM_GETLINK.

-Toke

