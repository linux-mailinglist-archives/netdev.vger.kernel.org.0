Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 553755A7491
	for <lists+netdev@lfdr.de>; Wed, 31 Aug 2022 05:42:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232169AbiHaDl3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Aug 2022 23:41:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33512 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232308AbiHaDlV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Aug 2022 23:41:21 -0400
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 46EDA93522
        for <netdev@vger.kernel.org>; Tue, 30 Aug 2022 20:41:18 -0700 (PDT)
Received: by mail-pj1-x102b.google.com with SMTP id p8-20020a17090ad30800b001fdfc8c7567so2577008pju.1
        for <netdev@vger.kernel.org>; Tue, 30 Aug 2022 20:41:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date;
        bh=tkFdc1lyC1BA4RQSgQO9S260AlFHMhaxSsj/Hj8TnYw=;
        b=bGDxk0kUvWa7GKFOXqR5W9odjIsb1M5n0a3gQRckRQYusG/dBow8zsM6waEzSSCMMB
         lzJKeJnvlo7fJ9913M3XrNkbmJ+egyRSWkt/VYo17q/CAQntRW/Ctqz+OJjxCRiZoAEg
         LVQEpuPMhYMVp90bNumrhdTpsH7dGk7+kHI3DQbPBcOl4WHA+QosrdjFtLVtPCQGbJCW
         oWM7skOXtwPLlHHK6W3iZuDD55FgVlAuU70xC1QlXkvCPGpd/hYQ56yEeAFktuyl2gBj
         KkodjAikkJEfDPrvTd04uVPOIqZ/IPMFWNFBFsm2rzKBFJveIYkUDbo6NDHQbTco7DLe
         SBhA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date;
        bh=tkFdc1lyC1BA4RQSgQO9S260AlFHMhaxSsj/Hj8TnYw=;
        b=si/9zYVP91G0MlraLCX4LxaafNC7KyxQtfQXOtmKl1GUduUy1ktzYxDWx7ZNt5AUqK
         hZnkcrruOdTKqvUiXUoWjntTPFZOqSoDaLrH3tgAdqcxre6Ydy9NLKTfyIP6GsHgTAgV
         J2ZmIkbIXZ7/LIv6FpUzDPwLuQJp3hmiaKpEFY34U6HIzJ+nM7e4dU4Vl3odoSzE/kYw
         yQq/ih8zOxPH76hVuVzMaOHfe/sx90e6yYOMKem2Z5U9WPaV5QN9dJy9Bpmfw4vQzS17
         PHFPxMf+7RmeDhA4XqvTzz9IY2j8yFe8fL4bDb/5zx6p+JJhOCPUHMAtsKbCPEVPD7u4
         zPRQ==
X-Gm-Message-State: ACgBeo0l+a5lmvwkkEexg/hvTyPeJmz6/JvUewAm7JYJGb5ZswkPgqrD
        P7BYVfd1nlReU04WdQ9qwr5Dt3Dn4X0=
X-Google-Smtp-Source: AA6agR7nfKBUhN7IFKZXDaUrcKGDcAklosDmR3VGx6v2utHJ6vIg2peHLhl7lu9GCxRAj69hGIT2dw==
X-Received: by 2002:a17:902:6b42:b0:174:4308:ce52 with SMTP id g2-20020a1709026b4200b001744308ce52mr21650665plt.81.1661917277800;
        Tue, 30 Aug 2022 20:41:17 -0700 (PDT)
Received: from hoboy.vegasvil.org ([2601:640:8200:33:e2d5:5eff:fea5:802f])
        by smtp.gmail.com with ESMTPSA id s66-20020a625e45000000b005350ea966c7sm10160931pfb.154.2022.08.30.20.41.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 Aug 2022 20:41:17 -0700 (PDT)
Date:   Tue, 30 Aug 2022 20:41:15 -0700
From:   Richard Cochran <richardcochran@gmail.com>
To:     =?iso-8859-1?B?Q3Pza+Fz?= Bence <csokas.bence@prolan.hu>
Cc:     Andrew Lunn <andrew@lunn.ch>, netdev@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, qiangqing.zhang@nxp.com,
        kernel@pengutronix.de, Marc Kleine-Budde <mkl@pengutronix.de>
Subject: Re: [PATCH v2] net: fec: Use unlocked timecounter reads for saving
 state
Message-ID: <Yw7YW+2LKGyfYHDb@hoboy.vegasvil.org>
References: <20220830111516.82875-1-csokas.bence@prolan.hu>
 <Yw4ClKHWACSP2EQ1@lunn.ch>
 <bbe8a924-7291-14f9-1e88-802a211ca0f4@prolan.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <bbe8a924-7291-14f9-1e88-802a211ca0f4@prolan.hu>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Aug 30, 2022 at 05:05:24PM +0200, Csókás Bence wrote:

> 3. The final option, check if we are in an atomic or otherwise
> non-interruptible context, and if not, take a mutex. Otherwise, proceed
> normally. Which is this version of the patch.

Just replace the mutex with a spinlock.

Thanks,
Richard
