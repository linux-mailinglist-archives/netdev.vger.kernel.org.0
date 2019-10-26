Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E5647E5F91
	for <lists+netdev@lfdr.de>; Sat, 26 Oct 2019 22:44:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726524AbfJZUmW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 26 Oct 2019 16:42:22 -0400
Received: from mail-pg1-f175.google.com ([209.85.215.175]:44343 "EHLO
        mail-pg1-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726443AbfJZUmW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 26 Oct 2019 16:42:22 -0400
Received: by mail-pg1-f175.google.com with SMTP id e10so3889989pgd.11
        for <netdev@vger.kernel.org>; Sat, 26 Oct 2019 13:42:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=Fjr0218VXJP4f+jkcuT7Gh2GsFBc3OHd9DARQB2BUW0=;
        b=X9T9Nf12m4VsZs53RA6oEa5L4OJzh8OZMgrMaRHdy9glzV4K6saWDAiOPGwdyrWdda
         08bZffKAA/vj/KzXydCWtlEP6JZm5pl9lVKxcvI5sVP3vv/mkx101EUZ8AB/+rE3bmr0
         qd/KR5DvNkoOF0S3WWdfqZbgcCDL+JuSjPKnPOzK0pzAdpcp/hBWiTCX+TqSx3/bR1JR
         GrBub4kRi2QVWOuqNOwOVuiOF+Z1/z50MD2z5OpyHYOm2r+2lgCTmBf05Z0EWS8L2ESU
         NpOlcc/uTEnKJzQqrhPGYB5NWs1ucjdbYMDm/h2eUHIH76zTTKrIL00VIwfykFLBFgL5
         dcSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Fjr0218VXJP4f+jkcuT7Gh2GsFBc3OHd9DARQB2BUW0=;
        b=h3JBnbecj92Vxt6CHxRRPDZWD9c5t7q2V5a0egyPmN0w7C6I/EIS20MLVXF3+zZISs
         7pa5qmHhAjp9gt4aKZZ04riidWuCu512QqkZmuJg+yzECuEvORpxx3wXjujZEehpy02K
         Nm6/xB8L1wz0gfRqai34RMylBLLKuFw8B5sU9qpPR5wsmTjgxTOmeAhaB9IM7GZu3Je+
         DOFjFdUokZoEzppYoBKQR1Oytliw6GdlgIvdG3Wnt3xxBahLEbSKohEMRQASGgd2Ho+4
         CCXBPSDYo5m0Q0YoIdRfoaV3HhnA6B0PKZNWHRvKsdnCR2XsZvPvLa9OcXJAQA5vq4sm
         nF5A==
X-Gm-Message-State: APjAAAWlnHpcyiN5jw2ZG1etsVEonDxoFq1pSjyO+dbl/uE6GY45mLSe
        Ckwur5aTSedJqC2JKFJbP33cZ8au
X-Google-Smtp-Source: APXvYqzDm2akNg47wEDMrOTq5XkBZpCX/qYhMiadGpKOrsm31NOvtT8+jpu4pCN7QeXuNmByhuH4pg==
X-Received: by 2002:a17:90a:6584:: with SMTP id k4mr13214586pjj.43.1572122541538;
        Sat, 26 Oct 2019 13:42:21 -0700 (PDT)
Received: from [192.168.86.235] (c-73-241-150-70.hsd1.ca.comcast.net. [73.241.150.70])
        by smtp.gmail.com with ESMTPSA id y10sm6537610pfe.148.2019.10.26.13.42.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 26 Oct 2019 13:42:20 -0700 (PDT)
Subject: Re: [PATCH v2] tcp: add timestamp options fetcher
To:     William Dauchy <wdauchy@gmail.com>, netdev@vger.kernel.org
Cc:     Eric Dumazet <eric.dumazet@gmail.com>
References: <20191002221017.2085-1-wdauchy@gmail.com>
 <20191026184554.32648-1-wdauchy@gmail.com>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <d7d15ef6-bc88-7cfa-3d3c-b220b13924ae@gmail.com>
Date:   Sat, 26 Oct 2019 13:42:19 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20191026184554.32648-1-wdauchy@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 10/26/19 11:45 AM, William Dauchy wrote:
> tsval and tsecr are useful in some cases to diagnose TCP issues from the
> sender point of view where unexplained RTT values are seen. Getting the
> the timestamps from both ends will help understand those issues more
> easily.
> It can be mostly use in some specific cases, e.g a http server where
> requests are tagged with such informations, which later helps to
> diagnose some issues and create some useful metrics to give a general
> signal.
> 

William, I am sorry but you do not describe what is supposed to be returned
in the structure.

Is it something updated for every incoming packet, every outgoing packet ?

What about out of order packets ?

Is the tcp_tsval our view of the tcp timestamps, or the value from the remote peer ?

What time unit is used for the values ?

What happens if TCP receives a packet that is discarded ? (for example by PAWS check)

tcp_parse_aligned_timestamp() would have updated tp->rx_opt.rcv_tsval and tp->rx_opt.rcv_tsecr
with garbage.

This means tp->rx_opt.rcv_tsval and tp->rx_opt.rcv_tsecr and really some working space
that could contain garbage. We could even imagine that a future version of TCP
no longer uses stable storage in the tcp socket for these, but some temporary room in the stack.

You really need to put more thinking into this, because otherwise every possible user
will have to dig the answers into linux kernel source.

In short, I really believe this tsval/tsecr thing is very hard to define and would
add more complexity in TCP just to make sure this is correctly implemented
and wont regress in the future.

You will have to convince us that this is a super useful feature, maybe publishing research results.

