Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C3367322DC
	for <lists+netdev@lfdr.de>; Sun,  2 Jun 2019 11:54:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726168AbfFBJyg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 2 Jun 2019 05:54:36 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:43179 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725977AbfFBJyg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 2 Jun 2019 05:54:36 -0400
Received: by mail-wr1-f65.google.com with SMTP id r18so284616wrm.10
        for <netdev@vger.kernel.org>; Sun, 02 Jun 2019 02:54:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=+DvvLTaJz6eu1D4oOEh8Bf5QB1HHr7/L5LVBEkXxRSA=;
        b=XCuuyQnl0s/+OyeHexoTzPYkMXx0wurnoj88iijXpDrUM9fJ8tO0i6oRylUtY6LL57
         r50/Kzd/0K4+4kX9f3zFFP9SsSXDn8BnQieYY+md0p3S5ms+emqe4JvqPMYYgUZNkxpw
         dba8c69S/ec5kA0wLUs1EVjsFjFZckxEO9efpGay9CdB1OPwS+4UAzAMDDYuBcD5uKx6
         DU2x9LOcseXxqMwizJF7UDXFvjwwtGEKQzXMFk0wh69cCwVmpDam5jv92mq5Rqra8z6E
         qTKL2hJplewawQ29gzovVz0OcbOQlKRKCvxv6LXYAy34OhFUX+VLDP537/M+32x9k4vF
         mTNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=+DvvLTaJz6eu1D4oOEh8Bf5QB1HHr7/L5LVBEkXxRSA=;
        b=OJtmaUGdWTM4KtFnRapuf8IptGgADP4opzQLLK/BZqUdAJ5bWqU1rACrasX7ovEM3K
         IOwqx8BWdYOP9Yg/bzyq/f1v/tOG5ULwzE3OHiQBLIHo0jTDmb8plawUX3tnQiFhXzf4
         xRwng007+NdayanAGjUe8x1glYSy/Pl5hIOhG4nool2DhzqLpCBR4CIfh/Mb+nx/SxMf
         bYiLsGqREUzqut1RI0kS8F1BWD1MlVZY9yioVplT3IKhMM/tDq+BGgtxh8zM8Zamn1VZ
         pbm6iL1j6dOE9i/84+kNQ38WUAD5ov8BYrg9pZU+fJtgwjbGh7RGA9waWWwYZiaRHvR+
         w0oA==
X-Gm-Message-State: APjAAAWftOwN1pt/4eoZCPAZI/Z+rAVbH1HEVSL+KZXLiNhLHaM0Ep9Q
        lrIsucoWdI6Y8EEarbk6zyO3+nfxHh0=
X-Google-Smtp-Source: APXvYqxIMD720mjcHZBqofcZELyqOJU4yp5UMbiJLqMDBWZfyxuQSvsy31rh/sjFbpRnIASUsCvmwQ==
X-Received: by 2002:adf:b6a5:: with SMTP id j37mr13073713wre.4.1559469274202;
        Sun, 02 Jun 2019 02:54:34 -0700 (PDT)
Received: from ahabdels-m-j3jg ([51.179.104.116])
        by smtp.gmail.com with ESMTPSA id p16sm22071703wrg.49.2019.06.02.02.54.32
        (version=TLS1 cipher=AES128-SHA bits=128/128);
        Sun, 02 Jun 2019 02:54:33 -0700 (PDT)
Date:   Sun, 2 Jun 2019 11:54:30 +0200
From:   Ahmed Abdelsalam <ahabdels.dev@gmail.com>
To:     Tom Herbert <tom@herbertland.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        dlebrun@google.com, Tom Herbert <tom@quantonium.net>
Subject: Re: [RFC PATCH 6/6] seg6: Add support to rearrange SRH for AH ICV
 calculation
Message-Id: <20190602115430.a726f7dd2a2f5b873d4a0537@gmail.com>
In-Reply-To: <CALx6S34m31vQQoy6-Esf9N3nYBUhQPMubPC3tXqT6RQbKzkhCQ@mail.gmail.com>
References: <1559321320-9444-1-git-send-email-tom@quantonium.net>
        <1559321320-9444-7-git-send-email-tom@quantonium.net>
        <20190531190704.07285053cb9a1d193f7b061d@gmail.com>
        <CALx6S34m31vQQoy6-Esf9N3nYBUhQPMubPC3tXqT6RQbKzkhCQ@mail.gmail.com>
X-Mailer: Sylpheed 3.4.1 (GTK+ 2.24.21; x86_64-apple-darwin10.8.0)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 31 May 2019 10:34:03 -0700
Tom Herbert <tom@herbertland.com> wrote:

> On Fri, May 31, 2019 at 10:07 AM Ahmed Abdelsalam
> <ahabdels.dev@gmail.com> wrote:
> >
> > On Fri, 31 May 2019 09:48:40 -0700
> > Tom Herbert <tom@herbertland.com> wrote:
> >
> > > Mutable fields related to segment routing are: destination address,
> > > segments left, and modifiable TLVs (those whose high order bit is set).
> > >
> > > Add support to rearrange a segment routing (type 4) routing header to
> > > handle these mutability requirements. This is described in
> > > draft-herbert-ipv6-srh-ah-00.
> >
> > Hi Tom,
> > Assuming that IETF process needs to be fixed, then, IMO, should not be on the cost of breaking the kernel process here.
> 
> Ahmed,
> 
> I do not see how this is any way breaking the kernel process. The
> kernel is beholden to the needs of users provide a robust and secure
> implementations, not to some baroque IETF or other SDO processes. When
> those are in conflict, the needs of our users should prevail.
> 
> > Let us add to the kernel things that have been reviewed and reached some consensus.
> 
> By that argument, segment routing should never have been added to the
> kernel since consensus has not be reached on it yet or at least
> portions of it. In fact, if you look at this patch set, most of the
> changes are actually bug fixes to bring the implementation into
> conformance with a later version of the draft. For instance, there was
> never consensus reached on the HMAC flag; now it's gone and we need to
> remove it from the implementation.
> 
> > For new features that still need to be reviewed we can have them outside the kernel tree for community to use.
> > This way the community does not get blocked by IETF process but also keep the kernel tree stable.
> 
> In any case, that does not address the issue of a user using both
> segment routing and authentication which leads to adverse behaviors.
> AFAICT, the kernel does not prevent this today. So I ask again: what
> is your alternative to address this?
> 
> Thanks,
> Tom

Tom,
Yes, the needs for users should prevail. But it’s not Tom or Ahmed alone who should define users needs. 
The comparison between "draft-herbert-ipv6-srh-ah-00" and "draft-ietf-6man-segment-routing-header" is
missing some facts. The first patch of the SRH implementation was submitted to the kernel two years after
releasing the SRH draft. By this time, the draft was a working group adopted and co-authored by several
vendors, operators and academia. Please refer to the first SRH patch submitted to the kernel
(https://patchwork.ozlabs.org/patch/663176/). I still don’t see the point of rushing to upstream something 
that has been defined couple of days ago. Plus there is nothing that prevents anyone to "innovate" in his 
own private kernel tree.

-- 
Ahmed Abdelsalam <ahabdels.dev@gmail.com>
