Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0C3C5228BB5
	for <lists+netdev@lfdr.de>; Tue, 21 Jul 2020 23:50:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731330AbgGUVup (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Jul 2020 17:50:45 -0400
Received: from www62.your-server.de ([213.133.104.62]:38826 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728470AbgGUVun (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Jul 2020 17:50:43 -0400
Received: from sslproxy03.your-server.de ([88.198.220.132])
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1jy09p-0006cv-Ec; Tue, 21 Jul 2020 23:50:41 +0200
Received: from [178.196.57.75] (helo=pc-9.home)
        by sslproxy03.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1jy09p-000NNS-7t; Tue, 21 Jul 2020 23:50:41 +0200
Subject: Re: [PATCH bpf-next v4] bpftool: use only nftw for file tree parsing
To:     Tony Ambardar <tony.ambardar@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        Quentin Monnet <quentin@isovalent.com>
References: <20200717225543.32126-1-Tony.Ambardar@gmail.com>
 <20200721024817.13701-1-Tony.Ambardar@gmail.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <c494168f-4f1d-1814-893a-5e93c6a643c8@iogearbox.net>
Date:   Tue, 21 Jul 2020 23:50:40 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20200721024817.13701-1-Tony.Ambardar@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.102.3/25880/Tue Jul 21 16:34:58 2020)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 7/21/20 4:48 AM, Tony Ambardar wrote:
> The bpftool sources include code to walk file trees, but use multiple
> frameworks to do so: nftw and fts. While nftw conforms to POSIX/SUSv3 and
> is widely available, fts is not conformant and less common, especially on
> non-glibc systems. The inconsistent framework usage hampers maintenance
> and portability of bpftool, in particular for embedded systems.
> 
> Standardize code usage by rewriting one fts-based function to use nftw and
> clean up some related function warnings by extending use of "const char *"
> arguments. This change helps in building bpftool against musl for OpenWrt.
> 
> Also fix an unsafe call to dirname() by duplicating the string to pass,
> since some implementations may directly alter it. The same approach is
> used in libbpf.c.
> 
> Signed-off-by: Tony Ambardar <Tony.Ambardar@gmail.com>

Lgtm, applied, thanks!
