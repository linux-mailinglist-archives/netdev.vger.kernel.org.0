Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 331101425E
	for <lists+netdev@lfdr.de>; Sun,  5 May 2019 22:57:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727911AbfEEU5B (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 5 May 2019 16:57:01 -0400
Received: from mail-qt1-f193.google.com ([209.85.160.193]:35489 "EHLO
        mail-qt1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727479AbfEEU5B (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 5 May 2019 16:57:01 -0400
Received: by mail-qt1-f193.google.com with SMTP id d20so2573315qto.2;
        Sun, 05 May 2019 13:57:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=YExjinVHBlRCvyNUu8p8UV5CV+SOy0PucZu7uPEhF+Q=;
        b=u6xgvh3Ppat2oz7uXspjcFuVpUhv6hsbX8z1lbYVDU/Jug1fOWqNnG1se/x/wGPrFa
         CkUQvNeWxcZCGo275+GMdJeB/TprIOUIJy1KrVjWVmbQw/1ObaS3MQEU1qTYF0BgnO5e
         NhwZVeMGxF28kiBBqefS5GZ+yMDPxYHOpLRWgCC/TnCx1QhxH04eGEWz/GCtSiYxVull
         /UV7xmn2FQvhZZCOGifKxjWq0cGayRwmCU81nZd1CquX1rO9SloKZcU2JKeqXgoWSERO
         S5FI6rqMwVuONt643YcUpjCU0Erymmwa9jqGHQy8/GK9LEbUHDzK8H2fkrfm0DhtuWb5
         fijg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=YExjinVHBlRCvyNUu8p8UV5CV+SOy0PucZu7uPEhF+Q=;
        b=lWjdlm1fCiAajaXlPqkR4UMRoPrG/QKK/VWO0Pb3mgmcHKtAkgVwB2xv8SDKmFaVBg
         0E7MLKHwGVRs/Q4qDba3ECkfhYevBpp5eqPTdOJOk3u/xZZ2AbhjnPYHd/Gv/xNLOqbp
         Ct6dPgBKr4I5lOaGNJ66I6L0Uxo0yzERFrln4bU5frSs1rvAmhDVtirbbIOxgoOV4jpZ
         lzqhBdy6m3RG/EKydSjDMwK96j0oyaJkuxIpszDEnil8MQmYiUl1AeVROe3fx6IG7Hit
         6AgJ6giNqEKQogVeesAc4WwdXFmNqIn56glDT+ZO4Szajd9f1YDscgz9QDNdoyUHZ4L8
         DxjA==
X-Gm-Message-State: APjAAAVhE1zv657WlbceD7J+y/BIdzYz+O2Rnh105HmZ4qqoqd0peXDS
        le9/Amh1G958F/3WZbAPs6Y=
X-Google-Smtp-Source: APXvYqx2jxtVCbhpO32VDgpv7uYVj5F+dXhvH7fbW7bh7WPyzTRyd8hfY6uyDwzwzGfZ+3q5F2Fg0g==
X-Received: by 2002:a0c:e98f:: with SMTP id z15mr316682qvn.181.1557089820434;
        Sun, 05 May 2019 13:57:00 -0700 (PDT)
Received: from rani.riverdale.lan ([2001:470:1f07:5f3::b55f])
        by smtp.gmail.com with ESMTPSA id e65sm796741qkd.64.2019.05.05.13.56.59
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 05 May 2019 13:56:59 -0700 (PDT)
Date:   Sun, 5 May 2019 16:56:58 -0400
From:   Arvind Sankar <niveditas98@gmail.com>
To:     Chris Packham <Chris.Packham@alliedtelesis.co.nz>
Cc:     David Miller <davem@davemloft.net>,
        "jon.maloy@ericsson.com" <jon.maloy@ericsson.com>,
        "ying.xue@windriver.com" <ying.xue@windriver.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "tipc-discussion@lists.sourceforge.net" 
        <tipc-discussion@lists.sourceforge.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] tipc: Avoid copying bytes beyond the supplied data
Message-ID: <20190505205656.GA27130@rani.riverdale.lan>
References: <20190502031004.7125-1-chris.packham@alliedtelesis.co.nz>
 <20190504.004449.945185836330139212.davem@davemloft.net>
 <306471ba2dc54014a77b090d2cf6a7c7@svr-chch-ex1.atlnz.lc>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <306471ba2dc54014a77b090d2cf6a7c7@svr-chch-ex1.atlnz.lc>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, May 05, 2019 at 08:20:14PM +0000, Chris Packham wrote:
> On 4/05/19 4:45 PM, David Miller wrote:
> > From: Chris Packham <chris.packham@alliedtelesis.co.nz>
> > Date: Thu,  2 May 2019 15:10:04 +1200
> > 
> >> TLV_SET is called with a data pointer and a len parameter that tells us
> >> how many bytes are pointed to by data. When invoking memcpy() we need
> >> to careful to only copy len bytes.
> >>
> >> Previously we would copy TLV_LENGTH(len) bytes which would copy an extra
> >> 4 bytes past the end of the data pointer which newer GCC versions
> >> complain about.
> >>
> >>   In file included from test.c:17:
> >>   In function 'TLV_SET',
> >>       inlined from 'test' at test.c:186:5:
> >>   /usr/include/linux/tipc_config.h:317:3:
> >>   warning: 'memcpy' forming offset [33, 36] is out of the bounds [0, 32]
> >>   of object 'bearer_name' with type 'char[32]' [-Warray-bounds]
> >>       memcpy(TLV_DATA(tlv_ptr), data, tlv_len);
> >>       ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> >>   test.c: In function 'test':
> >>   test.c::161:10: note:
> >>   'bearer_name' declared here
> >>       char bearer_name[TIPC_MAX_BEARER_NAME];
> >>            ^~~~~~~~~~~
> >>
> >> Signed-off-by: Chris Packham <chris.packham@alliedtelesis.co.nz>
> > 
> > But now the pad bytes at the end are uninitialized.
> > 
> > The whole idea is that the encapsulating TLV object has to be rounded
> > up in size based upon the given 'len' for the data.
> > 
> 
> TLV_LENGTH() does not account for any padding bytes due to the 
> alignment. TLV_SPACE() does but that wasn't used in the code before my 
> change.
> 
> Are you suggesting something like this
> 
> 
> -        if (len && data)
> -               memcpy(TLV_DATA(tlv_ptr), data, tlv_len);
> +        if (len && data) {
> +               memcpy(TLV_DATA(tlv_ptr), data, len);
> +               memset(TLV_DATA(tlv_ptr) + len, 0, TLV_SPACE(len) - 
> TLV_LENGTH(len));
> +        }
> 
> 

For zeroing out the padding, should that be done in TCM_SET in the same
file as well? That one only copies data_len bytes but doesn't zero out
any alignment padding.
