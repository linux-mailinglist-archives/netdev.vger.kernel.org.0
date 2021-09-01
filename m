Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EA75A3FE483
	for <lists+netdev@lfdr.de>; Wed,  1 Sep 2021 23:05:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243310AbhIAVGr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Sep 2021 17:06:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37680 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231857AbhIAVGq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Sep 2021 17:06:46 -0400
Received: from mail-ej1-x62e.google.com (mail-ej1-x62e.google.com [IPv6:2a00:1450:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6EECC061757
        for <netdev@vger.kernel.org>; Wed,  1 Sep 2021 14:05:48 -0700 (PDT)
Received: by mail-ej1-x62e.google.com with SMTP id n27so2073052eja.5
        for <netdev@vger.kernel.org>; Wed, 01 Sep 2021 14:05:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=LKn5XzdaATfmZVLMP/VINeiUy/AzHORm6uPxG+yEhjY=;
        b=I6kG2+uED0WBYICuRYtClJPQpJYowajeSiGlVbz72hTscsmRNZ4ZkBzpTA/Uihx2xf
         piR4BmgN37cHZbm4NvNnFMs9xbMCn9hOBbCAGQlAmKybwNgIBO1iLzDWtF2TWYr4GIf4
         scv7XOCjJeefgeciyie0PJK9uCqIL6P4ezr3c0OQMHKQ/XGF03j3XwlUj57UcPmjrooE
         R7RkHxBlC6/KQTl4jmccDFGRi6PbUANTsImnOKkf4LHo2vChl+oZ2v//7PRx+GQOFgIV
         ApME318Wfxfm0bc97WrdNdGqQy+7/wM+zqqhgW1cxqeotJlVHGKI0toJJWlUh017ArMc
         +4tQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=LKn5XzdaATfmZVLMP/VINeiUy/AzHORm6uPxG+yEhjY=;
        b=JJ3NXr3PuLp5EDAb6PMghH7ayID7Gtqk0kJ1AmPrdtQXMxdL34GCFV1Bobj2p75hLW
         kj+QsLh1rJaUUssEgXotLstFU2bIyRVi++yAw/21D9vWwtX8fHe6zn0jRqQ4QhlD4b0V
         L2o0Yik7USmIqgbbWmCvLX0YHJg9bb088UxNgXhIkZfYxUHlTeiXOw39LBdbtNGpqDBM
         svwefe8lUt7RK3SSn6SV92vvA7HOIjD0sAbQMY8PYVIp9O9+9GPRaVWXEFvOsHBa+aBL
         6tWLhnuSA9/3+Qm8hi2ye400UuohLCw5lEIZ/DXFOOYJnmEFOSb7OXtAmoDJ7BMz1Wno
         70DA==
X-Gm-Message-State: AOAM531ad9nSBEcNXYnfWcgwxEwavAKqJQ8EirkSy48PvaxI7Pu+Xqlz
        5nhLcbFgaJV00hiojpo/IOT+u4mKBHGZkUGikAZQsbfWXA==
X-Google-Smtp-Source: ABdhPJzsZbQ7ihen17WA7PbruLek6pI4Sopk016R3wrhgsKb0Uz973J+uyHJFnMARhklFMXXgJYZnYrsJDj6KlBHh/Q=
X-Received: by 2002:a17:906:1d59:: with SMTP id o25mr1548975ejh.431.1630530347399;
 Wed, 01 Sep 2021 14:05:47 -0700 (PDT)
MIME-Version: 1.0
References: <c6864908-d093-1705-76ce-94d6af85e092@linux.alibaba.com>
 <18f0171e-0cc8-6ae6-d04a-a69a2a3c1a39@linux.alibaba.com> <7f239a0e-7a09-3dc0-43ce-27c19c7a309d@linux.alibaba.com>
 <4c000115-4069-5277-ce82-946f2fdb790a@linux.alibaba.com>
In-Reply-To: <4c000115-4069-5277-ce82-946f2fdb790a@linux.alibaba.com>
From:   Paul Moore <paul@paul-moore.com>
Date:   Wed, 1 Sep 2021 17:05:36 -0400
Message-ID: <CAHC9VhRBhCfX45V701rbGsvmOPQ4Nyp7dX2GA6NL8FxnA9akXg@mail.gmail.com>
Subject: Re: [PATCH] Revert "net: fix NULL pointer reference in cipso_v4_doi_free"
To:     =?UTF-8?B?546L6LSH?= <yun.wang@linux.alibaba.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Aug 31, 2021 at 10:21 PM =E7=8E=8B=E8=B4=87 <yun.wang@linux.alibaba=
.com> wrote:
>
> Hi Paul, it confused me since it's the first time I face
> such situation, but I just realized what you're asking is
> actually this revert, correct?

I believe DaveM already answered your question in the other thread,
but if you are still unsure about the patch let me know.

--=20
paul moore
www.paul-moore.com
