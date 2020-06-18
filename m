Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2C24A1FFBCB
	for <lists+netdev@lfdr.de>; Thu, 18 Jun 2020 21:28:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728386AbgFRT2L (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Jun 2020 15:28:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44924 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726879AbgFRT2J (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Jun 2020 15:28:09 -0400
Received: from mail-io1-xd42.google.com (mail-io1-xd42.google.com [IPv6:2607:f8b0:4864:20::d42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98B4FC06174E;
        Thu, 18 Jun 2020 12:28:09 -0700 (PDT)
Received: by mail-io1-xd42.google.com with SMTP id h4so819204ior.5;
        Thu, 18 Jun 2020 12:28:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=2r/eBSRHwhICENHrw3CBIAzj43f+ABt0HR5OQ089hu0=;
        b=BtM/gutfGJHtM11Jf9/v446Zf9RvLqmaeBIDWHG6G2ucdVNCI233pCswnZ80j8+FYa
         46KUD4zDUIp5KUiQIm9+eq8/vwV9bebJDLpFSc3qwlZsGzjyG9lcGCz9VShWnkGsxyG8
         YHjcHB6FUSRjtpHF8s47A45wU8sBLqzHD/fv74QdPhso3ZNeDN91EwVFJKmX+Ba0uaSa
         Dhtqd8iSVzJqBJEPbZG7MTQQId58Injtd5bvcDwRNLpLMfb6wMdDySJcnze/ygOyd20+
         rV7NXEooNHMYsU6q+u2vn0yuHl0tI0W22sNwe14f+MAgSe7jdESdqq65lzKvmv8VH9bN
         3Bnw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=2r/eBSRHwhICENHrw3CBIAzj43f+ABt0HR5OQ089hu0=;
        b=VlgReaU0mslm8L/dxXvMuevdhCwj5mrq/k+Ayvk+WvY0oUUeWUfbC8Wxu+0POTVny/
         F5WaAeZ3/xMDUG/KEsgaY5NUkUNtIfvCFDCnA+qYunr4DbRlBxLQZnWq8qJkjeDxyVse
         ZXo8ogj5dQ5NzWP8KevdzGnHNEqXWggPchkyeUCfab3L2owNqeTYd6yFmLyaZPkMUAp2
         94IvXXoGw+0ZpXgKt0uQtUMvmAVn3nbjj94KzaCGJ1ifOfAEwgp8GXMe+khJp6MOggr/
         mU3pQdAPwVyqadwN76JYP8TstKkSXjwXHQ9/OAPf7vTD/O6Wsj9lAKQEDFL6Na/qR5gV
         r5vg==
X-Gm-Message-State: AOAM5323RJVBi2riZCSfclb57fnuDrl2nqWzz+yjTjh4HSXL+1ROVSWo
        rW/vi4gfDIMStjWmUWXbrbQ6QN9+PmH2by3HVuw=
X-Google-Smtp-Source: ABdhPJy3XGVVGxJ8arfWbqO0G1lLD28MUnxV6J8S6Ws55u6ixT26Q0Y9z2AtDMJGarttiZU3ejUeWcvCgdJbL7SB5oI=
X-Received: by 2002:a05:6638:d05:: with SMTP id q5mr196255jaj.2.1592508488960;
 Thu, 18 Jun 2020 12:28:08 -0700 (PDT)
MIME-Version: 1.0
References: <20200618183417.5423-1-alexander.kapshuk@gmail.com> <20200618190934.GB20699@nautica>
In-Reply-To: <20200618190934.GB20699@nautica>
From:   Alexander Kapshuk <alexander.kapshuk@gmail.com>
Date:   Thu, 18 Jun 2020 22:27:32 +0300
Message-ID: <CAJ1xhMW6_EdCh7TB0L5RD9BkjtozHtv2hbTWRzJ=S9Fq9eefew@mail.gmail.com>
Subject: Re: [PATCH] net/9p: Fix sparse endian warning in trans_fd.c
To:     Dominique Martinet <asmadeus@codewreck.org>
Cc:     ericvh@gmail.com, lucho@ionkov.net, davem@davemloft.net,
        kuba@kernel.org, v9fs-developer@lists.sourceforge.net,
        netdev@vger.kernel.org, linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jun 18, 2020 at 10:09 PM Dominique Martinet
<asmadeus@codewreck.org> wrote:
>
> Alexander Kapshuk wrote on Thu, Jun 18, 2020:
> > Address sparse endian warning:
> > net/9p/trans_fd.c:932:28: warning: incorrect type in assignment (different base types)
> > net/9p/trans_fd.c:932:28:    expected restricted __be32 [addressable] [assigned] [usertype] s_addr
> > net/9p/trans_fd.c:932:28:    got unsigned long
> >
> > Signed-off-by: Alexander Kapshuk <alexander.kapshuk@gmail.com>
>
> INADDR_ANY is 0 so this really is noop but sure, less warnings is always
> good. I'll take this one for 5.9.
> Thanks!
> --
> Dominique

Noted.
Thanks.
