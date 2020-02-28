Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DB095173E19
	for <lists+netdev@lfdr.de>; Fri, 28 Feb 2020 18:14:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726562AbgB1ROQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Feb 2020 12:14:16 -0500
Received: from mail-pj1-f66.google.com ([209.85.216.66]:54301 "EHLO
        mail-pj1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725730AbgB1ROQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Feb 2020 12:14:16 -0500
Received: by mail-pj1-f66.google.com with SMTP id dw13so1543882pjb.4;
        Fri, 28 Feb 2020 09:14:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version;
        bh=yMv5xu9YgcDWDsypzsNvCc1G+AinxBPAgahcuFPEI+8=;
        b=ud1iRBpFWJF3bAoC2V3s3V4LUBMorh5LE5RqU0SgsnxcgS53emgMHeOOGrYReaWCPL
         w4jyIiqiE3OG8js1PfMDeQB8E5PPSsP16RJtuMKHa/UNw7OVNb7TYqSSnd8ahB98O1IA
         rlpJWlRPDuIpAXWeJxhq4X2SjmpOvPkxxjMQyUNWj7rDOtsgmWbN825LK7pFvSjYN7//
         x9KBx8p08BnTXqcg59nStiLU7cs0hyH2VtV+gYbTjfgMmbSrucR7SEt/t2SG+m0Bo/UF
         z9E6xB/10lgeg6+t1cZEbrZXfjSLE9iZWH3fSu48414v2QJIg5HLjamAp5rn5Vc1OnZe
         lrig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version;
        bh=yMv5xu9YgcDWDsypzsNvCc1G+AinxBPAgahcuFPEI+8=;
        b=i5GdhdcjQfCwG3Ylaab4bMsvaKdq1bH69Z073SvUEwZEZm/3KqUXZuQfliBIB9KD9Z
         zZBNBaULlRDmre1R4YufAmZbANCkwCtBsIA1x+IK+Zmnlf9IQEUYzrEt+IbLh+fkbkU2
         JrBx8pk8OHAiyBRGoAGDTxcZtmqUd3vE4DWKYKRBxbZZHLf3v/sYm9fCwKY3shYqJULw
         wVqy51fKlhKWmkGsbKPpg3kZWmuDZmsfng1VKvEVf+EABliUdFoeSW0XjWK6zOqiKoE3
         yDFc9BfRTKaukFwPz6ZKJn5HnTNJLBatTnNKcW83ct7+H1ViGQLWXbL+w2VBmLAZz3p/
         t76w==
X-Gm-Message-State: APjAAAUcE4OvPeL0Bz0dGz/JJcPDieeven+roMAxGn71LAsbGBsb4uCW
        8/7ZCfSmoGUgUoWi7YwmqL04vaBC
X-Google-Smtp-Source: APXvYqz4eS9G3b2PGiQZRgkjMvUxaRgisw1x1Lr1PCrTvpqw6i8RVcfJIvOUTi3OfL21i55zTlJdxA==
X-Received: by 2002:a17:902:ec01:: with SMTP id l1mr4972539pld.205.1582910055262;
        Fri, 28 Feb 2020 09:14:15 -0800 (PST)
Received: from [172.20.55.224] ([2620:10d:c090:500::4:3ffc])
        by smtp.gmail.com with ESMTPSA id z27sm12307181pfj.107.2020.02.28.09.14.13
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 28 Feb 2020 09:14:14 -0800 (PST)
From:   "Jonathan Lemon" <jonathan.lemon@gmail.com>
To:     "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Cc:     "=?utf-8?b?QmrDtnJuIFTDtnBlbA==?=" <bjorn.topel@intel.com>,
        "Magnus Karlsson" <magnus.karlsson@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        "Jakub Kicinski" <kuba@kernel.org>,
        "Alexei Starovoitov" <ast@kernel.org>,
        "Daniel Borkmann" <daniel@iogearbox.net>,
        "Jesper Dangaard Brouer" <hawk@kernel.org>,
        "John Fastabend" <john.fastabend@gmail.com>,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [next] xdp: Replace zero-length array with flexible-array
 member
Date:   Fri, 28 Feb 2020 09:14:12 -0800
X-Mailer: MailMate (1.13.1r5671)
Message-ID: <6FEAF24E-27CF-4840-8134-595D27275976@gmail.com>
In-Reply-To: <20200228131907.GA17911@embeddedor>
References: <20200228131907.GA17911@embeddedor>
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 28 Feb 2020, at 5:19, Gustavo A. R. Silva wrote:

> The current codebase makes use of the zero-length array language
> extension to the C90 standard, but the preferred mechanism to declare
> variable-length types such as these ones is a flexible array member[1][2],
> introduced in C99:
>
> struct foo {
>         int stuff;
>         struct boo array[];
> };
>
> By making use of the mechanism above, we will get a compiler warning
> in case the flexible array does not occur last in the structure, which
> will help us prevent some kind of undefined behavior bugs from being
> inadvertently introduced[3] to the codebase from now on.
>
> Also, notice that, dynamic memory allocations won't be affected by
> this change:
>
> "Flexible array members have incomplete type, and so the sizeof operator
> may not be applied. As a quirk of the original implementation of
> zero-length arrays, sizeof evaluates to zero."[1]
>
> This issue was found with the help of Coccinelle.
>
> [1] https://gcc.gnu.org/onlinedocs/gcc/Zero-Length.html
> [2] https://github.com/KSPP/linux/issues/21
> [3] commit 76497732932f ("cxgb3/l2t: Fix undefined behaviour")
>
> Signed-off-by: Gustavo A. R. Silva <gustavo@embeddedor.com>

Acked-by: Jonathan Lemon <jonathan.lemon@gmail.com>
