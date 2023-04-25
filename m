Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A0FE26ED9D9
	for <lists+netdev@lfdr.de>; Tue, 25 Apr 2023 03:30:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233207AbjDYBaD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Apr 2023 21:30:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38470 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233110AbjDYBaC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Apr 2023 21:30:02 -0400
Received: from mail-pf1-x432.google.com (mail-pf1-x432.google.com [IPv6:2607:f8b0:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 858D0AF04;
        Mon, 24 Apr 2023 18:30:01 -0700 (PDT)
Received: by mail-pf1-x432.google.com with SMTP id d2e1a72fcca58-63d32d21f95so1197142b3a.1;
        Mon, 24 Apr 2023 18:30:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1682386201; x=1684978201;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=htqkwrbYe0J5JxsD8PlvuajYPbp9ghX9os9xd5y3vpc=;
        b=KWANcYsti+92cVW7op6FyyxC2rvQJsJzF49slXMcSQLxmP7oQQCiheclWRqPnpJxsn
         V9nTeOA42r6ILq3PSEvLRyl7JEii1VzoZgbvc4DasavWQNPAf0FmG8TPLCIb8IGOG538
         bD8u8X7R5GwQQ5wObaSh2/izsJRGduxvW2RvC058juLg35S/+qLfl3LeDkVNAX+Uc7ZH
         M+5H5cRSxMY43AA2oYN17dgZVai6np+YmKtcMogOyYwCalaxt5mmN9M6StSZC6MHslhb
         QzarB7aRnT0OO6zmi35mL30jqalz6wOrs2y/7b0SSIsE55egiDRfmbjDXaPqkLLanP4D
         g8sA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682386201; x=1684978201;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=htqkwrbYe0J5JxsD8PlvuajYPbp9ghX9os9xd5y3vpc=;
        b=YSRGD2gExfKNJ+EQ1jyCEXPMiI0l4VRWsc+jpfc74q2kTZj6Jl9rpq3OiFNsw+rv4P
         iFdDlOX8UxfUVOuAGAAXZHz+tPAcz25G87vTcja3E2xbU2MoO4G2zj7j+Sdw1/viRK5s
         awG0Jmd1azDFr6ep2Ni0IRObh1dZTmYlIcGOHP4T9c7Ey+y6vxXdjNmTzcRnycOcvsTF
         481iZZpYPFceCkGGH2r2lIiIfGqI3JZuolvbNor6b3Z3bRLhpsg25xWpASviuwXPw0De
         rajeyxnQx0XVkL5CiuzFw444g28wHAf/9LbYunsESE3jIqCk6LfBD23rejwhbYZp8v85
         PMmA==
X-Gm-Message-State: AAQBX9eHCMB4K2SQo9VhByOkx4/KtX1Fl3Kj1rmJDASOr6T/ItObaDuj
        /ZO4Lz7dhltyT2QyUg+F4bs=
X-Google-Smtp-Source: AKy350ZXOAiG0iqEOjmoAFK6oNti5vH8tDG8urqXfeAhhgREyfKkc1vZuDg9zQvdfbqqf/LmUjKUKg==
X-Received: by 2002:a05:6a00:2d96:b0:633:4c01:58b4 with SMTP id fb22-20020a056a002d9600b006334c0158b4mr18042705pfb.2.1682386200857;
        Mon, 24 Apr 2023 18:30:00 -0700 (PDT)
Received: from hoboy.vegasvil.org ([2601:640:8200:33:e2d5:5eff:fea5:802f])
        by smtp.gmail.com with ESMTPSA id t5-20020a628105000000b0063b73e69ea2sm8012027pfd.42.2023.04.24.18.29.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Apr 2023 18:30:00 -0700 (PDT)
Date:   Mon, 24 Apr 2023 18:29:58 -0700
From:   Richard Cochran <richardcochran@gmail.com>
To:     "Stern, Avraham" <avraham.stern@intel.com>
Cc:     "Greenman, Gregory" <gregory.greenman@intel.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "johannes@sipsolutions.net" <johannes@sipsolutions.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: pull-request: wireless-next-2023-03-30
Message-ID: <ZEctFm4ZreZ5ToP9@hoboy.vegasvil.org>
References: <20230330205612.921134-1-johannes@sipsolutions.net>
 <20230331000648.543f2a54@kernel.org>
 <ZCtXGpqnCUL58Xzu@localhost>
 <ZDd4Hg6bEv22Pxi9@hoboy.vegasvil.org>
 <ccc046c7e7db68915447c05726dd90654a7a8ffc.camel@intel.com>
 <ZEC08ivL3ngWFQBH@hoboy.vegasvil.org>
 <SN7PR11MB6996329FFC32ECCBE4509531FF669@SN7PR11MB6996.namprd11.prod.outlook.com>
 <ZEb81aNUlmpKsJ6C@hoboy.vegasvil.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZEb81aNUlmpKsJ6C@hoboy.vegasvil.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Apr 24, 2023 at 03:04:07PM -0700, Richard Cochran wrote:
> On Sun, Apr 23, 2023 at 01:33:19PM +0000, Stern, Avraham wrote:

> > So obviously for ptp4l to support time sync over wifi, it will
> > need to implement the FTM protocol (sending FTM frames via nl80211
> > socket) and use the kernel APIs added here

"obviously" ?

In the past, I made quite some thougts about how to best implement PTP
over Wifi.  I may have even written something about it.

In any case, "implement the FTM protocol (sending FTM frames via
nl80211 socket)" was definitely NOT one of the approaches.

Wouldn't it have great to start a discussion before plowing ahead and
hacking something into the kernel?

Oh well.

Thanks,
Richard
