Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 04C9BDE480
	for <lists+netdev@lfdr.de>; Mon, 21 Oct 2019 08:26:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726125AbfJUG03 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Oct 2019 02:26:29 -0400
Received: from mx2.suse.de ([195.135.220.15]:54008 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726039AbfJUG03 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 21 Oct 2019 02:26:29 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 6FD88B30E;
        Mon, 21 Oct 2019 06:26:27 +0000 (UTC)
Received: by unicorn.suse.cz (Postfix, from userid 1000)
        id 16F5BE3C6D; Mon, 21 Oct 2019 08:26:26 +0200 (CEST)
Date:   Mon, 21 Oct 2019 08:26:26 +0200
From:   Michal Kubecek <mkubecek@suse.cz>
To:     netdev@vger.kernel.org
Cc:     Maciej =?iso-8859-2?Q?=AFenczykowski?= <zenczykowski@gmail.com>,
        Maciej =?iso-8859-2?Q?=AFenczykowski?= <maze@google.com>,
        "John W . Linville" <linville@tuxdriver.com>
Subject: Re: [PATCH 01/33] fix arithmetic on pointer to void is a GNU
 extension warning
Message-ID: <20191021062626.GB27784@unicorn.suse.cz>
References: <CAHo-Ooze4yTO_yeimV-XSD=AXvvd0BmbKdvUK4bKWN=+LXirYQ@mail.gmail.com>
 <20191017182121.103569-1-zenczykowski@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-2
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20191017182121.103569-1-zenczykowski@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 17, 2019 at 11:20:49AM -0700, Maciej ¯enczykowski wrote:
> From: Maciej ¯enczykowski <maze@google.com>
> 
> This fixes:
>   external/ethtool/marvell.c:127:22: error: arithmetic on a pointer to void is a GNU extension [-Werror,-Wpointer-arith]
>   dump_timer("LED", p + 0x20);
> 
> (and remove some spare whitespace while we're at it)
> 
> Signed-off-by: Maciej ¯enczykowski <maze@google.com>
> Change-Id: Ia49b0baa9b8d00ccbe802780c226ca03ec9307f0
> ---
>  marvell.c | 14 +++++++-------
>  1 file changed, 7 insertions(+), 7 deletions(-)
> 
> diff --git a/marvell.c b/marvell.c
> index af21188..27785be 100644
> --- a/marvell.c
> +++ b/marvell.c
> @@ -118,13 +118,13 @@ static void dump_fifo(const char *name, const void *p)
>  	printf("\n%s\n", name);
>  	printf("---------------\n");
>  	printf("End Address                      0x%08X\n", r[0]);
> -  	printf("Write Pointer                    0x%08X\n", r[1]);
> -  	printf("Read Pointer                     0x%08X\n", r[2]);
> -  	printf("Packet Counter                   0x%08X\n", r[3]);
> -  	printf("Level                            0x%08X\n", r[4]);
> -  	printf("Control                          0x%08X\n", r[5]);
> -  	printf("Control/Test                     0x%08X\n", r[6]);
> -	dump_timer("LED", p + 0x20);
> +	printf("Write Pointer                    0x%08X\n", r[1]);
> +	printf("Read Pointer                     0x%08X\n", r[2]);
> +	printf("Packet Counter                   0x%08X\n", r[3]);
> +	printf("Level                            0x%08X\n", r[4]);
> +	printf("Control                          0x%08X\n", r[5]);
> +	printf("Control/Test                     0x%08X\n", r[6]);
> +	dump_timer("LED", r + 8);
>  }
>  
>  static void dump_gmac_fifo(const char *name, const void *p)

Reviewed-by: Michal Kubecek <mkubecek@suse.cz>
