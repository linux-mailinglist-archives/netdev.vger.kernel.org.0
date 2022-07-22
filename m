Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A03D657E3EB
	for <lists+netdev@lfdr.de>; Fri, 22 Jul 2022 17:47:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233073AbiGVPro (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Jul 2022 11:47:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57742 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229593AbiGVPrn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Jul 2022 11:47:43 -0400
Received: from mail-pl1-x634.google.com (mail-pl1-x634.google.com [IPv6:2607:f8b0:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 68324357D8
        for <netdev@vger.kernel.org>; Fri, 22 Jul 2022 08:47:42 -0700 (PDT)
Received: by mail-pl1-x634.google.com with SMTP id d7so4876981plr.9
        for <netdev@vger.kernel.org>; Fri, 22 Jul 2022 08:47:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gateworks-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to;
        bh=SWsRgEkvTvpQLQ7G9QO4RvqdsyqwGwKlrDl3/HIVORo=;
        b=rejxAZFkWzJnzBqk2sm0O/8dVVFKsPyFKd5VV2Q640SCX85VYiVJ5gHSmtCPVfCWfb
         2Fx3GPgDha7NBhyRAaRLvGgFMhgxB4D3OLimtd+YQ2WGL0ZPWdkdFuV1kSRhfW8ImQVB
         Wm733YWOJt+xlTQ5hOV6nDq5VVGimpmXOiqSMbAzRi1mnjbuDCyEikWv02pCt3lE7NHf
         uonU25tPlmYJhihaOAYvd+yPpbPhAu8KpqDHou9wKJmXXCGvU9klRdO1KRiPoHF3BbGZ
         HWOK4pR78cjAfeO9OW0hvuyTEtH7OpcLtJYxoyS+C8N8bUmI+SijHCZ/T2lELGJW8GzJ
         HUPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to;
        bh=SWsRgEkvTvpQLQ7G9QO4RvqdsyqwGwKlrDl3/HIVORo=;
        b=qvnGC/Up/WnsmJo/Yn0jdr4cTOdH7LMLjnExga4VZhNowOrKsvDDM86rHQMB6NQl7g
         QQCiH1DPe11mcA63XuIo6hfHAZp8OLiluZ8Xlhd+tRyKOx8xKs560sJyZRBCv5wwnoAr
         UPKf1h7dFKNV3lZgDGMFxOKzv6hV/YJl8cWmCZxJjXwqSf6l1YpekbNZ0+6x+pB2yrcq
         62BeEjPKKnLtBX1gJzPMzNfBqWsW4FuBtSMpdFIwjns3nPgiB+zBERdqdFvC3BgaGabq
         4yB2mFCi0o2mXhNhTvJ8P0DWzDf2mpK9HV085WFwQoeBfpqnwrHOOyyuBZLk8Ro5Ifp2
         zznw==
X-Gm-Message-State: AJIora8fEMY98r6Hg8n63Quv3m3CFFMSB2ceWsmVYjFzxRqnlWlsASK+
        1VYBZk8f2iitF4v1w+MQeu9OdFP6qWsqsvFjmBKIPC7XF2t6gA==
X-Google-Smtp-Source: AGRyM1v9QZPLhba03qZukCTdz02owhUgS8JUWgxQpZU3B5j2h7UDwp25YusbzThw2Aa6KTFzwCTBu+No6p2pf1rXFHc=
X-Received: by 2002:a17:90a:a40a:b0:1f2:979:397d with SMTP id
 y10-20020a17090aa40a00b001f20979397dmr234957pjp.179.1658504861273; Fri, 22
 Jul 2022 08:47:41 -0700 (PDT)
MIME-Version: 1.0
References: <CAJ+vNU3Eu8Mv3ErH=mw0o2ENcEoWXLXWXX-_mTTg3vDkmnGrxg@mail.gmail.com>
In-Reply-To: <CAJ+vNU3Eu8Mv3ErH=mw0o2ENcEoWXLXWXX-_mTTg3vDkmnGrxg@mail.gmail.com>
From:   Tim Harvey <tharvey@gateworks.com>
Date:   Fri, 22 Jul 2022 08:47:29 -0700
Message-ID: <CAJ+vNU3_iv=L2n130nVC-2sGbhBGs0giOrsuGo052uodCb_uUg@mail.gmail.com>
Subject: Re: imx8mp fec/eqos not working
To:     netdev <netdev@vger.kernel.org>,
        Fabio Estevam <festevam@gmail.com>,
        Shawn Guo <shawnguo@kernel.org>,
        Joakim Zhang <qiangqing.zhang@nxp.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 21, 2022 at 4:02 PM Tim Harvey <tharvey@gateworks.com> wrote:
>
> Greetings,
>
> Does anyone have imx8mp fec and/or eqos network support working in
> mainline Linux? I'm finding the device registers with the kernel and
> link detect works but I can't get packets through.
>
> I'm using an imx8mp-evk and linux master for testing. I find both
> fec/eqos devices work fine in U-Boot but not Linux mainline. The NXP
> downstream vendor kernel imx_5.4.70_2.3.0 branch works but I haven't
> been able to pinpoint what is missing/different in mainline.
>

My mistake... forgot to enable the PHY drivers and imx8mp-evk fec/eqos
work just fine.

Sorry for the noise,

Tim
