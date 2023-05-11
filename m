Return-Path: <netdev+bounces-1893-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 447496FF689
	for <lists+netdev@lfdr.de>; Thu, 11 May 2023 17:57:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A2C5A281869
	for <lists+netdev@lfdr.de>; Thu, 11 May 2023 15:57:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3427C653;
	Thu, 11 May 2023 15:57:12 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 234EC629
	for <netdev@vger.kernel.org>; Thu, 11 May 2023 15:57:12 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C9E9BD
	for <netdev@vger.kernel.org>; Thu, 11 May 2023 08:57:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1683820629;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=ypVRhqwdYqlWgySHpflCVTT3KZtpavKvai+o2QPpjPk=;
	b=JlHKpJN38IrjrfAIjJtJEfPDR49u3g4PwMWhIPnxe3Dkq2E+diQq+DMv5wsCwPBw4B/ed2
	LmnnfNWPIMpoFaR4bbbsRg4UEXhMfHm3NUc9nA1Qi/EbJ3Gw+pj/gORso6fL3pVXrCrblJ
	uFTh3GdZQW4UZXSRLlWmwzD+ZoDfFM4=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-2-aIvkq8k-NYCCAsPpSgBmVA-1; Thu, 11 May 2023 11:56:03 -0400
X-MC-Unique: aIvkq8k-NYCCAsPpSgBmVA-1
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-3f315735edeso190651795e9.1
        for <netdev@vger.kernel.org>; Thu, 11 May 2023 08:56:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683820562; x=1686412562;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ypVRhqwdYqlWgySHpflCVTT3KZtpavKvai+o2QPpjPk=;
        b=WrRIo3HlZ/O4mBG3sfGhjqsrhJpH+pAfax6dCp8FudWXowi4a4h5OW/KRNwp5u90Ml
         X2DNsVBx8l0ww90u4OiAhp+1BPZ6AG6BXirojxW2ofCbIxjJmts+PppIJhQ1EjlbZPdv
         Bornikctaho0ETFcp7tdgjHPOvgkIovvTndJBHInMBMxAR/QGwGsDMHV2oXg2uzc9uJA
         4IdnR8aM0QwtH7meMW3LP6qpwokRr66dgtPEnySG6MTGBWLDfD+d8Ym/Y7MGDpitx0HD
         zyv5GOIlVnFoAhHSBMFNx170Fuzh/In8ctyRmayJOjWVle/ZHvAzEHLZCC4ISm5/gNwL
         rxdw==
X-Gm-Message-State: AC+VfDwU6f/B/trW+VemUw36IxwKHSa/48EAi6no4iAgc0nSoTIcZrbp
	c650frNymMKV2MTzCruFgWrta8StSJ1dWv6SiRwqqI8CBD6Adsp+pzEb6+Wyn1SdzWvMPXGsQYB
	DgIndDz99qZYob94+
X-Received: by 2002:a7b:cb93:0:b0:3f4:2374:3511 with SMTP id m19-20020a7bcb93000000b003f423743511mr11563528wmi.10.1683820562125;
        Thu, 11 May 2023 08:56:02 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ5a6+sU+eY2NGW+rhF1/KR0ePYXA1XvygVNVDjWPZOWgG4ih6GBKr9CGtHHO3al540KJSfX8g==
X-Received: by 2002:a7b:cb93:0:b0:3f4:2374:3511 with SMTP id m19-20020a7bcb93000000b003f423743511mr11563512wmi.10.1683820561801;
        Thu, 11 May 2023 08:56:01 -0700 (PDT)
Received: from debian (2a01cb058918ce00af30fd5ba5292148.ipv6.abo.wanadoo.fr. [2a01:cb05:8918:ce00:af30:fd5b:a529:2148])
        by smtp.gmail.com with ESMTPSA id l11-20020a05600c1d0b00b003f1978bbcd6sm12374273wms.3.2023.05.11.08.56.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 May 2023 08:56:01 -0700 (PDT)
