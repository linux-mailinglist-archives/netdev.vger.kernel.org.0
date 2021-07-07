Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DC2383BE9FF
	for <lists+netdev@lfdr.de>; Wed,  7 Jul 2021 16:43:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232126AbhGGOqL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Jul 2021 10:46:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43750 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232050AbhGGOqI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Jul 2021 10:46:08 -0400
Received: from mail-ed1-x52f.google.com (mail-ed1-x52f.google.com [IPv6:2a00:1450:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 92D37C061574;
        Wed,  7 Jul 2021 07:43:26 -0700 (PDT)
Received: by mail-ed1-x52f.google.com with SMTP id l24so3672477edr.11;
        Wed, 07 Jul 2021 07:43:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=4IeXbsXJ9RpV3yoL/zDlLEt9fqmG00Q6LjVNpQtStaE=;
        b=ABUAbuA9NWQ/gp8fFhqiJrxJA+vcn/gHxAxmAiI9PoRYhYk8QY9pFmyMFGJMrvsJQJ
         xU7uTPAr/s/Vd4pEcm4p24E2bzlVEo5J3WBQDuvn35xqvaDY7DFsxvjtg3T7J43dyCw5
         qhA7xTIfNmUXmPovGRdNOOeEx/c22V5m8kCybLU20nmon386cLNAhTuORjxYtiF8GEFk
         5k7CHsEqmCe4m2s+fbcMswTwyyIbjU4AFEiOQCixsBWH6yGjEJmuAM2pMPwGH88eAVcw
         lcxfJvlPQjEUCEohdRB+U7Lg1w7u+yJVTeFkSDwxqkQVane/mr8EVaAly/gCTcpvLZ44
         9EBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=4IeXbsXJ9RpV3yoL/zDlLEt9fqmG00Q6LjVNpQtStaE=;
        b=bbYcvW8FTCCu5mP1MHa5qRWcYB/MHsobx320G5+xPK1RLGz6DcMv2VMLasbo/Z4g+C
         99tcr80XuK+Ufn+QQUcDx6BNp4/jaGAQSRmXfvXSC3IOlZXu7CuC5MUGX6FUkLfHStdX
         WKG7e1xc66/4CxKqVPytA09rztCqiLaSa5EoYWBSqDIPl9YSCijEnGV34ikOBHsU9vl8
         ZsEj7SIEs+nsqQWP21e1QuHqSbam2aipx1M1RpgXsjW10/0j38Fh4JX3ruJXl9nvFlfS
         cjlmaCZUs9mY6n8YaCwQna24NxjmsVIdcn2fL+B3TJiviR709aA6LY3zzn/Nt6CbChme
         wJZg==
X-Gm-Message-State: AOAM533r09peySeURXvxBpZp/6GCYshQJPy0QElRZTWasVLFB4y6xk/B
        8xgghbGPLScFtzN5Vmw/PYaOUxGyAEiVwWGdQio=
X-Google-Smtp-Source: ABdhPJwoSr1Q/6ysVXgBOAgE6EXwiu5uI0BNNFicjeMUxglwZn31byVLn+Arla/M2OMOdEwjdsW09fyrpuHE/aVcYmM=
X-Received: by 2002:a05:6402:5142:: with SMTP id n2mr30450097edd.241.1625669005115;
 Wed, 07 Jul 2021 07:43:25 -0700 (PDT)
MIME-Version: 1.0
References: <20210705131321.217111-1-mudongliangabcd@gmail.com>
 <CAB_54W5ceXFPaYGs0T4pVq8AzRqUSvaBDWdBjvRurBYyihqfVg@mail.gmail.com>
 <CAD-N9QWykP2CBq1bPvz=HQRdeaR+Mg06hezrgOm4g3N1J_jT1g@mail.gmail.com> <b3783b1c-0874-d16e-c51c-55cbec3b29fa@datenfreihafen.org>
In-Reply-To: <b3783b1c-0874-d16e-c51c-55cbec3b29fa@datenfreihafen.org>
From:   Dongliang Mu <mudongliangabcd@gmail.com>
Date:   Wed, 7 Jul 2021 22:42:59 +0800
Message-ID: <CAD-N9QUD-BTScOn5jC3UKkh8+T198vd6SAirFpAyMs+mAaAfaQ@mail.gmail.com>
Subject: Re: [PATCH] ieee802154: hwsim: fix GPF in hwsim_set_edge_lqi
To:     Stefan Schmidt <stefan@datenfreihafen.org>
Cc:     Alexander Aring <alex.aring@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexander Aring <aring@mojatatu.com>,
        linux-wpan - ML <linux-wpan@vger.kernel.org>,
        "open list:NETWORKING [GENERAL]" <netdev@vger.kernel.org>,
        kernel list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 7, 2021 at 10:41 PM Stefan Schmidt
<stefan@datenfreihafen.org> wrote:
>
> Hello.
>
> On 07.07.21 16:40, Dongliang Mu wrote:
> > On Wed, Jul 7, 2021 at 9:44 PM Alexander Aring <alex.aring@gmail.com> wrote:
> >>
> >> Hi,
> >>
> >> On Mon, 5 Jul 2021 at 09:13, Dongliang Mu <mudongliangabcd@gmail.com> wrote:
> >>>
> >>> Both MAC802154_HWSIM_ATTR_RADIO_ID and MAC802154_HWSIM_ATTR_RADIO_EDGE,
> >>> MAC802154_HWSIM_EDGE_ATTR_ENDPOINT_ID and MAC802154_HWSIM_EDGE_ATTR_LQI
> >>> must be present to fix GPF.
> >>>
> >>> Fixes: f25da51fdc38 ("ieee802154: hwsim: add replacement for fakelb")
> >>> Signed-off-by: Dongliang Mu <mudongliangabcd@gmail.com>
> >>
> >> Acked-by: Alexander Aring <aahringo@redhat.com>
> >>
> >> Thanks, but there are more places than this one. Can you send patches
> >> for them as well? Thanks! :)
> >
> > Sure. I will double-check those places and send patches to fix them.
>
> I will take this one in as-is. All new patches should be done with this
> one applied.

Sure. Thanks for your reminder.

>
> regards
> Stefan Schmidt
