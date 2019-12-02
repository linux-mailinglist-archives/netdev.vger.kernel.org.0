Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C38CC10E7BE
	for <lists+netdev@lfdr.de>; Mon,  2 Dec 2019 10:38:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726452AbfLBJh4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Dec 2019 04:37:56 -0500
Received: from www62.your-server.de ([213.133.104.62]:33064 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726210AbfLBJh4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Dec 2019 04:37:56 -0500
Received: from [194.230.159.159] (helo=localhost)
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1ibi9Q-0004d3-Nt; Mon, 02 Dec 2019 10:37:52 +0100
Date:   Mon, 2 Dec 2019 10:37:52 +0100
From:   Daniel Borkmann <daniel@iogearbox.net>
To:     Michael Ellerman <mpe@ellerman.id.au>
Cc:     Aurelien Jarno <aurelien@aurel32.net>,
        linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        debian-kernel@lists.debian.org,
        Alexei Starovoitov <ast@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        "open list:BPF (Safe dynamic programs and tools)" 
        <netdev@vger.kernel.org>,
        "open list:BPF (Safe dynamic programs and tools)" 
        <bpf@vger.kernel.org>
Subject: Re: [PATCH] libbpf: fix readelf output parsing on powerpc with
 recent binutils
Message-ID: <20191202093752.GA1535@localhost.localdomain>
References: <20191201195728.4161537-1-aurelien@aurel32.net>
 <87zhgbe0ix.fsf@mpe.ellerman.id.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87zhgbe0ix.fsf@mpe.ellerman.id.au>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.101.4/25650/Sun Dec  1 11:04:04 2019)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Dec 02, 2019 at 04:53:26PM +1100, Michael Ellerman wrote:
> Aurelien Jarno <aurelien@aurel32.net> writes:
> > On powerpc with recent versions of binutils, readelf outputs an extra
> > field when dumping the symbols of an object file. For example:
> >
> >     35: 0000000000000838    96 FUNC    LOCAL  DEFAULT [<localentry>: 8]     1 btf_is_struct
> >
> > The extra "[<localentry>: 8]" prevents the GLOBAL_SYM_COUNT variable to
> > be computed correctly and causes the checkabi target to fail.
> >
> > Fix that by looking for the symbol name in the last field instead of the
> > 8th one. This way it should also cope with future extra fields.
> >
> > Signed-off-by: Aurelien Jarno <aurelien@aurel32.net>
> > ---
> >  tools/lib/bpf/Makefile | 4 ++--
> >  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> Thanks for fixing that, it's been on my very long list of test failures
> for a while.
> 
> Tested-by: Michael Ellerman <mpe@ellerman.id.au>

Looks good & also continues to work on x86. Applied, thanks!
