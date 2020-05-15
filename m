Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 963311D5916
	for <lists+netdev@lfdr.de>; Fri, 15 May 2020 20:29:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726339AbgEOS3s (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 May 2020 14:29:48 -0400
Received: from ma1-aaemail-dr-lapp01.apple.com ([17.171.2.60]:56700 "EHLO
        ma1-aaemail-dr-lapp01.apple.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726197AbgEOS3s (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 May 2020 14:29:48 -0400
Received: from pps.filterd (ma1-aaemail-dr-lapp01.apple.com [127.0.0.1])
        by ma1-aaemail-dr-lapp01.apple.com (8.16.0.42/8.16.0.42) with SMTP id 04FIOs6o019024;
        Fri, 15 May 2020 11:29:39 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=apple.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=20180706; bh=/se8Rr3A0QMHGozpwD1QXFYY+EnkRjnbA/sKUpTPtWI=;
 b=d4KzZE68WD+tfliQ2H4ZDW0K5Ho+nWC6IurkPsB8uiC0GrPntjWPjEljrpo/xDdqUvbK
 cFPERX86ECkAudvkzmDv24stDWMxf1PIjrZwbGoaLKZGWypWfyRmwN2wqnhpAWiJhqjP
 XFzy/S7jn2cFyae5g22caCRoeQ+0xt+kdpIfaN4zof8jGl9Bg0WOzuC/fTej3o3KXSDP
 EMCr/ttAaZ1TGQH1h63ivYGK4kmJuOBeL7Y4uiEft27dFykwO39buVY9lkafckHld6hd
 ApHGgtbklWsRsF9PkQ5S9TD4olYQsdqmH+ezzuIvZgTb/hWHQR8AnrTiYGUjih5x16rz nw== 
Received: from rn-mailsvcp-mta-lapp04.rno.apple.com (rn-mailsvcp-mta-lapp04.rno.apple.com [10.225.203.152])
        by ma1-aaemail-dr-lapp01.apple.com with ESMTP id 3100x1fv1a-5
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO);
        Fri, 15 May 2020 11:29:39 -0700
Received: from rn-mailsvcp-mmp-lapp04.rno.apple.com
 (rn-mailsvcp-mmp-lapp04.rno.apple.com [17.179.253.17])
 by rn-mailsvcp-mta-lapp04.rno.apple.com
 (Oracle Communications Messaging Server 8.1.0.5.20200312 64bit (built Mar 12
 2020)) with ESMTPS id <0QAD00PAHY19P4F0@rn-mailsvcp-mta-lapp04.rno.apple.com>;
 Fri, 15 May 2020 11:29:33 -0700 (PDT)
Received: from process_milters-daemon.rn-mailsvcp-mmp-lapp04.rno.apple.com by
 rn-mailsvcp-mmp-lapp04.rno.apple.com
 (Oracle Communications Messaging Server 8.1.0.5.20200312 64bit (built Mar 12
 2020)) id <0QAD00500XUDZO00@rn-mailsvcp-mmp-lapp04.rno.apple.com>; Fri,
 15 May 2020 11:29:33 -0700 (PDT)
X-Va-A: 
X-Va-T-CD: f57a8199e6b1abd084bca0291b03c14e
X-Va-E-CD: 1cbcebcfde8a41282eb0f5c4e7847f42
X-Va-R-CD: e64278141933bf3ea6f37ad9e66ed532
X-Va-CD: 0
X-Va-ID: fa941644-27e3-4847-b570-aeae098bfb10
X-V-A:  
X-V-T-CD: f57a8199e6b1abd084bca0291b03c14e
X-V-E-CD: 1cbcebcfde8a41282eb0f5c4e7847f42
X-V-R-CD: e64278141933bf3ea6f37ad9e66ed532
X-V-CD: 0
X-V-ID: 2172c1b7-56f0-4ffb-be04-3e490b129f26
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.676
 definitions=2020-05-15_07:2020-05-15,2020-05-15 signatures=0
Received: from localhost ([17.232.192.63])
 by rn-mailsvcp-mmp-lapp04.rno.apple.com
 (Oracle Communications Messaging Server 8.1.0.5.20200312 64bit (built Mar 12
 2020))
 with ESMTPSA id <0QAD00758Y189V00@rn-mailsvcp-mmp-lapp04.rno.apple.com>; Fri,
 15 May 2020 11:29:32 -0700 (PDT)
Date:   Fri, 15 May 2020 11:29:32 -0700
From:   Christoph Paasch <cpaasch@apple.com>
To:     Paolo Abeni <pabeni@redhat.com>
Cc:     netdev@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
        "David S . Miller" <davem@davemloft.net>, mptcp@lists.01.org,
        Mat Martineau <mathew.j.martineau@linux.intel.com>
Subject: Re: [PATCH net-next v2 1/3] mptcp: add new sock flag to deal with join
 subflows
Message-id: <20200515182932.GA45434@MacBook-Pro-64.local>
References: <cover.1589558049.git.pabeni@redhat.com>
 <a5acf97e4f39de13ba178a3a007eedd83b418702.1589558049.git.pabeni@redhat.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-disposition: inline
In-reply-to: <a5acf97e4f39de13ba178a3a007eedd83b418702.1589558049.git.pabeni@redhat.com>
User-Agent: Mutt/1.12.2 (2019-09-21)
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.676
 definitions=2020-05-15_07:2020-05-15,2020-05-15 signatures=0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 15/05/20 - 19:22:15, Paolo Abeni wrote:
> MP_JOIN subflows must not land into the accept queue.
> Currently tcp_check_req() calls an mptcp specific helper
> to detect such scenario.
> 
> Such helper leverages the subflow context to check for
> MP_JOIN subflows. We need to deal also with MP JOIN
> failures, even when the subflow context is not available
> due allocation failure.
> 
> A possible solution would be changing the syn_recv_sock()
> signature to allow returning a more descriptive action/
> error code and deal with that in tcp_check_req().
> 
> Since the above need is MPTCP specific, this patch instead
> uses a TCP request socket hole to add a MPTCP specific flag.
> Such flag is used by the MPTCP syn_recv_sock() to tell
> tcp_check_req() how to deal with the request socket.
> 
> This change is a no-op for !MPTCP build, and makes the
> MPTCP code simpler. It allows also the next patch to deal
> correctly with MP JOIN failure.
> 
> v1 -> v2:
>  - be more conservative on drop_req initialization (Mat)
> 
> RFC -> v1:
>  - move the drop_req bit inside tcp_request_sock (Eric)
> 
> Signed-off-by: Paolo Abeni <pabeni@redhat.com>
> ---
>  include/linux/tcp.h      |  3 +++
>  include/net/mptcp.h      | 17 ++++++++++-------
>  net/ipv4/tcp_minisocks.c |  2 +-
>  net/mptcp/protocol.c     |  7 -------
>  net/mptcp/subflow.c      |  3 +++
>  5 files changed, 17 insertions(+), 15 deletions(-)


Reviewed-by: Christoph Paasch <cpaasch@apple.com>

