Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0D9EC2359D2
	for <lists+netdev@lfdr.de>; Sun,  2 Aug 2020 20:27:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727787AbgHBS1h (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 2 Aug 2020 14:27:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46000 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726920AbgHBS1f (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 2 Aug 2020 14:27:35 -0400
Received: from mail-ed1-x541.google.com (mail-ed1-x541.google.com [IPv6:2a00:1450:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2CFDFC06174A;
        Sun,  2 Aug 2020 11:27:35 -0700 (PDT)
Received: by mail-ed1-x541.google.com with SMTP id v22so14915937edy.0;
        Sun, 02 Aug 2020 11:27:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding:content-language;
        bh=ec+QZPQt4BI+HNScgjvbhAWx5U5Q2eYvCkS354frzh0=;
        b=YtJLT8D3c903d3hsfGfmpRep4DyZJhzRytGWo/UssPWnsu4TDB7JZAkT1sTJMmJUH+
         bq5rDlN4QtT+Xdj0JNzjtQ2QqTr2pVyC4JOlcnf9bRRCSyXgovVOl9FdgJQfsiPfkKzY
         DWsX6GX1lxDOlwpnwJCtIh+GQ6RZkI/pzRvVJxUc5FGTjx+jay8s+7hZFlw796rU78Gc
         7K1ApoysPqm8FRM+jQOGIRHengeFZ6xNP8mOw9mf8ONnQV8kOLpUVEJO7EpYgXqjQKbR
         ZXY6Otij2DqA3PujrgbIOxTi9tcd/lHDFFPdppv1+HoL/eGjvY6ERK9eoJvC1OZ061lc
         FmqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=ec+QZPQt4BI+HNScgjvbhAWx5U5Q2eYvCkS354frzh0=;
        b=K83uV3irkoUMjiaYGxaIKS/7/Xhw9LmAzT7GEm14xlebX6o+ahYRqHbiMaUg91zym0
         HOCPVuhQFvtyGr5sKMZ3VhY5avZJ3J0dVI3uEXdHfVHfig8ldeOikWvKCM8+E1bnUje6
         G/2FKjqgmGFDuSn2GyziNsKTy4iraIy9TOXl3SKC+PujmY1oSm/6HcRfncJ6C8YW2FGY
         Km/qhgofMmzTdBnhcOEh0R4V9pXI8vWWXUC2khNhxez7M0PSfQyiK6llzGQ952ESzuXB
         ZusXTc+b95kxkHR72i9XG/IoQU3EUle4GttbIa1qAAdfKtjMbvTDrCQrParNiHz1fCFS
         yGeQ==
X-Gm-Message-State: AOAM532cCpjZiyS08P3ApXbDPMB2E+dwfN+U5Qy7ScIzWByrjx7/CRnq
        Tr3hLoPvYHymHVvS49nNY94=
X-Google-Smtp-Source: ABdhPJzPSVl/d4yXQb9tARqdTsGpw8tzteKDCnrRiPQdt2yWNobLwsKDJ8Loc5jmq7ZA1MaLrCqHCQ==
X-Received: by 2002:aa7:c9c2:: with SMTP id i2mr12251380edt.326.1596392853909;
        Sun, 02 Aug 2020 11:27:33 -0700 (PDT)
Received: from net.saheed (95C84E0A.dsl.pool.telekom.hu. [149.200.78.10])
        by smtp.gmail.com with ESMTPSA id b9sm2015326ejz.57.2020.08.02.11.27.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 02 Aug 2020 11:27:33 -0700 (PDT)
Subject: Re: [RFC PATCH 00/17] Drop uses of pci_read_config_*() return value
To:     Borislav Petkov <bp@alien8.de>, trix@redhat.com
Cc:     helgaas@kernel.org, Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Wolfgang Grandegger <wg@grandegger.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Miquel Raynal <miquel.raynal@bootlin.com>,
        Richard Weinberger <richard@nod.at>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        Joerg Roedel <joro@8bytes.org>, bjorn@helgaas.com,
        skhan@linuxfoundation.org,
        linux-kernel-mentees@lists.linuxfoundation.org,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-mtd@lists.infradead.org, iommu@lists.linux-foundation.org,
        linux-rdma@vger.kernel.org, linux-ide@vger.kernel.org,
        linux-i2c@vger.kernel.org, linux-hwmon@vger.kernel.org,
        dri-devel@lists.freedesktop.org, intel-gfx@lists.freedesktop.org,
        linux-gpio@vger.kernel.org, linux-fpga@vger.kernel.org,
        linux-edac@vger.kernel.org, dmaengine@vger.kernel.org,
        linux-crypto@vger.kernel.org,
        linux-atm-general@lists.sourceforge.net
References: <20200801112446.149549-1-refactormyself@gmail.com>
 <20200801125657.GA25391@nazgul.tnic>
From:   Saheed Bolarinwa <refactormyself@gmail.com>
Message-ID: <b720aa44-895a-203b-e220-ecdb3acd9278@gmail.com>
Date:   Sun, 2 Aug 2020 19:28:00 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <20200801125657.GA25391@nazgul.tnic>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 8/1/20 2:56 PM, Borislav Petkov wrote:
> On Sat, Aug 01, 2020 at 01:24:29PM +0200, Saheed O. Bolarinwa wrote:
>> The return value of pci_read_config_*() may not indicate a device error.
>> However, the value read by these functions is more likely to indicate
>> this kind of error. This presents two overlapping ways of reporting
>> errors and complicates error checking.
> So why isn't the *value check done in the pci_read_config_* functions
> instead of touching gazillion callers?
Because the value ~0 has a meaning to some drivers and only
drivers have this knowledge. For those cases more checks will
be needed to ensure that it is an error that has actually
happened.
> For example, pci_conf{1,2}_read() could check whether the u32 *value it
> just read depending on the access method, whether that value is ~0 and
> return proper PCIBIOS_ error in that case.

The primary goal is to make pci_config_read*() return void, so
that there is *only* one way to check for error i.e. through the
obtained value.
Again, only the drivers can determine if ~0 is a valid value. This
information is not available inside pci_config_read*().

- Saheed

