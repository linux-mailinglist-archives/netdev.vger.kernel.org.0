Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7F7F62C46E9
	for <lists+netdev@lfdr.de>; Wed, 25 Nov 2020 18:38:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732884AbgKYRhX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Nov 2020 12:37:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40992 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730419AbgKYRhW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Nov 2020 12:37:22 -0500
Received: from mail-io1-xd41.google.com (mail-io1-xd41.google.com [IPv6:2607:f8b0:4864:20::d41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C1F04C0613D4;
        Wed, 25 Nov 2020 09:37:22 -0800 (PST)
Received: by mail-io1-xd41.google.com with SMTP id i9so2945812ioo.2;
        Wed, 25 Nov 2020 09:37:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=BBUsuCzzRQpf1zclwPXNGLE08MUefEX1M3OnYZB0/ek=;
        b=ryEOZlWMemD6xAV/fHbMcRM+gqLVKtp4F2I0y/GwCcpYGUh04QRMsof1BMhgTEdtFN
         RJQ4NBgUInXr51Ukm0HkRSNDN9MCr0KbnN5JB/CBoFyhS4tfjHCvFk8sBBi8q0D/o7US
         D5q8aXQk65cljQzc7tVG+Qs1dIohJwotYnl7GFssyYbSiLQeh/fBaduRB9vdIW+wM2oT
         rW9Y0EuvLsYGqP535Z3fLeOple3hqtfk5O8HVv2qhwgtLhUMJE5JyXgi3M81IIFagMXS
         gG/XPRzR/wTF+IL37N5+dgqA2v6PjfSdPkidsqjuot5KP1ol660+xnGYMpgO2qgqTnXH
         V3EQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=BBUsuCzzRQpf1zclwPXNGLE08MUefEX1M3OnYZB0/ek=;
        b=X4cjPXl4xNfByAseqk2Gv6DL+crTKjzbvbqE9DkRxM1fa3wEdYsWgS9I/4cm0TVb/y
         zYemVCWZW2Q6+G4sY7z236pOTtxp95mym09U0eQPS4v+A+ix3nCN8RZ0Wj9LLjVOYDWK
         I4RxNRs56dZhJgyxPm+5nfVRXpasxZA6wy5eopqbS7NbEzlu7SdvR90a8d6K4r+S72EP
         HwVemsG0hc2rU0Zj78xnSw0bjekQUrOz0tVEtzo/G6chVHL245SctTGPU5cP4xS/OpP2
         kM3o5Y6eYYYkc0X/5D3/lIE/kIs9jaDTB1hACPX7mv7a1sG2SgwlD26lwoHqvsSKY6to
         7M6w==
X-Gm-Message-State: AOAM533c9wpVlFJGuuf7oyvUN0rfes84T9y698KwmcpEbcvwej/5oMbJ
        L28QYQVpRMhz3S5mj8psusg=
X-Google-Smtp-Source: ABdhPJx4q9GOC7WqKqT9R1pPENviHRfBksRimpdovj5Sa5h9ghsoTCYWpdvrvlhekqCf8yxfiYt+kg==
X-Received: by 2002:a5d:8b87:: with SMTP id p7mr3330686iol.96.1606325842219;
        Wed, 25 Nov 2020 09:37:22 -0800 (PST)
Received: from Davids-MacBook-Pro.local ([2601:284:8203:54f0:b920:c7b8:6a02:a6c0])
        by smtp.googlemail.com with ESMTPSA id o8sm1256872ioo.20.2020.11.25.09.37.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 25 Nov 2020 09:37:21 -0800 (PST)
Subject: Re: [net-next v3 0/8] seg6: add support for SRv6 End.DT4/DT6 behavior
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Andrea Mayer <andrea.mayer@uniroma2.it>,
        "David S. Miller" <davem@davemloft.net>,
        David Ahern <dsahern@kernel.org>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Shuah Khan <shuah@kernel.org>,
        Shrijeet Mukherjee <shrijeet@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org,
        Nathan Chancellor <natechancellor@gmail.com>,
        Stefano Salsano <stefano.salsano@uniroma2.it>,
        Paolo Lungaroni <paolo.lungaroni@cnit.it>,
        Ahmed Abdelsalam <ahabdels.dev@gmail.com>
References: <20201123182857.4640-1-andrea.mayer@uniroma2.it>
 <20201124154904.0699f4c1@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <3dd23494-d6ae-1c09-acb3-c6c2b2ef93d8@gmail.com>
 <20201124175803.1e09e19e@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <08201db4-d523-3b0e-fcb6-dfb666f2e013@gmail.com>
 <20201125084710.01f0e6a6@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <7804cb54-6be0-5c3d-0adc-84799cf4a844@gmail.com>
Date:   Wed, 25 Nov 2020 10:37:20 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.5.0
MIME-Version: 1.0
In-Reply-To: <20201125084710.01f0e6a6@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/25/20 9:47 AM, Jakub Kicinski wrote:
> On Tue, 24 Nov 2020 21:37:18 -0700 David Ahern wrote:
>> On 11/24/20 6:58 PM, Jakub Kicinski wrote:
>>> But it's generally not a huge issue for applying the patch. I just like
>>> to see the build bot result, to make sure we're not adding W=1 C=1
>>> warnings.  
>>
>> ah, the build bot part is new. got it.
> 
> BTW I was wondering for the longest time how to structure things so
> that build bot can also build iproute2 in case we want to run tests
> attached to the series and the tests depend on iproute2 changes...
> 
> But let's cross that bridge when we get there.
> 

Why not cross it now? You handled the switch over to new a patchworks
with a build bot, so we can take advantage of automation.

Seems like the bot needs to detect 'net', 'net-next', 'bpf' and
'bpf-next' as they are all different trees for the kernel patches.
iproute2 is just another tree, so it should be able to put those in a
different bucket for automated builds - even if it means a 'set' crosses
trees.
