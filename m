Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 130A74D0D16
	for <lists+netdev@lfdr.de>; Tue,  8 Mar 2022 01:55:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344137AbiCHA4Y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Mar 2022 19:56:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52414 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245642AbiCHA4W (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Mar 2022 19:56:22 -0500
Received: from mail-pl1-x630.google.com (mail-pl1-x630.google.com [IPv6:2607:f8b0:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D79581155
        for <netdev@vger.kernel.org>; Mon,  7 Mar 2022 16:55:26 -0800 (PST)
Received: by mail-pl1-x630.google.com with SMTP id n2so6087283plf.4
        for <netdev@vger.kernel.org>; Mon, 07 Mar 2022 16:55:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=sgOcCj2nGBCQ0/uvaT+BpEDvtMy16F61R5agNStyJ50=;
        b=iFBHAMSARGX8B8rH/e/+mfCFBEl8eJGKSIMAnHKuneDbBT8slC5uC0BL8UfooWVscd
         041MLAX1Qt97tf7sak2duzwhX2piU7I+oRa9soQTrSWBIcZF3PXw6IFwAX2568pJgIRP
         W0kgYzxERE3ySGwDdyWDIHSaQpX09Ptj8bCvMMtnSPem3XBVt9OkxiU+vfp+31Nvkd+l
         5F/sFcx6c0a3/WaOZTAFkNpHqLR92GZ/o0LkmZqM4Oced7ifJ3DpbEShIyX6bypc3r3P
         spLyfjfbTOHA47h8J+koGHtQgByw+R0cXfNdUlnGvRtx+0gr7+BM5udIe2Hkfz9IpWhU
         srPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=sgOcCj2nGBCQ0/uvaT+BpEDvtMy16F61R5agNStyJ50=;
        b=17x3oiefiAWOzo4DVh6bChGiJhiFCsbGsD6iHcugL+PUoBI6jQu5HPzWrLcGajjaKl
         ya7FsMFT81ML8CdGnIXykGxEBEqlCtU+wEhE3m/5aFyEF9ffwf4Z4X4whFKGAd/uEszw
         Qzt+LfFcjnEcTqaO//oC4GwfCdmd9FJf0MTZKkptrr5Vndf311tlTE9fQRf8kHbzDRGg
         IPidYD2OzeC+c+LnP+UdDKY0CBcVCo3YPyTN/y4V2CDZw8RgJFvpH079KuP97IaARVvt
         l74VvTFDC6yVVbeUWw//UC37lFnF0mrRUrIyESbNweKQwyLvX353E6NEnLtydBKCpNPY
         S9cw==
X-Gm-Message-State: AOAM531MYca3TH/NQhvdBzpIVjs2xvJ0yXLfmWDDuWkQZlcw1/yvzHH4
        OaFrJy29Of80ARHWoewXhl4=
X-Google-Smtp-Source: ABdhPJxv9/R8GfQ6Pv3C1FLW7MrSgm0XHnA1+DwxGmEsMJIhTB0Fx3MeTafYc47Nlj0Jmg5jhI9Iww==
X-Received: by 2002:a17:902:d705:b0:14e:e5a2:1b34 with SMTP id w5-20020a170902d70500b0014ee5a21b34mr14309559ply.88.1646700926393;
        Mon, 07 Mar 2022 16:55:26 -0800 (PST)
Received: from hoboy.vegasvil.org ([2601:640:8200:33:e2d5:5eff:fea5:802f])
        by smtp.gmail.com with ESMTPSA id a32-20020a631a20000000b003756899829csm12914130pga.58.2022.03.07.16.55.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Mar 2022 16:55:26 -0800 (PST)
Date:   Mon, 7 Mar 2022 16:55:23 -0800
From:   Richard Cochran <richardcochran@gmail.com>
To:     Gerhard Engleder <gerhard@engleder-embedded.com>
Cc:     yangbo.lu@nxp.com, David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, mlichvar@redhat.com,
        Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        netdev <netdev@vger.kernel.org>
Subject: Re: [RFC PATCH net-next 0/6] ptp: Support hardware clocks with
 additional free running time
Message-ID: <20220308005523.GB6994@hoboy.vegasvil.org>
References: <20220306085658.1943-1-gerhard@engleder-embedded.com>
 <20220306170504.GE6290@hoboy.vegasvil.org>
 <CANr-f5wNJM4raaXrMA8if8gkUgMRrK7+5beCnpGOzoLu59zwsg@mail.gmail.com>
 <20220306215032.GA10311@hoboy.vegasvil.org>
 <20220307143440.GC29247@hoboy.vegasvil.org>
 <CANr-f5zyLX1YAW+D4AJn2MBQ8g7e8F+KVDc0GuxL7s9K89Qx_A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANr-f5zyLX1YAW+D4AJn2MBQ8g7e8F+KVDc0GuxL7s9K89Qx_A@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Mar 07, 2022 at 06:54:19PM +0100, Gerhard Engleder wrote:

> ktime_to_cycles uses hwtstamp as key for the cache lookup. As long as
> the PHC is monotonic, the key is unique. If the time of the PHC is set, then
> the cache would be invalidated. I'm afraid that setting the PHC could lead to
> wrong or missing timestamps. Setting the PHC in hardware, timestamp
> generation in hardware, and cache invalidation in software would need to
> be synchronized somehow.

You can avoid errors even with a time jump:

Make a variant (union) of skb_shared_hwtstamps to allow driver to
provide an address or cookie instead of ktime_t.  Set a flag in the
skbuff to signal this.

Let the Rx path check the flag and fetch the time stamp by callback
with the address/cookie.

Thanks,
Richard
