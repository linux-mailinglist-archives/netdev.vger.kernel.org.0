Return-Path: <netdev+bounces-5821-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id BDCD1712FD2
	for <lists+netdev@lfdr.de>; Sat, 27 May 2023 00:17:45 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 7B4CE1C21159
	for <lists+netdev@lfdr.de>; Fri, 26 May 2023 22:17:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D8D442A9F9;
	Fri, 26 May 2023 22:17:41 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C35C62A9F7
	for <netdev@vger.kernel.org>; Fri, 26 May 2023 22:17:41 +0000 (UTC)
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F160E42
	for <netdev@vger.kernel.org>; Fri, 26 May 2023 15:17:39 -0700 (PDT)
Received: by mail-pj1-x1031.google.com with SMTP id 98e67ed59e1d1-2535edae73cso1295768a91.2
        for <netdev@vger.kernel.org>; Fri, 26 May 2023 15:17:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20221208.gappssmtp.com; s=20221208; t=1685139458; x=1687731458;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=LqGHP0zjodTudspXiFPL/eN6nsMCOUspdyEhcIW75so=;
        b=lqV4c3FD0XeJDx+j5Hb4IVg+21Odbtkcg4ifjfdaZGbAzkaeOU4r4wPvfKgtm7V0s0
         q5/bZYLl+37CjJdgG8++tKi72LO3PzlcRti/GrRbeyNAiLJkubtFZJj/staQgNtebEJ6
         uvDTEKP8gtlKsSBsp7uzx8lj4D8WLKR2woUr9x4K7XTAq1HTK14hP/tTW0koxDbqwLeH
         4ImJnEwqZVol1UCyvt7dAjowN2ugRQOwtpr03OBPn+a8fUcjUCoq15k7BuV2oMOCLekz
         eYvI4xOY2Xd7dXlSzv6H+U5YNSF2bipmxmcVKH70/4GGsz/5E2c2OiPZGl6QqQI+/fek
         J6XQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685139458; x=1687731458;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=LqGHP0zjodTudspXiFPL/eN6nsMCOUspdyEhcIW75so=;
        b=MFvmDhNQ/pvNl0YQJ21VqDBisSCjAQf3G94PA3qQc17A287x91t9dX1zTd+davwOCH
         X1Te34BU1eQ46NCI9WMSMf0DecUOUb5R6YHZ7m9/O5Ct75O8rNnIG2ir9kWBEW9VDZww
         ses+u3BVRcL5WlQDYdxv86E8bzshfTPImSGnPc3+B0XPgtn8Kdc1t4Uj+R+pxjyvY8t8
         KChpHjMkkuqmqCvhh9V/b+o40Qtzcy4gpBDWRsHWglUx2D7FhS4gBvjDdlNe+ksvjzSR
         w5H+26YXOUtyQjddt0STsFkN15yUoKLgLvoLlPnC5efud2oKKVGP2drOcCmsDF8o3Gh8
         PCgw==
X-Gm-Message-State: AC+VfDxFXjDjRCAI5K10rDyATmCdjaqQ3UxVGarhAyCO6AMM3/f9lrvw
	K0lO3PJYe939FfObtLnfe7q3ByWUJWNAyHwjRJz3oA==
X-Google-Smtp-Source: ACHHUZ7Ret/NoZAeTEmfro0uoGW2znHCHdRG50nmnwdbXrqoYdeVKGDFkE8UqN0CM3XqUp6vY1Bn5g==
X-Received: by 2002:a17:90b:19cf:b0:247:6a31:d59d with SMTP id nm15-20020a17090b19cf00b002476a31d59dmr3919201pjb.1.1685139458494;
        Fri, 26 May 2023 15:17:38 -0700 (PDT)
Received: from hermes.local (204-195-120-218.wavecable.com. [204.195.120.218])
        by smtp.gmail.com with ESMTPSA id g3-20020a17090a578300b00247735d1463sm3201077pji.39.2023.05.26.15.17.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 26 May 2023 15:17:38 -0700 (PDT)
