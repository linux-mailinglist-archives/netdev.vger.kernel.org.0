Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D5BA4BA03B
	for <lists+netdev@lfdr.de>; Sun, 22 Sep 2019 04:29:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727149AbfIVCYh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 21 Sep 2019 22:24:37 -0400
Received: from mail-pg1-f196.google.com ([209.85.215.196]:33420 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727139AbfIVCYh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 21 Sep 2019 22:24:37 -0400
Received: by mail-pg1-f196.google.com with SMTP id i30so216578pgl.0
        for <netdev@vger.kernel.org>; Sat, 21 Sep 2019 19:24:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=SVwbK7IWi/FSoVn7UDmef5b4xH3yKyYucq2NewMSgGA=;
        b=MUUrUv+yXpCIkhbb2R9jqF3UDWd40wTbKaexJhnNKKnHGNV3xuZNqt5AsVlcKXe1Ct
         lNub64J5PD5YOAGCLE9JBnE7AeWAUVu/EwruV3hILVtPJvIlVmiWE2iGGzv68G9HFmAI
         j2e69gieVxo4IT6nlhWuZpYXNHBgWYlP6GqtTXMl/92KLQ5nywXH3d8qju+9ZwgiqPcj
         aZ6jgyTvGia4rpmAsL1Z0Rz2fO6dq75qkfUZKy+AX8UQe6GkUxjRvhq96l4llShNckDT
         TXd10gEizsUZ9OKw/PSy9QxizQTQkudm5iADgN0wbzHcYZ83cnttihuZcWfmjQdJ5Pxy
         GR3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=SVwbK7IWi/FSoVn7UDmef5b4xH3yKyYucq2NewMSgGA=;
        b=oDJcsdYA6phgSZmzgT0CTGff3ZYBxmlB5+QY8qkWozxI9AL9m54cah7zSFIk+IgG4Y
         PNc1s4d0hwvKRZN95iiIRfBXSTSAAc/4i9u61se7x+PJgQcc73imHqZwJHl33FoMiTJ5
         cB/g0zvM2iLTd7YuEXTjbkTxnIdbD3yGqICrDQFPtoVWsL94O5WzgDZRqoIEK3DZZ9aD
         iIP3CZZIbBJFg6sjQL4NcDot5UUCr8bLJEwT3YEcITI1K8+QDpEslvXi5TQgp/uK7fJq
         lMWlrDMTq/ZfJ8fYWjRlo1cJ+PTaMR3JUOOHcVCgz6GyyJp7m8T/6VM4mmW59tpPDGMc
         9E8Q==
X-Gm-Message-State: APjAAAVYoLxdX6D4XkGdQeevrbIJslYathnLdy3BFlK7hUwfryqHiL5F
        85PyD7ZzdnoJhbVB1rTyaNEqrg==
X-Google-Smtp-Source: APXvYqyy11v0AEMvhDqSTzxwRGPbb812kAQImggqmq53x3Yi3V4fodgPCIcypI8Z6jkq0BUNLUxyng==
X-Received: by 2002:a62:aa0f:: with SMTP id e15mr25501814pff.160.1569119077029;
        Sat, 21 Sep 2019 19:24:37 -0700 (PDT)
Received: from cakuba.netronome.com (c-73-202-202-92.hsd1.ca.comcast.net. [73.202.202.92])
        by smtp.gmail.com with ESMTPSA id f128sm9837974pfg.143.2019.09.21.19.24.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 21 Sep 2019 19:24:36 -0700 (PDT)
Date:   Sat, 21 Sep 2019 19:24:34 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Cong Wang <xiyou.wangcong@gmail.com>
Cc:     David Ahern <dsahern@gmail.com>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        syzbot <syzbot+618aacd49e8c8b8486bd@syzkaller.appspotmail.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Jiri Pirko <jiri@resnulli.us>
Subject: Re: [Patch net] net_sched: add max len check for TCA_KIND
Message-ID: <20190921192434.765d7604@cakuba.netronome.com>
In-Reply-To: <CAM_iQpXa=Kru2tXKwrErM9VsO40coBf9gKLRfwC3e8owKZG+0w@mail.gmail.com>
References: <20190918232412.16718-1-xiyou.wangcong@gmail.com>
        <36471b0d-cc83-40aa-3ded-39e864dcceb0@gmail.com>
        <CAM_iQpXa=Kru2tXKwrErM9VsO40coBf9gKLRfwC3e8owKZG+0w@mail.gmail.com>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 18 Sep 2019 22:15:24 -0700, Cong Wang wrote:
> On Wed, Sep 18, 2019 at 7:41 PM David Ahern <dsahern@gmail.com> wrote:
> > On 9/18/19 5:24 PM, Cong Wang wrote:  
> > > The TCA_KIND attribute is of NLA_STRING which does not check
> > > the NUL char. KMSAN reported an uninit-value of TCA_KIND which
> > > is likely caused by the lack of NUL.
> > >
> > > Change it to NLA_NUL_STRING and add a max len too.
> > >
> > > Fixes: 8b4c3cdd9dd8 ("net: sched: Add policy validation for tc attributes")  
> >
> > The commit referenced here did not introduce the ability to go beyond
> > memory boundaries with string comparisons. Rather, it was not complete
> > solution for attribute validation. I say that wrt to the fix getting
> > propagated to the correct stable releases.  
> 
> I think this patch should be backported to wherever commit 8b4c3cdd9dd8
> goes, this is why I picked it as Fixes.

Applied, queued for 4.14+, thanks!

> >  
> > > Reported-and-tested-by: syzbot+618aacd49e8c8b8486bd@syzkaller.appspotmail.com  
> >
> > What is the actual sysbot report?  
> 
> https://marc.info/?l=linux-kernel&m=156862916112881&w=2

