Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 55D7ED8023
	for <lists+netdev@lfdr.de>; Tue, 15 Oct 2019 21:24:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731988AbfJOTX7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Oct 2019 15:23:59 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:54185 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730839AbfJOTX7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Oct 2019 15:23:59 -0400
Received: by mail-wm1-f68.google.com with SMTP id i16so274328wmd.3
        for <netdev@vger.kernel.org>; Tue, 15 Oct 2019 12:23:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=sGIf1A0kMtMnaW4pOlmzIuINChMCw+EoGElWJi8OM/Y=;
        b=RYS+rUjs8n1SAm+EKr6ITzHclq8uS0tk2bNEF8hL7qChdRjtdm8bSyI+TOw7IL20Zz
         +m3QwFIOz3vwxlIpqXtVvQofTHRAdkhZa08KA1dBKD+ySwqO9vLdcvTYkgfRKVvkfR5F
         nu94op6DRtVwOihEgY25yO9AoEfNGCFpMsaOWOz5H0e86TSWYr0VK6Vp1cNdSCiLbQ3k
         OoMTfL9liDolQytEm9fAAPWoViG/4QQpvQiQGlG4sJS2Rqzc8hNhuF2wfuzg9zdil3Os
         R68rWhpgmDj3CXS1+mnpb1sw7CF8qQUvaBvxS7NBWp5UO4PbV0FQH3esl0ffiC3AJkvL
         jEmg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=sGIf1A0kMtMnaW4pOlmzIuINChMCw+EoGElWJi8OM/Y=;
        b=YNEIehTL/iWz3uZ6QyjnFPawhToJK/tOH/DkxCZXY7RMGhi7cWa6KaWKyCuN+X7DSE
         ELjHlmHsjvduWd7ThvxEUchRLqWs/8c9ppJJ7z4EUTq4QOqGnRms4kzZvxuTkYwGEQRz
         VkaIXzFd7PpHeMLO7crV4xGzgGKx3d5NZNR+lCHiDJev7uTYfpmgS8msDe9JNadZnKAy
         xQQWI4gDKCMWMiiHx+gFbrbUw56waVCJoQZxLKQhPv98pmKL+p32g6e4njOAuav/gRs3
         e90JFTMaVq9P36+B40Y+Q/6c8S2ik8gFztMfSeVmJQx6oE+w0F/FgljSq2EAo8vVjwyw
         YdfA==
X-Gm-Message-State: APjAAAVlnsi+JtqxjyaSt7XHCZGLcgAPjH1HT8+s/y0HztyjLhKZ1r+c
        BcGcUsRjCJklnsZ97/FCDRS7Ag==
X-Google-Smtp-Source: APXvYqyuIZCpxcHjHSu2akPqvtD9M3f4BwzEOSMCJdAW/wBj5T4UUF7iJgW8CIdRFdevy/qFfKy9RQ==
X-Received: by 2002:a7b:cf28:: with SMTP id m8mr96679wmg.161.1571167437483;
        Tue, 15 Oct 2019 12:23:57 -0700 (PDT)
Received: from cakuba.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id u10sm167418wmm.0.2019.10.15.12.23.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Oct 2019 12:23:57 -0700 (PDT)
Date:   Tue, 15 Oct 2019 12:23:49 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Thomas Bogendoerfer <tbogendoerfer@suse.de>
Cc:     Jonathan Corbet <corbet@lwn.net>,
        Ralf Baechle <ralf@linux-mips.org>,
        Paul Burton <paul.burton@mips.com>,
        James Hogan <jhogan@kernel.org>,
        Lee Jones <lee.jones@linaro.org>,
        "David S. Miller" <davem@davemloft.net>,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        Alessandro Zummo <a.zummo@towertech.it>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.com>, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-mips@vger.kernel.org,
        netdev@vger.kernel.org, linux-rtc@vger.kernel.org,
        linux-serial@vger.kernel.org
Subject: Re: [PATCH v10 4/6] mfd: ioc3: Add driver for SGI IOC3 chip
Message-ID: <20191015122349.612a230b@cakuba.netronome.com>
In-Reply-To: <20191015120953.2597-5-tbogendoerfer@suse.de>
References: <20191015120953.2597-1-tbogendoerfer@suse.de>
        <20191015120953.2597-5-tbogendoerfer@suse.de>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 15 Oct 2019 14:09:49 +0200, Thomas Bogendoerfer wrote:
> SGI IOC3 chip has integrated ethernet, keyboard and mouse interface.
> It also supports connecting a SuperIO chip for serial and parallel
> interfaces. IOC3 is used inside various SGI systemboards and add-on
> cards with different equipped external interfaces.
> 
> Support for ethernet and serial interfaces were implemented inside
> the network driver. This patchset moves out the not network related
> parts to a new MFD driver, which takes care of card detection,
> setup of platform devices and interrupt distribution for the subdevices.
> 
> Serial portion: Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Acked-for-MFD-by: Lee Jones <lee.jones@linaro.org>
> 
> Signed-off-by: Thomas Bogendoerfer <tbogendoerfer@suse.de>

Looks good, I think.
