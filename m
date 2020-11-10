Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4EACB2AE004
	for <lists+netdev@lfdr.de>; Tue, 10 Nov 2020 20:45:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731517AbgKJTp2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Nov 2020 14:45:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53702 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725862AbgKJTp2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Nov 2020 14:45:28 -0500
Received: from mail-pf1-x442.google.com (mail-pf1-x442.google.com [IPv6:2607:f8b0:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E16CC0613D1;
        Tue, 10 Nov 2020 11:45:28 -0800 (PST)
Received: by mail-pf1-x442.google.com with SMTP id q10so12402336pfn.0;
        Tue, 10 Nov 2020 11:45:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=FlTBekxLH9k5lDusEIqJe96gy2kgeT7w1mYQIC7teW8=;
        b=jxd//I0NFIFChmNjGPdP8n7pBMNdp35EWhyQUGVNOEFkxBmgDczY8aKnJ72aGscLiK
         xIzyZsPlCXjMasMkWXUCKiHfHwnmx2DzZiTZm5bqBDwwcImUAC/JktCOJlZDjztgEONa
         qtbH+61o+GqAoP48KdwdB/7mZKBkLEnlk9BjOaPasX7pLtcQ6Q07uAJxP5kDH8ge4L2c
         GTEv8im5JOuzgIFTMM7wYc6kE0/hwOYNhJ1wCG6Yt3Gn4bx48gRzBwNUNvxN1rU7b+xR
         Qdul0H+cR6XHCU7UAC0ShUPDT7BQuYEt/0E0UyM3aobauUNUVwjS48oRiTk9ZioZ3voB
         7yxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=FlTBekxLH9k5lDusEIqJe96gy2kgeT7w1mYQIC7teW8=;
        b=Or1wJVe7VaosTQJvxnmuwWg9hXOHQMXvNQGyPzfZvs0XQbpjxXKZ7K+IQWamA0PBvq
         n3RNZ3fQDMLPCh6SXA7XuVCOZ/38f7AgtC253+kt1zSxsUxsXN2Ta6PoPfRAKoYyLZJJ
         sqWFojAQUVi4F/alFi/kOvChAKAixWrnVAfnNyTK5JHxudW3LygAdQ7LoaCdNK99klEf
         euqHE13wLe86Qo6j3lRrbZt2YhUT+jYW7DmtBGLXOUta6iXxeuGxm1tTBZ9qo65E6vfI
         p7LPusD3jqi8DUb0WRkua/2aXae64ceVcdmPjIlUNxRaZCVK0RNHvZLncJBzdMp4B9Oz
         bbPQ==
X-Gm-Message-State: AOAM532P7cPc8bYBSiL63MgbnFAJdERBGy5mN/bVRrv/ulm+OzQAngeT
        p43VcdqR11RD0aUrMYS0GNM=
X-Google-Smtp-Source: ABdhPJwWl1MxrloEhHd7y4GBg3SQI528A+IjM7SIRT9Y15gRTroeExL72kLv0O57JDQ2MrodPavS6Q==
X-Received: by 2002:a17:90a:8c87:: with SMTP id b7mr782716pjo.162.1605037527447;
        Tue, 10 Nov 2020 11:45:27 -0800 (PST)
Received: from Thinkpad ([45.118.167.192])
        by smtp.gmail.com with ESMTPSA id j9sm3985736pjl.48.2020.11.10.11.45.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Nov 2020 11:45:26 -0800 (PST)
Date:   Wed, 11 Nov 2020 01:15:18 +0530
From:   Anmol Karn <anmol.karan123@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     ralf@linux-mips.org, davem@davemloft.net, saeed@kernel.org,
        gregkh@linuxfoundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-hams@vger.kernel.org,
        linux-kernel-mentees@lists.linuxfoundation.org,
        syzkaller-bugs@googlegroups.com,
        syzbot+a1c743815982d9496393@syzkaller.appspotmail.com
Subject: Re: [Linux-kernel-mentees] [PATCH v3 net] rose: Fix Null pointer
 dereference in rose_send_frame()
Message-ID: <20201110194518.GA97719@Thinkpad>
References: <20201107082041.GA2675@Thinkpad>
 <20201107191835.5541-1-anmol.karan123@gmail.com>
 <20201110095815.41577920@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201110095815.41577920@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello Sir,

On Tue, Nov 10, 2020 at 09:58:15AM -0800, Jakub Kicinski wrote:
> On Sun,  8 Nov 2020 00:48:35 +0530 Anmol Karn wrote:
> > +			dev = rose_dev_get(dest);
> 
> this calls dev_hold internally, you never release that reference in
> case ..neigh->dev is NULL
> 
> > +			if (rose_loopback_neigh->dev && dev) {

Ah, I missed to `dev_put()` the `dev` after checking for, if neigh->dev is NULL,
I will fix it soon and send another version.

Thank you for review.


Anmol
