Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D431B51BE7
	for <lists+netdev@lfdr.de>; Mon, 24 Jun 2019 22:03:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731363AbfFXUDc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Jun 2019 16:03:32 -0400
Received: from mail-qk1-f196.google.com ([209.85.222.196]:42190 "EHLO
        mail-qk1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730044AbfFXUDc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Jun 2019 16:03:32 -0400
Received: by mail-qk1-f196.google.com with SMTP id b18so10733792qkc.9
        for <netdev@vger.kernel.org>; Mon, 24 Jun 2019 13:03:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=fD2KwPjnPT3a+d5rVUvS3rQZxF88VTT5SnAP2kXk9yw=;
        b=hXssesLZlMUTM/Eocmp+VOm26lI1sTd/JZk1r+YsMqmJSFP1n2wLjaYnlYHi4SaDFo
         hlbpcaHRXs21bc0NGUHjLUt0AaSeB01g6NERlHdk9Nfd7j1UlcWvXfJ36l9G58dCJjyl
         jFNhjlpTWMjT84Pvpx2pUapiiba6M9Fnjmq3+vT17IG31MKYx3+U97ikEKGGEjdAAtWR
         OHf2GjQa4DocMzlxSVY1HO8oe7nbjlxTbw3oVJBVg5L5DT9PgrHZpABI2RVVaBbl3fzG
         YU1GTtwF8hHXMAhE+BwSkomeGNH7voe1Svw/PxOKHOMBZwPQzFSE0Tp95L8FOoMnnJHH
         2S9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=fD2KwPjnPT3a+d5rVUvS3rQZxF88VTT5SnAP2kXk9yw=;
        b=UsL/lBYrGkYavhVvfSID3Ot9HMk6LUHms/dwv4FHZ/yOvKgPCf+w6Hxjycj2aX4ku/
         uT4YnSD6kP1+NXNRPsVCAiwR+q588Rfk7H6kTTtO62KmRlN0KmCezXIRhAZA9ZRJPVsr
         mId1xWEATyeAUNgO41ZZm9q1M3xbZCjW80NkuO3uUEDyiwq401jjdIy519md8Z+MwWbK
         GvRxjAWpegzsI2skm2H/r2m+mA5p4+e6c6V9jRUk4NaVjzCOgeZsllRVYl8WwnYgIsOA
         HzaFXaemGbxu8QH6oceAVmTyjZvWCjQfzCTISlf/4z8DvcS3zlPRzFfV/iPsAI9ktgjY
         +c9g==
X-Gm-Message-State: APjAAAXTPRG3BpGhP5Tr0jvQMoUMBbZwBOm565g4/AFXCL5EW1AVcCBB
        vtfoy5ig+9qT1DAH1Rlaw3+rdw==
X-Google-Smtp-Source: APXvYqyYagvFot3yiRZr7ZORv8dp4EY5DHBr8NTrjRK36JM6IuK0pXglgGH4oNovGgLWn34gfPpykA==
X-Received: by 2002:a37:7083:: with SMTP id l125mr22798407qkc.71.1561406611601;
        Mon, 24 Jun 2019 13:03:31 -0700 (PDT)
Received: from cakuba.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id s11sm7050375qte.49.2019.06.24.13.03.30
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Mon, 24 Jun 2019 13:03:31 -0700 (PDT)
Date:   Mon, 24 Jun 2019 13:03:27 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Shannon Nelson <snelson@pensando.io>
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH net-next 01/18] ionic: Add basic framework for IONIC
 Network device driver
Message-ID: <20190624130327.2b16d149@cakuba.netronome.com>
In-Reply-To: <20190620202424.23215-2-snelson@pensando.io>
References: <20190620202424.23215-1-snelson@pensando.io>
        <20190620202424.23215-2-snelson@pensando.io>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 20 Jun 2019 13:24:07 -0700, Shannon Nelson wrote:
> diff --git a/Documentation/networking/device_drivers/pensando/ionic.rst b/Documentation/networking/device_drivers/pensando/ionic.rst
> new file mode 100644
> index 000000000000..84bdf682052b
> --- /dev/null
> +++ b/Documentation/networking/device_drivers/pensando/ionic.rst
> @@ -0,0 +1,75 @@
> +.. SPDX-License-Identifier: GPL-2.0+
> +
> +==========================================================
> +Linux* Driver for the Pensando(R) Ethernet adapter family
> +==========================================================
> +
> +Pensando Linux Ethernet driver.
> +Copyright(c) 2019 Pensando Systems, Inc
> +
> +Contents
> +========
> +
> +- Identifying the Adapter
> +- Special Features
> +- Support
> +
> +

nit: all instances of multiple empty lines in the docs look a bit
unnecessary
