Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C1F46248197
	for <lists+netdev@lfdr.de>; Tue, 18 Aug 2020 11:14:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726484AbgHRJOP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Aug 2020 05:14:15 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:31390 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726336AbgHRJOO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Aug 2020 05:14:14 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1597742053;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=SMDXmTL0MOVZaUBN/HCS/BMJjg+pDWRzyiZrwcqiCLA=;
        b=dddDnPdhy+h+Umy9u/hjC00j47MQpiWXAUCbvNzDSDli5ikVRZfmoAEkPaesBlLE2LEyQH
        oG5q4UXsimqwWNMsfT3SqXSs7vht8dgtzzSTuSoijBMEyv49bw6jl5cg7uR4KVc9EFgUyj
        yVzft6wm7l558Er89pRvfvyi6h9Q70s=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-283-3qoXk7KpORCRkr6TxxN5KQ-1; Tue, 18 Aug 2020 05:14:11 -0400
X-MC-Unique: 3qoXk7KpORCRkr6TxxN5KQ-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E7C071014E0C;
        Tue, 18 Aug 2020 09:14:09 +0000 (UTC)
Received: from krava (unknown [10.40.193.152])
        by smtp.corp.redhat.com (Postfix) with SMTP id 73D127DFC8;
        Tue, 18 Aug 2020 09:14:05 +0000 (UTC)
Date:   Tue, 18 Aug 2020 11:14:04 +0200
From:   Jiri Olsa <jolsa@redhat.com>
To:     Jesper Dangaard Brouer <brouer@redhat.com>
Cc:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>, sdf@google.com,
        andriin@fb.com
Subject: Re: Kernel build error on BTFIDS vmlinux
Message-ID: <20200818091404.GB177896@krava>
References: <20200818105555.51fc6d62@carbon>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200818105555.51fc6d62@carbon>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Aug 18, 2020 at 10:55:55AM +0200, Jesper Dangaard Brouer wrote:
> 
> On latest DaveM net-git tree (06a4ec1d9dc652), after linking (LD vmlinux) the
> "BTFIDS vmlinux" fails. Are anybody else experiencing this? Are there already a
> fix? (just returned from vacation so not fully up-to-date on ML yet)
> 
> The tool which is called and error message:
>   ./tools/bpf/resolve_btfids/resolve_btfids vmlinux
>   FAILED elf_update(WRITE): invalid section alignment

hi,
could you send your .config as well?

thanks,
jirka

