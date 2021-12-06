Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3985446A110
	for <lists+netdev@lfdr.de>; Mon,  6 Dec 2021 17:17:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352343AbhLFQVH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Dec 2021 11:21:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42170 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352515AbhLFQTu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Dec 2021 11:19:50 -0500
Received: from mail-io1-xd31.google.com (mail-io1-xd31.google.com [IPv6:2607:f8b0:4864:20::d31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 90B66C0698D6;
        Mon,  6 Dec 2021 08:16:16 -0800 (PST)
Received: by mail-io1-xd31.google.com with SMTP id y16so13565198ioc.8;
        Mon, 06 Dec 2021 08:16:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=i/ZDF2XFTR41zF12EPAoQs5EFKTLrwQvmyNIdqJ10Ng=;
        b=jjy6vu7x1/SheTJYzmrl2TkWwT8135gXiiNmNpL6SSWtaMgBsrfgqfK2i9gQfaulX2
         650TXJmRKRrdbvPS3436wSCqai0iIlP58bwOatJ663z0E0gFcqc895ncXk03uKBTJyKd
         a1vwlBzMpCb5pfx8Qo0w9UCfopaq1pIBowWEoRYuPQ5lHSAQoWJlTtpQFzcbC2hn2ahQ
         od0URcHDKVEHUoLhFcdlP36IhTR8qsmSWobbxOUsSqhDvAA8CGWQq25kZykxbQVG8HIt
         xACctvolBFQCQL22XYwhEK1ZmwydWIIXlDHq7h5N5BnTrY7G5IcQn1NNDXjqPlrQbuqH
         3v+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=i/ZDF2XFTR41zF12EPAoQs5EFKTLrwQvmyNIdqJ10Ng=;
        b=Auo/ghqgD/Ki46S+NcIj7pQ/cO412pGo1X5a6ekKuDA+F8+QHFwv0YeqUhAsLiNLp/
         tsJB5bmQ1ATa+QBzGacKM2VIfCgTwi3JEvBERDbhesThwicX+PlimXUzX/I8bdwRhuZl
         HO57UUseHLLZ16uldxTSfoYxnPBZw8lHupuSwo6mfT5fmcVqKNSaOb9xA7ittJhCciEp
         00YujSprf8z9uJvkCFSJ3bWsOpU4W4RBk1BBMS+XxxfXxCwOqx+SiWatDcfs+/qYEykj
         WqPPN3AwM1yIQToXuNwzGmRXArfplOR+7C4/goxSvYbZ0U7IxXsIKaSC4KbpkTdJlAlh
         Sv/g==
X-Gm-Message-State: AOAM530yHW/sOXB62t8D/63tKeet4jetB0TnJkZshGCUhJsZkcbiri2o
        aZSZMDZ2Fim7sdob3ZVcL18=
X-Google-Smtp-Source: ABdhPJyNBjMvn2kT2R1mnC2z+6+U/NB1fwZilTOwBHu7tzgJD0W6yGja2MoQcni8CJixnQxBg4GY6w==
X-Received: by 2002:a05:6638:2608:: with SMTP id m8mr43881290jat.57.1638807374571;
        Mon, 06 Dec 2021 08:16:14 -0800 (PST)
Received: from localhost ([172.243.151.11])
        by smtp.gmail.com with ESMTPSA id x13sm6948578ilp.43.2021.12.06.08.16.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Dec 2021 08:16:14 -0800 (PST)
Date:   Mon, 06 Dec 2021 08:16:06 -0800
From:   John Fastabend <john.fastabend@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        "Russell King (Oracle)" <linux@armlinux.org.uk>
Cc:     Emmanuel Deloget <emmanuel.deloget@eho.link>,
        Louis Amas <louis.amas@eho.link>, andrii@kernel.org,
        ast@kernel.org, bpf@vger.kernel.org, daniel@iogearbox.net,
        davem@davemloft.net, hawk@kernel.org, john.fastabend@gmail.com,
        kafai@fb.com, kpsingh@kernel.org, linux-kernel@vger.kernel.org,
        mw@semihalf.com, netdev@vger.kernel.org, songliubraving@fb.com,
        yhs@fb.com
Message-ID: <61ae3746df2f9_88182085b@john.notmuch>
In-Reply-To: <20211206080337.13fc9ae7@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
References: <DB9PR06MB8058D71218633CD7024976CAFA929@DB9PR06MB8058.eurprd06.prod.outlook.com>
 <20211110144104.241589-1-louis.amas@eho.link>
 <bdc1f03c-036f-ee29-e2a1-a80f640adcc4@eho.link>
 <Ya4vd9+pBbVJML+K@shell.armlinux.org.uk>
 <20211206080337.13fc9ae7@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Subject: Re: [PATCH 1/1] net: mvpp2: fix XDP rx queues registering
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jakub Kicinski wrote:
> On Mon, 6 Dec 2021 15:42:47 +0000 Russell King (Oracle) wrote:
> > On Mon, Dec 06, 2021 at 04:37:20PM +0100, Emmanuel Deloget wrote:
> > > On 10/11/2021 15:41, Louis Amas wrote:  
> > > > The registration of XDP queue information is incorrect because the
> > > > RX queue id we use is invalid. When port->id == 0 it appears to works
> > > > as expected yet it's no longer the case when port->id != 0.
> > > > 
> > > > When we register the XDP rx queue information (using
> > > > xdp_rxq_info_reg() in function mvpp2_rxq_init()) we tell them to use
> > > > rxq->id as the queue id. This value iscomputed as:
> > > > rxq->id = port->id * max_rxq_count + queue_id
> > > > 
> > > > where max_rxq_count depends on the device version. In the MB case,
> > > > this value is 32, meaning that rx queues on eth2 are numbered from
> > > > 32 to 35 - there are four of them.
> > > > 
> > > > Clearly, this is not the per-port queue id that XDP is expecting:
> > > > it wants a value in the range [0..3]. It shall directly use queue_id
> > > > which is stored in rxq->logic_rxq -- so let's use that value instead.
> > > > 
> > > > This is consistent with the remaining part of the code in
> > > > mvpp2_rxq_init().
> 
> > > Is there any update on this patch ? Without it, XDP only partially work on a
> > > MACCHIATOBin (read: it works on some ports, not on others, as described in
> > > our analysis sent together with the original patch).  
> > 
> > I suspect if you *didn't* thread your updated patch to your previous
> > submission, then it would end up with a separate entry in
> > patchwork.kernel.org,
> 
> Indeed, it's easier to keep track of patches which weren't posted 
> as a reply in a thread, at least for me.
> 
> > and the netdev maintainers will notice that the
> > patch is ready for inclusion, having been reviewed by Marcin.
> 
> In this case I _think_ it was dropped because it didn't apply.
> 
> Please rebase on top of net/master and repost if the changes is still
> needed.

Also I would add the detailed description to the actual commit not below
the "--" lines. Capturing that in the log will be useful for future
reference if we ever hit similar issue here or elsewhere.

Otherwise for patch,

Acked-by: John Fastabend <john.fastabend@gmail.com>
