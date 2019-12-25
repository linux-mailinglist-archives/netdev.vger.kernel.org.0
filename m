Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 67ADC12A917
	for <lists+netdev@lfdr.de>; Wed, 25 Dec 2019 21:36:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726489AbfLYUgQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Dec 2019 15:36:16 -0500
Received: from mail-pf1-f194.google.com ([209.85.210.194]:42416 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726414AbfLYUgQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Dec 2019 15:36:16 -0500
Received: by mail-pf1-f194.google.com with SMTP id 4so12298709pfz.9
        for <netdev@vger.kernel.org>; Wed, 25 Dec 2019 12:36:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=qwxvT5cn5r8eu1EwaHhHh7jVZauhirMZoqjUu1ANFas=;
        b=v88DxyrKTqDiM0/tqSfSw1GGj0ckiHRCA99jjRKgF0XnG2georFX5KBkIjcs+ZjzAP
         Pqs9/7xk/uInk99X0jylg2RJLQMqQRn/HEyutuxIXTGbQxX/zuZvf64NXQJJb7jpZjLq
         OH+QFFY7MLPJbO7Df2qYPxIFkQitzqzh0v2OLdua5dHwLvwL8LSNlzngwzakde+Tj+U8
         /e1BVnCPOHEuqnTs7evdil4vG4yqZTpzamVg6cI5DkGeKs5fdhz+4UYx/iq6/5k9ajb8
         2/AMaou2bJdZyCrU51ClIBF3vqY7lrwpM4wI16ihNjeEiUYZqkMU5rR6IKNMBrn+pGlM
         iHHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=qwxvT5cn5r8eu1EwaHhHh7jVZauhirMZoqjUu1ANFas=;
        b=MyLh9xiQVRb3RJIyBIHWvQ5JUyF3rKMaKHxb8lkV6JHb7MmiuQQ2JaIgoJwQ/LVbyu
         /rhnoEE2AsdTOFVIGMbZHP5smis+xhIo0bdTtFsteJlgX9y5AeSDKA+ld/kD4CrCL3ka
         qpj+iO+TJ67bW3j2k8oZ+/UBEY4K5yhrmVYGXdLb9TP5B0XpHrJhK956in/vydvTDlJd
         8UpHiqkGUszo6XTQhwST0uqdEnQF+/JoCo3ExSqZ+VP6PkH4bVd2lsFyz8l6wSHsN1O1
         8toFj1X/pCMGk6LjyxQHHQqEl2EB3mj+fz8yirF8Tpd5zydp3YC0l8JovoaJyP23ipPc
         XY7A==
X-Gm-Message-State: APjAAAWfnkrV/VUrZa+lgFs3eBP6urfdHM4wdH9Y/8bkqT0v3cWzHGzw
        cXChk4c6r/5WY1APOGqh7FuTb2vROHmexw==
X-Google-Smtp-Source: APXvYqwl6yfxGyvN9RZDKxQgk45kEc79iHrXIwxVLOCUqCboCK9HPHsEKCdSsTIYcKpf1KiUGYNLKA==
X-Received: by 2002:a62:a515:: with SMTP id v21mr45752455pfm.128.1577306175677;
        Wed, 25 Dec 2019 12:36:15 -0800 (PST)
Received: from hermes.lan (204-195-22-127.wavecable.com. [204.195.22.127])
        by smtp.gmail.com with ESMTPSA id p35sm25899510pgl.47.2019.12.25.12.36.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Dec 2019 12:36:15 -0800 (PST)
Date:   Wed, 25 Dec 2019 12:36:07 -0800
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Peter Junos <petoju@gmail.com>
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH] ss: use compact output for undetected screen width
Message-ID: <20191225123607.38be4bdc@hermes.lan>
In-Reply-To: <20191223124716.GA25816@peto-laptopnovy>
References: <20191223124716.GA25816@peto-laptopnovy>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 23 Dec 2019 13:47:16 +0100
Peter Junos <petoju@gmail.com> wrote:

> This change fixes calculation of width in case user pipes the output.
> 
> SS output output works correctly when stdout is a terminal. When one
> pipes the output, it tries to use 80 or 160 columns. That adds a
> line-break if user has terminal width of 100 chars and output is of
> the similar width.
> 
> To reproduce the issue, call
> ss | less
> and see every other line empty if your screen is between 80 and 160
> columns wide.
> 
> Signed-off-by: Peter Junos <petoju@gmail.com>

I would prefer that if the use pipes the command output to a pipe that
the line length was assumed to be infinite.  

> @@ -1159,7 +1159,13 @@ static int render_screen_width(void)
>   */
>  static void render_calc_width(void)
>  {
> +	bool compact_output = false;
>  	int screen_width = render_screen_width();
> +	if (screen_width == -1) {
> +		screen_width = 80;
> +		compact_output = true;
> +	}
> +
>  	struct column *c, *eol = columns - 1;
>  	int first, len = 0, linecols = 0;
>  

With this patch, declarations and code are now mixed (more than before).
I would expect something like:

static void render_calc_width(void)
{
	int screen_width, first, len = 0, linecols = 0;
	bool compact_output = false;
	struct column *c, *eol = columns - 1;

	screen_width = render_screen_width();
	if (screen_width == -1) {
		screen_width = INT_MAX;
		compact_output = true;
	}
