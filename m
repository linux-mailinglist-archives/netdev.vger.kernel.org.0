Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 583E7469353
	for <lists+netdev@lfdr.de>; Mon,  6 Dec 2021 11:20:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236305AbhLFKXq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Dec 2021 05:23:46 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:48328 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232530AbhLFKXp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Dec 2021 05:23:45 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1638786017;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=skvl+6MlZe2GRtwWiKsWPPv+qj696SGkXDdPY29ZI68=;
        b=PwGI0Gpu1MRlBizQ2/lSh7MsLRyrOsEerAqlxfuS/ymdLIize5abTNCL7K+nJAC9m+t8W4
        +vAA5f+0blaXkPnnMixgHSxlSksG/vjkaxIXwKdHrJBj0DHbA4Q5HGc8bcQFh04U/sY5Mo
        BeGWOVbl7IYP5j4XBgk5yeDd3J8D0/Q=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-164-B1kMtJS3MVOPtjtvjgFbUw-1; Mon, 06 Dec 2021 05:20:15 -0500
X-MC-Unique: B1kMtJS3MVOPtjtvjgFbUw-1
Received: by mail-wm1-f69.google.com with SMTP id z138-20020a1c7e90000000b003319c5f9164so7642818wmc.7
        for <netdev@vger.kernel.org>; Mon, 06 Dec 2021 02:20:15 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=skvl+6MlZe2GRtwWiKsWPPv+qj696SGkXDdPY29ZI68=;
        b=Anfu4XXvq7rSGKCSGZqrdbwGr/zNNoPmKxPbcW/sriBCYF2+n8ntuZXbep4HORwriT
         hh8r0WvMgBTZCTqpBsxBsDHVYnWSzn2N2L5Vb8TSfa9g/sRCzrk1LjtxGtPO00lBiyoh
         R8xotWttVpGwd8JPLmNy0Xfdf7d8uxsE1WCYGzKGEfvTLABpmH4U/eZS1CiT5KRgecow
         puEe+HGFDnfcL8pIg8n9xiT0y7vzUv8vSnbjww2E5Sqm95rQoIaJod2jelV7e102Vg2u
         7BDiUF5Yn8vZcnyGZesOZ04zYEgTBbV3PgPtV43KSY+8gU1DGpUXk5k0NTWxswjp0B1t
         /jCg==
X-Gm-Message-State: AOAM533R1fTiFKNAQjzW3NoQV8n/J2Y6xNecIxOLcaH+SG8lfFia0X+S
        r84Rde7WVQ2kkGJfD9d3xuAs73+jaU28RBM3GJUqN3Rqqtb3QYKDn4rgdzbEViqV4Qji6I0HMrA
        XYZhbv2iNhIzGSs0V
X-Received: by 2002:adf:de0b:: with SMTP id b11mr43412668wrm.588.1638786014226;
        Mon, 06 Dec 2021 02:20:14 -0800 (PST)
X-Google-Smtp-Source: ABdhPJyJiuKvUp0ap6UDuQ+CQtsADuNwSK6Bhc9fw6BiPV+bnd3NHq2D/xUosreRUQdLxRNZrQsDIA==
X-Received: by 2002:adf:de0b:: with SMTP id b11mr43412655wrm.588.1638786014048;
        Mon, 06 Dec 2021 02:20:14 -0800 (PST)
Received: from gerbillo.redhat.com (146-241-252-1.dyn.eolo.it. [146.241.252.1])
        by smtp.gmail.com with ESMTPSA id h7sm10369117wrt.64.2021.12.06.02.20.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Dec 2021 02:20:13 -0800 (PST)
Message-ID: <70c5f1a6ecdc67586d108ab5ebed4be6febf8423.camel@redhat.com>
Subject: Re: [PATCH v3 net-next 2/2] bpf: let bpf_warn_invalid_xdp_action()
 report more info
From:   Paolo Abeni <pabeni@redhat.com>
To:     Daniel Borkmann <daniel@iogearbox.net>, netdev@vger.kernel.org
Cc:     Alexei Starovoitov <ast@kernel.org>, bpf@vger.kernel.org,
        Toke =?ISO-8859-1?Q?H=F8iland-J=F8rgensen?= <toke@redhat.com>
Date:   Mon, 06 Dec 2021 11:20:12 +0100
In-Reply-To: <1ac2941f-b751-9cf0-f0e3-ea0f245b7503@iogearbox.net>
References: <cover.1638189075.git.pabeni@redhat.com>
         <ddb96bb975cbfddb1546cf5da60e77d5100b533c.1638189075.git.pabeni@redhat.com>
         <1ac2941f-b751-9cf0-f0e3-ea0f245b7503@iogearbox.net>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.1 (3.42.1-1.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 2021-12-03 at 23:04 +0100, Daniel Borkmann wrote:
> Hi Paolo,
> 
> Changes look good to me as well, we can route the series via bpf-next after tree
> resync, or alternatively ask David/Jakub to take it directly into net-next with our
> Ack given in bpf-next there is no drivers/net/ethernet/microsoft/mana/mana_bpf.c yet.
> 
> On 11/30/21 11:08 AM, Paolo Abeni wrote:
> [...]> diff --git a/net/core/filter.c b/net/core/filter.c
> > index 5631acf3f10c..392838fa7652 100644
> > --- a/net/core/filter.c
> > +++ b/net/core/filter.c
> > @@ -8181,13 +8181,13 @@ static bool xdp_is_valid_access(int off, int size,
> >   	return __is_valid_xdp_access(off, size);
> >   }
> >   
> > -void bpf_warn_invalid_xdp_action(u32 act)
> > +void bpf_warn_invalid_xdp_action(struct net_device *dev, struct bpf_prog *prog, u32 act)
> >   {
> >   	const u32 act_max = XDP_REDIRECT;
> >   
> > -	pr_warn_once("%s XDP return value %u, expect packet loss!\n",
> > +	pr_warn_once("%s XDP return value %u on prog %s (id %d) dev %s, expect packet loss!\n",
> >   		     act > act_max ? "Illegal" : "Driver unsupported",
> > -		     act);
> > +		     act, prog->aux->name, prog->aux->id, dev ? dev->name : "");
> 
> One tiny nit, but we could fix it up while applying I'd have is that for !dev case
> we should probably dump a "<n/a>" or so just to avoid a kernel log message like
> "dev , expect packet loss".

Yep, that would probably be better. Pleas let me know it you prefer a
formal new version for the patch.

Thanks!

Paolo


