Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EC9672FDC9
	for <lists+netdev@lfdr.de>; Thu, 30 May 2019 16:31:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726527AbfE3Oam (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 May 2019 10:30:42 -0400
Received: from mail-pf1-f195.google.com ([209.85.210.195]:46147 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725440AbfE3Oal (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 May 2019 10:30:41 -0400
Received: by mail-pf1-f195.google.com with SMTP id y11so4058003pfm.13;
        Thu, 30 May 2019 07:30:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=Nm5F0NoYud8dFTyRO4X6rwct4PghoxDGwB9Sv0Qk1Bg=;
        b=Rn5s0nZSWi8EQ+5KmOiZcdafiRF3NPaY2mYvVgKqGV5PDivqeK82NNLvOJOC91Adz6
         g6XEnt7yL37uVtJzHYDFR72JhLA8wm18aaQYg2ViWbIZGsn0W4hosX0YYZFxTiBn8lf5
         4BLI/mj63WI6eaSl+TJDa5xy4nSJOiaTg5cgn925Qqytlr+ET0lP0nKqD/lzpARAED1Y
         Z06Nk2LhgeMiOyZn1WGhBDmJp52e3SxJlfit3wgX8EaOqUzAsLcbM3UU2uVOdUKt0t7I
         w6ap5NxGY7znmoXNfc4/z6wcnJyqyvD64l2mHHDYCFCF1+46KdAKCV8OA+h/fViLuAK0
         aZJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=Nm5F0NoYud8dFTyRO4X6rwct4PghoxDGwB9Sv0Qk1Bg=;
        b=nWEGzBVLWCpDXwjVU45H7sAoegeQR1VL3SNPIvm8jpfMwCJ1hKOd3LdkEhbuSmLwTt
         Uai5FneCpZXGBc5HJom/Uy8fxNz9lZsSNzNTulqwWk5PTBl+E9YiYBBoPXdp5W81fIFv
         tXkBVbtosNVkMRhn1Y86m94cofXQHY55RvsSBgmbOyMJIK/E+bOfVjD6Q2xm7VoiiKZ/
         jtqfFCEJUrvIq/nop8NKGqZjNcdXqFqDLF1ZIMnUtPRH89IgR4ZaiTEGYRvWGRtCgM+V
         XgzsXz6/G79VZs7Ckn2Vo07+7ZM0Awo+0kF5ZUFEYsUV+YpINoTDgnb653HydaYiS75w
         PmUw==
X-Gm-Message-State: APjAAAWV/LWIKWhpre42+yyzKiFDkocIbacqVa1rvwX6RNhv1VAB+9Qt
        Fkns5/OU9oh4r/FYgcZqL84=
X-Google-Smtp-Source: APXvYqyf6RJQmExoYDAgn2nmPkTagv/GH+iSu2/KlyPfNpnjMuk7f+ZEwsIb1a9yhxSYO/bhI35eJw==
X-Received: by 2002:aa7:8495:: with SMTP id u21mr4002574pfn.125.1559226641022;
        Thu, 30 May 2019 07:30:41 -0700 (PDT)
Received: from localhost (c-73-222-71-142.hsd1.ca.comcast.net. [73.222.71.142])
        by smtp.gmail.com with ESMTPSA id c129sm3232904pfg.178.2019.05.30.07.30.39
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 30 May 2019 07:30:40 -0700 (PDT)
Date:   Thu, 30 May 2019 07:30:37 -0700
From:   Richard Cochran <richardcochran@gmail.com>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        "David S. Miller" <davem@davemloft.net>,
        John Stultz <john.stultz@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Stephen Boyd <sboyd@kernel.org>,
        lkml <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>
Subject: Re: [PATCH net-next 0/5] PTP support for the SJA1105 DSA driver
Message-ID: <20190530143037.iky5kk3h4ssmec3f@localhost>
References: <20190528235627.1315-1-olteanv@gmail.com>
 <20190529045207.fzvhuu6d6jf5p65t@localhost>
 <dbe0a38f-8b48-06dd-cc2c-676e92ba0e74@gmail.com>
 <20190530034555.wv35efen3igwwzjq@localhost>
 <CA+h21hpjsC=ie5G7Gx3EcPpazyxze6X_k+8eC+vw7JBvEO2zNg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+h21hpjsC=ie5G7Gx3EcPpazyxze6X_k+8eC+vw7JBvEO2zNg@mail.gmail.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, May 30, 2019 at 12:01:23PM +0300, Vladimir Oltean wrote:
> In fact that's why it doesn't work: because linuxptp adds ptp_dst_mac
> (01-1B-19-00-00-00) and (01-80-C2-00-00-0E) to the MAC's multicast
> filter, but the switch in its great wisdom mangles bytes
> 01-1B-19-xx-xx-00 of the DMAC to place the switch id and source port
> there (a rudimentary tagging mechanism). So the frames are no longer
> accepted by this multicast MAC filter on the DSA master port unless
> it's put in ALLMULTI or PROMISC.

IOW, it is not linuxptp's choice to use these modes, but rather this
is caused by a limitation of your device.
 
> If the meta frames weren't associated with the correct link-local
> frame, then the whole expect_meta -> SJA1105_STATE_META_ARRIVED
> mechanism would go haywire, but it doesn't.

Not necessarily.  If two frames that arrive at nearly the same time
get their timestamps mixed up, that would be enough to break the time
values but without breaking your state machine.

> I was actually thinking it has something to do with the fact that I
> shouldn't apply frequency corrections on timestamps of PTP delay
> messages. Does that make any sense?

What do you mean by that?  Is the driver altering PTP message fields?

Thanks,
Richard
