Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C789A4BF06E
	for <lists+netdev@lfdr.de>; Tue, 22 Feb 2022 05:10:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231932AbiBVDYj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Feb 2022 22:24:39 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:37218 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230154AbiBVDYi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Feb 2022 22:24:38 -0500
Received: from mail-io1-xd2a.google.com (mail-io1-xd2a.google.com [IPv6:2607:f8b0:4864:20::d2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9250D5F90;
        Mon, 21 Feb 2022 19:24:14 -0800 (PST)
Received: by mail-io1-xd2a.google.com with SMTP id m185so18440834iof.10;
        Mon, 21 Feb 2022 19:24:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=t9pbxXf5AxDJimERyAK/g611uy98VuNWmmEmuXc8qEw=;
        b=cQGwRIJzviZF9BcUrpncofuqGASKjdKjS1dBrbatBcOJd+O3l02b0Z301JZGkarEm+
         15zz8FOCluPEQI6cwB/sOGYFv1SC4APKpE2Pxv2zZDs5AztiNNp1dn4JjR2dkO91okTO
         1BrgUjfzkTXGjmTCqJNfOGFUfhx+Xeo3VaONlKhYpNh9px33vLRoDjfMXGZ1vJAA1hTN
         ANPJuFxm8lwLLQy3wJjFGpCwJaW6A62j3FZYxzw+/ukRJOex5tzy+gNmzqg3Dbqh+Pv1
         uY6i8C8Rm/RQg5VsDK0Yyw9CXylZB1J/xRPtP5KDQfIsTg6r2w4IF3N1SHOxojf+oyS7
         dUow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=t9pbxXf5AxDJimERyAK/g611uy98VuNWmmEmuXc8qEw=;
        b=lU4W98uiJ9x0Rb4Bcq1HevpmrG2nXeHKAffHIvJlnpZaRp0W/dudfCjlFnTCZMrAVR
         RvoO8J1MhdMiMINqU4LW6s6rfHzww9+Zrdx2h82DvGyH808mnRAV3gKLaJoxJ/EBhUgk
         2BwG6RP6jnfkxZM8eWVaLHWhX3c+/XXg4QmpgbNwqvjjaEIwPJEcC7hpuYqbAhWuxI6X
         Eb0zBaWVUVan89nCXeLFxK61MLQh/aXUNKT6DWmuHzHu/N6wmKj/iSzJ1namcxIREacF
         qr6qPNB15BNQ1OAn2H112wrUohmXRggz59eSsk6BRpPndiEzr9mZZgu4EN0KYPl8OyQa
         56qQ==
X-Gm-Message-State: AOAM530H/FrByKWo7h8RQJl7/rdUGdFjConMiIoh0ANNNXuT0fTmQmt2
        OqAadU6szeoFQ6ZEFeoq+4t77c/AeZGs5w==
X-Google-Smtp-Source: ABdhPJzZUKeg4Rm9p/szzjf9rOL8deIbDZKIYA1aPXEuZ8oBrxaWO0OEV4M3p3jSTHvvqVNFc0i4lw==
X-Received: by 2002:a02:6d04:0:b0:306:3f0c:6e2f with SMTP id m4-20020a026d04000000b003063f0c6e2fmr16890708jac.306.1645500254031;
        Mon, 21 Feb 2022 19:24:14 -0800 (PST)
Received: from ?IPV6:2601:284:8200:b700:fc7f:e53f:676e:280d? ([2601:284:8200:b700:fc7f:e53f:676e:280d])
        by smtp.googlemail.com with ESMTPSA id e14sm1973816ilu.13.2022.02.21.19.24.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 21 Feb 2022 19:24:13 -0800 (PST)
Message-ID: <cac945fa-ec67-4bbf-8893-323adf0836d8@gmail.com>
Date:   Mon, 21 Feb 2022 20:24:12 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.6.0
Subject: Re: [PATCH net-next v3 2/4] net: tap: track dropped skb via
 kfree_skb_reason()
Content-Language: en-US
To:     Dongli Zhang <dongli.zhang@oracle.com>, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        rostedt@goodmis.org, mingo@redhat.com, ast@kernel.org,
        daniel@iogearbox.net, andrii@kernel.org, imagedong@tencent.com,
        joao.m.martins@oracle.com, joe.jin@oracle.com, edumazet@google.com
References: <20220221053440.7320-1-dongli.zhang@oracle.com>
 <20220221053440.7320-3-dongli.zhang@oracle.com>
From:   David Ahern <dsahern@gmail.com>
In-Reply-To: <20220221053440.7320-3-dongli.zhang@oracle.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2/20/22 10:34 PM, Dongli Zhang wrote:
> The TAP can be used as vhost-net backend. E.g., the tap_handle_frame() is
> the interface to forward the skb from TAP to vhost-net/virtio-net.
> 
> However, there are many "goto drop" in the TAP driver. Therefore, the
> kfree_skb_reason() is involved at each "goto drop" to help userspace
> ftrace/ebpf to track the reason for the loss of packets.
> 
> The below reasons are introduced:
> 
> - SKB_DROP_REASON_SKB_CSUM
> - SKB_DROP_REASON_SKB_COPY_DATA
> - SKB_DROP_REASON_SKB_GSO_SEG
> - SKB_DROP_REASON_DEV_HDR
> - SKB_DROP_REASON_FULL_RING
> 
> Cc: Joao Martins <joao.m.martins@oracle.com>
> Cc: Joe Jin <joe.jin@oracle.com>
> Signed-off-by: Dongli Zhang <dongli.zhang@oracle.com>
> ---
> Changed since v1:
>   - revise the reason name
> Changed since v2:
>   - declare drop_reason as type "enum skb_drop_reason"
>   - handle the drop in skb_list_walk_safe() case
> 
>  drivers/net/tap.c          | 35 +++++++++++++++++++++++++----------
>  include/linux/skbuff.h     |  9 +++++++++
>  include/trace/events/skb.h |  5 +++++
>  3 files changed, 39 insertions(+), 10 deletions(-)
> 

couple of places where the new reason should be in reverse xmas order;
logic wise:

Reviewed-by: David Ahern <dsahern@kernel.org>
