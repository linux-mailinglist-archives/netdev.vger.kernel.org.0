Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 913181BD765
	for <lists+netdev@lfdr.de>; Wed, 29 Apr 2020 10:37:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726661AbgD2IhH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Apr 2020 04:37:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34378 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726436AbgD2IhG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Apr 2020 04:37:06 -0400
Received: from mail-wm1-x342.google.com (mail-wm1-x342.google.com [IPv6:2a00:1450:4864:20::342])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 40DFFC03C1AD
        for <netdev@vger.kernel.org>; Wed, 29 Apr 2020 01:37:06 -0700 (PDT)
Received: by mail-wm1-x342.google.com with SMTP id 188so1038410wmc.2
        for <netdev@vger.kernel.org>; Wed, 29 Apr 2020 01:37:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isovalent-com.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=p18rSOYa9QyJHcxF1hQQmt4mlrncQfWvskudtN2fyp8=;
        b=YNcreLIWbfHVA3Seq08Xeb65o5abdZn9Au+P0SHW6A9c/EzfI5PG41iDNfwUDH3Nyk
         5BndTOfV6UW0hx4lgEvucAXH06TlfVnoTKQ9sfqksyGF3ISYJuJkt9tRTs9lfYj8wieo
         PWDHlV8/XNtgxbPc0MVYKPbT1o5kqUh+wN1XPhfEMwzaxGUfy1SU+UykYkXsNEQvB0I2
         O3R8p4o8qEe76/deDyQEl7g1ZZ5S2h3E7RS/mr9oyxeZhh9dGlZSC5cegM2jAq8pfi7D
         doZUvdZjGyXzBMsK9DKgeN89fK+lE9RzHKHNuV3c0zhA48oFbi1xo5EJgiaoF/LpYX1A
         /+7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=p18rSOYa9QyJHcxF1hQQmt4mlrncQfWvskudtN2fyp8=;
        b=dFXYdzR7UHwdtgdt515SND64xv9GmGdNTrxNRckyE2r4Wk9bFMgDoW3lLpr8ijfx+7
         NPaN+2go3ZOwJ97nduWPN+MD607GsanfV68nOLvzhMWK/P6o8o4pmupylaU4Wp6G5GfG
         1icSAxBOd5hHPi0QXBMgRpZPObJxodJH5WIzb3zt6FIrgKTt2SWdLvPIUITkqpk16ovk
         RX0QJcHwhq8037XMavrkE2l0J2fc/dIbSPqzXg7EfNoa6utTmR7UtVPD7f/QsaCCOWSf
         8whQO97TcdnlbNNxUs7w2tJh71dtsnsmmcJ9bBLY8l8g/uMEvfOP4nqs+Y5E7XAG1Cdr
         E/GA==
X-Gm-Message-State: AGi0PuYnY5rI4XqEuMkZjVabtlGJZeumUHpi2IdZ3NDo/vfSVdCm/Tsl
        D1gBGFVpaMw0Wpu3IcXhT3zSVA==
X-Google-Smtp-Source: APiQypIFDmwxfdJn9ENU5B9x6Ich6QUJrdwx5gR3EIeK2B5dZTYxKvj3KNjfz/4UBedO1r8/YYYAXA==
X-Received: by 2002:a05:600c:2214:: with SMTP id z20mr2098557wml.189.1588149424905;
        Wed, 29 Apr 2020 01:37:04 -0700 (PDT)
Received: from [192.168.1.10] ([194.53.185.38])
        by smtp.gmail.com with ESMTPSA id i6sm31372580wrc.82.2020.04.29.01.37.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 29 Apr 2020 01:37:04 -0700 (PDT)
Subject: Re: [PATCH bpf-next v1 16/19] tools/bpftool: add bpf_iter support for
 bptool
To:     Yonghong Song <yhs@fb.com>, Andrii Nakryiko <andriin@fb.com>,
        bpf@vger.kernel.org, Martin KaFai Lau <kafai@fb.com>,
        netdev@vger.kernel.org
