Return-Path: <netdev+bounces-8956-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 264B4726673
	for <lists+netdev@lfdr.de>; Wed,  7 Jun 2023 18:52:21 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 823C41C20E32
	for <lists+netdev@lfdr.de>; Wed,  7 Jun 2023 16:52:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6EB091ACBD;
	Wed,  7 Jun 2023 16:52:18 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6251B63B5
	for <netdev@vger.kernel.org>; Wed,  7 Jun 2023 16:52:18 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 606DFE46
	for <netdev@vger.kernel.org>; Wed,  7 Jun 2023 09:52:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1686156724;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=E+Camu/wrYylmYMS88G8cmb/R4NWSFmH8HlRp/yIaXc=;
	b=bHb4p4Uz2smGJdBcrkzJYoJbg1KQQuqdr/kGxs3KpvC29k5+VzAaDJxPbL1sop6mjVkav7
	2r4UdxEhKA195sU1GU/J+LazUVhizHByMu8W/mbmNbQKFHLMOi1cK5CHV1jrYS55yVylIr
	E43XE5XGsaYSKNeUrYalWdBpaXGkkf4=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-556-hY7vuqS1MdulhAMPbzDpXA-1; Wed, 07 Jun 2023 12:52:03 -0400
X-MC-Unique: hY7vuqS1MdulhAMPbzDpXA-1
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-30932d15a30so4150209f8f.1
        for <netdev@vger.kernel.org>; Wed, 07 Jun 2023 09:52:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686156722; x=1688748722;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=E+Camu/wrYylmYMS88G8cmb/R4NWSFmH8HlRp/yIaXc=;
        b=ejKTAZ79CeW2CT57MVdmNoP+sbolIo51eSBGrwIL+osyKVTvx/tokxLoGSat6GcYvC
         ulw6o0OyoUdBhp7I3eSs7EJUrzSG68j5eUDgcDTGFY4pFHgXNJ0EAMwDxhm+jbiT2Iiz
         vFSZmaSLdMLRaO7jMMiCMfQIsjmg67T5D8M4hmTVCpwcL14wD63JDwcnpak+hHxZhtWy
         A669MT2UHuIoxowxv270Hv2lxjhNAXlG2q+s+6Cc1NBYBy/87aRXlNfsm7pk7bi8SpMR
         lOEvwAlLB0+1gJr9+SzKNUDYPTuIa8jSS2Z9vmCWBBMXBvFcjf3Pkgl9n2jEsnOvmxwS
         B5rw==
X-Gm-Message-State: AC+VfDzmM3vjMGLrXemNhwUcNUBm2+NjTZUv3sDySq3KS5edsyog7qlw
	ixYZi1Gx04x3WzbBi/kd9I7azGBgB5t2uimFIvQA3WoadFyd9sUfU9nuShO+jBwNy73c2W2hDU9
	/S7qV+wPhGInOQH6p
X-Received: by 2002:a5d:5687:0:b0:309:838:8c21 with SMTP id f7-20020a5d5687000000b0030908388c21mr4844406wrv.38.1686156722207;
        Wed, 07 Jun 2023 09:52:02 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ7xPltdMzBs9LNvRUqNzLN0Hg5c1lRRR0kmkHjhr8XETs7I3mNU/9WXnzEVajwk2UZq5vgngg==
X-Received: by 2002:a5d:5687:0:b0:309:838:8c21 with SMTP id f7-20020a5d5687000000b0030908388c21mr4844395wrv.38.1686156721825;
        Wed, 07 Jun 2023 09:52:01 -0700 (PDT)
Received: from debian (2a01cb058d652b00ba1a24d15502040a.ipv6.abo.wanadoo.fr. [2a01:cb05:8d65:2b00:ba1a:24d1:5502:40a])
        by smtp.gmail.com with ESMTPSA id z18-20020a1c4c12000000b003f60d0eef36sm2747537wmf.48.2023.06.07.09.52.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Jun 2023 09:52:01 -0700 (PDT)
Date: Wed, 7 Jun 2023 18:51:59 +0200
From: Guillaume Nault <gnault@redhat.com>
To: Mirsad Goran Todorovac <mirsad.todorovac@alu.unizg.hr>
Cc: netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Shuah Khan <shuah@kernel.org>, linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org
Subject: Re: POSSIBLE BUG: selftests/net/fcnal-test.sh: [FAIL][FIX TESTED] in
 vrf "bind - ns-B IPv6 LLA" test
Message-ID: <ZIC1r6IHOM5nr9QD@debian>
References: <b6191f90-ffca-dbca-7d06-88a9788def9c@alu.unizg.hr>
 <ZHeN3bg28pGFFjJN@debian>
 <a379796a-5cd6-caa7-d11d-5ffa7419b90e@alu.unizg.hr>
 <ZH84zGEODT97TEXG@debian>
 <48cfd903-ad2f-7da7-e5a6-a22392dc8650@alu.unizg.hr>
 <ZH+BhFzvJkWyjBE0@debian>
 <a3b2891d-d355-dacd-24ec-af9f8aacac57@alu.unizg.hr>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a3b2891d-d355-dacd-24ec-af9f8aacac57@alu.unizg.hr>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Wed, Jun 07, 2023 at 12:04:52AM +0200, Mirsad Goran Todorovac wrote:
> I cannot tell if those are new for the architecture (Ubuntu 22.04 + AMD Ryzen)
> 
> However, Ubuntu's unsigned 6.3.1 generic mainline kernel is also affected.
> So, it might seem like an old problem.
> 
> (If you could isolate the exact tests, I could try a bisect.)
> 
> [...]
> TEST: ping local, VRF bind - ns-A IP                                          [ OK ]
> TEST: ping local, VRF bind - VRF IP                                           [FAIL]
> TEST: ping local, VRF bind - loopback                                         [ OK ]
> TEST: ping local, device bind - ns-A IP                                       [FAIL]
> TEST: ping local, device bind - VRF IP                                        [ OK ]
> [...]
> 
> SYSCTL: net.ipv4.raw_l3mdev_accept=1
> 
> [...]
> TEST: ping local, VRF bind - ns-A IP                                          [ OK ]
> TEST: ping local, VRF bind - VRF IP                                           [FAIL]
> TEST: ping local, VRF bind - loopback                                         [ OK ]
> TEST: ping local, device bind - ns-A IP                                       [FAIL]
> TEST: ping local, device bind - VRF IP                                        [ OK ]
> [...]
> 
> Yes, just tested, w commit 42510dffd0e2 these are still present
> in fcnal-test.sh output:
> 
> [...]
> TEST: ping local, VRF bind - ns-A IP                                          [ OK ]
> TEST: ping local, VRF bind - VRF IP                                           [FAIL]
> TEST: ping local, VRF bind - loopback                                         [ OK ]
> TEST: ping local, device bind - ns-A IP                                       [FAIL]
> TEST: ping local, device bind - VRF IP                                        [ OK ]
> [...]
> TEST: ping local, VRF bind - ns-A IP                                          [ OK ]
> TEST: ping local, VRF bind - VRF IP                                           [FAIL]
> TEST: ping local, VRF bind - loopback                                         [ OK ]
> TEST: ping local, device bind - ns-A IP                                       [FAIL]
> TEST: ping local, device bind - VRF IP                                        [ OK ]
> [...]

I have the same failures here. They don't seem to be recent.
I'll take a look.

> I have attached the config used and lshw.
> 
> Best regards,
> Mirsad




