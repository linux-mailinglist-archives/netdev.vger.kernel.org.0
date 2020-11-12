Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 501DB2B0DC2
	for <lists+netdev@lfdr.de>; Thu, 12 Nov 2020 20:20:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726566AbgKLTUE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Nov 2020 14:20:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47944 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726255AbgKLTUD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Nov 2020 14:20:03 -0500
Received: from mail-ot1-x32f.google.com (mail-ot1-x32f.google.com [IPv6:2607:f8b0:4864:20::32f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F340BC0613D1;
        Thu, 12 Nov 2020 11:20:03 -0800 (PST)
Received: by mail-ot1-x32f.google.com with SMTP id j14so6715738ots.1;
        Thu, 12 Nov 2020 11:20:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=33v82rYPkbtauRnrxMrnUeQRuS+uGenuk5EAtau1PrU=;
        b=KipGtNW3tZHU1In/my+8qokRGJMYqlA4iv0Mn4rMohKlLpIhx058JGHjkShR1L0QLL
         QjldFxP8kPEFc1gjjDsMbycCMhV+7JNnzihl286AOR7OdU2XNciykmBMje5OdWpB9Qmn
         yC5Czp8cRrShbGYfa9pyZm8y/zslej4UA6o7ybZ75yXMsJulrZjRGNGowfxUJJH8+kHP
         o96MJiBsseNRZdQp8NUIhE6U2P0IOWu49DMrBMzoU1rMV1dFO1UClM3FHXEuJx3q2c8b
         Fk3dRpS8tsbA9bY4Ddhi90AkfhvgVHtdHJvVbkC0GmcB8Bv63jSW6dGc5NsN55JRIVZi
         ZDdQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=33v82rYPkbtauRnrxMrnUeQRuS+uGenuk5EAtau1PrU=;
        b=VCqWhdEA2jyyqK7XLXCDnCzj97hC/POc67yaxxEiw2ml5InqMkh7+WfY/qYos2cmtq
         0+vaZmynhaHEvItV7xyIOCRXPFF042ijraH/EjBY+qarxT6Dpv9ZAzm8PWqwEQkqkcn3
         TzlSqQogDHBX+f2DhtlQu90TpeGRgEYGBzNNXcfC/GAKlpjoNcfeGVj2AkSDOhQzO8JE
         rAKXRJHaYUrmwLdH20hCsswB8T4uZO8PRKnVtvDFKJPDBxWRrVaFENnuJp+n9V9xxtA6
         MeuiEbSd5+YWzaLQmO483HG72ZJXRrMOh7H4+ORMZw5JuoYaOp9SpPCGaSGx7y3R7EW4
         HxNQ==
X-Gm-Message-State: AOAM531rIEJH/Ri/CF9Y53IDW7aSNENxHra3TEb45T5cucYN4Bz3ZFje
        XY5wQZlWulAtIVm27YHX2y4=
X-Google-Smtp-Source: ABdhPJw9w+CicVYTvbmd1pJuUHkhkEMpE0az8k7onLnk9jRGr2seim7YySDdiis5a/rtlvmR4up0LA==
X-Received: by 2002:a9d:6b98:: with SMTP id b24mr556778otq.46.1605208801924;
        Thu, 12 Nov 2020 11:20:01 -0800 (PST)
Received: from localhost ([184.63.162.180])
        by smtp.gmail.com with ESMTPSA id w3sm1453198oov.48.2020.11.12.11.20.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Nov 2020 11:20:01 -0800 (PST)
Date:   Thu, 12 Nov 2020 11:19:54 -0800
From:   John Fastabend <john.fastabend@gmail.com>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        davem@davemloft.net
Cc:     daniel@iogearbox.net, netdev@vger.kernel.org, bpf@vger.kernel.org,
        kernel-team@fb.com
Message-ID: <5fad8adaa7c5d_2a6120828@john-XPS-13-9370.notmuch>
In-Reply-To: <20201111031213.25109-3-alexei.starovoitov@gmail.com>
References: <20201111031213.25109-1-alexei.starovoitov@gmail.com>
 <20201111031213.25109-3-alexei.starovoitov@gmail.com>
Subject: RE: [PATCH v2 bpf-next 2/3] selftests/bpf: Add skb_pkt_end test
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Alexei Starovoitov wrote:
> From: Alexei Starovoitov <ast@kernel.org>
> 
> Add a test that currently makes LLVM generate assembly code:
> 
> $ llvm-objdump -S skb_pkt_end.o
> 0000000000000000 <main_prog>:
> ; 	if (skb_shorter(skb, ETH_IPV4_TCP_SIZE))
>        0:	61 12 50 00 00 00 00 00	r2 = *(u32 *)(r1 + 80)
>        1:	61 14 4c 00 00 00 00 00	r4 = *(u32 *)(r1 + 76)
>        2:	bf 43 00 00 00 00 00 00	r3 = r4
>        3:	07 03 00 00 36 00 00 00	r3 += 54
>        4:	b7 01 00 00 00 00 00 00	r1 = 0
>        5:	2d 23 02 00 00 00 00 00	if r3 > r2 goto +2 <LBB0_2>
>        6:	07 04 00 00 0e 00 00 00	r4 += 14
> ; 	if (skb_shorter(skb, ETH_IPV4_TCP_SIZE))
>        7:	bf 41 00 00 00 00 00 00	r1 = r4
> 0000000000000040 <LBB0_2>:
>        8:	b4 00 00 00 ff ff ff ff	w0 = -1
> ; 	if (!(ip = get_iphdr(skb)))
>        9:	2d 23 05 00 00 00 00 00	if r3 > r2 goto +5 <LBB0_6>
> ; 	proto = ip->protocol;
>       10:	71 12 09 00 00 00 00 00	r2 = *(u8 *)(r1 + 9)
> ; 	if (proto != IPPROTO_TCP)
>       11:	56 02 03 00 06 00 00 00	if w2 != 6 goto +3 <LBB0_6>
> ; 	if (tcp->dest != 0)
>       12:	69 12 16 00 00 00 00 00	r2 = *(u16 *)(r1 + 22)
>       13:	56 02 01 00 00 00 00 00	if w2 != 0 goto +1 <LBB0_6>
> ; 	return tcp->urg_ptr;
>       14:	69 10 26 00 00 00 00 00	r0 = *(u16 *)(r1 + 38)
> 0000000000000078 <LBB0_6>:
> ; }
>       15:	95 00 00 00 00 00 00 00	exit
> 
> Signed-off-by: Alexei Starovoitov <ast@kernel.org>
> ---

Acked-by: John Fastabend <john.fastabend@gmail.com>
