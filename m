Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F30FD6CC251
	for <lists+netdev@lfdr.de>; Tue, 28 Mar 2023 16:42:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232981AbjC1OmT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Mar 2023 10:42:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59462 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233065AbjC1OmP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Mar 2023 10:42:15 -0400
Received: from mail-pl1-x62f.google.com (mail-pl1-x62f.google.com [IPv6:2607:f8b0:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4283F4233;
        Tue, 28 Mar 2023 07:42:09 -0700 (PDT)
Received: by mail-pl1-x62f.google.com with SMTP id z19so11891353plo.2;
        Tue, 28 Mar 2023 07:42:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1680014528; x=1682606528;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=IgNoFQm+wb3ZHmO4FOdLmqbPC8YhjP4RKltTs40NK3Q=;
        b=D3m2YXN7nBkOUDtLQs+TrJxUryHH7nylVXQ/HB88K7jhkDM58C/UbEn/Ck/tTdZMCj
         UYYMtAhRw8NIhCPUqgWEriBM0QYPrrt+NAuQdGbb6s0oAUDr8ZwdSoINYC339KNqDjH3
         pmkXuOFal8Q5KmcoC2uy73CrrxmzpeUjesQFhQDF/Fx6gvlU2R08Q7CCKYgrjWJWlSJI
         P7gMuxyzIdL7S9WG75vX1zp4FiwDI1GrYpsR88DT5rVHJv6L6+Fx2pLILmIfzPLRN6+4
         cCaiagbw2qYESU1WFzKmlpSCmIdIJ2Z/LZM8iUXi7oNFGxrDzUnYSnQ9vZFjLSH13cbC
         bNbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680014528; x=1682606528;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=IgNoFQm+wb3ZHmO4FOdLmqbPC8YhjP4RKltTs40NK3Q=;
        b=d2cMOmF/2bliTZvjhq0gYQkzZN/HeYxuZYwJBm/LtrBHM5njC2WTNM1WKJWNkmPl2S
         O1vTs3pwZAHr7X5eKTIR0P9T7nWOUdONTIQ0KXcwITpNT981EodX3eCMra9/8LKadfjz
         /RAmektUI6X7y/d6D44J9mU0ycRH2Q1C4WiqQfMVW939Ns1YBbJOY8X86ke4Powk1iyT
         ohc9PgNxbwfkDYIvcED1lBJ4YG7Ig3ZAkeq6uKElXzUErfbtwQEWmJ6w+jf8WeEqLT9O
         0H9MYNUYGa72RIRc2SC2LEbS8TuVxIrUN9nXzIYCIi42E509uXQkZwqDjeqnkGflqW+I
         zLUg==
X-Gm-Message-State: AAQBX9f4D7ZDDS5T6xwc4dclNh6OY1jLDfXVJXQzebOF0LIaH87986uG
        h9G3T5eg6BpQf3cl9cmMtmKiZEWt0/E=
X-Google-Smtp-Source: AKy350at3r6cpp3iOxGJ2E4qpsL44rbBlV7iDcI+yctvzMDjXkFgoFrIPIxSI4QDADtKhUn1OfpR5A==
X-Received: by 2002:a17:902:7297:b0:19d:2a3:f019 with SMTP id d23-20020a170902729700b0019d02a3f019mr13480409pll.1.1680014528636;
        Tue, 28 Mar 2023 07:42:08 -0700 (PDT)
Received: from hoboy.vegasvil.org ([2601:640:8200:33:e2d5:5eff:fea5:802f])
        by smtp.gmail.com with ESMTPSA id d13-20020a170902b70d00b001a239325f1csm5443517pls.100.2023.03.28.07.42.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Mar 2023 07:42:08 -0700 (PDT)
Date:   Tue, 28 Mar 2023 07:42:05 -0700
From:   Richard Cochran <richardcochran@gmail.com>
To:     Tianfei Zhang <tianfei.zhang@intel.com>
Cc:     netdev@vger.kernel.org, linux-fpga@vger.kernel.org,
        ilpo.jarvinen@linux.intel.com, andriy.shevchenko@linux.intel.com,
        vinicius.gomes@intel.com, pierre-louis.bossart@linux.intel.com,
        marpagan@redhat.com, russell.h.weight@intel.com,
        matthew.gerlach@linux.intel.com, nico@fluxnic.net,
        Raghavendra Khadatare <raghavendrax.anand.khadatare@intel.com>,
        Arnd Bergmann <arnd@kernel.org>
Subject: Re: [PATCH v3] ptp: add ToD device driver for Intel FPGA cards
Message-ID: <ZCL8veyS5xNUMCCt@hoboy.vegasvil.org>
References: <20230328142455.481146-1-tianfei.zhang@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230328142455.481146-1-tianfei.zhang@intel.com>
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


CCing Arnd...

On Tue, Mar 28, 2023 at 10:24:55AM -0400, Tianfei Zhang wrote:

> v3:
> - add PTP_1588_CLOCK dependency for PTP_DFL_TOD in Kconfig file.
> - don't need handle NULL case for ptp_clock_register() after adding
>   PTP_1588_CLOCK dependency.

Sorry, but this isn't how it is done...

> +config PTP_DFL_TOD
> +	tristate "FPGA DFL ToD Driver"
> +	depends on FPGA_DFL
> +	depends on PTP_1588_CLOCK

Try these commands:

   git grep "depends on PTP_1588_CLOCK_OPTIONAL"
   git grep "depends on PTP_1588_CLOCK_OPTIONAL" | grep -v OPTIONAL

Driver must depend on PTP_1588_CLOCK_OPTIONAL and then handle the NULL
case correctly.

Thanks,
Richard
