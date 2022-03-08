Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 91B5D4D22E5
	for <lists+netdev@lfdr.de>; Tue,  8 Mar 2022 21:52:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230385AbiCHUxQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Mar 2022 15:53:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54582 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350366AbiCHUxJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Mar 2022 15:53:09 -0500
Received: from mail-pf1-x432.google.com (mail-pf1-x432.google.com [IPv6:2607:f8b0:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 97CBE31528
        for <netdev@vger.kernel.org>; Tue,  8 Mar 2022 12:52:12 -0800 (PST)
Received: by mail-pf1-x432.google.com with SMTP id z16so430022pfh.3
        for <netdev@vger.kernel.org>; Tue, 08 Mar 2022 12:52:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=qy8Xh24NyoIHbt71IUbZyV0Z1HqBJzlKoCdc/2iN4w8=;
        b=YOkIMFIy4QAv8TdLLh/A9NKHsbBo3eQ24yKGg49H9KcJs5CEQakVTLy3sOdYGJuWFv
         qBmx0HG/hTfRv09WWkS9IwUY3ENU8spQAySpsMsD8+J2RwNmwbAqDjDeF+e3jELfEy8z
         8b0n0EY4aCO1TRTREmvTdmgvrDL3A0YdI1bYlBrdUQB/79YMoWJ+UMy5jCnKG83kFk7j
         eocMFKpGoKhZlztfwP6w5wpHPC7WCw/JVcJJjbKumU+EIpXg27WivQXWFiy2YvTT+cuj
         ftuL41s+nJiHEQ88cUtEcDGYZFW/+yq8Kl0mSROUhhJsU5n3HG8VmYrfaxonm7chzbnR
         GZmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=qy8Xh24NyoIHbt71IUbZyV0Z1HqBJzlKoCdc/2iN4w8=;
        b=BS+H3R48GbvaXzDWc0OUtqMyTgpTmvONgwwS3cLozX8KP04j/e3rQJdNw8wTTs0y0j
         Kk/5x/z/qcCuGiqtxe/urbQWgXOOEogBmekTyW+pm5WIO6gaV8TFma5qex5KyQPAvbbO
         M/oZJKvmZCwnEP7a+MeS+fTe7izcwFQ3O6beZe6G9OnxPZ+sNhU3xWfTc1l9fxTzQEwQ
         tIZ1yQiYC0uMZ3KBEUZc6fBu7YKUtktf46uDp5Sz5TDij/rGnW20eDXZK4OCckEUC4rO
         ESJDvwRIcDEiqR/GYWhBNYGVwG61MvnADsMSXLPrkal7Th2YI57uaJmS3H6MY5JQPxch
         SUEQ==
X-Gm-Message-State: AOAM531AUYtxDJRi1lVppHWRmdWmi+tBmcpacTJx4bcEdVvQAp21WItT
        DytknUUf2g8hQ5EQUbIEgYg=
X-Google-Smtp-Source: ABdhPJzgqJTwNh4YjSy//mEDfFTd8yy7aKZK6jAFKc0nTXTJZ6hDCwVD0qj158tQAH2KQnVbpasCxA==
X-Received: by 2002:a63:fa4a:0:b0:378:5d07:96d3 with SMTP id g10-20020a63fa4a000000b003785d0796d3mr15550988pgk.54.1646772732166;
        Tue, 08 Mar 2022 12:52:12 -0800 (PST)
Received: from hoboy.vegasvil.org ([2601:640:8200:33:e2d5:5eff:fea5:802f])
        by smtp.gmail.com with ESMTPSA id ic6-20020a17090b414600b001bf691499e4sm3731557pjb.33.2022.03.08.12.52.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Mar 2022 12:52:11 -0800 (PST)
Date:   Tue, 8 Mar 2022 12:52:09 -0800
From:   Richard Cochran <richardcochran@gmail.com>
To:     Gerhard Engleder <gerhard@engleder-embedded.com>
Cc:     yangbo.lu@nxp.com, David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, mlichvar@redhat.com,
        Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        netdev <netdev@vger.kernel.org>
Subject: Re: [RFC PATCH net-next 0/6] ptp: Support hardware clocks with
 additional free running time
Message-ID: <20220308205209.GC16895@hoboy.vegasvil.org>
References: <20220306085658.1943-1-gerhard@engleder-embedded.com>
 <20220306170504.GE6290@hoboy.vegasvil.org>
 <CANr-f5wNJM4raaXrMA8if8gkUgMRrK7+5beCnpGOzoLu59zwsg@mail.gmail.com>
 <20220306215032.GA10311@hoboy.vegasvil.org>
 <20220307143440.GC29247@hoboy.vegasvil.org>
 <CANr-f5zyLX1YAW+D4AJn2MBQ8g7e8F+KVDc0GuxL7s9K89Qx_A@mail.gmail.com>
 <20220308005523.GB6994@hoboy.vegasvil.org>
 <CANr-f5yecFHG9mjRTd4aKBNzKgVV_tbZ4VAKXkMe2qxAMb66Gg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANr-f5yecFHG9mjRTd4aKBNzKgVV_tbZ4VAKXkMe2qxAMb66Gg@mail.gmail.com>
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

On Tue, Mar 08, 2022 at 08:49:03PM +0100, Gerhard Engleder wrote:

> 3 of 8 flags are unused in tx_flags. It may be possible to use the same flag for
> TX and RX. Is it worth it trying to save flags?

Yes, every bit is precious.

Thanks,
Richard
