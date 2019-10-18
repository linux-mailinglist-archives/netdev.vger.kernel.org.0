Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 24657DCB8C
	for <lists+netdev@lfdr.de>; Fri, 18 Oct 2019 18:34:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2443123AbfJRQdc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Oct 2019 12:33:32 -0400
Received: from mail-pf1-f170.google.com ([209.85.210.170]:33436 "EHLO
        mail-pf1-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2443114AbfJRQda (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Oct 2019 12:33:30 -0400
Received: by mail-pf1-f170.google.com with SMTP id q10so4232373pfl.0
        for <netdev@vger.kernel.org>; Fri, 18 Oct 2019 09:33:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=q1DXhSX1xBL05ZotxsGzILehuIkjDUox9zR3xvM8NFo=;
        b=S463kMBA5VV4kAbHtK7jA6Cn+dljJuKjJ5y5f39eCPA9sm7J5AjLVDXLgudtE32F+1
         9Z9nahWepkq5Ai/OD99M/uttAlIOhYu3HxN6S7CCGvLFhmqb6fHOTysDE6l6EUSR4ELM
         DNMMe6cdeG36nJzBgG3N+9Vs5bxVxoA3Q7gz1VDjwVFNJyy7ztEI8+e/rU1ZTergWf86
         /ufiOm+EyArV7+GZ0Mw6bdFc7UjsbweVnEfjWVB1/7dBh3XXuTjvCUGWo1mekyADll55
         DOP9n8f0nkhEN6/SY4nZ/DnTyyHuM79U5hcQgUYye/lQgo4TtnUesoH3CRr62shbk7WC
         VfKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=q1DXhSX1xBL05ZotxsGzILehuIkjDUox9zR3xvM8NFo=;
        b=AJ2HiYe8GdsCsytTkd3dNXxiCXwv2thi/xFnENP6y3EWwDCrpZXhyHOQj6THYq/G70
         4MOKUzlwDzviJWkPzQoRsTgO7ckPEasq94s0soShc9CzwkBdrh7rfx6ftSdJBAEIxwzi
         kKNSrexF237ZXBOOqfgRsmFSAorgcw6zlqgsF3ouoKeZrGA+CrW6F3F7YOK9XWRa3eCL
         P62TTwIJvt0o5IIFG9uRE0UDXPv0ysoFath9SpBpNg6OEjSxb2LoZgX03rJqqSwcm+FQ
         x/TKVUX66DSqaAfnk+kzg8xINhi8zXDWJZ4lCxgnDfoKKwEBN+4DumOq2MiBOqm8afiU
         55sw==
X-Gm-Message-State: APjAAAU7pzx9mkqIKyGc5xdDLlmxzkfMDdmq/Oxkw4OgSIUbw5phkkjo
        aHY13QRtn+4qAu1CFAtaiygoXg==
X-Google-Smtp-Source: APXvYqx1DsIjg6TZqqhNVIDrF/jUas3CDFwNg12a/iFlIJdgR7v+fsaC48usbBMsfqqbbtnEz49wjA==
X-Received: by 2002:a65:5cca:: with SMTP id b10mr11045938pgt.258.1571416409620;
        Fri, 18 Oct 2019 09:33:29 -0700 (PDT)
Received: from hermes.lan (204-195-22-127.wavecable.com. [204.195.22.127])
        by smtp.gmail.com with ESMTPSA id j126sm8004093pfb.186.2019.10.18.09.33.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Oct 2019 09:33:29 -0700 (PDT)
Date:   Fri, 18 Oct 2019 09:33:22 -0700
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     netdev@vger.kernel.org, davem@davemloft.net,
        jakub.kicinski@netronome.com, andrew@lunn.ch, mlxsw@mellanox.com
Subject: Re: [patch net-next] devlink: add format requirement for devlink
 param names
Message-ID: <20191018093322.0a79b622@hermes.lan>
In-Reply-To: <20191018160726.18901-1-jiri@resnulli.us>
References: <20191018160726.18901-1-jiri@resnulli.us>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 18 Oct 2019 18:07:26 +0200
Jiri Pirko <jiri@resnulli.us> wrote:

> +static bool devlink_param_valid_name(const char *name)
> +{
> +	int len = strlen(name);
> +	int i;
> +
> +	/* Name can contain lowercase characters or digits.
> +	 * Underscores are also allowed, but not at the beginning
> +	 * or end of the name and not more than one in a row.
> +	 */
> +
> +	for (i = 0; i < len; i++) {

Very minor stuff.
   1. since strlen technically returns size_t why not make both i and len type size_t
   2. no blank line after comment and before loop?
