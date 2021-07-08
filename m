Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 06D3E3C1569
	for <lists+netdev@lfdr.de>; Thu,  8 Jul 2021 16:44:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232031AbhGHOri (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Jul 2021 10:47:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52866 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231976AbhGHOrh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Jul 2021 10:47:37 -0400
Received: from mail-ot1-x332.google.com (mail-ot1-x332.google.com [IPv6:2607:f8b0:4864:20::332])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42909C061574;
        Thu,  8 Jul 2021 07:44:54 -0700 (PDT)
Received: by mail-ot1-x332.google.com with SMTP id i5-20020a9d68c50000b02904b41fa91c97so1663520oto.5;
        Thu, 08 Jul 2021 07:44:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=F/Awx1Vy2NafahXTtsnNysIQcjAXLo83SmFI5Ze6190=;
        b=X2HAfGRyLnWiW354cxtjdeOSW0l6EWAOj897IYPhwDEhXdfBMBMWpcB2mbsHD5eYrB
         2OLCQSwEme5sQ3zVp765w11BYdfcLRw1xklWreudoB44N8eJPTkehIXRu8hl5RDQYYIO
         CxCzIBsQSY/eY5J24DarPG0ysUvF4/z2LatfGLLp14pL4lJ4e4Toc9xrVwufBidIOmAH
         NJU8cEdCSpk7yHCBgQqVEzMYX8n7Q7E3KtafPenOfIKsSiiz17p3qJ6ussakPQzehhWv
         gMvaC0gmhSIgm6yG8CieDX4M+3y6qdrEtr7MT5zUtmiBDgtKb7ej5XYZb0y+s745jW9l
         fU7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=F/Awx1Vy2NafahXTtsnNysIQcjAXLo83SmFI5Ze6190=;
        b=DX7t6zTeS9kth/BBLF5vIXADQBAPMK1hp7orkGp/Z62zI5NwnwgIMPUL1AUiWC/wLa
         ay+4SqsZtE3Lsuv36fRHok2DCSKCZEQg7wfzsjOk1ML6bOZM0b317O43wBkEtNzK0Jea
         lky7Z2JTbfBEYVQiZl5+G6t6w5UkUToFfEAuBZibyjifcYpwZ04jZoyLpF5bm6bGP9T1
         zmhh9yL/r1Of8/mX+uJH1K4k5Ym9bAVZBSxCdr/6qLBjTqYnp0Tnr7mkaIhEVrN35oQd
         0rW45vRj+Bt5K3ieunfqwBRmVMJVXtsDvNOtaR6wMt3nb3wf5T7ryUaHaKKIZXqlAYXj
         VyEQ==
X-Gm-Message-State: AOAM530C9OtSipeOl/toCrZeoKTdcyW5adpElEbZuxSpqPsDudb69KoM
        MarL2ytc0we9tuvjvmuWCcw=
X-Google-Smtp-Source: ABdhPJy3WMsXEufiA4YpxDjQhZcklIxgAuYy6pYCM8r86lpKnwJ1fUfkwTBPLIP57e+XI4Ufveg/8w==
X-Received: by 2002:a05:6830:2497:: with SMTP id u23mr6996108ots.344.1625755493710;
        Thu, 08 Jul 2021 07:44:53 -0700 (PDT)
Received: from Davids-MacBook-Pro.local ([8.48.134.38])
        by smtp.googlemail.com with ESMTPSA id m1sm522039otl.0.2021.07.08.07.44.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 08 Jul 2021 07:44:52 -0700 (PDT)
Subject: Re: [PATCH bpf] bpf: fix for BUG: kernel NULL pointer dereference,
 address: 0000000000000000
To:     Jesper Dangaard Brouer <jbrouer@redhat.com>,
        Xuan Zhuo <xuanzhuo@linux.alibaba.com>, bpf@vger.kernel.org
Cc:     brouer@redhat.com, "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        netdev@vger.kernel.org, Abaci <abaci@linux.alibaba.com>,
        Dust Li <dust.li@linux.alibaba.com>,
        David Ahern <dsahern@kernel.org>
References: <20210708080409.73525-1-xuanzhuo@linux.alibaba.com>
 <c314bdcc-06fc-c869-5ad8-a74173a1e6f1@redhat.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <f52ae16f-ee2b-c691-311a-51824c2d87e9@gmail.com>
Date:   Thu, 8 Jul 2021 08:44:48 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <c314bdcc-06fc-c869-5ad8-a74173a1e6f1@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 7/8/21 4:26 AM, Jesper Dangaard Brouer wrote:
> 
> Thanks for catching this.
> 
> Cc: Ahern, are you okay with disabling this for the
> bpf_prog_test_run_xdp() infra?

yes.

> 
> I don't think the selftests/bpf (e.g. prog_tests/xdp_devmap_attach.c)
> use the bpf_prog_test_run, right?
> 
> Acked-by: Jesper Dangaard Brouer <brouer@redhat.com>


Acked-by: David Ahern <dsahern@kernel.org>
