Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 217776D77B3
	for <lists+netdev@lfdr.de>; Wed,  5 Apr 2023 11:04:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237156AbjDEJE3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Apr 2023 05:04:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35718 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230059AbjDEJE2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Apr 2023 05:04:28 -0400
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ACE5710FA
        for <netdev@vger.kernel.org>; Wed,  5 Apr 2023 02:04:26 -0700 (PDT)
Received: by mail-pj1-x1036.google.com with SMTP id x15so33276622pjk.2
        for <netdev@vger.kernel.org>; Wed, 05 Apr 2023 02:04:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1680685466;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=3sbJKHi4/HtAWF7EeQvYFXKzs1WDvhLVQ2EBieg4Pv4=;
        b=NM1bolpkdX9FGIvjMpYznc46zYL8tfZiSoiffUTRAj9j2/3LjWVR6KEKAmOvzMzvz/
         37Pp7vd3cqHC+YKbqveA4LhHHVapAH8sIvn2ezn1xqh9cgsno55aWkZrm/j1y8zZR6AB
         382GoPYiIao26CqvWNLNsMK7sUk5lL7Na25/2ALuiLNekubePscl5G2NsI1FYi8DYveE
         alK7js4gYehz7trCouD5vd/4hoS39cHG9o6ZhhaG+dCsWTr8dxa1bQ0pkG+/jR9Lf2Ka
         mQlrPofLrPdp1+E/PbAiIdJZ55LV85vQo+NPtPtNBTUNEq+YGD64q0njB6VltCKlIFR0
         rq3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680685466;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=3sbJKHi4/HtAWF7EeQvYFXKzs1WDvhLVQ2EBieg4Pv4=;
        b=SDJ7T5o183qR/LCs9dWUMMJUJRsNVGpyoV2lX/tgRsBUXCf2BXu4vaoeS/E0/uLUuM
         rHyRTwLA4+RZiEYeuStt639SSnq8zZLWH0fDWwH3vZcKVtKwbKEd4ktYNzYSukLOTeSJ
         3HNv5W8ZJNwyqRk+gN4WXgOrnX3OOMrhd30U1hXYzpPiNHKokgOkkNzKv3sZ06jpbhqj
         fHFmXcyG6selfGNoaTcwVzotNcWUrSl6QtRyxWTx0VFeI8XXUG1X5FxtaQ0Yq+b4wEhq
         ScsgWkHoMNyiUX9xI1XY9VSvL1jFepIyPnIX4yIIjkTjb4g7axJRE/XHRoRLeD648y/B
         S5Cw==
X-Gm-Message-State: AAQBX9ec0xWDPjoQVZpDw5XLr2NMe5ZMSyx/mvUmrzUHEjwhA8YOoGGf
        9S72QN9TSTfDcVVaPjYwwHU=
X-Google-Smtp-Source: AKy350algCAKXWDsGUTFoumqwU7rlFN84gb6qaBCBlaYWsr+ui080IMX+euH9vujjNR/PgSG+1oBNg==
X-Received: by 2002:a17:90a:590e:b0:23f:2757:ce99 with SMTP id k14-20020a17090a590e00b0023f2757ce99mr5665109pji.49.1680685466051;
        Wed, 05 Apr 2023 02:04:26 -0700 (PDT)
Received: from Laptop-X1 ([2409:8a02:782e:a1c0:2082:5d32:9dce:4c17])
        by smtp.gmail.com with ESMTPSA id z9-20020a17090a468900b0023d1976cd34sm926356pjf.17.2023.04.05.02.04.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Apr 2023 02:04:25 -0700 (PDT)
Date:   Wed, 5 Apr 2023 17:04:20 +0800
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     Miroslav Lichvar <mlichvar@redhat.com>
Cc:     Jay Vosburgh <jay.vosburgh@canonical.com>, netdev@vger.kernel.org,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jonathan Toppins <jtoppins@redhat.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        Richard Cochran <richardcochran@gmail.com>
Subject: Re: [PATCH net-next] bonding: add software timestamping support
Message-ID: <ZC05lHM7GFuv1RyJ@Laptop-X1>
References: <20230329031337.3444547-1-liuhangbin@gmail.com>
 <ZCQSf6Sc8A8E9ERN@localhost>
 <ZCUDFyNQoulZRsRQ@Laptop-X1>
 <7144.1680149564@famine>
 <ZCZUMzk5SM9swbDT@Laptop-X1>
 <ZCqn27fK9oIzfWCA@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZCqn27fK9oIzfWCA@localhost>
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Apr 03, 2023 at 12:18:03PM +0200, Miroslav Lichvar wrote:
> > Oh.. I thought it's a software timestamp and all driver's should support it.
> > I didn't expect that Infiniband doesn't support it. Based on this, it seems
> > we can't even assume that all Ethernet drivers will support it, since a
> > private driver may also not call skb_tx_timestamp() during transmit. Even if
> > we check the slaves during ioctl call, we can't expect a later-joined slave
> > to have SW TX timestamp support. It seems that we'll have to drop this feature."
> 
> I'd not see that as a problem. At the time of the ioctl call the
> information is valid. I think knowing that some timestamps will be
> missing due to an interface not supporting the feature is a different
> case than the admin later adding a new interface to the bond and
> breaking the condition. The application likely already have some
> expectations after it starts and configures timestamping, e.g. that
> the RX filter is not changed or TX timestamping disabled.

Thanks, this makes sense to me. I will try this way and post the new patch.

Hangbin
