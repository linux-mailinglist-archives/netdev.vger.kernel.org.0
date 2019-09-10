Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C7690AE620
	for <lists+netdev@lfdr.de>; Tue, 10 Sep 2019 10:58:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726773AbfIJI6P (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Sep 2019 04:58:15 -0400
Received: from wout1-smtp.messagingengine.com ([64.147.123.24]:48785 "EHLO
        wout1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726121AbfIJI6P (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Sep 2019 04:58:15 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.west.internal (Postfix) with ESMTP id C23715C5;
        Tue, 10 Sep 2019 04:58:13 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute6.internal (MEProxy); Tue, 10 Sep 2019 04:58:14 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:content-transfer-encoding:in-reply-to; s=fm1; bh=N
        wXi/oe0IydEdExqK0+dznaH54PXUdT25LQcXIyjYQk=; b=DoVNlvF2zaTqjn8aU
        /Qr2nxkdAPJ49iWGvvMhQe0phIOLAJw36qs5McE01Kdg+he3Pk//tWJUupGUjKEO
        OvqDQ8FaV8JjM8Ea8Axh083ZYjTLO1kqo4Ott+/fDCJE0TBD0MSPQHfHbVOAPpsk
        YdsHZLBSf/lo2DsTmb+oKFIaeeR6k1OqQh+RETAg8UZQawfW6W4R91qODEGv8wPF
        CABJNaMbU4bl93qb6/0A/PaLu8dnPQA4NItZ+AK9hO3sgl3Wfr02Nog8//UHEdNh
        EoPYNNAlSWcJW5L467ZxHaj0KgGQUDws8PFN0A9vnxZzzPBU+7uqgirPHY9HjCk7
        x+M/Q==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:in-reply-to:message-id:mime-version:references
        :subject:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
        :x-sasl-enc; s=fm3; bh=NwXi/oe0IydEdExqK0+dznaH54PXUdT25LQcXIyjY
        Qk=; b=SbyPuNZqTDqQaGGKp3vFlT/U460sMpUHXJMyb5qDSkJZvWWOBHV+YeX5n
        m7sAuQxMB75WOY4q4UgzTSbn57b8rdRO7s2C3xKs/avs4N/qNI/CF+RBlx+JU+pi
        LGqjmqJnbZUNK1tT5oODMrPHqgCX4UwhziyW+hU5dHRt3BVbTykWCyVIQ2uaO6Ml
        3K/AXarOeHbsvgYnxUferuFeZ5c7ujTMf5+erjPYASfUoLCohKYK3bYnyGyP7MuX
        gtzgl4BZepImZVDuTAu2SGY8ypdbhb86FE4ErSmx9qUXepmynQjsRLeaBuTLEnMu
        qukTe8vr1mlMfBUBZy3/nYiEFPHZA==
X-ME-Sender: <xms:pGV3XUBLT97HoZfsDuzdE0lB8W-oNuPH5YOOJcg5LFDqvwvWYUL6yg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduvddrudekkedguddtucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtugfgjggfsehtkeertddtreejnecuhfhrohhmpefirhgv
    ghcumffjuceoghhrvghgsehkrhhorghhrdgtohhmqeenucffohhmrghinheptghkihdqph
    hrohhjvggtthdrohhrghdpkhgvrhhnvghlrdhorhhgnecukfhppedvudefrdeftddrkedr
    uddutdenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhmne
    cuvehluhhsthgvrhfuihiivgeptd
X-ME-Proxy: <xmx:pGV3Xax_g2W__zRRjkWxRwB4r5cScCxm_7OCCwneCfSQVwndVSIl8Q>
    <xmx:pGV3XSnR7Pm4QRV5D7zhskDuyCyfQwzDAg7g1mXcfM4JxsiTdGQJXQ>
    <xmx:pGV3XfHtipx2KlGKN8Eb3pOjUcSzudJqSAxA-htpUYlkl5iqmunxmw>
    <xmx:pWV3XZyuM7kSI2J8Jko8hUDIQC6SFpnXt-6kfUfrjUhWiS4K5iAV3A>
Received: from localhost (110.8.30.213.rev.vodafone.pt [213.30.8.110])
        by mail.messagingengine.com (Postfix) with ESMTPA id 5260B8005A;
        Tue, 10 Sep 2019 04:58:12 -0400 (EDT)
Date:   Tue, 10 Sep 2019 09:58:10 +0100
From:   Greg KH <greg@kroah.com>
To:     Hangbin Liu <haliu@redhat.com>
Cc:     CKI Project <cki-project@redhat.com>,
        Linux Stable maillist <stable@vger.kernel.org>,
        netdev@vger.kernel.org, Jan Stancek <jstancek@redhat.com>,
        Xiumei Mu <xmu@redhat.com>,
        David Howells <dhowells@redhat.com>,
        linux-afs@lists.infradead.org
Subject: Re: =?utf-8?B?4p2MIEZBSUw=?= =?utf-8?Q?=3A?= Stable queue: queue-5.2
Message-ID: <20190910085810.GA3593@kroah.com>
References: <cki.77A5953448.UY7ROQ6BKT@redhat.com>
 <20190910081956.GG22496@dhcp-12-139.nay.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20190910081956.GG22496@dhcp-12-139.nay.redhat.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Sep 10, 2019 at 04:19:56PM +0800, Hangbin Liu wrote:
> On Wed, Aug 28, 2019 at 08:36:14AM -0400, CKI Project wrote:
> > 
> > Hello,
> > 
> > We ran automated tests on a patchset that was proposed for merging into this
> > kernel tree. The patches were applied to:
> > 
> >        Kernel repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git
> >             Commit: f7d5b3dc4792 - Linux 5.2.10
> > 
> > The results of these automated tests are provided below.
> > 
> >     Overall result: FAILED (see details below)
> >              Merge: OK
> >            Compile: OK
> >              Tests: FAILED
> > 
> > All kernel binaries, config files, and logs are available for download here:
> > 
> >   https://artifacts.cki-project.org/pipelines/128519
> > 
> > 
> > 
> > One or more kernel tests failed:
> > 
> >   x86_64:
> >     ❌ Networking socket: fuzz
> 
> Sorry, maybe the info is a little late, I just found the call traces for this
> failure.

And this is no longer failing?

What is the "fuzz" test?

greg k-h
