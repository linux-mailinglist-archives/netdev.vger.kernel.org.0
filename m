Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 409EC2FAFC7
	for <lists+netdev@lfdr.de>; Tue, 19 Jan 2021 06:02:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726953AbhASFAJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Jan 2021 00:00:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41334 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389390AbhASEwH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Jan 2021 23:52:07 -0500
Received: from mail-oi1-x22a.google.com (mail-oi1-x22a.google.com [IPv6:2607:f8b0:4864:20::22a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 944FCC061573;
        Mon, 18 Jan 2021 20:51:27 -0800 (PST)
Received: by mail-oi1-x22a.google.com with SMTP id d203so19979604oia.0;
        Mon, 18 Jan 2021 20:51:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=YyUpixJdOFKDLwx0E5YLjJFkuvrbBxDPQNmPONztm6I=;
        b=LMX8+uwpqdNEXFDvRTkuqF+zOOFUp64zE4GT2cQ+/U4Z67cjiEvqlmEbGnk7jBlFqb
         IsfvV9CVRxojoyeKSwhABQfOTxKvlCCYOvqlujV+B3MCYPnV+Cel2Ytqn2zExqq0OO+T
         jztrqBwzUmCOuJfpu73MgF+UAVV0zCYKZ+1MEuObZRfFo7kh4crAGDgk7BAhE9KzyKzk
         XM4KAd4FqZ0SngOpbGq9TS9XeV5g+ge4lGHI670qanzMQjrc5B514XfEBvJ93XxXw5Se
         lvB7GjYDacc2XZzRIsmFEuS9D7ovz66JfKGL8DH+UHFk8+rDWIIs93DvCDwBXmhtSdf/
         75sA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=YyUpixJdOFKDLwx0E5YLjJFkuvrbBxDPQNmPONztm6I=;
        b=liMM8oyeP0WcDetTpNjPdSvb3QIskhvmyAf7UKVd4byERGYbbaBNJ0BjAXnWHvzu4b
         uYmCYG3WohoHIxWdBx5Tu3eOke2lzpYMyUXomp5ZgbP5RIcOna4Pvh6jN6GfSC2twk7w
         pKCSeXZ8Forf1Q8q4BsDgmkAFN0hJta5uz0xu0BhxxTDVXE3BqRPS+tOtL9bHhGScz+7
         r4mOq5QtsnaFHkQJKtpBLr/KGTtJFxoTZzcUW8SgGayJ6dKhInzCRNQtf7PDvIleHS2p
         Mshwnbv8g90XiPPqxKd+TdViqBwvK0b7cU7MDZdZiXO+g18kBBFFXqpD+UmVwMnAzJ0R
         +ICQ==
X-Gm-Message-State: AOAM533U1Q7BW4tAbTNcDZ7tHkYHF3VYds3s3LuAgGlhgaCZkziYS8Iz
        NZ32XCyNKBf9MYCoM1qMrhY=
X-Google-Smtp-Source: ABdhPJwTFgRyM9aXittIDXrWXQYpGEIiPG1accCJ4rcXgle4i8zzIDyRzBIEZzpjKzTLG+4tARhFhw==
X-Received: by 2002:aca:f44f:: with SMTP id s76mr1601888oih.120.1611031886945;
        Mon, 18 Jan 2021 20:51:26 -0800 (PST)
Received: from localhost.localdomain (99-6-134-177.lightspeed.snmtca.sbcglobal.net. [99.6.134.177])
        by smtp.gmail.com with ESMTPSA id s24sm3694402oij.20.2021.01.18.20.51.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Jan 2021 20:51:26 -0800 (PST)
Date:   Mon, 18 Jan 2021 20:51:23 -0800
From:   Enke Chen <enkechen2020@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Eric Dumazet <edumazet@google.com>,
        Yuchung Cheng <ycheng@google.com>,
        Soheil Hassas Yeganeh <soheil@google.com>,
        Neal Cardwell <ncardwell@google.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Jonathan Maxwell <jmaxwell37@gmail.com>,
        William McCall <william.mccall@gmail.com>,
        enkechen2020@gmail.com
Subject: Re: [PATCH net v2] tcp: fix TCP_USER_TIMEOUT with zero window
Message-ID: <20210119045123.GA26806@localhost.localdomain>
References: <20210115223058.GA39267@localhost.localdomain>
 <20210118200221.73033add@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210118200221.73033add@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jan 18, 2021 at 08:02:21PM -0800, Jakub Kicinski wrote:
> On Fri, 15 Jan 2021 14:30:58 -0800 Enke Chen wrote:
> > From: Enke Chen <enchen@paloaltonetworks.com>
> > 
> > The TCP session does not terminate with TCP_USER_TIMEOUT when data
> > remain untransmitted due to zero window.
> > 
> > The number of unanswered zero-window probes (tcp_probes_out) is
> > reset to zero with incoming acks irrespective of the window size,
> > as described in tcp_probe_timer():
> > 
> >     RFC 1122 4.2.2.17 requires the sender to stay open indefinitely
> >     as long as the receiver continues to respond probes. We support
> >     this by default and reset icsk_probes_out with incoming ACKs.
> > 
> > This counter, however, is the wrong one to be used in calculating the
> > duration that the window remains closed and data remain untransmitted.
> > Thanks to Jonathan Maxwell <jmaxwell37@gmail.com> for diagnosing the
> > actual issue.
> > 
> > In this patch a new timestamp is introduced for the socket in order to
> > track the elapsed time for the zero-window probes that have not been
> > answered with any non-zero window ack.
> > 
> > Fixes: 9721e709fa68 ("tcp: simplify window probe aborting on USER_TIMEOUT")
> > Reported-by: William McCall <william.mccall@gmail.com>
> > Co-developed-by: Neal Cardwell <ncardwell@google.com>
> > Signed-off-by: Neal Cardwell <ncardwell@google.com>
> > Signed-off-by: Enke Chen <enchen@paloaltonetworks.com>
> > Reviewed-by: Yuchung Cheng <ycheng@google.com>
> > Reviewed-by: Eric Dumazet <edumazet@google.com>
> 
> I take it you got all these tags off-list? I don't see them on the v1
> discussion.

Yes, the tags have been approved off-list by those named.

> 
> Applied to net, thanks!

Thanks.  -- Enke
