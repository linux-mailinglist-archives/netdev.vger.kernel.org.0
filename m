Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 525494F1B19
	for <lists+netdev@lfdr.de>; Mon,  4 Apr 2022 23:18:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359728AbiDDVTj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Apr 2022 17:19:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52360 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379720AbiDDR7B (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 Apr 2022 13:59:01 -0400
Received: from mail-oa1-x29.google.com (mail-oa1-x29.google.com [IPv6:2001:4860:4864:20::29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA2C234BB9;
        Mon,  4 Apr 2022 10:57:04 -0700 (PDT)
Received: by mail-oa1-x29.google.com with SMTP id 586e51a60fabf-df22f50e0cso11624114fac.3;
        Mon, 04 Apr 2022 10:57:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=AEWP21GM4E9cyOoL3qIS0CoFdLbJpmk5WXVV+auexAQ=;
        b=A8fxSPNmIfaWYKrHBlZaLXcvOYLu9Vrcb+u7TNHqeRxaF/O8WR7cLJCST+Tc1H7is6
         K61aviSX1tCeV7jaQPXPb4zsKtFjWO9V4ZXkcZMWTBJbX5E7+DtBaM2KQaQxQ4NXy12M
         VggI/cg9xK/1reYGYov8SHIDOSbJxUe7LPJ70ptMywxwLmYO7nPkjdCIwb76sGskIGsH
         uALkaOGEGL7Osw6CrmiCAlUGaa+Ld0GAWKTdFSdsJJFtyGoF9Cedmf4VX1KsJR0DU3WP
         lSoHhWrB/Lqqtfj3cJlLUISYxaA/U8U70C+up7rODwk8A65eKh/FQz1Nf3MoeGSfayNz
         4a9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=AEWP21GM4E9cyOoL3qIS0CoFdLbJpmk5WXVV+auexAQ=;
        b=gE96Z0MC6NmgPP/v47aYW3XQgJdH0McAT5AHeornhtrL32tWtJ9+JKKgwQVN/Ywjl3
         KV2rpbe9/U9rHQo+U0IFvXubIZ276ygcFvPAjSAKhj4c5sK469k9lHwOFnhj6MqGnwrG
         qu828fLS8W6Vq21PurYpALr07EuIu/Z2SeGNgTEGa1BRrmNk1m4y5cBtHiT8QcTyNG68
         KyrbyVOULaBt6pXj97gft2Css1Xb/jXmoukrSWEwhVSUhf0Q7uQWgPcY/idsSDwK1eCX
         uPt/p+77Q5+DFxMWo/yEUM/hJ70Al+2BonwBtislWkWxtMHNYH85fI2q4rCUmUrb+5CP
         GHrQ==
X-Gm-Message-State: AOAM532r/aPrPeXZzol95uJSoqNyZ5a3F/nsgGq6KqSCCzkNLxmSrjdc
        7OhPDja/kkN3pENK2+ldQ08=
X-Google-Smtp-Source: ABdhPJx18shL1wpUax/xhz8105BoWa0G7HpdbNUzdvsDRLqA5/2ZEilu8wWMeQGrEG3upCgBtBI+yA==
X-Received: by 2002:a05:6870:f719:b0:d6:e0c0:af42 with SMTP id ej25-20020a056870f71900b000d6e0c0af42mr187736oab.165.1649095024221;
        Mon, 04 Apr 2022 10:57:04 -0700 (PDT)
Received: from t14s.localdomain ([2001:1284:f013:bc01:5a2:a886:8487:b8de])
        by smtp.gmail.com with ESMTPSA id r23-20020a056830237700b005b2610517c8sm4930201oth.56.2022.04.04.10.57.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 Apr 2022 10:57:03 -0700 (PDT)
Received: by t14s.localdomain (Postfix, from userid 1000)
        id 1B7191DB7C2; Mon,  4 Apr 2022 14:57:02 -0300 (-03)
Date:   Mon, 4 Apr 2022 14:57:02 -0300
From:   Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
To:     Jamie Bainbridge <jamie.bainbridge@gmail.com>
Cc:     Vlad Yasevich <vyasevich@gmail.com>,
        Neil Horman <nhorman@tuxdriver.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, linux-sctp@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 net] sctp: count singleton chunks in assoc user stats
Message-ID: <YksxbrRhtngGlERY@t14s.localdomain>
References: <c9ba8785789880cf07923b8a5051e174442ea9ee.1649029663.git.jamie.bainbridge@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c9ba8785789880cf07923b8a5051e174442ea9ee.1649029663.git.jamie.bainbridge@gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Apr 04, 2022 at 09:47:48AM +1000, Jamie Bainbridge wrote:
> Singleton chunks (INIT, HEARTBEAT PMTU probes, and SHUTDOWN-
> COMPLETE) are not counted in SCTP_GET_ASOC_STATS "sas_octrlchunks"
> counter available to the assoc owner.
> 
> These are all control chunks so they should be counted as such.
> 
> Add counting of singleton chunks so they are properly accounted for.
> 
> Fixes: 196d67593439 ("sctp: Add support to per-association statistics via a new SCTP_GET_ASSOC_STATS call")
> Signed-off-by: Jamie Bainbridge <jamie.bainbridge@gmail.com>

Acked-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>

Thanks Jamie.
