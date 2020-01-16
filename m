Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ACABD13DA2B
	for <lists+netdev@lfdr.de>; Thu, 16 Jan 2020 13:39:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726278AbgAPMjF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jan 2020 07:39:05 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:47420 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726082AbgAPMjF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Jan 2020 07:39:05 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1579178344;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=xngfaP2ZROM9Q+2JNWAevdkrcdgN7hk/xC+a878e7tc=;
        b=CowoZrvPahAyK+d8yOA3HFAjzhgnK7Q+c6ejKHzPF3w6yvECeNgrI2O3bJ9QrSRyH5uV/7
        ZlhpzWnbe8qMMjQz45w8mgPkgH/eF6E4JG0QT22aIPIJsInpiCicqarbSjpd2Nn22IP/bn
        t0pismtgxQIkFhvhQ/KvFVSOIXcDKtI=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-369-fn6ckMUGN1aVzgTjfjQE4A-1; Thu, 16 Jan 2020 07:38:58 -0500
X-MC-Unique: fn6ckMUGN1aVzgTjfjQE4A-1
Received: by mail-wr1-f71.google.com with SMTP id u12so9211564wrt.15
        for <netdev@vger.kernel.org>; Thu, 16 Jan 2020 04:38:58 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=xngfaP2ZROM9Q+2JNWAevdkrcdgN7hk/xC+a878e7tc=;
        b=GZmxnIBFjVhTdPjL+ryiinu3V0TW4ERSZz//P6l1WJXXc0INw7vqHXWPD5kZ9F3AnJ
         HZvADWUFpi7Y1T+Ute8G5+MgzhSy9NfXNjofWPfu53t2uHnbzrznJYUJcSgK7SAaLNKw
         LNlM2phszqVtIB20BTjGjdIe75zmwIUZVkvn1gIRMUtSSWCf146KZOJJl6S5DlYnek3w
         jEASd+oPNzgLu2Dq4K99Ib4V4GtQB2mU+AkzMNAR6BUSAromop0m1qOru4b/RsdnjymK
         e1gH52ipssyS28vtjEyXBMhEv68Ol41rZpYBphvsuPHYeYjawFSEvf+bE3/+FAAt+/dE
         em7w==
X-Gm-Message-State: APjAAAXf3GuixihP3M7kJZdDJmddB+hPDi+3A/jvSKn9TJ33+tDfX2Xs
        +KnXfOEgBNZxaL0Y8cvwARNpqbNa74GfY0GR66CBDxG47/cdeS4PEnENpQBCtXjDeLRnj/HK1Y/
        Zzq/3u5BMArXqf5A7
X-Received: by 2002:a05:600c:248:: with SMTP id 8mr6066047wmj.175.1579178337211;
        Thu, 16 Jan 2020 04:38:57 -0800 (PST)
X-Google-Smtp-Source: APXvYqyNJGuilI0NOfEiesDJ0M6zEeMMSflKOy1NXyQLkz9BFfAk5eEEY+cDWy45BLdu2JOlK5kMjQ==
X-Received: by 2002:a05:600c:248:: with SMTP id 8mr6066026wmj.175.1579178336986;
        Thu, 16 Jan 2020 04:38:56 -0800 (PST)
Received: from linux.home (2a01cb058a4e7100d3814d1912515f67.ipv6.abo.wanadoo.fr. [2a01:cb05:8a4e:7100:d381:4d19:1251:5f67])
        by smtp.gmail.com with ESMTPSA id o4sm28800993wrw.97.2020.01.16.04.38.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Jan 2020 04:38:56 -0800 (PST)
