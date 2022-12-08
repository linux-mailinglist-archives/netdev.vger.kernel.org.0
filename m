Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9ED81646E35
	for <lists+netdev@lfdr.de>; Thu,  8 Dec 2022 12:18:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229561AbiLHLSH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Dec 2022 06:18:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49040 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229492AbiLHLSG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Dec 2022 06:18:06 -0500
Received: from mail-ej1-x634.google.com (mail-ej1-x634.google.com [IPv6:2a00:1450:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C95747327
        for <netdev@vger.kernel.org>; Thu,  8 Dec 2022 03:18:03 -0800 (PST)
Received: by mail-ej1-x634.google.com with SMTP id n20so3151757ejh.0
        for <netdev@vger.kernel.org>; Thu, 08 Dec 2022 03:18:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=oT2rBAyYzBWLma8KMHZ+cgilhfzsGAXdOAC/OUiRkiI=;
        b=SJY2ShYOGTIbPhBYczDaWzlurej2dSXzGDh6/nIOVDmC0aEN/0Jwe7KSuw/Dv1iEGi
         WXnyLoVqbs62c+0xshTao9VbfPXzaZbWaK6BAbyq4q+x93GDLyh7/MpP37aOTaLH6o0h
         4sybymi3lSIXBbGg9bcedvmRMhGx04QnoxTH07jTeCuIoUhE5wOiqxTVe3gm2lZxzrlO
         RD6kfSaRV67NWLeZEmI5xgspv/WOCgTCly3z8GOEyV0kGkeHUinfS9alzcfjUIjffy/X
         /WuauN0oMUEjT+pwYntbWKJ02dbIh/asW9qYhxhAa18YFAOYkPTn5zGHUwXqE6f17mge
         M3xg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=oT2rBAyYzBWLma8KMHZ+cgilhfzsGAXdOAC/OUiRkiI=;
        b=iQnUmOlG3FDc3wNou+MzN56DRme9PUMw7fZ009mlipDfUWrpeiOyH8zY2sH4eDyC9w
         rwz6GhHOYRk/qktLrTk+bOu9L11Exzd6hIAoR2qwK0Cxz32UmgsxRXHsWw/UoJXIh3ng
         2RSAalKJCRMr9ZCOU8EJ/sSNwxk7ODkR+qz7GByehhd/g+xMTcVTMa/GseCdX/enUjcf
         /kB0RGZ1rX3LIa0Qfxn9Eyr6hwbydbT4DfKyqe4WseHa0FjI7IAdNQzN52uIKDWbjXH8
         /u5vyUi9KuGc6dNWJpIiLM89nIWcw0NxzsUWRhGkNbAxClqkpHbKbQH1kOr0MihsrILq
         on3A==
X-Gm-Message-State: ANoB5pnoD1joODlpnibelqRTyZiXjtNFssDYD3LVK33K+3RDXuEwYMbe
        Qd5umhQ7B9afZslJNy7Ha5Tv68313h6CAU5mnV0=
X-Google-Smtp-Source: AA0mqf4dCGvpdBf/rVkS/p9eh8VaoYt2Bc0DZMfBFvhS1GzG8BtgCH+uN1ZJXfp6N3yzJDxrNf4Liw==
X-Received: by 2002:a17:906:2e8e:b0:7c0:9805:4060 with SMTP id o14-20020a1709062e8e00b007c098054060mr2111777eji.38.1670498281701;
        Thu, 08 Dec 2022 03:18:01 -0800 (PST)
Received: from localhost (host-213-179-129-39.customer.m-online.net. [213.179.129.39])
        by smtp.gmail.com with ESMTPSA id fi22-20020a1709073ad600b007c0d4d3a0c1sm6388329ejc.32.2022.12.08.03.18.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Dec 2022 03:18:00 -0800 (PST)
Date:   Thu, 8 Dec 2022 12:17:59 +0100
From:   Jiri Pirko <jiri@resnulli.us>
To:     Jiasheng Jiang <jiasheng@iscas.ac.cn>
Cc:     leon@kernel.org, jesse.brandeburg@intel.com,
        anthony.l.nguyen@intel.com, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        intel-wired-lan@lists.osuosl.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net v2] ice: Add check for kzalloc
Message-ID: <Y5HH54ek3KX2aHpI@nanopsycho>
References: <20221208100603.29588-1-jiasheng@iscas.ac.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221208100603.29588-1-jiasheng@iscas.ac.cn>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Thu, Dec 08, 2022 at 11:06:03AM CET, jiasheng@iscas.ac.cn wrote:
>On Thu, Dec 08, 2022 at 05:25:02PM +0800, Leon Romanovsky wrote:
>>> +err_out:
>>> +	for (j = 0; j < i; j++) {
>> 
>> You don't need an extra variable, "while(i--)" will do the trick.
>
>No, the right range is [0, i - 1], but the "while(i--)" is [1, i].

Are you sure??


>If using "while(i--)", the code should be "tty_port_destroy(pf->gnss_tty_port[i - 1]);".
>It will be more complex.
>Therefore, it is worthwhile to use an extra varaible.
>
>Thanks,
>Jiang
>
