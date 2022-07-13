Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 12D54573F0E
	for <lists+netdev@lfdr.de>; Wed, 13 Jul 2022 23:36:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231747AbiGMVge (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Jul 2022 17:36:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55770 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231187AbiGMVge (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Jul 2022 17:36:34 -0400
Received: from mail-ot1-x335.google.com (mail-ot1-x335.google.com [IPv6:2607:f8b0:4864:20::335])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9DA9A27FFB
        for <netdev@vger.kernel.org>; Wed, 13 Jul 2022 14:36:31 -0700 (PDT)
Received: by mail-ot1-x335.google.com with SMTP id v19-20020a9d69d3000000b0061c78772699so52204oto.11
        for <netdev@vger.kernel.org>; Wed, 13 Jul 2022 14:36:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=S2a8cxN9enEHki4oCS8X4bF9eRYJoXJx8GN/D4bN38I=;
        b=FAXTQN8tE8aKB3xReV3emmffG9pjylTPWt2UQcR4G9OG4uvLwTGYXMyk5oDg7fh+g3
         nNhPMfKJH8/agiCtUJOQTcHAJXZOxf4HNC7IG6RQb62cFGGC33drzV/RArJkKdPT1Lio
         omO/W/W7xKXvbNfAZ+4MpT5HuyZD+b3M2jjCU95qcA+h5a4LtS483pHDugRPARTEjcrh
         RwRZxnn160PrziEAft8F5PxJ+qB5rlpzkMOuQfbK7rNiun5PLUJm5nicVTzZmsfck9qK
         BoABW2Dbp1qxgLOTCBuwl9ClyEhvEGxQWQe/lB47T43WL3imm5lqOF3hDSlf01s4jZXm
         PHjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=S2a8cxN9enEHki4oCS8X4bF9eRYJoXJx8GN/D4bN38I=;
        b=XrXtOOkaMstojHhQsuIF/BFzHJyj19Ds7vke/ZXPcWwehtog+OzL4NIi0kiEnc+Fpe
         qO3WhDGPkEEHI/0H7P3jhFEv8rmbahMzF+grhbu/OhVT37VoM2Vaywh94Qu539Uxh2oL
         20KmZoW6FHyNn6HtLyMu0zyL1p2i467CHfgsqX2ADJJxspgeimhE5yW7NPDv8lyxVo7l
         PpKDOvaG9WhZtzWMbADUeURyyzkBS9oDktHOvQN4jlmQ0thsZDLdyRlfdWQRWgQGTQKo
         Sa7ut2GbAYQyxmFI05sYxRnvxp6fm5DkPgozG98Q9dFaHt5rKjBhxl8lOFbLITMof/QJ
         8qhA==
X-Gm-Message-State: AJIora+xjASPS30Uys8kSI0Kau+NZrup18gh40c+V2f1iQcVANDCTwhz
        xMt+keHdg/rw2ZgbuQShZXqp30Z5t5gli2Aal4F0zqhAq5K9Pg==
X-Google-Smtp-Source: AGRyM1v1GzXDF81lLoHoUhVkukT6+8eOFe0zZl2OfoiiuOGxBEav6MiA9B2KE/6vfB6qF9m0GRTx4eifPZTSMBxJrKI=
X-Received: by 2002:a9d:337:0:b0:61c:576b:dc08 with SMTP id
 52-20020a9d0337000000b0061c576bdc08mr2215381otv.170.1657748191014; Wed, 13
 Jul 2022 14:36:31 -0700 (PDT)
MIME-Version: 1.0
References: <20220713170653.11328-1-moises.veleta@linux.intel.com>
 <CAHNKnsTq+-_sgPsuqG1ohqVVwJfU-Gq_QJ7kQO8gwyLbQHKwiA@mail.gmail.com>
 <06e9db15-f5a2-c4ca-8750-c1909fdaf0a9@linux.intel.com> <CAHNKnsQ-WG7_-Z6zxbe193D-kXzN1SbC76r3eQmo5oAhCNqr0w@mail.gmail.com>
 <18532582-90b8-d128-bcc6-7548ce2d107b@linux.intel.com>
In-Reply-To: <18532582-90b8-d128-bcc6-7548ce2d107b@linux.intel.com>
From:   Sergey Ryazanov <ryazanov.s.a@gmail.com>
Date:   Thu, 14 Jul 2022 00:36:18 +0300
Message-ID: <CAHNKnsQ348NEdrCh4HbxeFUWc6PfLsRzPvkobPAmr5GnU5wNew@mail.gmail.com>
Subject: Re: [PATCH net-next v3 1/1] net: wwan: t7xx: Add AP CLDMA
To:     "moises.veleta" <moises.veleta@linux.intel.com>
Cc:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>,
        Johannes Berg <johannes@sipsolutions.net>,
        Loic Poulain <loic.poulain@linaro.org>,
        M Chetan Kumar <m.chetan.kumar@intel.com>,
        "Devegowda, Chandrashekar" <chandrashekar.devegowda@intel.com>,
        Intel Corporation <linuxwwan@intel.com>,
        chiranjeevi.rapolu@linux.intel.com,
        =?UTF-8?B?SGFpanVuIExpdSAo5YiY5rW35YabKQ==?= 
        <haijun.liu@mediatek.com>,
        Ricardo Martinez <ricardo.martinez@linux.intel.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        "Sharma, Dinesh" <dinesh.sharma@intel.com>,
        =?UTF-8?Q?Ilpo_J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
        ram.mohan.reddy.boggala@intel.com,
        "Veleta, Moises" <moises.veleta@intel.com>,
        Madhusmita Sahu <madhusmita.sahu@intel.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 14, 2022 at 12:14 AM moises.veleta
<moises.veleta@linux.intel.com> wrote:
> On 7/13/22 14:03, Sergey Ryazanov wrote:
>> On Wed, Jul 13, 2022 at 11:53 PM moises.veleta
>> <moises.veleta@linux.intel.com> wrote:
>>> Hi Sergey
>>>
>>> On 7/13/22 13:39, Sergey Ryazanov wrote:
>>>> Hello Moises,
>>>>
>>>> On Wed, Jul 13, 2022 at 8:07 PM Moises Veleta
>>>> <moises.veleta@linux.intel.com> wrote:
>>>>> From: Haijun Liu <haijun.liu@mediatek.com>
>>>>>
>>>>> The t7xx device contains two Cross Layer DMA (CLDMA) interfaces to
>>>>> communicate with AP and Modem processors respectively. So far only
>>>>> MD-CLDMA was being used, this patch enables AP-CLDMA.
>>>> What is the purpose of adding the driver interface to the hardware
>>>> function without a user counterpart?
>>>>
>>> We have follow-on features/submissiona that are dependent on this AP
>>> control port: PCIe rescan,  FW flashing via devlink, & Coredump log
>>> collection. They will be submitted for review upon completion by
>>> different individuals. This foreruns their efforts.
>> Thanks for the explanation. Is it possible to send these parts as a
>> single series? If not all at once, then at least AP-CLDMA + FW
>> flashing or AP-CLDMA + logs collection or some other provider + user
>> composition. What do you think?
>>
> I believe this is possible. I will share this information with them and
> see how we can package them into a series. Since, it appears this patch
> has been reviewed well by the community, it should not be hindrance for
> their later submissions. Thanks for guidance and feedback.

Sounds like a good plan. I will wait for the series with new
functionality. Thank you for continuing to develop the driver!

-- 
Sergey
