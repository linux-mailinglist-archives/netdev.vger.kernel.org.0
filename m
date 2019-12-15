Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6508A11FB04
	for <lists+netdev@lfdr.de>; Sun, 15 Dec 2019 21:21:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726514AbfLOUSx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 15 Dec 2019 15:18:53 -0500
Received: from mail-yw1-f65.google.com ([209.85.161.65]:36411 "EHLO
        mail-yw1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726146AbfLOUSx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 15 Dec 2019 15:18:53 -0500
Received: by mail-yw1-f65.google.com with SMTP id n184so1766494ywc.3
        for <netdev@vger.kernel.org>; Sun, 15 Dec 2019 12:18:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=NRCSA5JVeFzC2zi2cCyEn14IU+bP47l+q9q1ADgFMR4=;
        b=YOoOhFR2SfyYREiauUEjddxm/mD11gfCE45oYf3OEyZv8G8MNhNw3B3uW82PTdWpjM
         yA9p80w4g96fHFdCbL/WxhizHgdA+vutkwc0FFvdnAHhj8tbsxPLPlgP6IAKyFG57ma2
         r+9QO3evhPhoX56xUH7AoDpJTKnUnoeR6lntgOvLwabvZcgBR7mmVBtQ5mxeelUnJqX2
         1vsPJp+aBeeI5PO3A/3d9f7j19xXchDYSjv9xBu3DWLPFgEd9viYWliNMxHcM6lO8HIc
         njkM1O/AyDCqqFPGjKJwVplBaGach8J6PJh/kMXbyJIWjDh7ZfFinwlf11CV06MCpKKJ
         QNiA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=NRCSA5JVeFzC2zi2cCyEn14IU+bP47l+q9q1ADgFMR4=;
        b=SvzT9091q2+57NzC2EGyX+H2zhybvgkMdRdAsOXT3nP/rchmxfEzfKPszf9F3qhQEB
         HfAaS8oAN2/jHO8ei7c+L6QHLKjhBfjeK4PxISrj0cEVhJQ9txH05Wxq3EeeORMABTUX
         cGrRHAO7nOQz5h28Oid9IKeXwiRZtputwsjwayY+DaNR+gZ2NLrap65bUjrLr7MuyqDU
         5dU2aWqXKhBqtvbKmvDFoq3EFQUcXg7MBBE3mBIQ+oRdQ4TCAJHvFrz2kZYZVmeF8AyZ
         N+wt5zI+djDb0Og/jqKTZaepjYp7IEnmi7GnjUkl6HCUpvz/zwPXY8fdCLjMndW0FlfH
         ll3Q==
X-Gm-Message-State: APjAAAXeVYeI/LhRRuLaNndyHCu1LqqLDI7MBaW4ZtBqdeLVk7YzGnUV
        nCyaLruDIKlnRGFzqsQShE6+X6np9iY7PRSZlylxwQ==
X-Google-Smtp-Source: APXvYqw4nPk9roXKXQiWkGrs5wPLPAw0Lr0Yi+ueLf4Ggg0fTEXOPr+KOPEiFrfhwvPdrpDG/qYnnL0BgwJTqHiS6Is=
X-Received: by 2002:a81:50c3:: with SMTP id e186mr16591565ywb.160.1576441132060;
 Sun, 15 Dec 2019 12:18:52 -0800 (PST)
MIME-Version: 1.0
References: <20191206234455.213159-1-maheshb@google.com> <10902.1575756592@famine>
 <CAF2d9jgjeky0eMgwFZKHO_RLTBNstH1gCq4hn1FfO=TtrMP1ow@mail.gmail.com>
 <26918.1576132686@famine> <CAF2d9jh7WAydcm79VYZLb=A=fXo7B7RDiMquZRJdP2fnwnLabg@mail.gmail.com>
 <26868.1576268917@famine> <20191214162912.41936ef1@cakuba.netronome.com>
In-Reply-To: <20191214162912.41936ef1@cakuba.netronome.com>
From:   =?UTF-8?B?TWFoZXNoIEJhbmRld2FyICjgpK7gpLngpYfgpLYg4KSs4KSC4KSh4KWH4KS14KS+4KSwKQ==?= 
        <maheshb@google.com>
Date:   Sun, 15 Dec 2019 12:18:36 -0800
Message-ID: <CAF2d9jhfhyozw8VkRz80AZAVQB==f8G3ga_1rMuj3YehHyGZGA@mail.gmail.com>
Subject: Re: [PATCH net] bonding: fix active-backup transition after link failure
To:     Jakub Kicinski <jakub.kicinski@netronome.com>
Cc:     Jay Vosburgh <jay.vosburgh@canonical.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        Veaceslav Falico <vfalico@gmail.com>,
        David Miller <davem@davemloft.net>,
        Netdev <netdev@vger.kernel.org>,
        Mahesh Bandewar <mahesh@bandewar.net>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Dec 14, 2019 at 4:29 PM Jakub Kicinski
<jakub.kicinski@netronome.com> wrote:
>
> On Fri, 13 Dec 2019 12:28:37 -0800, Jay Vosburgh wrote:
> >       Ok, I think I understand, and am fine with the patch as-is.
> >
> > Acked-by: Jay Vosburgh <jay.vosburgh@canonical.com>
>
> Okay, applied then, and queued for 4.14+ stable.
>
> Mahesh, I reworded the commit message slightly, checkpatch insists
> that the word "commit" occurs before the hash when quoting.
>
Thanks and good to know, I'll keep that in mind.

> Thanks!
