Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 248B85ACDE
	for <lists+netdev@lfdr.de>; Sat, 29 Jun 2019 20:50:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726892AbfF2Spa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 29 Jun 2019 14:45:30 -0400
Received: from mail-pl1-f196.google.com ([209.85.214.196]:38590 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726873AbfF2Spa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 29 Jun 2019 14:45:30 -0400
Received: by mail-pl1-f196.google.com with SMTP id 9so4291003ple.5
        for <netdev@vger.kernel.org>; Sat, 29 Jun 2019 11:45:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=dh4m8H3e1cJ0TMxJmvpvtqj2SKGCeWccJUGTcuqKm6U=;
        b=awy8BXkq14Mhmebx1oiBjZr0POUuwDea7p9FaRB/h3vElTvBoG0oWDLbF7UOif3O/1
         Jl5dh5hmZ4ZMza3CvEUM/dYOHywbQcisWXAgAXlf5GzhHgOa/bmRwfk3hGRFp3/0LI6d
         y5MlGyLumE74+PULZbaJO7yyb24y7RrpigjwnI6BMjNsLpcVO4VrdQ0I/AZ7oda4d36u
         PBBXKUUPtpFxAope4CXj53xikh9lXeMUsiinulqN8WVKQYJpOVVqr23BixQdcd5pR8JN
         r28aBMz+WhPdGxv7nP5n+72J/SbOpuwNSsASjB4z8GzgBTyKNw9enDlHlio1pD8/8+sO
         w1Pg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=dh4m8H3e1cJ0TMxJmvpvtqj2SKGCeWccJUGTcuqKm6U=;
        b=gmaXiR53HItlZ77Hck+ghBqaurpB323VE/PpwHcbOUwHktyWtfvVqwYQREMvcbsbBP
         rbopGyOimq5RNMwB65enxYO5n+MYoWHaRDxiRJL2olmTqBUXAkfWvxe5LlNMtgIdpTFN
         XyQphsLe+QTdOz6ozxxQfi7XeA9ZqJruoXsiAjm26YqGOxmlQ1UNZ43KjRb3uBil7U3k
         coJw2DVqWqUgmdT4J0TIpmw/5IY7gmVDCxFudLu04sYMAp/OV4Oo7TEzwJ995iNn+0YF
         QfiO+wo/FtB1veE53MiLwlVEFI9BitjtipobyvxJKrsefEWahnINPao7Qx/M+bMLWfFJ
         a/Xw==
X-Gm-Message-State: APjAAAWx/V4G5sbYgKPXu/cXCg1AE7zSuYlZjgV/njG+rLskmr2v4e8f
        tyTpxYwvSDBKY7BSkoJY6SbpRcRSWLQ=
X-Google-Smtp-Source: APXvYqyARW3QWa4h9XeJ8CqqiblvA+ZGDCwSrnNnD+CnhgC36BqVu7zIHLE39V7roIxQtBB/hMZ9EQ==
X-Received: by 2002:a17:902:f095:: with SMTP id go21mr19543889plb.58.1561833929661;
        Sat, 29 Jun 2019 11:45:29 -0700 (PDT)
Received: from cakuba.netronome.com (c-71-204-185-212.hsd1.ca.comcast.net. [71.204.185.212])
        by smtp.gmail.com with ESMTPSA id q5sm5915245pgj.49.2019.06.29.11.45.29
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Sat, 29 Jun 2019 11:45:29 -0700 (PDT)
Date:   Sat, 29 Jun 2019 11:45:26 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Shannon Nelson <snelson@pensando.io>
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH v2 net-next 04/19] ionic: Add basic lif support
Message-ID: <20190629114526.4da68321@cakuba.netronome.com>
In-Reply-To: <20190628213934.8810-5-snelson@pensando.io>
References: <20190628213934.8810-1-snelson@pensando.io>
        <20190628213934.8810-5-snelson@pensando.io>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 28 Jun 2019 14:39:19 -0700, Shannon Nelson wrote:
> @@ -64,4 +66,49 @@ int ionic_debugfs_add_ident(struct ionic *ionic)
>  				   ionic, &identity_fops) ? 0 : -ENOTSUPP;
>  }
>  
> +int ionic_debugfs_add_sizes(struct ionic *ionic)
> +{
> +	debugfs_create_u32("nlifs", 0400, ionic->dentry,
> +			   (u32 *)&ionic->ident.dev.nlifs);
> +	debugfs_create_u32("nintrs", 0400, ionic->dentry, &ionic->nintrs);
> +
> +	debugfs_create_u32("ntxqs_per_lif", 0400, ionic->dentry,
> +			   (u32 *)&ionic->ident.lif.eth.config.queue_count[IONIC_QTYPE_TXQ]);
> +	debugfs_create_u32("nrxqs_per_lif", 0400, ionic->dentry,
> +			   (u32 *)&ionic->ident.lif.eth.config.queue_count[IONIC_QTYPE_RXQ]);

Are these __le32s?  Does the driver build cleanly with W=1 C=1?

> +	return 0;
> +}
