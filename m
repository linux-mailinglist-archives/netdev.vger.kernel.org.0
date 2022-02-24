Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 84EE64C3709
	for <lists+netdev@lfdr.de>; Thu, 24 Feb 2022 21:50:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234348AbiBXUuc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Feb 2022 15:50:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51582 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229455AbiBXUub (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Feb 2022 15:50:31 -0500
Received: from mail-lf1-x131.google.com (mail-lf1-x131.google.com [IPv6:2a00:1450:4864:20::131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34D7425D6DD
        for <netdev@vger.kernel.org>; Thu, 24 Feb 2022 12:50:01 -0800 (PST)
Received: by mail-lf1-x131.google.com with SMTP id j15so5908283lfe.11
        for <netdev@vger.kernel.org>; Thu, 24 Feb 2022 12:50:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=K7Q/Yaamh7u6ae3y6zkq/joMW6amPe2G20eLGXBMeLA=;
        b=LMlhah8SdQ2JxJ3A8LX9FtEG/kjw8TtC5fVbS/xgmC3I8CaYr7YE7fHIhHIsMq1g/g
         cjqxW8PLx4H7meNqtjpmtNS5G/RcHX3ub7b3DO1/cdh37glVOLbzVCbDvBeCqu/3NLzu
         SxnprZj4hBezMb3ITkFaMHuNdEazF5zxnNEhE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=K7Q/Yaamh7u6ae3y6zkq/joMW6amPe2G20eLGXBMeLA=;
        b=4zQCd0SRO67svDPuX2xDHwAuJvGXCjHnFpnk/u8efQvO1euGL7i3nx22c8e8xm6Dy6
         gYL8T84SfZ8INGFCIcpa8HKTpUUN9vTGs+zRXlhRW4naU3oVD4TsHb+8CqwBEiUCeCKK
         2c61FwcvuqIggmT2jCEnv2d3xKu0wF0Q7hO031kqKPrtQcMuHoH1XDhwkQwg69qi++b+
         n8HHG40lXjOABu2Kr3p1bcZiTA5itQgjXgYcAptFreOGsLGbk+yfHk9AB8zrWHCktJ/e
         Vf3tFA/pGelhHqcJf9vYFMV9P8uaU0zdSNjpBzkRfb/27f4HAY4cUP9gFY37KjJcrFTM
         MZrw==
X-Gm-Message-State: AOAM531KblqYRDa9RuRVtyQiPAIa64CJsIWesrXLspQTETvs3vHuDVXB
        Mt9kg75bxnroTP3T+Cpr5DtxxlGdZ/ZdYHmUF8E=
X-Google-Smtp-Source: ABdhPJz8E79ZklO7pHus41lKiyodVOqIkbu2pl9xfAA0/3+u8BAGFIgd5ZLK7B6ujhDOd8n0oS0YkQ==
X-Received: by 2002:ac2:5fe1:0:b0:443:4e28:7ccb with SMTP id s1-20020ac25fe1000000b004434e287ccbmr2892622lfg.30.1645735799301;
        Thu, 24 Feb 2022 12:49:59 -0800 (PST)
Received: from mail-lf1-f42.google.com (mail-lf1-f42.google.com. [209.85.167.42])
        by smtp.gmail.com with ESMTPSA id d3-20020a056512368300b00443fdd5f48fsm24500lfs.116.2022.02.24.12.49.58
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 24 Feb 2022 12:49:58 -0800 (PST)
Received: by mail-lf1-f42.google.com with SMTP id b11so5905119lfb.12
        for <netdev@vger.kernel.org>; Thu, 24 Feb 2022 12:49:58 -0800 (PST)
X-Received: by 2002:ac2:5313:0:b0:443:99c1:7e89 with SMTP id
 c19-20020ac25313000000b0044399c17e89mr2706158lfh.531.1645735798149; Thu, 24
 Feb 2022 12:49:58 -0800 (PST)
MIME-Version: 1.0
References: <20220224195305.1584666-1-kuba@kernel.org>
In-Reply-To: <20220224195305.1584666-1-kuba@kernel.org>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Thu, 24 Feb 2022 12:49:42 -0800
X-Gmail-Original-Message-ID: <CAHk-=wjWmb9fw1wnuZmaPca92X6+Ot1revY3+t2TKVc--xEVyQ@mail.gmail.com>
Message-ID: <CAHk-=wjWmb9fw1wnuZmaPca92X6+Ot1revY3+t2TKVc--xEVyQ@mail.gmail.com>
Subject: Re: [GIT PULL] Networking for 5.17-rc6
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     David Miller <davem@davemloft.net>,
        Netdev <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Feb 24, 2022 at 11:53 AM Jakub Kicinski <kuba@kernel.org> wrote:
>
> Current release - regressions:

.. and not listed here is the build fix for IPV6 being disabled that
has been reported multiple times.  Thanks.

                  Linus
