Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1AE02DB0DC
	for <lists+netdev@lfdr.de>; Thu, 17 Oct 2019 17:14:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404687AbfJQPOy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Oct 2019 11:14:54 -0400
Received: from www62.your-server.de ([213.133.104.62]:38048 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728994AbfJQPOy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Oct 2019 11:14:54 -0400
Received: from 55.249.197.178.dynamic.dsl-lte-bonding.lssmb00p-msn.res.cust.swisscom.ch ([178.197.249.55] helo=localhost)
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1iL7UD-0005K6-V8; Thu, 17 Oct 2019 17:14:46 +0200
Date:   Thu, 17 Oct 2019 17:14:45 +0200
From:   Daniel Borkmann <daniel@iogearbox.net>
To:     Alexei Starovoitov <ast@kernel.org>
Cc:     davem@davemloft.net, x86@kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, kernel-team@fb.com
Subject: Re: [PATCH v3 bpf-next 00/11] bpf: revolutionize bpf tracing
Message-ID: <20191017151445.GB26267@pc-63.home>
References: <20191016032505.2089704-1-ast@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191016032505.2089704-1-ast@kernel.org>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.101.4/25605/Thu Oct 17 10:52:31 2019)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Oct 15, 2019 at 08:24:54PM -0700, Alexei Starovoitov wrote:
> v2->v3:
> - while trying to adopt btf-based tracing in production service realized
>   that disabling bpf_probe_read() was premature. The real tracing program
>   needs to see much more than this type safe tracking can provide.
>   With these patches the verifier will be able to see that skb->data
>   is a pointer to 'u8 *', but it cannot possibly know how many bytes
>   of it is readable. Hence bpf_probe_read() is necessary to do basic
>   packet reading from tracing program. Some helper can be introduced to
>   solve this particular problem, but there are other similar structures.
>   Another issue is bitfield reading. The support for bitfields
>   is coming to llvm. libbpf will be supporting it eventually as well,
>   but there will be corner cases where bpf_probe_read() is necessary.
>   The long term goal is still the same: get rid of probe_read eventually.
> - fixed build issue with clang reported by Nathan Chancellor.
> - addressed a ton of comments from Andrii.
>   bitfields and arrays are explicitly unsupported in btf-based tracking.
>   This will be improved in the future.
>   Right now the verifier is more strict than necessary.
>   In some cases it can fall back to 'scalar' instead of rejecting
>   the program, but rejection today allows to make better decisions
>   in the future.
> - adjusted testcase to demo bitfield and skb->data reading.

Applied, thanks!
