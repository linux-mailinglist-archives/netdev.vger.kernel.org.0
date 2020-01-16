Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B49A213F6A4
	for <lists+netdev@lfdr.de>; Thu, 16 Jan 2020 20:06:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387942AbgAPTGG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jan 2020 14:06:06 -0500
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:38826 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1733289AbgAPTGD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Jan 2020 14:06:03 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1579201562;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=FSPKhmnOzDnzJzJBVKvFEQLgSi5rPFEQg67uq9ObDD4=;
        b=YIYGliIrlmUlkFb0VeYhHAzvxpY6ArHHv03A9E0GuxCuQVVEKDr8kuwYnCO0rDU0TV8M6B
        SQI0bzPNwnsqLTF91vak9GOZ0XXRKSAn60eL6Eg2egSI/J2FocHvVCxehS1ZHFnpdZFIty
        s5M1ftqJs+IdWzIjypyBo0aRB2wWSoA=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-185-d_AxEjFYN7CfxgEj8D8Y7g-1; Thu, 16 Jan 2020 14:06:00 -0500
X-MC-Unique: d_AxEjFYN7CfxgEj8D8Y7g-1
Received: by mail-wr1-f69.google.com with SMTP id f15so9679780wrr.2
        for <netdev@vger.kernel.org>; Thu, 16 Jan 2020 11:06:00 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=FSPKhmnOzDnzJzJBVKvFEQLgSi5rPFEQg67uq9ObDD4=;
        b=Jv0JEfLzpXKxbsONklr/Jy+gq2ke2FyUyMbIZgH409M/nKW8C/cwgUHE1xs0mrPTFN
         16xxvrttimz1qvMWDoacumgRF1HxhIYoRT6SWR4+IFHYqBSEfW5kJHG/L81LwFDXm04a
         0QmgKLn6mlOTzdO72yJBnCHcNsliqKPU3NVkftP1atoshDz2/PbAzMsVQjh73ohYcRaO
         58XsT44Dplt4l9+EPyZHd0srJXYrEjr9lEXtqjA4HfDtxm0d9qWPjBqXzAM2+k6XuvJ4
         w4EXIm3tA3KAhQJOzw6ilmPOMpC8HdcREj1pwsCnNAmzrw5IvSscnP7qUUDZaL2vl14K
         LFHA==
X-Gm-Message-State: APjAAAVw5EEjsUoIlinAbvujyjZ09lgN7rU3Vi37rXe/TArbcVc5KZ+f
        WMJP8WU4v9Ou/HCj02yq6GX7olSujO0ls47845EgMDdzTqsBuGapSlBMaz/kDKFaH4KI6ixGcO2
        A1vTxSj1fzLA49z0v
X-Received: by 2002:a1c:99ce:: with SMTP id b197mr506929wme.108.1579201559252;
        Thu, 16 Jan 2020 11:05:59 -0800 (PST)
X-Google-Smtp-Source: APXvYqwlWH9yZiUnVSvzH+3U5CsjUPbkXwqeUS2zO7WCrxBSKkxW2uK5UQMWjQ0ncYNvqSNdo3Lfhw==
X-Received: by 2002:a1c:99ce:: with SMTP id b197mr506909wme.108.1579201558984;
        Thu, 16 Jan 2020 11:05:58 -0800 (PST)
Received: from linux.home (2a01cb058a4e7100d3814d1912515f67.ipv6.abo.wanadoo.fr. [2a01:cb05:8a4e:7100:d381:4d19:1251:5f67])
        by smtp.gmail.com with ESMTPSA id t190sm177049wmt.44.2020.01.16.11.05.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Jan 2020 11:05:58 -0800 (PST)
Date:   Thu, 16 Jan 2020 20:05:56 +0100
From:   Guillaume Nault <gnault@redhat.com>
To:     Tom Parkin <tparkin@katalix.com>
Cc:     Ridge Kennedy <ridge.kennedy@alliedtelesis.co.nz>,
        netdev@vger.kernel.org
