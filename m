Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7AC8846E85E
	for <lists+netdev@lfdr.de>; Thu,  9 Dec 2021 13:22:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237334AbhLIMZb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Dec 2021 07:25:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60740 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229990AbhLIMZa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Dec 2021 07:25:30 -0500
Received: from mail-vk1-xa31.google.com (mail-vk1-xa31.google.com [IPv6:2607:f8b0:4864:20::a31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 77D75C061746;
        Thu,  9 Dec 2021 04:21:57 -0800 (PST)
Received: by mail-vk1-xa31.google.com with SMTP id q21so3647016vkn.2;
        Thu, 09 Dec 2021 04:21:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=w3ReoaqnPEHjdJMe05z68xUf6XudxSIjb7gmP09rJQc=;
        b=qAXe/PUEjSWPGwo4b8gou+dvBHVqhIAIgQxrvG4FTud65PvHoO/e55K661EV3H/B7p
         F1xAxQHtey8CwpR7QFO7JohxqAzuvbmJiq/mZAqAcHTN9cFWocuXT5TwL9/0W3Hz2sDG
         YfMP4QsUAohnNc8LNTza+91rJepm4DX0ikuTuZSGAg0Ecz/yuNkkS8KLdfGQOlmW5RSp
         AUkFG3E+drqcU6ODhkf19gb7AjduYsSv51huT9XT4yCyPxi4WHJw5ywl9glFwtJV42Jm
         GJYSap6GBjQGN0ITA23LEeDWnykD2FllYj4Ai0leFxYP4/rB+OA2FXen3wu57KLbA4f6
         nQaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=w3ReoaqnPEHjdJMe05z68xUf6XudxSIjb7gmP09rJQc=;
        b=ROlKWS/Fdd9K93Oabvzg1rsQMtdXAaU8t3GSD6USvE3+7KEMu/uvRv3Ae0dwYx0Idd
         LFzjJON5F6tKPe8GCermJgPSoRQH4KjE9pMF5ZXY4avG5zo+Pd2pyueJ3+KlKwAmKOpC
         hSb2x/Jcx49P1N7BeCGarBnntWza7CyamJPeIlxFEOsjUeAvUvnygIq94y22fhLS06Nh
         gcTRVaMVoYOKvxN8MktLFCjeVjBg4iVHjXeT40FtFfFTtJyu1hya0NNo7fi5uoKPDE0t
         eQhjzC2Ly6PSCK1LZiK8ymtt9C2rNL2GbLcElhkGoTHWSTb59j2xPww94rXCK2bv8028
         EtOg==
X-Gm-Message-State: AOAM532g9UUZQXWUSKjjrZD0JW6XIBcqJEhiFU8SKS7RHijr/qoBzS7O
        orWfDYk++5KtXUpiP81EsuM=
X-Google-Smtp-Source: ABdhPJziCTAr2E8Bs/ThL9oUGU3K0fyG3S9LlyLkquPvm2rZNuin3u/ToaT22Fm2JY8wZ/2q2NO5EA==
X-Received: by 2002:a05:6122:988:: with SMTP id g8mr8851565vkd.2.1639052516572;
        Thu, 09 Dec 2021 04:21:56 -0800 (PST)
Received: from t14s.localdomain ([177.220.172.101])
        by smtp.gmail.com with ESMTPSA id e13sm3673249vkd.21.2021.12.09.04.21.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Dec 2021 04:21:56 -0800 (PST)
Received: by t14s.localdomain (Postfix, from userid 1000)
        id 5C510ECD30; Thu,  9 Dec 2021 09:21:54 -0300 (-03)
Date:   Thu, 9 Dec 2021 09:21:54 -0300
From:   Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
To:     Lee Jones <lee.jones@linaro.org>
Cc:     linux-kernel@vger.kernel.org, Vlad Yasevich <vyasevich@gmail.com>,
        Neil Horman <nhorman@tuxdriver.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        lksctp developers <linux-sctp@vger.kernel.org>,
        "H.P. Yarroll" <piggy@acm.org>,
        Karl Knutson <karl@athena.chicago.il.us>,
        Jon Grimm <jgrimm@us.ibm.com>,
        Xingang Guo <xingang.guo@intel.com>,
        Hui Huang <hui.huang@nokia.com>,
        Sridhar Samudrala <sri@us.ibm.com>,
        Daisy Chang <daisyc@us.ibm.com>,
        Ryan Layer <rmlayer@us.ibm.com>,
        Kevin Gao <kevin.gao@intel.com>, netdev@vger.kernel.org
Subject: Re: [PATCH 1/1] sctp: Protect cached endpoints to prevent possible
 UAF
Message-ID: <YbH04oUdLf2XML23@t14s.localdomain>
References: <20211208165434.2962062-1-lee.jones@linaro.org>
 <YbDlFFVPm/MYEoOQ@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YbDlFFVPm/MYEoOQ@google.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Dec 08, 2021 at 05:02:12PM +0000, Lee Jones wrote:
> On Wed, 08 Dec 2021, Lee Jones wrote:
> 
> > The cause of the resultant dump_stack() reported below is a
> > dereference of a freed pointer to 'struct sctp_endpoint' in
> > sctp_sock_dump().
> > 
> > This race condition occurs when a transport is cached into its
> > associated hash table then freed prior to its subsequent use in
> > sctp_diag_dump() which uses sctp_for_each_transport() to walk the
> > (now out of date) hash table calling into sctp_sock_dump() where the
> > dereference occurs.
> > 
> > To prevent this from happening we need to take a reference on the
> > to-be-used/dereferenced 'struct sctp_endpoint' until such a time when
> > we know it can be safely released.
> > 
> > When KASAN is not enabled, a similar, but slightly different NULL
> > pointer derefernce crash occurs later along the thread of execution in
> > inet_sctp_diag_fill() this time.
> > 
> >   BUG: KASAN: use-after-free in sctp_sock_dump+0xa8/0x438 [sctp_diag]
> >   Call trace:
> >    dump_backtrace+0x0/0x2dc
> >    show_stack+0x20/0x2c
> >    dump_stack+0x120/0x144
> >    print_address_description+0x80/0x2f4
> >    __kasan_report+0x174/0x194
> >    kasan_report+0x10/0x18
> >    __asan_load8+0x84/0x8c
> >    sctp_sock_dump+0xa8/0x438 [sctp_diag]
> >    sctp_for_each_transport+0x1e0/0x26c [sctp]
> >    sctp_diag_dump+0x180/0x1f0 [sctp_diag]
> >    inet_diag_dump+0x12c/0x168
> >    netlink_dump+0x24c/0x5b8
> >    __netlink_dump_start+0x274/0x2a8
> >    inet_diag_handler_cmd+0x224/0x274
> >    sock_diag_rcv_msg+0x21c/0x230
> >    netlink_rcv_skb+0xe0/0x1bc
> >    sock_diag_rcv+0x34/0x48
> >    netlink_unicast+0x3b4/0x430
> >    netlink_sendmsg+0x4f0/0x574
> >    sock_write_iter+0x18c/0x1f0
> >    do_iter_readv_writev+0x230/0x2a8
> >    do_iter_write+0xc8/0x2b4
> >    vfs_writev+0xf8/0x184
> >    do_writev+0xb0/0x1a8
> >    __arm64_sys_writev+0x4c/0x5c
> >    el0_svc_common+0x118/0x250
> >    el0_svc_handler+0x3c/0x9c
> >    el0_svc+0x8/0xc
> 
> This looks related (reported 3 years ago!)
> 
>   https://lore.kernel.org/all/20181122131344.GD31918@localhost.localdomain/

Agree, seems related. Thanks for root causing it.
