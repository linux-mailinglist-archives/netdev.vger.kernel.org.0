Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 82770290B01
	for <lists+netdev@lfdr.de>; Fri, 16 Oct 2020 19:55:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388272AbgJPRzB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Oct 2020 13:55:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58048 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731123AbgJPRzB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 16 Oct 2020 13:55:01 -0400
Received: from mail-vs1-xe30.google.com (mail-vs1-xe30.google.com [IPv6:2607:f8b0:4864:20::e30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C9758C061755
        for <netdev@vger.kernel.org>; Fri, 16 Oct 2020 10:54:59 -0700 (PDT)
Received: by mail-vs1-xe30.google.com with SMTP id r1so1891454vsi.12
        for <netdev@vger.kernel.org>; Fri, 16 Oct 2020 10:54:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=T7RmkCdURX7edIG7MLMiHxalXn5YtiMab+pTqubB6tw=;
        b=MUZiz6bzwdvEZkYGYpJEXkrRo5wGlY8pFogDdaVprzDpbSAkLIc+1tMXaEaLt4Ey1y
         bIl7MnUwj0cchYfy0Y5e+csEBieHnWDFmRlxy5W+Xy4O8gPeGKIKA2MW7Z1iouAZ9tcc
         OXY4f3Bdl/6D7GDMkeRLb5KBnIO4SRQhzRa8mACMcYmf4tv79zu2mPwWS+ugM73xSOvj
         3gG7K2i9AafR+0zNMU4xyW9BFBfWS0dTBc62LqBrECZRab6iRatCLNyK6okJRmyyPGCb
         3OmkAy8aEwD9YRnTS2mDRy5q8NBIEQYlLgvdnMNgTROBzZmjFHgP14i8gY9lBzxT3/GC
         1URg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=T7RmkCdURX7edIG7MLMiHxalXn5YtiMab+pTqubB6tw=;
        b=JwLCEWXAk72hhvA5l9DAJOtixNjorKJAsfjVFmllsBOz6SR6z4/sgiAImPI5ERy/6k
         9UtN/8frSi5MZAusY3gTGXiNYDJJ2RXElR7ge6ZzrIDkQPjB/mY0F+7jefBbx7GTRAHx
         Za6nOmenTcsBQojhhCHi6gLetqMrMUquMsJ8o7fCxX77yBTgYz4elhuiiX+5X3Q1dlZl
         cuTJMAB1FwTQiWbrJF7R7ZZyJmLYBwMQFYVe2AUs/XJS/PiUSWBXEzpjSDQ39gUI6raT
         +5aTw7jIybQh2Wdzq1G8fP3kN5by9YZPpPscCgzsfHNzw4QEHWuy91k2ji+uxVX2t9Ez
         +vHw==
X-Gm-Message-State: AOAM531V92/B2Fc+d1dGxTiQin2bR7/3ijuwjmjJpI1/1yzyEycz/Utm
        7xYhbVOCgEbjCnZPjcNg71/x7HPgfUsPPYczSBpflQ==
X-Google-Smtp-Source: ABdhPJwxuwGVOTSPysQt9ug5K7hY4YgSxIT6hXbqyjNsNYmzmIQ0Xo2QDL/EwRnOaXRJ82JYT3C/CorvfDErgR8kZ40=
X-Received: by 2002:a67:de18:: with SMTP id q24mr3036609vsk.54.1602870898321;
 Fri, 16 Oct 2020 10:54:58 -0700 (PDT)
MIME-Version: 1.0
References: <87eelz4abk.fsf@marvin.dmesg.gr> <CADVnQym6OPVRcJ6PdR3hjN5Krcn0pugshdLZsrnzNQe1c52HXA@mail.gmail.com>
 <CAK6E8=fCwjP47DvSj4YQQ6xn25bVBN_1mFtrBwOJPYU6jXVcgQ@mail.gmail.com>
 <87blh33zr7.fsf@marvin.dmesg.gr> <CADVnQym2cJGRP8JnRAdzHfWEeEbZrmXd3eXD-nFP6pRNK7beWw@mail.gmail.com>
 <878sc63y8j.fsf@marvin.dmesg.gr>
In-Reply-To: <878sc63y8j.fsf@marvin.dmesg.gr>
From:   Neal Cardwell <ncardwell@google.com>
Date:   Fri, 16 Oct 2020 13:54:41 -0400
Message-ID: <CADVnQymc0cVqfBmRVeERrrTOSJOpScdz8_HCU6yDWNREz9TG3g@mail.gmail.com>
Subject: Re: TCP sender stuck in persist despite peer advertising non-zero window
To:     Apollon Oikonomopoulos <apoikos@dmesg.gr>
Cc:     Yuchung Cheng <ycheng@google.com>, Netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Soheil Hassas Yeganeh <soheil@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Oct 16, 2020 at 12:57 PM Apollon Oikonomopoulos
<apoikos@dmesg.gr> wrote:
>
> Neal Cardwell <ncardwell@google.com> writes:
> > On Thu, Oct 15, 2020 at 6:12 PM Apollon Oikonomopoulos <apoikos@dmesg.gr> wrote:
> >> Neal, would it be possible to re-send the patch as an attachment? The
> >> inlined version does not apply cleanly due to linewrapping and
> >> whitespace changes and, although I can re-type it, I would prefer to test
> >> the exact same thing that would be merged.
> >
> > Sure, I have attached the "git format-patch" format of the commit. It
> > does seem to apply cleanly to the v4.9.144 kernel you mentioned you
> > are using.
> >
> > Thanks for testing this!
>
> We are now running the patched kernel on the machines involved. I want
> to give it some time just to be sure, so I'll get back to you by
> Thursday if everything goes well.

Great. Thanks, Apollon, for testing this!

Thanks, Eric. I will include the link you suggested in the next rev of
the patch.

thanks,
neal
