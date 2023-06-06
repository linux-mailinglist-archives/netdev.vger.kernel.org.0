Return-Path: <netdev+bounces-8603-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5A70E724BC2
	for <lists+netdev@lfdr.de>; Tue,  6 Jun 2023 20:51:05 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 147CE280F91
	for <lists+netdev@lfdr.de>; Tue,  6 Jun 2023 18:51:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4F1D6200DF;
	Tue,  6 Jun 2023 18:51:02 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42DD6125CC
	for <netdev@vger.kernel.org>; Tue,  6 Jun 2023 18:51:02 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C0AFA83
	for <netdev@vger.kernel.org>; Tue,  6 Jun 2023 11:50:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1686077458;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=0XFw6gcEgy9jlNj5A7rUaw0iqCQdUHsprsfL2vsu2qk=;
	b=GhktSge3BN/ixMd3TvvddGOQnnpuZp8PXLh2S/ApGlOc/4gYD2UYjXoBT1LN/LV2QVcSqT
	zWxe61i0ZxE8u7VGRq7kk0BV1pX/p/6dEeztYb8+UbTJjLr6FnIrd0V1zSpdnds60IZsCI
	OD5tY5xfWqBn6spx7HiZT855vIflRwY=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-657--pQj4RuiPJ6fEsPtJeC9UA-1; Tue, 06 Jun 2023 14:50:56 -0400
X-MC-Unique: -pQj4RuiPJ6fEsPtJeC9UA-1
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-3f5df65fa35so32739025e9.3
        for <netdev@vger.kernel.org>; Tue, 06 Jun 2023 11:50:56 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686077455; x=1688669455;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0XFw6gcEgy9jlNj5A7rUaw0iqCQdUHsprsfL2vsu2qk=;
        b=Mtmsv65CjX7MEjb+aziP+OEuLcpGeMtOjBr01ElF/9CsfOGYlsUBeIaq6kPIKaM4td
         aMNtKI7Il5RyIKTtf2BnPzUaWEb0qVPMb5q/1tOCCkeEVIGsQEy4lUDIC6LONIjfJmCd
         uR1cxsKvy9k0Aux5ffnTISMzJ1eswOA8uMJbGFi435WkVLMOCS4ClSoqjem3aJnyCVsz
         8G5SJO0QqPALwNQv0rAFsObDARj23iP5zuaKkOGGi5KhqLQe9n7qB0wdjNZNs9WaFUX9
         om7ONvlVZb1IZbnHlgKDxtSNfPYESa39ersvk/aZKlRU6MceSqSrlCI35pk3N8oeadFM
         hvSw==
X-Gm-Message-State: AC+VfDxgjHwARdJoRNWaId1XApT9SHXSRAJ+gTrEdorTAAcbB405SC7W
	9JMJan7smbMecsuRNPp6gjaqwUHtCNqF/OAwJmmXBSfY2fNfEOuJ9B+GO4JPabXq9Xt32Jxib4k
	K/ft/HoM9gdhkf+7yaEXsbXKS
X-Received: by 2002:a05:600c:2190:b0:3f7:e605:287c with SMTP id e16-20020a05600c219000b003f7e605287cmr2516524wme.40.1686077455345;
        Tue, 06 Jun 2023 11:50:55 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ4mno06Udc08ZqmQp5/iVohovKPWT68QmgpRONctzItJSjsWoMjSAoeJkseeOB3fP+Kwpr5oQ==
X-Received: by 2002:a05:600c:2190:b0:3f7:e605:287c with SMTP id e16-20020a05600c219000b003f7e605287cmr2516512wme.40.1686077455004;
        Tue, 06 Jun 2023 11:50:55 -0700 (PDT)
Received: from debian (2a01cb058d652b00fa0f162c47a2f35b.ipv6.abo.wanadoo.fr. [2a01:cb05:8d65:2b00:fa0f:162c:47a2:f35b])
        by smtp.gmail.com with ESMTPSA id m14-20020a7bcb8e000000b003f7ba52eeccsm7293471wmi.7.2023.06.06.11.50.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Jun 2023 11:50:54 -0700 (PDT)
