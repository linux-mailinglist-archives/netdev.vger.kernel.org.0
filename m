Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6F2D886659
	for <lists+netdev@lfdr.de>; Thu,  8 Aug 2019 17:58:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390084AbfHHP6V (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Aug 2019 11:58:21 -0400
Received: from mx1.redhat.com ([209.132.183.28]:50087 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732662AbfHHP6V (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 8 Aug 2019 11:58:21 -0400
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 8A5C9309DEE5;
        Thu,  8 Aug 2019 15:58:21 +0000 (UTC)
Received: from carbon (ovpn-200-43.brq.redhat.com [10.40.200.43])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 8C0BE5D9DC;
        Thu,  8 Aug 2019 15:58:16 +0000 (UTC)
Date:   Thu, 8 Aug 2019 17:58:14 +0200
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     netdev@vger.kernel.org, Daniel Borkmann <borkmann@iogearbox.net>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     a.s.protopopov@gmail.com, dsahern@gmail.com,
        Toke =?UTF-8?B?SMO4aWxh?= =?UTF-8?B?bmQtSsO4cmdlbnNlbg==?= 
        <toke@toke.dk>, ys114321@gmail.com, brouer@redhat.com
Subject: Re: [bpf-next v2 PATCH 2/3] samples/bpf: make xdp_fwd more
 practically usable via devmap lookup
Message-ID: <20190808175814.14b679ca@carbon>
In-Reply-To: <156527920658.20297.5634629362034006298.stgit@firesoul>
References: <156527914510.20297.12225832190052744019.stgit@firesoul>
        <156527920658.20297.5634629362034006298.stgit@firesoul>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.45]); Thu, 08 Aug 2019 15:58:21 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 08 Aug 2019 17:46:46 +0200
Jesper Dangaard Brouer <brouer@redhat.com> wrote:

> @@ -103,8 +112,17 @@ int main(int argc, char **argv)
>  			return 1;
>  		}
>  
> -		if (bpf_prog_load_xattr(&prog_load_attr, &obj, &prog_fd))
> +		err = bpf_prog_load_xattr(&prog_load_attr, &obj, &prog_fd);
> +		if (err) {
> +			if (err == -22) {

Darn - I forgot this, need to be changed.
I'll send a V3.

> +				printf("Does kernel support devmap lookup?\n");
> +				/* If not, the error message will be:
> +				 * "cannot pass map_type 14 into func
> +				 * bpf_map_lookup_elem#1"
> +				 */
> +			}
>  			return 1;



-- 
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer
