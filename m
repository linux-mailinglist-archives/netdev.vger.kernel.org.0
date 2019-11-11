Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 72556F7AB9
	for <lists+netdev@lfdr.de>; Mon, 11 Nov 2019 19:25:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726958AbfKKSZJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Nov 2019 13:25:09 -0500
Received: from mail-il1-f194.google.com ([209.85.166.194]:38804 "EHLO
        mail-il1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726821AbfKKSZJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Nov 2019 13:25:09 -0500
Received: by mail-il1-f194.google.com with SMTP id u17so8075322ilq.5
        for <netdev@vger.kernel.org>; Mon, 11 Nov 2019 10:25:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=JCeoaT6SPhdsAFhAQGiiZtXxeeYRWs8SK2Q/QsJRHRw=;
        b=jQlgh9zg8O2oWvtUgxIK4YvQg67tSjZ4/A2rV1ETgxAixnV4Vn/xrsWyhToTtyWwZi
         ziQbIVgYEGgVjRL3axUjbSv0B3VJkvPJVKd+crjsiLycM39aenWS5AkkmkzIdK48RBP/
         k10Ty3GJjTIO+o5o4apvbWJ7P2zH+pxX2UbDFNcms7e44AhfX6Cim3hGLEW0bndiyNsL
         HRTiSTZnO5Pko7+QtmofgLQ7iqr0jAb3LicadsvqZzGo2Ow4+pOhQ5HQPigrepQZMjv1
         +bWwege4dM5pVO6JltOo2MyantbqK+OdRXHhKotv7a7oyD9HbOg+tKWmvawjR/+D5RsG
         q94w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=JCeoaT6SPhdsAFhAQGiiZtXxeeYRWs8SK2Q/QsJRHRw=;
        b=r8ZV8qj2NruOZqUnXnr9Fm3YF9RUVSgkeg3SSmOoVs7tZJfU6LFO2iduHD8uD1zhji
         5KRy/8L17exZz1mDCpogIA9LDYv7ezMbN8bGCRCtjau/X56CliFC6jH7leR6S0RvWom/
         BiF38Rh495aIm0KdZWImvgh09F9R38KgJFircm0EC6vycIj+iXcskziTRW6KKkG8a7sH
         XZNlR1a77I9Ftb5n8ijNTCiRoKklthO7++6GiDGmwlWQpcjJ3wvT4CSaZ0Acea3GSaGc
         zfrB48c/C9TNx/d+R/LzIdnkIWHvV2TMtXSd9uc0qqAzdOvggufG9UW7sZuv7TUqj+Tc
         gUrg==
X-Gm-Message-State: APjAAAWuKmM21IKJbM4MPyviY9LBBuGJOyYRePmcGEChqA5hNPgw+/XC
        kS3cyabz++4TR2nlIMAvp5WUh+DZYzY7jK07lziA7g==
X-Google-Smtp-Source: APXvYqzHvkfiZBckd2jJeRCy/dDlhO8RqeOlsComYTZXSNlEorT+CbKY8qGYKd5JtTib+86a056DbXjDKUPm7UT04wk=
X-Received: by 2002:a92:109c:: with SMTP id 28mr31333481ilq.142.1573496708105;
 Mon, 11 Nov 2019 10:25:08 -0800 (PST)
MIME-Version: 1.0
References: <20191101173219.18631-1-edumazet@google.com> <20191101.145923.2168876543627475825.davem@davemloft.net>
 <CAC=O2+SdhuLmsDEUsNQS3hbEH_Puy07gxsN98dQzTNsF0qx2UA@mail.gmail.com>
 <CANn89iJUVcpbknBsKn5aJLhJP6DkhErZBcEh3P_uwGs4ZJbMYQ@mail.gmail.com>
 <CAC=O2+R3gHT6RtqL6RPiWsyuptpa+vrSQsxdN=DW1LaD1B-vGw@mail.gmail.com>
 <CANn89iLPfy6Nbk0pouySQq=xVsEOGJMkVEXM=nKWW3=e4OGjoQ@mail.gmail.com> <CAC=O2+QG6vdJxjHT9yVQ4c78qG6LdREJch0Z5gKvcdfO94t9Rg@mail.gmail.com>
In-Reply-To: <CAC=O2+QG6vdJxjHT9yVQ4c78qG6LdREJch0Z5gKvcdfO94t9Rg@mail.gmail.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Mon, 11 Nov 2019 10:24:56 -0800
Message-ID: <CANn89i+sjuMtkK_J0gCV4CXYwGNk=Udark1=n5ZSHJd04nO7Mg@mail.gmail.com>
Subject: Re: [PATCH net] inet: stop leaking jiffies on the wire
To:     Thiemo Nagel <tnagel@google.com>
Cc:     David Miller <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 11, 2019 at 9:49 AM Thiemo Nagel <tnagel@google.com> wrote:

> Problem a) is hard -- as you mention, it may require hardware support
> to solve it fully. However the problem that I'm suggesting to address
> is b), and that likely can be solved by swapping out prandom_u32() for
> get_random_u32().
>

Make sure a server can still generates 10 millions packets per second
using this thing :)

I believe get_random_u32() is at least 5 times more expensive than
prandom_u32(),
and that is on x86 where arch_has_random() is true and rdrand
instruction can be used.

On other arches this would probably kill performance, and eat entropy
way too much.

Really this is a discussion that should be taken to random subsystem
maintainers.

We can not simply use get_random_u32() here.
