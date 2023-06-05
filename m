Return-Path: <netdev+bounces-8233-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id A13B372334F
	for <lists+netdev@lfdr.de>; Tue,  6 Jun 2023 00:44:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 116F61C20CB7
	for <lists+netdev@lfdr.de>; Mon,  5 Jun 2023 22:44:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7BF5C24E98;
	Mon,  5 Jun 2023 22:44:34 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6DCB35256
	for <netdev@vger.kernel.org>; Mon,  5 Jun 2023 22:44:34 +0000 (UTC)
Received: from mail-pl1-x635.google.com (mail-pl1-x635.google.com [IPv6:2607:f8b0:4864:20::635])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ECFECF9
	for <netdev@vger.kernel.org>; Mon,  5 Jun 2023 15:44:32 -0700 (PDT)
Received: by mail-pl1-x635.google.com with SMTP id d9443c01a7336-1b038064d97so49283815ad.0
        for <netdev@vger.kernel.org>; Mon, 05 Jun 2023 15:44:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20221208.gappssmtp.com; s=20221208; t=1686005072; x=1688597072;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=5LVNNL/8i7EPYrqFXNV9wFJ0SdEUO/Pe/tt12fxbhw4=;
        b=fGIVJfr4HGgbFOOg/wadrtYveVuQMm2ty+lPBbBvS7UrX13EH61HVAuxw4jpqDQnyj
         oJzpyB4X8MTePBSTiw7brVaCfKb/53mA8+O+oGCSOpj0PkUGNMh3ldz1vPWDhqJxeeyp
         C8lPI9quh9to/VUxNEU4aPsHB+y2nrkSffNJtB40dsgo6kQmQORaiJ9qiFm8Gil3Ey3X
         vC6tAQP8N1ZeXbQUF8wXH+Q5h/mK68eyJcZ/QVBBzxdnQyg1nVozoqMh90JVKkP5pqIt
         x33sfS3RDIPsUgK04DWIfwuJRW8065EC+2csyu3mWoTUxtn2RkQvA8jpCwDIA2qtZAOR
         aRPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686005072; x=1688597072;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=5LVNNL/8i7EPYrqFXNV9wFJ0SdEUO/Pe/tt12fxbhw4=;
        b=W2tqNSmQRFEeOz8vULNMRh1lZL2i4CXT9yBc50A5k/ivQlm3AaHIijPRZv3qY7LkIW
         /a7Q+BjjvmqLEGKBseDTCA0Sr/C2Kwcf80tXvD2Vt6rPkIMl4PvpIgipO6h5EpUPw4mE
         bwbalXgm9FXlBNmiGK8B6nT1fN90vcpL5qMyauO1f9eaVKJQJvImcuVRGU/Ur9zM69rr
         gaAqWtBkvLJjvu/f3ogVEK7hrZ69LJyCEM7jJ2WfJLvpegtRb99/pORRVHhIdooEO9wA
         XYdWfffgWLQXG7xVF22/+soTgBD4rFV0/3wkdDhWkpTsWo9m8Wt4bdRlNz8zAuxfD4HF
         hBCw==
X-Gm-Message-State: AC+VfDx8CS00SQsAWvj30nfBqwW1rHKegUMbVt2gu8wtfbuw4y86RSTm
	tz48DBQ9LurOUmSn7+jIlDYMUwgk2epO2mSADJhv0g==
X-Google-Smtp-Source: ACHHUZ4yajPY68zst5N0xb5aK2jY9P6YTjd3T8kpkYyh8lTQIlR6g0aw/+XsIcTHFOH6gel1pNTBCg==
X-Received: by 2002:a17:902:d2c6:b0:1b1:99c9:8cd1 with SMTP id n6-20020a170902d2c600b001b199c98cd1mr310676plc.28.1686005072360;
        Mon, 05 Jun 2023 15:44:32 -0700 (PDT)
Received: from hermes.local (204-195-120-218.wavecable.com. [204.195.120.218])
        by smtp.gmail.com with ESMTPSA id ix20-20020a170902f81400b001a285269b70sm7052411plb.280.2023.06.05.15.44.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 Jun 2023 15:44:32 -0700 (PDT)
Date: Mon, 5 Jun 2023 15:44:30 -0700
From: Stephen Hemminger <stephen@networkplumber.org>
To: Mike Freemon <mfreemon@cloudflare.com>
Cc: netdev@vger.kernel.org, kernel-team@cloudflare.com
Subject: Re: [PATCH] Add a sysctl to allow TCP window shrinking in order to
 honor memory limits
Message-ID: <20230605154430.65d94106@hermes.local>
In-Reply-To: <20230605154229.6077983e@hermes.local>
References: <20230605203857.1672816-1-mfreemon@cloudflare.com>
	<20230605154229.6077983e@hermes.local>
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

On Mon, 5 Jun 2023 15:42:29 -0700
Stephen Hemminger <stephen@networkplumber.org> wrote:

> > sysctl: net.ipv4.tcp_shrink_window
> > 
> > This sysctl changes how the TCP window is calculated.
> > 
> > If sysctl tcp_shrink_window is zero (the default value), then the
> > window is never shrunk.
> > 
> > If sysctl tcp_shrink_window is non-zero, then the memory limit
> > set by autotuning is honored.  This requires that the TCP window
> > be shrunk ("retracted") as described in RFC 1122.
> > 
> > [1] https://www.rfc-editor.org/rfc/rfc7323#appendix-F
> > [2] https://www.rfc-editor.org/rfc/rfc7323#section-2.4
> > [3] https://www.rfc-editor.org/rfc/rfc1122#page-91
> > [4] https://www.rfc-editor.org/rfc/rfc793
> > [5] https://www.rfc-editor.org/rfc/rfc1323
> > 
> > Signed-off-by: Mike Freemon <mfreemon@cloudflare.com>  
> 
> Does Linux TCP really need another tuning parameter?
> Will tests get run with both feature on and off?
> What default will distributions ship with?
> 
> Sounds like unbounded receive window growth is always a bad
> idea and a latent bug.

FYI - I worked in an environment where every bug fix had to have
a tuning parameter to turn it off. It was a bad idea, driven by
management problems with updating. The number of knobs lead
to confusion and geometric growth in possible code paths.

