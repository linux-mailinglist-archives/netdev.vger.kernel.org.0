Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B02D8511A92
	for <lists+netdev@lfdr.de>; Wed, 27 Apr 2022 16:57:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235444AbiD0NVi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Apr 2022 09:21:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44424 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235530AbiD0NVg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Apr 2022 09:21:36 -0400
Received: from mail-vk1-xa29.google.com (mail-vk1-xa29.google.com [IPv6:2607:f8b0:4864:20::a29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C288127172;
        Wed, 27 Apr 2022 06:17:57 -0700 (PDT)
Received: by mail-vk1-xa29.google.com with SMTP id h144so485686vkh.3;
        Wed, 27 Apr 2022 06:17:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=uN2AvNgUuh26EShG8XGbjQPKMO5dYMYNA35xtbAlORY=;
        b=eOr/moldShOW+h3PPmtHh+ZMd9DBi5jhrB5PB5xFyTFk6TfNgfDw1kPV6sx6Mx1V1U
         Cns5hVwdsJbU6i8/HmivoJmleq7px++hl1J3EwyGLcOwwLRBNvxC4xyKlexkAC+GCVKZ
         2g/bKjaK8YQ2gcGukqjKgQ4WdPFSR9ur2xSyns9tz+8FCYtf0b5FrJjS3uc/Xwub3Qgl
         YzDpXY2pDhEGF8lNzRVGDcgXN/rW/aWYUgF8JmAX+CpHbGU2CScT5wAPk/5WbEDfjgIW
         BRrwIJGxbFAhZmspPuwvWPMf4HICsLunIx9g8dY0ZaQyGjfCknC+j5Mx+cfveZ+Ay+u7
         97ZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=uN2AvNgUuh26EShG8XGbjQPKMO5dYMYNA35xtbAlORY=;
        b=HKw8Dg8yKzL25uSahuDHfvKGzsjqQKoWUPTeb5FJvFbVP+t08vc5wKI3ppmsSdAgz6
         6NULfZ0BhbHedpXmFqhE0e5n7WrKBr0q/vRWGnSv+ic+1aYrAw7YebLqLOtKZ01ARekB
         3KSMAPnO8oWxVrfXYadpjuYJh1PnQXAWB4DpASer5duSTY5yrFVkjAmG5S7TrI31l27U
         lbqgunixAtX1L2ow66vdfwCLvxTKuqcdzbLqeCz/4FQiOBrQVTKDQtBQcVumFwqSzE4D
         1xu5oXaPvHdTthAuHo7wP3pYI1xZpfdGGo7mP1W/DG/oBFFdR8byFbCHnMLpfCOpaRWy
         iz6Q==
X-Gm-Message-State: AOAM533GTz4l8L7lDkFvOeDUbHQlX8oBwTyyQqcXx1umMzQM8X1oMSuA
        j59vW/+/1r20elOrZZl65+XjFWKK3l6iwPMrbQk=
X-Google-Smtp-Source: ABdhPJxy3WAzAZGtx686mGmZjiKglH7VD4zj+A6zktnSEohH6OWYf2drz2Bft82edO1fD2t6wcpakq1ftEMw+A7ZXeA=
X-Received: by 2002:a1f:278b:0:b0:34d:34f3:3596 with SMTP id
 n133-20020a1f278b000000b0034d34f33596mr5900763vkn.25.1651065476900; Wed, 27
 Apr 2022 06:17:56 -0700 (PDT)
MIME-Version: 1.0
References: <20220407223629.21487-1-ricardo.martinez@linux.intel.com>
 <20220407223629.21487-3-ricardo.martinez@linux.intel.com> <CAHNKnsRt=H_tkqG7CNf15DBYJmmunYy6vsm4HjneN47EQB_uug@mail.gmail.com>
 <CAMZdPi90Joo8+_44ceqS3k8ez08W_AX-eWs42F0ztDN67WR2Pw@mail.gmail.com>
In-Reply-To: <CAMZdPi90Joo8+_44ceqS3k8ez08W_AX-eWs42F0ztDN67WR2Pw@mail.gmail.com>
From:   Sergey Ryazanov <ryazanov.s.a@gmail.com>
Date:   Wed, 27 Apr 2022 16:17:45 +0300
Message-ID: <CAHNKnsTh0A85XTy8+Gk-3dCFee9ynB3+r0S3HcwJ8DkM5e4ADg@mail.gmail.com>
Subject: Re: [PATCH net-next v6 02/13] net: wwan: t7xx: Add control DMA interface
To:     Loic Poulain <loic.poulain@linaro.org>
Cc:     Ricardo Martinez <ricardo.martinez@linux.intel.com>,
        netdev@vger.kernel.org, linux-wireless@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>,
        Johannes Berg <johannes@sipsolutions.net>,
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
        "Sahu, Madhusmita" <madhusmita.sahu@intel.com>
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

On Wed, Apr 27, 2022 at 3:35 PM Loic Poulain <loic.poulain@linaro.org> wrot=
e:
> On Tue, 26 Apr 2022 at 02:19, Sergey Ryazanov <ryazanov.s.a@gmail.com> wr=
ote:
>> On Fri, Apr 8, 2022 at 1:37 AM Ricardo Martinez
>> <ricardo.martinez@linux.intel.com> wrote:
>>> ...
>>> Co-developed-by: Ricardo Martinez <ricardo.martinez@linux.intel.com>
>>> Signed-off-by: Ricardo Martinez <ricardo.martinez@linux.intel.com>
>>>
>>> From a WWAN framework perspective:
>>> Reviewed-by: Loic Poulain <loic.poulain@linaro.org>
>>>
>>> Reviewed-by: Ilpo J=C3=A4rvinen <ilpo.jarvinen@linux.intel.com>
>>
>> This line with "From a WWAN framework perspective" looks confusing to
>> me. Anyone not familiar with all of the iterations will be in doubt as
>> to whether it belongs only to Loic's review or to both of them.
>>
>> How about to format this block like this:
>>
>>> Co-developed-by: Ricardo Martinez <ricardo.martinez@linux.intel.com>
>>> Signed-off-by: Ricardo Martinez <ricardo.martinez@linux.intel.com>
>>> Reviewed-by: Loic Poulain <loic.poulain@linaro.org> (WWAN framework)
>>> Reviewed-by: Ilpo J=C3=A4rvinen <ilpo.jarvinen@linux.intel.com>
>>
>> or like this:
>>
>>> Co-developed-by: Ricardo Martinez <ricardo.martinez@linux.intel.com>
>>> Signed-off-by: Ricardo Martinez <ricardo.martinez@linux.intel.com>
>>> Reviewed-by: Loic Poulain <loic.poulain@linaro.org> # WWAN framework
>>> Reviewed-by: Ilpo J=C3=A4rvinen <ilpo.jarvinen@linux.intel.com>
>>
>> Parentheses vs. comment sign. I saw people use both of these formats,
>> I just do not know which is better. What do you think?
>
> My initial comment was to highlight that someone else should double
> check the network code, but it wasn't expected to end up in the commit
> message. Maybe simply drop this extra comment?

Yep, this drastically solves the problem with comment format :) I do not mi=
nd.

--=20
Sergey
