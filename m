Return-Path: <netdev+bounces-1280-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E19926FD2C4
	for <lists+netdev@lfdr.de>; Wed, 10 May 2023 00:36:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 2D1D5281422
	for <lists+netdev@lfdr.de>; Tue,  9 May 2023 22:36:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 93548F9DE;
	Tue,  9 May 2023 22:36:37 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 866A519937
	for <netdev@vger.kernel.org>; Tue,  9 May 2023 22:36:37 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E6982D4A
	for <netdev@vger.kernel.org>; Tue,  9 May 2023 15:36:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1683671782;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=IaxjeQx1aQ5zZuJTHWwe4xdYYPSpt73Wq+wBrfpBzqE=;
	b=LPhpzFM+0csajoeKBPS6Sk+SCfRynjlVQ8iH2fqhAWuf+TrxSGnhm00WxI+8gAYnQL8/gH
	HPoGDj+QgEi5PUhcQuOBphq/D+fpmPG/cUgzHnpKhwsJIDrsvw6iZiQk1+YjrrP8F5jTWG
	eEc77m3Hut4x1JyVbA48b6FJri2RPOs=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-138-7ldO92FJNFS7uc0LBJ2yoQ-1; Tue, 09 May 2023 18:36:21 -0400
X-MC-Unique: 7ldO92FJNFS7uc0LBJ2yoQ-1
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-3f433a2308bso10107625e9.0
        for <netdev@vger.kernel.org>; Tue, 09 May 2023 15:36:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683671779; x=1686263779;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=IaxjeQx1aQ5zZuJTHWwe4xdYYPSpt73Wq+wBrfpBzqE=;
        b=E4DbM6ut0TChsIHSP9+q3xHX4XakIPmwpO1UW/cSzGZ/NEQFxpRj/VvMOmHbqFwMg6
         /o8eA5IlhXCBQB0a0lWbfWmJAsTaY6k6qu2WGx8bU+WCEbd4Scj+95BWVjYcIbTwwE2F
         NfaKFU1adRmPozNNtSl+pDQwkDh8fu2I9ljHk9azj92UpeP2yAVleAO5yFIaxpsu5C01
         Cl+rsyDmuHuRZni9qhQFkqLj1C1C1SPIH33UvbrKaA05yDslL0lUh40qj1VkGTIiWpuk
         44K8lmmSIl/LmvN8mUOZ/xuQE0Oy+mh0ptplWvP1JJeMW8YYMuR6qjRP93qBpsYzWlf1
         bRWQ==
X-Gm-Message-State: AC+VfDw3KQ9tePxDTZMivFM0iw2UtYB7oeDHC8pvnqjNIqlZL4WA3ci3
	jBGm8av1hG+jpKffJagiEglDZf/A1TQY4466i+Rzd1uVTa10G93pInUBlZoBWApzxGAocCt38XL
	wjTr1KOrOGq5rdo54
X-Received: by 2002:adf:f189:0:b0:306:45ef:9935 with SMTP id h9-20020adff189000000b0030645ef9935mr14192568wro.13.1683671779116;
        Tue, 09 May 2023 15:36:19 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ4Xa3r1RcngcBkN+BdHuaQldghW3gS3LoddvmmaotQFAKrjrHhfivqwnwd6x40NFCFXC9Cg2g==
X-Received: by 2002:adf:f189:0:b0:306:45ef:9935 with SMTP id h9-20020adff189000000b0030645ef9935mr14192554wro.13.1683671778773;
        Tue, 09 May 2023 15:36:18 -0700 (PDT)
Received: from debian (2a01cb058918ce005a3b5dcb9dbff7d2.ipv6.abo.wanadoo.fr. [2a01:cb05:8918:ce00:5a3b:5dcb:9dbf:f7d2])
        by smtp.gmail.com with ESMTPSA id a11-20020a5d508b000000b00307a86a4bcesm2211757wrt.35.2023.05.09.15.36.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 May 2023 15:36:18 -0700 (PDT)
Date: Wed, 10 May 2023 00:36:16 +0200
From: Guillaume Nault <gnault@redhat.com>
To: David Ahern <dsahern@kernel.org>
Cc: David Miller <davem@davemloft.net>, Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>, Eric Dumazet <edumazet@google.com>,
	netdev@vger.kernel.org
Subject: Re: [PATCH net-next 2/4] selftests: fcnal: Test SO_DONTROUTE on TCP
 sockets.
Message-ID: <ZFrK4CXsCrfmBG7T@debian>
References: <cover.1683626501.git.gnault@redhat.com>
 <ac92940c6d2c17c7c8d476428cfa94c4ffa6bd8b.1683626501.git.gnault@redhat.com>
 <20230509153246.GA26485@u2004-local>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230509153246.GA26485@u2004-local>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Tue, May 09, 2023 at 09:32:46AM -0600, David Ahern wrote:
> On Tue, May 09, 2023 at 02:02:37PM +0200, Guillaume Nault wrote:
> > diff --git a/tools/testing/selftests/net/fcnal-test.sh b/tools/testing/selftests/net/fcnal-test.sh
> > index 21ca91473c09..1f8939fbb021 100755
> > --- a/tools/testing/selftests/net/fcnal-test.sh
> > +++ b/tools/testing/selftests/net/fcnal-test.sh
> > @@ -1098,6 +1098,73 @@ test_ipv4_md5_vrf__global_server__bind_ifindex0()
> >  	set_sysctl net.ipv4.tcp_l3mdev_accept="$old_tcp_l3mdev_accept"
> >  }
> >  
> > +ipv4_tcp_dontroute()
> > +{
> > +	local syncookies=$1
> > +	local nsa_syncookies
> > +	local nsb_syncookies
> > +	local a
> > +
> > +	#
> > +	# Link local connection tests (SO_DONTROUTE).
> > +	# Connections should succeed only when the remote IP address is
> > +	# on link (doesn't need to be routed through a gateway).
> > +	#
> > +
> > +	nsa_syncookies=$(ip netns exec "${NSA}" sysctl -n net.ipv4.tcp_syncookies)
> > +	nsb_syncookies=$(ip netns exec "${NSB}" sysctl -n net.ipv4.tcp_syncookies)
> > +	ip netns exec "${NSA}" sysctl -wq net.ipv4.tcp_syncookies=${syncookies}
> > +	ip netns exec "${NSB}" sysctl -wq net.ipv4.tcp_syncookies=${syncookies}
> > +
> > +	# Test with eth1 address (on link).
> > +
> > +	a=${NSB_IP}
> > +	log_start
> > +	run_cmd_nsb nettest -s &
> > +	sleep 1
> 
> rather than propagate the sleep for new tests, you try adding these
> tests using a single nettest instance that takes both server and client
> arguments and does the netns switch internally.

Okay. That also means adding more options to nettest, to independently
set SO_DONTROUTE on the server or on the client. We're getting short of
one letter options, so I'll probably use long ones.


