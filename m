Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 358401BEC78
	for <lists+netdev@lfdr.de>; Thu, 30 Apr 2020 01:14:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727781AbgD2XOQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Apr 2020 19:14:16 -0400
Received: from www62.your-server.de ([213.133.104.62]:59194 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726164AbgD2XOO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Apr 2020 19:14:14 -0400
Received: from sslproxy03.your-server.de ([88.198.220.132])
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1jTvu7-0006n3-Ue; Thu, 30 Apr 2020 01:14:11 +0200
Received: from [178.195.186.98] (helo=pc-9.home)
        by sslproxy03.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1jTvu7-000V8p-LZ; Thu, 30 Apr 2020 01:14:11 +0200
Subject: Re: [PATCH bpf-next v3 0/3] tools: bpftool: probe features for
 unprivileged users
To:     Quentin Monnet <quentin@isovalent.com>,
        Alexei Starovoitov <ast@kernel.org>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        Richard Palethorpe <rpalethorpe@suse.com>,
        Michael Kerrisk <mtk.manpages@gmail.com>
References: <20200429144506.8999-1-quentin@isovalent.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <49ca473a-efa0-19ec-c054-9e051bc4d401@iogearbox.net>
Date:   Thu, 30 Apr 2020 01:14:10 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20200429144506.8999-1-quentin@isovalent.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.102.2/25797/Wed Apr 29 14:06:14 2020)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 4/29/20 4:45 PM, Quentin Monnet wrote:
> This set allows unprivileged users to probe available features with
> bpftool. On Daniel's suggestion, the "unprivileged" keyword must be passed
> on the command line to avoid accidentally dumping a subset of the features
> supported by the system. When used by root, this keyword makes bpftool drop
> the CAP_SYS_ADMIN capability and print the features available to
> unprivileged users only.
> 
> The first patch makes a variable global in feature.c to avoid piping too
> many booleans through the different functions. The second patch introduces
> the unprivileged probing, adding a dependency to libcap. Then the third
> patch makes this dependency optional, by restoring the initial behaviour
> (root only can probe features) if the library is not available.
> 
> Cc: Richard Palethorpe <rpalethorpe@suse.com>
> Cc: Michael Kerrisk <mtk.manpages@gmail.com>
> 
> v3: Update help message for bpftool feature probe ("unprivileged").
> 
> v2: Add "unprivileged" keyword, libcap check (patches 1 and 3 are new).
> 
> Quentin Monnet (3):
>    tools: bpftool: for "feature probe" define "full_mode" bool as global
>    tools: bpftool: allow unprivileged users to probe features
>    tools: bpftool: make libcap dependency optional
> 
>   .../bpftool/Documentation/bpftool-feature.rst |  12 +-
>   tools/bpf/bpftool/Makefile                    |  13 +-
>   tools/bpf/bpftool/bash-completion/bpftool     |   2 +-
>   tools/bpf/bpftool/feature.c                   | 143 +++++++++++++++---
>   4 files changed, 143 insertions(+), 27 deletions(-)
> 

Applied, thanks!
