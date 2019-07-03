Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 85ACA5DAD1
	for <lists+netdev@lfdr.de>; Wed,  3 Jul 2019 03:28:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727430AbfGCB2m (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Jul 2019 21:28:42 -0400
Received: from mail-qt1-f196.google.com ([209.85.160.196]:34084 "EHLO
        mail-qt1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727326AbfGCB2m (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Jul 2019 21:28:42 -0400
Received: by mail-qt1-f196.google.com with SMTP id m29so825074qtu.1
        for <netdev@vger.kernel.org>; Tue, 02 Jul 2019 18:28:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=GPq+X9gZ7QNxQQpyYuv9TfK86Mv6GcvklT40SAlmU6I=;
        b=OluhLlRuwPPuipU6cP5uCepLi5qwIPWoKIg+SrFLDnLIPWUVwbd20cNRHrpJjZodcI
         bpTfkHot5f3AkN85zqhxB7iu7g8RRnhrvj4IDi9J+ymngPXPpvvKixZ7uy4vgS/CpA7o
         LI1K0P6e1HWNz859c3xzR/LWinE4y3gtVbPZH4ZvuxbazmVyd+SVfrHLVQLiU6nwTytT
         lRThvht5Y8GvFutbWJKr2+mpp75TF8D0xUlKGgFCuC32BUvu+jKEjJFrlKkH00pq5Qnf
         sTnjxik3lFu9C92pKOnsGh5sW4gcox6NBLporHj4ibDswJqbrUtUe/3vWdLsvqNcBeVL
         Gt1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=GPq+X9gZ7QNxQQpyYuv9TfK86Mv6GcvklT40SAlmU6I=;
        b=FtA31182ux/dvD4SxrsoDY/lEoK+qDzRW/4pvOymI5CBAUo6Rg09Qt6z98KYHN0vZh
         9ejQBHGnrlp3kOg+vk6+pc/YROkeO7RGnBIalesukrnhqTkvU3nYuf7PZOCe1s2XKB1s
         gV/OXAn2aOSCYduqTxQWyKnYeRvodfRZJRiTLjH/IOz2I84QHJp6B3OBsPuIG8UcyRis
         ND2s6S+pqVkUTc8xUfyj25s9ehCrv/hI48auUFsZG80n0RUtYpfYwM9arkXdD5CL8npz
         jQrJ2yxqP5pVlIRUTkT8k/fhInW24DGg3/BjR0+pREHcjyaCDozcg5gagV4WUdmmHooD
         wuuA==
X-Gm-Message-State: APjAAAWDrxKI+2CCvWNo80KvFC/QCbgffX1OVzReDwfrI7fyrxQlFymX
        SVh1fP2aml6s+IQyOOgWJfRV8o/YyyI=
X-Google-Smtp-Source: APXvYqzYSgXl8r6+whN1TzV4O/DdC6Y7yHmiVDY0vvy0MVaR9rm+bdJH9PclIsRiwOBEWrYeIC7k2Q==
X-Received: by 2002:ac8:224d:: with SMTP id p13mr27884664qtp.154.1562117321444;
        Tue, 02 Jul 2019 18:28:41 -0700 (PDT)
Received: from cakuba.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id 18sm247144qke.131.2019.07.02.18.28.39
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Tue, 02 Jul 2019 18:28:41 -0700 (PDT)
Date:   Tue, 2 Jul 2019 18:28:35 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Michal Kubecek <mkubecek@suse.cz>
Cc:     netdev@vger.kernel.org, Jiri Pirko <jiri@resnulli.us>,
        David Miller <davem@davemloft.net>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        John Linville <linville@tuxdriver.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Johannes Berg <johannes@sipsolutions.net>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next v6 05/15] ethtool: helper functions for netlink
 interface
Message-ID: <20190702182835.69c9ac67@cakuba.netronome.com>
In-Reply-To: <20190702163437.GE20101@unicorn.suse.cz>
References: <cover.1562067622.git.mkubecek@suse.cz>
        <44957b13e8edbced71aca893908d184eb9e57341.1562067622.git.mkubecek@suse.cz>
        <20190702130515.GO2250@nanopsycho>
        <20190702163437.GE20101@unicorn.suse.cz>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 2 Jul 2019 18:34:37 +0200, Michal Kubecek wrote:
> > >+	ret = nla_parse_nested(tb, ETHTOOL_A_HEADER_MAX, nest,
> > >+			       policy ?: dflt_header_policy, extack);
> > >+	if (ret < 0)  
> > 
> > if (ret)
> > 
> > Same remark goes to the rest of the code (also the rest of the patches),
> > in case called function cannot return positive values.  
> 
> The "if (ret < 0)" idiom for "on error do ..." is so ubiquitous through
> the whole kernel that I don't think it's worth it to carefully check
> which function can return a positive value and which cannot and risk
> that one day I overlook that some function. And yet another question is
> what exactly "cannot return" means: is it whenever the function does not
> return a positive value or only if it's explicitly documented not to?
> 
> Looking at existing networking code, e.g. net/netfilter (except ipvs),
> net/sched or net/core/rtnetlink.c are using "if (ret < 0)" rather
> uniformly. And (as you objected to the check of genl_register_family()
> previous patch) even genetlink itself has
> 
> 	err = genl_register_family(&genl_ctrl);
> 	if (err < 0)
> 		goto problem;
> 
> in genl_init().

I agree with Jiri, if a function only returns "0, or -errno" it's
easier to parse if the error check is not only for negative values.
At least to my eyes.

What I'm not sure about is whether we want to delay the merging of this
interface over this..
