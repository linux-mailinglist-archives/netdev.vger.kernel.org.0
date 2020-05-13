Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A1BA41D1BE3
	for <lists+netdev@lfdr.de>; Wed, 13 May 2020 19:07:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389788AbgEMRH0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 May 2020 13:07:26 -0400
Received: from ma1-aaemail-dr-lapp02.apple.com ([17.171.2.68]:55092 "EHLO
        ma1-aaemail-dr-lapp02.apple.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728068AbgEMRH0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 May 2020 13:07:26 -0400
Received: from pps.filterd (ma1-aaemail-dr-lapp02.apple.com [127.0.0.1])
        by ma1-aaemail-dr-lapp02.apple.com (8.16.0.42/8.16.0.42) with SMTP id 04DGxVto051502;
        Wed, 13 May 2020 10:07:21 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=apple.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=20180706; bh=42VhPZa4O3yw3qMUKHX2/5Sg4e5t6eapEjpyLDItKTY=;
 b=IY/BRNNLaRlMcBMceSYc3YA8MW+ef2OhFzJSISF2rujvp/DqgWVBroKiX2xxR6/7pGm4
 Ra5ltwYXuUXzdevOk2thafNmw+DdRThqbL2Z5sKfhAsJ0G9R9kZzYBtVWyBf3gJI7/rq
 lPcZ3+nN5TlkBIBiAzx4Dj/r7rPqYqZn9QfZLEfQDUOUy5QbYEwSEueJ2vL7B+rZPgys
 TpuTUhUopRHwuoQzVmqmxgZ/VmOUyLJCHZXLtzrglRq3JYCYHhkNLDK1bn6Ry10pdeuI
 3EnHg0hDdfS8Gzdxx16FN40+Op22ZJf+RVgFwYYNh2yHob7NCSgzuPnTHdyg+fMCL1Ib FQ== 
Received: from rn-mailsvcp-mta-lapp01.rno.apple.com (rn-mailsvcp-mta-lapp01.rno.apple.com [10.225.203.149])
        by ma1-aaemail-dr-lapp02.apple.com with ESMTP id 3100xcber1-15
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO);
        Wed, 13 May 2020 10:07:21 -0700
Received: from rn-mailsvcp-mmp-lapp04.rno.apple.com
 (rn-mailsvcp-mmp-lapp04.rno.apple.com [17.179.253.17])
 by rn-mailsvcp-mta-lapp01.rno.apple.com
 (Oracle Communications Messaging Server 8.1.0.5.20200312 64bit (built Mar 12
 2020)) with ESMTPS id <0QAA00P564W845I0@rn-mailsvcp-mta-lapp01.rno.apple.com>;
 Wed, 13 May 2020 10:07:20 -0700 (PDT)
Received: from process_milters-daemon.rn-mailsvcp-mmp-lapp04.rno.apple.com by
 rn-mailsvcp-mmp-lapp04.rno.apple.com
 (Oracle Communications Messaging Server 8.1.0.5.20200312 64bit (built Mar 12
 2020)) id <0QAA010004KB7G00@rn-mailsvcp-mmp-lapp04.rno.apple.com>; Wed,
 13 May 2020 10:07:20 -0700 (PDT)
X-Va-A: 
X-Va-T-CD: f57a8199e6b1abd084bca0291b03c14e
X-Va-E-CD: 4f2abbce232c5488497f887bd4f0e086
X-Va-R-CD: 25812e5303df4d9ccf0ca119e2d2cbd3
X-Va-CD: 0
X-Va-ID: 882e9cbb-b310-4ba0-8b3e-8c26b9561132
X-V-A:  
X-V-T-CD: f57a8199e6b1abd084bca0291b03c14e
X-V-E-CD: 4f2abbce232c5488497f887bd4f0e086
X-V-R-CD: 25812e5303df4d9ccf0ca119e2d2cbd3
X-V-CD: 0
X-V-ID: 87cb1214-4aa3-456f-8a50-04eb3487e5cd
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.676
 definitions=2020-05-13_08:2020-05-13,2020-05-13 signatures=0
Received: from localhost ([17.234.56.181])
 by rn-mailsvcp-mmp-lapp04.rno.apple.com
 (Oracle Communications Messaging Server 8.1.0.5.20200312 64bit (built Mar 12
 2020))
 with ESMTPSA id <0QAA00JGU4W76B00@rn-mailsvcp-mmp-lapp04.rno.apple.com>; Wed,
 13 May 2020 10:07:19 -0700 (PDT)
Date:   Wed, 13 May 2020 10:07:18 -0700
From:   Christoph Paasch <cpaasch@apple.com>
To:     Paolo Abeni <pabeni@redhat.com>
Cc:     netdev@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
        "David S . Miller" <davem@davemloft.net>
Subject: Re: [PATCH net-next 0/3] mptcp: fix MP_JOIN failure handling
Message-id: <20200513170718.GB10555@MacBook-Pro-64.local>
References: <cover.1589383730.git.pabeni@redhat.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-disposition: inline
In-reply-to: <cover.1589383730.git.pabeni@redhat.com>
User-Agent: Mutt/1.12.2 (2019-09-21)
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.676
 definitions=2020-05-13_07:2020-05-13,2020-05-13 signatures=0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 13/05/20 - 17:31:01, Paolo Abeni wrote:
> Currently if we hit an MP_JOIN failure on the third ack, the child socket is
> closed with reset, but the request socket is not deleted, causing weird
> behaviors.
> 
> The main problem is that MPTCP's MP_JOIN code needs to plug it's own
> 'valid 3rd ack' checks and the current TCP callbacks do not allow that.
> 
> This series tries to address the above shortcoming introducing a new MPTCP
> specific bit in a 'struct tcp_request_sock' hole, and leveraging that to allow
> tcp_check_req releasing the request socket when needed.
> 
> The above allows cleaning-up a bit current MPTCP hooking in tcp_check_req().
> 
> An alternative solution, possibly cleaner but more invasive, would be
> changing the 'bool *own_req' syn_recv_sock() argument into 'int *req_status'
> and let MPTCP set it to 'REQ_DROP'.
> 
> RFC -> v1:
>  - move the drop_req bit inside tcp_request_sock (Eric)
> 
> Paolo Abeni (3):
>   mptcp: add new sock flag to deal with join subflows
>   inet_connection_sock: factor out destroy helper.
>   mptcp: cope better with MP_JOIN failure
> 
>  include/linux/tcp.h                |  3 +++
>  include/net/inet_connection_sock.h |  8 ++++++++
>  include/net/mptcp.h                | 17 ++++++++++-------
>  net/ipv4/inet_connection_sock.c    |  6 +-----
>  net/ipv4/tcp_minisocks.c           |  2 +-
>  net/mptcp/protocol.c               |  7 -------
>  net/mptcp/subflow.c                | 17 +++++++++++------
>  7 files changed, 34 insertions(+), 26 deletions(-)

Reviewed-by: Christoph Paasch <cpaasch@apple.com>



Christoph

