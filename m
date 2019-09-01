Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 53F27A4C00
	for <lists+netdev@lfdr.de>; Sun,  1 Sep 2019 22:50:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729065AbfIAUsW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 1 Sep 2019 16:48:22 -0400
Received: from mail-pf1-f196.google.com ([209.85.210.196]:45833 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729013AbfIAUsW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 1 Sep 2019 16:48:22 -0400
Received: by mail-pf1-f196.google.com with SMTP id y72so114773pfb.12
        for <netdev@vger.kernel.org>; Sun, 01 Sep 2019 13:48:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=bS2bI3ruDfFVimUY7Z4bScUDQ/vtCRQvHkIcBmhtyz0=;
        b=GZtaKC+8wRBAk8HqwrJs7L/Y5jxf3w+jauly6obhgAiG0lnJgqd9YmdW4TPlR7ROUe
         ZwA24RI/+tzvXmfYPBXYZZA9I0EdPtGHEB9L+GYV9hRWGXE2pvizh4Tjr8YKERe7iuSO
         up7VQ6vR6MTxiUw4NdK2PwY4QiUlo2ILDJyBHyCJxqeqMTWAEj1/KwYdZooMQ1tS0Jwz
         Zy8bxJZBH9IRoLKNnap1BtN9QID/ZmBssjl09RRH44y4wqvaM2ENn4bv9og3y54wgd3F
         DxRax926EfVG3bdJ0NW5AgZdVvJZxTqB5Qio7wJuosKW04lYU3lrTn4XWhJeSCHB9sLD
         4t5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=bS2bI3ruDfFVimUY7Z4bScUDQ/vtCRQvHkIcBmhtyz0=;
        b=sqYVimwc6+BSGq+Yc2t5LJ3WZnW/ZnRFdhfxgmn1P3tjQPXXOknfN41FWF2ChW7qaN
         kz0WOXOT8yPt1qyORs6B8T0AEEDN++aAJVQ41wbbJro8+e1YIwr3Th9KwkyUjlLJSB8f
         qBxM+LMtruHoM5sAeEoSzzb4p1oSOQAAe0qtzxz0ZZfyJJED+VrtbDJNMJZ3E1Ofk7v3
         6ltbAY9nR0FEQaUYhv97PRr1A3P9Zemlia8zQPFv251sXaj6evodlnzqVBJXDpCd3SsM
         7qiO1EU15FKhYqx3fN9cagQObJ8B/qwlin8U0mpa024zkKpPWicbD76BnbPAaANNOcp8
         CWsw==
X-Gm-Message-State: APjAAAUqN2JXgiznbIov/911bjni296eTRIGWJ4nP8o+SXxD6wVq7ExZ
        PMBdKNJoMKyohT8etXFPDucbBg==
X-Google-Smtp-Source: APXvYqyME8OnFGwbDYlrJTWfTh1RyiwrZU29eECFiC0c6tq1sDPu6H+EDrAXbhi3mTyxrD1H3yFz8g==
X-Received: by 2002:a17:90a:1b0a:: with SMTP id q10mr9739584pjq.91.1567370901211;
        Sun, 01 Sep 2019 13:48:21 -0700 (PDT)
Received: from cakuba.netronome.com (c-71-204-185-212.hsd1.ca.comcast.net. [71.204.185.212])
        by smtp.gmail.com with ESMTPSA id g18sm11189073pgm.9.2019.09.01.13.48.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 01 Sep 2019 13:48:21 -0700 (PDT)
Date:   Sun, 1 Sep 2019 13:47:54 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org, davem@davemloft.net,
        netdev@vger.kernel.org, vishal@chelsio.com, saeedm@mellanox.com,
        jiri@resnulli.us
Subject: Re: [PATCH 0/4 net-next] flow_offload: update mangle action
 representation
Message-ID: <20190901134754.1bcd72d4@cakuba.netronome.com>
In-Reply-To: <20190831142217.bvxx3vc6wpsmnxpe@salvia>
References: <20190830005336.23604-1-pablo@netfilter.org>
        <20190829185448.0b502af8@cakuba.netronome.com>
        <20190830090710.g7q2chf3qulfs5e4@salvia>
        <20190830153351.5d5330fa@cakuba.netronome.com>
        <20190831142217.bvxx3vc6wpsmnxpe@salvia>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 31 Aug 2019 16:22:17 +0200, Pablo Neira Ayuso wrote:
> On Fri, Aug 30, 2019 at 03:33:51PM -0700, Jakub Kicinski wrote:
> > On Fri, 30 Aug 2019 11:07:10 +0200, Pablo Neira Ayuso wrote:  
> > > > > * The front-end coalesces consecutive pedit actions into one single
> > > > >   word, so drivers can mangle IPv6 and ethernet address fields in one
> > > > >   single go.    
> > > > 
> > > > You still only coalesce up to 16 bytes, no?    
> > > 
> > > You only have to rise FLOW_ACTION_MANGLE_MAXLEN coming in this patch
> > > if you need more. I don't know of any packet field larger than 16
> > > bytes. If there is a use-case for this, it should be easy to rise that
> > > definition.  
> > 
> > Please see the definitions of:
> > 
> > struct nfp_fl_set_eth
> > struct nfp_fl_set_ip4_addrs
> > struct nfp_fl_set_ip4_ttl_tos
> > struct nfp_fl_set_ipv6_tc_hl_fl
> > struct nfp_fl_set_ipv6_addr
> > struct nfp_fl_set_tport
> > 
> > These are the programming primitives for header rewrites in the NFP.
> > Since each of those contains more than just one field, we'll have to
> > keep all the field coalescing logic in the driver, even if you coalesce
> > while fields (i.e. IPv6 addresses).  
> 
> nfp has been updated in this patch series to deal with the new mangle
> representation.

It has been updated to handle the trivial coalescing.

> > Perhaps it's not a serious blocker for the series, but it'd be nice if
> > rewrite action grouping was handled in the core. Since you're already
> > poking at that code..  
> 
> Rewrite action grouping is already handled from the core front-end in
> this patch series.

If you did what I'm asking the functions nfp_fl_check_mangle_start()
and nfp_fl_check_mangle_end() would no longer exist. They were not
really needed before you "common flow API" changes.

Your reply makes limited amount of sense to me. Pleas read the code and
what I wrote, if you think I'm asking for too much just say that, I'd
accept that.
