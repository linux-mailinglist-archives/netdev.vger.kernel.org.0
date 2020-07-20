Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3FD4C226FE9
	for <lists+netdev@lfdr.de>; Mon, 20 Jul 2020 22:48:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728969AbgGTUsE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Jul 2020 16:48:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58262 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726012AbgGTUsB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Jul 2020 16:48:01 -0400
Received: from mail-pj1-x1043.google.com (mail-pj1-x1043.google.com [IPv6:2607:f8b0:4864:20::1043])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A3549C061794;
        Mon, 20 Jul 2020 13:48:01 -0700 (PDT)
Received: by mail-pj1-x1043.google.com with SMTP id md7so536206pjb.1;
        Mon, 20 Jul 2020 13:48:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=W3gFxb9MTLvTnCe3A+iabUWXBAu7mA9HyhZHWgTOkUw=;
        b=OGmrrLECo+9bEWcObjspsB7mZd1Knz6TplGXozOrISTfqD7/NX21SXnbWcSkV3fL4v
         rTtVk5lWAA2Zu7uZ6u1mrfxhancqzyg3QAj3aPjlEycGVWZJlozkhUGEvXA8Lh3Zhd9y
         MI2pFWCUVAw0qhoczi2fzDR5o+9jsXf0u50JS+cFIfuTYX6fdThXqy7BkTGCK/dg3wkY
         mbds6x2z1GfwvAA0D5GwOBd9MLDFeCqWgb4tYptazoXAosQDHX7Ytsgw6xoiVQCij+q6
         LhYcFToAHR8FWmsf1prWh4sudrDF50FXVoAgPYMNb7eWHKWg9zXFnQitJW8+uw6BZBn8
         8EhQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=W3gFxb9MTLvTnCe3A+iabUWXBAu7mA9HyhZHWgTOkUw=;
        b=NmiT+9oS9uGFkHRMP8aKc0bdouhlF+z3N5dmTZmMvJTuQlavya2QOjW9QZluOBDMSN
         Bf8iOVH8ZwsENeYxwjEQZujdZFojbyI5o/gyN8uqRyJGsRUd4CmnulXJhw4+Gy1N/tQM
         4ju/0yxyaquisGWKaNo8IDmPDegmXL1hE7sGBPd37CAuuHg4bE7IRXJLKd5HezY+6rbI
         57Abyx0O6OS1c4sJpbqMwZFxec+2L4ngp4CDZv566S1w3ZjoKKvtWYtElQPsITi+GpaX
         QeoAbDjDDjufLbC3qeDlBil3FMgGdXH7tdt3RJ0ZPfbGcZ8VCfWS6QkfnGtmwRWsDlu/
         2GXQ==
X-Gm-Message-State: AOAM532xzswQCE9EmiTk87sBNFqaRV6lXN9+OTa+JTpTX2JXZ3mv7RA8
        Lqgsib0ge2mJ4jEvgoQdL6o=
X-Google-Smtp-Source: ABdhPJznKJm/ctwfQ0zEUlKph93VMIYlrMPvmwUzvON4KJd0PPoASWmZCQzIIZBDlRvR10ywRtQVEg==
X-Received: by 2002:a17:902:a50d:: with SMTP id s13mr19573067plq.149.1595278081037;
        Mon, 20 Jul 2020 13:48:01 -0700 (PDT)
Received: from ast-mbp.dhcp.thefacebook.com ([2620:10d:c090:400::5:e3b])
        by smtp.gmail.com with ESMTPSA id m31sm455776pjb.52.2020.07.20.13.47.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Jul 2020 13:47:59 -0700 (PDT)
Date:   Mon, 20 Jul 2020 13:47:56 -0700
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Eric Dumazet <edumazet@google.com>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        linux-sctp@vger.kernel.org, linux-hams@vger.kernel.org,
        linux-bluetooth@vger.kernel.org, bridge@lists.linux-foundation.org,
        linux-can@vger.kernel.org, dccp@vger.kernel.org,
        linux-decnet-user@lists.sourceforge.net,
        linux-wpan@vger.kernel.org, linux-s390@vger.kernel.org,
        mptcp@lists.01.org, lvs-devel@vger.kernel.org,
        rds-devel@oss.oracle.com, linux-afs@lists.infradead.org,
        tipc-discussion@lists.sourceforge.net, linux-x25@vger.kernel.org
Subject: Re: get rid of the address_space override in setsockopt
Message-ID: <20200720204756.iengwcguikj2yrxt@ast-mbp.dhcp.thefacebook.com>
References: <20200720124737.118617-1-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200720124737.118617-1-hch@lst.de>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jul 20, 2020 at 02:47:13PM +0200, Christoph Hellwig wrote:
> Hi Dave,
> 
> setsockopt is the last place in architecture-independ code that still
> uses set_fs to force the uaccess routines to operate on kernel pointers.
> 
> This series adds a new sockptr_t type that can contained either a kernel
> or user pointer, and which has accessors that do the right thing, and
> then uses it for setsockopt, starting by refactoring some low-level
> helpers and moving them over to it before finally doing the main
> setsockopt method.
> 
> Note that I could not get the eBPF selftests to work, so this has been
> tested with a testing patch that always copies the data first and passes
> a kernel pointer.  This is something that works for most common sockopts
> (and is something that the ePBF support relies on), but unfortunately
> in various corner cases we either don't use the passed in length, or in
> one case actually copy data back from setsockopt, so we unfortunately
> can't just always do the copy in the highlevel code, which would have
> been much nicer.

could you rebase on bpf-next tree and we can route it this way then?
we'll also test the whole thing before applying.

sounds like v2 is needed anyway to address Eric's addr space concern?
