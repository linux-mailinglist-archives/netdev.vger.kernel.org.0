Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B50493EF02A
	for <lists+netdev@lfdr.de>; Tue, 17 Aug 2021 18:29:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230188AbhHQQ1M (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Aug 2021 12:27:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54808 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229518AbhHQQ1F (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Aug 2021 12:27:05 -0400
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 69C16C061764;
        Tue, 17 Aug 2021 09:26:32 -0700 (PDT)
Received: by mail-pj1-x1032.google.com with SMTP id mq2-20020a17090b3802b0290178911d298bso7178483pjb.1;
        Tue, 17 Aug 2021 09:26:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=wQTsET6oBxsb+BxyZU/lAk0roJlCRzO1Zh+nAP6uf8g=;
        b=CZ6E06co9olcvRslsYUsuQlobgSqRLzP/3SE196pquYkfaBqNwCuoEgrIYHoss/0Gt
         93Cw8HSzd4MYs+8jkl40GA1jrLW6aNRALZt6M67IOdbTXCVrFxiXnuxohpVU7NTwrHIE
         Hdu3hLIAsmagN139GDl0FNlaJXWpLOVmo1rPiebgzPVe23dmEUnupaoYmw5ZznSefyUW
         zQMoebijBOvtWMRO/ocml8bLSsmXLKK8TK6Bt660EyvFJUGx1Rx9KrnZ6cIFrLkLZfLI
         nuG+FkTwyl2oekOzyB1Dgoe2g1+VfbwOyWCk9bhA3MUr+/e/h9nSNsh+Fcm3MZjedDBv
         j71Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=wQTsET6oBxsb+BxyZU/lAk0roJlCRzO1Zh+nAP6uf8g=;
        b=L6/sGvbSIHriR1KZTxJWl6c3CF2cDToSuO4XedI+e15I0cXqe937Lw8+Bj9l1F0u3h
         3zeFJ0ohSJKEAVWMf16gBTZmYFkjDX3MWoZHYL+K/p2ODaSZHiMBQLrxmDmC7gzlA+9s
         bUYz7s7i9PGHcsRxgwUlmq9ZO5hsVg8U2bHJp/5WqdtfjIlpKvKddHlJ7ZiFPaCFFU4R
         cZiiVncJk1l+2Tn9UPrtbFHW2VffGeADtldhsmOLPr9gl7HfrV0BmsYoOqSQpP9oL58k
         0TzoR+7eNvJSBCQbnVsL5Rl8tXa7h7r75gJ8fRyPu9fx9PRPQVMfBcSRAuDOe6LopQkm
         VVXA==
X-Gm-Message-State: AOAM533pt/sQx2TYA+SoogZsKNAhXyA1hY9bKr+pTKH5np+BZKLM1mTT
        WGdLC5M6PDw99Ubcrd8ccyA=
X-Google-Smtp-Source: ABdhPJyeFzJ5itZS2GCNi9Wg6rlQjJtxvrfEy2yDt9VBhvOGuNWUUUEw5XouXdv7AdfRIWByf7NN5A==
X-Received: by 2002:a62:3185:0:b0:3e1:ae2e:4b78 with SMTP id x127-20020a623185000000b003e1ae2e4b78mr4358532pfx.18.1629217591846;
        Tue, 17 Aug 2021 09:26:31 -0700 (PDT)
Received: from gmail.com ([2601:600:8500:5f14:bd71:fea:c430:7b0a])
        by smtp.gmail.com with ESMTPSA id r11sm2568361pjd.26.2021.08.17.09.26.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Aug 2021 09:26:31 -0700 (PDT)
Date:   Tue, 17 Aug 2021 09:22:20 -0700
From:   "avagin@gmail.com" <avagin@gmail.com>
To:     David Laight <David.Laight@aculab.com>
Cc:     'Bui Quang Minh' <minhquangbui99@gmail.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "yoshfuji@linux-ipv6.org" <yoshfuji@linux-ipv6.org>,
        "dsahern@kernel.org" <dsahern@kernel.org>,
        "willemb@google.com" <willemb@google.com>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "alexander@mihalicyn.com" <alexander@mihalicyn.com>,
        "lesedorucalin01@gmail.com" <lesedorucalin01@gmail.com>
Subject: Re: [PATCH v2 1/2] udp: UDP socket send queue repair
Message-ID: <YRviPJwrnuh9Nn35@gmail.com>
References: <20210811154557.6935-1-minhquangbui99@gmail.com>
 <721a2e32-c930-ad6b-5055-631b502ed11b@gmail.com>
 <7f3ecbaf-7759-88ae-53d3-2cc5b1623aff@gmail.com>
 <489f0200-b030-97de-cf3a-2d715b07dfa4@gmail.com>
 <3f861c1d-bd33-f074-8ef3-eede9bff73c1@gmail.com>
 <29dc7ac9781344f1a57e16c14900a7da@AcuMS.aculab.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=koi8-r
Content-Disposition: inline
In-Reply-To: <29dc7ac9781344f1a57e16c14900a7da@AcuMS.aculab.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Aug 13, 2021 at 01:00:12PM +0000, David Laight wrote:
> From: Bui Quang Minh
> > Sent: 13 August 2021 12:08
> ...
> > The reason we want to dump the packet in send queue is to make to state of the
> > application consistent. The scenario is that when an application sends UDP
> > packets via UDP_CORK socket or with MSG_MORE, CRIU comes and checkpoints the
> > application. If we drop the data in send queue, when application restores, it
> > sends some more data then turns off the cork and actually sends a packet. The
> > receiving side may get that packet but it's unusual that the first part of that
> > packet is missing because we drop it. So we try to solve this problem with some
> > help from the Linux kernel.
> 
> Patient: It hurts if I do xxx.
> Doctor: Don't do xxx then.
> 
> It has to be more efficient to buffer partial UDP packets
> in userspace and only send when all the packet is available.

You are right. It can be more efficient, but we don't have controls over
user-space processes, and they can do whatever the kernel allows them to
do.

> 
> 	David
> 
> -
> Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
> Registration No: 1397386 (Wales)
