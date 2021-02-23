Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E25313230E0
	for <lists+netdev@lfdr.de>; Tue, 23 Feb 2021 19:38:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234002AbhBWShw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Feb 2021 13:37:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54296 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233952AbhBWShv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Feb 2021 13:37:51 -0500
Received: from mail-lj1-x22d.google.com (mail-lj1-x22d.google.com [IPv6:2a00:1450:4864:20::22d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 522A8C061574
        for <netdev@vger.kernel.org>; Tue, 23 Feb 2021 10:37:01 -0800 (PST)
Received: by mail-lj1-x22d.google.com with SMTP id u4so64296699ljh.6
        for <netdev@vger.kernel.org>; Tue, 23 Feb 2021 10:37:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=references:user-agent:from:to:cc:subject:in-reply-to:date
         :message-id:mime-version;
        bh=E50IIg6QS1J2ekVIp5/vZr8iPYB5YAAkcwkaRyVEjlw=;
        b=KNFRMmB/Z5Tju36hdgxttb+OUUJliAVQkukoSiGrQtYpt5B9CTSndjFWLGfsY7HgYK
         X4DmzoK8Gi52qtISLcaEHfGI2AIglNWaxxKMs79G86B/XbpWTscSx6WhPkjcLbAp9dL2
         CPbiW2HC4ULdpR2HIf8OSiF2taqPTIH2e3RzY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:references:user-agent:from:to:cc:subject
         :in-reply-to:date:message-id:mime-version;
        bh=E50IIg6QS1J2ekVIp5/vZr8iPYB5YAAkcwkaRyVEjlw=;
        b=WV5+0NOfqEvzldUVgK3uANxd4QVmwlpH+0A6OwDWhY+6G8rIUXByp7bULKbb8xZTQ3
         DdH06gpMPAE7ivXL00lurtO3e47s8dLjm4HeXzwoyIm96nLDK1X+nyHJnFWUEObZSiqj
         O3ubuo3XdsedqOxzM5Dsqy/zWKP+wpeHf1q+B7rhqF9Dj014OTErs894wvtz3tcaGk/v
         ln2BDfVtcoVJJ5HvOEA16MufFjzqPGotmXMIFuepxhfzgcUAWLyxrT99B+6vB2ml5DIZ
         qFn3H048f+6y8NUu4FnCWrHhELZjtbytmW7CW8PkVBAg1YpIOPHbmhmpqqkNNpCPgPOq
         ddpA==
X-Gm-Message-State: AOAM533Ho2xV5rudOYt2ZjBRaS5GP71dDf7YzDrgyoBvxbuoBSoVdLV3
        wz3a+IMlTVwqjKghzE06qGFa9A==
X-Google-Smtp-Source: ABdhPJzKXVfDVKLrrungZLuAcIvsB6BN1qWck9v7Qz+EHNz5OzMtGHlBXUh+hs8m8Ep1742DpF3qhQ==
X-Received: by 2002:a2e:8691:: with SMTP id l17mr5612536lji.297.1614105419695;
        Tue, 23 Feb 2021 10:36:59 -0800 (PST)
Received: from cloudflare.com (79.184.34.53.ipv4.supernova.orange.pl. [79.184.34.53])
        by smtp.gmail.com with ESMTPSA id g4sm2779368lfu.283.2021.02.23.10.36.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 23 Feb 2021 10:36:59 -0800 (PST)
References: <20210220052924.106599-1-xiyou.wangcong@gmail.com>
 <20210220052924.106599-5-xiyou.wangcong@gmail.com>
 <87eeh847ko.fsf@cloudflare.com>
 <CAM_iQpVS_sJy=sM31pHZVi6njZEAa7Hv_Bkt2sB7JcAjFw3guw@mail.gmail.com>
 <875z2i4qo5.fsf@cloudflare.com>
 <CAM_iQpWofNM=erfyP8b_qrezJN6d51UDW5bfgo2LHkPOTXqm8Q@mail.gmail.com>
User-agent: mu4e 1.1.0; emacs 27.1
From:   Jakub Sitnicki <jakub@cloudflare.com>
To:     Cong Wang <xiyou.wangcong@gmail.com>
Cc:     Linux Kernel Network Developers <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, duanxiongchun@bytedance.com,
        Dongdong Wang <wangdongdong.6@bytedance.com>,
        Jiang Wang <jiang.wang@bytedance.com>,
        Cong Wang <cong.wang@bytedance.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Lorenz Bauer <lmb@cloudflare.com>,
        John Fastabend <john.fastabend@gmail.com>
Subject: Re: [Patch bpf-next v6 4/8] skmsg: move sk_redir from TCP_SKB_CB to
 skb
In-reply-to: <CAM_iQpWofNM=erfyP8b_qrezJN6d51UDW5bfgo2LHkPOTXqm8Q@mail.gmail.com>
Date:   Tue, 23 Feb 2021 19:36:57 +0100
Message-ID: <874ki24omu.fsf@cloudflare.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Feb 23, 2021 at 07:04 PM CET, Cong Wang wrote:
> On Tue, Feb 23, 2021 at 9:53 AM Jakub Sitnicki <jakub@cloudflare.com> wrote:
>> Based on what I've seen around, mask for sanitizing tagged pointers is
>> usually derived from the flag(s). For instance:
>>
>> #define SKB_DST_NOREF   1UL
>> #define SKB_DST_PTRMASK ~(SKB_DST_NOREF)
>>
>> #define SK_USER_DATA_NOCOPY     1UL
>> #define SK_USER_DATA_BPF        2UL     /* Managed by BPF */
>> #define SK_USER_DATA_PTRMASK    ~(SK_USER_DATA_NOCOPY | SK_USER_DATA_BPF)
>>
>> Using ~(BPF_F_INGRESS) expression would be like substituting mask
>> definition.
>
> Yes, that is why I said we need a mask.

OK

>
>>
>> Alternatively we could clear _skb_refdest after clone, but before
>> enqueuing the skb in ingress_skb. And only for when we're redirecting.
>>
>> I believe that would be in sk_psock_skb_redirect, right before skb_queue_tail.
>
> Hmm? We definitely cannot clear skb->_sk_redir there, as it is used after
> enqueued in ingress_skb, that is in sk_psock_backlog().

You're right. I focused on the sk pointer and forgot it also carries the
ingress flag.
