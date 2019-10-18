Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9BDBEDC7A8
	for <lists+netdev@lfdr.de>; Fri, 18 Oct 2019 16:43:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2408510AbfJROnz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Oct 2019 10:43:55 -0400
Received: from mail-pg1-f193.google.com ([209.85.215.193]:35170 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2405365AbfJROny (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Oct 2019 10:43:54 -0400
Received: by mail-pg1-f193.google.com with SMTP id p30so3520454pgl.2
        for <netdev@vger.kernel.org>; Fri, 18 Oct 2019 07:43:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=qqD13exqVYnsM1ZZfhtle755qkmvhaW0YCe6dhzNVH0=;
        b=OaQk+2++QPs2Uoczz52BnqNlZLiAERk1PO0sfo9yTqspjGbTmOZF1F2t9PXHOoq3A7
         L49GkCrMal0DOv0kLlse2/VWrCTVae77O88o1wkxfP7bwcV56UyE7HeZ2z2BzyUpRbJJ
         0znfd8KPTGtTF3V6vm//Vig0GDVFuGsimDdWrxmYizTu3hovvU4sC3+HSR7HUGngBqYp
         ezqgzD0ozhWGImFiIRzu2AQixMKMMzdJ8w1UmXW03k3i4xejFlyI+/bHWxwU7cIAQYpJ
         R9vMXN4IFSwMpzDeesAJ63OsC+dthar0Nl+jAUNSzxaxQSsXMrOHiorQkljeqvZJF9lS
         O1ug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=qqD13exqVYnsM1ZZfhtle755qkmvhaW0YCe6dhzNVH0=;
        b=jnfwibKUyWBB9RO4RNOv7QSxjAbfzw+sHxUEgktQ0l9kQv4bynURSgEXZzxeS1uSeT
         /lhTWfVPa31l4f/g707Ls7hZKh1b8m1pGLbWCb8uHlmIbw54WmeF631t00lob3avnLa/
         HGl7SrazimbHm7o/dDKb5W5nqMgN3sL17Z/uUa7xYKlKTvpGx8XqYslg3+XzTXDpH8Y+
         Lj5QjZ4Covud5knNzvPNPF9mWSp2Y9EcUfIXDyV+AU0lRjijBWRQCXGIWN0LScc5nTtc
         nvIzG9QE/gR3M0NiZv+yP7/n9lkl83BVq5GEexH5pUO3pLZS2yfdf7lOxKaykx+Urg85
         NbWQ==
X-Gm-Message-State: APjAAAXM/8QfYfqW1ZFD1OJQJqRcDlwExEYCNK4ool3fC6DTf0jqzIEy
        1F0Nb6FAAT4ckEBF3F7DSX+28zVA7uXtoQ==
X-Google-Smtp-Source: APXvYqxhSEUXJ1smjci2IeCyTjfO9xr/dLfImtrg2DgXhTN0iwUMsEz1gpueJMlRel+jnMBX5HZ2/A==
X-Received: by 2002:a17:90a:8a89:: with SMTP id x9mr11672031pjn.95.1571409831770;
        Fri, 18 Oct 2019 07:43:51 -0700 (PDT)
Received: from ?IPv6:2620:10d:c081:1131::1120? ([2620:10d:c090:180::e16a])
        by smtp.gmail.com with ESMTPSA id g20sm6308189pfo.73.2019.10.18.07.43.49
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 18 Oct 2019 07:43:50 -0700 (PDT)
Subject: Re: [PATCH 1/3] io_uring: add support for async work inheriting files
 table
To:     Jann Horn <jannh@google.com>
Cc:     linux-block@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Network Development <netdev@vger.kernel.org>
References: <20191017212858.13230-1-axboe@kernel.dk>
 <20191017212858.13230-2-axboe@kernel.dk>
 <CAG48ez0G2y0JS9=S2KmePO3xq-5DuzgovrLFiX4TJL-G897LCA@mail.gmail.com>
 <0fb9d9a0-6251-c4bd-71b0-6e34c6a1aab8@kernel.dk>
 <CAG48ez181=JoYudXee0KbU0vDZ=EbxmgB7q0mmjaA0gyp6MFBQ@mail.gmail.com>
 <a54329d5-a128-3ccd-7a12-f6cadaa20dbf@kernel.dk>
 <CAG48ez1SDQNHjgFku4ft4qw9hdv1g6-sf7-dxuU_tJSx+ofV-w@mail.gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <dbcf874d-8484-9c27-157a-c2752181acb5@kernel.dk>
Date:   Fri, 18 Oct 2019 08:43:48 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <CAG48ez1SDQNHjgFku4ft4qw9hdv1g6-sf7-dxuU_tJSx+ofV-w@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/18/19 8:40 AM, Jann Horn wrote:
> On Fri, Oct 18, 2019 at 4:37 PM Jens Axboe <axboe@kernel.dk> wrote:
>>
>> On 10/18/19 8:34 AM, Jann Horn wrote:
>>> On Fri, Oct 18, 2019 at 4:01 PM Jens Axboe <axboe@kernel.dk> wrote:
>>>> On 10/17/19 8:41 PM, Jann Horn wrote:
>>>>> On Fri, Oct 18, 2019 at 4:01 AM Jens Axboe <axboe@kernel.dk> wrote:
>>>>>> This is in preparation for adding opcodes that need to modify files
>>>>>> in a process file table, either adding new ones or closing old ones.
>>> [...]
>>>> Updated patch1:
>>>>
>>>> http://git.kernel.dk/cgit/linux-block/commit/?h=for-5.5/io_uring-test&id=df6caac708dae8ee9a74c9016e479b02ad78d436
>>>
>>> I don't understand what you're doing with old_files in there. In the
>>> "s->files && !old_files" branch, "current->files = s->files" happens
>>> without holding task_lock(), but current->files and s->files are also
>>> the same already at that point anyway. And what's the intent behind
>>> assigning stuff to old_files inside the loop? Isn't that going to
>>> cause the workqueue to keep a modified current->files beyond the
>>> runtime of the work?
>>
>> I simply forgot to remove the old block, it should only have this one:
>>
>> if (s->files && s->files != cur_files) {
>>          task_lock(current);
>>          current->files = s->files;
>>          task_unlock(current);
>>          if (cur_files)
>>                  put_files_struct(cur_files);
>>          cur_files = s->files;
>> }
> 
> Don't you still need a put_files_struct() in the case where "s->files
> == cur_files"?

I want to hold on to the files for as long as I can, to avoid unnecessary
shuffling of it. But I take it your worry here is that we'll be calling
something that manipulates ->files? Nothing should do that, unless
s->files is set. We didn't hide the workqueue ->files[] before this
change either.

-- 
Jens Axboe

