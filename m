Return-Path: <netdev+bounces-3953-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 14812709C42
	for <lists+netdev@lfdr.de>; Fri, 19 May 2023 18:19:15 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A4B161C209FD
	for <lists+netdev@lfdr.de>; Fri, 19 May 2023 16:19:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C0B5C11C8D;
	Fri, 19 May 2023 16:19:11 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE88F1118B
	for <netdev@vger.kernel.org>; Fri, 19 May 2023 16:19:11 +0000 (UTC)
Received: from mail-pl1-x62a.google.com (mail-pl1-x62a.google.com [IPv6:2607:f8b0:4864:20::62a])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D5658C9
	for <netdev@vger.kernel.org>; Fri, 19 May 2023 09:19:09 -0700 (PDT)
Received: by mail-pl1-x62a.google.com with SMTP id d9443c01a7336-1ae5dc9eac4so20361185ad.1
        for <netdev@vger.kernel.org>; Fri, 19 May 2023 09:19:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20221208.gappssmtp.com; s=20221208; t=1684513149; x=1687105149;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=6ePbnkU5H7O5eWwE7UkfwLr2kV9ma32OQw9+FSeq4Q4=;
        b=H2E+lxD8nzKOTn0zr9u6WRIr677U7yDlIoJj7KoEt8TtHTGkph32TpvlnQs8ilaOu+
         Q5Jr5wgZAilK8hSVR3xhgTs2cH7FShI6IKTf8nIz1ip1iKEFlgamUYQBvOfAkwkTSzXB
         wdnWJLbzSUC5iqif65UH18bSFRlzj38VfsblaQvTJiOtSzH/EVJzuGd1Qzi7AnIwE/E1
         IlzTxj1WV1DOeS2ZYyDQXU46QFJA66dYRl6AiLQKSEwFDs5ydkQuxD5SiysKU1ifUwEc
         08G2ZvtmskYml/93XRExWCRU4J2dMOLaCP8aVYIILj9KF3P+d+wM4QzRYtjqw+lBU1Hm
         h4xA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684513149; x=1687105149;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=6ePbnkU5H7O5eWwE7UkfwLr2kV9ma32OQw9+FSeq4Q4=;
        b=KBhANScoESIFw+qpGih4FpPiocK/X5D0gUNRRH+hV4ny5ShZe2qSrW4XJliXgS3sl/
         6vqpA6KQOzQVWObiJHeGSZx8m/hijifTfOblDKIjCoTzLmkTfEpNJMbYC4Ivue9VyxBX
         ELfRKYpPUjnn8yrqgkhgVSi+oh28QG3I4aWu0awB2gaMGMJPWBVzoWRxoA1alkYLxU5v
         cqy9XRSVYOd6w/kcoh4KzEyJH30lwpJFWv0k7ZVjAPpxAi+7+EUBcCWZEyBuww7FLZ2i
         wiEhQJyK/vQqk1uokzDCFk/Q1GtJ9d67BS1VcITPk1ZuJrqdxZyiU6MZcGAjCXgFB3BX
         AcLw==
X-Gm-Message-State: AC+VfDxVLaaiU9CPm8Tp3CpKlVtJxrexMfh+/gdWKTh+0QsWs4P5CuUx
	BHSdH1OI8rdZx+Xp3fZSOfBtJw==
X-Google-Smtp-Source: ACHHUZ7vUMdMWLxzcrok+k8do6dt1+iYbHf9t6YW1bidVy00V4oq/Ta14CsQn1PWSzP+F2oRcDPdiQ==
X-Received: by 2002:a17:902:ecc9:b0:1ac:6ef0:a96e with SMTP id a9-20020a170902ecc900b001ac6ef0a96emr3962091plh.31.1684513149326;
        Fri, 19 May 2023 09:19:09 -0700 (PDT)
Received: from hermes.local (204-195-120-218.wavecable.com. [204.195.120.218])
        by smtp.gmail.com with ESMTPSA id d12-20020a170902b70c00b001a1a8e98e93sm3620380pls.287.2023.05.19.09.19.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 19 May 2023 09:19:09 -0700 (PDT)
Date: Fri, 19 May 2023 09:19:07 -0700
From: Stephen Hemminger <stephen@networkplumber.org>
To: Andrea Claudi <aclaudi@redhat.com>
Cc: Vladimir Nikishkin <vladimir@nikishkin.pw>, netdev@vger.kernel.org,
 davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
 pabeni@redhat.com, eng.alaamohamedsoliman.am@gmail.com, gnault@redhat.com,
 razor@blackwall.org, idosch@nvidia.com, liuhangbin@gmail.com,
 eyal.birger@gmail.com, jtoppins@redhat.com
