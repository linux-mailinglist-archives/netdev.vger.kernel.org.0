Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8293C8BB94
	for <lists+netdev@lfdr.de>; Tue, 13 Aug 2019 16:32:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729427AbfHMOc5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Aug 2019 10:32:57 -0400
Received: from www62.your-server.de ([213.133.104.62]:53660 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727561AbfHMOc5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Aug 2019 10:32:57 -0400
Received: from sslproxy05.your-server.de ([78.46.172.2])
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1hxXr4-0006AY-8v; Tue, 13 Aug 2019 16:32:54 +0200
Received: from [2a02:120b:2c12:c120:71a0:62dd:894c:fd0e] (helo=pc-66.home)
        by sslproxy05.your-server.de with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89)
        (envelope-from <daniel@iogearbox.net>)
        id 1hxXr4-000CGW-1a; Tue, 13 Aug 2019 16:32:54 +0200
Subject: Re: [bpf-next] selftests/bpf: fix race in flow dissector tests
To:     Petar Penkov <ppenkov.kernel@gmail.com>, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Cc:     davem@davemloft.net, ast@kernel.org, sdf@google.com,
        Petar Penkov <ppenkov@google.com>
References: <20190812233039.173067-1-ppenkov.kernel@gmail.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <f3769cce-1b24-c938-a672-f511afa9d423@iogearbox.net>
Date:   Tue, 13 Aug 2019 16:32:53 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20190812233039.173067-1-ppenkov.kernel@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.100.3/25540/Tue Aug 13 10:16:47 2019)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/13/19 1:30 AM, Petar Penkov wrote:
> From: Petar Penkov <ppenkov@google.com>
> 
> Since the "last_dissection" map holds only the flow keys for the most
> recent packet, there is a small race in the skb-less flow dissector
> tests if a new packet comes between transmitting the test packet, and
> reading its keys from the map. If this happens, the test packet keys
> will be overwritten and the test will fail.
> 
> Changing the "last_dissection" map to a hash map, keyed on the
> source/dest port pair resolves this issue. Additionally, let's clear the
> last test results from the map between tests to prevent previous test
> cases from interfering with the following test cases.
> 
> Fixes: 0905beec9f52 ("selftests/bpf: run flow dissector tests in skb-less mode")
> Signed-off-by: Petar Penkov <ppenkov@google.com>

Applied, thanks!
