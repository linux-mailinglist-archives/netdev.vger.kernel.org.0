Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 52BF810127F
	for <lists+netdev@lfdr.de>; Tue, 19 Nov 2019 05:34:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727675AbfKSEeb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Nov 2019 23:34:31 -0500
Received: from mail-pl1-f173.google.com ([209.85.214.173]:36072 "EHLO
        mail-pl1-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727217AbfKSEea (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Nov 2019 23:34:30 -0500
Received: by mail-pl1-f173.google.com with SMTP id d7so11046570pls.3
        for <netdev@vger.kernel.org>; Mon, 18 Nov 2019 20:34:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=rkdEpR62sDVJxgsklhz1UnFEmVbcNibLh8/QnTcfFDc=;
        b=QxRyOWEATY2cC2tVR5io3QZcV+0POPsUjI9K7u3AsC/BnxcStwWEfJUlXHl0Vi791Q
         Io6aVIdnaAJRnpxHlJEpBsiNM58/23Ti/xY5Ge5bZp80Z0bCNHXJtcFtHdbiDZenPI09
         PKFZNRtVzPyhTH/hzpAn0eFyDgIcZyTbRgiMdIYuOqaMSVnEoyAlU5RDlhVmnlGGLMAW
         j2nw7EU7CUklvXki/4UaU2nPoGgjr+laZc020JOvx3acdSInUg46Qu6OC5UXAJF9LXdS
         kmSfLrmPjbYJBiFx0vHl43XvtDqbJEVpR8AGeGRQbXBHGq41ywd0nP0brZuC6EyE47IC
         brHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=rkdEpR62sDVJxgsklhz1UnFEmVbcNibLh8/QnTcfFDc=;
        b=XekX9KaKrGQOve5dooyo1XlMcRbl9PsFGh/tgY7sa0MqH0LSwhrruY82Q59fp7wcov
         BrrKvLEbQqrE2gTQpK2/53TF5eTuUWyQR2FtKtcFcqZ8ebXLyQ+b2UrYBUO7BMSCUUPJ
         JtrRyNVIBSYygJDWMBWUk9d6mcMeRmYxIkW5UhJWV0gwTugUnYLBVIfPkPTHJ+rMoBsQ
         JfZskK8wHfmyDfTlChNwCzOMbaMS3ig4DLMfHLxTSle9tdoU5z7TjBSzjpfI4E9YkXzG
         FX7K3zEvWYT+FU8RqCBJv59OlXrxBSlDUHWUCOFt5EWslnc7wPeWJyr/ZMdCQ+JQs3CL
         8pgA==
X-Gm-Message-State: APjAAAU9ajkxJoE8KS/MTUVauAicaD8EgTIifn7uddN/7oPt43W4qOGz
        gEe7Mpz+MMB9RfEIOfSmJO7vaA==
X-Google-Smtp-Source: APXvYqwS6dQ3WixHS9SBX1WTB0MYVtzBe/zIaYNktn/PyxM7sW/RB1GkPzkJraCwg45ZOoaYSWA9Lg==
X-Received: by 2002:a17:90a:22a6:: with SMTP id s35mr3454079pjc.3.1574138067544;
        Mon, 18 Nov 2019 20:34:27 -0800 (PST)
Received: from [192.168.1.188] ([66.219.217.79])
        by smtp.gmail.com with ESMTPSA id s2sm21838748pgv.48.2019.11.18.20.34.24
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 18 Nov 2019 20:34:26 -0800 (PST)
Subject: Re: INFO: task hung in io_wq_destroy
From:   Jens Axboe <axboe@kernel.dk>
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     syzbot <syzbot+0f1cc17f85154f400465@syzkaller.appspotmail.com>,
        andriy.shevchenko@linux.intel.com, davem@davemloft.net,
        f.fainelli@gmail.com, gregkh@linuxfoundation.org,
        idosch@mellanox.com, kimbrownkd@gmail.com,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, petrm@mellanox.com,
        syzkaller-bugs@googlegroups.com, tglx@linutronix.de,
        viro@zeniv.linux.org.uk, wanghai26@huawei.com,
        yuehaibing@huawei.com
References: <000000000000f86a4f0595fdb152@google.com>
 <f1a79e81-b41f-ba48-9bf3-aeae708f73ba@kernel.dk>
 <20191119022330.GC3147@sol.localdomain>
 <bc52115c-3951-54c6-7810-86797d8c4644@kernel.dk>
Message-ID: <c7b9c600-724b-6df1-84ba-b74999d6f4a6@kernel.dk>
Date:   Mon, 18 Nov 2019 21:34:22 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <bc52115c-3951-54c6-7810-86797d8c4644@kernel.dk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/18/19 8:15 PM, Jens Axboe wrote:
> On 11/18/19 7:23 PM, Eric Biggers wrote:
>> Hi Jens,
>>
>> On Mon, Oct 28, 2019 at 03:00:08PM -0600, Jens Axboe wrote:
>>> This is fixed in my for-next branch for a few days at least, unfortunately
>>> linux-next is still on the old one. Next version should be better.
>>
>> This is still occurring on linux-next.  Here's a report on next-20191115 from
>> https://syzkaller.appspot.com/text?tag=CrashReport&x=16fa3d1ce00000
> 
> Hmm, I'll take a look. Looking at the reproducer, it's got a massive
> sleep at the end. I take it this triggers before that time actually
> passes? Because that's around 11.5 days of sleep.
> 
> No luck reproducing this so far, I'll try on linux-next.

I see what it is - if the io-wq is setup and torn down before the
manager thread is started, then we won't create the workers we already
expected. The manager thread will exit without doing anything, but
teardown will wait for the expected workers to exit before being
allowed to proceed. That never happens.

I've got a patch for this, but I'll test it a bit and send it out
tomorrow.

-- 
Jens Axboe