Subject: Re: [PATCH net] l2tp: Allow duplicate session creation with UDP
Message-ID: <20200116190556.GA25654@linux.home>
References: <20200115223446.7420-1-ridge.kennedy@alliedtelesis.co.nz>
 <20200116123854.GA23974@linux.home>
 <20200116131223.GB4028@jackdaw>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200116131223.GB4028@jackdaw>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 16, 2020 at 01:12:24PM +0000, Tom Parkin wrote:
> On  Thu, Jan 16, 2020 at 13:38:54 +0100, Guillaume Nault wrote:
> > Well, I think we have a more fundamental problem here. By adding
> > L2TPoUDP sessions to the global list, we allow cross-talks with L2TPoIP
> > sessions. That is, if we have an L2TPv3 session X running over UDP and
> > we receive an L2TP_IP packet targetted at session ID X, then
> > l2tp_session_get() will return the L2TP_UDP session to l2tp_ip_recv().
> > 
> > I guess l2tp_session_get() should be dropped and l2tp_ip_recv() should
> > look up the session in the context of its socket, like in the UDP case.
> > 
> > But for the moment, what about just not adding L2TP_UDP sessions to the
> > global list? That should fix both your problem and the L2TP_UDP/L2TP_IP
> > cross-talks.
> > 
> > diff --git a/net/l2tp/l2tp_core.c b/net/l2tp/l2tp_core.c
> > index f82ea12bac37..f70fea8d093d 100644
> > --- a/net/l2tp/l2tp_core.c
> > +++ b/net/l2tp/l2tp_core.c
> > @@ -316,7 +316,7 @@ int l2tp_session_register(struct l2tp_session *session,
> >  			goto err_tlock;
> >  		}
> >  
> > -	if (tunnel->version == L2TP_HDR_VER_3) {
> > +	if (tunnel->encap == L2TP_ENCAPTYPE_IP) {
> >  		pn = l2tp_pernet(tunnel->l2tp_net);
> >  		g_head = l2tp_session_id_hash_2(pn, session->session_id);
> >  
> > @@ -1587,8 +1587,8 @@ void __l2tp_session_unhash(struct l2tp_session *session)
> >  		hlist_del_init(&session->hlist);
> >  		write_unlock_bh(&tunnel->hlist_lock);
> >  
> > -		/* For L2TPv3 we have a per-net hash: remove from there, too */
> > -		if (tunnel->version != L2TP_HDR_VER_2) {
> > +		/* For IP encap we have a per-net hash: remove from there, too */
> > +		if (tunnel->encap == L2TP_ENCAPTYPE_IP) {
> >  			struct l2tp_net *pn = l2tp_pernet(tunnel->l2tp_net);
> >  			spin_lock_bh(&pn->l2tp_session_hlist_lock);
> >  			hlist_del_init_rcu(&session->global_hlist);
> >
> 
> I agree with you about the possibility for cross-talk, and I would
> welcome l2tp_ip/ip6 doing more validation.  But I don't think we should
> ditch the global list.
> 
> As per the RFC, for L2TPv3 the session ID should be a unique
> identifier for the LCCE.  So it's reasonable that the kernel should
> enforce that when registering sessions.
> 
I had never thought that the session ID could have global significance
in L2TPv3, but maybe that's because my experience is mostly about
L2TPv2. I haven't read RFC 3931 in detail, but I can't see how
restricting the scope of sessions to their parent tunnel would conflict
with the RFC.

> When you're referring to cross-talk, I wonder whether you have in mind
> normal operation or malicious intent?  I suppose it would be possible
> for someone to craft session data packets in order to disrupt a
> session.
> 
What makes me uneasy is that, as soon as the l2tp_ip or l2tp_ip6 module
is loaded, a peer can reach whatever L2TPv3 session exists on the host
just by sending an L2TP_IP packet to it.
I don't know how practical it is to exploit this fact, but it looks
like it's asking for trouble.

> For normal operation, you just need to get the wrong packet on the
> wrong socket to run into trouble of course.  In such a situation
> having a unique session ID for v3 helps you to determine that
> something has gone wrong, which is what the UDP encap recv path does
> if the session data packet's session ID isn't found in the context of
> the socket that receives it.
Unique global session IDs might help troubleshooting, but they also
break some use cases, as reported by Ridge. At some point, we'll have
to make a choice, or even add a knob if necessary.

