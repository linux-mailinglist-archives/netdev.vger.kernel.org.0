Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1C30956649
	for <lists+netdev@lfdr.de>; Wed, 26 Jun 2019 12:10:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726387AbfFZKKL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Jun 2019 06:10:11 -0400
Received: from mail-yb1-f193.google.com ([209.85.219.193]:42059 "EHLO
        mail-yb1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725379AbfFZKKL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Jun 2019 06:10:11 -0400
Received: by mail-yb1-f193.google.com with SMTP id w9so1031731ybe.9
        for <netdev@vger.kernel.org>; Wed, 26 Jun 2019 03:10:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=RzN+GJDJig/0G1hyVW5cslUEAZNBjYgx7cq3gfmBETk=;
        b=Q+JmW5ggStmYpLcNn7Iv74jwH+agMYPPCAYsM7qU6NjPZU81MzZMtc8W4MIXRfVYm4
         qEzyAdkOorrAPw6I/4Pm0dyZlcnXHn0Xqs9VQcym2YKpYZtP+GOQJaWNC/yhWo7IskRY
         +bPzBqjdTO9QuO8BDnLWl6UM6ZQEAjSjkRIji2c5z+73OSpGqWpJzi4WfSutFSehOeQ+
         5mzcRFQl3ltY0hGLckmF6AkVOqzEMhIg3aHa3j2fMwP0QrJhupZ4IWi5Srm5nrL4VAku
         0+zct1eWZB0sIIfZhPIaDC6g5r4xqu7ZW2ICvDxHRb2XQYfNpeRHaSpZySut0wKeJY4a
         Vnog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=RzN+GJDJig/0G1hyVW5cslUEAZNBjYgx7cq3gfmBETk=;
        b=gNFHrXKj2iNgygFiB9wZ/RnOqJLPMlMie87vfShdPMM6hX5diVgXZRk9t0yNl5kR2z
         /ond4BML6c1bdLWgOd8Tn/F/HfoxINBUlZhTyrzFYXo6gs6TgQ0S8hChEfQfnkEbLjM4
         lWqzChkdYWa71cOdDIyBiKktAERHtHCxiEddnexB9p/3Th88B/KsNrCqd7YxKe0wnNqP
         al2XJLAfVMDrwPlr7pHiH/+xLUUzOrieP4zHJmcXDd2WmEzGSOo1OOhz+Dr1h86jfYob
         xj2OdNRW3/nSd5jVImlh5EZrZRWpkkgC03tNse4sjjROTRoeR5aXsFSedMyu2eI+eHGf
         Uc9A==
X-Gm-Message-State: APjAAAWD2EYu4ef1gVSSCSDVHpJFwTykBxptDUk1Tj2acmJOM0SZzxKk
        U4YY4IhUlrWVLInKFR7hzEx5Sxj/2B+CgUv36zOl/qai+rPTBg==
X-Google-Smtp-Source: APXvYqyNEe4mtScgdAFjsBj0QBP3b5vNr7CMvSR5lUDustMoIFdCCkaOgJyvEasISH0OTapgghXdo15wRNubS+KDgm0=
X-Received: by 2002:a25:55d7:: with SMTP id j206mr2230190ybb.234.1561543809986;
 Wed, 26 Jun 2019 03:10:09 -0700 (PDT)
MIME-Version: 1.0
References: <20190626100528.218097-1-edumazet@google.com>
In-Reply-To: <20190626100528.218097-1-edumazet@google.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Wed, 26 Jun 2019 12:09:58 +0200
Message-ID: <CANn89iJPr1d3OHJ7kfSwQ9=mNaDLALPTEoYJWBDRM=WB6k+JVg@mail.gmail.com>
Subject: Re: [PATCH net] ipv6: fix suspicious RCU usage in rt6_dump_route()
To:     "David S . Miller" <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Stefano Brivio <sbrivio@redhat.com>,
        David Ahern <dsahern@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 26, 2019 at 12:05 PM Eric Dumazet <edumazet@google.com> wrote:
>
> syzbot reminded us that rt6_nh_dump_exceptions() needs to be called
> with rcu_read_lock()

Same remark : This is for net-next tree.
