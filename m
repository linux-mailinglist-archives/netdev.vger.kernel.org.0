Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 505AA72028
	for <lists+netdev@lfdr.de>; Tue, 23 Jul 2019 21:36:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388808AbfGWTgD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Jul 2019 15:36:03 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:34371 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725468AbfGWTgD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Jul 2019 15:36:03 -0400
Received: by mail-wm1-f68.google.com with SMTP id w9so31813302wmd.1
        for <netdev@vger.kernel.org>; Tue, 23 Jul 2019 12:36:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=HnWyeIg8cplH1KLgxVMcxlFG4peGAYs8DxqRy//LOQ4=;
        b=lskDqCcWpEM8J2J1xfrtg11zMkLgxUcOho/R62VN7kMwDPp8AIoV1UgLDHI0cQgBYv
         dVzCOw4qIi5wi89VQGgUEYBTFptjqlVC4h2UZ0vaZSxvermsDbJ3dmSDg9DyQfkBaSzJ
         VO6b0fhZaV/oX/SyrB84ABDXwuy1cATw2xTeQNX9MMzb6H0hH4lHWzTFVlQPvx704mcp
         nRd1Ztp1IMsn1RwAOMdSSbe9vkUl5r1uwZvEwRWDIRNcanovPwzFJuiyXac8YWJ+nPRC
         ZSnSEZdUKULeA2QGeRRIwgvMajBLgLBVJbxDEoGegCj/4ATaouDRl6IjgCMz4t52Ws0O
         i2eg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=HnWyeIg8cplH1KLgxVMcxlFG4peGAYs8DxqRy//LOQ4=;
        b=myNR2Bmt6PZhruxlIgpLpvc9R+vV3YO0ojm3xkFjVorQ8PZAldUbf8rxlrFnRu9FKp
         K0Ys1fMpmyKdwQH4iYiy+CpurS0V/fvgFOVMx54jiKRe7WvWPPq+FfCGtLeSzcjj4Pcv
         wyZveY0nAAgc/ErsUewSq8Pp7WyW+PM/Rns8lOQrdx594UWRL53duP8e7WrB/T+tqxoC
         UVOPlrw2EJ/tTOLl5cWCVVlJYId/UnCQ5NNlDfOWMf0clWW47WxWmQQ7ay/irjhpAH+C
         vGypUA9FaSSDdeuAgT9n6KUyn6uI03jLZwhVVYS2kuCfOAVheC/GGzX7LSWvx1iLVevB
         SyHg==
X-Gm-Message-State: APjAAAX1YSrg59Wta4iWUpS1n4w8LETSAs0G2eqvS5skIJ5SkqgPreiM
        RClrB/hBuq1TPwluAgu8eOg=
X-Google-Smtp-Source: APXvYqxiog4TEDoXQUws1sOxeVG4xJpNhudwfZitL+/WQtTTCJOmgR8VNKMgubvsN9RMACRhZXilNQ==
X-Received: by 2002:a05:600c:2111:: with SMTP id u17mr49552240wml.64.1563910561515;
        Tue, 23 Jul 2019 12:36:01 -0700 (PDT)
Received: from localhost (jirka.pirko.cz. [84.16.102.26])
        by smtp.gmail.com with ESMTPSA id n9sm83253991wrp.54.2019.07.23.12.36.00
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Tue, 23 Jul 2019 12:36:01 -0700 (PDT)
Date:   Tue, 23 Jul 2019 21:36:00 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     Stephen Hemminger <stephen@networkplumber.org>
Cc:     netdev@vger.kernel.org, sthemmin@microsoft.com, dsahern@gmail.com,
        alexanderk@mellanox.com, mlxsw@mellanox.com
Subject: Re: [patch iproute2 1/2] tc: action: fix crash caused by incorrect
 *argv check
Message-ID: <20190723193600.GA2315@nanopsycho.orion>
References: <20190723112538.10977-1-jiri@resnulli.us>
 <20190723105401.4975396d@hermes.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190723105401.4975396d@hermes.lan>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Tue, Jul 23, 2019 at 07:54:01PM CEST, stephen@networkplumber.org wrote:
>On Tue, 23 Jul 2019 13:25:37 +0200
>Jiri Pirko <jiri@resnulli.us> wrote:
>
>> From: Jiri Pirko <jiri@mellanox.com>
>> 
>> One cannot depend on *argv being null in case of no arg is left on the
>> command line. For example in batch mode, this is not always true. Check
>> argc instead to prevent crash.
>> 
>> Reported-by: Alex Kushnarov <alexanderk@mellanox.com>
>> Fixes: fd8b3d2c1b9b ("actions: Add support for user cookies")
>> Signed-off-by: Jiri Pirko <jiri@mellanox.com>
>
>Actually makeargs does NULL terminate the last arg so what input
>to batchmode is breaking this?

Interesting, there must be another but out there then.

My input is:
filter add dev testdummy parent ffff: protocol all prio 11000 flower action drop
filter add dev testdummy parent ffff: protocol ipv4 prio 1 flower dst_mac 11:22:33:44:55:66 action drop