Subject: Re: [PATCH iproute2-next v4] ip-link: add support for nolocalbypass
 in vxlan
Message-ID: <20230519091907.6af1b3b1@hermes.local>
In-Reply-To: <ZGc9MHUkZ7nS7q+o@renaissance-vector>
References: <20230518134601.17873-1-vladimir@nikishkin.pw>
	<20230518084908.7c0e14d4@hermes.local>
	<87cz2xt1rb.fsf@laptop.lockywolf.net>
	<ZGc9MHUkZ7nS7q+o@renaissance-vector>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Fri, 19 May 2023 11:11:12 +0200
Andrea Claudi <aclaudi@redhat.com> wrote:

> On Fri, May 19, 2023 at 11:50:03AM +0800, Vladimir Nikishkin wrote:
> > 
> > Stephen Hemminger <stephen@networkplumber.org> writes:
> >   
> > > On Thu, 18 May 2023 21:46:01 +0800
> > > Vladimir Nikishkin <vladimir@nikishkin.pw> wrote:
> > >  
> > >> +	if (tb[IFLA_VXLAN_LOCALBYPASS]) {
> > >> +		__u8 localbypass = rta_getattr_u8(tb[IFLA_VXLAN_LOCALBYPASS]);
> > >> +
> > >> +		print_bool(PRINT_JSON, "localbypass", NULL, localbypass);
> > >> +		if (localbypass) {
> > >> +			print_string(PRINT_FP, NULL, "localbypass ", NULL);
> > >> +		} else {
> > >> +			print_string(PRINT_FP, NULL, "nolocalbypass ", NULL);
> > >> +		}
> > >> +	}  
> > >
> > > You don't have to print anything if nolocalbypass.  Use presence as
> > > a boolean in JSON.
> > >
> > > I.e.
> > > 	if (tb[IFLA_VXLAN_LOCALBYPASS] &&
> > > 	   rta_getattr_u8(tb[IFLA_VXLAN_LOCALBYPASS])) {
> > > 		print_bool(PRINT_ANY, "localbypass", "localbypass", true);
> > > 	}
> > >
> > > That is what other options do.
> > > Follows the best practices for changes to existing programs: your
> > > new feature should look like all the others.  
> > 
> > Sorry, I do not understand. I intended to do exactly that, and I copied
> > and adjusted for the option name the code currently used for the
> > "udpcsum" option. Which is exactly
> > 
> > 		if (is_json_context()) {
> > 			print_bool(PRINT_ANY, "udp_csum", NULL, udp_csum);
> > 		} else {
> > 			if (!udp_csum)
> > 				fputs("no", f);
> > 			fputs("udpcsum ", f);
> > 		}
> > I just replaced that option name with [no]localbypass. Fairly
> > straightforward, prints noudpcsum or udpcsum. Later Andrea C
> > 
> > Then Andrea Claudi suggested that print_bool knows about the json
> > context itself, so the outer check is not needed, so I removed that.
> > But the "model option" I used (really the simplest one), does have
> > output both when set to true, and when set to false. I have neither an
> > opinion on this nor an understanding what is better for scripting. But I
> > do not understand the suggestion "do like the other options do", when
> > seemingly, other options do what I suggest in the first place.
> >  
> 
> If I get Stephen corretly, he is simply suggesting that printing
> "nolocalbypass" is unnecessary. If you find don't find "localbypass" in
> the output, you know it's not enabled.
> 
> Unfortunately iplink_vxlan does not work according to this logic, as you
> are pointing out, but there are several places where this happens, like
> link_gre6.c:543. So you can do that for "localbypass" here.
> 
> Fixing old options, on the other hand, is not easy, as we may end up
> breaking user scripts relying on "no<whatever>" option. I can work on a
> patch for that, but we probably need some kind of deprecation warning to
> users.
> 
> Stephen, what do you think?
> 

Scripts parsing non-json output are fragile. There was never a hard
guarantee that non-json output was stable.


I was looking at the existing vxlan_print_opts() and it already does
this for several options.

static void vxlan_print_opt(struct link_util *lu, FILE *f, struct rtattr *tb[])
{
...

	if (tb[IFLA_VXLAN_COLLECT_METADATA] &&
	    rta_getattr_u8(tb[IFLA_VXLAN_COLLECT_METADATA])) {
		print_bool(PRINT_ANY, "external", "external ", true);
	}

	if (tb[IFLA_VXLAN_VNIFILTER] &&
	    rta_getattr_u8(tb[IFLA_VXLAN_VNIFILTER])) {
		print_bool(PRINT_ANY, "vnifilter", "vnifilter", true);
	}


