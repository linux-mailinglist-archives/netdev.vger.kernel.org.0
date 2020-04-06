Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 22A7519FEE4
	for <lists+netdev@lfdr.de>; Mon,  6 Apr 2020 22:15:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726272AbgDFUPD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Apr 2020 16:15:03 -0400
Received: from www62.your-server.de ([213.133.104.62]:50996 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725895AbgDFUPD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Apr 2020 16:15:03 -0400
Received: from sslproxy05.your-server.de ([78.46.172.2])
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1jLY8s-0000iS-RH; Mon, 06 Apr 2020 22:14:46 +0200
Received: from [178.195.186.98] (helo=pc-9.home)
        by sslproxy05.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1jLY8s-0001Mt-Ch; Mon, 06 Apr 2020 22:14:46 +0200
Subject: Re: [PATCH] libbpf: Initialize *nl_pid so gcc 10 is happy
To:     Jeremy Cline <jcline@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>
Cc:     Martin KaFai Lau <kafai@fb.com>, Song Liu <songliubraving@fb.com>,
        Yonghong Song <yhs@fb.com>, Andrii Nakryiko <andriin@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20200404051430.698058-1-jcline@redhat.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <977ea25b-01bc-c1aa-eb93-e51ff916da0f@iogearbox.net>
Date:   Mon, 6 Apr 2020 22:14:45 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20200404051430.698058-1-jcline@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.102.2/25774/Mon Apr  6 14:53:25 2020)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 4/4/20 7:14 AM, Jeremy Cline wrote:
> Builds of Fedora's kernel-tools package started to fail with "may be
> used uninitialized" warnings for nl_pid in bpf_set_link_xdp_fd() and
> bpf_get_link_xdp_info() on the s390 architecture.
> 
> Although libbpf_netlink_open() always returns a negative number when it
> does not set *nl_pid, the compiler does not determine this and thus
> believes the variable might be used uninitialized. Assuage gcc's fears
> by explicitly initializing nl_pid.
> 
> Bugzilla: https://bugzilla.redhat.com/show_bug.cgi?id=1807781
> Signed-off-by: Jeremy Cline <jcline@redhat.com>

Applied, thanks!