Cc:     Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>, kernel-team@fb.com
References: <20200427201235.2994549-1-yhs@fb.com>
 <20200427201253.2996156-1-yhs@fb.com>
 <05d9c82d-8cba-db77-02af-265e4d200946@isovalent.com>
 <82034392-5f65-fd84-8cbd-d2aa85f01ee3@fb.com>
From:   Quentin Monnet <quentin@isovalent.com>
Message-ID: <4ffc7653-311c-a2a1-2ba6-eda765f665e7@isovalent.com>
Date:   Wed, 29 Apr 2020 09:37:03 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <82034392-5f65-fd84-8cbd-d2aa85f01ee3@fb.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

2020-04-28 10:35 UTC-0700 ~ Yonghong Song <yhs@fb.com>
> 
> 
> On 4/28/20 2:27 AM, Quentin Monnet wrote:

[...]

>>> +    err = bpf_link__pin(link, path);
>>
>> Try to mount bpffs before that if "-n" is not passed? You could even
>> call do_pin_any() from common.c by passing bpf_link__fd().
> 
> You probably means do_pin_fd()? That is a good suggestion, will use it
> in the next revision.

Right, passing bpf_link__fd() to do_pin_any() wouldn't work, it does not
take the arguments expected by the "get_fd()" callback. My bad. So yeah,
just do_pin_fd() in that case :)

[...]

>>
>> Have you considered simply adapting the more traditional workflow
>> "bpftool prog load && bpftool prog attach" so that it supports iterators
>> instead of adding a new command? It would:
> 
> This is a good question, I should have clarified better in the commit
> message.
>   - prog load && prog attach won't work.
>     the create_iter is a three stage process:
>       1. prog load
>       2. create and attach to a link
>       3. pin link
>     In the current implementation, the link merely just has the program.
>     But in the future, the link will have other parameters like map_id,
>     tgid/gid, or cgroup_id, or others.
> 
>     We could say to do:
>       1. bpftool prog load <pin_path>
>       2. bpftool iter pin prog file
>          <maybe more parameters in the future>
> 
>     But this requires to pin the program itself in the bpffs, which
>     mostly unneeded for file iterator creator.
> 
>     So this command `bpftool iter pin ...` is created for ease of use.
> 
>>
>> - Avoid adding yet another bpftool command with a single subcommand
> 
> So far, yes, in the future we may have more. In my RFC patcch, I have
> `bpftool iter show ...` for introspection, this is to show all
> registered targets and all file iterators prog_id's.
> 
> This patch does not have it and I left it for the future work.
> I am considering to use bpf iterator to do introspection here...

Ok, so with the useless bpffs pinning step and the perspectives for
other subcommands in the future, I agree it makes sense to have "iter"
as a new command. And as you say, handling of the link may grow so it's
probably not a bad thing to have it aside from the "prog" command.
Thanks for the clarification (maybe add some of it to the commit log
indeed?).

> 
>>
>> - Enable to reuse the code from prog load, in particular for map reuse
>> (I'm not sure how relevant maps are for iterators, but I wouldn't be
>> surprised if someone finds a use case at some point?)
> 
> Yes, we do plan to have map element iterators. We can also have
> bpf_prog or other iterators. Yes, map element iterator use
> implementation should be `bpftool map` code base since it is
> a use of bpf_iter infrastructure.

My point was more about loading programs that reuse pre-existing, as in
"bpftool prog load foo /sys/fs/bpf/foo map name foomap id 1337". It
seems likely that similar syntax will be needed for loading/pinning
iterators as well eventually, but I suppose we can try to refactor the
code from prog.c to reuse it when the time comes.

> 
>>
>> - Avoid users naively trying to run "bpftool prog load && bpftool prog
>> attach <prog> iter" and not understanding why it fails
> 
> `bpftool prog attach <prog> [map_id]` mostly used to attach a program to
> a map, right? In this case, it won't apply, right?

Right, I'm just not convinced that all users are aware of that :) But
fair enough.

> 
> BTW, Thanks for reviewing and catching my mistakes!
> 

Thanks for your reply and clarification, that's appreciated too!
Quentin
