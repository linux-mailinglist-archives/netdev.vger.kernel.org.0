Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 346DE4FEA96
	for <lists+netdev@lfdr.de>; Wed, 13 Apr 2022 01:46:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231342AbiDLXgQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Apr 2022 19:36:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55432 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231477AbiDLXdC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Apr 2022 19:33:02 -0400
Received: from mail-lf1-x12e.google.com (mail-lf1-x12e.google.com [IPv6:2a00:1450:4864:20::12e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 244076D968
        for <netdev@vger.kernel.org>; Tue, 12 Apr 2022 15:21:45 -0700 (PDT)
Received: by mail-lf1-x12e.google.com with SMTP id x17so278651lfa.10
        for <netdev@vger.kernel.org>; Tue, 12 Apr 2022 15:21:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=jhwvgyEcZSOpmpyxrOgaq3w630NRgKLJPQ/gN5X9BqI=;
        b=BB63I15MqIOp+T77hNkUITkpUD8QzKo4ftAaAr6iSDCZawwm24ja4awPZssphh0IS/
         UryQULhmMGO7D/ThCzmwk0TszCLMMADNuhX2eYsT6ofrbvaRJaeXhS/I0rbWh83NMk1Y
         eQd6vSyt+TcQ+D978FzkhEZnx0v/6eY5iqGxPxHN5PsdLzgYLcGmUsnhXMjldLfNfeIT
         o1Sae3QBQnECHLmyrbwKmqr+sWHO+Jtv0zNHGksgZuovc029llkhB7qu+4xSW16g/NJX
         eCOXHRXh5RqyXxfa6cQV1sQp5WpPxWyKCMqcajjiAdi54wY0DdQDOh/tHKAUG9kA7/Kv
         uZlA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=jhwvgyEcZSOpmpyxrOgaq3w630NRgKLJPQ/gN5X9BqI=;
        b=XXm6mTVyIdGuI/0H3MiHy4nXu39wmCqxQHm1oppkMDRa4XrCZiC8itm+EkUJUnXr8B
         9DxmCrCOQuKI360uS8XMg73GQ6tWf933/MpLc7SmSJgxfkVR1P5XdH7sEPipZl91QJrF
         GyUCcDVcW7uaFOMiidKA6HvoJU9dAMKC97WI7/tJIUftFRH6RSKXFJUF4pH5wLozIKkC
         VbGOL3ld/9DnKhjwGw/0gW+ke3Lz8mqk6YLGTH7WCxBHtbimY5rnarcS/OEKB0zaS0zo
         KXqZh4r2VTUxacz5zIrq2vFFeixvwoTHP8/p08w/mNQAbAqyNiskFx5fDV4eyeH64NWx
         qYhQ==
X-Gm-Message-State: AOAM532Ats9Y8pBcaigl3qC6sXRYsdb54zbG6r6Osg842EUISRzKnxM3
        akHf72aJUh/04e10JQhRH+a19+zEvWc=
X-Google-Smtp-Source: ABdhPJw+es4HP4ZNUL9jIZiSw5Dlf2I3brqrtwwtJL66sXiQBoyeSLcm5ceujNkah436/1TXqF6BNQ==
X-Received: by 2002:adf:ed8f:0:b0:207:ac33:801f with SMTP id c15-20020adfed8f000000b00207ac33801fmr5635741wro.453.1649800017932;
        Tue, 12 Apr 2022 14:46:57 -0700 (PDT)
Received: from hoboy.vegasvil.org (195-70-108-137.stat.salzburg-online.at. [195.70.108.137])
        by smtp.gmail.com with ESMTPSA id u7-20020a5d6da7000000b00203d9d1875bsm34134462wrs.73.2022.04.12.14.46.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Apr 2022 14:46:57 -0700 (PDT)
Date:   Tue, 12 Apr 2022 14:46:55 -0700
From:   Richard Cochran <richardcochran@gmail.com>
To:     Gerhard Engleder <gerhard@engleder-embedded.com>
Cc:     Vinicius Costa Gomes <vinicius.gomes@intel.com>, yangbo.lu@nxp.com,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, mlichvar@redhat.com,
        netdev <netdev@vger.kernel.org>
Subject: Re: [PATCH net-next v2 4/5] ptp: Support late timestamp determination
Message-ID: <20220412214655.GB579091@hoboy.vegasvil.org>
References: <20220403175544.26556-1-gerhard@engleder-embedded.com>
 <20220403175544.26556-5-gerhard@engleder-embedded.com>
 <20220410072930.GC212299@hoboy.vegasvil.org>
 <CANr-f5xhH31yF8UOmM=ktWULyUugBGDoHzOiYZggiDPZeTbdrw@mail.gmail.com>
 <20220410134215.GA258320@hoboy.vegasvil.org>
 <CANr-f5xriLzQ+3xtM+iV8ahu=J1mA7ixbc49f0i2jxkySthTdQ@mail.gmail.com>
 <CANr-f5yn9LzMQ8yAP8Py-EP_NyifFyj1uXBNo+kuGY1p8t0CFw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANr-f5yn9LzMQ8yAP8Py-EP_NyifFyj1uXBNo+kuGY1p8t0CFw@mail.gmail.com>
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

On Tue, Apr 12, 2022 at 09:24:10PM +0200, Gerhard Engleder wrote:
> I'm thinking about why there should be a slow path with lookup. If the
> address/cookie
> points to a defined data structure with two timestamps, then no lookup
> for the phc or
> netdev is necessary. It should be possible for every driver to
> allocate a skbuff with enough
> space for this structure in front of the received Ethernet frame.

Adding 16 bytes for every allocated skbuff is going to be a tough
sell.  Most people don't want/need this.

Thanks,
Richard
