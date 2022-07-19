Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 987AD57A0ED
	for <lists+netdev@lfdr.de>; Tue, 19 Jul 2022 16:12:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238956AbiGSOMw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Jul 2022 10:12:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53758 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238995AbiGSOMe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Jul 2022 10:12:34 -0400
Received: from mail-wm1-x32b.google.com (mail-wm1-x32b.google.com [IPv6:2a00:1450:4864:20::32b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6E954F6B2;
        Tue, 19 Jul 2022 06:35:23 -0700 (PDT)
Received: by mail-wm1-x32b.google.com with SMTP id p26-20020a1c545a000000b003a2fb7c1274so7365584wmi.1;
        Tue, 19 Jul 2022 06:35:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:from:to:cc:subject:references:mime-version
         :content-disposition:in-reply-to;
        bh=+mWM93Q+TpkuMlgUY+I/2gZxaDcQ/qDofIHKazp4GBU=;
        b=DZlplFNKzcDX7MdSmlBxVjxEoFu6oLldVocKLLkgiIepUZa5m9klQU5Wb2jYY1LVky
         W0/Aa0UcyntaBUxKCUDnk+3KTowEg6+kcxU8FAluW2kbxsw1xdXKzfECJXmH2P3R07bA
         3FYtipb7H0NTnAfupyCp63XHbnC/D9Vx5t9wv5fFl4YWj+bEXwU9kWB82tkMBtG/vKJ/
         2kBwa6bcssoIvBK34Urkd8AMcgXPPpP7Ry52k+tJ/fmPFnHpn5AJB3Bb76SrJVC4Cxh6
         wc60TnUcPf3wFWvL5Dak0ZQQcrQRyyLOAR2CQ5U3aR5TQtvOREk1SewrEuwtUFlkS2Q3
         3ZlA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:from:to:cc:subject:references
         :mime-version:content-disposition:in-reply-to;
        bh=+mWM93Q+TpkuMlgUY+I/2gZxaDcQ/qDofIHKazp4GBU=;
        b=68d6x7PeGwl9XdjtPSf9ddvvOHVlV9dxkfV7qsmPKpVSEDsq6IDWQHUmcMolcfOG9K
         bo/t9gTBWhccNxdxe18lAWADnAh6j9wdoZ+/yRLJZP+rBtHQ4v3eD3i/jjy6Ywg1HUCH
         IDiaPqCSxc7TUT0buU3iZavEwRQJ5FKx4MTDc6WDWso9amIRhRTZtcqxRM7Xk9pEPkJS
         0Y+4WMqi7fhuvfCtL+5S2H4MDwWEMs+Fi2CnPRVALUL6PP9tA6cKZDXS9O+l5/0/Rwrv
         EErIfo3VCu410Mr0zAE1A+vJoTfN3swEJsI/Na1gTAaZf/6GWCUny6rr24lSrw49reqq
         K0ug==
X-Gm-Message-State: AJIora/sbxrcXmEI9Gm3ZrcdzCvZk7XaHe8vlaTdVEtiFFK+ppBeq/ua
        eUJGgGpy70gkHkeFp+lxUjc=
X-Google-Smtp-Source: AGRyM1sUpMCasnEebNz4vETaSZnQDmhTaA3l5s/i4V1JnufKC10MFOBE6ObeZA7+9leaXoCWCLu4dg==
X-Received: by 2002:a7b:cbd4:0:b0:3a3:20eb:2b80 with SMTP id n20-20020a7bcbd4000000b003a320eb2b80mr5076876wmi.175.1658237722286;
        Tue, 19 Jul 2022 06:35:22 -0700 (PDT)
Received: from Ansuel-xps. (93-34-208-75.ip51.fastwebnet.it. [93.34.208.75])
        by smtp.gmail.com with ESMTPSA id n15-20020adffe0f000000b0021d96b3b6adsm13441856wrr.106.2022.07.19.06.35.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Jul 2022 06:35:21 -0700 (PDT)
Message-ID: <62d6b319.1c69fb81.6be76.d6b1@mx.google.com>
X-Google-Original-Message-ID: <YtazFllzzK6Mevin@Ansuel-xps.>
Date:   Tue, 19 Jul 2022 15:35:18 +0200
From:   Christian Marangi <ansuelsmth@gmail.com>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [net-next PATCH v2 15/15] net: dsa: qca8k: drop unnecessary
 exposed function and make them static
References: <20220719005726.8739-1-ansuelsmth@gmail.com>
 <20220719005726.8739-1-ansuelsmth@gmail.com>
 <20220719005726.8739-17-ansuelsmth@gmail.com>
 <20220719005726.8739-17-ansuelsmth@gmail.com>
 <20220719132931.p3amcmjsjzefmukq@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220719132931.p3amcmjsjzefmukq@skbuf>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 19, 2022 at 04:29:31PM +0300, Vladimir Oltean wrote:
> On Tue, Jul 19, 2022 at 02:57:26AM +0200, Christian Marangi wrote:
> > Some function were exposed to permit migration to common code. Drop them
> > and make them static now that the user are in the same common code.
> > 
> > Signed-off-by: Christian Marangi <ansuelsmth@gmail.com>
> > ---
> 
> Hmm, ideally the last patch that removes a certain function from being
> called from qca8k-8xxx.c would also delete its prototype and make it
> static in qca8k-common.c. Would that be hard to change?

Can be done, it's really to compile check the changes and fix them.
Problem is that the patch number would explode. (ok explode is a big
thing but i think that would add 2-3 more patch to this big series...
this is why I did the static change as the last patch instead of in the
middle of the series)

But yes it's totally doable and not that hard honestly.

-- 
	Ansuel
