Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9370951D968
	for <lists+netdev@lfdr.de>; Fri,  6 May 2022 15:40:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1441829AbiEFNoa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 May 2022 09:44:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42238 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1441828AbiEFNoZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 May 2022 09:44:25 -0400
Received: from mail-ua1-x92e.google.com (mail-ua1-x92e.google.com [IPv6:2607:f8b0:4864:20::92e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BFE18F18;
        Fri,  6 May 2022 06:40:33 -0700 (PDT)
Received: by mail-ua1-x92e.google.com with SMTP id x11so2815019uao.2;
        Fri, 06 May 2022 06:40:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=CVxGfvIdylztEKYqHZTungXdeVR8eiJqsSdWXIBE3g4=;
        b=XTOuxmzMuz3U4/5PMq3TnsW0JlFG0zetPXMJzm3TcnUxnDYYEfmCqw72YA3N/5eHTw
         J2i6bX/dSoJiutUQwV7NBw3D5pS/ucKGG4DrF+X/qlUWujVUnS0zXUQ8KL4JOjWxtvTV
         TX9kMMfcq3YM+XojNT8tVja581P8PYiR/8Oj0K0PC/I6lf7eACXCFvr2esEEmWddxX+o
         Oti6g3Jv+WNilg7t1FlaloS8VyCoFYXHSAjIOGLPhvDOzDDTc5f2/NC9Nk4BSi45Fzvs
         /+bHielUFBXpfQR45nfCPXIDDGteVbwmAruh4dQYbGJIguU4o/y2QNUMjC4bC/gUsg+m
         7sDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=CVxGfvIdylztEKYqHZTungXdeVR8eiJqsSdWXIBE3g4=;
        b=L5uujQCbvUWcJ17mLjsixgPd0j+Srja4QzNhoQUroZuAsHlcHl9xEEQfveH/sjZnaW
         pY6n6VpGfT6TGU5avmpuDb3MF7flC93ja62JbuVU6pLgHD57G9fxMto7gVMdtNR/kclf
         GjHhDjLSmyHCSS4hIQD8a/U6ciaDd15KoJIT7mbA31bZC4lGdlh0+aw92e6alJI7odzw
         GldQgLrmXk0DeNJYs72hqz9lPtRKk1H/LpDxJXXlrcyt8wbaZxYKFoy9bKwviEefe7Wb
         +lpzEcQRC0VT1ke8EhLH37po9ZtjSkR286dPLwdO50OOl0A/bFcBayIyAz1xQt85op9p
         /S7w==
X-Gm-Message-State: AOAM533AAEoQZy1Md67wMdOPIg9HfHZ58sCtZ7yi+lTUFtQe5gfYnV4W
        z+pdvdjiN7If+c3u4uFE3Zna3sCoipYIcq6Fjpk=
X-Google-Smtp-Source: ABdhPJx/hlhG3/R/h+5qG2kG/MGMx4mj5CtKDW6zYn4E7g68qtJnWZwBCdiAObl4WN1VfWYreQdYdUY/r91b1GdD4lA=
X-Received: by 2002:ab0:2002:0:b0:35f:fd13:960 with SMTP id
 v2-20020ab02002000000b0035ffd130960mr964247uak.50.1651844432899; Fri, 06 May
 2022 06:40:32 -0700 (PDT)
MIME-Version: 1.0
References: <20220506011616.1774805-1-ricardo.martinez@linux.intel.com> <20220506011616.1774805-6-ricardo.martinez@linux.intel.com>
In-Reply-To: <20220506011616.1774805-6-ricardo.martinez@linux.intel.com>
From:   Sergey Ryazanov <ryazanov.s.a@gmail.com>
Date:   Fri, 6 May 2022 16:40:22 +0300
Message-ID: <CAHNKnsQ8OkLsJ2V6QYjGLO_7fhJ1f7ZG-u=GTY2fg8669CBtOw@mail.gmail.com>
Subject: Re: [PATCH net-next v7 05/14] net: wwan: t7xx: Add port proxy infrastructure
To:     Ricardo Martinez <ricardo.martinez@linux.intel.com>
Cc:     netdev@vger.kernel.org, linux-wireless@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>,
        Johannes Berg <johannes@sipsolutions.net>,
        Loic Poulain <loic.poulain@linaro.org>,
        M Chetan Kumar <m.chetan.kumar@intel.com>,
        "Devegowda, Chandrashekar" <chandrashekar.devegowda@intel.com>,
        Intel Corporation <linuxwwan@intel.com>,
        chiranjeevi.rapolu@linux.intel.com,
        =?UTF-8?B?SGFpanVuIExpdSAo5YiY5rW35YabKQ==?= 
        <haijun.liu@mediatek.com>,
        "Hanania, Amir" <amir.hanania@intel.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        "Sharma, Dinesh" <dinesh.sharma@intel.com>,
        "Lee, Eliot" <eliot.lee@intel.com>,
        "Jarvinen, Ilpo Johannes" <ilpo.johannes.jarvinen@intel.com>,
        "Veleta, Moises" <moises.veleta@intel.com>,
        "Bossart, Pierre-louis" <pierre-louis.bossart@intel.com>,
        "Sethuraman, Muralidharan" <muralidharan.sethuraman@intel.com>,
        "Mishra, Soumya Prakash" <Soumya.Prakash.Mishra@intel.com>,
        "Kancharla, Sreehari" <sreehari.kancharla@intel.com>,
        "Sahu, Madhusmita" <madhusmita.sahu@intel.com>,
        =?UTF-8?Q?Ilpo_J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, May 6, 2022 at 4:16 AM Ricardo Martinez
<ricardo.martinez@linux.intel.com> wrote:
> Port-proxy provides a common interface to interact with different types
> of ports. Ports export their configuration via `struct t7xx_port` and
> operate as defined by `struct port_ops`.
>
> Signed-off-by: Haijun Liu <haijun.liu@mediatek.com>
> Co-developed-by: Chandrashekar Devegowda <chandrashekar.devegowda@intel.c=
om>
> Signed-off-by: Chandrashekar Devegowda <chandrashekar.devegowda@intel.com=
>
> Co-developed-by: Ricardo Martinez <ricardo.martinez@linux.intel.com>
> Signed-off-by: Ricardo Martinez <ricardo.martinez@linux.intel.com>
> Reviewed-by: Loic Poulain <loic.poulain@linaro.org>
> Reviewed-by: Ilpo J=C3=A4rvinen <ilpo.jarvinen@linux.intel.com>

Reviewed-by: Sergey Ryazanov <ryazanov.s.a@gmail.com>
