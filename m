Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1BBFA1AA133
	for <lists+netdev@lfdr.de>; Wed, 15 Apr 2020 14:45:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S369753AbgDOMeZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Apr 2020 08:34:25 -0400
Received: from www62.your-server.de ([213.133.104.62]:43568 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S369735AbgDOMeK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Apr 2020 08:34:10 -0400
Received: from sslproxy06.your-server.de ([78.46.172.3])
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1jOhF1-0001AP-RV; Wed, 15 Apr 2020 14:34:07 +0200
Received: from [178.195.186.98] (helo=pc-9.home)
        by sslproxy06.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1jOhF1-000GL6-HB; Wed, 15 Apr 2020 14:34:07 +0200
Subject: Re: [PATCH v3 bpf-next] libbpf: always specify expected_attach_type
 on program load if supported
To:     Andrii Nakryiko <andriin@fb.com>, bpf@vger.kernel.org,
        netdev@vger.kernel.org, ast@fb.com, rdna@fb.com
Cc:     andrii.nakryiko@gmail.com, kernel-team@fb.com,
        Song Liu <songliubraving@fb.com>
References: <20200414182645.1368174-1-andriin@fb.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <2f095beb-f91b-0528-48cd-bbfa8149ff90@iogearbox.net>
Date:   Wed, 15 Apr 2020 14:34:06 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20200414182645.1368174-1-andriin@fb.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.102.2/25782/Tue Apr 14 13:57:42 2020)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 4/14/20 8:26 PM, Andrii Nakryiko wrote:
> For some types of BPF programs that utilize expected_attach_type, libbpf won't
> set load_attr.expected_attach_type, even if expected_attach_type is known from
> section definition. This was done to preserve backwards compatibility with old
> kernels that didn't recognize expected_attach_type attribute yet (which was
> added in 5e43f899b03a ("bpf: Check attach type at prog load time"). But this
> is problematic for some BPF programs that utilize never features that require
> kernel to know specific expected_attach_type (e.g., extended set of return
> codes for cgroup_skb/egress programs).
> 
> This patch makes libbpf specify expected_attach_type by default, but also
> detect support for this field in kernel and not set it during program load.
> This allows to have a good metadata for bpf_program
> (e.g., bpf_program__get_extected_attach_type()), but still work with old
> kernels (for cases where it can work at all).
> 
> Additionally, due to expected_attach_type being always set for recognized
> program types, bpf_program__attach_cgroup doesn't have to do extra checks to
> determine correct attach type, so remove that additional logic.
> 
> Also adjust section_names selftest to account for this change.
> 
> More detailed discussion can be found in [0].
> 
>    [0] https://lore.kernel.org/bpf/20200412003604.GA15986@rdna-mbp.dhcp.thefacebook.com/
> 
> Reported-by: Andrey Ignatov <rdna@fb.com>
> Acked-by: Song Liu <songliubraving@fb.com>
> Acked-by: Andrey Ignatov <rdna@fb.com>
> Signed-off-by: Andrii Nakryiko <andriin@fb.com>

Applied (to bpf), thanks!
