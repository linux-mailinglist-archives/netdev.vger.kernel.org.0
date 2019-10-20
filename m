Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 344A2DDE12
	for <lists+netdev@lfdr.de>; Sun, 20 Oct 2019 12:15:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726320AbfJTKO5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 20 Oct 2019 06:14:57 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:27727 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726027AbfJTKO4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 20 Oct 2019 06:14:56 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1571566495;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=rBMRx7VKl+U03kBuVO96Nk+z6cMJJlJhVPE1Ji9EtVo=;
        b=Rjydvl6q50Pt6XplH8eWCzk48hm38ti9SjRrPJDmCiE/IDJIC3BMpKIi4BOjMsOKY8yLVF
        NzYeq7+eHTFMDO1dtgEcsgNkoUHdcHU3D4Xlq4m7TgAeqiQSLoXog4N++EL7GldWYcPncg
        kMZu3MECwYEREnuK7mWIOoi0LcnjouE=
Received: from mail-lj1-f197.google.com (mail-lj1-f197.google.com
 [209.85.208.197]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-98-uBjR2FjGO0uSH9mNy1l2-A-1; Sun, 20 Oct 2019 06:14:53 -0400
Received: by mail-lj1-f197.google.com with SMTP id y28so1938287ljn.2
        for <netdev@vger.kernel.org>; Sun, 20 Oct 2019 03:14:53 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=lXtTDTE7K2RmqsVX0VCIrU7dqQ+2zlkBv2Zk4TX90ZI=;
        b=C9QIoO+jkJetbSbpegrq/fOudlqysb+eFh0jIZtloo8Lk1eVxNr+RZspeRqgR1LBFz
         vtj7qHEXcnpiDEXlz/8PVp8FoyaFRUcgnxYo4lVCYTxS0VzpXa5I/0z6D74BflpHB2d9
         gFK1bF8iKsHoY+yz6flT0mKAxxQ6rmnhZ9cIuXe2lh88qZnG7CFa+GBSpmS1fntGuK+A
         RMwpz22xo/JcV5Kxecz3Ethq5S1jOXFwpViBVNVe1eUWev47YBq+utIoLfw8Q6sFz6Ij
         Oak97ly3/yJAzS90q5Ap3d3GkLNy2WNx8jf2L2gWjLbTikj/DZnv8i9RtGRj8DShAUoN
         WOPQ==
X-Gm-Message-State: APjAAAUYXo8Gvss3EC3WWwK8WdFM+BFP9TNC/vDOlfPJwCiZDqIZQsT3
        omMDr9eE0iWAkODXE1SROh2a+neP5y0NNmXhM2SuwWFMyjce+6RcBSsXcgcZHP31Mb0JKEH+RQo
        wagbjnJPNkcO/IsPE
X-Received: by 2002:a2e:81cf:: with SMTP id s15mr9829344ljg.99.1571566492254;
        Sun, 20 Oct 2019 03:14:52 -0700 (PDT)
X-Google-Smtp-Source: APXvYqwk3PE8wyqtm9E0FO88pbqr/0aL7k1Lp5yiQfGBzgWtbyOMvfKaYdhTmahXXB++Ngh5GJPbgw==
X-Received: by 2002:a2e:81cf:: with SMTP id s15mr9829335ljg.99.1571566491980;
        Sun, 20 Oct 2019 03:14:51 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([2a00:7660:6da:443::2])
        by smtp.gmail.com with ESMTPSA id x3sm4685598ljm.103.2019.10.20.03.14.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 20 Oct 2019 03:14:50 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id BD30C1804C8; Sun, 20 Oct 2019 12:14:49 +0200 (CEST)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        "Samudrala\, Sridhar" <sridhar.samudrala@intel.com>
Cc:     Jakub Kicinski <jakub.kicinski@netronome.com>,
        "Karlsson\, Magnus" <magnus.karlsson@intel.com>,
        =?utf-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>,
        Netdev <netdev@vger.kernel.org>,
        "bpf\@vger.kernel.org" <bpf@vger.kernel.org>,
        intel-wired-lan <intel-wired-lan@lists.osuosl.org>,
        "Fijalkowski\, Maciej" <maciej.fijalkowski@intel.com>,
        "Herbert\, Tom" <tom.herbert@intel.com>
Subject: Re: FW: [PATCH bpf-next 2/4] xsk: allow AF_XDP sockets to receive packets directly from a queue
In-Reply-To: <20191019022525.w5xbwkav2cpqkfwi@ast-mbp>
References: <1570515415-45593-3-git-send-email-sridhar.samudrala@intel.com> <CAADnVQ+XxmvY0cs8MYriMMd7=2TSEm4zCtB+fs2vkwdUY6UgAQ@mail.gmail.com> <3ED8E928C4210A4289A677D2FEB48235140134CE@fmsmsx111.amr.corp.intel.com> <2bc26acd-170d-634e-c066-71557b2b3e4f@intel.com> <CAADnVQ+qq6RLMjh5bB1ugXP5p7vYM2F1fLGFQ2pL=2vhCLiBdA@mail.gmail.com> <2032d58c-916f-d26a-db14-bd5ba6ad92b9@intel.com> <CAADnVQ+CH1YM52+LfybLS+NK16414Exrvk1QpYOF=HaT4KRaxg@mail.gmail.com> <acf69635-5868-f876-f7da-08954d1f690e@intel.com> <20191019001449.fk3gnhih4nx724pm@ast-mbp> <6f281517-3785-ce46-65de-e2f78576783b@intel.com> <20191019022525.w5xbwkav2cpqkfwi@ast-mbp>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Sun, 20 Oct 2019 12:14:49 +0200
Message-ID: <877e4zd8py.fsf@toke.dk>
MIME-Version: 1.0
X-MC-Unique: uBjR2FjGO0uSH9mNy1l2-A-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Alexei Starovoitov <alexei.starovoitov@gmail.com> writes:

> On Fri, Oct 18, 2019 at 05:45:26PM -0700, Samudrala, Sridhar wrote:
>> On 10/18/2019 5:14 PM, Alexei Starovoitov wrote:
>> > On Fri, Oct 18, 2019 at 11:40:07AM -0700, Samudrala, Sridhar wrote:
>> > >=20
>> > > Perf report for "AF_XDP default rxdrop" with patched kernel - mitiga=
tions ON
>> > > =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D
>> > > Samples: 44K of event 'cycles', Event count (approx.): 38532389541
>> > > Overhead  Command          Shared Object              Symbol
>> > >    15.31%  ksoftirqd/28     [i40e]                     [k] i40e_clea=
n_rx_irq_zc
>> > >    10.50%  ksoftirqd/28     bpf_prog_80b55d8a76303785  [k] bpf_prog_=
80b55d8a76303785
>> > >     9.48%  xdpsock          [i40e]                     [k] i40e_clea=
n_rx_irq_zc
>> > >     8.62%  xdpsock          xdpsock                    [.] main
>> > >     7.11%  ksoftirqd/28     [kernel.vmlinux]           [k] xsk_rcv
>> > >     5.81%  ksoftirqd/28     [kernel.vmlinux]           [k] xdp_do_re=
direct
>> > >     4.46%  xdpsock          bpf_prog_80b55d8a76303785  [k] bpf_prog_=
80b55d8a76303785
>> > >     3.83%  xdpsock          [kernel.vmlinux]           [k] xsk_rcv
>> >=20
>> > why everything is duplicated?
>> > Same code runs in different tasks ?
>>=20
>> Yes. looks like these functions run from both the app(xdpsock) context a=
nd ksoftirqd context.
>>=20
>> >=20
>> > >     2.81%  ksoftirqd/28     [kernel.vmlinux]           [k] bpf_xdp_r=
edirect_map
>> > >     2.78%  ksoftirqd/28     [kernel.vmlinux]           [k] xsk_map_l=
ookup_elem
>> > >     2.44%  xdpsock          [kernel.vmlinux]           [k] xdp_do_re=
direct
>> > >     2.19%  ksoftirqd/28     [kernel.vmlinux]           [k] __xsk_map=
_redirect
>> > >     1.62%  ksoftirqd/28     [kernel.vmlinux]           [k] xsk_umem_=
peek_addr
>> > >     1.57%  xdpsock          [kernel.vmlinux]           [k] xsk_umem_=
peek_addr
>> > >     1.32%  ksoftirqd/28     [kernel.vmlinux]           [k] dma_direc=
t_sync_single_for_cpu
>> > >     1.28%  xdpsock          [kernel.vmlinux]           [k] bpf_xdp_r=
edirect_map
>> > >     1.15%  xdpsock          [kernel.vmlinux]           [k] dma_direc=
t_sync_single_for_device
>> > >     1.12%  xdpsock          [kernel.vmlinux]           [k] xsk_map_l=
ookup_elem
>> > >     1.06%  xdpsock          [kernel.vmlinux]           [k] __xsk_map=
_redirect
>> > >     0.94%  ksoftirqd/28     [kernel.vmlinux]           [k] dma_direc=
t_sync_single_for_device
>> > >     0.75%  ksoftirqd/28     [kernel.vmlinux]           [k] __x86_ind=
irect_thunk_rax
>> > >     0.66%  ksoftirqd/28     [i40e]                     [k] i40e_clea=
n_programming_status
>> > >     0.64%  ksoftirqd/28     [kernel.vmlinux]           [k] net_rx_ac=
tion
>> > >     0.64%  swapper          [kernel.vmlinux]           [k] intel_idl=
e
>> > >     0.62%  ksoftirqd/28     [i40e]                     [k] i40e_napi=
_poll
>> > >     0.57%  xdpsock          [kernel.vmlinux]           [k] dma_direc=
t_sync_single_for_cpu
>> > >=20
>> > > Perf report for "AF_XDP direct rxdrop" with patched kernel - mitigat=
ions ON
>> > > =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D
>> > > Samples: 46K of event 'cycles', Event count (approx.): 38387018585
>> > > Overhead  Command          Shared Object             Symbol
>> > >    21.94%  ksoftirqd/28     [i40e]                    [k] i40e_clean=
_rx_irq_zc
>> > >    14.36%  xdpsock          xdpsock                   [.] main
>> > >    11.53%  ksoftirqd/28     [kernel.vmlinux]          [k] xsk_rcv
>> > >    11.32%  xdpsock          [i40e]                    [k] i40e_clean=
_rx_irq_zc
>> > >     4.02%  xdpsock          [kernel.vmlinux]          [k] xsk_rcv
>> > >     2.91%  ksoftirqd/28     [kernel.vmlinux]          [k] xdp_do_red=
irect
>> > >     2.45%  ksoftirqd/28     [kernel.vmlinux]          [k] xsk_umem_p=
eek_addr
>> > >     2.19%  xdpsock          [kernel.vmlinux]          [k] xsk_umem_p=
eek_addr
>> > >     2.08%  ksoftirqd/28     [kernel.vmlinux]          [k] bpf_direct=
_xsk
>> > >     2.07%  ksoftirqd/28     [kernel.vmlinux]          [k] dma_direct=
_sync_single_for_cpu
>> > >     1.53%  ksoftirqd/28     [kernel.vmlinux]          [k] dma_direct=
_sync_single_for_device
>> > >     1.39%  xdpsock          [kernel.vmlinux]          [k] dma_direct=
_sync_single_for_device
>> > >     1.22%  ksoftirqd/28     [kernel.vmlinux]          [k] xdp_get_xs=
k_from_qid
>> > >     1.12%  ksoftirqd/28     [i40e]                    [k] i40e_clean=
_programming_status
>> > >     0.96%  ksoftirqd/28     [i40e]                    [k] i40e_napi_=
poll
>> > >     0.95%  ksoftirqd/28     [kernel.vmlinux]          [k] net_rx_act=
ion
>> > >     0.89%  xdpsock          [kernel.vmlinux]          [k] xdp_do_red=
irect
>> > >     0.83%  swapper          [i40e]                    [k] i40e_clean=
_rx_irq_zc
>> > >     0.70%  swapper          [kernel.vmlinux]          [k] intel_idle
>> > >     0.66%  xdpsock          [kernel.vmlinux]          [k] dma_direct=
_sync_single_for_cpu
>> > >     0.60%  xdpsock          [kernel.vmlinux]          [k] bpf_direct=
_xsk
>> > >     0.50%  ksoftirqd/28     [kernel.vmlinux]          [k] xsk_umem_d=
iscard_addr
>> > >=20
>> > > Based on the perf reports comparing AF_XDP default and direct rxdrop=
, we can say that
>> > > AF_XDP direct rxdrop codepath is avoiding the overhead of going thro=
ugh these functions
>> > > =09bpf_prog_xxx
>> > >          bpf_xdp_redirect_map
>> > > =09xsk_map_lookup_elem
>> > >          __xsk_map_redirect
>> > > With AF_XDP direct, xsk_rcv() is directly called via bpf_direct_xsk(=
) in xdp_do_redirect()
>> >=20
>> > I don't think you're identifying the overhead correctly.
>> > xsk_map_lookup_elem is 1%
>> > but bpf_xdp_redirect_map() suppose to call __xsk_map_lookup_elem()
>> > which is a different function:
>> > ffffffff81493fe0 T __xsk_map_lookup_elem
>> > ffffffff81492e80 t xsk_map_lookup_elem
>> >=20
>> > 10% for bpf_prog_80b55d8a76303785 is huge.
>> > It's the actual code of the program _without_ any helpers.
>> > How does the program actually look?
>>=20
>> It is the xdp program that is loaded via xsk_load_xdp_prog() in tools/li=
b/bpf/xsk.c
>> https://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf-next.git/tree/to=
ols/lib/bpf/xsk.c#n268
>
> I see. Looks like map_gen_lookup was never implemented for xskmap.
> How about adding it first the way array_map_gen_lookup() is implemented?
> This will easily give 2x perf gain.

I guess we should implement this for devmaps as well now that we allow
lookups into those.

However, in this particular example, the lookup from BPF is not actually
needed, since bpf_redirect_map() will return a configurable error value
when the map lookup fails (for exactly this use case).

So replacing:

if (bpf_map_lookup_elem(&xsks_map, &index))
    return bpf_redirect_map(&xsks_map, index, 0);

with simply

return bpf_redirect_map(&xsks_map, index, XDP_PASS);

would save the call to xsk_map_lookup_elem().

-Toke

