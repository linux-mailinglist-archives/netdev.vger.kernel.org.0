Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F21127B332
	for <lists+netdev@lfdr.de>; Tue, 30 Jul 2019 21:24:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727776AbfG3TYP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Jul 2019 15:24:15 -0400
Received: from mail-qk1-f194.google.com ([209.85.222.194]:45728 "EHLO
        mail-qk1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725840AbfG3TYP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Jul 2019 15:24:15 -0400
Received: by mail-qk1-f194.google.com with SMTP id s22so47464342qkj.12;
        Tue, 30 Jul 2019 12:24:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=OhLVyjdTUvve/Y4PMA/hXjNnH3oXEzxOn7HC1gnatZA=;
        b=GlbndsXxIjom3ykqpo8LnDNYTtbISpEltEU9d9aAqJTZ8tfluq9SzJh3ToGQYRnUhm
         EYmgm6MUO9+/bags2mtIBdpNQPXfvFakMohkxbIsv+u9EUkqWzj0O0AW/Mi//mgWuBd+
         Jo04uDa4RwZbbmVKR+dKmUujpV8cv5oQ5te5H67JlKG+/OHH+xDix4H55SEVRDWlGzY0
         4i0tW9SETg8bIcXwIJuv1EmkwJ1ZM2/GACWYREbGqDBjnG8VE4cJaD/JTqoVht+GqC5U
         aXK4nZvbChmQSgL6v9KRdgwjJqRbrKJwT2lgEoUBUrYZdO9jdUSOgCcIAGDtDgUIo3c3
         Ng5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=OhLVyjdTUvve/Y4PMA/hXjNnH3oXEzxOn7HC1gnatZA=;
        b=PL2qZE6LYsC9ATy7kSv33d31tZt3zCfthQhqSfW+Vk0A2NsUDa3IipnTf28Rlhsm2k
         7mbAFV7CdfGoBXnWmsZXWyGBqSI9U683VshebhUPv+mlURTGOGZMxhOS0a7rRmhto/a8
         pruvVYuOhnojhLWx+7XrtJKgMbWgb7w6TcOppBGKhmdOkvb1tc+qJQOnuZ1vELNFHBdb
         W74fgub8ydVbPKkV0RdVSlNYX9WuT8901mOn8jbkjU77vVJ2YiA7NLCLYWzoGjWgMpkv
         5Z3jHR+50J087HQgV+UNLKRKnEwfkUgEry0xdM+H0dvs9HbweHX75Irf57xsBZZ4VEAW
         PPOQ==
X-Gm-Message-State: APjAAAWZqce4QP2SmWZNMAHON5qvYsm5dX2nAGn/Fi8g+WxT8cLFi9f3
        fPADzAHuBDAY96MnV/8hIFvWzbCJxlGZ0Q==
X-Google-Smtp-Source: APXvYqwlfCtCaDKcSXrAT5/wVU8wzUGOeo4yHpeHBlKfk1K9dSPdhCRr03/K+KGK5aS51ejrcr3dkw==
X-Received: by 2002:ae9:e10e:: with SMTP id g14mr75842138qkm.486.1564514654416;
        Tue, 30 Jul 2019 12:24:14 -0700 (PDT)
Received: from localhost.localdomain ([2001:1284:f016:a0af:c6c5:7c31:69b:3f23])
        by smtp.gmail.com with ESMTPSA id l19sm37164135qtb.6.2019.07.30.12.24.13
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Tue, 30 Jul 2019 12:24:13 -0700 (PDT)
Received: by localhost.localdomain (Postfix, from userid 1000)
        id 6C97BC0AD9; Tue, 30 Jul 2019 16:24:11 -0300 (-03)
Date:   Tue, 30 Jul 2019 16:24:11 -0300
From:   Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
To:     Xin Long <lucien.xin@gmail.com>
Cc:     network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org,
        Neil Horman <nhorman@tuxdriver.com>, davem@davemloft.net
Subject: Re: [PATCHv2 net-next 1/5] sctp: only copy the available addr data
 in sctp_transport_init
Message-ID: <20190730192411.GR6204@localhost.localdomain>
References: <cover.1564490276.git.lucien.xin@gmail.com>
 <bb6e9856c2db0f24b91fb326fbe3c9c013f2459b.1564490276.git.lucien.xin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <bb6e9856c2db0f24b91fb326fbe3c9c013f2459b.1564490276.git.lucien.xin@gmail.com>
User-Agent: Mutt/1.12.0 (2019-05-25)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 30, 2019 at 08:38:19PM +0800, Xin Long wrote:
> 'addr' passed to sctp_transport_init is not always a whole size
> of union sctp_addr, like the path:
> 
>   sctp_sendmsg() ->
>   sctp_sendmsg_new_asoc() ->
>   sctp_assoc_add_peer() ->
>   sctp_transport_new() -> sctp_transport_init()
> 
> In the next patches, we will also pass the address length of data
> only to sctp_assoc_add_peer().
> 
> So sctp_transport_init() should copy the only available data from
> addr to peer->ipaddr, instead of 'peer->ipaddr = *addr' which may
> cause slab-out-of-bounds.
> 
> Signed-off-by: Xin Long <lucien.xin@gmail.com>
> ---
>  net/sctp/transport.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/net/sctp/transport.c b/net/sctp/transport.c
> index e2f8e36..7235a60 100644
> --- a/net/sctp/transport.c
> +++ b/net/sctp/transport.c
> @@ -43,8 +43,8 @@ static struct sctp_transport *sctp_transport_init(struct net *net,
>  						  gfp_t gfp)
>  {
>  	/* Copy in the address.  */
> -	peer->ipaddr = *addr;
>  	peer->af_specific = sctp_get_af_specific(addr->sa.sa_family);
> +	memcpy(&peer->ipaddr, addr, peer->af_specific->sockaddr_len);

Just for the record, transports are allocated with kzalloc() and this
shouldn't result in any remaining bytes of this buffer to be
uninitialized.

That said, unrelated to the patch, memset below and other =0's are not
necessary.

>  	memset(&peer->saddr, 0, sizeof(union sctp_addr));
>  
>  	peer->sack_generation = 0;
> -- 
> 2.1.0
> 
