Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4E58B285463
	for <lists+netdev@lfdr.de>; Wed,  7 Oct 2020 00:17:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727006AbgJFWRr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Oct 2020 18:17:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51482 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726137AbgJFWRq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Oct 2020 18:17:46 -0400
Received: from mail-pg1-x543.google.com (mail-pg1-x543.google.com [IPv6:2607:f8b0:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA11FC061755
        for <netdev@vger.kernel.org>; Tue,  6 Oct 2020 15:17:46 -0700 (PDT)
Received: by mail-pg1-x543.google.com with SMTP id n9so102972pgf.9
        for <netdev@vger.kernel.org>; Tue, 06 Oct 2020 15:17:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=CNukoQ1wOViIkD8xDgafWXUletYdOlid3LX9recub/0=;
        b=IJf0tTNAuVgmtW0Nj7jQ7X4bMYesAxwzpk4DE8TNWpiZeHPXEZkMKJJYmY0i03gTuI
         PXoClZOog8FCJmpJ+7x/m5XhNKJeHRMKVXmXGTD6GBSjKUHMHSUFZLFtc0vuSb9Kdf9+
         HaFK51tyHHeRcmdHy7zQQ2K0iBzkIW17gL84J52DR2nC+vJVIGCEegshEFyu++dssSRw
         t40s4UFMMM2N5dhkUydTLph5eCSuJh7pQnSmCFxeh349jjGKI1XeoB39lJOOT2usnO3/
         H1snN2nRkuNrZtUWMIuq6vKrM8BYMMJIBgl1c/Imdd4iekhyqhmncIqcGQmli0PR6Syz
         KcgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=CNukoQ1wOViIkD8xDgafWXUletYdOlid3LX9recub/0=;
        b=mnHpukkKMadsWQdJNy0F0HNfHbx6CDvq/uGnrYxj7czLUW0p/GfB0zrRu4+p8cXQBt
         l+xRb5p7QBQ7S6Tzq6R3UPk5x/fCFH2Jteislf/DPIorjCd3X9FClo+1KFVWDRJUFgGx
         W3QKsuMVP6GDSZYLJxINVkpL8/QOPoZDGy3jHMVoCO5G9mBY22cPS6IhXqdudqcLMZNq
         Djo8IiqpKfOMJauHYHS+rx9IznQN+etu8CfeXeFebeAlFuEwmgxlBEIiu2yb6DyvcqFF
         7vmz+4dKZ09cwaeDfeqrgJdpe8ovbA7xSqPCHJJNHN3jPOZkNsiTMeEY2R0jGo77InTq
         S7Xw==
X-Gm-Message-State: AOAM5320rf6/p7CcxOm0sYa6dbiTB3yyWIHizOtmnm4kCSuFHMB8kLp4
        48XMHehSyORFJo4mOalLkutiz5KFnK1AWQ==
X-Google-Smtp-Source: ABdhPJxqGAXH1cxiAn09ZLPxH3GlfDsEtJpJyvsgFsxhGn8wWBfRh99eDuyBjMmjwfnbWIe9fW9Q9g==
X-Received: by 2002:aa7:8ec7:0:b029:13e:d13d:a137 with SMTP id b7-20020aa78ec70000b029013ed13da137mr207283pfr.31.1602022666391;
        Tue, 06 Oct 2020 15:17:46 -0700 (PDT)
Received: from hermes.local (204-195-22-127.wavecable.com. [204.195.22.127])
        by smtp.gmail.com with ESMTPSA id nm11sm15489pjb.24.2020.10.06.15.17.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Oct 2020 15:17:46 -0700 (PDT)
Date:   Tue, 6 Oct 2020 15:17:38 -0700
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Adel Belhouane <bugs.a.b@free.fr>
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH] iproute2: ip addr: Fix noprefixroute and autojoin for
 IPv4
Message-ID: <20201006151738.4eb63ee4@hermes.local>
In-Reply-To: <1869e1c3-cf1e-a851-77ac-5482c694f5b3@free.fr>
References: <1869e1c3-cf1e-a851-77ac-5482c694f5b3@free.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 3 Oct 2020 16:10:05 +0200
Adel Belhouane <bugs.a.b@free.fr> wrote:

> These were reported as IPv6-only and ignored:
> 
>      # ip address add 192.0.2.2/24 dev dummy5 noprefixroute
>      Warning: noprefixroute option can be set only for IPv6 addresses
>      # ip address add 224.1.1.10/24 dev dummy5 autojoin
>      Warning: autojoin option can be set only for IPv6 addresses
> 
> This enables them back for IPv4.
> 
> Fixes: 9d59c86e575b5 ("iproute2: ip addr: Organize flag properties
> structurally")
> Signed-off-by: Adel Belhouane <bugs.a.b@free.fr>

Thanks, your patch was corrupted by mail and would not apply.
Did the same change manually and kept your SOB

