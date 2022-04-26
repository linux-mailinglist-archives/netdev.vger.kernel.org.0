Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7DE7350ED7F
	for <lists+netdev@lfdr.de>; Tue, 26 Apr 2022 02:19:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238291AbiDZAWJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Apr 2022 20:22:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51232 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230087AbiDZAWI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Apr 2022 20:22:08 -0400
Received: from mail-vk1-xa2f.google.com (mail-vk1-xa2f.google.com [IPv6:2607:f8b0:4864:20::a2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB4541240E9;
        Mon, 25 Apr 2022 17:19:02 -0700 (PDT)
Received: by mail-vk1-xa2f.google.com with SMTP id d132so3168647vke.0;
        Mon, 25 Apr 2022 17:19:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=JcShw88rT2b4kuhXSIORC/0deuJ5kC0IXbgAX0EZqzI=;
        b=ojI3z3raSNQCvhA/UQJtkSNLzwjX1wo+WliYB1VAgA8BdUjqJCaYzVo2HiZ9PEsL70
         Who3s6o+1QXudT38AkZqLMf0hH3BYN/QLG4Hnly422lyJUgOj8bOefaVjOi5SLtcta2X
         9RH6xvxZCK6Z17BYU1e1ouxnw4pK2ydtLre7HtUcd7VnoDYVIq1uSD9ZgIkjBkIZO6e2
         FF18yW11sFk6BDny+NBqIZRPJ5ISmPjb+1l8D8M+QM2AnKabS2tYj57HKbNwsvUNeHvT
         vBeuX4HF0otQkMhof7S5Y9svmybH9WxQU3n0IqJBTNDG1VMLPweSLNcdRb5g2yv1kYOF
         AA1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=JcShw88rT2b4kuhXSIORC/0deuJ5kC0IXbgAX0EZqzI=;
        b=QWwLfFPr9wkkbnT51mwReSONe2mjBZ4EWl4lnIf2F2673jGCauw1ucF0m3QZqbQ4w0
         QMM0wo+yaXfuobs6iXwqOocRBRsCb6BAP/WXteGVkpr9HtDysJqr+7bMhlxOTwAPeTN+
         Fk6o1DCXWQyDt8H+LcUO3U5uml+V0BHgt3Geg2zbT9NlKETFc+bcXQAK5o4cOIYZi4BR
         BxCx+o5IhmdbvttIcnUc2UZ+uVigv9IkxyXbcrpQXWvKEpJb8Q94xKgdWIEItqyFME8T
         cZAZRnZ8uWytx+NHDKUH3oe1ScLjiCburTTqZxwcX5YnY8iUAOrGRbmF8xStcjnAho0G
         3KWA==
X-Gm-Message-State: AOAM531/MQ3zoF7iHz+J3R1DgwYKRAp8S4f2MS4CMGuaZZXwcrtJaPJ9
        xIg0IlYn8la5QZZrkYSRZl8oQ2zKPcJhKRC1PwA=
X-Google-Smtp-Source: ABdhPJwN1wfjTGEQLN0mdwyxiTCKEtaGAdKOb89ooui9k2WgWz153e5mvCcmJ+ITcLhn7kcnVB1n3tycIml4XI3vzOY=
X-Received: by 2002:a1f:9dca:0:b0:349:6bb2:1c1a with SMTP id
 g193-20020a1f9dca000000b003496bb21c1amr6083936vke.1.1650932341906; Mon, 25
 Apr 2022 17:19:01 -0700 (PDT)
MIME-Version: 1.0
References: <20220407223629.21487-1-ricardo.martinez@linux.intel.com> <20220407223629.21487-3-ricardo.martinez@linux.intel.com>
In-Reply-To: <20220407223629.21487-3-ricardo.martinez@linux.intel.com>
From:   Sergey Ryazanov <ryazanov.s.a@gmail.com>
Date:   Tue, 26 Apr 2022 03:19:01 +0300
Message-ID: <CAHNKnsRt=H_tkqG7CNf15DBYJmmunYy6vsm4HjneN47EQB_uug@mail.gmail.com>
Subject: Re: [PATCH net-next v6 02/13] net: wwan: t7xx: Add control DMA interface
To:     Ricardo Martinez <ricardo.martinez@linux.intel.com>,
        Loic Poulain <loic.poulain@linaro.org>
Cc:     netdev@vger.kernel.org, linux-wireless@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>,
        Johannes Berg <johannes@sipsolutions.net>,
        M Chetan Kumar <m.chetan.kumar@intel.com>,
        chandrashekar.devegowda@intel.com,
        Intel Corporation <linuxwwan@intel.com>,
        chiranjeevi.rapolu@linux.intel.com,
        =?UTF-8?B?SGFpanVuIExpdSAo5YiY5rW35YabKQ==?= 
        <haijun.liu@mediatek.com>, amir.hanania@intel.com,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        dinesh.sharma@intel.com, eliot.lee@intel.com,
        ilpo.johannes.jarvinen@intel.com, moises.veleta@intel.com,
        pierre-louis.bossart@intel.com, muralidharan.sethuraman@intel.com,
        Soumya.Prakash.Mishra@intel.com, sreehari.kancharla@intel.com,
        madhusmita.sahu@intel.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello Ricardo, Loic, Ilpo,

On Fri, Apr 8, 2022 at 1:37 AM Ricardo Martinez
<ricardo.martinez@linux.intel.com> wrote:
> ...
> Co-developed-by: Ricardo Martinez <ricardo.martinez@linux.intel.com>
> Signed-off-by: Ricardo Martinez <ricardo.martinez@linux.intel.com>
>
> From a WWAN framework perspective:
> Reviewed-by: Loic Poulain <loic.poulain@linaro.org>
>
> Reviewed-by: Ilpo J=C3=A4rvinen <ilpo.jarvinen@linux.intel.com>

This line with "From a WWAN framework perspective" looks confusing to
me. Anyone not familiar with all of the iterations will be in doubt as
to whether it belongs only to Loic's review or to both of them.

How about to format this block like this:

> Co-developed-by: Ricardo Martinez <ricardo.martinez@linux.intel.com>
> Signed-off-by: Ricardo Martinez <ricardo.martinez@linux.intel.com>
> Reviewed-by: Loic Poulain <loic.poulain@linaro.org> (WWAN framework)
> Reviewed-by: Ilpo J=C3=A4rvinen <ilpo.jarvinen@linux.intel.com>

or like this:

> Co-developed-by: Ricardo Martinez <ricardo.martinez@linux.intel.com>
> Signed-off-by: Ricardo Martinez <ricardo.martinez@linux.intel.com>
> Reviewed-by: Loic Poulain <loic.poulain@linaro.org> # WWAN framework
> Reviewed-by: Ilpo J=C3=A4rvinen <ilpo.jarvinen@linux.intel.com>

Parentheses vs. comment sign. I saw people use both of these formats,
I just do not know which is better. What do you think?

--
Sergey
