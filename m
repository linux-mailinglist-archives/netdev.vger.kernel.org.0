Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3BEC5C3FC1
	for <lists+netdev@lfdr.de>; Tue,  1 Oct 2019 20:24:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732216AbfJASYG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Oct 2019 14:24:06 -0400
Received: from mail-lf1-f68.google.com ([209.85.167.68]:43777 "EHLO
        mail-lf1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731560AbfJASYG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Oct 2019 14:24:06 -0400
Received: by mail-lf1-f68.google.com with SMTP id u3so10661155lfl.10;
        Tue, 01 Oct 2019 11:24:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=xsb8X67G1dgu/8EsNnROg1igCsh1++gnvS+/mAQM0dU=;
        b=V/FIMLaPog/lK3+LFmJucz8381bvDo5ayEdKyZgtHCDNw7ntbb/uvHcVtBZ9whSuiN
         4NLT7UbPei21ad3LRXwWzQp1+Ax4bwIjb8IDNZtBGspToZ1ebYILzy07ZWKP0qTWpQ4E
         hQIOrssNVxZdYNTWni+0WECaLpeEPJQ6P9KgJR1A8KhmpXQmJx13HAocjl61fQ6HI9VI
         oXhV5DFfGXbQqJCQLGQD9YXyA3jeVIqSRNwPytThbz46vGCkQFgkT6CWvjrbNjCiKP7z
         cm5h0/KOxUg+CPKrlDWuRRX1AVfSMMR0C5fjjnVu5mN7zMvGL9toRQcJm9pQ4zWN7BAF
         mSUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=xsb8X67G1dgu/8EsNnROg1igCsh1++gnvS+/mAQM0dU=;
        b=BlOhKQdgYYFYw2Ivt600IpdywLZ8Q7krTmEikb78V7aZRRtlrguGmlYxUYqeWkDENz
         k8/auBALrEkc79fvTSVMgSVYCLMShBXGIOgm+TRsCNZDMFwC80C+6HxwUxRh1bdDlSZ5
         J1fesd2o+FwDvU2zFYkvFWL++US4TM+rWAaiRYrRP5n3y2K2NtmP74fOY6wrk9TyvRX2
         6/upCse7cPXmfmEDTNS/mQA62vKvcE67yIY4oSsGjc0K/Vroz3i2Kha4Zb2c+SWexlv+
         WLxIQmUg2Q8OwaSdDXsSSaiBkKXu8uM/0VORIx8/yB5K7tP96OoQ4BnM6gt1UnzkgAMB
         SDCw==
X-Gm-Message-State: APjAAAU1O4Bk8gbos85/cIKf4KgMx6e1dv3PRF+iRZDZpLQ5qkavJJn9
        3ZgjvqYNCbQl2CHsT2SSVtElfJMezwrSWvyKhog=
X-Google-Smtp-Source: APXvYqy//C5+mNC2SlSAWAkfG107LouiPyJyATxU/tw4ZQCaMxuKXdE/Ray9bj9ZbDnhwVc7b6IbwwTvWSRztK4UrPk=
X-Received: by 2002:a19:cc15:: with SMTP id c21mr15571875lfg.64.1569954244189;
 Tue, 01 Oct 2019 11:24:04 -0700 (PDT)
MIME-Version: 1.0
References: <20190928164843.31800-1-ap420073@gmail.com> <20190928164843.31800-2-ap420073@gmail.com>
 <d1b5d944fef2a2d5875a0f12f3cdc490586da475.camel@sipsolutions.net>
 <CAMArcTUgcPv+kg5rhw0i2iwX-CiD00v3ZCvw0b_Q0jb_-eo=UQ@mail.gmail.com>
 <39e879f59ad3b219901839d1511fc96886bf94fb.camel@sipsolutions.net>
 <CAMArcTW6q=ga1juv_Qp-dKwRwxneAEsX4xQxN-n19oWM-VUQ+w@mail.gmail.com> <9bbf73e318df17d179014937cb6c1335fb303611.camel@sipsolutions.net>
In-Reply-To: <9bbf73e318df17d179014937cb6c1335fb303611.camel@sipsolutions.net>
From:   Taehee Yoo <ap420073@gmail.com>
Date:   Wed, 2 Oct 2019 03:23:52 +0900
Message-ID: <CAMArcTX7RLaqxYXMfKbC5Kw0JdXauwaxRQGxh=bZqqYafYAPLQ@mail.gmail.com>
Subject: Re: [PATCH net v4 01/12] net: core: limit nested device depth
To:     Johannes Berg <johannes@sipsolutions.net>
Cc:     David Miller <davem@davemloft.net>,
        Netdev <netdev@vger.kernel.org>, linux-wireless@vger.kernel.org,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        j.vosburgh@gmail.com, vfalico@gmail.com,
        Andy Gospodarek <andy@greyhouse.net>,
        =?UTF-8?B?SmnFmcOtIFDDrXJrbw==?= <jiri@resnulli.us>,
        sd@queasysnail.net, Roopa Prabhu <roopa@cumulusnetworks.com>,
        saeedm@mellanox.com, manishc@marvell.com, rahulv@marvell.com,
        kys@microsoft.com, haiyangz@microsoft.com,
        Stephen Hemminger <stephen@networkplumber.org>,
        sashal@kernel.org, hare@suse.de, varun@chelsio.com,
        ubraun@linux.ibm.com, kgraul@linux.ibm.com,
        Jay Vosburgh <jay.vosburgh@canonical.com>,
        Cody Schuffelen <schuffelen@google.com>, bjorn@mork.no
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 1 Oct 2019 at 22:57, Johannes Berg <johannes@sipsolutions.net> wrote:
>
> Hi,
>

Hi!

> (jumping out now, forgive me for being so brief)
>
> > If I understand correctly, you said about the alignment of
> > "lower_level" and "upper_level".
> > I thought this place is a fine position for variables as regards the
> > alignment and I didn't try to put each variable in different places.
> >
> > If I misunderstood your mention, please let me know.
>
> Not sure what you mean, alignment doesn't matter for them (they're u8).
>
> I was thinking of the packing for the overall struct, we have:
>
>         unsigned int            max_mtu;
>         unsigned short          type;
>         unsigned short          hard_header_len;
>         unsigned char           min_header_len;
>
> +       unsigned char           upper_level, lower_level;
>
>         unsigned short          needed_headroom;
>         unsigned short          needed_tailroom;
>
>
> Previously, there was a one byte hole at that spot due to a single
> "unsigned char" (after something aligned at least 4 bytes) followed by
> "unsigned short" - now you push that out a bit.
>
> If you place the variables a bit lower, below "name_assign_type", you
> probably fill a hole instead.
>
> Check out the 'pahole' tool.
>

Thank you for the detailed explanation.
I tested the pahole and found holes.

$ pahole ./vmlinux.o -C net_device
        unsigned char              addr_assign_type;     /*   598     1 */
        unsigned char              addr_len;             /*   599     1 */
        short unsigned int         neigh_priv_len;       /*   600     2 */
        short unsigned int         dev_id;               /*   602     2 */
        short unsigned int         dev_port;             /*   604     2 */

        /* XXX 2 bytes hole, try to pack */

I will place the variables here.

> johannes
>

Thank you so much!
Taehee
