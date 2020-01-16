Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3358713F97D
	for <lists+netdev@lfdr.de>; Thu, 16 Jan 2020 20:28:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729547AbgAPT2j (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jan 2020 14:28:39 -0500
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:40080 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729044AbgAPT2j (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Jan 2020 14:28:39 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1579202918;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=G3MBraSZuHNQVH/nVENUhEPzBqwHjRc6fETDQjXVNy0=;
        b=NoirPH0gEiYj2jbYTZt5UHTwfik46MEDJs8eHPETH2XtcGqak2mltYJr9f+3rhHTcTeUA6
        j5PQIFRNjOEVlM/wfusjlLM67Xrn6glmkW+dTI36f6Ew90mj8I214+rgQqdd54peimTxYB
        Llt5nEPT0Hk6F7bv6VGD7rMCgjzk4mQ=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-430-Qf_KvArKNTmVYRGW9RBVew-1; Thu, 16 Jan 2020 14:28:31 -0500
X-MC-Unique: Qf_KvArKNTmVYRGW9RBVew-1
Received: by mail-wr1-f71.google.com with SMTP id f15so9692443wrr.2
        for <netdev@vger.kernel.org>; Thu, 16 Jan 2020 11:28:31 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=G3MBraSZuHNQVH/nVENUhEPzBqwHjRc6fETDQjXVNy0=;
        b=LuUPisy/Ola5Pj0aLYxztfvr4+/nGgSpWjvYHXziTyGEFma6X6UkDFOwSsZgAkEKfh
         17PyyTS5SnDcGj8UiQVWvEdWFeIO3XoAMyZ9r8lVdwo8uaeTU/sQFXVgtuTgx8bGAwki
         oVOg0P0Ma1IOmi+4KtC8E443KpDJYEbdVzT6fdwmMZtLP6aQdqTFLJ9UHp7w8VsptK4c
         mRV25t12+bhl/A7mCQ1hDBheM4j58CdnMrU3xs5nHV/9KFHBN8xaq+mOBjxMtXa3VvP4
         l2T7mG5dcbSwBpJwY2A0ZZ2k/ALOFb/layGJBVG8u3gvOKEisnKWkqoj3BdBiFiBrg3t
         7log==
X-Gm-Message-State: APjAAAW/OMjOdiihFSdgzmG+f7josS3qtD2Oz4/puCihGgE8vp6PHQHi
        QUTItX7zipjv3qBrkEDjhcFHpwI4JVUBAqyfl1rvJ1s+GYYUVI9AP02HQLo8Nc+N4b860V789j6
        1pnv4RzbxgDXdMTIm
X-Received: by 2002:adf:e6c6:: with SMTP id y6mr4968374wrm.284.1579202910095;
        Thu, 16 Jan 2020 11:28:30 -0800 (PST)
X-Google-Smtp-Source: APXvYqzBNvan8X0vIHztsvUw4FY6TIShY2YiTU88xMY8M6dKrMDJFnIJY5MeU6OR9ilEyllxVam03A==
X-Received: by 2002:adf:e6c6:: with SMTP id y6mr4968350wrm.284.1579202909777;
        Thu, 16 Jan 2020 11:28:29 -0800 (PST)
Received: from linux.home (2a01cb058a4e7100d3814d1912515f67.ipv6.abo.wanadoo.fr. [2a01:cb05:8a4e:7100:d381:4d19:1251:5f67])
        by smtp.gmail.com with ESMTPSA id v14sm30352304wrm.28.2020.01.16.11.28.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Jan 2020 11:28:29 -0800 (PST)
Date:   Thu, 16 Jan 2020 20:28:27 +0100
From:   Guillaume Nault <gnault@redhat.com>
To:     Tom Parkin <tparkin@katalix.com>
Cc:     Ridge Kennedy <ridge.kennedy@alliedtelesis.co.nz>,
        netdev@vger.kernel.org
Subject: Re: [PATCH net] l2tp: Allow duplicate session creation with UDP
Message-ID: <20200116192827.GB25654@linux.home>
References: <20200115223446.7420-1-ridge.kennedy@alliedtelesis.co.nz>
 <20200116123143.GA4028@jackdaw>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200116123143.GA4028@jackdaw>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 16, 2020 at 12:31:43PM +0000, Tom Parkin wrote:
> On  Thu, Jan 16, 2020 at 11:34:47 +1300, Ridge Kennedy wrote:
> > In the past it was possible to create multiple L2TPv3 sessions with the
> > same session id as long as the sessions belonged to different tunnels.
> > The resulting sessions had issues when used with IP encapsulated tunnels,
> > but worked fine with UDP encapsulated ones. Some applications began to
> > rely on this behaviour to avoid having to negotiate unique session ids.
> > 
> > Some time ago a change was made to require session ids to be unique across
> > all tunnels, breaking the applications making use of this "feature".
> > 
> > This change relaxes the duplicate session id check to allow duplicates
> > if both of the colliding sessions belong to UDP encapsulated tunnels.
> 
> I appreciate what you're saying with respect to buggy applications,
> however I think the existing kernel code is consistent with RFC 3931,
> which makes session IDs unique for a given LCCE.
> 
> Given how the L2TP data packet headers work for L2TPv3, I'm assuming
> that sessions in UDP-encapsulated tunnels work even if their session
> IDs clash because the tunnel sockets are using distinct UDP ports
> which will effectively separate the data traffic into the "correct"
> tunnel.  Obviously the same thing doesn't apply for IP-encap.
> 
> However, there's nothing to prevent user space from using the same UDP
> port for multiple tunnels, at which point this relaxation of the RFC
> rules would break down again.
> 
Multiplexing L2TP tunnels on top of non-connected UDP sockets might be
a nice optimisation for someone using many tunnels (like hundred of
thouthands), but I'm afraid the rest of the L2TP code is not ready to
handle such load anyway. And the current implementation only allows
one tunnel for each UDP socket anyway.

> Since UDP-encap can also be broken in the face of duplicated L2TPv3
> session IDs, I think its better that the kernel continue to enforce
> the RFC.
How is UDP-encap broken with duplicate session IDs (as long as a UDP
socket can only one have one tunnel associated with it and that no
duplicate session IDs are allowed inside the same tunnel)?

It all boils down to what's the scope of a session ID. For me it has
always been the parent tunnel. But if that's in contradiction with
RFC 3931, I'd be happy to know.

