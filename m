Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 432DA61F5C
	for <lists+netdev@lfdr.de>; Mon,  8 Jul 2019 15:11:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730786AbfGHNLX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Jul 2019 09:11:23 -0400
Received: from mx1.redhat.com ([209.132.183.28]:50786 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728922AbfGHNLX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 8 Jul 2019 09:11:23 -0400
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 2651A3001817;
        Mon,  8 Jul 2019 13:11:15 +0000 (UTC)
Received: from treble (ovpn-112-43.rdu2.redhat.com [10.10.112.43])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 8034839A4C;
        Mon,  8 Jul 2019 13:11:13 +0000 (UTC)
Date:   Mon, 8 Jul 2019 08:11:10 -0500
From:   Josh Poimboeuf <jpoimboe@redhat.com>
To:     Arnd Bergmann <arnd@arndb.de>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [RFC] Revert "bpf: Fix ORC unwinding in non-JIT BPF code"
Message-ID: <20190708130010.pnxlzi5vptuyppxz@treble>
References: <20190708124547.3515538-1-arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20190708124547.3515538-1-arnd@arndb.de>
User-Agent: NeoMutt/20180716
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.40]); Mon, 08 Jul 2019 13:11:23 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jul 08, 2019 at 02:45:23PM +0200, Arnd Bergmann wrote:
> Apparently this was a bit premature, at least I still get this
> warning with gcc-8.1:
> 
> kernel/bpf/core.o: warning: objtool: ___bpf_prog_run()+0x44d2: sibling call from callable instruction with modified stack frame
> 
> This reverts commit b22cf36c189f31883ad0238a69ccf82aa1f3b16b.
> 
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>

Yes, I have been working on a fix.

The impact is that ORC unwinding is broken in this function for
CONFIG_RETPOLINE=n.

I don't think we want to revert this patch though, because that will
broaden the impact to the CONFIG_RETPOLINE=y case.  Anyway I hope to
have fixes soon.

-- 
Josh
