Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 75426319B8
	for <lists+netdev@lfdr.de>; Sat,  1 Jun 2019 07:07:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726075AbfFAFHS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 1 Jun 2019 01:07:18 -0400
Received: from mail-pf1-f195.google.com ([209.85.210.195]:33424 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725892AbfFAFHS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 1 Jun 2019 01:07:18 -0400
Received: by mail-pf1-f195.google.com with SMTP id x10so2305896pfi.0;
        Fri, 31 May 2019 22:07:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=5fVO/KlgFtT6cJll97rrU11AOlKOJoOz7bpnwuaM3NY=;
        b=psbFX5rrIAyMxOtsHsZIlwXwiaTQLbj/hyX0J2mpgTMmIqQEBD3UpE2nRf9VbfPtlh
         UOTPoXW+AGChIyYAPTiFiGSjFSN8XlpdSXv7EFAkwxf9NiRdZzu6imbcymJpZEVtMJ+R
         v6iEuLvj3ra3fkB6ReQvURq4xODL0GnAD4iW7hbI6eoTiXupg2QAl8u3i/EmS/qwPAJa
         QUaHuaMg/xsDzBF9h9Di5V2w9BZR202ZEj93vtfKwSGfXRqbsjUcyeAKm3GO10nPYRPj
         nBaCNIlfOcABN3DEp9QyEv8t2baVs34KxNCOyhJbs6ls3Vt+1L+eEDrXr1bqUYFOUXmF
         bEcw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=5fVO/KlgFtT6cJll97rrU11AOlKOJoOz7bpnwuaM3NY=;
        b=rbyyCWAYN07gUjuyNnX/4GJRAFIHeni8I7DmcThRDK73xqqZEY8hbuE992WicZvk1K
         PzPsFIZpZc/WHfZvDwhhwPHEf49i2fbENhpD2FQUTdLtdgqTz0zNb0iyy59fyFXynYS0
         WNN8vbBIBI2lkPs7ahTwxDYxx2lIjae9kA9zvcuxir89s81srdGZg8YlDHdmZ4Khfdy3
         KYuFenyReeluawjokmIdEc3hRPnQLAH17Ns/P1Nbuu7exnNB0sQtrjCmfoX//y6TdSBO
         JH3Wdwh8Vo+5xE9ERRGHvfM2GbLxN1CEGGgpijG1Z/S5kNSyENhRZ6BfuKek3lM0j7vY
         T/jA==
X-Gm-Message-State: APjAAAXWSZcebnQN7rCl71498bwOqsJMMmvuqGIOX672vZi1Du3MFzWw
        U7TVXbbcxlj6a4L3XuIoaeu6X63u
X-Google-Smtp-Source: APXvYqy8Sq8SkPYDYdiI3R9gq77SPJSFYiDI1aalisl8WgsdCJ3HlEGJDfZW3ZM7LllVAoYKPit/dA==
X-Received: by 2002:a62:3707:: with SMTP id e7mr13841706pfa.36.1559365637821;
        Fri, 31 May 2019 22:07:17 -0700 (PDT)
Received: from localhost (c-73-222-71-142.hsd1.ca.comcast.net. [73.222.71.142])
        by smtp.gmail.com with ESMTPSA id n2sm6842027pgp.27.2019.05.31.22.07.16
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 31 May 2019 22:07:17 -0700 (PDT)
Date:   Fri, 31 May 2019 22:07:14 -0700
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
Message-ID: <20190601050714.xylw5noxka7sa4p3@localhost>
References: <CA+h21hrBwR4Sow7q0_rS1u2md1M4bSAJt8FO5+VLFiu9UGnvjA@mail.gmail.com>
 <20190531043417.6phscbpmo6krvxam@localhost>
 <CA+h21hp9DfW3wFy4YbHMU31rBHyrnUTdF4kKwX36h9vHOW2COw@mail.gmail.com>
 <20190531140841.j4f72rlojmaayqr5@localhost>
 <CA+h21hroywaij3gyO0u6v+GFVO2Fv_dP_a+L3oMGpQH8mQgJ5g@mail.gmail.com>
 <20190531151151.k3a2wdf5f334qmqh@localhost>
 <CA+h21hpHKbTc8toPZf0iprW1b4v6ErnRaSM=C6vk-GCiXM8NvA@mail.gmail.com>
 <20190531160909.jh43saqvichukv7p@localhost>
 <CA+h21hpVrVNJTFj4DHHV+zphs2MjyRO-XZsM3D-STra+BYYHtw@mail.gmail.com>
 <CA+h21houLC7TGJYQ28LxiUxyBE7ju2ZiRcUd41aGo_=uAhgVgQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+h21houLC7TGJYQ28LxiUxyBE7ju2ZiRcUd41aGo_=uAhgVgQ@mail.gmail.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, May 31, 2019 at 09:12:03PM +0300, Vladimir Oltean wrote:
> It won't work unless I make changes to dsa_switch_rcv.

Or to the tagging code.

> Right now taggers can only return a pointer to the skb, or NULL, case
> in which DSA will free it.

The tagger can re-write the skb.  Why not reform it into a PTP frame?
This clever trick is what the phyter does in hardware.  See dp83640.c.

Thanks,
Richard
