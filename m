Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B38C614F7F0
	for <lists+netdev@lfdr.de>; Sat,  1 Feb 2020 14:30:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726523AbgBANa0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 1 Feb 2020 08:30:26 -0500
Received: from mail-ot1-f48.google.com ([209.85.210.48]:35381 "EHLO
        mail-ot1-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726480AbgBANa0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 1 Feb 2020 08:30:26 -0500
Received: by mail-ot1-f48.google.com with SMTP id r16so9361380otd.2
        for <netdev@vger.kernel.org>; Sat, 01 Feb 2020 05:30:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=4yXaP+LRwvGbnJ1oBUWO/6IuGMATcaiOWRj5DUBQkZc=;
        b=mGy1O5WG/tD3ojyVu95+/cXsxrs7yob/kKKG3B9zVOHLfM7/vj6HadS6BYUp84GcIz
         XY7eOfJm7sq3NSqx54cMlNaljd0pX6geQ7XRz7VF++0514woUxPyIHSkY1ICjxhLK2rn
         ntKeWlTXK3tb5coXbnqi8k4/rz99GzN/4xFKeLSkOOWVm2F97kmI2tHOaiONNW5h5AH/
         AAaLTgsBG62j3Ls0YzyHVC9hYpNC60/uxvw/RgBZPpSXoeiCs/6046VE3fUWA7GFSvgv
         SYmMtflo56jpLDabCa5y909GkkUOIGpiq7uFWL8IPtIt7EzO2WcPqh658ACbP4k8nbRO
         svFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=4yXaP+LRwvGbnJ1oBUWO/6IuGMATcaiOWRj5DUBQkZc=;
        b=gY2JU3fZP3sTV9b+4fhctb2OHa6S04PCTWUsMN9LuI6D1WBRNawk8LyYX0bvEuii1y
         UVriV3defcDALUHBTAAWvLZ99ymm5sEwiCutDb96ltGNpkyJ2J9dUTwe2E9q82lJ8K0H
         pQUl1g0iHsgtg1CverApOgkxEpaF52+WvJbK31LHxIRfbnDV5hH0cWCCpVjuAGZ0AZ0F
         N5AHoZd0zjUY8v1Qdq3pzMm7DdzFlR7oj9kSmJ/o51IhsRRwKap/vT/v99nzNOeIRDtT
         veU4AfHvEEkEST6HrnLjw1OWS9Pa2LsPSwKnnyxB6REbbs2/EJN7GVxT4ugelWLsFw7x
         Uwew==
X-Gm-Message-State: APjAAAWUtcZ6qSvuHkAWgCKdAhKMwRy5pCEAtikH/3Uxx+Qv0GG4JuVT
        ceCY3I+sXU8yA4PnR7uKd64OU/URl24fPbmiqMuXtg==
X-Google-Smtp-Source: APXvYqwkhM6QMY2sSNkbJDFdOXUjQFF1n3ICPf5aMAN4z/s8Xn6Y/knX56aoiFE+U39Y64v9cdVWaVWyzaObYRI1rco=
X-Received: by 2002:a9d:7b51:: with SMTP id f17mr11027322oto.302.1580563825300;
 Sat, 01 Feb 2020 05:30:25 -0800 (PST)
MIME-Version: 1.0
References: <CADVnQy=oFmmG-Z9QMafWLcALOBgohADgwScn2r+7CGFNAw5jvw@mail.gmail.com>
 <20200201060843.21626-1-sj38.park@gmail.com>
In-Reply-To: <20200201060843.21626-1-sj38.park@gmail.com>
From:   Neal Cardwell <ncardwell@google.com>
Date:   Sat, 1 Feb 2020 08:30:08 -0500
Message-ID: <CADVnQymWFGfX-N_O=p_kqJ2UxQZUDVn1YKrzZ+C+hYWc_OuzMg@mail.gmail.com>
Subject: Re: Re: Re: [PATCH 2/3] tcp: Reduce SYN resend delay if a suspicous
 ACK is received
To:     SeongJae Park <sj38.park@gmail.com>
Cc:     Eric Dumazet <eric.dumazet@gmail.com>, sjpark@amazon.com,
        Eric Dumazet <edumazet@google.com>,
        David Miller <davem@davemloft.net>, shuah@kernel.org,
        Netdev <netdev@vger.kernel.org>, linux-kselftest@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>, aams@amazon.com,
        SeongJae Park <sjpark@amazon.de>,
        Yuchung Cheng <ycheng@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Feb 1, 2020 at 1:08 AM SeongJae Park <sj38.park@gmail.com> wrote:
> RST/ACK is traced if LINGER socket option is applied in the reproduce program,
> and FIN/ACK is traced if it is not applied.  LINGER applied version shows the
> spikes more frequently, but the main problem logic has no difference.  I
> confirmed this by testing both of the two versions.
>
> In the previous discussion, I showed the LINGER applied trace.  However, as
> many other documents are using FIN/ACK, I changed the trace to FIN/ACK version
> in this patchset for better understanding.  I will comment that it doesn't
> matter whether it is FIN/ACK or RST/ACK in the next spin.

Great. Thanks for the details!

neal
