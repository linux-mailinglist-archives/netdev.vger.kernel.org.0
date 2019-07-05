Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6747B60D6B
	for <lists+netdev@lfdr.de>; Fri,  5 Jul 2019 23:59:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727390AbfGEV67 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Jul 2019 17:58:59 -0400
Received: from www62.your-server.de ([213.133.104.62]:52600 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725882AbfGEV67 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 5 Jul 2019 17:58:59 -0400
Received: from [88.198.220.130] (helo=sslproxy01.your-server.de)
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1hjWEL-0003Jo-77; Fri, 05 Jul 2019 23:58:57 +0200
Received: from [178.193.45.231] (helo=linux.home)
        by sslproxy01.your-server.de with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89)
        (envelope-from <daniel@iogearbox.net>)
        id 1hjWEK-0007Ms-Um; Fri, 05 Jul 2019 23:58:57 +0200
Subject: Re: [PATCH bpf-next v2] tools: bpftool: add "prog run" subcommand to
 test-run programs
To:     Quentin Monnet <quentin.monnet@netronome.com>,
        Alexei Starovoitov <ast@kernel.org>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        oss-drivers@netronome.com, Yonghong Song <ys114321@gmail.com>
References: <20190705175433.22511-1-quentin.monnet@netronome.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <41b3c982-2c4b-ccfc-c548-f70c8fd42f73@iogearbox.net>
Date:   Fri, 5 Jul 2019 23:58:56 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101
 Thunderbird/52.3.0
MIME-Version: 1.0
In-Reply-To: <20190705175433.22511-1-quentin.monnet@netronome.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.100.3/25501/Fri Jul  5 10:01:52 2019)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 07/05/2019 07:54 PM, Quentin Monnet wrote:
> Add a new "bpftool prog run" subcommand to run a loaded program on input
> data (and possibly with input context) passed by the user.
> 
> Print output data (and output context if relevant) into a file or into
> the console. Print return value and duration for the test run into the
> console.
> 
> A "repeat" argument can be passed to run the program several times in a
> row.
> 
> The command does not perform any kind of verification based on program
> type (Is this program type allowed to use an input context?) or on data
> consistency (Can I work with empty input data?), this is left to the
> kernel.
> 
> Example invocation:
> 
>     # perl -e 'print "\x0" x 14' | ./bpftool prog run \
>             pinned /sys/fs/bpf/sample_ret0 \
>             data_in - data_out - repeat 5
>     0000000 0000 0000 0000 0000 0000 0000 0000      | ........ ......
>     Return value: 0, duration (average): 260ns
> 
> When one of data_in or ctx_in is "-", bpftool reads from standard input,
> in binary format. Other formats (JSON, hexdump) might be supported (via
> an optional command line keyword like "data_fmt_in") in the future if
> relevant, but this would require doing more parsing in bpftool.
> 
> v2:
> - Fix argument names for function check_single_stdin(). (Yonghong)
> 
> Signed-off-by: Quentin Monnet <quentin.monnet@netronome.com>
> Reviewed-by: Jakub Kicinski <jakub.kicinski@netronome.com>

Looks great, thanks for adding, applied!
