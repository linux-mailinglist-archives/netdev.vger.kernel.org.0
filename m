Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6E0C229610D
	for <lists+netdev@lfdr.de>; Thu, 22 Oct 2020 16:40:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2900998AbgJVOkM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Oct 2020 10:40:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35010 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2900978AbgJVOkL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Oct 2020 10:40:11 -0400
Received: from mail-ua1-x941.google.com (mail-ua1-x941.google.com [IPv6:2607:f8b0:4864:20::941])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4824BC0613CE
        for <netdev@vger.kernel.org>; Thu, 22 Oct 2020 07:40:11 -0700 (PDT)
Received: by mail-ua1-x941.google.com with SMTP id x26so529195uau.0
        for <netdev@vger.kernel.org>; Thu, 22 Oct 2020 07:40:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=vt5F6KjNkmlnBeWxGhnHoc3bQg0jZFtZbaw7129oA3s=;
        b=AMq0UAvnkW9myH4lLhbH+zoRftq1BDpywSbP4m1vMOrJY5t7cbM/YtIkVDUP5xeT0J
         1KbN8Gi3+0lJt8qnnh+DMvPen9E1qzHSpLp58y24FLTKL+q86DTqgfZM0SOXoBHsmDpT
         hdoke0YqHf1CWFAsGvIuYcHYGOf4PIsdV3ISB0CbQCzbxfZRO6xw6dmlIIXvpScLOZdA
         FHTX+1EMkn3B4clOVJTH8ifvnDkYotwKqJbOA8/evkWVEU/As3rvDJaGcw19xPMUBiPa
         UnIvKouiJ+bgOR4qztjhYxyt7JZ1LE9CRmI52bt++aNtmanfU1yjfhjQuOOTsWd3z8J8
         9JeQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=vt5F6KjNkmlnBeWxGhnHoc3bQg0jZFtZbaw7129oA3s=;
        b=GGSMGZp3ePc0If8TX09bMGU2mqDR970FNvdJ6PeQppYOU2cSV/tIXZTUOj4lc6ooiO
         KSY6AJc93uj6mdFmI9iy1OV03JUtnXzs+6VE0UIN88SMu+ZNbdekJqMqFUaPgj7kanYK
         1mkUECOojvNCsAl4UrjD4IEfHo78l2rLhp9ApSACMqp245wAe4STKsPn+Kqp1nBFSu+z
         u7K4V4Sob7SCNuv3ALRJOxmApra2QhUfkGh+KOQRAVKk92WFRzEhiUP0v38p7R0TZfer
         OjcV1gEkMBBKTwSncxsbvOOBpgRkLKyKAAZ4zLwHJy51Ep4fTrb6oJceTGhmtoYiCgVw
         056Q==
X-Gm-Message-State: AOAM532t1WLYuCZWyxZ9jD3vjsBmEJvrjKzZIeFnJXxHQDkUGkxgKRVp
        2J/qSqavt+W/tXHJ3nkqpovs6LJFGE4ekQlcWAWGE+mWOeS4fg==
X-Google-Smtp-Source: ABdhPJxpQwR1l/zSQXGR1FZ+gBuONWjh6daQsMmfwnlDyM+b1IPMRUdELKqO7YXucWygIf2luKJLzPX4iaqSBD6xaqo=
X-Received: by 2002:ab0:5b55:: with SMTP id v21mr1521733uae.65.1603377609017;
 Thu, 22 Oct 2020 07:40:09 -0700 (PDT)
MIME-Version: 1.0
References: <87eelz4abk.fsf@marvin.dmesg.gr> <CADVnQym6OPVRcJ6PdR3hjN5Krcn0pugshdLZsrnzNQe1c52HXA@mail.gmail.com>
 <CAK6E8=fCwjP47DvSj4YQQ6xn25bVBN_1mFtrBwOJPYU6jXVcgQ@mail.gmail.com>
 <87blh33zr7.fsf@marvin.dmesg.gr> <CADVnQym2cJGRP8JnRAdzHfWEeEbZrmXd3eXD-nFP6pRNK7beWw@mail.gmail.com>
 <878sc63y8j.fsf@marvin.dmesg.gr> <87eelqs9za.fsf@marvin.dmesg.gr>
In-Reply-To: <87eelqs9za.fsf@marvin.dmesg.gr>
From:   Neal Cardwell <ncardwell@google.com>
Date:   Thu, 22 Oct 2020 10:39:51 -0400
Message-ID: <CADVnQy=owUxBjPcHC1u0Xn_Uwd3wBVoQFO+5Wo-TzO0=1+3HMQ@mail.gmail.com>
Subject: Re: TCP sender stuck in persist despite peer advertising non-zero window
To:     Apollon Oikonomopoulos <apoikos@dmesg.gr>
Cc:     Yuchung Cheng <ycheng@google.com>, Netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Soheil Hassas Yeganeh <soheil@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 22, 2020 at 8:47 AM Apollon Oikonomopoulos <apoikos@dmesg.gr> wrote:
>
> Apollon Oikonomopoulos <apoikos@dmesg.gr> writes:
> > We are now running the patched kernel on the machines involved. I want
> > to give it some time just to be sure, so I'll get back to you by
> > Thursday if everything goes well.
>
> It has been almost a week and we have had zero hangs in 60 rsync runs,
> so I guess we can call it fixed. At the same time we didn't notice any
> ill side-effects. In the unlikely event it hangs again, I will let you
> know.

Great. Many thanks for your testing and thorough analysis!

I agree that it's a little surprising that this bug would be there for
so long (looks like since Linux v2.1.8 in Nov 1996), but I also agree
with your analysis about why this might be so.

I have posted the proposed patch here:

  https://patchwork.ozlabs.org/project/netdev/patch/20201022143331.1887495-1-ncardwell.kernel@gmail.com/

best,
neal
