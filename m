Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E46C1BE63C
	for <lists+netdev@lfdr.de>; Wed, 25 Sep 2019 22:19:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393054AbfIYUTZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Sep 2019 16:19:25 -0400
Received: from www62.your-server.de ([213.133.104.62]:60246 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727743AbfIYUTZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Sep 2019 16:19:25 -0400
Received: from [178.197.248.15] (helo=localhost)
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1iDDkn-0001Me-Cr; Wed, 25 Sep 2019 22:19:13 +0200
Date:   Wed, 25 Sep 2019 22:19:13 +0200
From:   Daniel Borkmann <daniel@iogearbox.net>
To:     Stanislav Fomichev <sdf@google.com>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org, davem@davemloft.net,
        ast@kernel.org
Subject: Re: [PATCH bpf v2] selftests/bpf: test_progs: fix client/server race
 in tcp_rtt
Message-ID: <20190925201913.GA9500@pc-63.home>
References: <20190923184112.196358-1-sdf@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190923184112.196358-1-sdf@google.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.101.4/25583/Wed Sep 25 10:27:51 2019)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Sep 23, 2019 at 11:41:12AM -0700, Stanislav Fomichev wrote:
> This is the same problem I found earlier in test_sockopt_inherit:
> there is a race between server thread doing accept() and client
> thread doing connect(). Let's explicitly synchronize them via
> pthread conditional variable.
> 
> v2:
> * don't exit from server_thread without signaling condvar,
>   fixes possible issue where main() would wait forever (Andrii Nakryiko)
> 
> Fixes: b55873984dab ("selftests/bpf: test BPF_SOCK_OPS_RTT_CB")
> Signed-off-by: Stanislav Fomichev <sdf@google.com>

Applied, thanks!
