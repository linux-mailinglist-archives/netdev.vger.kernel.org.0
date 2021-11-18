Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E0AF4456463
	for <lists+netdev@lfdr.de>; Thu, 18 Nov 2021 21:38:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233650AbhKRUlS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Nov 2021 15:41:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44880 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231732AbhKRUlS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Nov 2021 15:41:18 -0500
Received: from mail-pf1-x42f.google.com (mail-pf1-x42f.google.com [IPv6:2607:f8b0:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 196F3C061574
        for <netdev@vger.kernel.org>; Thu, 18 Nov 2021 12:38:18 -0800 (PST)
Received: by mail-pf1-x42f.google.com with SMTP id o4so7189423pfp.13
        for <netdev@vger.kernel.org>; Thu, 18 Nov 2021 12:38:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20210112.gappssmtp.com; s=20210112;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=912Y1SOnk0mg+ocf1iKls//NzpM9rMW1Oh0yIxKIf8w=;
        b=B/LkooJ06tSSGm+tJH/qn9YNO4TdO4GiMnQfZ40BpsMOtaOeehKJvwMLKf/dPNvXil
         J8oUXRw+qiOe4fJCiI1vtTQUayLL6q8VaC/fJV06tVPoFNGwNQxFaWHjFKnPswXaF7N+
         tou2kVa7jUGU2yGUd1JVVClxLSiD0d+59cuyrtPL5zlcBtMjXAaK8ljfj4hZlWXUbeJU
         cJ6P6oZeeJGC2a1M2SSMX04vPWectPP8Niu9n5/eDXHUIgj9fEmyJJ/AFWHypkrQ0Sin
         3WP3zwNzI14EGbZ/1VLSEFimkJyzwsdRqgO4H9v9ZF+DBZMWX9Wvs0pBccuKdhsKJbbn
         jTLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=912Y1SOnk0mg+ocf1iKls//NzpM9rMW1Oh0yIxKIf8w=;
        b=azFnPkLLdNnc2gsLjDKCOn+8aHefcuMcbjIRLN2Xhslnp89EvYbsNDU+P11ZfAgg0k
         pnyblX1TI3EGa2ZgQRlzvF6gKPI+vOugtcjpF1KmVSj/UXI2bMpCf4P28kmhMJ1s+bbH
         /j0R6OXDJGOWsB3QGkwRPyJnquI8/7E6H7xLV+nUaNGmRcwUkCeFcjTm2HxK/sB0slA/
         GmnA0T4DAkW3O3/ARQK8KQCbGTJrIIOlWEIwv9hLIkkvs84uAPVoUKE5Zk3E/I7ktagy
         qxzxCFchYStijIyZmm6x0Oq8tsb6VcNUz8/VpfVMhSPTi5lH3+UNzJecZfOoCd69YTCQ
         80yg==
X-Gm-Message-State: AOAM530mqDH7ecw2mDWW6/yluz9otPlgwP0fwxvQuffTiGkpsuL12QpE
        znXhLxOWOvIFWAuIhOaQPsJNnFHcqcN8gg==
X-Google-Smtp-Source: ABdhPJwDLW+m3+ARpfky4PCQopGyrcl4tl+xx4uUa1RAXtKNV8LhPXobLjW4YnteDRiOVnYiDDxTwA==
X-Received: by 2002:a05:6a00:244d:b0:44d:c279:5155 with SMTP id d13-20020a056a00244d00b0044dc2795155mr17411404pfj.0.1637267897573;
        Thu, 18 Nov 2021 12:38:17 -0800 (PST)
Received: from hermes.local (204-195-33-123.wavecable.com. [204.195.33.123])
        by smtp.gmail.com with ESMTPSA id l21sm9199092pjt.24.2021.11.18.12.38.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Nov 2021 12:38:17 -0800 (PST)
Date:   Thu, 18 Nov 2021 12:38:13 -0800
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Heiner Kallweit <hkallweit1@gmail.com>
Cc:     Mirko Lindner <mlindner@marvell.com>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH net-next] sky2: use PCI VPD API in eeprom ethtool ops
Message-ID: <20211118123813.2f11dcac@hermes.local>
In-Reply-To: <a12724c0-2aba-3d3c-358d-a26e0c73eb38@gmail.com>
References: <a12724c0-2aba-3d3c-358d-a26e0c73eb38@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 18 Nov 2021 21:04:23 +0100
Heiner Kallweit <hkallweit1@gmail.com> wrote:

> Recently pci_read/write_vpd_any() have been added to the PCI VPD API.
> These functions allow to access VPD address space outside the
> auto-detected VPD, and they can be used to significantly simplify the
> eeprom ethtool ops.
> 
> Tested with a 88E8070 card with 1KB EEPROM.
> 
> Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
> ---

Looks like a good idea. I don't have sky2 hardware in a system anymore.

Reviewed-by: Stephen Hemminger <stephen@networkplumber.org>
