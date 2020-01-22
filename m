Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 968A8145AF5
	for <lists+netdev@lfdr.de>; Wed, 22 Jan 2020 18:40:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728709AbgAVRkX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jan 2020 12:40:23 -0500
Received: from mail-ed1-f67.google.com ([209.85.208.67]:42179 "EHLO
        mail-ed1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725802AbgAVRkW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Jan 2020 12:40:22 -0500
Received: by mail-ed1-f67.google.com with SMTP id e10so384590edv.9
        for <netdev@vger.kernel.org>; Wed, 22 Jan 2020 09:40:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=yLiFtIkboeeZLFFTLCIQwVHL4bA4hu4oT7Vy4K7O4WY=;
        b=Jp/ZmEx+sEg/5WZDuoXqtsi0E/D9rIWSaXpd9njf1uoCugDIHOxzwcgzIuJdfCxzG2
         LkGatrk0FvmQWaFIxFZs4MLhjDZAAgaZ3wh/ZRKVa9niJTgz77oWnpFh3rjL88buDn9e
         Ik1E8ogtTP/BeD1cgnf706WZd7YXZV4MBqZWZUxTbo0XA/WVQ3/7c57i3rVUxBTub2L8
         B5oBL3Ok4e4mm6VWu3rhfz9PW6HaFOZTlSc9RUC4tp/83QMlUraThwL8tTVLJENIkKgH
         YfCsWJTyO3bKHL9ZNz892csvmcc51ySTkTADNLGjVQYdSYbcf/SBCCZMM6Jnx3i2HDqt
         eucQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=yLiFtIkboeeZLFFTLCIQwVHL4bA4hu4oT7Vy4K7O4WY=;
        b=s3aNcxdV2Q2dnab2Yc6fggrupDmwBshK6Kky/FEAR4piTVLQlgy9soIZraBldgd2dQ
         n4ZjP4e2IOy6aeaT3LwiuMwzQbljsg65cdUlPz5WBH3zCsp8+Qj4VJqCEybq4ew4Po/C
         8bqkIkppqB5sXT0A9LdOCCwQTNhO/DjREyDfJsgpnm0ApgFtYFG3SxyQUMu7QKGLx38b
         f95oNKQ4zioNu+G+c1FG3F9sCSqn0/kqbrOWeSGtJh4R+/MIlS6mrMdSnMWc12zqWT7L
         arQE1UvPykbCr2qsilqjNfbdsjg05BBZnvJVnZDx1b7CmD7OK00eeRkfVnzTYo0DeWSn
         trfw==
X-Gm-Message-State: APjAAAXB4qehpO3j5VvIbzhBmZYgq2e2ww18fVXopuXGDqjx8KefR2HO
        vSbWlzTOdFWEEyoPsf8RgOZHL4FhOd0amZFOuBs=
X-Google-Smtp-Source: APXvYqwphvpvo7oidP4gICHEEh+MHriMzlOAYaRDjZnGA1U5o7kdKcEWqR/Vvv/iQPk3L2ps/RymTsYG//X2VFY74jc=
X-Received: by 2002:a05:6402:1764:: with SMTP id da4mr3828457edb.24.1579714821250;
 Wed, 22 Jan 2020 09:40:21 -0800 (PST)
MIME-Version: 1.0
References: <20200122113533.28128-1-gautamramk@gmail.com> <20200122113533.28128-11-gautamramk@gmail.com>
 <20200122074203.00566700@cakuba>
In-Reply-To: <20200122074203.00566700@cakuba>
From:   Gautam Ramakrishnan <gautamramk@gmail.com>
Date:   Wed, 22 Jan 2020 23:10:10 +0530
Message-ID: <CADAms0ync3s6sOtH5ywwC6yWAK9P73d6+D+FqhtvUMyBwSVqEQ@mail.gmail.com>
Subject: Re: [PATCH net-next v6 10/10] net: sched: add Flow Queue PIE packet scheduler
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Linux Kernel Network Developers <netdev@vger.kernel.org>,
        "Mohit P. Tahiliani" <tahiliani@nitk.edu.in>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        "David S . Miller" <davem@davemloft.net>,
        Dave Taht <dave.taht@gmail.com>,
        =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Leslie Monis <lesliemonis@gmail.com>,
        "Sachin D . Patil" <sdp.sachin@gmail.com>,
        "V . Saicharan" <vsaicharan1998@gmail.com>,
        Mohit Bhasi <mohitbhasi1998@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 22, 2020 at 9:12 PM Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Wed, 22 Jan 2020 17:05:33 +0530, gautamramk@gmail.com wrote:
> > +     err = tcf_block_get(&q->block, &q->filter_list, sch, extack);
> > +     if (err)
> > +             goto init_failure;
>
> I think you're missing a tcf_block_put() call or equivalent.
Thanks for pointing it out. I shall make the change and resubmit.


-- 
-------------
Gautam |
