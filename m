Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C57C11628B1
	for <lists+netdev@lfdr.de>; Tue, 18 Feb 2020 15:40:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726767AbgBROke (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Feb 2020 09:40:34 -0500
Received: from www62.your-server.de ([213.133.104.62]:45930 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726116AbgBROke (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Feb 2020 09:40:34 -0500
Received: from sslproxy05.your-server.de ([78.46.172.2])
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1j4434-0001cM-2o; Tue, 18 Feb 2020 15:40:30 +0100
Received: from [2001:1620:665:0:5795:5b0a:e5d5:5944] (helo=linux-3.fritz.box)
        by sslproxy05.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1j4433-000SqE-Qd; Tue, 18 Feb 2020 15:40:29 +0100
Subject: Re: [PATCH bpf] libbpf: Sanitise internal map names so they are not
 rejected by the kernel
To:     =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgensen?= <toke@redhat.com>,
        ast@fb.com
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org
References: <20200217171701.215215-1-toke@redhat.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <9ddddbd6-aca2-61ae-b864-0f12d7fd33b4@iogearbox.net>
Date:   Tue, 18 Feb 2020 15:40:29 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20200217171701.215215-1-toke@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.102.1/25726/Mon Feb 17 15:01:07 2020)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2/17/20 6:17 PM, Toke Høiland-Jørgensen wrote:
> The kernel only accepts map names with alphanumeric characters, underscores
> and periods in their name. However, the auto-generated internal map names
> used by libbpf takes their prefix from the user-supplied BPF object name,
> which has no such restriction. This can lead to "Invalid argument" errors
> when trying to load a BPF program using global variables.
> 
> Fix this by sanitising the map names, replacing any non-allowed characters
> with underscores.
> 
> Fixes: d859900c4c56 ("bpf, libbpf: support global data/bss/rodata sections")
> Signed-off-by: Toke Høiland-Jørgensen <toke@redhat.com>

Makes sense to me, applied, thanks! I presume you had something like '-' in the
global var leading to rejection?
