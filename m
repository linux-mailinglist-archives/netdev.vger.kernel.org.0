Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DD05CAFECE
	for <lists+netdev@lfdr.de>; Wed, 11 Sep 2019 16:36:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728231AbfIKOgA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Sep 2019 10:36:00 -0400
Received: from mail-qt1-f196.google.com ([209.85.160.196]:34754 "EHLO
        mail-qt1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726381AbfIKOgA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Sep 2019 10:36:00 -0400
Received: by mail-qt1-f196.google.com with SMTP id j1so12769188qth.1;
        Wed, 11 Sep 2019 07:35:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=lz6pPDkcvzOzp7XP5oUjvf5uOwgn/oAAoLzpKFDISLA=;
        b=p015+/VwbseaBsWwrhAew84vZXkrUQXVZykzQSTNh1Z64fob+q6Ik0GSFOsdM36dwO
         HTDy5Peyxy8bxxV6QY1xCjifXZE+qZugyDRinOGSf2FuflTSFOjFphuK6AN4glBl2iEy
         kU0BrgPhEv3tskF9Nz1JfWjSOnuX+zjWasvVvXOAdSgSTbWPJjcaRpj+Dt+dQADyI97Y
         puSdNTn/PetDfzt5i9Ih2SAZuoPK7gB+Qtw9eCfH3/h+S/BgZJcglQtTrl4YebdYvfe2
         EL7tSv1W9ybRx/MiAnnRBWlYFMW0lZuVt37KBIeW3wBb96bt8x1VcoVmS7doqd5yqegd
         KU/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=lz6pPDkcvzOzp7XP5oUjvf5uOwgn/oAAoLzpKFDISLA=;
        b=nE86e5l55SDs9FL/c8nxX5qdpemvsPNMqWVjqt+/ZQR6G0OOBzR+9xGLRW2swqvXqR
         DoHblADApmQCN//jlrZ2vN8qgd3K/2ir4U5WNQFiNmCdXUhWY2OK/zvGoPty+vj5LKMG
         1vjv/W5Bj8Lwi+tCjo53EmEoIIN6jIBRdKaM4VXn5TWO1vMzplgHBjFDNRn0qIjGpjhY
         m/nwmH0RUpby6W2XH9H7OiCJqVZQl1wXeqYb9oPesxVRdrwanjcA1gqPwN8N/0Iy2VcB
         zE6U7zcs8Olk/ro0JOU7KwFtnu7ZWMq0JqY9TC6Jxe+vPBSEJM93uM8is55Tb7S4/78W
         zfFA==
X-Gm-Message-State: APjAAAXQQTU2T7UUPAHixmVjCGtYsH1Qmf+MeeJv4Z0IfA6x6D5huciN
        iTAqtzAEAjmCTpTpiwIF+jtiLfBMoDUW3Q==
X-Google-Smtp-Source: APXvYqypaRSlQiCJbhzKSPGzfCsE9jjkQ+NJT0O7PcE6PzrEX1u7w+MtLbnwX/RCSWsSi5zt82gIvQ==
X-Received: by 2002:a05:6214:303:: with SMTP id i3mr2160017qvu.148.1568212212424;
        Wed, 11 Sep 2019 07:30:12 -0700 (PDT)
Received: from localhost.localdomain ([2001:1284:f016:e600:cd79:21fe:b069:7c04])
        by smtp.gmail.com with ESMTPSA id w11sm12027815qtj.10.2019.09.11.07.30.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Sep 2019 07:30:11 -0700 (PDT)
Received: by localhost.localdomain (Postfix, from userid 1000)
        id 04F69C4A64; Wed, 11 Sep 2019 11:30:08 -0300 (-03)
Date:   Wed, 11 Sep 2019 11:30:08 -0300
From:   Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
To:     Dan Carpenter <dan.carpenter@oracle.com>
Cc:     maowenan <maowenan@huawei.com>, vyasevich@gmail.com,
        nhorman@tuxdriver.com, davem@davemloft.net,
        linux-sctp@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH net 1/2] sctp: remove redundant assignment when call
 sctp_get_port_local
Message-ID: <20190911143008.GD3499@localhost.localdomain>
References: <20190910071343.18808-1-maowenan@huawei.com>
 <20190910071343.18808-2-maowenan@huawei.com>
 <20190910185710.GF15977@kadam>
 <20190910192207.GE20699@kadam>
 <53556c87-a351-4314-cbd9-49a39d0b41aa@huawei.com>
 <20190911083038.GF20699@kadam>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190911083038.GF20699@kadam>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Sep 11, 2019 at 11:30:38AM +0300, Dan Carpenter wrote:
> On Wed, Sep 11, 2019 at 09:30:47AM +0800, maowenan wrote:
> > 
> > 
> > On 2019/9/11 3:22, Dan Carpenter wrote:
> > > On Tue, Sep 10, 2019 at 09:57:10PM +0300, Dan Carpenter wrote:
> > >> On Tue, Sep 10, 2019 at 03:13:42PM +0800, Mao Wenan wrote:
> > >>> There are more parentheses in if clause when call sctp_get_port_local
> > >>> in sctp_do_bind, and redundant assignment to 'ret'. This patch is to
> > >>> do cleanup.
> > >>>
> > >>> Signed-off-by: Mao Wenan <maowenan@huawei.com>
> > >>> ---
> > >>>  net/sctp/socket.c | 3 +--
> > >>>  1 file changed, 1 insertion(+), 2 deletions(-)
> > >>>
> > >>> diff --git a/net/sctp/socket.c b/net/sctp/socket.c
> > >>> index 9d1f83b10c0a..766b68b55ebe 100644
> > >>> --- a/net/sctp/socket.c
> > >>> +++ b/net/sctp/socket.c
> > >>> @@ -399,9 +399,8 @@ static int sctp_do_bind(struct sock *sk, union sctp_addr *addr, int len)
> > >>>  	 * detection.
> > >>>  	 */
> > >>>  	addr->v4.sin_port = htons(snum);
> > >>> -	if ((ret = sctp_get_port_local(sk, addr))) {
> > >>> +	if (sctp_get_port_local(sk, addr))
> > >>>  		return -EADDRINUSE;
> > >>
> > >> sctp_get_port_local() returns a long which is either 0,1 or a pointer
> > >> casted to long.  It's not documented what it means and neither of the
> > >> callers use the return since commit 62208f12451f ("net: sctp: simplify
> > >> sctp_get_port").
> > > 
> > > Actually it was commit 4e54064e0a13 ("sctp: Allow only 1 listening
> > > socket with SO_REUSEADDR") from 11 years ago.  That patch fixed a bug,
> > > because before the code assumed that a pointer casted to an int was the
> > > same as a pointer casted to a long.
> > 
> > commit 4e54064e0a13 treated non-zero return value as unexpected, so the current
> > cleanup is ok?
> 
> Yeah.  It's fine, I was just confused why we weren't preserving the
> error code and then I saw that we didn't return errors at all and got
> confused.

But please lets seize the moment and do the change Dean suggested.
This was the last place saving this return value somewhere. It makes
sense to cleanup sctp_get_port_local() now and remove that masked
pointer return.

Then you may also cleanup:
socket.c:       return !!sctp_get_port_local(sk, &addr);
as it will be a direct map.

  Marcelo