> 
> Note, the tool is only called when CONFIG_DEBUG_INFO_BTF is enabled.
> 
> I saved a copy of vmlinux and ran the tool manually with verbose
> options, the output is provided below signature.
> 
> - - 
> Best regards,
>   Jesper Dangaard Brouer
>   MSc.CS, Principal Kernel Engineer at Red Hat
>   LinkedIn: http://www.linkedin.com/in/brouer
> 
> $ ./tools/bpf/resolve_btfids/resolve_btfids -vv vmlinux.err.bak
> section(1) .text, size 12588824, link 0, flags 6, type=1
> section(2) .rodata, size 4424758, link 0, flags 3, type=1
> section(3) .pci_fixup, size 12736, link 0, flags 2, type=1
> section(4) __ksymtab, size 58620, link 0, flags 2, type=1
> section(5) __ksymtab_gpl, size 56592, link 0, flags 2, type=1
> section(6) __kcrctab, size 19540, link 0, flags 2, type=1
> section(7) __kcrctab_gpl, size 18864, link 0, flags 2, type=1
> section(8) __ksymtab_strings, size 180372, link 0, flags 32, type=1
> section(9) __param, size 14000, link 0, flags 2, type=1
> section(10) __modver, size 152, link 0, flags 2, type=1
> section(11) __ex_table, size 21864, link 0, flags 2, type=1
> section(12) .notes, size 60, link 0, flags 2, type=7
> section(13) .BTF, size 3345350, link 0, flags 2, type=1
> section(14) .BTF_ids, size 100, link 0, flags 2, type=1
> section(15) .data, size 2243456, link 0, flags 3, type=1
> section(16) __bug_table, size 87804, link 0, flags 3, type=1
> section(17) .orc_unwind_ip, size 1625580, link 0, flags 2, type=1
> section(18) .orc_unwind, size 2438370, link 0, flags 2, type=1
> section(19) .orc_lookup, size 196708, link 0, flags 3, type=8
> section(20) .vvar, size 4096, link 0, flags 3, type=1
> section(21) .data..percpu, size 178840, link 0, flags 3, type=1
> section(22) .init.text, size 349579, link 0, flags 6, type=1
> section(23) .altinstr_aux, size 3367, link 0, flags 6, type=1
> section(24) .init.data, size 1584032, link 0, flags 3, type=1
> section(25) .x86_cpu_dev.init, size 24, link 0, flags 2, type=1
> section(26) .parainstructions, size 316, link 0, flags 2, type=1
> section(27) .altinstructions, size 15015, link 0, flags 2, type=1
> section(28) .altinstr_replacement, size 3756, link 0, flags 6, type=1
> section(29) .iommu_table, size 160, link 0, flags 2, type=1
> section(30) .apicdrivers, size 32, link 0, flags 3, type=1
> section(31) .exit.text, size 5195, link 0, flags 6, type=1
> section(32) .smp_locks, size 32768, link 0, flags 2, type=1
> section(33) .data_nosave, size 0, link 0, flags 1, type=1
> section(34) .bss, size 3805184, link 0, flags 3, type=8
> section(35) .brk, size 155648, link 0, flags 3, type=8
> section(36) .comment, size 44, link 0, flags 30, type=1
> section(37) .debug_aranges, size 45684, link 0, flags 800, type=1
> section(38) .debug_info, size 129098181, link 0, flags 800, type=1
> section(39) .debug_abbrev, size 1152583, link 0, flags 800, type=1
> section(40) .debug_line, size 7374522, link 0, flags 800, type=1
> section(41) .debug_frame, size 702463, link 0, flags 800, type=1
> section(42) .debug_str, size 1017606, link 0, flags 830, type=1
> section(43) .debug_loc, size 3019453, link 0, flags 800, type=1
> section(44) .debug_ranges, size 1744583, link 0, flags 800, type=1
> section(45) .symtab, size 2955888, link 46, flags 0, type=2
> section(46) .strtab, size 2613072, link 0, flags 0, type=3
> section(47) .shstrtab, size 525, link 0, flags 0, type=3
> adding symbol seq_file
> adding symbol bpf_map
> adding symbol task_struct
> adding symbol file
> adding symbol bpf_prog
> adding symbol bpf_ctx_convert
> adding symbol sk_buff
> adding symbol xdp_buff
> adding symbol inet_sock
> adding symbol inet_connection_sock
> adding symbol inet_request_sock
> adding symbol inet_timewait_sock
> adding symbol request_sock
> adding symbol sock
> adding symbol sock_common
> adding symbol tcp_sock
> adding symbol tcp_request_sock
> adding symbol tcp_timewait_sock
> adding symbol tcp6_sock
> adding symbol udp_sock
> adding symbol udp6_sock
> adding symbol netlink_sock
> adding symbol fib6_info
> patching addr    36: ID   21502 [xdp_buff]
> patching addr    84: ID   63192 [udp_sock]
> patching addr    88: ID   63195 [udp6_sock]
> patching addr    76: ID   66968 [tcp_timewait_sock]
> patching addr    68: ID   61353 [tcp_sock]
> patching addr    72: ID   61567 [tcp_request_sock]
> patching addr    80: ID   63196 [tcp6_sock]
> patching addr    12: ID     169 [task_struct]
> patching addr    28: ID     169 [task_struct]
> patching addr    64: ID    4401 [sock_common]
> patching addr    60: ID    2894 [sock]
> patching addr    32: ID    3116 [sk_buff]
> patching addr     0: ID    1683 [seq_file]
> patching addr     4: ID    1683 [seq_file]
> patching addr    56: ID    4458 [request_sock]
> patching addr    92: ID   65748 [netlink_sock]
> patching addr    52: ID   66629 [inet_timewait_sock]
> patching addr    40: ID   37652 [inet_sock]
> patching addr    48: ID   61566 [inet_request_sock]
> patching addr    44: ID   61337 [inet_connection_sock]
> patching addr    16: ID     491 [file]
> patching addr    96: ID   56653 [fib6_info]
> patching addr    20: ID    3099 [bpf_prog]
> patching addr     8: ID    1926 [bpf_map]
> patching addr    24: ID   21629 [bpf_ctx_convert]
> FAILED elf_update(WRITE): invalid section alignment
> update failed for vmlinux.err.bak
> 
> 
> diff --git a/scripts/link-vmlinux.sh b/scripts/link-vmlinux.sh
> index e6e2d9e5ff48..718b2c0ee7ea 100755
> --- a/scripts/link-vmlinux.sh
> +++ b/scripts/link-vmlinux.sh
> @@ -227,6 +227,7 @@ cleanup()
>         rm -f .tmp_System.map
>         rm -f .tmp_vmlinux*
>         rm -f System.map
> +       cp vmlinux vmlinux.err.bak
>         rm -f vmlinux
>         rm -f vmlinux.o
>  }
> 

