Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B1C161E4D4C
	for <lists+netdev@lfdr.de>; Wed, 27 May 2020 20:48:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727040AbgE0Srx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 May 2020 14:47:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56624 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726701AbgE0Srg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 May 2020 14:47:36 -0400
Received: from mail-qt1-x843.google.com (mail-qt1-x843.google.com [IPv6:2607:f8b0:4864:20::843])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 62639C008630
        for <netdev@vger.kernel.org>; Wed, 27 May 2020 11:38:14 -0700 (PDT)
Received: by mail-qt1-x843.google.com with SMTP id h9so9848020qtj.7
        for <netdev@vger.kernel.org>; Wed, 27 May 2020 11:38:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=spzwh5mif+klJhxgYF7h2uAx0djjInTtblZCsc7uBPM=;
        b=dG5zcsXs1U+2b2w0IY+MbIowBnBy/gxtBl3MiLFiqxgE1DuyLkrziwO+cKvpg4y6fe
         SFa8MHejR+Lm1a0EXL1hlvhXTKY7XLpx6M3e97Lt7+mxpKhkgZRkapyY4B3LhyZRc1hR
         pM4TXHwsJrN8rSVxUUFph6KbqYdiK7fxgQbyP/pf/6d+ZkIezcRlew32ui96UicbpPAm
         fGjEMsS86WHog167GIH/ZbpqFUI2XfxtCWgKSMxFNvFPkjWKMJsGv7Qpx7rnIcvchq3B
         Krb7pLn9XDnpb3QdcSN0P4mcoTGN7vqtRywO74e3zUxBOWy+B5ivr9Dki5PeiTneUzmt
         s9xA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=spzwh5mif+klJhxgYF7h2uAx0djjInTtblZCsc7uBPM=;
        b=ZG5cTxIxvXw1vtkVYZG6iDsmkSP1liHGhK02He7gawBvr2XT7M1tTU36e/h1CgjuSr
         KXz4lwkALyp+Z5lQcl5SqkRVpfnao/uoWeTn30uiAq0YM8GfDCkSYCD1siEsReWrHPfS
         CW/U3cUdtfMvlPUefaeZHTCkVEfIkXM+AklWIBZMux9s2l90rCz7MEsS/DEHO1pMRrAe
         1FOu0WkxKE9Qds8ZCoXknnwhBJx6dsih3c2UhCFRCxh5Qa4WmWjt1d7XTi9yhJaY/wdu
         6E484w0RxEagrO/Z6x9hNykFWrhEDfHU/vPEo2xkV7I88Ro5qWUWJbrSXBO/kYPSbtWd
         o1qA==
X-Gm-Message-State: AOAM533oV/jzdZb8AcoT4MqgHjLI3kbYxnH3o0Lw/Rc9zTS2n6Jw43oT
        UQ+NwfxEE02K2bCeIfaUAWA=
X-Google-Smtp-Source: ABdhPJyXPHo5XZEgXMLIWKTILneXbnFFoDrWuJA9B+sqJy/4qpf6ICjL0m/GAyGOYiisDf+B2QV4kw==
X-Received: by 2002:ac8:1a6f:: with SMTP id q44mr5755009qtk.372.1590604693583;
        Wed, 27 May 2020 11:38:13 -0700 (PDT)
Received: from ?IPv6:2601:282:803:7700:2840:9137:669d:d1e7? ([2601:282:803:7700:2840:9137:669d:d1e7])
        by smtp.googlemail.com with ESMTPSA id l184sm2968136qke.115.2020.05.27.11.38.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 27 May 2020 11:38:12 -0700 (PDT)
Subject: Re: [PATCH bpf-next 1/5] bpf: Handle 8-byte values in DEVMAP and
 DEVMAP_HASH
To:     Jesper Dangaard Brouer <brouer@redhat.com>
Cc:     David Ahern <dsahern@kernel.org>, netdev@vger.kernel.org,
        davem@davemloft.net, kuba@kernel.org, toke@redhat.com,
        daniel@iogearbox.net, john.fastabend@gmail.com, ast@kernel.org,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com, andriin@fb.com
References: <20200527010905.48135-1-dsahern@kernel.org>
 <20200527010905.48135-2-dsahern@kernel.org> <20200527122612.579fbb25@carbon>
 <bb30af38-c74c-1c78-0b10-a00de39b434b@gmail.com>
 <20200527173021.10468d8b@carbon>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <9e80e899-7b34-5901-abb1-a6daefcce3c7@gmail.com>
Date:   Wed, 27 May 2020 12:38:10 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <20200527173021.10468d8b@carbon>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 5/27/20 9:30 AM, Jesper Dangaard Brouer wrote:
> On Wed, 27 May 2020 08:27:36 -0600
> David Ahern <dsahern@gmail.com> wrote:
> 
>> On 5/27/20 4:26 AM, Jesper Dangaard Brouer wrote:
>>> IMHO we really need to leverage BTF here, as I'm sure we need to do more
>>> extensions, and this size matching will get more and more unmaintainable.
>>>
>>> With BTF in place, dumping the map via bpftool, will also make the
>>> fields "self-documenting".  
>>
>> furthermore, the kernel is changing the value - an fd is passed in and
>> an id is returned. I do not see how any of this fits into BTF.
> 
> It can, as BTF actually support union's (I just tested that).
> 

You are trying to force an arbitrary kernel API with BTF, and it adds no
value over a static struct definition that grows as new capability is added.

DEVMAPs (and CPUMAP) are not like other maps - the fields in the entries
have meaning to *the kernel*. That means the kernel needs to know the
fields and what they represent - be it a device index, a program fd
converted to an id, a cpuid, or any future extension. If you add 'u32
foo' to this interface, you still need kernel code to understand 'foo'
maps to resource 'bar' via lookup function 'f'. You can not do this
dynamically. BTF does not make sense here.

Furthermore, if the kernel does not understand a field then it better
return an error code - EINVAL so the user knows expected functionality
is not supported by that kernel.

> 
> But a union would also work (also tested via BPF loading and BTF dumpinmg):
> 
>  struct dev_map_ext_val {
>         u32 ifindex;
>         union {
>                 int bpf_prog_fd_write;
>                 u32 bpf_prog_id_read;
>         };
>  };
> 

I prefer the union and without the verb; comments convey the same
meaning. The fd has no meaning beyond the process that created the entry
so it does not need to be kept around bloating the interface.

For v2, I moved the struct to uapi/linux/bpf.h and added comments.
