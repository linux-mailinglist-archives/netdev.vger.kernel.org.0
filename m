Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3F74A1025D5
	for <lists+netdev@lfdr.de>; Tue, 19 Nov 2019 15:03:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727352AbfKSOD2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Nov 2019 09:03:28 -0500
Received: from mail-pg1-f195.google.com ([209.85.215.195]:37282 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725280AbfKSOD1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Nov 2019 09:03:27 -0500
Received: by mail-pg1-f195.google.com with SMTP id b10so2890900pgd.4;
        Tue, 19 Nov 2019 06:03:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=t74/VpiGvMA7PufCpXnH39ozgmgIiKrUGwtvDvobjHU=;
        b=QUrwn98xfw5nViraHFy/yKWIZZtfW6OjKCpo5CJ7HoSJib8V1EM7cmmMjUDMwXrR2+
         2itsRlibNFA8g84Nq+UrwrHSOE9c37kxyO/bSWQ/btVOAgjTS//sBEx2jiPrSlkmAsuG
         bNhevpNBBYY/52kldMKLTPUwAk+yxR0QmyeYfsK0p2NRLiKkFpSUO1AJsT7/EvskYjSq
         nbxIs5nYWoU9QQEX4G/ct1Ob4z5V/mqJmG4UhlpFpGLSP40b0oefvTxTv1BbMnpzYtz3
         rc0hbLBcq82KZHZGwnYwOvYnWXHA1+0uRJHDIgG2dhekEJnS0Hx2AZ4n+Rf0tfPJtotG
         ipcQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=t74/VpiGvMA7PufCpXnH39ozgmgIiKrUGwtvDvobjHU=;
        b=M8A47TyApxMhnFHnkKrKMe93x1YktOset0P3ODV896zTfz659EPHDsf0flbbvvnwkO
         qemP4JuZhCZWA1BDFD50rWtropPrvrXujZBIBhVm+UhyWhNMjgAZhG6RhRDMOmkHNI27
         yQ1wKX6A131mNgoTwol7EvzdphJjBjrBmZKnk4bwaRmXURudUez3GXMTLuAu1UheN4Q4
         waboU4i0u7L3u6biArJKC0zYgCTsLDOt0S/ClaIv9YcYcurJfpgNDyuAmV/LHqDqL8qJ
         XkCJG4M1QJTJjSQG0cLo0O/kc5KiK6/NPAho7F2fC5H7KAulBFDATwSgP8MMt4FMo512
         MsKw==
X-Gm-Message-State: APjAAAW3CEb5rdUowM9TQyCrncNQU1C8n5ggp2a6Ztznzclfkk5o0BDN
        p99wqGC829AdYZ5siHBPSSk=
X-Google-Smtp-Source: APXvYqxXkOy2yefLl/ia3QTBRCi/9E/3Cg3kvtnKQVls6SAtDJT+OPUnwC/ynN1QVOmO8dn+TKVQ/g==
X-Received: by 2002:a63:7c03:: with SMTP id x3mr5953500pgc.382.1574172205640;
        Tue, 19 Nov 2019 06:03:25 -0800 (PST)
Received: from localhost (c-73-241-114-122.hsd1.ca.comcast.net. [73.241.114.122])
        by smtp.gmail.com with ESMTPSA id w27sm24538192pgc.20.2019.11.19.06.03.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Nov 2019 06:03:24 -0800 (PST)
Date:   Tue, 19 Nov 2019 06:03:22 -0800
From:   Richard Cochran <richardcochran@gmail.com>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        "David S. Miller" <davem@davemloft.net>,
        lkml <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>
Subject: Re: Design issue in DSA RX timestamping (Was "Re: [PATCH net-next
 3/5] net: dsa: mv88e6xxx: Let taggers specify a can_timestamp function")
Message-ID: <20191119140322.GA7556@localhost>
References: <20190528235627.1315-1-olteanv@gmail.com>
 <20190528235627.1315-4-olteanv@gmail.com>
 <CA+h21hpvn-9MNUze3dc2UmVTpRHrv_Xrc_LdAzpzctCqzkE8OA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+h21hpvn-9MNUze3dc2UmVTpRHrv_Xrc_LdAzpzctCqzkE8OA@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 19, 2019 at 01:35:14PM +0200, Vladimir Oltean wrote:
> - DSA doesn't let drivers to select which frames should be
> timestamped. It knows better.

It time stamps the event frames.
 
> - To be precise, it runs the PTP BPF classifier and filters only the
> SYNC (but not FOLLOW-UP) messages. In principle I agree, the FOLLOW-UP
> frames are general messages and don't need to be timestamped for the
> PTP protocol to work. But by that logic, the HWTSTAMP_FILTER_ALL
> rx_filter shouldn't exist?

FILTER_ALL means all event frames on all transports.  It has nothing
to do with event messages.

> - Because it treats SYNC and FOLLOW-UP frames differently on the RX
> path, it gives them a chance to get reordered. It doesn't give the
> driver a chance to avoid the reordering.

The re-ordering will occur no matter what.  Think about the UDP/IPv4
transport.  The event and general messages are on different ports!
The user space PTP must deal with message re-ordering.


> - Without fully understanding what happens, I tried to propose better
> logic for recovering reordered SYNC/FOLLOW-UP pairs at the application
> level in linuxptp [1]. Needless to say, the consensus was to fix the
> kernel. So here we are.
> 
> [1] https://sourceforge.net/p/linuxptp/mailman/linuxptp-devel/thread/20190928123414.9422-1-olteanv%40gmail.com/#msg36773629

There was no consensus to fix the kernel.  The kernel is fine.  Your
hardware is too slow to keep up with the very high message rate of the
telecom profiles.  Here are a few quotes from that discussion:

   ---
   Are you saying in a local network it's expected that a PTP slave
   receives the follow-up message one or more sync intervals after the
   corresponding sync message, e.g. a delay of 1 second with the default
   sync interval?
   
   I'd not consider such network to be suitable for PTP.
   ---
   I think it's expected that two messages sent within few microseconds or
   milliseconds can be received in a wrong order and PTP slaves need to
   handle that. But it's not expected that a message will be delayed so
   much that it will be received after a message that was sent one or
   more sync intervals later.
   ---
   I'd not expect to receive a follow-up message 30 milliseconds
   after the corresponding sync message. If the difference was getting to
   the millisecond range, I'd be worried that the network is so
   overloaded or misconfigured that it might drop some PTP messages.
   ---

Thanks,
Richard
