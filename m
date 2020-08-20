Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B395A24C066
	for <lists+netdev@lfdr.de>; Thu, 20 Aug 2020 16:16:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727791AbgHTOQx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Aug 2020 10:16:53 -0400
Received: from www62.your-server.de ([213.133.104.62]:51684 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726853AbgHTOQw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Aug 2020 10:16:52 -0400
Received: from sslproxy02.your-server.de ([78.47.166.47])
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1k8lN1-0002ff-Pq; Thu, 20 Aug 2020 16:16:48 +0200
Received: from [178.196.57.75] (helo=pc-9.home)
        by sslproxy02.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1k8lN1-000CkW-LP; Thu, 20 Aug 2020 16:16:47 +0200
Subject: Re: [PATCH bpf] bpf: refer to struct xdp_md in user space comments
To:     Jakub Kicinski <kuba@kernel.org>, bpf@vger.kernel.org
Cc:     netdev@vger.kernel.org, yhs@fb.com
References: <20200819192723.838228-1-kuba@kernel.org>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <ec62c928-429d-8bea-13ec-5c7744ebf121@iogearbox.net>
Date:   Thu, 20 Aug 2020 16:16:47 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20200819192723.838228-1-kuba@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.102.4/25905/Thu Aug 20 15:09:58 2020)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/19/20 9:27 PM, Jakub Kicinski wrote:
> uAPI uses xdp_md, not xdp_buff. Fix comments.
> 
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> ---
>   include/uapi/linux/bpf.h | 8 ++++----
>   1 file changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
> index 0480f893facd..cc3553a102d0 100644
> --- a/include/uapi/linux/bpf.h
> +++ b/include/uapi/linux/bpf.h
> @@ -1554,7 +1554,7 @@ union bpf_attr {

Needs also tooling header copy, but once that is done, it needs fixup for libbpf:

[root@pc-9 bpf]# make
   GEN      bpf_helper_defs.h
Unrecognized type 'struct xdp_md', please add it to known types!
make[1]: *** [Makefile:186: bpf_helper_defs.h] Error 1
make[1]: *** Deleting file 'bpf_helper_defs.h'
make: *** [Makefile:160: all] Error 2
[root@pc-9 bpf]#

Pls fix up and send v2, thanks.
Daniel
