Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 110982989EF
	for <lists+netdev@lfdr.de>; Mon, 26 Oct 2020 11:02:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1768867AbgJZKCO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Oct 2020 06:02:14 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:60368 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1768855AbgJZKBV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Oct 2020 06:01:21 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1603706479;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=g9M52w860PyPvVBSu7mKSxeRwS8lIdF5tDbDT2wR+cs=;
        b=WLNLorvmfuoAFhDWKJPfeTKYq937Cn1NIYtN+xYL26JW7EtnAI/QKmAnrtAhGoWjM+/jbq
        vkmIH8NNomqNaunaM+fczRuTxa+BtZ1Qcj5xk0SHwcosTlbhuUl3WFrmKvvLS6ynSmfxNE
        4HB8MLn64n8b42ru+3beuELtrZYtYf0=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-484-ZmaJJJLiM9mu4PBwDV_JnQ-1; Mon, 26 Oct 2020 06:01:18 -0400
X-MC-Unique: ZmaJJJLiM9mu4PBwDV_JnQ-1
Received: by mail-wr1-f71.google.com with SMTP id p6so8071467wrm.23
        for <netdev@vger.kernel.org>; Mon, 26 Oct 2020 03:01:17 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=g9M52w860PyPvVBSu7mKSxeRwS8lIdF5tDbDT2wR+cs=;
        b=sEDgvOBHiLLf4353QJkEolJ7yHPZ2vSq6DO9GhLNQkLemwPt3z0WiVWKnVK4kLQvVF
         Xbec1/NHGYLMM/JdrkyOASzEUjsGuOvcHACF4Flin5vgaCc8y5QzNsnD+jADhj4kZrqH
         wNbjGRY+975XZylV0kj4CNjlG8WqoHKIdvWEyYxiB1uEeu8coGj06woCYqT0pvmmKeUK
         8vBDA7hXVLeVr4pcpdBl6JHqSJlVt3MAxeJM8YHBMEC51GHNJa821shPRdhQFkertGLV
         UDyyP2D9sk23DkiCoOcH7DNTTiFarDt7wzaNoZLbxwu9llqRGsa65abB1rhZEH8UcoJQ
         AuYQ==
X-Gm-Message-State: AOAM531Ogg+65LADWi7Hy/1D8witCbVZ2nd1G8qWeuO9JIqq3eSZtcFA
        r68qVIqIVhT0Q172OPRskaZt/7vVkLy8R1P98piZywP3/t+zVnHEedZ4Jn3UKufAv+yre64/sF2
        nxPcQak2pxYMj4oW3
X-Received: by 2002:a1c:7214:: with SMTP id n20mr15399261wmc.93.1603706476059;
        Mon, 26 Oct 2020 03:01:16 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzqhquQiOmnt0ldElrGf3ZubNN/KA9VMe3Bjf5dcZx476oa5Meo2vVFpvD5OnEUV2kNEXETSQ==
X-Received: by 2002:a1c:7214:: with SMTP id n20mr15399246wmc.93.1603706475872;
        Mon, 26 Oct 2020 03:01:15 -0700 (PDT)
Received: from steredhat (host-79-17-248-215.retail.telecomitalia.it. [79.17.248.215])
        by smtp.gmail.com with ESMTPSA id t7sm21294559wrx.42.2020.10.26.03.01.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Oct 2020 03:01:15 -0700 (PDT)
Date:   Mon, 26 Oct 2020 11:01:12 +0100
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     David Laight <David.Laight@aculab.com>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Colin King <colin.king@canonical.com>,
        "David S . Miller" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] vsock: ratelimit unknown ioctl error message
Message-ID: <20201026100112.qaorff6c6vucakyg@steredhat>
References: <20201023122113.35517-1-colin.king@canonical.com>
 <20201023140947.kurglnklaqteovkp@steredhat>
 <e535c07df407444880d8b678bc215d9f@AcuMS.aculab.com>
 <20201026084300.5ag24vck3zeb4mcz@steredhat>
 <d893e3251f804cffa797b6eb814944fd@AcuMS.aculab.com>
 <20201026093917.5zgginii65pq6ezd@steredhat>
 <3e34e4121f794355891fd7577c9dfbc0@AcuMS.aculab.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <3e34e4121f794355891fd7577c9dfbc0@AcuMS.aculab.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Oct 26, 2020 at 09:46:17AM +0000, David Laight wrote:
>From: Stefano Garzarella
>> Sent: 26 October 2020 09:39
>>
>> On Mon, Oct 26, 2020 at 09:13:23AM +0000, David Laight wrote:
>> >From: Stefano Garzarella
>> >> Sent: 26 October 2020 08:43
>> >...
>> >> >Isn't the canonical error for unknown ioctl codes -ENOTTY?
>> >> >
>> >>
>> >> Oh, thanks for pointing that out!
>> >>
>> >> I had not paid attention to the error returned, but looking at it I
>> >> noticed that perhaps the most appropriate would be -ENOIOCTLCMD.
>> >> In the ioctl syscall we return -ENOTTY, if the callback returns
>> >> -ENOIOCTLCMD.
>> >>
>> >> What do you think?
>> >
>> >It is 729 v 443 in favour of ENOTTY (based on grep).
>>
>> Under net/ it is 6 vs 83 in favour of ENOIOCTLCMD.
>>
>> >
>> >No idea where ENOIOCTLCMD comes from, but ENOTTY probably
>> >goes back to the early 1970s.
>>
>> Me too.
>>
>> >
>> >The fact that the ioctl wrapper converts the value is a good
>> >hint that userspace expects ENOTTY.
>>
>> Agree on that, but since we are not interfacing directly with userspace,
>> I think it is better to return the more specific error (ENOIOCTLCMD).
>
>I bet Linux thought it could use a different error code then
>found that 'unknown ioctl' was spelt ENOTTY.

It could be :-)

Anyway, as you pointed out, I think we should change the -EINVAL with 
-ENOTTY or -ENOIOCTLCMD.

@Jakub what do you suggest?

Thanks,
Stefano

