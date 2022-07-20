Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D327457B8F8
	for <lists+netdev@lfdr.de>; Wed, 20 Jul 2022 16:54:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236357AbiGTOyZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Jul 2022 10:54:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60470 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240821AbiGTOyX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Jul 2022 10:54:23 -0400
Received: from mail-ua1-x934.google.com (mail-ua1-x934.google.com [IPv6:2607:f8b0:4864:20::934])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 270431EC75
        for <netdev@vger.kernel.org>; Wed, 20 Jul 2022 07:54:22 -0700 (PDT)
Received: by mail-ua1-x934.google.com with SMTP id y19so8100076ual.12
        for <netdev@vger.kernel.org>; Wed, 20 Jul 2022 07:54:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc;
        bh=pRW51Zf8RzoluaRIPps/fzsMK5pZhkAW4XFwEonLMvw=;
        b=WiGwoKDNAEyBaub3ALOhsOfd8V1Tgkza8OJMERydOJCmZ4SPBYWl5LIlQuX7ywfnCU
         I3Hb1Joyb660f//GWck9lPLxB2cxJ21o5u7Jl9xGBNS2XfCwAnqqk5yeMAvX9zidy+kr
         aj3zERckGzNiyDk8T86GBc9WFnCJE1J/4gbw5IptkgJxFeD9Om+//q50EwPi79jF/8AV
         /8YTLcPvpy6CuJBCoOBO633GITuR+2PhDilJCjeSA5oL3fxiAWbc1/9unROkF1IghZis
         XstU0yK8SK5yTNWfoLE3blCDa7QI4CNQ9AV5Kfi9r6dMcdRqqLfHN33BG6mLpoUN6rLE
         BJIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc;
        bh=pRW51Zf8RzoluaRIPps/fzsMK5pZhkAW4XFwEonLMvw=;
        b=tq4zVvzO0t+6ZVaLxZWTJMkjO81aacSXa3ga100iwBz6apQqsrKSEgr0qJ3Q9+cQZB
         8OnKTxQceiOvFxOxlBZkc9zL/FiuFYGWWrjaNGg+PS7F8RTQymkq9muCsHnp49s8Jq7b
         SAtHrjy+mQdJ6Cqvpc21buTluuSYxYm0jVG3HFdHI4foBiGrsJ/tw8UhuY7FK/lIigLa
         kuxcQHYGrJ2NhXLuPCaJcQvL7nHH7//rCPPCNAcjDEqaNeYElDIz7Yft0bmBEwguvjHy
         4nB2p2jaPkN39p/BGRTV4maLwrsEN9rr0tw7+eyHdf1XTz1ad3F0JPGOpgaWzGHeS9Zn
         Pq/Q==
X-Gm-Message-State: AJIora+0SIgMjNrHVdzAVR330x6eaXeAnxt8LIIqfyIg4BGNUdDtLAl9
        j6tzJr39BRQXYf5DCvwFHiFYyoqUtRKkIOKoWCRBdg==
X-Google-Smtp-Source: AGRyM1tMJIlVh+piYAR1gu3liiD2a2yD06tL01sT5b1NlAk+YutcH6h+FoabXhj/fEmuMGA7cgOG6qNwc9qAH5EJN18=
X-Received: by 2002:ab0:215a:0:b0:382:c57:ee13 with SMTP id
 t26-20020ab0215a000000b003820c57ee13mr14287948ual.68.1658328860989; Wed, 20
 Jul 2022 07:54:20 -0700 (PDT)
MIME-Version: 1.0
References: <20220607025729.1673212-1-mfaltesek@google.com> <fc85ff14-70d6-0c3e-247d-eda2284a5f6b@oracle.com>
In-Reply-To: <fc85ff14-70d6-0c3e-247d-eda2284a5f6b@oracle.com>
From:   Martin Faltesek <mfaltesek@google.com>
Date:   Wed, 20 Jul 2022 08:53:44 -0600
Message-ID: <CAOiWkA_AcD_J1r1ncvmX8YswbMiS2fx5WySrYwvfdFE4qgk=hQ@mail.gmail.com>
Subject: Re: [PATCH net v3 0/3] Split "nfc: st21nfca: Refactor
 EVT_TRANSACTION" into 3
To:     Denis Efremov <denis.e.efremov@oracle.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        christophe.ricard@gmail.com,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Guenter Roeck <groeck@google.com>, jordy@pwning.systems,
        krzk@kernel.org, Martin Faltesek <martin.faltesek@gmail.com>,
        netdev@vger.kernel.org, linux-nfc@lists.01.org,
        sameo@linux.intel.com, William K Lin <wklin@google.com>,
        theflamefire89@gmail.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 20, 2022 at 1:25 AM Denis Efremov
<denis.e.efremov@oracle.com> wrote:
>
> Hi,
>
> On 6/7/22 06:57, Martin Faltesek wrote:
> >
> > Martin Faltesek (3):
> >   nfc: st21nfca: fix incorrect validating logic in EVT_TRANSACTION
> >   nfc: st21nfca: fix memory leaks in EVT_TRANSACTION handling
> >   nfc: st21nfca: fix incorrect sizing calculations in EVT_TRANSACTION
> >
> >  drivers/nfc/st21nfca/se.c | 53 ++++++++++++++++++++++-----------------
> >  1 file changed, 30 insertions(+), 23 deletions(-)
>
>
> It looks like driver st-nci contains the same problems and all 3 fixes are
> also applicable to st_nci_hci_connectivity_event_received() function.
> At least I can see the memory leak
> https://elixir.bootlin.com/linux/v5.19-rc7/source/drivers/nfc/st-nci/se.c#L343
>
> Can you please double check the st-nci driver and send the same fixes to it?
> Reported-by: Denis Efremov <denis.e.efremov@oracle.com>

Will do.
