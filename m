Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 96F231430E7
	for <lists+netdev@lfdr.de>; Mon, 20 Jan 2020 18:42:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726901AbgATRmF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Jan 2020 12:42:05 -0500
Received: from mail-pg1-f195.google.com ([209.85.215.195]:37804 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726642AbgATRmF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Jan 2020 12:42:05 -0500
Received: by mail-pg1-f195.google.com with SMTP id q127so29953pga.4
        for <netdev@vger.kernel.org>; Mon, 20 Jan 2020 09:42:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ZRiWXOawtCsM43vxBGinZ/BFfFS6wqGhtWDtNooQgkA=;
        b=Ch43K2tykT+lh+ePLs3s1uKh6RrlYgH99uKWTQ5RX7EU4adrmheu0AVkhlewk4S0er
         jS+kyauWmIfuiqNJqiiWiNKVW6JzjMfoqIgXx2c8aCVfzlK2KdFhbz59V7S+mnIEF2l0
         D5mBdTq3ZItJxG7MfDYqRurOT4fVavShzUu6vSaCq+uHafmCUUNjIwHm3Fhn6hxdpBYo
         83zsJgIvlSSLPsNqUhzdAN7AUXVuBNBji/IJTijA4vqjGhKRoBQrIYHNGFNLgXlVMRQf
         qH1NL90h0bq0dRLadD0gex9AVuttoZxtS3LMBGHScOsYYwzqHTzsz62jqE/qrEqwRlSr
         wrrg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ZRiWXOawtCsM43vxBGinZ/BFfFS6wqGhtWDtNooQgkA=;
        b=XwafU3W5cntF80RPCus3Xe61SoTixTDU0JzYHSJBF/EJzu0ztTfb8rNxOU6IAGQv7B
         57noOMnRMgzYd6LUPYD3qUb5ZGfHpmM3kITg2dxHte9m2cXtIr+DVN+eAms36hHSeC93
         gFdIRGcQWDju8kvFjtgqW6a+bvkr/jX+8/17iChNlJ44Rze263OgVYOmZstbMk6Rzas4
         2UnmtCYGrUSEVKs6sWTSOxrBCN2xc4ro6bDBgV5bYlBE5ITBdJbgEtAiCBQ5k1sD94sH
         o2s+HHxC9Z/T/xTeT0aqGm9fKUUiYcabUjJ95Gk9yboJnJy9FhYbbd4jsBvKKgJPLse3
         izZw==
X-Gm-Message-State: APjAAAVQyyvfT3HIJmLCDFnX+qtIYonmvAaZfFpjcvP/1lY+r5+46Z8O
        ZwgAALimkufzJAxnsgNNRftb1Ah3Kwc=
X-Google-Smtp-Source: APXvYqzKm2P1ZaMgK+Vzl1Fj6MpJWWVPMW9usJXXW/NGRDI6VkASWFRaYNvV9Onki1SnOTYv9tMTEw==
X-Received: by 2002:aa7:9f47:: with SMTP id h7mr274603pfr.13.1579542125042;
        Mon, 20 Jan 2020 09:42:05 -0800 (PST)
Received: from hermes.lan (204-195-22-127.wavecable.com. [204.195.22.127])
        by smtp.gmail.com with ESMTPSA id a9sm39754916pfn.38.2020.01.20.09.42.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Jan 2020 09:42:04 -0800 (PST)
Date:   Mon, 20 Jan 2020 09:42:01 -0800
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Jan Engelhardt <jengelh@inai.de>
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH] build: fix build failure with -fno-common
Message-ID: <20200120094201.45323e5f@hermes.lan>
In-Reply-To: <20200108100424.26642-1-jengelh@inai.de>
References: <20200108100424.26642-1-jengelh@inai.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed,  8 Jan 2020 11:04:24 +0100
Jan Engelhardt <jengelh@inai.de> wrote:

> $ make CCOPTS=-fno-common
> gcc ... -o ip
> ld: rt_names.o (symbol from plugin): in function "rtnl_rtprot_n2a":
> (.text+0x0): multiple definition of "numeric"; ip.o (symbol from plugin):(.text+0x0): first defined here
> 
> gcc ... -o tipc
> ld: ../lib/libutil.a(utils.o):(.bss+0xc): multiple definition of `pretty';
> tipc.o:tipc.c:28: first defined here
> 
> References: https://bugzilla.opensuse.org/1160244
> Signed-off-by: Jan Engelhardt <jengelh@inai.de>

Looks good, applied.
