Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4EDEA7B4B4
	for <lists+netdev@lfdr.de>; Tue, 30 Jul 2019 23:00:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727477AbfG3VA4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Jul 2019 17:00:56 -0400
Received: from mail-qk1-f196.google.com ([209.85.222.196]:34703 "EHLO
        mail-qk1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726078AbfG3VA4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Jul 2019 17:00:56 -0400
Received: by mail-qk1-f196.google.com with SMTP id t8so47605589qkt.1
        for <netdev@vger.kernel.org>; Tue, 30 Jul 2019 14:00:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=UZVLH+YJQnTToBfxuUOLKOpxR4PzlV9zcM3XVpn0bZQ=;
        b=mcws10hDVVGHgXmeHOx3+gacFHiyt6qxQmtnMf9VKy9x2aso89EW+Iz5QyvBfsb5k1
         mYAFkhQqw6yWf+1/iIzcSs2OgAr0QWe+wVrEtAFBUilZNASolnS6iRHqCGouKKTxI2pb
         tbupWsSD/Tc8IocksoN9BnMfFPsJswJhUvq0DvlfVplsZKLM0664vDVsqqjchQGU1OnD
         Vmcd0hqOSEzOcAc6AyUEKp+4VSBl+vtPQNYbD9RnLXrL+N397Jh9IxFwt+Y155WBnSZm
         YBsmWTIg7WDc3KKxVG9iLH62A88G7F44bLEDorf4En3SYksZTTcX8R4dfbxSdHLuL6gx
         /7tQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=UZVLH+YJQnTToBfxuUOLKOpxR4PzlV9zcM3XVpn0bZQ=;
        b=J8Nw11Trk7U8SyHdcZeFAUYhi6eiO+M35hDTei/w1Up9nw6WYdf8iousWx0j+UDXRK
         nBF5BPtBSU5UbeXYs9dfNSnTwB5gv0mqe6bA9B5BxhDmuowoxeAplT4QclD/Vx271As9
         STG119vtPRkDrW/dIKRCpZPpsPQbspvyORd8oSirnqxVz4+yiZruRkscsYfS6aJE+RX/
         raxkoblXnzJ5H5df4lgW4oimwhPO1+np0nbGKn2ktm7kzJ04ZMLEXY+PaJT/gG2GYmfm
         uQRiy42WbA7mZx0uAG/wmD4YXnkOMXmcTD3aGykgukBNaXTazCqJjKVS8Cia8KB5y2sx
         sY4w==
X-Gm-Message-State: APjAAAXqNCLr2BhABJk5DAWOLhZUfh+5/KQDQ7FD8arkiaTHSMZk3UeA
        masKCCzfhnftXc4gUbs4HtxO+A==
X-Google-Smtp-Source: APXvYqy6uA8j/TiODO9MQFYAXMgFVAJWCFAWDabDRYE1w+HZfeiZDq7OyAAZj3mhuM9beq9rdAK4LQ==
X-Received: by 2002:a37:274a:: with SMTP id n71mr72049172qkn.448.1564520454474;
        Tue, 30 Jul 2019 14:00:54 -0700 (PDT)
Received: from cakuba.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id g10sm27564265qkk.91.2019.07.30.14.00.53
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Tue, 30 Jul 2019 14:00:54 -0700 (PDT)
Date:   Tue, 30 Jul 2019 14:00:40 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Takshak Chahande <ctakshak@fb.com>
Cc:     "alexei.starovoitov@gmail.com" <alexei.starovoitov@gmail.com>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "oss-drivers@netronome.com" <oss-drivers@netronome.com>,
        Kernel Team <Kernel-team@fb.com>,
        Quentin Monnet <quentin.monnet@netronome.com>
Subject: Re: [PATCH bpf-next] tools: bpftool: add support for reporting the
 effective cgroup progs
Message-ID: <20190730140040.7a357b19@cakuba.netronome.com>
In-Reply-To: <20190730180443.GA48276@ctakshak-mbp.dhcp.thefacebook.com>
References: <20190729213538.8960-1-jakub.kicinski@netronome.com>
        <20190730180443.GA48276@ctakshak-mbp.dhcp.thefacebook.com>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 30 Jul 2019 18:04:53 +0000, Takshak Chahande wrote:
> Jakub Kicinski <jakub.kicinski@netronome.com> wrote on Mon [2019-Jul-29 14:35:38 -0700]:
> > @@ -158,20 +161,30 @@ static int show_attached_bpf_progs(int cgroup_fd, enum bpf_attach_type type,
> >  static int do_show(int argc, char **argv)
> >  {
> >  	enum bpf_attach_type type;
> > +	const char *path;
> >  	int cgroup_fd;
> >  	int ret = -1;
> >  
> > -	if (argc < 1) {
> > -		p_err("too few parameters for cgroup show");
> > -		goto exit;
> > -	} else if (argc > 1) {
> > -		p_err("too many parameters for cgroup show");
> > -		goto exit;
> > +	query_flags = 0;
> > +
> > +	if (!REQ_ARGS(1))
> > +		return -1;
> > +	path = GET_ARG();
> > +
> > +	while (argc) {
> > +		if (is_prefix(*argv, "effective")) {
> > +			query_flags |= BPF_F_QUERY_EFFECTIVE;
> > +			NEXT_ARG();
> > +		} else {
> > +			p_err("expected no more arguments, 'effective', got: '%s'?",
> > +			      *argv);
> > +			return -1;
> > +		}
> >  	}  
> This while loop will allow multiple 'effective' keywords in the argument
> unnecessarily. IMO, we should strictly restrict only for single
> occurance of 'effective' word.

It's kind of the way all bpftool works to date :(

But perhaps not checking is worse than inconsistency? Okay, let's fix
this up.

> > -	cgroup_fd = open(argv[0], O_RDONLY);
> > +	cgroup_fd = open(path, O_RDONLY);
> >  	if (cgroup_fd < 0) {
> > -		p_err("can't open cgroup %s", argv[0]);
> > +		p_err("can't open cgroup %s", path);
> >  		goto exit;
> >  	}
> >  
> > @@ -297,23 +310,29 @@ static int do_show_tree(int argc, char **argv)
> >  	char *cgroup_root;
> >  	int ret;
> >  
> > -	switch (argc) {
> > -	case 0:
> > +	query_flags = 0;
> > +
> > +	if (!argc) {
> >  		cgroup_root = find_cgroup_root();
> >  		if (!cgroup_root) {
> >  			p_err("cgroup v2 isn't mounted");
> >  			return -1;
> >  		}
> > -		break;
> > -	case 1:
> > -		cgroup_root = argv[0];
> > -		break;
> > -	default:
> > -		p_err("too many parameters for cgroup tree");
> > -		return -1;
> > +	} else {
> > +		cgroup_root = GET_ARG();
> > +
> > +		while (argc) {
> > +			if (is_prefix(*argv, "effective")) {
> > +				query_flags |= BPF_F_QUERY_EFFECTIVE;
> > +				NEXT_ARG();  
> 
> NEXT_ARG() does update argc value; that means after this outer if/else we need 
> to know how argc has become 0 (through which path) before freeing up `cgroup_root` allocated
> memory later at the end of this function.

Good catch!

> > +			} else {
> > +				p_err("expected no more arguments, 'effective', got: '%s'?",
> > +				      *argv);
> > +				return -1;
> > +			}
> > +		}
> >  	}  
 
> Thanks for the patch. Apart from above two issues, patch looks good.

Thanks for the review.