Date: Tue, 6 Jun 2023 20:50:52 +0200
From: Guillaume Nault <gnault@redhat.com>
To: Mirsad Todorovac <mirsad.todorovac@alu.unizg.hr>
Cc: netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Shuah Khan <shuah@kernel.org>, linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org
Subject: Re: POSSIBLE BUG: selftests/net/fcnal-test.sh: [FAIL] in vrf "bind -
 ns-B IPv6 LLA" test
Message-ID: <ZH+ADF0OOcmtUPw9@debian>
References: <b6191f90-ffca-dbca-7d06-88a9788def9c@alu.unizg.hr>
 <ZHeN3bg28pGFFjJN@debian>
 <a379796a-5cd6-caa7-d11d-5ffa7419b90e@alu.unizg.hr>
 <ZH84zGEODT97TEXG@debian>
 <60f78eaa-ace7-c27d-8e45-4777ecf3faa2@alu.unizg.hr>
 <ZH8+jLjottBw2zuD@debian>
 <12c34bed-0885-3bb3-257f-3b2438ba206f@alu.unizg.hr>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <12c34bed-0885-3bb3-257f-3b2438ba206f@alu.unizg.hr>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Tue, Jun 06, 2023 at 04:28:02PM +0200, Mirsad Todorovac wrote:
> On 6/6/23 16:11, Guillaume Nault wrote:
> > On Tue, Jun 06, 2023 at 03:57:35PM +0200, Mirsad Todorovac wrote:
> > > +       if (oif) {
> > > +               rcu_read_lock();
> > > +               dev = dev_get_by_index_rcu(net, oif);
> > > +               rcu_read_unlock();
> > 
> > You can't assume '*dev' is still valid after rcu_read_unlock() unless
> > you hold a reference on it.
> > 
> > > +               rtnl_lock();
> > > +               mdev = netdev_master_upper_dev_get(dev);
> > > +               rtnl_unlock();
> > 
> > Because of that, 'dev' might have already disappeared at the time
> > netdev_master_upper_dev_get() is called. So it may dereference an
> > invalid pointer here.
> 
> Good point, thanks. I didn't expect those to change.
> 
> This can be fixed, provided that RCU and RTNL locks can be nested:

Well, yes and no. You can call rcu_read_{lock,unlock}() while under the
rtnl protection, but not the other way around.

>         rcu_read_lock();
>         if (oif) {
>                 dev = dev_get_by_index_rcu(net, oif);
>                 rtnl_lock();
>                 mdev = netdev_master_upper_dev_get(dev);
>                 rtnl_unlock();
>         }

This is invalid: rtnl_lock() uses a mutex, so it can sleep and that's
forbidden inside an RCU critical section.

>         if (sk->sk_bound_dev_if) {
>                 bdev = dev_get_by_index_rcu(net, sk->sk_bound_dev_if);
>         }
> 
>         addr_type = ipv6_addr_type(daddr);
>         if ((__ipv6_addr_needs_scope_id(addr_type) && !oif) ||
>             (addr_type & IPV6_ADDR_MAPPED) ||
>             (oif && sk->sk_bound_dev_if && oif != sk->sk_bound_dev_if &&
>                     !(mdev && sk->sk_bound_dev_if && bdev && mdev == bdev))) {
>                 rcu_read_unlock();
>                 return -EINVAL;
> 	}
>         rcu_read_unlock();
> 
> But again this is still probably not race-free (bdev might also disappear before
> the mdev == bdev test), even if it passed fcnal-test.sh, there is much duplication
> of code, so your one-line solution is obviously by far better. :-)

The real problem is choosing the right function for getting the master
device. In particular netdev_master_upper_dev_get() was a bad choice.
It forces you to take the rtnl, which is unnatural here and obliges you
to add extra code, while all this shouldn't be necessary in the first
place.

> Much obliged.
> 
> Best regards,
> Mirsad


