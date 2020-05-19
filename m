Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 929281D9DCE
	for <lists+netdev@lfdr.de>; Tue, 19 May 2020 19:22:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729451AbgESRWU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 May 2020 13:22:20 -0400
Received: from www62.your-server.de ([213.133.104.62]:51812 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729053AbgESRWU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 May 2020 13:22:20 -0400
Received: from sslproxy01.your-server.de ([78.46.139.224])
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1jb5wP-0003gY-84; Tue, 19 May 2020 19:22:09 +0200
Received: from [178.196.57.75] (helo=pc-9.home)
        by sslproxy01.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1jb5wO-000GLg-W8; Tue, 19 May 2020 19:22:09 +0200
Subject: Re: [PATCH bpf-next] bpf: fix too large copy from user in
 bpf_test_init
To:     Jesper Dangaard Brouer <brouer@redhat.com>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        Daniel Borkmann <borkmann@iogearbox.net>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
References: <158980712729.256597.6115007718472928659.stgit@firesoul>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <169a1b10-4bb8-6ba1-4f5f-e74dd273107a@iogearbox.net>
Date:   Tue, 19 May 2020 19:22:08 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <158980712729.256597.6115007718472928659.stgit@firesoul>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.102.2/25817/Tue May 19 14:16:16 2020)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 5/18/20 3:05 PM, Jesper Dangaard Brouer wrote:
> Commit bc56c919fce7 ("bpf: Add xdp.frame_sz in bpf_prog_test_run_xdp().")
> recently changed bpf_prog_test_run_xdp() to use larger frames for XDP in
> order to test tail growing frames (via bpf_xdp_adjust_tail) and to have
> memory backing frame better resemble drivers.
> 
> The commit contains a bug, as it tries to copy the max data size from
> userspace, instead of the size provided by userspace.  This cause XDP
> unit tests to fail sporadically with EFAULT, an unfortunate behavior.
> The fix is to only copy the size specified by userspace.
> 
> Fixes: bc56c919fce7 ("bpf: Add xdp.frame_sz in bpf_prog_test_run_xdp().")
> Signed-off-by: Jesper Dangaard Brouer <brouer@redhat.com>

Applied, thanks!
