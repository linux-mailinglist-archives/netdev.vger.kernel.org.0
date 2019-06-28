Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F13525A61F
	for <lists+netdev@lfdr.de>; Fri, 28 Jun 2019 23:06:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726604AbfF1VGG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Jun 2019 17:06:06 -0400
Received: from mail-pl1-f193.google.com ([209.85.214.193]:34418 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725783AbfF1VGG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Jun 2019 17:06:06 -0400
Received: by mail-pl1-f193.google.com with SMTP id i2so3913720plt.1
        for <netdev@vger.kernel.org>; Fri, 28 Jun 2019 14:06:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version;
        bh=Khe1TlauAnVAYu3wIc3FrfUyx4bf6J8y6jSD7zPiuqI=;
        b=eUIzNF/xPUfxSM1GPZhjzZuBp+kmGzjyaq3fspY1190Oy5Ht/euKNJR8VjnAbLZ6+v
         /ghwggj1wUp4xrQ8pbWorJFAgJ8gyOSk2dX6XRLH0mJpODdJ0lDkBcW+n9kmjKlqnTq4
         n5sZGA+ocAR4WJeztrVMkqYSilf6zqZD62hCSPBLy4xAXY6zf2RB1LiUprTdTc8e0Cz0
         8iCraKGSfk7+9JflxZye62w4ZZZA4VTdtMvw8jLylX/U3dBUKNiPnmgBBt/xtyRksQM0
         Sxymy8gqtfiJeWvU05HJcA/TUiepYpsJV/TifgaUXJhSnigXK8IrSM3HAND51QqldSu7
         tuDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version;
        bh=Khe1TlauAnVAYu3wIc3FrfUyx4bf6J8y6jSD7zPiuqI=;
        b=iZddsYGBBLwgxXHRhftfgMpkHkcIadDeHHzbda0xXx8yWU0xjKaQLLguRJp2aaSMpV
         xnrO7lDjHH/R/YgakCpe7irL6uUl6QfR+Tkng2vO3HhdpIXC++pHHgbHM5kSCQY/RWpK
         iKrvtmoa2IHKkz8r1vCZ9J5sicz5Q3iqZmq9C7HJYXqXhxr/a/TYYDa9TRkeWRLbLr6q
         V+LiLIE0UhqWORssZ+OE3HqWyCuISpiyn+9Hlq0YRpHKcyc12j+5m9YKgJylcQhL9USN
         DikUrfU3+R/T4NU0/gBY/RoPt1HclGnYF8N5fGvIzHCGaDtIrHr2gsqAm6+/Q8edEo2+
         wNvA==
X-Gm-Message-State: APjAAAV4BWovPrnz9A+v3THICeTlSCyBaj/oZG2HpWWr6WbFjvh0bpIr
        /kZ8GYGnEagbaXPuW2y3PE8=
X-Google-Smtp-Source: APXvYqyFJwm1W9wGUGJ4slwAvdOrbHcncIuf8YKP8hA9exRbH7EhIhY7BmjABioDA3bj322Nhx0pKw==
X-Received: by 2002:a17:902:15c5:: with SMTP id a5mr14183301plh.39.1561755965636;
        Fri, 28 Jun 2019 14:06:05 -0700 (PDT)
Received: from [172.20.54.151] ([2620:10d:c090:200::e695])
        by smtp.gmail.com with ESMTPSA id p27sm5022925pfq.136.2019.06.28.14.06.04
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 28 Jun 2019 14:06:04 -0700 (PDT)
From:   "Jonathan Lemon" <jonathan.lemon@gmail.com>
To:     "Jakub Kicinski" <jakub.kicinski@netronome.com>
Cc:     netdev@vger.kernel.org, bjorn.topel@intel.com,
        magnus.karlsson@intel.com, saeedm@mellanox.com,
        maximmi@mellanox.com, brouer@redhat.com, kernel-team@fb.com
Subject: Re: [PATCH 4/6 bfp-next] Simplify AF_XDP umem allocation path for
 Intel drivers.
Date:   Fri, 28 Jun 2019 14:06:03 -0700
X-Mailer: MailMate (1.12.5r5635)
Message-ID: <5061E73B-6980-4055-917D-D35906D98E9A@gmail.com>
In-Reply-To: <20190628134847.74bea2fb@cakuba.netronome.com>
References: <20190627220836.2572684-1-jonathan.lemon@gmail.com>
 <20190627220836.2572684-5-jonathan.lemon@gmail.com>
 <20190627154206.5d458e94@cakuba.netronome.com>
 <32DD3CE5-327F-4D76-861B-7256F3F10EC9@gmail.com>
 <20190628134847.74bea2fb@cakuba.netronome.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 28 Jun 2019, at 13:48, Jakub Kicinski wrote:

> On Thu, 27 Jun 2019 19:36:42 -0700, Jonathan Lemon wrote:
>> On 27 Jun 2019, at 15:42, Jakub Kicinski wrote:
>>> Could you be more explicit on the motivation?  I'd call this patch set
>>> "make all drivers use reuse queue" rather than "clean up".
>>
>> The motivation is to have packets which were received on a zero-copy
>> AF_XDP socket, and which returned a TX verdict from the bpf program,
>> queued directly on the TX ring (if they're in the same napi context).
>>
>> When these TX packets are completed, they are placed back onto the
>> reuse queue, as there isn't really any other place to handle them.
>>
>> It also addresses Maxim's concern about having buffers end up sitting
>> on the rq after a ring resize.
>>
>> I was going to send the TX change out as part of this patch, but
>> figured it would be better split unto its own series.
>
> Makes sense, please put that info in the cover letter.  (in other nit
> picks please prefix the patches which the name of the subsystem they
> are touching - net: xsk: ?, and make sure all changes have a commit
> message).
>
> Looking at this yesterday I think I've seen you didn't change the RQ
> sizing -  for the TX side to work the rq size must be RX ring size
> + XDP TX ring size (IIRC that was the worst case number of packets
> which we may need to park during reconfiguration).
>
> Maybe you did do that and I missed it.

Not yet - that's in the TX section of the patches, I'll post the
Intel versions shortly.



>>> Also when you're changing code please make sure you CC the author.
>>
>> Who did I miss?
>
> commit f5bd91388e26557f64ca999e0006038c7a919308
> Author: Jakub Kicinski <jakub.kicinski@netronome.com>
> Date:   Fri Sep 7 10:18:46 2018 +0200
>
>     net: xsk: add a simple buffer reuse queue
>
>     XSK UMEM is strongly single producer single consumer so reuse of
>     frames is challenging.  Add a simple "stash" of FILL packets to
>     reuse for drivers to optionally make use of.  This is useful
>     when driver has to free (ndo_stop) or resize a ring with an active
>     AF_XDP ZC socket.
>
>     Signed-off-by: Jakub Kicinski <jakub.kicinski@netronome.com>
>     Tested-by: Andrew Bowers <andrewx.bowers@intel.com>
>     Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
>
>
> Sorry to get upset, I missed a bpf patch recently and had to do
> a revert..

Ack.
