Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 722561E92AC
	for <lists+netdev@lfdr.de>; Sat, 30 May 2020 18:43:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729151AbgE3QnX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 30 May 2020 12:43:23 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:20385 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728927AbgE3QnX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 30 May 2020 12:43:23 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1590857001;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=wZf4AcQfH0ropKMoOlCZU3Elgy9S461kQFfCXa24wvE=;
        b=R6WvX68fKvWgFpRT5FVJ3cOMc8Us+Nc82oRqKQazFfwWE0w8thhURgDLHu2GlWMn2sEcLQ
        AZfWLQPe5NBpvEURdjkeQiB6yNURhdJdAFp1OAvDGl4wZJs/WLUBlwygR1N/JPvbCllAr/
        xgAsXw1ueSd4whFdxSC5Bw3xCuTnUbY=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-222-vyCZ4tD6O6iQy_8gxhfciQ-1; Sat, 30 May 2020 12:43:18 -0400
X-MC-Unique: vyCZ4tD6O6iQy_8gxhfciQ-1
Received: by mail-wr1-f71.google.com with SMTP id h6so2414895wrx.4
        for <netdev@vger.kernel.org>; Sat, 30 May 2020 09:43:18 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=wZf4AcQfH0ropKMoOlCZU3Elgy9S461kQFfCXa24wvE=;
        b=H6rs2njlarnSgtWyq9Flkoa6SirfGUwQ1z5V8zX8z+z97rBusul51xZrbWftGKqlnN
         oWUS+v7WM/gyIWXsibkAnCxqHM6BrDBCqhT59lFlnI7izsjvALC3M+sv2s8NSnAMtIFc
         khpU45I+Y0cFiXD0jRLWGp3lpKe5YrLCp8y/MRBR+KrF66T/DOmW+PkoqzqFyw4OypJW
         CNeVv7VwlvpsHe1sV/Gr0L30JTm0CQcL7KD9urwk9tBnD/quf+p2Y3Q6AxIIE3alAn8i
         UnqHqVdmuJSR+kQOJ8K9U2iteNBxghtbrjOrzlwxDOtxdDhPw95+1o3Ae70JaqHn+yDx
         bNhQ==
X-Gm-Message-State: AOAM533i1+zRNkoV6Ywihvb+RryOxEQ89HRSiq/aJ2gD3T1GYqdYQBsQ
        nkFDf8H6SlLaeXOl/IqbE8TmB4GRokJgFDlOfAw4JKUWk0g0RixplJ2xGduAEl+hsXoDr52w+sr
        Dt4+BpfaeLv8oBnww
X-Received: by 2002:a1c:7903:: with SMTP id l3mr6749829wme.50.1590856997712;
        Sat, 30 May 2020 09:43:17 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJx8w3ZNctiQFmF5ZSRztquGP+y9cNvFSewUVTCPhNv0kpqsXEoYgjFdjybNCjr1Odx9xbgdjA==
X-Received: by 2002:a1c:7903:: with SMTP id l3mr6749808wme.50.1590856997496;
        Sat, 30 May 2020 09:43:17 -0700 (PDT)
Received: from pc-3.home (2a01cb058918ce00dd1a5a4f9908f2d5.ipv6.abo.wanadoo.fr. [2a01:cb05:8918:ce00:dd1a:5a4f:9908:f2d5])
        by smtp.gmail.com with ESMTPSA id s8sm11446368wrm.96.2020.05.30.09.43.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 30 May 2020 09:43:16 -0700 (PDT)
Date:   Sat, 30 May 2020 18:43:14 +0200
From:   Guillaume Nault <gnault@redhat.com>
To:     Arnd Bergmann <arnd@arndb.de>
Cc:     Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Vlad Buslov <vladbu@mellanox.com>,
        Xin Long <lucien.xin@gmail.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] flow_dissector: work around stack frame size warning
Message-ID: <20200530164314.GA31920@pc-3.home>
References: <20200529201413.397679-1-arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200529201413.397679-1-arnd@arndb.de>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, May 29, 2020 at 10:13:58PM +0200, Arnd Bergmann wrote:
> The fl_flow_key structure is around 500 bytes, so having two of them
> on the stack in one function now exceeds the warning limit after an
> otherwise correct change:
> 
> net/sched/cls_flower.c:298:12: error: stack frame size of 1056 bytes in function 'fl_classify' [-Werror,-Wframe-larger-than=]
> 
> I suspect the fl_classify function could be reworked to only have one
> of them on the stack and modify it in place, but I could not work out
> how to do that.
> 
> As a somewhat hacky workaround, move one of them into an out-of-line
> function to reduce its scope. This does not necessarily reduce the stack
> usage of the outer function, but at least the second copy is removed
> from the stack during most of it and does not add up to whatever is
> called from there.
> 
> I now see 552 bytes of stack usage for fl_classify(), plus 528 bytes
> for fl_mask_lookup().
> 
> Fixes: 58cff782cc55 ("flow_dissector: Parse multiple MPLS Label Stack Entries")
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> 
Sorry, I didn't see that, as my .config has CONFIG_FRAME_WARN=2048,
which seems to be the default for x86_64.

Acked-by: Guillaume Nault <gnault@redhat.com>

