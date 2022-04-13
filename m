Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AA2824FF2BF
	for <lists+netdev@lfdr.de>; Wed, 13 Apr 2022 10:53:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234094AbiDMIzy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Apr 2022 04:55:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37006 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229463AbiDMIzy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Apr 2022 04:55:54 -0400
Received: from mail-pf1-x434.google.com (mail-pf1-x434.google.com [IPv6:2607:f8b0:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CAFCA3FDB2;
        Wed, 13 Apr 2022 01:53:33 -0700 (PDT)
Received: by mail-pf1-x434.google.com with SMTP id bo5so1419811pfb.4;
        Wed, 13 Apr 2022 01:53:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=vrTdQF20XoNgjKqhooRdhomx5wbpyGcrgzLCucSJKsQ=;
        b=lp760lm4NwRsPDsRYdz/MWMHhWVyIy3o6EuQyqy+j/cU4lO8+jUIY2EPEV9tLMLzqX
         tFs4cZ0qBTHYFzVqCEWH3BBGAx4X/SGuq3wx/P97/XsfhaBQf4xoyYSFr4qm2r6yL99O
         DdzhMNMbUd8eHXQ+nbRAEA30nefNCPlrP5+PM0lPjLKTMCjQh2o0WcQqq2jsXsUE0HSA
         cjq/kdZ6MGkaCMjwGP71XVQF/Sv8wbJ86UOATWjESkvOn5cPYdzAAGt6HaZ3H7g/QefQ
         T2FOgklqmhA7c4nis82wL0Zt4V3CXfHW6QG3hn/cYnUudMii3rhwmXTwrZ25IqPx+1tL
         3C2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=vrTdQF20XoNgjKqhooRdhomx5wbpyGcrgzLCucSJKsQ=;
        b=OBezk2F/YBXEpf9azuF0w0rorQGiW7+adb57xnIEUr8tJ2U1MJF41+B+rrPuMBJUt9
         jD5LBKOZB3hI/vW9hPntiKnwnQcj2sZuukbEkO/XlDqaaRNNmNV9I4XPM5U3KzN1EjID
         I5aMuAX5YYobUJ4Jw6U475HeQ8LzuFBfwEcMMAZlkHWlYJCWcuCJgUPJ0dgvOvvxki0T
         i+2WecC2uabzjexJKt5CR6vKlNhNWBx9IP8dZej8GSuF0xibNhHWKmVQFKPM+L0tE1Z/
         iVnLndPBPaW34DOw+ohe1shdwlNAIZBObKKNIcPw542y9P203HxuMWh1kbj2CnbgP8Vo
         QZ4A==
X-Gm-Message-State: AOAM5313tIN8jv4fXITW+IlWCBcghyXAFzng2oBuF+RxozNvRtfkvrJT
        5ZfwlO1c5DWhiwgW2ovWMm8=
X-Google-Smtp-Source: ABdhPJxDKSmRO3F/JxnbBNIZJWGtcMs44vj8qujdQNYz1RwsoGzyyBZwIXg68LqZw5E5F3o1DEJp/A==
X-Received: by 2002:a63:3f0e:0:b0:386:1d94:312a with SMTP id m14-20020a633f0e000000b003861d94312amr34322386pga.317.1649840013257;
        Wed, 13 Apr 2022 01:53:33 -0700 (PDT)
Received: from [192.168.43.80] (subs32-116-206-28-52.three.co.id. [116.206.28.52])
        by smtp.gmail.com with ESMTPSA id b2-20020a056a000a8200b004f1111c66afsm45318769pfl.148.2022.04.13.01.53.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 13 Apr 2022 01:53:32 -0700 (PDT)
Message-ID: <c59ded56-23a0-a600-c669-1307d3ff1be4@gmail.com>
Date:   Wed, 13 Apr 2022 15:53:27 +0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
Subject: Re: [net-next PATCH v5 1/7] octeon_ep: Add driver framework and
 device initialization
Content-Language: en-US
To:     Veerasenareddy Burru <vburru@marvell.com>, davem@davemloft.net,
        kuba@kernel.org, corbet@lwn.net, netdev@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Abhijit Ayarekar <aayarekar@marvell.com>,
        Satananda Burla <sburla@marvell.com>
References: <20220413033503.3962-1-vburru@marvell.com>
 <20220413033503.3962-2-vburru@marvell.com>
From:   Bagas Sanjaya <bagasdotme@gmail.com>
In-Reply-To: <20220413033503.3962-2-vburru@marvell.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_SORBS_WEB,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 4/13/22 10:34, Veerasenareddy Burru wrote:
> @@ -0,0 +1,35 @@
> +.. SPDX-License-Identifier: GPL-2.0+
> +
> +====================================================================
> +Linux kernel networking driver for Marvell's Octeon PCI Endpoint NIC
> +====================================================================
> +
> +Network driver for Marvell's Octeon PCI EndPoint NIC.
> +Copyright (c) 2020 Marvell International Ltd.
> +
> +Contents
> +========
> +
> +- `Overview`_
> +- `Supported Devices`_
> +- `Interface Control`_
> +

Why did you manually add table of contents?

> +Interface Control
> +=================
> +Network Interface control like changing mtu, link speed, link down/up are
> +done by writing command to mailbox command queue, a mailbox interface
> +implemented through a reserved region in BAR4.
> +This driver writes the commands into the mailbox and the firmware on the
> +Octeon device processes them. The firmware also sends unsolicited notifications
> +to driver for events suchs as link change, through notification queue
> +implemented as part of mailbox interface.

How does one write to mailbox command queue?

-- 
An old man doll... just what I always wanted! - Clara
