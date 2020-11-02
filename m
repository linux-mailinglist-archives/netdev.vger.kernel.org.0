Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2122C2A2882
	for <lists+netdev@lfdr.de>; Mon,  2 Nov 2020 11:48:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728484AbgKBKsb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Nov 2020 05:48:31 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:60051 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728316AbgKBKsb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Nov 2020 05:48:31 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1604314110;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=t4pGMj34NOEkxkJO4svHLpYj4X3D5C9C+6vudFv9OuU=;
        b=EppOIC2J/6ovNcl3LEjaDQOs9rTx/ragX6/vx6AP5WONDUEuYMEP8XcyJ0Sb+8647GSpdB
        /Hy7fBIGzacoO4G1U8GqgiKP4zcHy92W/KKbOkjS2LsaBi2Q6DNvICL1YvZD6oA9gTifTw
        /SK8CAIgV+YhANQRMhCkBw0tw8SKMqg=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-274-SXQSKGsEOfu3heISXelIWw-1; Mon, 02 Nov 2020 05:48:28 -0500
X-MC-Unique: SXQSKGsEOfu3heISXelIWw-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 7A0681868407;
        Mon,  2 Nov 2020 10:48:27 +0000 (UTC)
Received: from ovpn-113-223.ams2.redhat.com (ovpn-113-223.ams2.redhat.com [10.36.113.223])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 4E8175DA6A;
        Mon,  2 Nov 2020 10:48:26 +0000 (UTC)
Message-ID: <97343b07772ae794ca2aad683734901c055aa0ab.camel@redhat.com>
Subject: Re: [PATCH net] mptcp: token: fix unititialized variable
From:   Paolo Abeni <pabeni@redhat.com>
To:     Davide Caratti <dcaratti@redhat.com>, mptcp@lists.01.org,
        netdev@vger.kernel.org
Cc:     Jakub Kicinski <kuba@kernel.org>
Date:   Mon, 02 Nov 2020 11:48:25 +0100
In-Reply-To: <49e20da5d467a73414d4294a8bd35e2cb1befd49.1604308087.git.dcaratti@redhat.com>
References: <49e20da5d467a73414d4294a8bd35e2cb1befd49.1604308087.git.dcaratti@redhat.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-1.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 2020-11-02 at 10:09 +0100, Davide Caratti wrote:
> gcc complains about use of uninitialized 'num'. Fix it by doing the first
> assignment of 'num' when the variable is declared.
> 
> Fixes: 96d890daad05 ("mptcp: add msk interations helper")
> Signed-off-by: Davide Caratti <dcaratti@redhat.com>
> ---
>  net/mptcp/token.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/net/mptcp/token.c b/net/mptcp/token.c
> index 8b47c4bb1c6b..feb4b9ffd462 100644
> --- a/net/mptcp/token.c
> +++ b/net/mptcp/token.c
> @@ -291,7 +291,7 @@ struct mptcp_sock *mptcp_token_iter_next(const struct net *net, long *s_slot,
>  {
>  	struct mptcp_sock *ret = NULL;
>  	struct hlist_nulls_node *pos;
> -	int slot, num;
> +	int slot, num = 0;
>  
>  	for (slot = *s_slot; slot <= token_mask; *s_num = 0, slot++) {
>  		struct token_bucket *bucket = &token_hash[slot];

LGTM, thanks Davide!

Acked-by: Paolo Abeni <pabeni@redhat.com>

