Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 771513BC3FA
	for <lists+netdev@lfdr.de>; Tue,  6 Jul 2021 01:02:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232079AbhGEXEy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Jul 2021 19:04:54 -0400
Received: from mail-lf1-f50.google.com ([209.85.167.50]:40918 "EHLO
        mail-lf1-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230086AbhGEXEx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Jul 2021 19:04:53 -0400
Received: by mail-lf1-f50.google.com with SMTP id q18so34888760lfc.7;
        Mon, 05 Jul 2021 16:02:14 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=opgV/1dSlT5CgMY/0CX/nuPAXjFoizd2I+M4agkbai8=;
        b=aacaY3uXF9YeLBtCIsBw+EklE1UXjgU7ft83ao55sRJvTxglzxZcO9SOVDeCmYuaxJ
         mPOX6GqdbTV4VqC08F8vOV3bnxK752515yU/kHKhC9+nZ2JOqPr/Zo0S5wl9GJ4zyKgb
         F4mB10nm3zGffjLZsno9SOIHk9mgLoikhM+VC8AwGwD9uRHXVgdHY2X/0JLm2iDhUog8
         PVsvAG88REDJIEndk/u5zFtWsl6kdp/i1mbfCNQzYgho27DHF6H7eNvVzF4Ulp3+dfq9
         XLsLaE34DYM4Xk02kPBgsrTOJl4E2SHSEuqrD8Bwk0kvTb7BAZaHayNgqCnwZRqOS3Et
         JbUA==
X-Gm-Message-State: AOAM530bs74MrMh+1NYg6EZcq7jR6WwB899OSY8gSaF81fPca6pJlpWw
        AnjcdgDBMXmEw1slyaF1b1M=
X-Google-Smtp-Source: ABdhPJxGcdoMlt+O4KlMPB6m89KUIwV/UznGIwolBu//VdjxQJJ6rv4GIHsixITGAHepa6Y807nsfQ==
X-Received: by 2002:a05:6512:238b:: with SMTP id c11mr4669725lfv.548.1625526133811;
        Mon, 05 Jul 2021 16:02:13 -0700 (PDT)
Received: from rocinante ([95.155.85.46])
        by smtp.gmail.com with ESMTPSA id s21sm1208097lfc.249.2021.07.05.16.02.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 Jul 2021 16:02:13 -0700 (PDT)
Date:   Tue, 6 Jul 2021 01:02:12 +0200
From:   Krzysztof =?utf-8?Q?Wilczy=C5=84ski?= <kw@linux.com>
To:     Pali =?utf-8?B?Um9ow6Fy?= <pali@kernel.org>
Cc:     Aaron Ma <aaron.ma@canonical.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        jesse.brandeburg@intel.com, anthony.l.nguyen@intel.com,
        davem@davemloft.net, kuba@kernel.org,
        intel-wired-lan@lists.osuosl.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        Marek =?utf-8?B?QmVow7pu?= <kabel@kernel.org>
Subject: Re: [PATCH 1/2] igc: don't rd/wr iomem when PCI is removed
Message-ID: <20210705230212.GC142312@rocinante>
References: <20210702045120.22855-1-aaron.ma@canonical.com>
 <20210704142808.f43jbcufk37hundo@pali>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20210704142808.f43jbcufk37hundo@pali>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Pali,

[...]
> Aaron: can you check if pci_dev_is_disconnected() is really something
> which should be used and it helps you?

While having a closer look, I've noticed that quite a few of the network
drivers handle this somewhat, as I see that a lot of them have some sort
of I/O error handles set where a check for "pci_channel_io_perm_failure"
seem to be having place.  This is also true for this driver looking at
the igc_io_error_detected().

Is this not working for the igc driver?  Or is this for something
completely different?

Having said all that, I am not an expert in network drivers, so pardon
me if I am asking about something completely different, and I apologise
if that is the case.

> Bjorn, Krzysztof: what do you think about lifting helper function
> pci_dev_is_disconnected() to be available to all drivers and not only in
> PCI subsystem?

No objections from me, if we believe it's useful and that it might
encourage people to use a common API.  Currently, I can see at least
five potential users of this helper.

	Krzysztof
