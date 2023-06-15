Return-Path: <netdev+bounces-11230-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 786FE7320F4
	for <lists+netdev@lfdr.de>; Thu, 15 Jun 2023 22:36:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 60F371C20EDB
	for <lists+netdev@lfdr.de>; Thu, 15 Jun 2023 20:36:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 35F667E3;
	Thu, 15 Jun 2023 20:36:56 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 298AF2E0D4
	for <netdev@vger.kernel.org>; Thu, 15 Jun 2023 20:36:55 +0000 (UTC)
Received: from mail-ej1-x62b.google.com (mail-ej1-x62b.google.com [IPv6:2a00:1450:4864:20::62b])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 867BFDF;
	Thu, 15 Jun 2023 13:36:54 -0700 (PDT)
Received: by mail-ej1-x62b.google.com with SMTP id a640c23a62f3a-9828a7a39d1so239317366b.0;
        Thu, 15 Jun 2023 13:36:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1686861413; x=1689453413;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=NIlLjmpeTXD7muPq78fDDjTK7R0iuY0NQ7klt7QevyE=;
        b=svC2+czAPQw0JJaaeyX18v0M77T5jLqxpdGZiELyrOr36OeF39seF6G8xChaR4LQkt
         EuhHsWI+ijwMx7e8w9e3twuFgSAsnOWIfPPrfb5ou5T6c0IzK1Lr5K8ufhPNMMt5SoEw
         ogW+7B9SntyqbpWlv8W8AjezAxrxDWq1BB+pugH9MENC4zAqJfRV43WH5WjrlD5+5Nwx
         /5Vc+xe35iSLWT6WPqm044DLSMrTgQxLyulyv28+Bw8qNZsF0TSzS/T1sYXozW+g/yBW
         etqSP1QNjSrihZ9N2NOOfspAXWMRbN3xfF3x0wiXkJ+veQ12KTfUZ9VuNX5NOd45gMtC
         oB/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686861413; x=1689453413;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=NIlLjmpeTXD7muPq78fDDjTK7R0iuY0NQ7klt7QevyE=;
        b=RlgWJaOZsjowFMrggpfPTGGNL25uE168RjiWhBMFKG8baH9hzemSYdy6EYRG2XhG5b
         U87knYqnssjbGs3yONuPm16IZA5/vHmDNgtnTDwVQ0s10qKlptHBaHdni4AYCQZfnEtW
         LdgCF3AvvOJasExU3BCxojysFdMSRa7jTewufSS3JBFvCvizQ+sE3JufCCz3pQJHuott
         dnzXuyef/IYzu+QdvH7Yytl1xdFyisHG6xAaGi5f9fNBh2vQNZVNhx/iDRQneFB2xRX9
         JhlvZzzNcXwYoJ34HvyUrfJegXbE3xeo0OHoGelrKY3Add1MAx1xQ+QqEHtt13ZoiSdh
         itDA==
X-Gm-Message-State: AC+VfDw8fFCSc1Vc8DXzgswy07drpEyMTElmM7EdOB+tKmgGaiSxqEeW
	cK5HPez+o/rwK8AL/WtfKe0=
X-Google-Smtp-Source: ACHHUZ5zo0Bp5rWItQGj98AvS8hsBTVEf8FixZF83ZFIVGz+ZZ8Rai2ZsaZ7MHhNfKf4dtLbHMYxsQ==
X-Received: by 2002:a17:906:ef0b:b0:967:21:5887 with SMTP id f11-20020a170906ef0b00b0096700215887mr145397ejs.40.1686861412620;
        Thu, 15 Jun 2023 13:36:52 -0700 (PDT)
Received: from skbuf ([188.27.184.189])
        by smtp.gmail.com with ESMTPSA id oq19-20020a170906cc9300b00977e0bcff1esm9917887ejb.10.2023.06.15.13.36.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Jun 2023 13:36:51 -0700 (PDT)
Date: Thu, 15 Jun 2023 23:36:49 +0300
From: Vladimir Oltean <olteanv@gmail.com>
To: Simon Horman <simon.horman@corigine.com>
Cc: Wang Ming <machel@vivo.com>, Andrew Lunn <andrew@lunn.ch>,
	Florian Fainelli <f.fainelli@gmail.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Stephen Rothwell <sfr@canb.auug.org.au>, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org, opensource.kernel@vivo.com
Subject: Re: [PATCH v1] drivers:net:dsa:Fix resource leaks in
 fwnode_for_each_child_node() loops
Message-ID: <20230615203649.amziv2aqzi3vishu@skbuf>
References: <20230615070512.6634-1-machel@vivo.com>
 <ZIsME1gwEWEyyN1o@corigine.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZIsME1gwEWEyyN1o@corigine.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Hi Simon,

On Thu, Jun 15, 2023 at 03:03:15PM +0200, Simon Horman wrote:
> On Thu, Jun 15, 2023 at 03:04:58PM +0800, Wang Ming wrote:
> >  The fwnode_for_each_child_node loop in qca8k_setup_led_ctrl should
> >  have fwnode_handle_put() before return which could avoid resource leaks.
> >  This patch could fix this bug.
> > 
> > Signed-off-by: Wang Ming <machel@vivo.com>
> 
> Hi Wang Ming,
> 
> unfortunately your patch has been whitespace mangled - tabs have been
> converted into 8 spaces. Possibly this was done by your mail client
> or mail server. In any case the result is that the patch doesn't apply.
> And unfortunately that breaks our processes.
> 
> Also, I'm assuming that as this patch is a fix, it is targeted at the
> "net", as opposed to "net-next", tree. This should be noted in the subject.
> 
> 	Subject: [PATCH net v2] ...
> 
> Lastly, looking at the git history of qca8k-leds.c, I think that
> a better prefix for the patch is "net: dsa: qca8k: ".
> 
> 	Subject: [PATCH net v2] net: dsa: qca8k: ...
> 
> Please consider addressing the problems and reposting your patch.
> 
> -- 
> pw-bot: changes-requested

I think that according to the disclaimer text, you as a subscriber to
the mailing list should have deleted this message instead of commenting
on it :)

| The contents of this message and any attachments may contain confidential
| and/or privileged information and are intended exclusively for the
| addressee(s). If you are not the intended recipient of this message or
| their agent, please note that any use, dissemination, copying, or storage
| of this message or its attachments is not allowed.
| If you receive this message in error, please notify the sender by reply
| the message or phone and delete this message, any attachments and any
| copies immediately.

Seriously now, that has to go when posting to a mailing list whose archives
can be seen on the world wide web.
https://lore.kernel.org/netdev/20230615070512.6634-1-machel@vivo.com/

2 comments from my side on the actual patch.

1. There is an indentation of 1 space in the commit message which
   doesn't belong there.

2. I believe that the "ports" fwnode_handle is also leaked, both in the
   error as well as in the success case.

And one more process-related observation. You must find the commit which
introduced the problem and add:

Fixes: 1e264f9d2918 ("net: dsa: qca8k: add LEDs basic support")

and also CC the author of that patch.

