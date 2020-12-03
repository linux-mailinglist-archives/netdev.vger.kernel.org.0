Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 025662CDF16
	for <lists+netdev@lfdr.de>; Thu,  3 Dec 2020 20:36:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729542AbgLCTf7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Dec 2020 14:35:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59544 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726885AbgLCTf7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Dec 2020 14:35:59 -0500
Received: from mail-wr1-x42a.google.com (mail-wr1-x42a.google.com [IPv6:2a00:1450:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D4507C061A4E
        for <netdev@vger.kernel.org>; Thu,  3 Dec 2020 11:35:18 -0800 (PST)
Received: by mail-wr1-x42a.google.com with SMTP id s8so3059314wrw.10
        for <netdev@vger.kernel.org>; Thu, 03 Dec 2020 11:35:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=364X1iRafzKSHYilhh8/unvIwWlspFKBQ97fdvZJXtM=;
        b=i06QRsrqhQ9s2/QtPwDwSa/irenZR5NAHqu+qe4EyePSLs56gEidWLwgQIDEtYMa7E
         1n5h7Ibf4aBEl8mscxL+muevsoWkLKCmVomPgf9hO77+Fw4DhCu4BVeNNDuNhmsr+vCQ
         hMTSUhp8mTcg5j9sa8XU+/lTcKOw3L4I2nLic1GyCt2tLVnsrMrzvMQ+YkiuaCy5mgR6
         HN6rvboCWPxkce/9bQCXbo/GNiVLNDgUsejbrwmdV68HN3Po3U10hqTRZhNO6Te7XSGF
         iSTUars+EKig6nDZKybiKjawbo/T7lrssFBsIWw9jRqTWf/NrXFz5Ls1IJc261U0Kwox
         a22w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=364X1iRafzKSHYilhh8/unvIwWlspFKBQ97fdvZJXtM=;
        b=HO4zaiCwWu7PH1u8I/c3h+X5RC6LXy9nJTBH1tATXc5tJiOfh1+Gj2FE4WIAilgEbh
         lPxAQaPt0Jsa6qw+1sB7erFeBycCjY49aP2Ti5oONyFotfQzvXGq3yEgEMgu3KGGlfZS
         EVTgtua377qnW4HO+2C3uOyyBzUS7YRoB85GhJssT5ESis+TFgZtECBvFm/AVdjiTp5z
         bDUdySSVApRGMlHAuYySH12Ol+xB8etvSr2pgNvrW+tbyAvFFnulsBucJ1h/++F9OCw6
         Rb248acb7RRnNKEHoJSjzkD0i1rc2i6HMl8LrtJmEGlSkbeydgPcqM7lT+4GANzlTfuO
         XQRQ==
X-Gm-Message-State: AOAM531PekAxTefrFpd+PLtfCEt+V4073y/iZYmN+zsY+K0gEcOW+Yki
        nTyEcBw9CjnskaAVeyGFuvHPYs77nK0=
X-Google-Smtp-Source: ABdhPJyT88bFZ8RHluTveMr/1fDQw/Ws7rMTFGMoX1rDiWSGLOfzVtAgjsP2sQF9AdUIItz4dnbV0w==
X-Received: by 2002:a5d:6886:: with SMTP id h6mr796542wru.173.1607024116122;
        Thu, 03 Dec 2020 11:35:16 -0800 (PST)
Received: from [192.168.8.116] ([37.165.75.126])
        by smtp.gmail.com with ESMTPSA id a144sm356157wmd.47.2020.12.03.11.35.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 03 Dec 2020 11:35:15 -0800 (PST)
Subject: Re: GRO: can't force packet up stack immediately?
To:     John Ousterhout <ouster@cs.stanford.edu>, netdev@vger.kernel.org
References: <CAGXJAmx_xQr56oiak8k8MC+JPBNi+tQBtTvBRqYVsimmKtW4MA@mail.gmail.com>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <72f3ea21-b4bd-b5bd-f72f-be415598591f@gmail.com>
Date:   Thu, 3 Dec 2020 20:35:14 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.0
MIME-Version: 1.0
In-Reply-To: <CAGXJAmx_xQr56oiak8k8MC+JPBNi+tQBtTvBRqYVsimmKtW4MA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 12/3/20 8:03 PM, John Ousterhout wrote:
> I recently upgraded my kernel module implementing the Homa transport
> protocol from 4.15.18 to 5.4.80, and a GRO feature available in the
> older version seems to have gone away in the newer version. In
> particular, it used to be possible for a protocol's xxx_gro_receive
> function to force a packet up the stack immediately by returning that
> skb as the result of xxx_gro_receive. However, in the newer kernel
> version, these packets simply get queued on napi->rx_list; the queue
> doesn't get flushed up-stack until napi_complete_done is called or
> gro_normal_batch packets accumulate. For Homa, this extra level of
> queuing gets in the way.


Could you describe what the issue is ?

> 
> Is there any way for a xxx_gro_receive function to force a packet (in
> particular, one of those in the list passed as first argument to
> xxx_gro_receive) up the protocol stack immediately? I suppose I could
> set gro_normal_batch to 1, but that might interfere with other
> protocols that really want the batching.
> 
> -John-
> 
