Return-Path: <netdev+bounces-3856-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 93EC17092C2
	for <lists+netdev@lfdr.de>; Fri, 19 May 2023 11:12:30 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 3EB071C21249
	for <lists+netdev@lfdr.de>; Fri, 19 May 2023 09:12:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C96D9611C;
	Fri, 19 May 2023 09:12:26 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AADD1611F
	for <netdev@vger.kernel.org>; Fri, 19 May 2023 09:12:26 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED9A61991
	for <netdev@vger.kernel.org>; Fri, 19 May 2023 02:11:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1684487481;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=+teNjF69Y29Ygdy5WrJuQkxdx5o/fSnPp6iTwvYQX4k=;
	b=jTWm2NqveWmagmWbcHprPWq2gRatxyMfQaApUerUf21YoZkgqO16FUm1nJl+uPMHAIM9EI
	tktickP9fp2EU6COYWSZdLq+5XmjCcZ2KUpsE2iv/hPmptjZTVF5xwiW5PHaUu87xqnTBg
	S9z8C3HKeNzvfpSwsnZLowH929Kd0f8=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-375--ookYJ0YN0ecLyuM-vrFfA-1; Fri, 19 May 2023 05:11:18 -0400
X-MC-Unique: -ookYJ0YN0ecLyuM-vrFfA-1
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-30940b01998so1155422f8f.3
        for <netdev@vger.kernel.org>; Fri, 19 May 2023 02:11:18 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684487477; x=1687079477;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+teNjF69Y29Ygdy5WrJuQkxdx5o/fSnPp6iTwvYQX4k=;
        b=g4HSMhD+5AW+kIBS/l6XxW9tLTFN88CfF8G4hjZvGuUlt5ctvLxmjNUTftnUr/HGRQ
         h8Yd7gM9h8u4cImsb6Y4ATlo3vuhN2HVGZ+nbxqYlnZinGtHFRgCqoBF1PbEpkxsAURl
         Xy+LYeoNxqd3vkG85T9FAVC/5L92qdbzqRPRMulaJD05QG4G0DhRr8xEdWHMViODCx+q
         oLOFUQqw8NDQo9ePfsxgKwYPvn0Sa7nxO69nlVBkhv+2ysRoruFo4HQPO5+n2IQp2xdl
         YB9JL5Cu41K2VMmnMpDlsvJpj4NKZZFyZ7J2CKRjCviILRQNf4pxnQQOyLUgPWnOPNNL
         jVIg==
X-Gm-Message-State: AC+VfDxknw/Mx5wKiVRQCO60g+5fV07CIHO6vbd5MRQjWbY7qed90IWa
	RVZyM+8nXfM+tdksRSTfHOdjN5OTkGE0ny/GjA7p41iWW4AKHpATj3TOWGMcmhpy/f7QRcMkNB2
	pk+bM9SJXX7xoqivw
X-Received: by 2002:a5d:4811:0:b0:309:2e6e:78e1 with SMTP id l17-20020a5d4811000000b003092e6e78e1mr1268088wrq.49.1684487477655;
        Fri, 19 May 2023 02:11:17 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ5c3+iDtzUlAHD03stDk1RhWmj2g6ar1p6AUFBotneEdOqzjt9LROlbIwkJ+v9psR8V4PcKDg==
X-Received: by 2002:a5d:4811:0:b0:309:2e6e:78e1 with SMTP id l17-20020a5d4811000000b003092e6e78e1mr1268060wrq.49.1684487477338;
        Fri, 19 May 2023 02:11:17 -0700 (PDT)
Received: from localhost ([37.163.18.47])
        by smtp.gmail.com with ESMTPSA id d18-20020a5d5392000000b00307bbbecd29sm4652452wrv.62.2023.05.19.02.11.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 19 May 2023 02:11:16 -0700 (PDT)
