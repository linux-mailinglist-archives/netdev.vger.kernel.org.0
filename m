Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 12A4630835C
	for <lists+netdev@lfdr.de>; Fri, 29 Jan 2021 02:49:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231246AbhA2Brw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Jan 2021 20:47:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47530 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231210AbhA2Bro (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Jan 2021 20:47:44 -0500
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4DFAAC061573;
        Thu, 28 Jan 2021 17:47:04 -0800 (PST)
Received: by mail-pj1-x1029.google.com with SMTP id jx18so5479209pjb.5;
        Thu, 28 Jan 2021 17:47:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=ZEwxOEWEUldbVA77DNHYazxcJ2zOigWsWKQuv/zMlHk=;
        b=YdfDNprXozcmkHwu+BvjWK9q9U4AtkmWrX0rdyUToNJFOP7JVpV2WUuu56n56I5bDI
         P2CNbKCKt8cIKL7Oel2DT+tp8+e6f7wJrSIbS8y4Lm9gHG7ispgPO02LLbhhlZuruAhE
         GnkIYbOw0W77wtxVZYFIpTZSsGbb823igNLgIm7JeOo3He8MRpSPAn8LVrOw0hp/ujDi
         hzwAQBc7Vl0jzeMOVYA+5/m4uVJZWT4Ae78dAXsmih4UJW1E4a8930x0/A84twIull5x
         pw09mZ6Yi+p8amUAFA6xNb4+IlJTFOsR3RiUpvT61n18hqaqfB/4dMi8CSOFgs6zdO/5
         r8Mw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=ZEwxOEWEUldbVA77DNHYazxcJ2zOigWsWKQuv/zMlHk=;
        b=gZ15r8blVr9bNjsEvNQKsrhFKKBW3TiL5Clb66r5SpiXVS9yMgm8thmQRB/X1HJ77X
         ekciN6/hYh2hJYGwrJycJ/EIVxeQ4T3cFkT/WkL5g1ih7XYJMwo49/eA62Wnum2s984B
         KLsxtz+HpRUoNGbBXJ/Qcvtr8UQ5pXtkVGp6Ke6+0s1pE+yKJr0cKXDyPWBGj1YFb3PO
         icWlG/kAJGM97u+JCVxKVuTpV3Rr2u1k0RvUm5hjCXnWz4K1g5z84ZJTAguZ/G2Op5qE
         0aFV9n1L8CQ8CkzjqtN7nBrXNYmNAGOY0e83lgWL9hEbcAOpnQu9uS5jZOJ6vweEP9NM
         PKew==
X-Gm-Message-State: AOAM533tCY53x06UbvXsb2Oi9jtYlevH6IQ0I8MbYl4RaLsutdBN9HVc
        q+Ky2Xl7GSvc9h0YJxww/0A=
X-Google-Smtp-Source: ABdhPJwjnRcDA7rrB+FiuFk4GOlWV6rtyhl9SeWcti0KcyOHW6MenKsqVDI8iMZRXKh7FkKbc9OYHQ==
X-Received: by 2002:a17:90b:3c8:: with SMTP id go8mr2180848pjb.105.1611884823873;
        Thu, 28 Jan 2021 17:47:03 -0800 (PST)
Received: from Leo-laptop-t470s ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id 83sm6792991pfb.68.2021.01.28.17.46.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 28 Jan 2021 17:47:03 -0800 (PST)
Date:   Fri, 29 Jan 2021 09:46:50 +0800
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     John Fastabend <john.fastabend@gmail.com>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        Toke =?iso-8859-1?Q?H=F8iland-J=F8rgensen?= <toke@redhat.com>,
        Jiri Benc <jbenc@redhat.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Eelco Chaudron <echaudro@redhat.com>, ast@kernel.org,
        Daniel Borkmann <daniel@iogearbox.net>,
        Lorenzo Bianconi <lorenzo.bianconi@redhat.com>,
        David Ahern <dsahern@gmail.com>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Subject: Re: [PATCHv17 bpf-next 6/6] selftests/bpf: add xdp_redirect_multi
 test
Message-ID: <20210129014650.GA2900@Leo-laptop-t470s>
References: <20210122074652.2981711-1-liuhangbin@gmail.com>
 <20210125124516.3098129-1-liuhangbin@gmail.com>
 <20210125124516.3098129-7-liuhangbin@gmail.com>
 <60134aa5cd92d_f9c120823@john-XPS-13-9370.notmuch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <60134aa5cd92d_f9c120823@john-XPS-13-9370.notmuch>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi John,
On Thu, Jan 28, 2021 at 03:37:09PM -0800, John Fastabend wrote:
> Otherwise, its not the most elegant, but testing XDP at the moment
> doesn't fit into the normal test framework very well either.

Thanks a lot for your help in reviewing the patches. I will add updating
XDP test in my todo list.

Thanks
hangbin
