Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 59F0E50DBF
	for <lists+netdev@lfdr.de>; Mon, 24 Jun 2019 16:22:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727851AbfFXOW3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Jun 2019 10:22:29 -0400
Received: from www62.your-server.de ([213.133.104.62]:51574 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726376AbfFXOW3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Jun 2019 10:22:29 -0400
Received: from [78.46.172.3] (helo=sslproxy06.your-server.de)
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1hfPrW-0002Yq-4f; Mon, 24 Jun 2019 16:22:27 +0200
Received: from [178.199.41.31] (helo=linux.home)
        by sslproxy06.your-server.de with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89)
        (envelope-from <daniel@iogearbox.net>)
        id 1hfPrV-000FLD-VJ; Mon, 24 Jun 2019 16:22:25 +0200
Subject: Re: [PATCH bpf-next] bpftool: Add BPF_F_QUERY_EFFECTIVE support in
 bpftool cgroup [show|tree]
To:     Takshak Chahande <ctakshak@fb.com>, netdev@vger.kernel.org
Cc:     ast@kernel.org, rdna@fb.com, kernel-team@fb.com
References: <20190621223311.1380295-1-ctakshak@fb.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <6fe292ee-fff0-119c-8524-e25783901167@iogearbox.net>
Date:   Mon, 24 Jun 2019 16:22:25 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101
 Thunderbird/52.3.0
MIME-Version: 1.0
In-Reply-To: <20190621223311.1380295-1-ctakshak@fb.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.100.3/25490/Mon Jun 24 10:02:14 2019)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 06/22/2019 12:33 AM, Takshak Chahande wrote:
> With different bpf attach_flags available to attach bpf programs specially
> with BPF_F_ALLOW_OVERRIDE and BPF_F_ALLOW_MULTI, the list of effective
> bpf-programs available to any sub-cgroups really needs to be available for
> easy debugging.
> 
> Using BPF_F_QUERY_EFFECTIVE flag, one can get the list of not only attached
> bpf-programs to a cgroup but also the inherited ones from parent cgroup.
> 
> So "-e" option is introduced to use BPF_F_QUERY_EFFECTIVE query flag here to
> list all the effective bpf-programs available for execution at a specified
> cgroup.
> 
> Reused modified test program test_cgroup_attach from tools/testing/selftests/bpf:
>   # ./test_cgroup_attach
> 
> With old bpftool (without -e option):
> 
>   # bpftool cgroup show /sys/fs/cgroup/cgroup-test-work-dir/cg1/
>   ID       AttachType      AttachFlags     Name
>   271      egress          multi           pkt_cntr_1
>   272      egress          multi           pkt_cntr_2
> 
>   Attached new program pkt_cntr_4 in cg2 gives following:
> 
>   # bpftool cgroup show /sys/fs/cgroup/cgroup-test-work-dir/cg1/cg2
>   ID       AttachType      AttachFlags     Name
>   273      egress          override        pkt_cntr_4
> 
> And with new "-e" option it shows all effective programs for cg2:
> 
>   # bpftool -e cgroup show /sys/fs/cgroup/cgroup-test-work-dir/cg1/cg2
>   ID       AttachType      AttachFlags     Name
>   273      egress          override        pkt_cntr_4
>   271      egress          override        pkt_cntr_1
>   272      egress          override        pkt_cntr_2
> 
> Signed-off-by: Takshak Chahande <ctakshak@fb.com>
> Acked-by: Andrey Ignatov <rdna@fb.com>

Applied, thanks!
