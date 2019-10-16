Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DA7A6D920B
	for <lists+netdev@lfdr.de>; Wed, 16 Oct 2019 15:10:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393466AbfJPNKb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Oct 2019 09:10:31 -0400
Received: from www62.your-server.de ([213.133.104.62]:51438 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727080AbfJPNKb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Oct 2019 09:10:31 -0400
Received: from [2a02:120b:2c12:c120:71a0:62dd:894c:fd0e] (helo=localhost)
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1iKj4H-0002aC-34; Wed, 16 Oct 2019 15:10:21 +0200
Date:   Wed, 16 Oct 2019 15:10:20 +0200
From:   Daniel Borkmann <daniel@iogearbox.net>
To:     Ben Dooks <ben.dooks@codethink.co.uk>
Cc:     linux-kernel@lists.codethink.co.uk,
        Alexei Starovoitov <ast@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: bpf: add static in net/core/filter.c
Message-ID: <20191016131020.GE21367@pc-63.home>
References: <20191016110446.24622-1-ben.dooks@codethink.co.uk>
 <20191016122605.GC21367@pc-63.home>
 <e947b15d-1d70-39d9-3b28-0367a3f0f4c0@codethink.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <e947b15d-1d70-39d9-3b28-0367a3f0f4c0@codethink.co.uk>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.101.4/25604/Wed Oct 16 10:53:05 2019)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Oct 16, 2019 at 02:02:31PM +0100, Ben Dooks wrote:
> On 16/10/2019 13:26, Daniel Borkmann wrote:
> > On Wed, Oct 16, 2019 at 12:04:46PM +0100, Ben Dooks (Codethink) wrote:
> > > There are a number of structs in net/core/filter.c
> > > that are not exported or declared outside of the
> > > file. Fix the following warnings by making these
> > > all static:
> > > 
> > > net/core/filter.c:8465:31: warning: symbol 'sk_filter_verifier_ops' was not declared. Should it be static?
> > > net/core/filter.c:8472:27: warning: symbol 'sk_filter_prog_ops' was not declared. Should it be static?
> > [...]
> > > net/core/filter.c:8935:27: warning: symbol 'sk_reuseport_prog_ops' was not declared. Should it be static?
> > > 
> > > Signed-off-by: Ben Dooks <ben.dooks@codethink.co.uk>
> > > ---
> > > Cc: Alexei Starovoitov <ast@kernel.org>
> > > Cc: Daniel Borkmann <daniel@iogearbox.net>
> > > Cc: Martin KaFai Lau <kafai@fb.com>
> > > Cc: Song Liu <songliubraving@fb.com>
> > > Cc: Yonghong Song <yhs@fb.com>
> > > Cc: "David S. Miller" <davem@davemloft.net>
> > > Cc: Jakub Kicinski <jakub.kicinski@netronome.com>
> > > Cc: Jesper Dangaard Brouer <hawk@kernel.org>
> > > Cc: John Fastabend <john.fastabend@gmail.com>
> > > Cc: netdev@vger.kernel.org
> > > Cc: bpf@vger.kernel.org
> > > Cc: linux-kernel@vger.kernel.org
> > > ---
> > >   net/core/filter.c | 60 +++++++++++++++++++++++------------------------
> > >   1 file changed, 30 insertions(+), 30 deletions(-)
> > > 
> > > diff --git a/net/core/filter.c b/net/core/filter.c
> > > index ed6563622ce3..f7338fee41f8 100644
> > > --- a/net/core/filter.c
> > > +++ b/net/core/filter.c
> > > @@ -8462,18 +8462,18 @@ static u32 sk_msg_convert_ctx_access(enum bpf_access_type type,
> > >   	return insn - insn_buf;
> > >   }
> > > -const struct bpf_verifier_ops sk_filter_verifier_ops = {
> > > +static const struct bpf_verifier_ops sk_filter_verifier_ops = {
> > >   	.get_func_proto		= sk_filter_func_proto,
> > >   	.is_valid_access	= sk_filter_is_valid_access,
> > >   	.convert_ctx_access	= bpf_convert_ctx_access,
> > >   	.gen_ld_abs		= bpf_gen_ld_abs,
> > >   };
> > 
> > Big obvious NAK. I'm puzzled that you try to fix a compile warning, but without
> > even bothering to compile the result after your patch ...
> 
> builds fine. maybe some effort to stop this happening again should be made.

It doesn't build, because they are used/needed outside:

[...]
  CC      net/core/dev_ioctl.o
  CC      net/core/tso.o
net/core/filter.c:8467:38: error: static declaration of ‘sk_filter_verifier_ops’ follows non-static declaration
 8467 | static const struct bpf_verifier_ops sk_filter_verifier_ops = {
      |                                      ^~~~~~~~~~~~~~~~~~~~~~
In file included from ./include/linux/bpf-cgroup.h:5,
                 from ./include/linux/cgroup-defs.h:22,
                 from ./include/linux/cgroup.h:28,
                 from ./include/net/netprio_cgroup.h:11,
                 from ./include/linux/netdevice.h:42,
                 from ./include/net/sock.h:46,
                 from ./include/linux/sock_diag.h:8,
                 from net/core/filter.c:25:
./include/linux/bpf_types.h:5:44: note: previous declaration of ‘sk_filter_verifier_ops’ was here
    5 | BPF_PROG_TYPE(BPF_PROG_TYPE_SOCKET_FILTER, sk_filter)
      |                                            ^~~~~~~~~
./include/linux/bpf.h:625:39: note: in definition of macro ‘BPF_PROG_TYPE’
  625 |  extern const struct bpf_verifier_ops _name ## _verifier_ops;
      |                                       ^~~~~
[...] ( and more of the same errors ... )
