Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 626B9358FC2
	for <lists+netdev@lfdr.de>; Fri,  9 Apr 2021 00:24:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232728AbhDHWYq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Apr 2021 18:24:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43486 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232404AbhDHWYp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Apr 2021 18:24:45 -0400
Received: from mail-wr1-x42d.google.com (mail-wr1-x42d.google.com [IPv6:2a00:1450:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E1E49C061760;
        Thu,  8 Apr 2021 15:24:33 -0700 (PDT)
Received: by mail-wr1-x42d.google.com with SMTP id b9so3707617wrs.1;
        Thu, 08 Apr 2021 15:24:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=BNR7rx3WwSOrqYI00Bz6gWtuuXsbvZB+6IMJ+XFJzek=;
        b=Xh73ggA3VimlbiZV/oPeyAEn09isnySne+Kyqprg/KiLQ8W+HB0rTcr8knkNueEtUG
         4ay1v/lW3uTmM8TX32QztYs8stq2Rsn68NKTUFUlzzciNefqbPvEkhxthVCv70nhUnNk
         iR4/TS5kxactnupTwNIvdPuOiNC8Yx19RqxbaPiFEkckYKrsk+2omzIfoS2zIYD6lNWO
         KCeI+Z8oy6D5MyJRbQ4hogyqSPIMNVnoDprK24oeYuFPoZsqk56BlDTKRXPF1LUocBEl
         G+3Uc0FP47rA0sHcASBIBywI0OSMPHtNEd/b1nwXurKO0bmMhetma/wpqkO1dzeFQeD4
         79Bg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=BNR7rx3WwSOrqYI00Bz6gWtuuXsbvZB+6IMJ+XFJzek=;
        b=l4XHiYIVdA7yEpIFUZkKq2khqOep2YsyMnWIYaS21PpQILocUWYsQ0mYTPcBsnD9/3
         w0kDT8ncdMQKV6YqUnMiJ+BwU7AUzQFFEiQJrr4L30cMpSSjHb0gJGJS7zQVhbxNLa/V
         0InHXWkOsDVc9VRhWpEmCohlJSga2lnxezjoae6zRI5BUrMNldChxGZoojROKjsiPHyY
         KtX13uoQyYZrom5IH6TR9eNX5EHJrlYWUV4yQoDu/mO6TW7T1aeGM3L0WbWfwo+U1t+H
         r/FxEONGSmP79XG+BHtFZbvK5A5mZ5OJYlXMVSvhj7qF/YJOtFPbs09TVmnmk+HVtXMh
         xfBw==
X-Gm-Message-State: AOAM530lSAJgiPQ41/YoSkFE3kPrGez814ZDExf0XloNRxUbk6RIpWyQ
        NnsEPvv+3PpVs6wuM33jGkIG2rgAqo9yR9BL5A4=
X-Google-Smtp-Source: ABdhPJzYirKUaz/+aRcf0K0YTcjj9ki8jfaJrnLpn+NUVfYrShhKnHR8lNzhIRu7SQYy9tKYD6UsMEiYKHLlt5z4/zk=
X-Received: by 2002:a05:6000:14f:: with SMTP id r15mr14568438wrx.166.1617920672524;
 Thu, 08 Apr 2021 15:24:32 -0700 (PDT)
MIME-Version: 1.0
References: <20210408172353.21143-1-TheSven73@gmail.com> <CAFSKS=O4Yp6gknSyo1TtTO3KJ+FwC6wOAfNkbBaNtL0RLGGsxw@mail.gmail.com>
 <CAGngYiVg+XXScqTyUQP-H=dvLq84y31uATy4DDzzBvF1OWxm5g@mail.gmail.com>
 <CAFSKS=P3Skh4ddB0K_wUxVtQ5K9RtGgSYo1U070TP9TYrBerDQ@mail.gmail.com>
 <820ed30b-90f4-2cba-7197-6c6136d2e04e@gmail.com> <CAGngYiU=v16Z3NHC0FyxcZqEJejKz5wn2hjLubQZKJKHg_qYhw@mail.gmail.com>
 <CAGngYiXH8WsK347ekOZau+oLtKa4RFF8RCc5dAoSsKFvZAFbTw@mail.gmail.com> <CAFSKS=PjCU-5YmDhUzjvhXV_+Ln70bThjCt48GUGXtn-NH6HQw@mail.gmail.com>
In-Reply-To: <CAFSKS=PjCU-5YmDhUzjvhXV_+Ln70bThjCt48GUGXtn-NH6HQw@mail.gmail.com>
From:   Sven Van Asbroeck <thesven73@gmail.com>
Date:   Thu, 8 Apr 2021 18:24:21 -0400
Message-ID: <CAGngYiWPfGOkMFkL_Sb4EiQ-43XNOZ_WQ6gPJzq-1pAjcXaZCw@mail.gmail.com>
Subject: Re: [PATCH net v1] Revert "lan743x: trim all 4 bytes of the FCS; not
 just 2"
To:     George McCollister <george.mccollister@gmail.com>
Cc:     Heiner Kallweit <hkallweit1@gmail.com>,
        Bryan Whitehead <bryan.whitehead@microchip.com>,
        David S Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        netdev <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi George,

On Thu, Apr 8, 2021 at 3:55 PM George McCollister
<george.mccollister@gmail.com> wrote:
>
> Works for me too.

Sounds good. I'll post a proper patch soon. Would you be able to
review+test, and perhaps offer your Reviewed-by/Tested-by tags when
everything looks ok?
