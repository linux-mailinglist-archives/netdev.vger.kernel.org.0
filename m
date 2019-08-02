Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DDD2B801F2
	for <lists+netdev@lfdr.de>; Fri,  2 Aug 2019 22:48:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729659AbfHBUr6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Aug 2019 16:47:58 -0400
Received: from mail-qk1-f196.google.com ([209.85.222.196]:46694 "EHLO
        mail-qk1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726999AbfHBUr6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Aug 2019 16:47:58 -0400
Received: by mail-qk1-f196.google.com with SMTP id r4so55771893qkm.13
        for <netdev@vger.kernel.org>; Fri, 02 Aug 2019 13:47:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=l2xTmeRtEZTPMASSyFs2258/OlcrW4XV8UWTXw6h5+k=;
        b=0cZkj17p28vciM09SU3936/Q8DZdrQt6nHUUyhVZEvE5mPkdVaT3Bxk0GgtLCHVqUq
         J2zV2mcLdpHFem6LH415jDwmnqzUaPdUUfP1aSNzw1LsMvChYxCJ59CsKbw5eQkFfPr0
         pjsyrJYLIwhMGknijfLBcroM9GFWGqdBaPhL+qpPNt9mbShDS92VjCMfNGjW32B8bYi5
         NYtyRME50oGbbNNv5oqoTQtDkySWVMlyDcU81B491kQ5JY2nYV3lR90CV9MC0X1dUPF4
         WblnCHJPAtrr1rY1btjs6xomaxQ+Hfx3a1IOa0LLS6Hd7A7IL/BXXS9Ax66n3YNQuH4T
         kVKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=l2xTmeRtEZTPMASSyFs2258/OlcrW4XV8UWTXw6h5+k=;
        b=s0FEMc+KOkP4eCXeiWkpFTsP1r2JbC4Hf7hI4Gic8cjTdj3AihVibJWtMa79/tdDtB
         RldDHxBGpcSslI6/GCUB1Va7F6PfMV0pviYM12TEd1msqZ/HQiSfiiHzCtfIX/QdI/2N
         YFv6si/GQTaJVcgfcwAMlVIXcOCmO2uEdQyo9fkmrssdRorifVuPC9F/mvJJEWYFCLYf
         1Mfz3h5c5K/vIjQcnc7Sl37cdkAK2Z01f8S4vchJtV1iChPHWaEyTn1+DEVxLvl5OGvK
         QG5Vmgo+jbIa38ehh8xnhUTIWc0fArOpDRkJ9I4TyV4CVmx83Kt4brxHCa6qI+NgjPdX
         mHZA==
X-Gm-Message-State: APjAAAVix6eQE7/4C2QNSW7ygUEQzC8Ql3m2H0w8a0gENT/1thf0LDmt
        jDXUfPD2VCyPma5I3zTi4x/U4w==
X-Google-Smtp-Source: APXvYqyGPVP4pYNHM6j3aUEwLbB+3r04zY+QW4Rhajmc+Oriuf8YEYDgH6W+BTNlLSFJ3Q+vhcav0g==
X-Received: by 2002:a37:7cc5:: with SMTP id x188mr90076102qkc.456.1564778877066;
        Fri, 02 Aug 2019 13:47:57 -0700 (PDT)
Received: from cakuba.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id g2sm32862012qkf.32.2019.08.02.13.47.55
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Fri, 02 Aug 2019 13:47:56 -0700 (PDT)
Date:   Fri, 2 Aug 2019 13:47:38 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org, davem@davemloft.net,
        netdev@vger.kernel.org, marcelo.leitner@gmail.com,
        jiri@resnulli.us, wenxu@ucloud.cn, saeedm@mellanox.com,
        paulb@mellanox.com, gerlitz.or@gmail.com
Subject: Re: [PATCH net 0/2] flow_offload hardware priority fixes
Message-ID: <20190802134738.328691b4@cakuba.netronome.com>
In-Reply-To: <20190802110023.udfcxowe3vmihduq@salvia>
References: <20190801112817.24976-1-pablo@netfilter.org>
        <20190801172014.314a9d01@cakuba.netronome.com>
        <20190802110023.udfcxowe3vmihduq@salvia>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 2 Aug 2019 13:00:23 +0200, Pablo Neira Ayuso wrote:
> Hi Jakub,
>=20
> If the user specifies 'pref' in the new rule, then tc checks if there
> is a tcf_proto object that matches this priority. If the tcf_proto
> object does not exist, tc creates a tcf_proto object and it adds the
> new rule to this tcf_proto.
>=20
> In cls_flower, each tcf_proto only stores one single rule, so if the
> user tries to add another rule with the same 'pref', cls_flower
> returns EEXIST.

=F0=9F=98=B3=20

So you're saying this doesn't work?

ip link add type dummy
tc qdisc add dev dummy0 clsact
tc filter add dev dummy0 ingress protocol ipv6 prio 123 flower src_ip 1111:=
:1 action drop
tc filter add dev dummy0 ingress protocol ipv6 prio 123 flower src_ip 1111:=
:2 action drop
tc filter add dev dummy0 ingress protocol ipv6 prio 123 flower src_ip 1111:=
:3 action drop
tc filter add dev dummy0 ingress protocol ipv6 prio 123 flower src_ip 1111:=
:4 action drop
tc filter add dev dummy0 ingress protocol ipv6 prio 123 flower src_ip 1111:=
:5 action drop

tc filter show dev dummy0 ingress

filter protocol ipv6 pref 123 flower chain 0=20
filter protocol ipv6 pref 123 flower chain 0 handle 0x1=20
  eth_type ipv6
  src_ip 1111::1
  not_in_hw
	action order 1: gact action drop
	 random type none pass val 0
	 index 1 ref 1 bind 1

filter protocol ipv6 pref 123 flower chain 0 handle 0x2=20
  eth_type ipv6
  src_ip 1111::2
  not_in_hw
	action order 1: gact action drop
	 random type none pass val 0
	 index 2 ref 1 bind 1

filter protocol ipv6 pref 123 flower chain 0 handle 0x3=20
  eth_type ipv6
  src_ip 1111::3
  not_in_hw
	action order 1: gact action drop
	 random type none pass val 0
	 index 3 ref 1 bind 1

filter protocol ipv6 pref 123 flower chain 0 handle 0x4=20
  eth_type ipv6
  src_ip 1111::4
  not_in_hw
	action order 1: gact action drop
	 random type none pass val 0
	 index 4 ref 1 bind 1

filter protocol ipv6 pref 123 flower chain 0 handle 0x5=20
  eth_type ipv6
  src_ip 1111::5
  not_in_hw
	action order 1: gact action drop
	 random type none pass val 0
	 index 5 ref 1 bind 1


> I'll prepare a new patchset not to map the priority to the netfilter
> basechain priority, instead the rule priority will be internally
> allocated for each new rule.

In which you're adding fake priorities to rules, AFAICT,=20
and continue to baffle me.