Date: Thu, 11 May 2023 17:55:59 +0200
From: Guillaume Nault <gnault@redhat.com>
To: David Ahern <dsahern@kernel.org>
Cc: David Miller <davem@davemloft.net>, Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>, Eric Dumazet <edumazet@google.com>,
	netdev@vger.kernel.org
Subject: Re: [PATCH v2 net-next 3/4] selftests: fcnal: Test SO_DONTROUTE on
 UDP sockets.
Message-ID: <ZF0QDwICQk9JK90Z@debian>
References: <cover.1683814269.git.gnault@redhat.com>
 <dbc62d5ea038e0fc7b0a59cedc1213d3ae6a59fe.1683814269.git.gnault@redhat.com>
 <40497aaa-ac1e-32c3-16ba-f61b22013e28@kernel.org>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <40497aaa-ac1e-32c3-16ba-f61b22013e28@kernel.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Thu, May 11, 2023 at 09:03:44AM -0600, David Ahern wrote:
> On 5/11/23 8:39 AM, Guillaume Nault wrote:
> > Use nettest --client-dontroute to test the kernel behaviour with UDP
> > sockets having the SO_DONTROUTE option. Sending packets to a neighbour
> > (on link) host, should work. When the host is behind a router, sending
> > should fail.
> > 
> > Signed-off-by: Guillaume Nault <gnault@redhat.com>
> > ---
> >  v2: Use 'nettest -B' instead of invoking two nettest instances for
> >      client and server.
> > 
> >  tools/testing/selftests/net/fcnal-test.sh | 17 +++++++++++++++++
> >  1 file changed, 17 insertions(+)
> > 
> > diff --git a/tools/testing/selftests/net/fcnal-test.sh b/tools/testing/selftests/net/fcnal-test.sh
> > index 3a1f3051321f..08b4b96cbd63 100755
> > --- a/tools/testing/selftests/net/fcnal-test.sh
> > +++ b/tools/testing/selftests/net/fcnal-test.sh
> > @@ -1641,6 +1641,23 @@ ipv4_udp_novrf()
> >  	log_start
> >  	run_cmd nettest -D -d ${NSA_DEV} -r ${a}
> >  	log_test_addr ${a} $? 2 "No server, device client, local conn"
> > +
> > +	#
> > +	# Link local connection tests (SO_DONTROUTE).
> > +	# Connections should succeed only when the remote IP address is
> > +	# on link (doesn't need to be routed through a gateway).
> > +	#
> > +
> > +	a=${NSB_IP}
> > +	log_start
> > +	do_run_cmd nettest -B -D -N "${NSA}" -O "${NSB}" -r ${a} --client-dontroute
> > +	log_test_addr ${a} $? 0 "SO_DONTROUTE client"
> > +
> > +	a=${NSB_LO_IP}
> > +	log_start
> > +	show_hint "Should fail 'Network is unreachable' since server is not on link"
> > +	do_run_cmd nettest -B -D -N "${NSA}" -O "${NSB}" -r ${a} --client-dontroute
> > +	log_test_addr ${a} $? 1 "SO_DONTROUTE client"
> >  }
> >  
> >  ipv4_udp_vrf()
> 
> Reviewed-by: David Ahern <dsahern@kernel.org>
> 
> Have you looked at test cases with VRF - both UDP and TCP?

I haven't looked at the VRF cases. I don't really see what kernel path
I could cover that isn't already covered by the non-vrf cases:

  * From ns-B point of view, VRF_IP is just a routed IP, like NSA_LO_IP.
    So testing SO_DONTROUTE on a socket belonging to ns-B wouldn't
    cover any new kernel code path.

  * From ns-A point of view, the routing table content is the same. It
    just has to use table $VRF_TABLE instead of main. So the test would
    just ensure that we jump to the right routing table, something that
    SO_DONTROUTE doesn't influences. But the route lookup itself is
    actually the same as for the non-vrf test (just using a different
    table). Therefore I feel that adding vrf tests for SO_DONTROUTE
    wouldn't bring much value.

But I may very well be missing some interesting points. If you have any
VRF test case in mind, I can add them.


