Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 289F2A7D4C
	for <lists+netdev@lfdr.de>; Wed,  4 Sep 2019 10:08:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729234AbfIDIID (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Sep 2019 04:08:03 -0400
Received: from mail-lf1-f65.google.com ([209.85.167.65]:40484 "EHLO
        mail-lf1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727787AbfIDIIC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Sep 2019 04:08:02 -0400
Received: by mail-lf1-f65.google.com with SMTP id u29so15099364lfk.7
        for <netdev@vger.kernel.org>; Wed, 04 Sep 2019 01:08:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rasmusvillemoes.dk; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=a0kRc/YGO4sI2T4Jh9SgXNSXruke3g7n9BxPhpUUJ54=;
        b=P4VDt5A6J/Y3PvIBzQ6SPSxa/x9TjXmZukB9THqunU38XJM5ivrf2H/Q2LyXaOMgzK
         Pd5ydHTs4EIvyjSPo3A8Hmr4tHXUUtBJmQY5UvW3DtX+8oxiRvxf43pu+ax2o3Zh+GkI
         yRm4cPAZGjqkCee4M3LbDLVUSpIcfnC8CCWHY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=a0kRc/YGO4sI2T4Jh9SgXNSXruke3g7n9BxPhpUUJ54=;
        b=O1msC9v1V2k6g814KlTja/Ribv8K2wxFuFuK7CujkpoiQtVLI0jEp/iFupIgUcJyg7
         ctUCtKGjTp6sqIIn8u6vXFdt/sYO7HNcDVaWvYwAeBXRK6XAF06E/JpO1aea/prr4tcb
         94nlSEOoJam05CarBHrygOeXVFjeL8NKbUcbCf63sMV0gS/AAZzzNLgD2+wCUuuM6V6H
         kaJ27f9J4hAlO3EuCnVdohiuugh0eeDbkv2jWJICCzI7FscVrsQI3QwwzOealcv+Cdr6
         CRFmF9q8tmqHnBp/ew5dveCobGyljtmeDBsxG2SitYUWSU5j1AhBMQpX+rBIHIGRtjY7
         FyHg==
X-Gm-Message-State: APjAAAX0wVQ3lTYk1WHu78oQsvyiHQnFo6WRh/pxsr4PaS4SdYQgJgPk
        HU5H73e8gFWUabWOCRKAe6939Q==
X-Google-Smtp-Source: APXvYqz2ExSsuGf+yAeGUMFV4ravzD8nHs1JMfCDmzblByyzFaRuS+bA/s5+pTAI8uOIZMjph78wRg==
X-Received: by 2002:ac2:558a:: with SMTP id v10mr1946562lfg.162.1567584480532;
        Wed, 04 Sep 2019 01:08:00 -0700 (PDT)
Received: from [172.16.11.28] ([81.216.59.226])
        by smtp.gmail.com with ESMTPSA id z72sm1131327ljb.98.2019.09.04.01.07.59
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 04 Sep 2019 01:07:59 -0700 (PDT)
Subject: Re: [PATCH 1/2] linux/kernel.h: add yesno(), onoff(),
 enableddisabled(), plural() helpers
To:     Jani Nikula <jani.nikula@intel.com>, linux-kernel@vger.kernel.org
Cc:     Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>,
        intel-gfx@lists.freedesktop.org,
        Vishal Kulkarni <vishal@chelsio.com>, netdev@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Julia Lawall <julia.lawall@lip6.fr>
References: <20190903133731.2094-1-jani.nikula@intel.com>
From:   Rasmus Villemoes <linux@rasmusvillemoes.dk>
Message-ID: <dcdf1abc-7b8e-1f42-a955-0438b90fe9dc@rasmusvillemoes.dk>
Date:   Wed, 4 Sep 2019 10:07:58 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190903133731.2094-1-jani.nikula@intel.com>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 03/09/2019 15.37, Jani Nikula wrote:

> While the main goal here is to abstract recurring patterns, and slightly
> clean up the code base by not open coding the ternary operators, there
> are also some space savings to be had via better string constant
> pooling.

Eh, no? The linker does that across translation units anyway - moreover,
given that you make them static inlines, "yes" and "no" will still live
in .rodata.strX.Y in each individual TU that uses the yesno() helper.

The enableddisabled() is a mouthful, perhaps the helpers should have an
underscore between the choices

yes_no()
enabled_disabled()
on_off()

?

>  drivers/gpu/drm/i915/i915_utils.h             | 15 -------------
>  .../ethernet/chelsio/cxgb4/cxgb4_debugfs.c    | 11 ----------
>  drivers/usb/core/config.c                     |  5 -----
>  drivers/usb/core/generic.c                    |  5 -----
>  include/linux/kernel.h                        | 21 +++++++++++++++++++

Pet peeve: Can we please stop using linux/kernel.h as a dumping ground
for every little utility/helper? That makes each and every translation
unit in the kernel slightly larger, hence slower to compile. Please make
a linux/string-choice.h and put them there.

Rasmus
