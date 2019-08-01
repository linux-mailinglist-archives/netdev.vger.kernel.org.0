Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CF18A7D34D
	for <lists+netdev@lfdr.de>; Thu,  1 Aug 2019 04:22:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728171AbfHACWU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 31 Jul 2019 22:22:20 -0400
Received: from mail-ed1-f66.google.com ([209.85.208.66]:37580 "EHLO
        mail-ed1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726079AbfHACWU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 31 Jul 2019 22:22:20 -0400
Received: by mail-ed1-f66.google.com with SMTP id w13so67645227eds.4;
        Wed, 31 Jul 2019 19:22:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=sC9WSjHIf3YYqrZ48Ho9EQniwjdamSmLDkL+UgHsgsE=;
        b=llXl0uA66CPHwc937gj8nqBMKzMjpnrttJor3IogjY5x4XNbctuL16+HpHVNLkvSHJ
         dASGPohwTOLRrOIbesMNK7aHBkEj3ZGLJmG2FJnf4eRm1fHXUvgxzGkDftTIHc1VHDmZ
         j5BqHd9erS6VkcaY97iG2yCqyRLY92B5zj0taBeypB+2Pbw7c+AnlTnxcwNWI3g5nydm
         ABDm823hVpYbhF2Afs1V7P6h4O5mNUWpvvMtHv2cI9v0X4YNt5IYkPGbWuAqBHztDuXZ
         k8BiSmE0GwfdAIM1X3RgZzDMiMxwDz2f5OG8kK/QwNmSt3WLqz9v8W+Jn8JK5CLYJ0w5
         b3Yw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=sC9WSjHIf3YYqrZ48Ho9EQniwjdamSmLDkL+UgHsgsE=;
        b=tU0rgSE85FriElE0AXX7S5LqYbZzXII2mIk/pNthu77pZuRggi3ApPZzf+hfM+i1y2
         C8sMlLYEejCEYGjNRet12HOs2atYFgbKOPYOkBwpyKQp0sLfKeRB9SKXwDaKDJmFXLZF
         c985DMDr1/NEO2ugPqrK8EyZMQllJAwepKG972+WjH9sOX7pZdkw6ZlsdZEUQ58g9Ojw
         A/9gx3iKH+MTANw6ctC9jmyXhqoyW3mg/qBwcYxc7tw6APIdYSJamW2U6biNoSCRLmW5
         fj+GQVDtqrVW1CC8YWKGuBUxxWF754roMZ1TZhfHNP0QNT9cotuBkheiYXIlfLJLQSGp
         3Ldw==
X-Gm-Message-State: APjAAAWDB042oJcPAR4EyZ/p22sjS4Kphn4IMrWVNcnS18XGPQQHKeAP
        Pt5UUEwYy97CherU6iImNCAYdtHu/7CAD1SIito=
X-Google-Smtp-Source: APXvYqyQZSotBC5QpJ3UAQIVqYBxSYe/ET0fiP9HIck+vOonE/4njZIWinONYh1FY5DYJRQwr6Pbh5mNC4Vg8lC2aEk=
X-Received: by 2002:a05:6402:896:: with SMTP id e22mr106635474edy.202.1564626138515;
 Wed, 31 Jul 2019 19:22:18 -0700 (PDT)
MIME-Version: 1.0
References: <20190731122224.1003-1-hslester96@gmail.com> <CACKFLinuFebDgJN=BgK5e-bNaFqNpk61teva0=2xMH6R_iT39g@mail.gmail.com>
In-Reply-To: <CACKFLinuFebDgJN=BgK5e-bNaFqNpk61teva0=2xMH6R_iT39g@mail.gmail.com>
From:   Chuhong Yuan <hslester96@gmail.com>
Date:   Thu, 1 Aug 2019 10:22:07 +0800
Message-ID: <CANhBUQ1J8hXBZv4x3pJhG_08ZS1zR=9Uj2EUta2sgtyND_QKPw@mail.gmail.com>
Subject: Re: [PATCH 2/2] cnic: Use refcount_t for refcount
To:     Michael Chan <michael.chan@broadcom.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Netdev <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Michael Chan <michael.chan@broadcom.com> =E4=BA=8E2019=E5=B9=B48=E6=9C=881=
=E6=97=A5=E5=91=A8=E5=9B=9B =E4=B8=8A=E5=8D=881:58=E5=86=99=E9=81=93=EF=BC=
=9A
>
> On Wed, Jul 31, 2019 at 5:22 AM Chuhong Yuan <hslester96@gmail.com> wrote=
:
>
> >  static void cnic_ctx_wr(struct cnic_dev *dev, u32 cid_addr, u32 off, u=
32 val)
> > @@ -494,7 +494,7 @@ int cnic_register_driver(int ulp_type, struct cnic_=
ulp_ops *ulp_ops)
> >         }
> >         read_unlock(&cnic_dev_lock);
> >
> > -       atomic_set(&ulp_ops->ref_count, 0);
> > +       refcount_set(&ulp_ops->ref_count, 0);
> >         rcu_assign_pointer(cnic_ulp_tbl[ulp_type], ulp_ops);
> >         mutex_unlock(&cnic_lock);
> >
>
> Willem's comment applies here too.  The driver needs to be modified to
> count from 1 to use refcount_t.
>
> Thanks.

I have revised this problem but find the other two refcounts -
cnic_dev::ref_count
and cnic_sock::ref_count have no set.
I am not sure where to initialize them to 1.

Besides, should ulp_ops->ref_count be set to 0 when unregistered?
