Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9C8234BEAA6
	for <lists+netdev@lfdr.de>; Mon, 21 Feb 2022 20:36:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232705AbiBUTJ5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Feb 2022 14:09:57 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:52706 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232658AbiBUTJz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Feb 2022 14:09:55 -0500
Received: from mail-ed1-x531.google.com (mail-ed1-x531.google.com [IPv6:2a00:1450:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 183C819C23;
        Mon, 21 Feb 2022 11:09:31 -0800 (PST)
Received: by mail-ed1-x531.google.com with SMTP id m3so25395315eda.10;
        Mon, 21 Feb 2022 11:09:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=GiBDC4NrOX8UwcznWIOERNhc3u5ACgSxBptO6DWd+2Q=;
        b=e92JXaCZb6LAJISQYrOD/RcnTqGgZnfGKmpzUXnFJEYgL+KJA6xCoFGGJaxCAGSQBi
         t4YXSIjPWYTyCNZcbsADf6ERExszQIvxgCCR0aijB084zwS9oAt0+8F9hNyPXXD9Xo6D
         isPe8pw3R3SijuH7hs/ig3QPV9CkA3hlK3WJVGXjBjUklC+7Pdvb8fG4STKfQ+eKUVgx
         yi6nPg7TtDYCGIBxv5Kpx0ue6457fE3stz2ZZYPyFX4QkWUMRZWUez+ydUnrbqCevcfA
         5/W2J5JjNKtBoF2rPq1+bRKo81wPKnVbkiXpGInArBrUyKLTPpcKFegQ3DL0LsrgKX2y
         BwGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=GiBDC4NrOX8UwcznWIOERNhc3u5ACgSxBptO6DWd+2Q=;
        b=m42y1U4tbT8BXQu0YForV8WMbE1gFq9AujEb0oeoUKmtLyHnb9/ZpBEJj70U91vlka
         b77FCQGmJH6J2mFzJb75lYXktbjfZ6Cb+LNPks0cfpTlUZsgnBkmvxfoBhQuAXZOY+L1
         ADZtXD8uBWGaemvpgHtszRpXM9tNlozLfGJXutRbS9Q/LF1uC9J6W3e3s5siFHQBTKIu
         fsIefXVPUEPaJx0YzJVZz/fghUGGxs/DL28MpsopWEuGuI3oNasGcRzEOoHEKIJnlnpm
         GEO6shNzpyCo2jN1FAOvSgTU7AY8YhFTMf1gn2cgWUi3rxL8bkOIp/sLHcb5LVRJEaXr
         FnTQ==
X-Gm-Message-State: AOAM532tE0r1gi0n5V2H9YusajwN5ho5ZrEDAmTCtNSwydSf5FXJs99Y
        cpe7paZdWOPbCd7W2wIa6xI=
X-Google-Smtp-Source: ABdhPJz+xz0LhRp9fHOsmeY50sDki8eHmdQFYjXXA1BJ+Yi+I/3gYOmiuXLLdYYHuyt/zwz/lkX+2A==
X-Received: by 2002:a05:6402:50cb:b0:412:ab6d:c807 with SMTP id h11-20020a05640250cb00b00412ab6dc807mr21726221edb.382.1645470569495;
        Mon, 21 Feb 2022 11:09:29 -0800 (PST)
Received: from skbuf ([188.25.231.156])
        by smtp.gmail.com with ESMTPSA id y23sm5557003ejk.153.2022.02.21.11.09.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Feb 2022 11:09:29 -0800 (PST)
Date:   Mon, 21 Feb 2022 21:09:27 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Alvin =?utf-8?Q?=C5=A0ipraga?= <alvin@pqrs.dk>
Cc:     Linus Walleij <linus.walleij@linaro.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Michael Rasmussen <mir@bang-olufsen.dk>,
        Alvin =?utf-8?Q?=C5=A0ipraga?= <alsi@bang-olufsen.dk>,
        Luiz Angelo Daros de Luca <luizluca@gmail.com>,
        =?utf-8?B?QXLEsW7DpyDDnE5BTA==?= <arinc.unal@arinc9.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 net-next 2/2] net: dsa: realtek: rtl8365mb: serialize
 indirect PHY register access
Message-ID: <20220221190927.5rb2vz5jj3ky324z@skbuf>
References: <20220221184631.252308-1-alvin@pqrs.dk>
 <20220221184631.252308-3-alvin@pqrs.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20220221184631.252308-3-alvin@pqrs.dk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Feb 21, 2022 at 07:46:31PM +0100, Alvin Šipraga wrote:
> To fix this problem, one must guard against regmap access while the
> PHY indirect register read is executing. Fix this by using the newly
> introduced "nolock" regmap in all PHY-related functions, and by aquiring
> the regmap mutex at the top level of the PHY register access callbacks.
> Although no issue has been observed with PHY register _writes_, this
> change also serializes the indirect access method there. This is done
> purely as a matter of convenience and for reasons of symmetry.

Reviewed-by: Vladimir Oltean <olteanv@gmail.com>
