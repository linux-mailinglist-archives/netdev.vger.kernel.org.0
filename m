Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4A744DCFC8
	for <lists+netdev@lfdr.de>; Fri, 18 Oct 2019 22:11:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2395071AbfJRULY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Oct 2019 16:11:24 -0400
Received: from mail-pl1-f193.google.com ([209.85.214.193]:33753 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2394929AbfJRULY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Oct 2019 16:11:24 -0400
Received: by mail-pl1-f193.google.com with SMTP id d22so3379804pls.0
        for <netdev@vger.kernel.org>; Fri, 18 Oct 2019 13:11:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version;
        bh=hXUeQfCFjejlaHZu4j61RpghIvgOB4WRWnuljxk2Kn8=;
        b=POM8eRUbehASp8K7IG+smVSOyVDscUaCWV4uW3SxBmdx4hwVYjtHevuOWs1G5yua5D
         rpdQwmiPTabIHsGxroqCbMfYyPZhIFyY7yYNp+zfCfRM2YUeTOmVqj1OHzVy11SnYpHw
         cxS9gwyBm1KGHEggJeRIfrsBb0Jz/XylClarHfl81+6HscbPtlEzq+O0/duD1XaG62M3
         XWDSUQYD4kgkHXeAjeNQWBpqJQY6eIA8veRsJC0uKxISaUNxg/wgat9rFZezxfsmBXeL
         7MqY1430RD8Hmv/YXKlDTaWF5QzQwdvigRdbFUzl7VhQ5BC0ZN7cel+fGsbpscsBA0Or
         XrHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version;
        bh=hXUeQfCFjejlaHZu4j61RpghIvgOB4WRWnuljxk2Kn8=;
        b=BRoS6gJduLPlbNXlOPAof/otIyrmXYxCvVQTpiwVO/cAPA5punXP/abQ9XHPcXl3zL
         VS1ZQ4ybbISY8K0sr/JhM+FwKFY4vHeYtHqqlSvS2c3kLB7m15J06t6jBE+UGkimlv90
         wvJgMBc85seSeoecLGlXvN4zxKVHts2StGZI0INZjnp3mwrAkSvksXAkmuvyZqWuQ6YB
         uEMkV8mXFsJ3IbTpYM9vxpQvIqWBuzd/53C/4J13/Vpo/4DX7vAZlOuzlOqX0loZat1N
         EFlW2lLPVSO62t5zrji06SE321wwAkzXu4vzGLCIjgt5m+Gt3hK5zos1HBsCtnuw82hk
         9XjA==
X-Gm-Message-State: APjAAAVg/2xDyIBtrNkHtA8h4K3qSPYNFYSCks0CjpCLzBA6+2XD/s7w
        eY/oCkrgWfMdLo2oXoeAK74=
X-Google-Smtp-Source: APXvYqxmmz5NuZBf93317xOjUWNLAGUUmTQpgBhI8lEUgsoDaz9obveI7Q3lLX9XFpotIpZ3K4prnQ==
X-Received: by 2002:a17:902:bcc2:: with SMTP id o2mr11989826pls.281.1571429014110;
        Fri, 18 Oct 2019 13:03:34 -0700 (PDT)
Received: from [172.20.162.151] ([2620:10d:c090:180::d0dd])
        by smtp.gmail.com with ESMTPSA id w134sm8198376pfd.4.2019.10.18.13.03.32
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 18 Oct 2019 13:03:33 -0700 (PDT)
From:   "Jonathan Lemon" <jonathan.lemon@gmail.com>
To:     "Jakub Kicinski" <jakub.kicinski@netronome.com>
Cc:     brouer@redhat.com, ilias.apalodimas@linaro.org,
        saeedm@mellanox.com, tariqt@mellanox.com, netdev@vger.kernel.org,
        kernel-team@fb.com
Subject: Re: [PATCH 01/10 net-next] net/mlx5e: RX, Remove RX page-cache
Date:   Fri, 18 Oct 2019 13:03:32 -0700
X-Mailer: MailMate (1.13r5655)
Message-ID: <45D9EEE8-9196-43B4-B2EB-2269CE9EAAF6@gmail.com>
In-Reply-To: <20191016183018.62121bdf@cakuba.netronome.com>
References: <20191016225028.2100206-1-jonathan.lemon@gmail.com>
 <20191016225028.2100206-2-jonathan.lemon@gmail.com>
 <20191016183018.62121bdf@cakuba.netronome.com>
MIME-Version: 1.0
Content-Type: text/plain; markup=markdown
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 16 Oct 2019, at 18:30, Jakub Kicinski wrote:

> On Wed, 16 Oct 2019 15:50:19 -0700, Jonathan Lemon wrote:
>> From: Tariq Toukan <tariqt@mellanox.com>
>>
>> Obsolete the RX page-cache layer, pages are now recycled
>> in page_pool.
>>
>> This patch introduce a temporary degradation as recycling
>> does not keep the pages DMA-mapped. That is fixed in a
>> downstream patch.
>>
>> Issue: 1487631
>
> Please drop these Issue identifiers.
>
>> Signed-off-by: Tariq Toukan <tariqt@mellanox.com>
>>
>
> And no empty lines between tags.
>
>> Signed-off-by: Jonathan Lemon <jonathan.lemon@gmail.com>

Will fix.
-- 
Jonathan
