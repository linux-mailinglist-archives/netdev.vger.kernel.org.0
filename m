Return-Path: <netdev+bounces-6134-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 25665714DBE
	for <lists+netdev@lfdr.de>; Mon, 29 May 2023 18:02:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D5752280F87
	for <lists+netdev@lfdr.de>; Mon, 29 May 2023 16:02:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DA6049469;
	Mon, 29 May 2023 15:57:09 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD51B8C0A
	for <netdev@vger.kernel.org>; Mon, 29 May 2023 15:57:09 +0000 (UTC)
Received: from mail-wm1-x32b.google.com (mail-wm1-x32b.google.com [IPv6:2a00:1450:4864:20::32b])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 80731A0;
	Mon, 29 May 2023 08:57:08 -0700 (PDT)
Received: by mail-wm1-x32b.google.com with SMTP id 5b1f17b1804b1-3f60e536250so29681865e9.1;
        Mon, 29 May 2023 08:57:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1685375827; x=1687967827;
        h=in-reply-to:content-disposition:mime-version:references:subject:cc
         :to:from:date:message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=lKUULOSBj7tBTW8FHEwjrgh3AafjtGjNkiIhNVDZYDQ=;
        b=UHO7po5P5jLxAfPfrh8jh+BHAychOE0T3pKlgqhwScXEnF7Aw92PMVXTBpEjpDUC8c
         eKCwR8BEKrP4Sa9e1UXFsU+1EkCx3Yw1vCu6B6W60ACHUj8JepKpnGfvmwP4OViNxDfj
         w37PQ+1k17m5jcQ+/l5nRKQfVZITZcXXtHR8RDDvMw3Op0uFNYE3YrwKuH3eBmpWIxZ4
         Or9fpoPiori3uM2MU+zWbwP4Ws5wnoFvcX4TzMVcRSyTqv/Q+1MWLUkNqdbnoD42AK13
         YGq936+0CWWqGbesclYNw7wP6LXbgnVLBesG8y0azOf0gIxAg19TfHJ4PU9exGzbMIb0
         Jqyg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685375827; x=1687967827;
        h=in-reply-to:content-disposition:mime-version:references:subject:cc
         :to:from:date:message-id:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=lKUULOSBj7tBTW8FHEwjrgh3AafjtGjNkiIhNVDZYDQ=;
        b=eR9/kYbPgXJhymy2PF8VuAxqKWxiXrNpviSq7BWnf9VjqLazxldP4Hixm7uxDFzrws
         Zl20+6SYl7kTNW+dxBFLJnh0aB1DPqymdfhA3i2LlW96xCq73bYl4GL+v7XetJlApTpB
         oP0E+j/1+ik2IqrzXbCTUqgHzfrF23uczi+4EmhmM7jOOxBJK3my2caOoNSECCiEoozr
         eSvYHyuks9+HNNJ6JuKT2VPUZ5wxXmY2tnKF0Sm6i91D58Kre6SNlr6GRozRLpAR/78M
         kxBb3aFW0yCSp1YO2xYLZzl8MriSwvaGfyZLU86PFrZ4kKaqUfcMbqLVquUfrq6lv59L
         GJCg==
X-Gm-Message-State: AC+VfDwN0lpoAikZtIUTTzyz4Le6E9/Mhsj51LNT6WMO6bJWyQDMsIQo
	gMAoXSAcLi+r5+W4J6AO9+Q=
X-Google-Smtp-Source: ACHHUZ79cFL3R4cI5Y2qR+q72gm7jPHqUr2wOV+GcT+ImB9u5twMe6StMCS1FCZyk0thQF7rLg6TVQ==
X-Received: by 2002:a7b:c8d7:0:b0:3f6:3486:1391 with SMTP id f23-20020a7bc8d7000000b003f634861391mr6686520wml.13.1685375826743;
        Mon, 29 May 2023 08:57:06 -0700 (PDT)
Received: from Ansuel-xps. (93-34-93-173.ip49.fastwebnet.it. [93.34.93.173])
        by smtp.gmail.com with ESMTPSA id z10-20020a7bc7ca000000b003f602e2b653sm18313505wmk.28.2023.05.29.08.57.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 29 May 2023 08:57:06 -0700 (PDT)
Message-ID: <6474cb52.7b0a0220.ece09.c49e@mx.google.com>
X-Google-Original-Message-ID: <ZHTKKK7/Rsjn0HgH@Ansuel-xps.>
Date: Mon, 29 May 2023 17:52:08 +0200
From: Christian Marangi <ansuelsmth@gmail.com>
To: Andrew Lunn <andrew@lunn.ch>
Cc: Pavel Machek <pavel@ucw.cz>, Lee Jones <lee@kernel.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Florian Fainelli <f.fainelli@gmail.com>,
	Vladimir Oltean <olteanv@gmail.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	linux-leds@vger.kernel.org, linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [net-next PATCH v3 08/13] leds: trigger: netdev: add support for
 LED hw control
References: <20230527112854.2366-1-ansuelsmth@gmail.com>
 <20230527112854.2366-9-ansuelsmth@gmail.com>
 <41bbeede-b88a-431f-8bcf-ba3c8a951dc5@lunn.ch>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <41bbeede-b88a-431f-8bcf-ba3c8a951dc5@lunn.ch>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Mon, May 29, 2023 at 05:45:45PM +0200, Andrew Lunn wrote:
> >  static bool can_hw_control(struct led_netdev_data *trigger_data)
> >  {
> > +	unsigned int interval = atomic_read(&trigger_data->interval);
> >  	struct led_classdev *led_cdev = trigger_data->led_cdev;
> > +	unsigned long default_interval = msecs_to_jiffies(50);
> 
> nitpick:
> 
> We have 50 in netdev_trig_activate(). Now it is used twice, it would
> be nice to replace it with a #define. I doubt it will ever get
> changed, but we do want them to be identical.
> 
> Reviewed-by: Andrew Lunn <andrew@lunn.ch>
>

Good idea. I will move the value to a define in v4, guess it's ok to
keep the review tag for this simple change?

-- 
	Ansuel

