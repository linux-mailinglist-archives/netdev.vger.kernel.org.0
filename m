Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F38591950C1
	for <lists+netdev@lfdr.de>; Fri, 27 Mar 2020 06:42:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726742AbgC0Fmi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Mar 2020 01:42:38 -0400
Received: from mail-pf1-f196.google.com ([209.85.210.196]:33710 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725857AbgC0Fmh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Mar 2020 01:42:37 -0400
Received: by mail-pf1-f196.google.com with SMTP id j1so3994052pfe.0;
        Thu, 26 Mar 2020 22:42:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=4wG0RN2cqceurx8JJbCkwdHJTX3H2NrTFGH7MZM7fwg=;
        b=df9+GCRhbWr8zBo94fv09n7M8GP4rAOTXPZOZ4/3ajfVSiT4aSPd3pxh6KWUikgcXF
         LysJd1g2wCssSLGqFnOuaQ9/K6S5GdeaneGPdFASMxItrYkVFnVpo8EpNyLpE74iN6Yj
         75HKNKNgpgG1tdFs4k5lHm1ACWROFN0i4T+xWeAaAfLgax79tTuv7YaT1YZe0jKiUz8D
         56n4fbNRpbBATvAYVYYvwer4IDi5pvooBx0HbJbUjdxNjjHd3912tUHXGdf3hpbvtLCT
         rx7aIcH6l4shmdECgb/Q1VKSP1v0JDHIWxXZ24ipKSau4ov3uUWGwi91up/nSa4HxWPE
         EcGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=4wG0RN2cqceurx8JJbCkwdHJTX3H2NrTFGH7MZM7fwg=;
        b=qtTvAwCTxNSTECCVSZMgYI4vWf/Uvc5uB5aZUVYTuFp1mHPWYNLhCh3Pf4SmkIkT/U
         X+4FkxX1rgO8gaSUawL70yhXRLSWATbeCjQGTe+XWdbit7Eig4FhD/40f65G5uDtMdfP
         2tuBKaiqZe74bZwj3vq2ziWSxtrh8WKW0bwsx3+MVa/4+uz5j88gTxme6pu2HAWhYZRs
         rTgHxtlPZ4/BlZ3DpzPUlWntQBZJQq5ncQ3XGie2PJIMKseLL+P1A2aswqjyU4WyNt3c
         +qJ1xrlJQ0+fUQJwQkYEOUGsWdRUTxDCBtfj6KNIbjhstfe7TB4A2JOed6v4ZngdjxjG
         XeVw==
X-Gm-Message-State: ANhLgQ2vVV4xEO/GPADOoLP/JdB3qJp6I0nVw+i1k2EAqdbBl0FzaBlb
        j/No0kNVOHqwcRjid4A+39M=
X-Google-Smtp-Source: ADFU+vtCR3XkSpfJHe8WUvyiWOjsZNEKEwpio8c5gW+pTjhFHR1cqDooYAGbN9o5t5lKghsIG+U6tg==
X-Received: by 2002:a62:a119:: with SMTP id b25mr12772596pff.158.1585287755332;
        Thu, 26 Mar 2020 22:42:35 -0700 (PDT)
Received: from [192.168.86.235] (c-73-241-150-58.hsd1.ca.comcast.net. [73.241.150.58])
        by smtp.gmail.com with ESMTPSA id c190sm3138089pfa.66.2020.03.26.22.42.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 26 Mar 2020 22:42:34 -0700 (PDT)
Subject: Re: [PATCHv3 bpf-next 0/5] Add bpf_sk_assign eBPF helper
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Joe Stringer <joe@wand.net.nz>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org, daniel@iogearbox.net,
        ast@kernel.org, eric.dumazet@gmail.com, lmb@cloudflare.com,
        kafai@fb.com
References: <20200327042556.11560-1-joe@wand.net.nz>
 <20200327050215.vpl62gfvjj7zljdf@ast-mbp>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <3882061d-b7b8-63e7-f6f9-ba108528b83a@gmail.com>
Date:   Thu, 26 Mar 2020 22:42:33 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <20200327050215.vpl62gfvjj7zljdf@ast-mbp>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 3/26/20 10:02 PM, Alexei Starovoitov wrote:
> On Thu, Mar 26, 2020 at 09:25:51PM -0700, Joe Stringer wrote:
>> Introduce a new helper that allows assigning a previously-found socket
>> to the skb as the packet is received towards the stack, to cause the
>> stack to guide the packet towards that socket subject to local routing
>> configuration. The intention is to support TProxy use cases more
>> directly from eBPF programs attached at TC ingress, to simplify and
>> streamline Linux stack configuration in scale environments with Cilium.
> 
> Thanks for the quick respin.
> It builds. And tests are passing for me.
> The lack of acks and reviewed-by is a bit concerning for such important feature.
> 
> Folks, please be more generous with acks :)
> so we can apply it with more confidence.
> 

I can review this tomorrow morning, thanks.
