Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5CE5A14D9C0
	for <lists+netdev@lfdr.de>; Thu, 30 Jan 2020 12:28:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727164AbgA3L2H (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Jan 2020 06:28:07 -0500
Received: from mga07.intel.com ([134.134.136.100]:45867 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727128AbgA3L2H (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 30 Jan 2020 06:28:07 -0500
X-Amp-Result: UNSCANNABLE
X-Amp-File-Uploaded: False
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga105.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 30 Jan 2020 03:28:05 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,381,1574150400"; 
   d="scan'208";a="428339804"
Received: from ranger.igk.intel.com ([10.102.21.164])
  by fmsmga005.fm.intel.com with ESMTP; 30 Jan 2020 03:28:04 -0800
Date:   Thu, 30 Jan 2020 05:19:03 +0100
From:   Maciej Fijalkowski <maciej.fijalkowski@intel.com>
To:     Yulia Kartseva <hex@fb.com>
Cc:     bpf@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net,
        netdev@vger.kernel.org, andriin@fb.com
Subject: Re: [PATCH v2 bpf] runqslower: fix Makefile
Message-ID: <20200130041903.GC39325@ranger.igk.intel.com>
References: <da8c16011df5628cfc9ddfeaeca2aa5d90be920b.1580373028.git.hex@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <da8c16011df5628cfc9ddfeaeca2aa5d90be920b.1580373028.git.hex@fb.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 30, 2020 at 12:38:32AM -0800, Yulia Kartseva wrote:
> From: Julia Kartseva <hex@fb.com>

I don't think you need the 'From: ' line if you are the sender of patch.

> 
> Fixes: 9c01546d26d2 ("tools/bpf: Add runqslower tool to tools/bpf")
> Signed-off-by: Julia Kartseva <hex@fb.com>
> Acked-by: Andrii Nakryiko <andriin@fb.com>

These tags should be placed after the commit message.

> 
> Fix undefined reference linker errors when building runqslower with
> gcc 7.4.0 on Ubuntu 18.04.
> The issue is with misplaced -lelf, -lz options in Makefile:
> $(Q)$(CC) $(CFLAGS) -lelf -lz $^ -o $@
> 
> -lelf, -lz options should follow the list of target dependencies:
> $(Q)$(CC) $(CFLAGS) $^ -lelf -lz -o $@
> or after substitution
> cc -g -Wall runqslower.o libbpf.a -lelf -lz -o runqslower
> 
> The current order of gcc params causes failure in libelf symbols resolution,
> e.g. undefined reference to `elf_memory'
> ---
>  tools/bpf/runqslower/Makefile | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/tools/bpf/runqslower/Makefile b/tools/bpf/runqslower/Makefile
> index 0c021352b..87eae5be9 100644
> --- a/tools/bpf/runqslower/Makefile
> +++ b/tools/bpf/runqslower/Makefile
> @@ -41,7 +41,7 @@ clean:
>  
>  $(OUTPUT)/runqslower: $(OUTPUT)/runqslower.o $(BPFOBJ)
>  	$(call msg,BINARY,$@)
> -	$(Q)$(CC) $(CFLAGS) -lelf -lz $^ -o $@
> +	$(Q)$(CC) $(CFLAGS) $^ -lelf -lz -o $@
>  
>  $(OUTPUT)/runqslower.o: runqslower.h $(OUTPUT)/runqslower.skel.h	      \
>  			$(OUTPUT)/runqslower.bpf.o
> -- 
> 2.17.1
> 
