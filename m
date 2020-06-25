Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 15BA9209980
	for <lists+netdev@lfdr.de>; Thu, 25 Jun 2020 07:32:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727912AbgFYFcP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Jun 2020 01:32:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48714 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726548AbgFYFcM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Jun 2020 01:32:12 -0400
Received: from mail-pg1-x544.google.com (mail-pg1-x544.google.com [IPv6:2607:f8b0:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 94927C061573
        for <netdev@vger.kernel.org>; Wed, 24 Jun 2020 22:32:11 -0700 (PDT)
Received: by mail-pg1-x544.google.com with SMTP id g67so1901728pgc.8
        for <netdev@vger.kernel.org>; Wed, 24 Jun 2020 22:32:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=XEX/vfFKM8Tz0AjFI4UGRCdPt+6ym7uNc96jC0XvWic=;
        b=1OwQxTofspk5kdYvArDVDTMy/TjPpReAieWI7Sk5PXTDqE02YJY0/2bxxru59FMM3B
         PBG+1hBbaLAMAyXZgYgnWn3p9xeinEz5zvBckgBNyYl7uxugLCD0GyVo7XipwVwgMyRn
         JK2/29ZovUhoxhiOd1f3FaQoE99orVlcHPHuS9r6nWVUT86Zq2o8ImZzb4INFdJ4R6wp
         zufrXY3WW08H+zdAFx2AIhkBGkDpTyTFEQZBoXzGeajsF7Rk3UzngprRedL/PSq36KiH
         dvCUMjrHyR6Ia5AFi2T8RaoH28/ybvzisYEqZj6502b8Eu0AB2ZE4/Q6eY2SgmoDtPTQ
         LIzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=XEX/vfFKM8Tz0AjFI4UGRCdPt+6ym7uNc96jC0XvWic=;
        b=hnrTv+hBGyLYdUsJuaAJnKl+Whx3iWOOh/S9gZPZ9eyZvF8eBbhVpwBciAvyNRqF1q
         GghqH2p28XvqSIshhYUxu3XKTFchwDPM8QF8O9WvSWyzOAVSgRnAU/2iWrGKreGy0Sj2
         J6guIqyQAz+XKz4d/beX5BTf6EGj0kt9HzAo2DHsH2D9rjBOdnvVf9S0Idpv0W4zPwwJ
         mOHtCk3GTCNC0yXriJ8pKf6TeV5Tneud0+cjQY7xN/7G/VsqbvRoJvh8Pa3Mq+OAOKKf
         PfWOI44t89rCcz2QVo1kg+aZ2fbfTUpBXUM0PxUSoOADD5TTVD9bIJcdFZZPVVxXoIEI
         i0OQ==
X-Gm-Message-State: AOAM532mK5i+8RBJUzHCWCpnUEsUBcykp6ncT219qTp/02pEe8iTpHbs
        uyv08D1FBW7cnX/k1h8tPMdxFQ==
X-Google-Smtp-Source: ABdhPJzxGZpFZh8WvtcGAIXOv17oWFxCXgh31lkw6+76aFTdw+qOyI/0140eyI2c/JV7WqSQYN77Pw==
X-Received: by 2002:a63:c64c:: with SMTP id x12mr24934478pgg.362.1593063130846;
        Wed, 24 Jun 2020 22:32:10 -0700 (PDT)
Received: from hermes.lan (204-195-22-127.wavecable.com. [204.195.22.127])
        by smtp.gmail.com with ESMTPSA id y136sm21948680pfg.55.2020.06.24.22.32.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Jun 2020 22:32:10 -0700 (PDT)
Date:   Wed, 24 Jun 2020 22:32:02 -0700
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Michal Kubecek <mkubecek@suse.cz>, netdev <netdev@vger.kernel.org>,
        Chris Healy <cphealy@gmail.com>
Subject: Re: [ethtool v2 3/6] json_writer: Import the iproute2 helper code
 for JSON output
Message-ID: <20200624223202.6ddc891f@hermes.lan>
In-Reply-To: <20200625001244.503790-4-andrew@lunn.ch>
References: <20200625001244.503790-1-andrew@lunn.ch>
        <20200625001244.503790-4-andrew@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 25 Jun 2020 02:12:41 +0200
Andrew Lunn <andrew@lunn.ch> wrote:

> In general, Linux network tools use JSON for machine readable output.
> See for example -json for iproute2 and devlink. In order to support
> JSON output from ethtool, import the iproute2 helper code.
> 
> Maybe some time in the future it would make sense to either have a
> shared library, or to merge ethtool into the iproute2 source
> distribution?
> 
> Signed-off-by: Andrew Lunn <andrew@lunn.ch>

LGTM

Acked-by: Stephen Hemminger <stephen@networkplumber.org>

A shared library is hard to version and gets to be a chore.
