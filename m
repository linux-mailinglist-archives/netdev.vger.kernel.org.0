Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2199727D1A0
	for <lists+netdev@lfdr.de>; Tue, 29 Sep 2020 16:42:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731749AbgI2Ol5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Sep 2020 10:41:57 -0400
Received: from www62.your-server.de ([213.133.104.62]:48698 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728844AbgI2Ol4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Sep 2020 10:41:56 -0400
Received: from sslproxy01.your-server.de ([78.46.139.224])
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1kNGpB-0001qy-WE; Tue, 29 Sep 2020 16:41:50 +0200
Received: from [178.196.57.75] (helo=pc-9.home)
        by sslproxy01.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1kNGpB-000Res-QS; Tue, 29 Sep 2020 16:41:49 +0200
Subject: Re: [PATCH] powerpc: net: bpf_jit_comp: Fix misuse of fallthrough
To:     zhe.he@windriver.com, gustavo@embeddedor.com,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org
References: <20200928090023.38117-1-zhe.he@windriver.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <d73d30b7-6405-3b42-693f-5e16c7a4c6a3@iogearbox.net>
Date:   Tue, 29 Sep 2020 16:41:49 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20200928090023.38117-1-zhe.he@windriver.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.102.4/25942/Tue Sep 29 15:56:33 2020)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 9/28/20 11:00 AM, zhe.he@windriver.com wrote:
> From: He Zhe <zhe.he@windriver.com>
> 
> The user defined label following "fallthrough" is not considered by GCC
> and causes build failure.
> 
> kernel-source/include/linux/compiler_attributes.h:208:41: error: attribute
> 'fallthrough' not preceding a case label or default label [-Werror]
>   208   define fallthrough _attribute((fallthrough_))
>                            ^~~~~~~~~~~~~
> 
> Signed-off-by: He Zhe <zhe.he@windriver.com>

Applied, thanks! I've also added Fixes tag with df561f6688fe ("treewide: Use fallthrough pseudo-keyword")
which added the bug.
