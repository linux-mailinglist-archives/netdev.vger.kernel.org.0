Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D0CC4E0B85
	for <lists+netdev@lfdr.de>; Tue, 22 Oct 2019 20:36:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387983AbfJVSgZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Oct 2019 14:36:25 -0400
Received: from mail-lf1-f65.google.com ([209.85.167.65]:38498 "EHLO
        mail-lf1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387932AbfJVSgZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Oct 2019 14:36:25 -0400
Received: by mail-lf1-f65.google.com with SMTP id q28so10676040lfa.5
        for <netdev@vger.kernel.org>; Tue, 22 Oct 2019 11:36:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=LjHIWXCG/lggGmh2jkHok/UuaKKS+LrI78ohPfifSgE=;
        b=hZNqyYmGsdzJWTb5bmxTDZORcYMq+2jK/+4fhqKatMhqfH+0fedsTLFbvYEFWr14kl
         Sbd8Ofnz2lBxtrMw+1J4uNvvaE8OUhzes0+n5rL/H0efunLohAh8gtA97bScxq7qgvfx
         /MqtHD6bmZNtTG4mdavx2zbH7tOIuI4YiI+U+auF8JF8bUu6ysI1xXMubN8RwfEdbVyq
         LfTlF8LnZXMeGzExtDGE+S7udsoiaTl0NYqDV32aLaXelfkEDezfdynNy3SK333fmG3M
         lqaDO72gB8ypN6TXZtPOkC9mlRtaSX3KgFz6Ensq4HAGXnmlb6YE68FgOfUkKSs8weLY
         72+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=LjHIWXCG/lggGmh2jkHok/UuaKKS+LrI78ohPfifSgE=;
        b=TfAQTRYrj89v96Xic7oalEMPqErsE6J5AxcuXkVCms9amXY6S7PEJS7lVP3uBUUVFE
         3wNuXtubq9LBzEUls3BNA7z4GlfOEmjJvaNw6sF9mBhIjMhJuODvD6LDz3Q09l7AXBwg
         6PacOi2Z6/5nOrX0GCwR6agPVIYllXaUBJ+wlkuX8T4agDWW/tu+xyFf9zx/oQ9JLPAa
         kQywbUfDQhGFOem3150ke4zIqOaIZerzBq1LcaJ4nIRE7Lkbe7riWLFbgHoK3ynvdse9
         IOWET+gOj37bXyO1csE6MbVe9F+6pl+PQIYS87TQG0/JOidKK9iyDCXLTLQB2iPIpgcu
         +5Jg==
X-Gm-Message-State: APjAAAWXZ/Lu0HRrAbftVlcBke2B56l39vPCeOCyDQpn52jK7ObsSyGG
        ae43i7xioSgue6Kr7f1yRriDjKBTaxQ=
X-Google-Smtp-Source: APXvYqxUtnI0nNKV+M1AVtNvY2gdUHByhTKz2Jo8YUYdZOnWciaua4dE1pDdW8FWH+CcGOvIGIGOsQ==
X-Received: by 2002:a19:ac04:: with SMTP id g4mr19893096lfc.63.1571769383149;
        Tue, 22 Oct 2019 11:36:23 -0700 (PDT)
Received: from cakuba.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id j2sm8279883lfb.77.2019.10.22.11.36.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Oct 2019 11:36:22 -0700 (PDT)
Date:   Tue, 22 Oct 2019 11:36:17 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Heiner Kallweit <hkallweit1@gmail.com>
Cc:     Realtek linux nic maintainers <nic_swsd@realtek.com>,
        David Miller <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH net-next 0/4] r8169: remove fiddling with the PCIe max
 read request size
Message-ID: <20191022113617.3c5c4dfc@cakuba.netronome.com>
In-Reply-To: <c4f2e4fc-9cbe-2ba1-b0b2-1e734032b550@gmail.com>
References: <c4f2e4fc-9cbe-2ba1-b0b2-1e734032b550@gmail.com>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 21 Oct 2019 21:21:23 +0200, Heiner Kallweit wrote:
> The attempt to improve performance by changing the PCIe max read request
> size was added in the vendor driver more than 10 years back and copied
> to r8169 driver. In the vendor driver this has been removed long ago.
> Obviously it had no effect, also in my tests I didn't see any
> difference. Typically the max payload size is less than 512 bytes
> anyway, and the PCI core takes care that the maximum supported value
> is set. So let's remove fiddling with PCIe max read request size from
> r8169 too. This change allows to simplify the driver in the subsequent
> three patches of this series.

Applied, thanks!
