Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DB956FE757
	for <lists+netdev@lfdr.de>; Fri, 15 Nov 2019 22:59:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727022AbfKOV7D (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Nov 2019 16:59:03 -0500
Received: from www62.your-server.de ([213.133.104.62]:47692 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726598AbfKOV7D (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Nov 2019 16:59:03 -0500
Received: from sslproxy01.your-server.de ([88.198.220.130])
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1iVjcL-0004me-AN; Fri, 15 Nov 2019 22:59:01 +0100
Received: from [178.197.248.45] (helo=pc-9.home)
        by sslproxy01.your-server.de with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89)
        (envelope-from <daniel@iogearbox.net>)
        id 1iVjcK-0002j1-VR; Fri, 15 Nov 2019 22:59:01 +0100
Subject: Re: [PATCH bpf] selftests: bpf: fix test_tc_tunnel hanging
To:     Jiri Benc <jbenc@redhat.com>, bpf@vger.kernel.org,
        netdev@vger.kernel.org
Cc:     Willem de Bruijn <willemb@google.com>
References: <60919291657a9ee89c708d8aababc28ebe1420be.1573821780.git.jbenc@redhat.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <dc889f46-bc26-df21-bf24-906a6ccf7a12@iogearbox.net>
Date:   Fri, 15 Nov 2019 22:58:59 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <60919291657a9ee89c708d8aababc28ebe1420be.1573821780.git.jbenc@redhat.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.101.4/25634/Fri Nov 15 10:44:37 2019)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/15/19 1:43 PM, Jiri Benc wrote:
> When run_kselftests.sh is run, it hangs after test_tc_tunnel.sh. The reason
> is test_tc_tunnel.sh ensures the server ('nc -l') is run all the time,
> starting it again every time it is expected to terminate. The exception is
> the final client_connect: the server is not started anymore, which ensures
> no process is kept running after the test is finished.
> 
> For a sit test, though, the script is terminated prematurely without the
> final client_connect and the 'nc' process keeps running. This in turn causes
> the run_one function in kselftest/runner.sh to hang forever, waiting for the
> runaway process to finish.
> 
> Ensure a remaining server is terminated on cleanup.
> 
> Fixes: f6ad6accaa9d ("selftests/bpf: expand test_tc_tunnel with SIT encap")
> Cc: Willem de Bruijn <willemb@google.com>
> Signed-off-by: Jiri Benc <jbenc@redhat.com>

Looks like your Fixes tag is wrong:

[...]
Applying: selftests: bpf: Fix test_tc_tunnel hanging
Switched to branch 'master'
Your branch is up to date with 'origin/master'.
Updating 808c9f7ebfff..e2090d0451c5
Fast-forward
  tools/testing/selftests/bpf/test_tc_tunnel.sh | 5 +++++
  1 file changed, 5 insertions(+)
Deleted branch mbox (was e2090d0451c5).
Commit: e2090d0451c5 ("selftests: bpf: Fix test_tc_tunnel hanging")
	Fixes tag: Fixes: f6ad6accaa9d ("selftests/bpf: expand test_tc_tunnel with SIT encap")
	Has these problem(s):
		- Target SHA1 does not exist
[...]

Thanks,
Daniel