Date: Fri, 19 May 2023 11:11:12 +0200
From: Andrea Claudi <aclaudi@redhat.com>
To: Vladimir Nikishkin <vladimir@nikishkin.pw>
Cc: Stephen Hemminger <stephen@networkplumber.org>, netdev@vger.kernel.org,
	davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
	pabeni@redhat.com, eng.alaamohamedsoliman.am@gmail.com,
	gnault@redhat.com, razor@blackwall.org, idosch@nvidia.com,
	liuhangbin@gmail.com, eyal.birger@gmail.com, jtoppins@redhat.com
Subject: Re: [PATCH iproute2-next v4] ip-link: add support for nolocalbypass
 in vxlan
Message-ID: <ZGc9MHUkZ7nS7q+o@renaissance-vector>
References: <20230518134601.17873-1-vladimir@nikishkin.pw>
 <20230518084908.7c0e14d4@hermes.local>
 <87cz2xt1rb.fsf@laptop.lockywolf.net>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87cz2xt1rb.fsf@laptop.lockywolf.net>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Fri, May 19, 2023 at 11:50:03AM +0800, Vladimir Nikishkin wrote:
> 
> Stephen Hemminger <stephen@networkplumber.org> writes:
> 
> > On Thu, 18 May 2023 21:46:01 +0800
> > Vladimir Nikishkin <vladimir@nikishkin.pw> wrote:
> >
> >> +	if (tb[IFLA_VXLAN_LOCALBYPASS]) {
> >> +		__u8 localbypass = rta_getattr_u8(tb[IFLA_VXLAN_LOCALBYPASS]);
> >> +
> >> +		print_bool(PRINT_JSON, "localbypass", NULL, localbypass);
> >> +		if (localbypass) {
> >> +			print_string(PRINT_FP, NULL, "localbypass ", NULL);
> >> +		} else {
> >> +			print_string(PRINT_FP, NULL, "nolocalbypass ", NULL);
> >> +		}
> >> +	}
> >
> > You don't have to print anything if nolocalbypass.  Use presence as
> > a boolean in JSON.
> >
> > I.e.
> > 	if (tb[IFLA_VXLAN_LOCALBYPASS] &&
> > 	   rta_getattr_u8(tb[IFLA_VXLAN_LOCALBYPASS])) {
> > 		print_bool(PRINT_ANY, "localbypass", "localbypass", true);
> > 	}
> >
> > That is what other options do.
> > Follows the best practices for changes to existing programs: your
> > new feature should look like all the others.
> 
> Sorry, I do not understand. I intended to do exactly that, and I copied
> and adjusted for the option name the code currently used for the
> "udpcsum" option. Which is exactly
> 
> 		if (is_json_context()) {
> 			print_bool(PRINT_ANY, "udp_csum", NULL, udp_csum);
> 		} else {
> 			if (!udp_csum)
> 				fputs("no", f);
> 			fputs("udpcsum ", f);
> 		}
> I just replaced that option name with [no]localbypass. Fairly
> straightforward, prints noudpcsum or udpcsum. Later Andrea C
> 
> Then Andrea Claudi suggested that print_bool knows about the json
> context itself, so the outer check is not needed, so I removed that.
> But the "model option" I used (really the simplest one), does have
> output both when set to true, and when set to false. I have neither an
> opinion on this nor an understanding what is better for scripting. But I
> do not understand the suggestion "do like the other options do", when
> seemingly, other options do what I suggest in the first place.
>

If I get Stephen corretly, he is simply suggesting that printing
"nolocalbypass" is unnecessary. If you find don't find "localbypass" in
the output, you know it's not enabled.

Unfortunately iplink_vxlan does not work according to this logic, as you
are pointing out, but there are several places where this happens, like
link_gre6.c:543. So you can do that for "localbypass" here.

Fixing old options, on the other hand, is not easy, as we may end up
breaking user scripts relying on "no<whatever>" option. I can work on a
patch for that, but we probably need some kind of deprecation warning to
users.

Stephen, what do you think?


