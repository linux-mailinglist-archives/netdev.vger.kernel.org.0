Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 483F095858
	for <lists+netdev@lfdr.de>; Tue, 20 Aug 2019 09:29:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729347AbfHTH2e (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Aug 2019 03:28:34 -0400
Received: from mga18.intel.com ([134.134.136.126]:58020 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729047AbfHTH2e (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 20 Aug 2019 03:28:34 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga106.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 20 Aug 2019 00:28:33 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,408,1559545200"; 
   d="scan'208";a="169001452"
Received: from arappl-mobl2.ger.corp.intel.com (HELO btopel-mobl.ger.intel.com) ([10.252.53.140])
  by orsmga007.jf.intel.com with ESMTP; 20 Aug 2019 00:28:27 -0700
Subject: Re: [PATCH -next] bpf: Use PTR_ERR_OR_ZERO in xsk_map_inc()
To:     YueHaibing <yuehaibing@huawei.com>, magnus.karlsson@intel.com,
        jonathan.lemon@gmail.com, ast@kernel.org, daniel@iogearbox.net,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        kernel-janitors@vger.kernel.org
References: <20190820013652.147041-1-yuehaibing@huawei.com>
From:   =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>
Message-ID: <93fafdab-8fb3-0f2b-8f36-0cf297db3cd9@intel.com>
Date:   Tue, 20 Aug 2019 09:28:26 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190820013652.147041-1-yuehaibing@huawei.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2019-08-20 03:36, YueHaibing wrote:
> Use PTR_ERR_OR_ZERO rather than if(IS_ERR(...)) + PTR_ERR
> 
> Signed-off-by: YueHaibing <yuehaibing@huawei.com>
> ---
>   kernel/bpf/xskmap.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/kernel/bpf/xskmap.c b/kernel/bpf/xskmap.c
> index 4cc28e226398..942c662e2eed 100644
> --- a/kernel/bpf/xskmap.c
> +++ b/kernel/bpf/xskmap.c
> @@ -21,7 +21,7 @@ int xsk_map_inc(struct xsk_map *map)
>   	struct bpf_map *m = &map->map;
>   
>   	m = bpf_map_inc(m, false);
> -	return IS_ERR(m) ? PTR_ERR(m) : 0;
> +	return PTR_ERR_OR_ZERO(m);
>   }
>   
>   void xsk_map_put(struct xsk_map *map)
>

Acked-by: Björn Töpel <bjorn.topel@intel.com>

Thanks for the patch!

For future patches: Prefix AF_XDP socket work with "xsk:" and use "PATCH
bpf-next" to let the developers know what tree you're aiming for.



Cheers!
Björn


> 
> 
