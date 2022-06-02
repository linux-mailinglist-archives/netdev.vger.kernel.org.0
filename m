Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6DB8B53B76A
	for <lists+netdev@lfdr.de>; Thu,  2 Jun 2022 12:38:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233955AbiFBKiX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Jun 2022 06:38:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42718 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233953AbiFBKiT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Jun 2022 06:38:19 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id A0D272B1948
        for <netdev@vger.kernel.org>; Thu,  2 Jun 2022 03:38:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1654166297;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=cEcO6QyHnPHYS4Vy+YLs+KWkeAz9zsW0LykwJtSxyKE=;
        b=F/8WLkUaKtHZPQjxMe8S5VsESWppVY2mIHN4OmfSOC5jqik+/IEhtOJWDysu8KtPuHqvq6
        yNnnRMvQcrZNsVMUaGfE6HyQ1/CrNQrByw992g0owU4W7umz3hRtMM7SmSQ5oKQKRkjUZE
        rzZiOTAgnuEQZeCAJjCdnwd/HCPDryI=
Received: from mail-qt1-f197.google.com (mail-qt1-f197.google.com
 [209.85.160.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-651-oS1JOS7LNSuXKN4ogKfmLA-1; Thu, 02 Jun 2022 06:38:17 -0400
X-MC-Unique: oS1JOS7LNSuXKN4ogKfmLA-1
Received: by mail-qt1-f197.google.com with SMTP id e13-20020a05622a110d00b00304b71fae86so3381327qty.5
        for <netdev@vger.kernel.org>; Thu, 02 Jun 2022 03:38:16 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=cEcO6QyHnPHYS4Vy+YLs+KWkeAz9zsW0LykwJtSxyKE=;
        b=l5l1dPR9/yHVAQiPYl3LhusCUy5sfknYrG2U1bePjhPW35i4vOIAy045swsQMz9Zk1
         q73NaM20va9YvwMQsU1J5TkpphGCidYyLPwg77z0S3kDyT/mkir+/hRU01qo+nD7bfyR
         vlClc8i/gHhFy5dnMRx2QWIAMmhe3W/RsfVTFfFBx3h9H6JaS4O7km+oi1MPm0KYtlQ9
         shiklVcSUlp8R1nq699SOVkLgLJbo6tiLVBfXeuGenQJOu2j0gbCSHBbbLUUvABrZr71
         1I5OmWl0YcUpMi5RbT7v9bg/bqzuyA/u6vvP8m8MbLe0t1khORXgBnhjbb8pdhlhpVp8
         JUbA==
X-Gm-Message-State: AOAM533dN8IcZNfUPgYanFWtKncujL5RBuzGUS5zoTFTmG8lAGVRiY9I
        XvRmcqBK1MeyrBpAFNCZSGVSMzPKTwKtBJeJnWnnE0Qq17UfPwH7hq5CFa8PbSWF1qQkUFkau2m
        +g6qNzH7+pdt4GM4W
X-Received: by 2002:a05:6214:4104:b0:42c:1db0:da28 with SMTP id kc4-20020a056214410400b0042c1db0da28mr58094685qvb.67.1654166295373;
        Thu, 02 Jun 2022 03:38:15 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyKaok4uC0gNMvnkmHdYFlz5ez7IZbeoh5p82LSlatVHUnTtlooLcZ5k/Za57l19xqbgWEIFg==
X-Received: by 2002:a05:6214:4104:b0:42c:1db0:da28 with SMTP id kc4-20020a056214410400b0042c1db0da28mr58094671qvb.67.1654166295138;
        Thu, 02 Jun 2022 03:38:15 -0700 (PDT)
Received: from gerbillo.redhat.com (146-241-112-184.dyn.eolo.it. [146.241.112.184])
        by smtp.gmail.com with ESMTPSA id p21-20020a05620a15f500b0069fc13ce23esm2747275qkm.111.2022.06.02.03.38.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Jun 2022 03:38:14 -0700 (PDT)
Message-ID: <4c9e3cf5122f4c2f8a2473c493891362e0a13b4a.camel@redhat.com>
Subject: Re: [PATCH net-next v4] ipv6: Fix signed integer overflow in
 __ip6_append_data
From:   Paolo Abeni <pabeni@redhat.com>
To:     Wang Yufen <wangyufen@huawei.com>, davem@davemloft.net,
        yoshfuji@linux-ipv6.org, dsahern@kernel.org, edumazet@google.com,
        kuba@kernel.org, ast@kernel.org, daniel@iogearbox.net,
        andrii@kernel.org, kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org
Date:   Thu, 02 Jun 2022 12:38:10 +0200
In-Reply-To: <20220601084803.1833344-1-wangyufen@huawei.com>
References: <20220601084803.1833344-1-wangyufen@huawei.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.4 (3.42.4-2.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 2022-06-01 at 16:48 +0800, Wang Yufen wrote:
> Resurrect ubsan overflow checks and ubsan report this warning,
> fix it by change the variable [length] type to size_t.
> 
> UBSAN: signed-integer-overflow in net/ipv6/ip6_output.c:1489:19
> 2147479552 + 8567 cannot be represented in type 'int'
> CPU: 0 PID: 253 Comm: err Not tainted 5.16.0+ #1
> Hardware name: linux,dummy-virt (DT)
> Call trace:
>   dump_backtrace+0x214/0x230
>   show_stack+0x30/0x78
>   dump_stack_lvl+0xf8/0x118
>   dump_stack+0x18/0x30
>   ubsan_epilogue+0x18/0x60
>   handle_overflow+0xd0/0xf0
>   __ubsan_handle_add_overflow+0x34/0x44
>   __ip6_append_data.isra.48+0x1598/0x1688
>   ip6_append_data+0x128/0x260
>   udpv6_sendmsg+0x680/0xdd0
>   inet6_sendmsg+0x54/0x90
>   sock_sendmsg+0x70/0x88
>   ____sys_sendmsg+0xe8/0x368
>   ___sys_sendmsg+0x98/0xe0
>   __sys_sendmmsg+0xf4/0x3b8
>   __arm64_sys_sendmmsg+0x34/0x48
>   invoke_syscall+0x64/0x160
>   el0_svc_common.constprop.4+0x124/0x300
>   do_el0_svc+0x44/0xc8
>   el0_svc+0x3c/0x1e8
>   el0t_64_sync_handler+0x88/0xb0
>   el0t_64_sync+0x16c/0x170
> 
> Changes since v1:
> -Change the variable [length] type to unsigned, as Eric Dumazet suggested.
> Changes since v2:
> -Don't change exthdrlen type in ip6_make_skb, as Paolo Abeni suggested.
> Changes since v3:
> -Don't change ulen type in udpv6_sendmsg and l2tp_ip6_sendmsg, as
> Jakub Kicinski suggested.

I'm sorry for the multiple incremental feedback on this patch. It's
somewhat tricky.

AFAICS Jakub mentioned only udpv6_sendmsg(). In l2tp_ip6_sendmsg() we
can have an overflow:

        int transhdrlen = 4; /* zero session-id */
        int ulen = len + transhdrlen;

when len >= INT_MAX - 4. That will be harmless, but I guess it could
still trigger a noisy UBSAN splat. 

Paolo