Date:   Thu, 16 Jan 2020 13:38:54 +0100
From:   Guillaume Nault <gnault@redhat.com>
To:     Ridge Kennedy <ridge.kennedy@alliedtelesis.co.nz>
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH net] l2tp: Allow duplicate session creation with UDP
Message-ID: <20200116123854.GA23974@linux.home>
References: <20200115223446.7420-1-ridge.kennedy@alliedtelesis.co.nz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200115223446.7420-1-ridge.kennedy@alliedtelesis.co.nz>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 16, 2020 at 11:34:47AM +1300, Ridge Kennedy wrote:
> In the past it was possible to create multiple L2TPv3 sessions with the
> same session id as long as the sessions belonged to different tunnels.
> The resulting sessions had issues when used with IP encapsulated tunnels,
> but worked fine with UDP encapsulated ones. Some applications began to
> rely on this behaviour to avoid having to negotiate unique session ids.
> 
> Some time ago a change was made to require session ids to be unique across
> all tunnels, breaking the applications making use of this "feature".
> 
> This change relaxes the duplicate session id check to allow duplicates
> if both of the colliding sessions belong to UDP encapsulated tunnels.
> 
> Fixes: dbdbc73b4478 ("l2tp: fix duplicate session creation")
> Signed-off-by: Ridge Kennedy <ridge.kennedy@alliedtelesis.co.nz>
> ---
>  net/l2tp/l2tp_core.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/net/l2tp/l2tp_core.c b/net/l2tp/l2tp_core.c
> index f82ea12bac37..0cc86227c618 100644
> --- a/net/l2tp/l2tp_core.c
> +++ b/net/l2tp/l2tp_core.c
> @@ -323,7 +323,9 @@ int l2tp_session_register(struct l2tp_session *session,
>  		spin_lock_bh(&pn->l2tp_session_hlist_lock);
>  
>  		hlist_for_each_entry(session_walk, g_head, global_hlist)
> -			if (session_walk->session_id == session->session_id) {
> +			if (session_walk->session_id == session->session_id &&
> +			    (session_walk->tunnel->encap == L2TP_ENCAPTYPE_IP ||
> +			     tunnel->encap == L2TP_ENCAPTYPE_IP)) {
>  				err = -EEXIST;
>  				goto err_tlock_pnlock;
>  			}
Well, I think we have a more fundamental problem here. By adding
L2TPoUDP sessions to the global list, we allow cross-talks with L2TPoIP
sessions. That is, if we have an L2TPv3 session X running over UDP and
we receive an L2TP_IP packet targetted at session ID X, then
l2tp_session_get() will return the L2TP_UDP session to l2tp_ip_recv().

I guess l2tp_session_get() should be dropped and l2tp_ip_recv() should
look up the session in the context of its socket, like in the UDP case.

But for the moment, what about just not adding L2TP_UDP sessions to the
global list? That should fix both your problem and the L2TP_UDP/L2TP_IP
cross-talks.

diff --git a/net/l2tp/l2tp_core.c b/net/l2tp/l2tp_core.c
index f82ea12bac37..f70fea8d093d 100644
--- a/net/l2tp/l2tp_core.c
+++ b/net/l2tp/l2tp_core.c
@@ -316,7 +316,7 @@ int l2tp_session_register(struct l2tp_session *session,
 			goto err_tlock;
 		}
 
-	if (tunnel->version == L2TP_HDR_VER_3) {
+	if (tunnel->encap == L2TP_ENCAPTYPE_IP) {
 		pn = l2tp_pernet(tunnel->l2tp_net);
 		g_head = l2tp_session_id_hash_2(pn, session->session_id);
 
@@ -1587,8 +1587,8 @@ void __l2tp_session_unhash(struct l2tp_session *session)
 		hlist_del_init(&session->hlist);
 		write_unlock_bh(&tunnel->hlist_lock);
 
-		/* For L2TPv3 we have a per-net hash: remove from there, too */
-		if (tunnel->version != L2TP_HDR_VER_2) {
+		/* For IP encap we have a per-net hash: remove from there, too */
+		if (tunnel->encap == L2TP_ENCAPTYPE_IP) {
 			struct l2tp_net *pn = l2tp_pernet(tunnel->l2tp_net);
 			spin_lock_bh(&pn->l2tp_session_hlist_lock);
 			hlist_del_init_rcu(&session->global_hlist);

