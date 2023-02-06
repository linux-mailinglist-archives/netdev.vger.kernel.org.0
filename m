Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AAF2868C786
	for <lists+netdev@lfdr.de>; Mon,  6 Feb 2023 21:20:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230400AbjBFUUM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Feb 2023 15:20:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55856 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230449AbjBFUTu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Feb 2023 15:19:50 -0500
Received: from mail-il1-x131.google.com (mail-il1-x131.google.com [IPv6:2607:f8b0:4864:20::131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D7E4D2BED9
        for <netdev@vger.kernel.org>; Mon,  6 Feb 2023 12:19:26 -0800 (PST)
Received: by mail-il1-x131.google.com with SMTP id l7so5208346ilf.0
        for <netdev@vger.kernel.org>; Mon, 06 Feb 2023 12:19:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=GyO4H+NPThpmNrszKY3ZjzP0Rd9jL1+w73Xf4g0ELv4=;
        b=T6MduvHKpSGd3A6R6gkuMYuAib6DsUH4pSK+ARl89lrtmIEYGTXAdknNDIdfyjjUUX
         WfKKomDmat6TsUzTncmu9eyNTkbwLgW1zjCb3VTM5as0xaO2m3u6ARSVQcQr3s67uqUQ
         PsNDIfnv150h/tPvmmy/k50G1YhbAOumi5MGdetKCMgsiDqbdbRW/bat8HjyeLmK5FZ5
         +9Umd/2oS3SSdiYr8xLChtX9HNUhnhcLOnwcWUFlWhKPeG/bfDR7zn79DnzXIcmYDAM/
         JhVu6wx7n39Wf8pSgKHTIDaHbgbPVpLMcItwGq0UO8huiKbcAWoSj6Qu65Gped1NM279
         ALfw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=GyO4H+NPThpmNrszKY3ZjzP0Rd9jL1+w73Xf4g0ELv4=;
        b=t4+6XYvvMI30V1iyNhqfe/xEe0z6c19B8JigJN3YX3TlOYrbxZfXFMvf/DDBgA+ekR
         449Bly+mecBc4XSfd4U9s4Qu5ptmthOGKX0h/a+T6qtcYuAng10j93UNdl9y55ok5Rd1
         7Gxxgo+eoX8VGi9CpexQEAwEvQWejKOMunQJneOuFBfwm0riNtNIBVMOOjhZaMpVt5gr
         I63FSauaAAKmn0ajRGXfIBry/6NgBammHDrkagBLV2YHd7FHh+AqZaDJAJo1Nsx+HADU
         w166pPaHtD81RgQF2B9EpmXya9pCiCUl5hfkGl0e7T9/IpLd+SaK4ict8efOj9BS5XN1
         Y1Ow==
X-Gm-Message-State: AO0yUKXwsGjDTqsFo76G/3BO4ScVxeiT7szuVPUUCB3g3fYnquGGL4zS
        4GzU+nT7AeeWQfSOI3n2PMtonA==
X-Google-Smtp-Source: AK7set9M1G/XPzvlguhRhWPaA4Kqfaupla5+Y3OZh6sjez2Du5/3W4GhEGlygE28FmaEu7mZZd1tHg==
X-Received: by 2002:a92:d386:0:b0:313:bb52:a976 with SMTP id o6-20020a92d386000000b00313bb52a976mr361376ilo.1.1675714765838;
        Mon, 06 Feb 2023 12:19:25 -0800 (PST)
Received: from [192.168.1.94] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id o6-20020a02b806000000b003af2cdde559sm3650739jam.35.2023.02.06.12.19.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 06 Feb 2023 12:19:25 -0800 (PST)
Message-ID: <ad133b58-9bc1-4da9-73a2-957512e3e162@kernel.dk>
Date:   Mon, 6 Feb 2023 13:19:24 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [PATCH v2] 9p/client: don't assume signal_pending() clears on
 recalc_sigpending()
Content-Language: en-US
To:     Dominique Martinet <asmadeus@codewreck.org>,
        Christian Schoenebeck <linux_oss@crudebyte.com>,
        Eric Van Hensbergen <ericvh@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>, Jakub Kicinski <kuba@kernel.org>,
        Pengfei Xu <pengfei.xu@intel.com>,
        v9fs-developer@lists.sourceforge.net
References: <9422b998-5bab-85cc-5416-3bb5cf6dd853@kernel.dk>
 <Y99+yzngN/8tJKUq@codewreck.org>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <Y99+yzngN/8tJKUq@codewreck.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2/5/23 3:02?AM, Dominique Martinet wrote:
> meta-comment: 9p is usually handled separately from netdev, I just saw
> this by chance when Simon replied to v1 -- please cc
> v9fs-developer@lists.sourceforge.net for v3 if there is one
> (well, it's a bit of a weird tree because patches are sometimes taken
> through -net...)
> 
> Also added Christian (virtio 9p) and Eric (second maintainer) to Tos for
> attention.

Thanks! I can send out a v3, but let's get the discussion sorted first.
Only change I want to make is the comment format, which apparently is
different in net/ that most other spots in the kernel.

> Jens Axboe wrote on Fri, Feb 03, 2023 at 09:04:28AM -0700:
>> signal_pending() really means that an exit to userspace is required to
>> clear the condition, as it could be either an actual signal, or it could
>> be TWA_SIGNAL based task_work that needs processing. The 9p client
>> does a recalc_sigpending() to take care of the former, but that still
>> leaves TWA_SIGNAL task_work. The result is that if we do have TWA_SIGNAL
>> task_work pending, then we'll sit in a tight loop spinning as
>> signal_pending() remains true even after recalc_sigpending().
>>
>> Move the signal_pending() logic into a helper that deals with both, and
>> return -ERESTARTSYS if the reason for signal_pendding() being true is
>> that we have task_work to process.
>> Link: https://lore.kernel.org/lkml/Y9TgUupO5C39V%2FDW@xpf.sh.intel.com/
>> Reported-and-tested-by: Pengfei Xu <pengfei.xu@intel.com>
>> Signed-off-by: Jens Axboe <axboe@kernel.dk>
>> ---
>> v2: don't rely on task_work_run(), rather just punt with -ERESTARTYS at
>>     that point. For one, we don't want to export task_work_run(), it's
>>     in-kernel only. And secondly, we need to ensure we have a sane state
>>     before running task_work. The latter did look fine before, but this
>>     should be saner. Tested this also fixes the report as well for me.
> 
> Hmm, just bailing out here is a can of worm -- when we get the reply
> from server depending on the transport hell might break loose (zc
> requests in particular on virtio will probably just access the memory
> anyway... fd will consider it got a bogus reply and close the connection
> which is a lesser evil but still not appropriatey)
> 
> We really need to get rid of that retry loop in the first place, and req
> refcounting I added a couple of years ago was a first step towards async
> flush which will help with that, but the async flush code had a bug I
> never found time to work out so it never made it and we need an
> immediate fix.
> 
> ... Just looking at code out loud, sorry for rambling: actually that
> signal handling in virtio is already out of p9_virtio_zc_request() so
> the pages are already unpinned by the time we do that flush, and I guess
> it's not much worse -- refcounting will make it "mostly work" exactly as
> it does now, as in the pages won't be freed until we actually get the
> reply, so the pages can get moved underneath virtio which is bad but is
> the same as right now, and I guess it's a net improvement?
> 
> 
> I agree with your assessment that we can't use task_work_run(), I assume
> it's also quite bad to just clear the flag?
> I'm not familiar with these task at all, in which case do they happen?
> Would you be able to share an easy reproducer so that I/someone can try
> on various transports?

You can't just clear the flag without also running the task_work. Hence
it either needs to be done right there, or leave it pending and let the
exit to userspace take care of it.

> If it's "rare enough" I'd say sacrificing the connection might make more
> sense than a busy loop, but if it's becoming common I think we'll need
> to spend some more time thinking about it...
> It might be less effort to dig out my async flush commits if this become
> too complicated, but I wish I could say I have time for it...

It can be a number of different things - eg fput() will do it. The
particular case that I came across was io_uring, which will use
TWA_SIGNAL based task_work for retry operations (and other things). If
you use io_uring, and depending on how you setup the ring, it can be
quite common or will never happen. Dropping the connection task_work
being pending is not a viable solution, I'm afraid.

-- 
Jens Axboe

