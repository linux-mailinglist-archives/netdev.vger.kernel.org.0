Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 760D72D8D5
	for <lists+netdev@lfdr.de>; Wed, 29 May 2019 11:18:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726626AbfE2JSF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 May 2019 05:18:05 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:50640 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726018AbfE2JSF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 May 2019 05:18:05 -0400
Received: by mail-wm1-f67.google.com with SMTP id f204so1102010wme.0
        for <netdev@vger.kernel.org>; Wed, 29 May 2019 02:18:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=PA7o+E5TanGr16h7Oy845fcFh8G+pAiv4rWZfkX/jjI=;
        b=BQTKFzkBVyyJw/5nn247Cer8dg7TyVU4wv8QAOoWRl6JTMAQiw4/zk8X4vUIF1K6jx
         +D3zHTTJGooSSEbfuVfNF0dS0ngrIO0j4I9Pi+O2U5OaTRhGoQlbNlUcab9smZ6t5+13
         8vNGft3DwvSM5GFWYLrT2a6i1Nk3ATXcEpu2sCce+v/M9QtHYMTs/HFqu4K5uamuDaHq
         cxRe79oMnpsUvNedfGL8IutjCEEX/lv2gTJkbJz7EYWhh253dkGn4fqBnI59KuAAPAn9
         SGy5qoKkjOURTS6WssbVC/74QFhP2T4nvRTmse2nVr465749SeP4T/XxMopmtV50r9up
         lrUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=PA7o+E5TanGr16h7Oy845fcFh8G+pAiv4rWZfkX/jjI=;
        b=NPbFmxNrJxVj/LddBuHTyKYr2AvpZpcx1AMQFOuw02x4KqQaKovMGSii/FlJ+SqKV8
         TLXr8t7wUJoUGfjrINVw14IvnNc7NugNyn1z8chIRffNs/Uko2c/t0bP7yxJ0lKrBXFf
         XxzaC7IlhT83EVwMyFnVgg2J60cn+NRA66SX5vFxPVoC6N6JYHGIOtjGUCmzSDJq7/JR
         JhimaL29Sqi2fIBkREHDTLpp4OP7dpiPd7wGffOPioT6lCLGMfsNah9dY+7NCjXoJnOT
         UeJTfFvMz37flp3bem4qBRXE6EiFKempkYwFnWP0fgEj2gMT3VVlRBfXqhISIoBPkTzq
         rUeQ==
X-Gm-Message-State: APjAAAXpdh6K4eJSTVA7rfh3URF7dE/k9PQ7638P1mvgMMz76oo/20DC
        RIulk5XcPIBHOBardZKHWxV39w==
X-Google-Smtp-Source: APXvYqx3K5WS7jTcKEBdb+W1wgXo5qW2Emzn407GM/gllJHuwwpXz0Vlm0xarau4UMZnbVwPBod/aA==
X-Received: by 2002:a1c:4054:: with SMTP id n81mr4716322wma.78.1559121482805;
        Wed, 29 May 2019 02:18:02 -0700 (PDT)
Received: from [192.168.1.2] ([194.53.187.60])
        by smtp.gmail.com with ESMTPSA id y2sm4553438wra.58.2019.05.29.02.18.01
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 29 May 2019 02:18:01 -0700 (PDT)
Subject: Re: [PATCH bpf-next v3 2/3] libbpf: add bpf_object__load_xattr() API
 function to pass log_level
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Daniel Borkmann <daniel@iogearbox.net>, bpf <bpf@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        oss-drivers@netronome.com, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>
References: <20190524103648.15669-1-quentin.monnet@netronome.com>
 <20190524103648.15669-3-quentin.monnet@netronome.com>
 <CAADnVQJ_V1obLb1ZhkKWzuPhrxGBjJOuSbof6VrA6vxT+W463A@mail.gmail.com>
From:   Quentin Monnet <quentin.monnet@netronome.com>
Message-ID: <d6c99b5c-8a88-f604-4ae6-76ccfb4aee49@netronome.com>
Date:   Wed, 29 May 2019 10:18:01 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <CAADnVQJ_V1obLb1ZhkKWzuPhrxGBjJOuSbof6VrA6vxT+W463A@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

2019-05-28 17:35 UTC-0700 ~ Alexei Starovoitov
<alexei.starovoitov@gmail.com>
> On Fri, May 24, 2019 at 3:36 AM Quentin Monnet
> <quentin.monnet@netronome.com> wrote:
>>
>> libbpf was recently made aware of the log_level attribute for programs,
>> used to specify the level of information expected to be dumped by the
>> verifier. Function bpf_prog_load_xattr() got support for this log_level
>> parameter.
>>
>> But some applications using libbpf rely on another function to load
>> programs, bpf_object__load(), which does accept any parameter for log
>> level. Create an API function based on bpf_object__load(), but accepting
>> an "attr" object as a parameter. Then add a log_level field to that
>> object, so that applications calling the new bpf_object__load_xattr()
>> can pick the desired log level.
>>
>> v3:
>> - Rewrite commit log.
>>
>> v2:
>> - We are in a new cycle, bump libbpf extraversion number.
>>
>> Signed-off-by: Quentin Monnet <quentin.monnet@netronome.com>
>> Reviewed-by: Jakub Kicinski <jakub.kicinski@netronome.com>
>> ---
>>  tools/lib/bpf/Makefile   |  2 +-
>>  tools/lib/bpf/libbpf.c   | 20 +++++++++++++++++---
>>  tools/lib/bpf/libbpf.h   |  6 ++++++
>>  tools/lib/bpf/libbpf.map |  5 +++++
>>  4 files changed, 29 insertions(+), 4 deletions(-)
> 
> This commit broke ./test_progs -s
> prog_tests/bpf_verif_scale.c no longer passes log_level.
> Could you please take a look?
> 

Indeed, I forgot that bpf_load_prog_xattr() would eventually call
bpf_object__load_progs() as well, where the log_level is now overwritten.

Fix incoming, sorry about that.

Quentin
