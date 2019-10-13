Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C0D58D57B6
	for <lists+netdev@lfdr.de>; Sun, 13 Oct 2019 21:21:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729509AbfJMTV1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 13 Oct 2019 15:21:27 -0400
Received: from mail-pf1-f196.google.com ([209.85.210.196]:38873 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728982AbfJMTV1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 13 Oct 2019 15:21:27 -0400
Received: by mail-pf1-f196.google.com with SMTP id h195so9120118pfe.5;
        Sun, 13 Oct 2019 12:21:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=oHK/IbtLtLd0Mg7pLkpjOllfV02f4vtvzFxGoOp6RpE=;
        b=valD4oTADEY+j55I6B/KvTUuuY2Ro615SOGtX5bZxpO/SYNDj9i8xS1bwlOBet9YzF
         Qx51g6x47P7LtcwtYXfoXXAf5FixapJ+CnPdJGtru+7agwb25OYJ+37J0j6wHvv9R0B1
         qwM3AUJAQGdV5bw1MB2zKdWNLL7im9nLZ7tKI8AOf9ozBs9sp8gpGdCFS2GeGeLmu+Gt
         5wvDIVTTuhK1VYuJmhOuTsZnTBumkuOlYMsGOXa56l1ZEwT447U+Y5UdFu1bsM691JQR
         2P9WDRK9xvv+7pNCqCsDncufe0SjV1lsoFcTFU+02imBb5m9k8M2x45TIS8SLq1L+F49
         /Ssw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=oHK/IbtLtLd0Mg7pLkpjOllfV02f4vtvzFxGoOp6RpE=;
        b=Dccd/LXIUM0k5e53HIuqArUhpMWu+b+T7ivwebxJm2X5yLDs2bbZ1ATTbY8dz9FC8e
         VrGI3SmxNJhCoZjPySc0ZROgwT3B2DCwIq3MXnuilLvsf3o0VCMsoOnUSoe/oIfX9iBB
         x7uxeLhylW9LiCVxCOFGm8Ru1w92XNSyrMt1cTuH3/8vG/DOE1DrS+hO2EGvfAGZiws7
         aA9EmNBClfnjp6adHon1mCSyDuY18M9lLlPXQYX1YIibUJokWzNL43KliTeEeNGHbz/j
         0q4oX+L8HlrN+UahYbjRP0skGKreOnBJo+JzkOnMJUnnNcu1OIztR6aXHOgFCW9lXGSV
         cL3Q==
X-Gm-Message-State: APjAAAUneRESKJN0hJnwB45Cj7qwAmoHBJ0i7ecsofn8MkFYmS222VKm
        7SuthBCbuHXeXCGsTkSpxGX6L3iD
X-Google-Smtp-Source: APXvYqxqcyUAGHdvLmGFJ3ZiKCpImZ2fnsa5DwVHeQn6yEQkYlVENnbpkiDmBA8s14FH1IlVxQkRgw==
X-Received: by 2002:a17:90a:c406:: with SMTP id i6mr31274471pjt.98.1570994486372;
        Sun, 13 Oct 2019 12:21:26 -0700 (PDT)
Received: from [192.168.1.3] (ip68-111-84-250.oc.oc.cox.net. [68.111.84.250])
        by smtp.gmail.com with ESMTPSA id 193sm16266892pfc.59.2019.10.13.12.21.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 13 Oct 2019 12:21:25 -0700 (PDT)
Subject: Re: [PATCH] net: ethernet: broadcom: have drivers select DIMLIB as
 needed
To:     Randy Dunlap <rdunlap@infradead.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>
Cc:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        =?UTF-8?Q?Uwe_Kleine-K=c3=b6nig?= <uwe@kleine-koenig.org>,
        Tal Gilboa <talgi@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@mellanox.com>,
        Leon Romanovsky <leonro@mellanox.com>,
        Or Gerlitz <ogerlitz@mellanox.com>,
        Sagi Grimberg <sagi@grimberg.me>
References: <610f9277-adff-2f4b-1f44-8f41b6c3ccb5@infradead.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <198472c1-f584-8e17-6109-264af1328152@gmail.com>
Date:   Sun, 13 Oct 2019 12:21:23 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.2
MIME-Version: 1.0
In-Reply-To: <610f9277-adff-2f4b-1f44-8f41b6c3ccb5@infradead.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 10/11/2019 9:03 PM, Randy Dunlap wrote:
> From: Randy Dunlap <rdunlap@infradead.org>
> 
> NET_VENDOR_BROADCOM is intended to control a kconfig menu only.
> It should not have anything to do with code generation.
> As such, it should not select DIMLIB for all drivers under
> NET_VENDOR_BROADCOM.  Instead each driver that needs DIMLIB should
> select it (being the symbols SYSTEMPORT, BNXT, and BCMGENET).
> 
> Link: https://lkml.kernel.org/r/alpine.DEB.2.21.1907021810220.13058@ramsan.of.borg/
> 
> Fixes: 4f75da3666c0 ("linux/dim: Move implementation to .c files")
> Reported-by: Geert Uytterhoeven <geert@linux-m68k.org>
> Signed-off-by: Randy Dunlap <rdunlap@infradead.org>

Acked-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
