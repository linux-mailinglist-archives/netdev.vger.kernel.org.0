Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 24CBA29953B
	for <lists+netdev@lfdr.de>; Mon, 26 Oct 2020 19:25:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1784607AbgJZSZK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Oct 2020 14:25:10 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:47396 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1789673AbgJZSZI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Oct 2020 14:25:08 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1603736707;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=PTOPOTQ28R0upPb6yV12OFPjWFChCPsyJnX2G5n47O4=;
        b=EyaDTQSndbcfkfb8XmBQEsOgxK0w0a2IMoKh16Flg/GPWKZpCOK7qMza+pGSdV+xhRsa4y
        cD2/INdZo0Bt49rh8NhwiQecSVK+fiHndhHqoOG9vfbYNb+5wNwUvxg5wHgtsrxESdgR/4
        F98D4Mu9abrVmmZBUyValFKrDLbP/OA=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-476-7D1YZHykNLCvTiONd5EMTw-1; Mon, 26 Oct 2020 14:25:05 -0400
X-MC-Unique: 7D1YZHykNLCvTiONd5EMTw-1
Received: by mail-wr1-f72.google.com with SMTP id i1so9063309wrb.18
        for <netdev@vger.kernel.org>; Mon, 26 Oct 2020 11:25:04 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=PTOPOTQ28R0upPb6yV12OFPjWFChCPsyJnX2G5n47O4=;
        b=NKVP/vNeO914IKFHQ9jOVVn+uAqA3vDI0yOhanOpY9XbyS6oLUL5MpiIiJhz5MU419
         iLXuuLDN7Q1fvwjWTf4N4Hqssi6udfnCdx/cMs32mw02Fio9XM8fG0OB7sHHPRDquTcT
         EdL8XkOsvE+hN7wFAOkX1rg1W3rbm1SrekaJuCLGV17C3y+0x+vyn2IDoHl61yr5Ifyf
         sI6+k/wC2/gF0oQWEaNw7Q2GmNSCAvitxqmzAHdiknU0ElUaVzNnHeDKN+Lk3ummb3Zc
         1gqetYcEQqKw2hLPJyDo7Pen1hT3w8ZhJ5vsT60mVreUs+TljjTe39mqrKqsg+R3TYFp
         zesg==
X-Gm-Message-State: AOAM532/NW4joogUtbB5bnyKZsNDa5NX57Vmjo0ygIj7JM3IrDECdbS2
        eLZrwyHIYo7/OmQ8Mb5lBSXAejw9+noGpP/dRp2xvDrcU/LazlHd7gh2Z05UR2K9ggD7jtZsj23
        hyT0WSe2T7drz7KUG
X-Received: by 2002:a1c:cc07:: with SMTP id h7mr18215188wmb.55.1603736700657;
        Mon, 26 Oct 2020 11:25:00 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwkli58w2YGvlcCf87uJq2IZGE8a3ti/dpYthSyydRCGsmb5nUsUwgCQtZdQpS8BkX/Q79nMQ==
X-Received: by 2002:a1c:cc07:: with SMTP id h7mr18215171wmb.55.1603736700414;
        Mon, 26 Oct 2020 11:25:00 -0700 (PDT)
Received: from steredhat (host-79-17-248-215.retail.telecomitalia.it. [79.17.248.215])
        by smtp.gmail.com with ESMTPSA id v6sm23367090wrp.69.2020.10.26.11.24.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Oct 2020 11:24:59 -0700 (PDT)
Date:   Mon, 26 Oct 2020 19:24:57 +0100
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     Colin King <colin.king@canonical.com>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     David Laight <David.Laight@aculab.com>,
        "David S . Miller" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] vsock: ratelimit unknown ioctl error message
Message-ID: <20201026182457.fy6uxrjgs5bpzmnr@steredhat>
References: <20201023122113.35517-1-colin.king@canonical.com>
 <20201023140947.kurglnklaqteovkp@steredhat>
 <e535c07df407444880d8b678bc215d9f@AcuMS.aculab.com>
 <20201026084300.5ag24vck3zeb4mcz@steredhat>
 <d893e3251f804cffa797b6eb814944fd@AcuMS.aculab.com>
 <20201026093917.5zgginii65pq6ezd@steredhat>
 <3e34e4121f794355891fd7577c9dfbc0@AcuMS.aculab.com>
 <20201026100112.qaorff6c6vucakyg@steredhat>
 <20201026105548.0cc911a8@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20201026105548.0cc911a8@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Oct 26, 2020 at 10:55:48AM -0700, Jakub Kicinski wrote:
>On Mon, 26 Oct 2020 11:01:12 +0100 Stefano Garzarella wrote:
>> On Mon, Oct 26, 2020 at 09:46:17AM +0000, David Laight wrote:
>> >From: Stefano Garzarella
>> >> Sent: 26 October 2020 09:39
>> >>
>> >> On Mon, Oct 26, 2020 at 09:13:23AM +0000, David Laight wrote:
>> >> >From: Stefano Garzarella
>> >> >> Sent: 26 October 2020 08:43
>> >> >...
>> >> >> >Isn't the canonical error for unknown ioctl codes -ENOTTY?
>> >> >> >
>> >> >>
>> >> >> Oh, thanks for pointing that out!
>> >> >>
>> >> >> I had not paid attention to the error returned, but looking at it I
>> >> >> noticed that perhaps the most appropriate would be -ENOIOCTLCMD.
>> >> >> In the ioctl syscall we return -ENOTTY, if the callback returns
>> >> >> -ENOIOCTLCMD.
>> >> >>
>> >> >> What do you think?
>> >> >
>> >> >It is 729 v 443 in favour of ENOTTY (based on grep).
>> >>
>> >> Under net/ it is 6 vs 83 in favour of ENOIOCTLCMD.
>> >>
>> >> >
>> >> >No idea where ENOIOCTLCMD comes from, but ENOTTY probably
>> >> >goes back to the early 1970s.
>> >>
>> >> Me too.
>> >>
>> >> >
>> >> >The fact that the ioctl wrapper converts the value is a good
>> >> >hint that userspace expects ENOTTY.
>> >>
>> >> Agree on that, but since we are not interfacing directly with userspace,
>> >> I think it is better to return the more specific error (ENOIOCTLCMD).
>> >
>> >I bet Linux thought it could use a different error code then
>> >found that 'unknown ioctl' was spelt ENOTTY.
>>
>> It could be :-)
>>
>> Anyway, as you pointed out, I think we should change the -EINVAL with
>> -ENOTTY or -ENOIOCTLCMD.
>>
>> @Jakub what do you suggest?
>
>ENOIOCTLCMD is a kernel-internal high return code (515) which should
>be returned by the driver, but it's then caught inside the core and
>translated to ENOTTY which is then returned to user space.
>
>So you're both right, I guess? But the driver should use ENOIOCTLCMD.
>

Thanks for clarify!

@Colin, can you send a v2 removing the error message and updating the 
return value?

Thanks,
Stefano

