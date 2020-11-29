Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 263A72C7B04
	for <lists+netdev@lfdr.de>; Sun, 29 Nov 2020 20:47:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728581AbgK2Tmc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 29 Nov 2020 14:42:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44048 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726961AbgK2Tmb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 29 Nov 2020 14:42:31 -0500
Received: from mail-io1-xd41.google.com (mail-io1-xd41.google.com [IPv6:2607:f8b0:4864:20::d41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6DF1BC0613CF;
        Sun, 29 Nov 2020 11:41:51 -0800 (PST)
Received: by mail-io1-xd41.google.com with SMTP id i9so9696710ioo.2;
        Sun, 29 Nov 2020 11:41:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=rbvmwJAcYOcJQozd16DmJLcdFk8Wg6pGtEFA+DtjDUQ=;
        b=ZIOIDSmz9UbcLeW+Go/F71ACOY52CF146/AUGz4spE8aVhhp+f1IwThycHEpVCTxn5
         U3eOUj8bfJ+mxpr0emyHVLj+3Dzw2r8WmhuY73nmgQcn/Bl0M//FKk/QNTp+KMM94cIX
         g2ZO0XYIGP5oL/6aN6hw+CN0SwimL+4eQ1sNALm3uHdGZdSOlbZO/BvqJch1lrTMrZNd
         pVXbefhUrKusDl+/wL5kFe7p2MFEk4maZdxD2nV94R25cyeeOEeR6tmX9Yo698jx8YsS
         YSfaJeKTmjP+egZK81bx2bUMe/igByIMGGVQSbA4p/bAqdA3MG0qo+5DP/td+xRy4RTt
         a+Fw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=rbvmwJAcYOcJQozd16DmJLcdFk8Wg6pGtEFA+DtjDUQ=;
        b=SDeqa4ZqawjeX8X/wVZ4VF8mbMYA4ywQUAabGq6UZljUm7LaFjFk6NzRpV0XMKMh/r
         4MkcxwSlxW7v1G3MBrGrjPxLC+cB9YyE4DeaGjG2sDarxlDDYRMJYRzCIqzLPgc3DqZk
         40VTi9ILJAdu8Gb2/djh9t+8401NDpvYMCbwpLoo5YLzDv4JaLbfZ6Z7KNXMFtlDB2IG
         xYYDonO7hJZ7IKkHcyBewxOv+XevmFm/pcNjzCYjUaGL1zAjBnrmKdIbfusfzmJ6FDb9
         9CkICnhcydKN+K+pgxpwCzHxEJY9FloHVYdJ8TYrxnTdBGFs2Fb0A4j4GcUvag8Nyqiv
         DWXA==
X-Gm-Message-State: AOAM530CtG4gkL7OlmiCASF+sVii5Zx7HykFtP71x0bHgpq/6C7/mDSN
        Yl7AClrOPT8PdXNXMV+OV+0=
X-Google-Smtp-Source: ABdhPJyU3U+re4nVcj7ys4Wo+sNBAdXk0KTl3eG8u/a0qcGnsQHkJrwoBbk7TzslL4WJMt4brZI9aQ==
X-Received: by 2002:a05:6602:1492:: with SMTP id a18mr13064267iow.124.1606678910909;
        Sun, 29 Nov 2020 11:41:50 -0800 (PST)
Received: from Davids-MacBook-Pro.local ([2601:282:800:dc80:4896:3e20:e1a7:6425])
        by smtp.googlemail.com with ESMTPSA id e1sm7171057iod.17.2020.11.29.11.41.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 29 Nov 2020 11:41:50 -0800 (PST)
Subject: Re: [PATCH iproute2-next 0/5] iproute2: add libbpf support
To:     Stephen Hemminger <stephen@networkplumber.org>,
        Hangbin Liu <haliu@redhat.com>
Cc:     Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        David Miller <davem@davemloft.net>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        Jiri Benc <jbenc@redhat.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vu?= =?UTF-8?Q?sen?= 
        <toke@redhat.com>
References: <20201023033855.3894509-1-haliu@redhat.com>
 <20201128221635.63fdcf69@hermes.local>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <08071e1e-497f-f53e-916a-8b519fdd1e0f@gmail.com>
Date:   Sun, 29 Nov 2020 12:41:49 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.16; rv:78.0)
 Gecko/20100101 Thunderbird/78.5.0
MIME-Version: 1.0
In-Reply-To: <20201128221635.63fdcf69@hermes.local>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/28/20 11:16 PM, Stephen Hemminger wrote:
> Luca wants to put this in Debian 11 (good idea), but that means:
> 
> 1. It has to work with 5.10 release and kernel.
> 2. Someone has to test it.
> 3. The 5.10 is a LTS kernel release which means BPF developers have
>    to agree to supporting LTS releases.
> 
> If someone steps up to doing this then I would be happy to merge it now
> for 5.10. Otherwise it won't show up until 5.11.

It would be good for Bullseye to have the option to use libbpf with
iproute2. If Debian uses the 5.10 kernel then it should use the 5.10
version of iproute2 and 5.10 version libbpf. All the components align
with consistent versioning.

I have some use cases I can move from bpftool loading to iproute2 as
additional testing to what Hangbin has already done. If that goes well,
I can re-send the patch series against iproute2-main branch by next weekend.

It would be good for others (Jesper, Toke, Jiri) to run their own
testing as well.
