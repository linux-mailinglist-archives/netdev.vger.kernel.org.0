Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 780181C1A67
	for <lists+netdev@lfdr.de>; Fri,  1 May 2020 18:12:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730100AbgEAQMM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 May 2020 12:12:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47988 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729881AbgEAQML (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 May 2020 12:12:11 -0400
Received: from mail-il1-x141.google.com (mail-il1-x141.google.com [IPv6:2607:f8b0:4864:20::141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F270C061A0C;
        Fri,  1 May 2020 09:12:11 -0700 (PDT)
Received: by mail-il1-x141.google.com with SMTP id c18so4885185ile.5;
        Fri, 01 May 2020 09:12:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=Iodo4U7LOCVxijacJr07fnu9OI5Fyd/DzRExN8zN+/8=;
        b=rCVFjBqghCjlPZHk8+/gJuPt5XrK/hcTRTVSMjp+LAbwYl/ztZJxZ/T+TcJ/SUiBot
         lXzipjY4/V8EkCDXc+k9pVaMwq0xMIDO9vDH9zfYtEYOcO/Yo3oF5KisLhMEEqEnh6lT
         ENLjs++D+UpKmO+V7PoouB4Cyv690ccu2aDzfbDZllbzULk4rCzqttAwHui+WTmZz3kg
         KuTOY+sgaU5bjh4tcFjDpzfumGvpv1Uen1IR09BrG8cSt3nXah8ApOftA6g/LjtRrTVw
         XpWov7Bax83cjkL4ZyrynvFubzKNkPEfTy6gl5lXbbll7TS5siowvFAgoA/6CirfU7PS
         qF2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=Iodo4U7LOCVxijacJr07fnu9OI5Fyd/DzRExN8zN+/8=;
        b=WUd1BrMHTVCXFM2c2d9EIpUCub60/ZPFZl8lzEqciezzf+A6Kb/JdjQnqiczKW5Bb0
         midULQ7ZlIr2/dKZg5VwMzbxIQVhCf5qiwQm3YljY4V3y6yBQy3SJXRU523vuoM2GLjm
         sLj7UpjUc/mh0989lDL9pcCa7a1PrEcAZoK+z1bw4qLVVHneFF1ZXUtLWVfxVI9wh2uk
         teVsjAKHmo1TUN/8AIMo7RxPUDfcR09cUqLCr4CnVfdW/VpPQdRXaZtW5AdFK1VqK1hX
         y4J5pwhfvk2Es7XdJaC4DGdSZUbW1Yjsvt1wzBk54UytR3ZS92Pi0Suf/M6Dwv+fd4n7
         iAqQ==
X-Gm-Message-State: AGi0Puamxup5lE6pjrDAkhhqTVxQd1aoWd091cRwi7ppUR7dkWnad0G0
        QL7Lnh47R3Lmdqb1D7W8mCU=
X-Google-Smtp-Source: APiQypIUuCUwPgWn3kaMl2z9/65xOTpKkp+T8hAH9L654oF/yl4P8XUBVCaABB7pg/f8imn3DDlqaA==
X-Received: by 2002:a92:c9c8:: with SMTP id k8mr4373815ilq.141.1588349530530;
        Fri, 01 May 2020 09:12:10 -0700 (PDT)
Received: from localhost ([184.63.162.180])
        by smtp.gmail.com with ESMTPSA id n138sm1083856iod.21.2020.05.01.09.12.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 01 May 2020 09:12:09 -0700 (PDT)
Date:   Fri, 01 May 2020 09:12:01 -0700
From:   John Fastabend <john.fastabend@gmail.com>
To:     Jakub Sitnicki <jakub@cloudflare.com>,
        John Fastabend <john.fastabend@gmail.com>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        kernel-team@cloudflare.com, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Joe Stringer <joe@wand.net.nz>,
        Lorenz Bauer <lmb@cloudflare.com>,
        Martin KaFai Lau <kafai@fb.com>
Message-ID: <5eac4a51d61ab_2dd52ac42ee805b8af@john-XPS-13-9370.notmuch>
In-Reply-To: <87h7x1utu8.fsf@cloudflare.com>
References: <20200429181154.479310-1-jakub@cloudflare.com>
 <20200429181154.479310-3-jakub@cloudflare.com>
 <5ea9d43aa9298_220d2ac81567a5b8fa@john-XPS-13-9370.notmuch>
 <87h7x1utu8.fsf@cloudflare.com>
Subject: Re: [PATCH bpf-next 2/3] selftests/bpf: Test that lookup on
 SOCKMAP/SOCKHASH is allowed
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jakub Sitnicki wrote:
> On Wed, Apr 29, 2020 at 09:23 PM CEST, John Fastabend wrote:
> > Jakub Sitnicki wrote:
> >> Now that bpf_map_lookup_elem() is white-listed for SOCKMAP/SOCKHASH,
> >> replace the tests which check that verifier prevents lookup on these map
> >> types with ones that ensure that lookup operation is permitted, but only
> >> with a release of acquired socket reference.
> >> 
> >> Signed-off-by: Jakub Sitnicki <jakub@cloudflare.com>
> >> ---
> >
> > For completeness would be nice to add a test passing this into
> > sk_select_reuseport to cover that case as well. Could come as
> > a follow up patch imo.
> 
> Is this what you had in mind?

Yes thanks!

> 
> https://lore.kernel.org/bpf/20200430104738.494180-1-jakub@cloudflare.com/
> 
> Thanks for reviewing the series.
