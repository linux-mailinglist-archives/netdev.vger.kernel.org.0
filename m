Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 44A9069D090
	for <lists+netdev@lfdr.de>; Mon, 20 Feb 2023 16:24:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230427AbjBTPYd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Feb 2023 10:24:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51186 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230484AbjBTPYb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Feb 2023 10:24:31 -0500
Received: from mail-pf1-x42f.google.com (mail-pf1-x42f.google.com [IPv6:2607:f8b0:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 164641BE9
        for <netdev@vger.kernel.org>; Mon, 20 Feb 2023 07:24:05 -0800 (PST)
Received: by mail-pf1-x42f.google.com with SMTP id x24so834076pfn.7
        for <netdev@vger.kernel.org>; Mon, 20 Feb 2023 07:24:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1676906644;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=JlHbUFam4W2zvWkg53WCdmQneeI9Wx2bOInBpNcDbz8=;
        b=KEh9yq9b4yAg3o2V7u/iTd02RttKFdozPb/t1DRnb5+PeF+Arsx437HyH2DGjj9N/X
         sQrMRdfBXwayT8qcHYC7s7RwLzCYInuYkJ7NLU9JmazMEN4z3jYI0fRbLRRsml71JTxt
         JJ+6TxNrYkcUUGD2nQXSsdMlG5PMMhH/v/YSDhz2HuLuaqNh6o419Wnno8OHTIEQXiSB
         gtfPvnooviw8Fg6WAMmsPFbV2k6nRaC5ZNJVJLzkzQKXw5heY8G5akdXIIyNi+zZfn0m
         XQG02ztwZLt6pW4Ijr1Mwct5wE0LTh/xDvGsbali4Cea6m3nN2Xd8V+L7w6KrwsM65Cc
         cXBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1676906644;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=JlHbUFam4W2zvWkg53WCdmQneeI9Wx2bOInBpNcDbz8=;
        b=JVFqB8Zjp9WdTYoKk2sMzyHoU1FUG+mYM7EbOjgDyn0L71gXDwGdA7zLIHiLUUYGFW
         S0deYLuiGhcZOP3SMvyuMsPM+6l7JFaNY4ILBEaIQ6+rwmkhNbHJZvTgqGeFVL7bWyGz
         l+gcNyMZq3UrSDN93VQGAgkZIMcauKtvvZzNmfeF/e6D2xlpBr1lSsw0//xTaDRgvKhg
         hRBZN4epGEVlEaVntHZfnPLrs5J1jA5NuMBOeIIsuQ744eWE4QGzeQchfnNZT1SYOcXC
         56kAEQoNqVHl8sRu0rwdOk1SWF4sqHpjs6gsXC86w2ioRqc3siYlyNBJCFrPZphoDJLD
         2yZw==
X-Gm-Message-State: AO0yUKVbKbynH4En6qkeSTaEAijVZ3SiN//0i+nfyn7i4xq7ohit3h1t
        GxTys/A+6cDEWjHRoB51/u8=
X-Google-Smtp-Source: AK7set9TsMrqc1LfUgcTrJ1di6tfbFNus6+lZwdumM/3Plb7SOhoZx1kLFiQwKI7NrbX9BcnUyOo3Q==
X-Received: by 2002:a62:bd08:0:b0:5a8:abe2:fee2 with SMTP id a8-20020a62bd08000000b005a8abe2fee2mr2168754pff.2.1676906644014;
        Mon, 20 Feb 2023 07:24:04 -0800 (PST)
Received: from hoboy.vegasvil.org ([2601:640:8200:33:e2d5:5eff:fea5:802f])
        by smtp.gmail.com with ESMTPSA id v24-20020aa78518000000b005a9ea5d43ddsm6382189pfn.174.2023.02.20.07.24.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Feb 2023 07:24:02 -0800 (PST)
Date:   Mon, 20 Feb 2023 07:24:00 -0800
From:   Richard Cochran <richardcochran@gmail.com>
To:     Miroslav Lichvar <mlichvar@redhat.com>
Cc:     Matt Corallo <ntp-lists@mattcorallo.com>,
        chrony-dev@chrony.tuxfamily.org,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [chrony-dev] Support for Multiple PPS Inputs on single PHC
Message-ID: <Y/OQkNJQ6CP+FaIT@hoboy.vegasvil.org>
References: <72ac9741-27f5-36a5-f64c-7d81008eebbc@bluematt.me>
 <Y+3m/PpzkBN9kxJY@localhost>
 <0fb552f0-b069-4641-a5c1-48529b56cdbf@bluematt.me>
 <Y+60JfLyQIXpSirG@hoboy.vegasvil.org>
 <Y/NGl06m04eR2PII@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y/NGl06m04eR2PII@localhost>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Feb 20, 2023 at 11:08:23AM +0100, Miroslav Lichvar wrote:
> Does it need to be that way? It seems strange for the kernel to
> support enabling PPS on multiple channels at the same time, but not
> allow multiple applications to receive all samples from their channel.

It does not need to be that way, but nobody ever wanted multiple
readers before.

Implementing this would make the kernel side much more complex, as the
code would need per-reader tracking of the buffered time stamps, or
per-reader fifo buffers, etc.

Thanks,
Richard