Date: Fri, 26 May 2023 15:17:36 -0700
From: Stephen Hemminger <stephen@networkplumber.org>
To: Andrea Claudi <aclaudi@redhat.com>
Cc: netdev@vger.kernel.org
Subject: Re: [PATCH iproute2 v4 2/2] vxlan: make option printing more
 consistent
Message-ID: <20230526151736.633919c0@hermes.local>
In-Reply-To: <ZHELme0yf4sDF3UW@renaissance-vector>
References: <20230526174141.5972-1-stephen@networkplumber.org>
	<20230526174141.5972-3-stephen@networkplumber.org>
	<ZHELme0yf4sDF3UW@renaissance-vector>
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

On Fri, 26 May 2023 21:42:17 +0200
Andrea Claudi <aclaudi@redhat.com> wrote:

> On Fri, May 26, 2023 at 10:41:41AM -0700, Stephen Hemminger wrote:
> > Add new helper function print_bool_opt() which prints
> > with no prefix and use it for vxlan options.
> > 
> > If the option matches the expected default value,
> > it is not printed if in non JSON mode unless the details
> > setting is repeated.
> > 
> > Use a table for the vxlan options. This will change
> > the order of the printing of options.
> > 
> > Signed-off-by: Stephen Hemminger <stephen@networkplumber.org>
> > ---
> >  include/json_print.h |   9 ++++
> >  ip/iplink_vxlan.c    | 110 +++++++++++++------------------------------
> >  lib/json_print.c     |  19 ++++++++
> >  3 files changed, 60 insertions(+), 78 deletions(-)
> > 
> > diff --git a/include/json_print.h b/include/json_print.h
> > index 91b34571ceb0..49d3cc14789c 100644
> > --- a/include/json_print.h
> > +++ b/include/json_print.h
> > @@ -101,6 +101,15 @@ static inline int print_rate(bool use_iec, enum output_type t,
> >  	return print_color_rate(use_iec, t, COLOR_NONE, key, fmt, rate);
> >  }
> >  
> > +int print_color_bool_opt(enum output_type type, enum color_attr color,
> > +			 const char *key, bool value, bool show);
> > +
> > +static inline int print_bool_opt(enum output_type type,
> > +				 const char *key, bool value, bool show)
> > +{
> > +	return print_color_bool_opt(type, COLOR_NONE, key, value, show);
> > +}
> > +
> >  /* A backdoor to the size formatter. Please use print_size() instead. */
> >  char *sprint_size(__u32 sz, char *buf);
> >  
> > diff --git a/ip/iplink_vxlan.c b/ip/iplink_vxlan.c
> > index cb6745c74507..e77c3aa2e3a5 100644
> > --- a/ip/iplink_vxlan.c
> > +++ b/ip/iplink_vxlan.c
> > @@ -19,6 +19,25 @@
> >  
> >  #define VXLAN_ATTRSET(attrs, type) (((attrs) & (1L << (type))) != 0)
> >  
> > +static const struct vxlan_bool_opt {
> > +	const char *key;
> > +	int type;
> > +	bool default_value;
> > +} vxlan_opts[] = {
> > +	{ "metadata",	IFLA_VXLAN_COLLECT_METADATA,	false },  
> 
> Here you are changing the output from "external" to "metadata", while
> continuing to use "external" to toggle the option. This may surprise a
> user which checks the output for this option after enabling it.
> 
> Moreover, looking at the man page for ip link, this option is used to
> specify "whether an external control plane (e.g. ip route encap) or the
> internal FDB should be used", so maybe "external" is more close to the
> true meaning of this option.
> 
> I would suggest either to continue using "external" or to switch to
> "metadata" also for option toggling (and update the manpage, too).
> 
> All the rest looks good to me.
>

Thanks will fix that.


