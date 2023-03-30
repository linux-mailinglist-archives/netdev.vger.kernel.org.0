Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B584D6CF886
	for <lists+netdev@lfdr.de>; Thu, 30 Mar 2023 03:11:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229869AbjC3BLM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Mar 2023 21:11:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37816 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229529AbjC3BLK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Mar 2023 21:11:10 -0400
Received: from mail-oo1-xc2b.google.com (mail-oo1-xc2b.google.com [IPv6:2607:f8b0:4864:20::c2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7444F55BF;
        Wed, 29 Mar 2023 18:10:58 -0700 (PDT)
Received: by mail-oo1-xc2b.google.com with SMTP id h22-20020a4ad756000000b0053e4ab58fb5so1701495oot.4;
        Wed, 29 Mar 2023 18:10:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1680138657;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=U+tJVafNWqOuQPEBzM6fBHEcL9TFwibZa5a2SuWE/Mw=;
        b=V+tUe7XXMFg4HA9Oko7HdLAlWQOelRQY0PBqFWWzmh+5KOtThPI/G2Jy60G0f1X9m2
         a0otZN4N9j9ZQMQAF6UBd4x7N+eIuTsWhxWzqdWlkjWL4+EQMfdx24hnpK9D+O+ywZbk
         gTWIDAP8N/4oHk6GeuPdr+0YqMdgHaFdODb3mWVerfqrR5sxN90+ZukGGKgkSTwT19+g
         uItG+h1D8aaX0TishHleeXzoEo937TqaHFDccG4PmI333dPPLavyvAW2AC4VLPzZ0TJY
         GMXqoCAgMLeIThwlfsbe9D71GtqJKhtC+HV+aymwmv5DPqfOPU1wuBvsxScyPkR+Ltpt
         Oqfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680138657;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=U+tJVafNWqOuQPEBzM6fBHEcL9TFwibZa5a2SuWE/Mw=;
        b=A+7qDArmCLnhgDg2gCZGSSh7Llg6Vg7Foot4TIOJ8LVbbMOvfyl45DH8ChyIXFoCZA
         TVOZagqRzKJTE1+AFeRxfqmnobFJIqMNm2rwGR5/NtDJLSJCCA61gFbgUg4Jl+6mTL2h
         ATfiAv9ZIcAxePGGBO54KO5iXe4mDiugqVYnZPTcM5I1W6ZJDzNq1+teRF8nDgBVyibw
         7rRafGAUde2RWSulnrj13P+uk7G2EDczF2lfV5KHGgnF2Mde35/eV4frEscQ7Ujtz3Vf
         aJcPJu29vjPBX0EDXJ66M0yVVoZCAErOXsnJPddIVNZNTyBzGeBHFviHu9sI/4iaL4VR
         HU9A==
X-Gm-Message-State: AO0yUKXLZeQ3XipnMDbVut+19X0fnoAiLDpCjLGoHvqMwkxJ2bHwFvSD
        wvEbkdTYRmnRhTUXGYFPjIc=
X-Google-Smtp-Source: AK7set9QoADutjDVRDgteYOyjw4F3Isfx6K9mtlsnhbTf75K3gN9oJxta4a+1hufvOhSlJw5yjAAiA==
X-Received: by 2002:a4a:d64a:0:b0:53b:62ee:8bf5 with SMTP id y10-20020a4ad64a000000b0053b62ee8bf5mr9840866oos.3.1680138657397;
        Wed, 29 Mar 2023 18:10:57 -0700 (PDT)
Received: from localhost ([2804:30c:900:c000:e02a:5b57:da1d:f7cf])
        by smtp.gmail.com with ESMTPSA id b7-20020a056830104700b0069d4e5284fdsm8656763otp.7.2023.03.29.18.10.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Mar 2023 18:10:56 -0700 (PDT)
Date:   Wed, 29 Mar 2023 22:10:55 -0300
From:   Marcelo Schmitt <marcelo.schmitt1@gmail.com>
To:     Rob Herring <robh@kernel.org>
Cc:     "Rafael J. Wysocki" <rafael@kernel.org>,
        Len Brown <lenb@kernel.org>,
        Lars-Peter Clausen <lars@metafoo.de>,
        Michael Hennerich <Michael.Hennerich@analog.com>,
        Jonathan Cameron <jic23@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Johannes Berg <johannes@sipsolutions.net>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Jiri Slaby <jirislaby@kernel.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        Jonathan Hunter <jonathanh@nvidia.com>,
        Marc Zyngier <maz@kernel.org>, linux-iio@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-staging@lists.linux.dev,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-serial@vger.kernel.org, linux-tegra@vger.kernel.org,
        linux-acpi@vger.kernel.org, devicetree@vger.kernel.org
Subject: Re: [PATCH 1/5] iio: adc: ad7292: Add explicit include for of.h
Message-ID: <ZCThn87xFr3wGtzP@marsc.168.1.7>
References: <20230329-acpi-header-cleanup-v1-0-8dc5cd3c610e@kernel.org>
 <20230329-acpi-header-cleanup-v1-1-8dc5cd3c610e@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230329-acpi-header-cleanup-v1-1-8dc5cd3c610e@kernel.org>
X-Spam-Status: No, score=0.1 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 03/29, Rob Herring wrote:
> With linux/acpi.h no longer implicitly including of.h, add an explicit
> include of of.h to fix the following error:
> 
> drivers/iio/adc/ad7292.c:307:9: error: implicit declaration of function 'for_each_available_child_of_node'; did you mean 'fwnode_for_each_available_child_node'? [-Werror=implicit-function-declaration]
> 
> Signed-off-by: Rob Herring <robh@kernel.org>

Acked-by: Marcelo Schmitt <marcelo.schmitt1@gmail.com>

Thanks,
Marcelo

> ---
>  drivers/iio/adc/ad7292.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/iio/adc/ad7292.c b/drivers/iio/adc/ad7292.c
> index a2f9fda25ff3..cccacec5db6d 100644
> --- a/drivers/iio/adc/ad7292.c
> +++ b/drivers/iio/adc/ad7292.c
> @@ -8,6 +8,7 @@
>  #include <linux/bitfield.h>
>  #include <linux/device.h>
>  #include <linux/module.h>
> +#include <linux/of.h>
>  #include <linux/regulator/consumer.h>
>  #include <linux/spi/spi.h>
>  
> 
> -- 
> 2.39.2
> 
