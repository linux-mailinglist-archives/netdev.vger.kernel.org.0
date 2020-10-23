Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E6C25297163
	for <lists+netdev@lfdr.de>; Fri, 23 Oct 2020 16:34:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1750608AbgJWOec (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Oct 2020 10:34:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58534 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S371564AbgJWOeb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Oct 2020 10:34:31 -0400
Received: from mail-il1-x141.google.com (mail-il1-x141.google.com [IPv6:2607:f8b0:4864:20::141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 49F2DC0613CE;
        Fri, 23 Oct 2020 07:34:30 -0700 (PDT)
Received: by mail-il1-x141.google.com with SMTP id k1so1545272ilc.10;
        Fri, 23 Oct 2020 07:34:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=JVb78+BehGmgUZgwLmi3c5ryDpGi5f+PpPO+wpRXrIw=;
        b=d4Y+ZKKx1MCcabmG42rGMENKdb3l4eWhv0xPpOPal0MRc3SvI8+vURN2NghjtsZwQy
         lFuhYfJpJ8TD59gA9/8OTGv1eFw5dxOHt7sCY/zUsFIB9Wv+NEW/xrzS5q/faj6CVqfv
         6nfpHxEY2BLOkShjzI5lMHeRgg4FWhh1801QNhT+GYdfVLdYDIWQIr2SRlB0+5Ns1uDO
         0g0i3DmyWp2htHT+mNlhV2mpQ/Ixro8haEPo5ALQxgpbFir+wWwlhLVY3F0d7QJvxfs9
         TyClwNgsZ2/F09jP3OjEXZ87iH0ZmgQrEWU7NxMBuHj0fxnBIzTyuwJO1t/YKC4DZIQH
         Bi7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=JVb78+BehGmgUZgwLmi3c5ryDpGi5f+PpPO+wpRXrIw=;
        b=ATCugKz6mb4wrKuNmxHWjwLk/+dnbxYKiWYg0QFxPqvMo2kRiEhcoQMnf9s32mJcNr
         7ocH0hIZ5+dY4VmqB+i4xriYXkxffmjYdjPD3YiBsRgjdBvfGZkmly7KSZ/3+fX1v5sk
         JCwtA8zblOj7EdGao5ELX6sm77jh1pMhg1D8zevgpxwKgEmdeaWaYCZDko8LxczI13Hy
         pYt535VUILiBx44pHQmHSKBM2aP672jCvu075NXAYOytmqGs/wfB8ugi/qk/QC9/zwQK
         dwTx7t4bXV8LN3+IBRcMIp+G29KeWI/tvtLXI1RjFzlf+0rwGm31FVV0UGrxvAAjRWUh
         Zj3g==
X-Gm-Message-State: AOAM533zs+8Ijl8x+05Zjy+fpKyT+HutDXexyr8NPblpttJVv5s2UdpA
        nBxkahUUDV49ulRJMpAmb/E=
X-Google-Smtp-Source: ABdhPJzKtdRy9dwQir5GvcFBczFCsh4AZi4Q1ZmagF+oFtUapSjEs5TFvor9SeNXwHFHdZ3UkzFI0A==
X-Received: by 2002:a05:6e02:d01:: with SMTP id g1mr1765875ilj.246.1603463669688;
        Fri, 23 Oct 2020 07:34:29 -0700 (PDT)
Received: from Davids-MacBook-Pro.local ([2601:282:803:7700:6052:3bc7:efe9:3aec])
        by smtp.googlemail.com with ESMTPSA id m13sm923395ioo.9.2020.10.23.07.34.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 23 Oct 2020 07:34:28 -0700 (PDT)
Subject: Re: [PATCH iproute2-next 3/5] lib: add libbpf support
To:     Hangbin Liu <haliu@redhat.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>
Cc:     Martin KaFai Lau <kafai@fb.com>, Song Liu <songliubraving@fb.com>,
        Yonghong Song <yhs@fb.com>, David Miller <davem@davemloft.net>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        Jiri Benc <jbenc@redhat.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vu?= =?UTF-8?Q?sen?= 
        <toke@redhat.com>
References: <20201023033855.3894509-1-haliu@redhat.com>
 <20201023033855.3894509-4-haliu@redhat.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <29c13bd0-d2f6-b914-775c-2d90270f86d4@gmail.com>
Date:   Fri, 23 Oct 2020 08:34:27 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.12.1
MIME-Version: 1.0
In-Reply-To: <20201023033855.3894509-4-haliu@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/22/20 9:38 PM, Hangbin Liu wrote:
> Note: ip/ipvrf.c is not convert to use libbpf as it only encodes a few
> instructions and load directly.

for completeness, libbpf should be able to load a program from a buffer
as well.
