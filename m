Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EC414180893
	for <lists+netdev@lfdr.de>; Tue, 10 Mar 2020 20:53:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727272AbgCJTxY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Mar 2020 15:53:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:40202 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726604AbgCJTxX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 10 Mar 2020 15:53:23 -0400
Received: from kicinski-fedora-PC1C0HJN (unknown [163.114.132.128])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 03047215A4;
        Tue, 10 Mar 2020 19:53:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583870003;
        bh=3kKKbDoTMrPAQC5oGwvt+aUNCOax7tpwbm/M0z4Cri4=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Hh2lmvyjLnEgag23ygqylV7ngcJC5Lm04ssuHfFVohoZcVE4QYaCIFjoCWyCymb8J
         jJNbnVTR+p/4NndlD4fVDAgX2ShlKfhGyKoY1gQQRHVS/X2os8huLDEVWOp6W6dSPB
         LO2g9ReMr3kFWiBFl9FL/QoboBoUes7FG8AuNioQ=
Date:   Tue, 10 Mar 2020 12:53:21 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Petr Machata <petrm@mellanox.com>
Cc:     Ido Schimmel <idosch@idosch.org>, netdev@vger.kernel.org,
        davem@davemloft.net, jiri@mellanox.com, jhs@mojatatu.com,
        xiyou.wangcong@gmail.com, mlxsw@mellanox.com,
        Ido Schimmel <idosch@mellanox.com>
Subject: Re: [PATCH net-next 2/6] net: sched: Add centralized RED flag
 checking
Message-ID: <20200310125321.699b36bc@kicinski-fedora-PC1C0HJN>
In-Reply-To: <87sgigy1zr.fsf@mellanox.com>
References: <20200309183503.173802-1-idosch@idosch.org>
        <20200309183503.173802-3-idosch@idosch.org>
        <20200309151818.4350fae6@kicinski-fedora-PC1C0HJN>
        <87sgigy1zr.fsf@mellanox.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 10 Mar 2020 10:48:24 +0100 Petr Machata wrote:
> > The only flags which are validated today are the gRED per-vq ones, which
> > are a recent addition and were validated from day one.  
> 
> Do you consider the validation as such to be a problem? Because that
> would mean that the qdiscs that have not validated flags this way
> basically cannot be extended ever ("a buggy userspace used to get a
> quiet slicing of flags, and now they mean something").

I just remember leaving it as is when I was working on GRED, because 
of the potential breakage. The uAPI policy is what it is, then again
we probably lose more by making the code of these ancient Qdiscs ugly
than we win :(

I don't feel like I can ack it with clear conscience tho.
