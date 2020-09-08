Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 237DB261478
	for <lists+netdev@lfdr.de>; Tue,  8 Sep 2020 18:23:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731904AbgIHQXK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Sep 2020 12:23:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58180 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731192AbgIHQWM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Sep 2020 12:22:12 -0400
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC261C061374;
        Tue,  8 Sep 2020 05:45:38 -0700 (PDT)
Received: by mail-pj1-x102d.google.com with SMTP id b16so8234990pjp.0;
        Tue, 08 Sep 2020 05:45:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=jhHypeLTRA4WXxhhuo6Z6j83RXXSW7eZ7o0xAUpwRko=;
        b=WYKxTMjhCEq3m5vySflh4N7bV6WzAwoHVDwnzWmDuvMlUJQQTYUjRRQrQ1HRFyImD6
         ARHK1Gga6jFz0A0tT9XZCQOyxKpp2fSboNAWVfGB7Fc9x5CDDDVQTESefH43SmG5Ubag
         0O7upG16zrl5k74HF5oKkZlLqAYvSAv9dK2XPLZSOC6w1xowlI4LXHsW1Z7CqsmB03Vh
         +3OTgSWBIMK36QOK71xW0sjXtkESECjQEqIycmMsrjdzZc/+KT54hSVfaOj0R6Aro5Mb
         2ZXppdSSRwH+2qL2ZJqr6KHK4j8mLTt5Dh19wFsqNl5SjHS542eBkah5tHd30rej+n+7
         uwHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=jhHypeLTRA4WXxhhuo6Z6j83RXXSW7eZ7o0xAUpwRko=;
        b=r+4yPV9ulkUASdNbZ3E6zAO5hYQ6kobKbCu6LKqhgAiZc+tnCm+3GxZNs7EkPjLTsJ
         4heTHCTF97pUsCZfdjKo9TJFMnlcYw+GLI4IbIukRAvPimrWT9n4698Rb3XIkIjjm2WU
         Nstaqd/qUV7+MK4IOHDWHHTYOLSEk4is8U4X8RgcmedKZF4ceIvzjaRHjV6UbJJ8zBhZ
         ukPRjJPpCoY4AmsR57L613auaQDKqmccStMP7jhsJvWHrCfs1uHcD+DbjLr8NJTYjfop
         NP5n1iQPRgRVnntY9ZkdwXtmnIQ975Ooj3lJyZlSg7orjwSNyRlxvDNf2xB35X1GwTa9
         Fq3Q==
X-Gm-Message-State: AOAM533UOHS4nPtWAp7ePBuOz8Zx9YTMgoUYFCf+OYu30lDW3uDF7q4r
        7STX9k/9fw8vi8zkozGbj9iezMbJbej068VC21Y=
X-Google-Smtp-Source: ABdhPJw8LTt+XXaAgFIKLhZcvCAflJODmJdMFXBFRgAFnhCwPcvxTBBWUsyrjeSl3fonexRUaflNzJYkjYk5w6tS5WE=
X-Received: by 2002:a17:90a:bd02:: with SMTP id y2mr3900886pjr.66.1599569138277;
 Tue, 08 Sep 2020 05:45:38 -0700 (PDT)
MIME-Version: 1.0
References: <CAJht_EOu8GKvdTAeF_rHsaKu7iYOmW8C64bQA21bgKuiANE5Zw@mail.gmail.com>
 <CAJht_EP=g02o2ygihNo=EWd1OuL3HSjmhqgGiwUGrMde=urSUA@mail.gmail.com>
 <CA+FuTSdm35x9nA259JgOWcCWJto9MVMHGGgamPPsgnpsTmPO8g@mail.gmail.com>
 <CAJht_EPEqUMXNdQLL9d5OtzbZ92Jms7nSUR8bS+cw2Ah5mv6cQ@mail.gmail.com>
 <CA+FuTSeJS22R2VYSzcEVvXiUhX79RYE0o3G6V3NKGzQ4UGaJQg@mail.gmail.com>
 <CAJht_EN7SXAex-1W49eY7q5p2UqLYvXA8D6hptJGquXdJULLcA@mail.gmail.com> <CA+FuTSfgxt6uqcxy=wnOXo8HxMJ3J0HAqQNiDJBLCs22Ukb_gQ@mail.gmail.com>
In-Reply-To: <CA+FuTSfgxt6uqcxy=wnOXo8HxMJ3J0HAqQNiDJBLCs22Ukb_gQ@mail.gmail.com>
From:   Xie He <xie.he.0141@gmail.com>
Date:   Tue, 8 Sep 2020 05:45:27 -0700
Message-ID: <CAJht_EN-aBo8rfHAxYxwW2Jb38S2PW3WtxhWuHn5HS1fAWeA1w@mail.gmail.com>
Subject: Re: Question about dev_validate_header used in af_packet.c
To:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Cc:     Eric Dumazet <eric.dumazet@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Sep 8, 2020 at 4:53 AM Willem de Bruijn
<willemdebruijn.kernel@gmail.com> wrote:
>
> On Tue, Sep 8, 2020 at 1:04 PM Xie He <xie.he.0141@gmail.com> wrote:
> >
> > I was recently looking at some drivers, and I felt that if af_packet.c
> > could help me filter out the invalid RAW frames, I didn't need to
> > check the validity of the frames myself (in the driver when
> > transmitting). But now I guess I still need to check that.
> >
> > I feel this makes the dev_validate_header's variable-length header
> > check not very useful, because drivers need to do this check again
> > (when transmitting) anyway.
> >
> > I was thinking, after I saw dev_validate_header, that we could
> > eventually make it completely take over the responsibility for a
> > driver to validate the header when transmitting RAW frames. But now it
> > seems we would not be able to do this.
>
> Agreed. As is, it is mainly useful to block users who are ns_capable,
> but not capable.
>
> A third option is to move it behind a sysctl (with static_branch). Your
> point is valid that there really is no need for testing of drivers against
> bad packets if the data is validated directly on kernel entry.

I was thinking about this again and it came to me that maybe sometimes
people actually wanted to send invalid frames on wire (for testing the
network device on the other end of the wire)? Having thought about
this possibility I think it might be good to keep the ability for
people to have 2 choices (either having their RAW frames validated, or
not validated) through "capability" or through "sysctl" as you
mentioned. We can keep the default to be not validating the RAW frames
because RAW sockets are already intended for very special use and are
not for normal use.
