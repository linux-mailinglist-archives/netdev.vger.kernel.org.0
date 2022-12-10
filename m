Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 50B17648F7E
	for <lists+netdev@lfdr.de>; Sat, 10 Dec 2022 16:36:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229750AbiLJPgR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 10 Dec 2022 10:36:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34476 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229732AbiLJPgO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 10 Dec 2022 10:36:14 -0500
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7FF211A05A
        for <netdev@vger.kernel.org>; Sat, 10 Dec 2022 07:36:13 -0800 (PST)
Received: by mail-pl1-x636.google.com with SMTP id d7so7799839pll.9
        for <netdev@vger.kernel.org>; Sat, 10 Dec 2022 07:36:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:content-language:cc:to:subject:from
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=CpxA/SL97knKBrJfUdv1usFpbLft+Z7VxMk6SqP21/s=;
        b=HYhuxD+XZquhgEwi5h8vNbmvRD/sH1EebEqiLZjBHU+pzBl06MGLRw61nz+Ju/b0fb
         lTIoR6EZwx/pKTEqjSLa3xbvlyGC+rVmGmc+iTLvJW0xK85T8jC1wvWqhgKaj03bonc3
         FjMTLrZWUVPM5baBP0jmjQKMQz7qSEHNRMJl2Ne5QSQ8mmRiPuCiU4HuDM1orKFjohHw
         83uveg4PAwS2a+L3n7vgp4HWLiQ9cEhIGDT8hjBpqEZRuvzOTcz2IdDzkZGcqOJHWt2e
         u76/qss1XAaRJR8MjNQn4uSCcwBBq6rIhEK1v5JVf++z0dI4XjO/v7k3A/Izy+5Q2+Aw
         L/Aw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:content-language:cc:to:subject:from
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=CpxA/SL97knKBrJfUdv1usFpbLft+Z7VxMk6SqP21/s=;
        b=pc/IUGvlh2c12oTSETUYxfOv0fP7r4n3Sgu50r21CZihxplPe51GuO9ldIjP54SZi7
         J4sQ0pNXMU+FiuPZhZrLjR/Et80/caPoUOpbTA1fLIPbmj8D7AiNwz3KhXGFNghoKgCw
         5553Sq0wZvgVfqV14XapfT957i4RQ9Vo/+9TUAEYXe9cm1bg3kvtEMruH1yY6v0JkIvM
         HrY9aXXP/M39VwuysnmF47biTDsoHMJjgLwRWjhZWOiIdusPe4O2NGlhw8wwJwrq3Lgf
         DUVU6s90yugeX2VmdvVBMvwIvPnCpuzsyIkKjpPMFGHWtOKYh9dyMAPNu2fBL3U1bHhl
         szVQ==
X-Gm-Message-State: ANoB5pl2IqyXY5HtzET4TOkssqHox1nEhZ2eCij+Kz1JRdf3GHmnB4rB
        nfM8jFzGk1L+wmWB4qAGUsx1IQ==
X-Google-Smtp-Source: AA0mqf4WXJ7DOBrkysCZrsKNzdfsRhDmjHUVzeKdlhoVrNHmm4+A9UEbBX7t024OsANn4MRPvZVErw==
X-Received: by 2002:a17:902:b694:b0:189:cff9:726a with SMTP id c20-20020a170902b69400b00189cff9726amr2935709pls.4.1670686572904;
        Sat, 10 Dec 2022 07:36:12 -0800 (PST)
Received: from [192.168.1.136] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id ix3-20020a170902f80300b0018980f14ecfsm3139516plb.115.2022.12.10.07.36.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 10 Dec 2022 07:36:12 -0800 (PST)
Message-ID: <b0901cba-3cb8-a309-701e-7b8cb13f0e8a@kernel.dk>
Date:   Sat, 10 Dec 2022 08:36:11 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.1
From:   Jens Axboe <axboe@kernel.dk>
Subject: [GIT PULL] Add support for epoll min wait time
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     netdev <netdev@vger.kernel.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=1.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_SBL_CSS,SPF_HELO_NONE,SPF_PASS
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: *
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Linus,

I've had this done for months and posted a few times, but little
attention has been received. Sending it out for inclusion now, as having
it caught up in upstream limbo is preventing further use cases of it at
Meta. We upstream every feature that we develop, and we don't put any
features into our kernel that aren't already upstream, or on the way
upstream. This is obviously especially important when an API is
involved.

This adds an epoll_ctl method for setting the minimum wait time for
retrieving events. In production, workloads don't just run mostly idle
or mostly full tilt. A common pattern is medium load. epoll_wait and
friends receive a cap of max events and max time we want to wait for
them, but there's no notion of min events or min time. This leads to
services only getting a single event, even if they are totally fine with
waiting eg 200 usec for more events. More events leads to greater
efficiency in handling them.

The main patch has some numbers, but tldr is that we see a nice
reduction in context switches / second, and a reduction in busy time on
such systems.

It has been suggested that a syscall should be available for this as
well, and there are two main reasons for why this wasn't pursued (but
was still investigated):

- This most likely should've been done as epoll_pwait3(), as we already
  have epoll_wait, epoll_pwait, and epoll_pwait2. The latter two are
  already at the max number of syscall arguments, so a new method would
  have to be done where a struct would define the API. With some
  arguments being optional, this could get inefficient or ugly (or both).

- Main reason is that Meta doesn't need it. By using epoll_ctl, the
  check-for-support-of-feature can be relegated to setup time rather
  than in the fast path, and the workloads we are looking at would not
  need different min wait settings within a single epoll context.

Please pull!


The following changes since commit ef4d3ea40565a781c25847e9cb96c1bd9f462bc6:

  afs: Fix server->active leak in afs_put_server (2022-11-30 10:02:37 -0800)

are available in the Git repository at:

  git://git.kernel.dk/linux.git tags/epoll-min_ts-2022-12-08

for you to fetch changes up to 73b9320234c0ad1b5e6f576abb796221eb088c64:

  eventpoll: ensure we pass back -EBADF for a bad file descriptor (2022-12-08 07:05:42 -0700)

----------------------------------------------------------------
epoll-min_ts-2022-12-08

----------------------------------------------------------------
Jens Axboe (8):
      eventpoll: cleanup branches around sleeping for events
      eventpoll: don't pass in 'timed_out' to ep_busy_loop()
      eventpoll: split out wait handling
      eventpoll: move expires to epoll_wq
      eventpoll: move file checking earlier for epoll_ctl()
      eventpoll: add support for min-wait
      eventpoll: add method for configuring minimum wait on epoll context
      eventpoll: ensure we pass back -EBADF for a bad file descriptor

 fs/eventpoll.c                 | 192 +++++++++++++++++++++++++++++++++--------
 include/linux/eventpoll.h      |   2 +-
 include/uapi/linux/eventpoll.h |   1 +
 3 files changed, 158 insertions(+), 37 deletions(-)

-- 
Jens Axboe

