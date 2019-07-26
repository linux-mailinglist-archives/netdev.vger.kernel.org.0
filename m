Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8EC53773D6
	for <lists+netdev@lfdr.de>; Sat, 27 Jul 2019 00:06:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728379AbfGZWGF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Jul 2019 18:06:05 -0400
Received: from mail-pg1-f196.google.com ([209.85.215.196]:46720 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726262AbfGZWGE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Jul 2019 18:06:04 -0400
Received: by mail-pg1-f196.google.com with SMTP id k189so6335463pgk.13
        for <netdev@vger.kernel.org>; Fri, 26 Jul 2019 15:06:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=suJ8HTYXt96cKm0goN1fy+IV1OGokTCAGMrQYEBvTgI=;
        b=sNd2TbO2DZ6i5v1ZF19awmRsXdnXZeafxtlKl2NenV37GRALxDpQ9ybX8doqU5CMqK
         Ewv4cL7yg7XB4SDfSqtywVIgYWU5h9ahzA1XlWy8rgLy+y6LmYf/fzYyNy8htdcfcuvI
         flzzWM+3tzV1MyAZU/8swMEWpAvZdDUGykM9FYvT2G944Iy5U3hBoBHidRcn02EXyjmJ
         XJ5ldlilkQ6b7iM99D90CiuiEuA9pF+ZVo/j/xgx3hYL+GGrnXPqkWkzxgxYZ1HvfFNP
         w3EQaQ7IX34ya3qrqDV+GfpfDN35Mzvug2eqBMrNHrGpd0HvaItboXBOeRBcW32MrmMa
         bepw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=suJ8HTYXt96cKm0goN1fy+IV1OGokTCAGMrQYEBvTgI=;
        b=q7vpGPjI954l2Hk8AIfaaBjL/Bovxo64KJU4v8qmeKnwV/wE2otdzI075jdFbd5egq
         febYdWr7GyaJbaTOch5A2Amjqyc+LTvNFBRdX9K5KMEq7SR0SJChk3E4gp0kSAaxJMtR
         YB/zPCjftSK1OOI/sgM0nR/Ssv8nquXqbqhIXXlZ2RXO8PXX7V7i4v0+GRQ59VMJzP5Q
         klia38RHuc79bPUqmUkEz7xFWcH1VHJ4SZDttzDGqbpJCbfvYowQPOxxbSQehNJIjFD/
         hb1aKP1lLIr0iyl7wZynbm1SYjaWAo11M68GtVdEEo0ez31g+Ct9HFn5WTaNVpCBPnjK
         vERQ==
X-Gm-Message-State: APjAAAXbTVHWs948Gcx8luRV0u2/4OB0BRUAkvBZOxro9kEcspT1IyqR
        qca6LOJbPUDrCNG7WO2Y6is=
X-Google-Smtp-Source: APXvYqwXktzsuOub7N5AHUr3Cx+CdGc6+91h6TU31qoEkVZT56iNIewbUV809NC+wGzzcQ1A0L7ekg==
X-Received: by 2002:aa7:9092:: with SMTP id i18mr24301614pfa.101.1564178763340;
        Fri, 26 Jul 2019 15:06:03 -0700 (PDT)
Received: from hermes.lan (204-195-22-127.wavecable.com. [204.195.22.127])
        by smtp.gmail.com with ESMTPSA id r61sm68400047pjb.7.2019.07.26.15.06.03
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Fri, 26 Jul 2019 15:06:03 -0700 (PDT)
Date:   Fri, 26 Jul 2019 15:04:40 -0700
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Antonio Borneo <borneo.antonio@gmail.com>
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH] iplink_can: fix format output of clock with flag
 -details
Message-ID: <20190726150440.03365456@hermes.lan>
In-Reply-To: <20190726130609.27704-1-borneo.antonio@gmail.com>
References: <20190726130609.27704-1-borneo.antonio@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 26 Jul 2019 15:06:09 +0200
Antonio Borneo <borneo.antonio@gmail.com> wrote:

> The command
> 	ip -details link show can0
> prints in the last line the value of the clock frequency attached
> to the name of the following value "numtxqueues", e.g.
> 	clock 49500000numtxqueues 1 numrxqueues 1 gso_max_size
> 	 65536 gso_max_segs 65535
> 
> Add the missing space after the clock value.
> 
> Signed-off-by: Antonio Borneo <borneo.antonio@gmail.com>

Applied, but CAN looks like it doesn't support single line output correctly.
