Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 91BD3352E55
	for <lists+netdev@lfdr.de>; Fri,  2 Apr 2021 19:31:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235421AbhDBRbH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Apr 2021 13:31:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57252 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235971AbhDBRa7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Apr 2021 13:30:59 -0400
Received: from mail-oo1-xc30.google.com (mail-oo1-xc30.google.com [IPv6:2607:f8b0:4864:20::c30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 08EC0C0617A9
        for <netdev@vger.kernel.org>; Fri,  2 Apr 2021 10:30:58 -0700 (PDT)
Received: by mail-oo1-xc30.google.com with SMTP id x187-20020a4a41c40000b02901b664cf3220so1428835ooa.10
        for <netdev@vger.kernel.org>; Fri, 02 Apr 2021 10:30:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=tFq3dY0RT72BHrk7ok6eI3664JDFeam9zNV3RjnEcwo=;
        b=MF9qQTPHMzKD/a89/l6mzPKMnDHOy8gl7/jMOglep0Upik6UjiUnePay4UvNamsmQX
         +ntd0mloiZ3zUI9QtQ1lp+J4iZUpbPhUlsJP72AyhcsDxik8TkhMzgP1+bJjAacAFIPL
         Fwjh1j1bwoYMh8zfwRyYJ/NObwWOVXpiZh3xsusv0ZeNEwPCpEiCL/R96RG1mldvnWWZ
         6KBatLU2qCHdKji4NZaURwFv7Gk3/ej2voQmuyPeEtuHMh2GgnV6B1mVxCbsqmYg8g4t
         oSs3Ee9a7QBA3GUjSQxtDwNkUvsoH6MqOmB7V7pgiqBl25XEmrN/QQOcBEx2a39xC6am
         Jzxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=tFq3dY0RT72BHrk7ok6eI3664JDFeam9zNV3RjnEcwo=;
        b=nTHFuJf9zk1XISbIMhnYC03bAwqT/GIDpNSlR3fig6q7/HSHtDzCExYLJtmjE9exJH
         xyM0or2oQMQMQ183bx9D3yx63aooFe9rrFXNFlVQIBR6fmQNO+SZsSSYawUE+fMitAD9
         1D3nqa7s52pCNBF5dBiqss035wjoNAKl7n1BXCfI4wDuaO3hfwYCdOoEsmybI7Ahkbev
         yyTvxMrNtF/uEPRRfNhPOMF9GDo1Tu0M8G95g1pp/G/tVVEYaBJOc9L2UhH1qQkl6kqE
         TuvZNZuPf1ToM/g5Au/61RGg3V6UsN3sptm7qiRGOIANm9ULP9Q7kxgcU83Wc4iw/Me8
         EeEw==
X-Gm-Message-State: AOAM532wUf1j6MfGomBurTaVgRBNd+WHt/sB8r1FjbKuxozhMt/bxdTO
        44+AENeBjs62v8UdVhgRXTV1lg==
X-Google-Smtp-Source: ABdhPJzWtjLOq+7MW6am6fJ2qyojfFrbGcIApptCWxka+tmPAPEoEqLeC+rWN7I0VOh+1PggpJUwIw==
X-Received: by 2002:a4a:e70a:: with SMTP id y10mr12527509oou.75.1617384657315;
        Fri, 02 Apr 2021 10:30:57 -0700 (PDT)
Received: from yoga (104-57-184-186.lightspeed.austtx.sbcglobal.net. [104.57.184.186])
        by smtp.gmail.com with ESMTPSA id 3sm695680oti.30.2021.04.02.10.30.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 02 Apr 2021 10:30:56 -0700 (PDT)
Date:   Fri, 2 Apr 2021 12:30:54 -0500
From:   Bjorn Andersson <bjorn.andersson@linaro.org>
To:     Alex Elder <elder@linaro.org>
Cc:     netdev@vger.kernel.org, Daniele Palmas <dnlplm@gmail.com>
Subject: Re: [PATCH v2] iplink_rmnet: Allow passing IFLA_RMNET_FLAGS
Message-ID: <20210402173054.GR904837@yoga>
References: <20210315154629.652824-1-bjorn.andersson@linaro.org>
 <1b6ebc71-5efd-53ea-95b5-85e17d5804d1@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1b6ebc71-5efd-53ea-95b5-85e17d5804d1@linaro.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon 15 Mar 11:16 CDT 2021, Alex Elder wrote:

> On 3/15/21 10:46 AM, Bjorn Andersson wrote:
> > Parse and pass IFLA_RMNET_FLAGS to the kernel, to allow changing the
> > flags from the default of ingress-aggregate only.
> 
> To be clear, this default is implemented in the kernel RMNet
> driver, not in "iproute2".  And it is ingress deaggregation
> (unpacking of aggregated packets from a buffer), not aggregation
> (which would be supplying a buffer of aggregated packets to the
> hardware).
> 

Thanks, I'll update the commit message to clarify this point.

> > Signed-off-by: Bjorn Andersson <bjorn.andersson@linaro.org>
> 
> I have some suggestions on your help text (and flag names).
> The code looks good to me otherwise.  I trust you've
> confirmed the RMNet driver uses the flags exactly as
> you intend when they're provided this way.
> 

I've confirmed that it flips the bits in the rmnet driver and that
flipping the right bit(s) my laptop starts deaggregating messages.

> 					-Alex
> > ---
> > 
> > Changes since v1:
> > - s/ifla_vlan_flags/ifla_rmnet_flags/ in print_opt
> > 
> >   ip/iplink_rmnet.c | 42 ++++++++++++++++++++++++++++++++++++++++++
> >   1 file changed, 42 insertions(+)
> > 
> > diff --git a/ip/iplink_rmnet.c b/ip/iplink_rmnet.c
> > index 1d16440c6900..a847c838def2 100644
> > --- a/ip/iplink_rmnet.c
> > +++ b/ip/iplink_rmnet.c
> > @@ -16,6 +16,10 @@ static void print_explain(FILE *f)
> >   {
> >   	fprintf(f,
> >   		"Usage: ... rmnet mux_id MUXID\n"
> > +		"                 [ingress-deaggregation]\n"
> > +		"                 [ingress-commands]\n"
> > +		"                 [ingress-chksumv4]\n"
> > +		"                 [egress-chksumv4]\n"
> 
> Other help output (in print_explain()) put spaces after
> the '[' and before the ']'; so you'd be better to stay
> consistent with that.
> 

I had missed that, thanks.

> And I know the name is based on the C symbol, but I think
> you should follow the convention that seems to be used for
> all others, and use "csum" to mean checksum.
> 
> Also it's not clear what the "v4" means.  I'm not sure I
> like this suggestion, but...  It comes from QMAP version 4,
> as opposed to QMAP version 5, so maybe use "csum-qmap4"
> in place of "csumv4?"
> 

Make sense, I'll update this to ingress-csum-qmap4 etc.

> Is there any way to disable ingress deaggregation?  Since
> it's on by default, you might want to use a "[ on | off ]"
> type option for that case (or all of them for that matter).
> Otherwise, the deaggregation parameter doesn't really help
> anything.
> 

Unfortunately, in contrast to other implementers of IFLAG_x_FLAGS we
find the following snippet in the rmnet driver:

  data_format = flags->flags & flags->mask;

So rather than flags->mask specifying which bits to update, it masks
flags->flags and whatever is left is your new flags. And given that this
is non-standard, the iplink flow doesn't support read/modify/write on
the tool side.

As such it's not possible to toggle individual bits, you always pass the
new flags. So the way to disable a particular feature, is to issue an
change link request without the particular feature specified.

> >   		"\n"
> >   		"MUXID := 1-254\n"
> >   	);
> > @@ -29,6 +33,7 @@ static void explain(void)
> >   static int rmnet_parse_opt(struct link_util *lu, int argc, char **argv,
> >   			   struct nlmsghdr *n)
> >   {
> > +	struct ifla_rmnet_flags flags = { };
> >   	__u16 mux_id;
> 
> Do you know why this is __u16?  Is it because it's exposed
> to user space?  Not a problem... just curious.
> 

This seems to be the data type used throughout the project to denote
16 bit unsigned integers, so it seems to me that Daniele just followed
the coding standard of the project here - and it's defined in the kernel
to be a 16 bit unsigned integer...

Regards,
Bjorn

> >   	while (argc > 0) {
> > @@ -37,6 +42,18 @@ static int rmnet_parse_opt(struct link_util *lu, int argc, char **argv,
> >   			if (get_u16(&mux_id, *argv, 0))
> >   				invarg("mux_id is invalid", *argv);
> >   			addattr16(n, 1024, IFLA_RMNET_MUX_ID, mux_id);
> > +		} else if (matches(*argv, "ingress-deaggregation") == 0) {
> > +			flags.mask = ~0;
> > +			flags.flags |= RMNET_FLAGS_INGRESS_DEAGGREGATION;
> > +		} else if (matches(*argv, "ingress-commands") == 0) {
> > +			flags.mask = ~0;
> > +			flags.flags |= RMNET_FLAGS_INGRESS_MAP_COMMANDS;
> > +		} else if (matches(*argv, "ingress-chksumv4") == 0) {
> > +			flags.mask = ~0;
> > +			flags.flags |= RMNET_FLAGS_INGRESS_MAP_CKSUMV4;
> > +		} else if (matches(*argv, "egress-chksumv4") == 0) {
> > +			flags.mask = ~0;
> > +			flags.flags |= RMNET_FLAGS_EGRESS_MAP_CKSUMV4;
> >   		} else if (matches(*argv, "help") == 0) {
> >   			explain();
> >   			return -1;
> > @@ -48,11 +65,28 @@ static int rmnet_parse_opt(struct link_util *lu, int argc, char **argv,
> >   		argc--, argv++;
> >   	}
> > +	if (flags.mask)
> > +		addattr_l(n, 1024, IFLA_RMNET_FLAGS, &flags, sizeof(flags));
> > +
> >   	return 0;
> >   }
> > +static void rmnet_print_flags(FILE *fp, __u32 flags)
> > +{
> > +	if (flags & RMNET_FLAGS_INGRESS_DEAGGREGATION)
> > +		print_string(PRINT_ANY, NULL, "%s ", "ingress-deaggregation");
> > +	if (flags & RMNET_FLAGS_INGRESS_MAP_COMMANDS)
> > +		print_string(PRINT_ANY, NULL, "%s ", "ingress-commands");
> > +	if (flags & RMNET_FLAGS_INGRESS_MAP_CKSUMV4)
> > +		print_string(PRINT_ANY, NULL, "%s ", "ingress-chksumv4");
> > +	if (flags & RMNET_FLAGS_EGRESS_MAP_CKSUMV4)
> > +		print_string(PRINT_ANY, NULL, "%s ", "egress-cksumv4");
> > +}
> > +
> >   static void rmnet_print_opt(struct link_util *lu, FILE *f, struct rtattr *tb[])
> >   {
> > +	struct ifla_rmnet_flags *flags;
> > +
> >   	if (!tb)
> >   		return;
> > @@ -64,6 +98,14 @@ static void rmnet_print_opt(struct link_util *lu, FILE *f, struct rtattr *tb[])
> >   		   "mux_id",
> >   		   "mux_id %u ",
> >   		   rta_getattr_u16(tb[IFLA_RMNET_MUX_ID]));
> > +
> > +	if (tb[IFLA_RMNET_FLAGS]) {
> > +		if (RTA_PAYLOAD(tb[IFLA_RMNET_FLAGS]) < sizeof(*flags))
> > +			return;
> > +		flags = RTA_DATA(tb[IFLA_RMNET_FLAGS]);
> > +
> > +		rmnet_print_flags(f, flags->flags);
> > +	}
> >   }
> >   static void rmnet_print_help(struct link_util *lu, int argc, char **argv,
> > 
> 
