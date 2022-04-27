Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5B8DE510E2D
	for <lists+netdev@lfdr.de>; Wed, 27 Apr 2022 03:47:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356775AbiD0BjJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Apr 2022 21:39:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38808 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351147AbiD0BjI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Apr 2022 21:39:08 -0400
Received: from mail-ua1-x933.google.com (mail-ua1-x933.google.com [IPv6:2607:f8b0:4864:20::933])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 20D54DFDE;
        Tue, 26 Apr 2022 18:35:59 -0700 (PDT)
Received: by mail-ua1-x933.google.com with SMTP id az13so88895uab.13;
        Tue, 26 Apr 2022 18:35:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=/GTP1Ij9ZJMMooI6eS22+QuUn9jrqBvk1je1hsyKuPo=;
        b=lCMCto1ZG06tjcFOHLHoplrUCEZhV4S3INk9fjek5AXQclh3ptUFAV2jDqi74ykNxm
         J6b1RMMQQ5mOjQfnYeaWMcgAYrLmB7AmvHKLD2aivY2z3rTPtnIGpUj9FX3rCehoQV/i
         bZgY6U25ibxcUHE+oQ7NmavUe7BM9vMka9KFUMTZNAFw8YOS5KfWd5gtmi2DJ6H89Lut
         DPwshVPC86NWyTRKP2ljZk+Kqx8sARjFaV3nMTthgbhalxvCM6U3/4Bq7Xf3QFUxjQOY
         NCWqSmpjjIItxku8IKI53c0mM36g1C+DWvAeu1g2ZFHlCuSJHnnDkiVx82o9sRHRc4/A
         orQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=/GTP1Ij9ZJMMooI6eS22+QuUn9jrqBvk1je1hsyKuPo=;
        b=jsfYIXC8+vnknugQr15JtTaVBTbo+f4uDK7j5lZgVQAhYxdwPlrn+udkCHE9O96Rv/
         QzMDDMZoMIXmUVs9EvHZDhICoeNXqwQYiLHdTuz5zeTL+l5sGrXmr0L2YZ39D55grJAI
         IbtkLDNbXI26Fg6e08fwhrKH0cINEYj8HCMAUI2ASYHqMnawQP8wQ7bQPSXIXuqfcHPt
         nV84Brz+nTFb5lZiPgQSqMCtS93LU7Cee7D7RD9gFN0sqJW7YnvERhlzMLvKO0U3PPjw
         iTESeKgY0KcM4HJD2XSwTLLbgBU6LVxyItSwja71ugTJ3lOO4Lu1RbNBt9z0MuDfNKLX
         jHXA==
X-Gm-Message-State: AOAM530CoB2sx98C4affjGsS1PwxxBdRJQPfgW/lTaiBI3iqLazI780l
        gQMFA2v2bv7bYb1eyWwD5nJ1WQT15gUg7oDSW6k=
X-Google-Smtp-Source: ABdhPJycgEaO1pNrzefI4ELg3+VH1T2fKfprmHXlTSv3As/Lblp5nVu5lcC7CkYkcBGjg69MONvaFILMgYi9eVuAeIo=
X-Received: by 2002:ab0:2002:0:b0:35f:fd13:960 with SMTP id
 v2-20020ab02002000000b0035ffd130960mr7833994uak.50.1651023358245; Tue, 26 Apr
 2022 18:35:58 -0700 (PDT)
MIME-Version: 1.0
References: <20220407223629.21487-1-ricardo.martinez@linux.intel.com>
 <20220407223629.21487-5-ricardo.martinez@linux.intel.com> <CAHNKnsQWThUnMnk6ruGek9cuDKOAcPa18nA7-CgLf58=iEgE0g@mail.gmail.com>
 <MWHPR1101MB231920A2152DC2FC7B2FBB3CE0FB9@MWHPR1101MB2319.namprd11.prod.outlook.com>
 <CAHNKnsQLwMMpFjOVvJUt5927g5dGUKAe_rNRuEBgCRR=KuipPg@mail.gmail.com> <MWHPR1101MB2319F7A27B51ECD998855494E0FA9@MWHPR1101MB2319.namprd11.prod.outlook.com>
In-Reply-To: <MWHPR1101MB2319F7A27B51ECD998855494E0FA9@MWHPR1101MB2319.namprd11.prod.outlook.com>
From:   Sergey Ryazanov <ryazanov.s.a@gmail.com>
Date:   Wed, 27 Apr 2022 04:35:58 +0300
Message-ID: <CAHNKnsTQALBBxgN7J2fKO57eDz8P3qJ5797XrFbPRB4MCir5jQ@mail.gmail.com>
Subject: Re: [PATCH net-next v6 04/13] net: wwan: t7xx: Add port proxy infrastructure
To:     "Veleta, Moises" <moises.veleta@intel.com>
Cc:     Ricardo Martinez <ricardo.martinez@linux.intel.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>,
        Johannes Berg <johannes@sipsolutions.net>,
        Loic Poulain <loic.poulain@linaro.org>,
        "Kumar, M Chetan" <m.chetan.kumar@intel.com>,
        "Devegowda, Chandrashekar" <chandrashekar.devegowda@intel.com>,
        linuxwwan <linuxwwan@intel.com>,
        "chiranjeevi.rapolu@linux.intel.com" 
        <chiranjeevi.rapolu@linux.intel.com>,
        "Liu, Haijun" <haijun.liu@mediatek.com>,
        "Hanania, Amir" <amir.hanania@intel.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        "Sharma, Dinesh" <dinesh.sharma@intel.com>,
        "Lee, Eliot" <eliot.lee@intel.com>,
        "Jarvinen, Ilpo Johannes" <ilpo.johannes.jarvinen@intel.com>,
        "Bossart, Pierre-louis" <pierre-louis.bossart@intel.com>,
        "Sethuraman, Muralidharan" <muralidharan.sethuraman@intel.com>,
        "Mishra, Soumya Prakash" <soumya.prakash.mishra@intel.com>,
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

On Wed, Apr 27, 2022 at 4:14 AM Veleta, Moises <moises.veleta@intel.com> wr=
ote:
> From: Sergey Ryazanov <ryazanov.s.a@gmail.com>
> Sent: Tuesday, April 26, 2022 4:06 PM
> To: Veleta, Moises <moises.veleta@intel.com>
> Cc: Ricardo Martinez <ricardo.martinez@linux.intel.com>; netdev@vger.kern=
el.org <netdev@vger.kernel.org>; linux-wireless@vger.kernel.org <linux-wire=
less@vger.kernel.org>; Jakub Kicinski <kuba@kernel.org>; David Miller <dave=
m@davemloft.net>; Johannes Berg <johannes@sipsolutions.net>; Loic Poulain <=
loic.poulain@linaro.org>; Kumar, M Chetan <m.chetan.kumar@intel.com>; Deveg=
owda, Chandrashekar <chandrashekar.devegowda@intel.com>; linuxwwan <linuxww=
an@intel.com>; chiranjeevi.rapolu@linux.intel.com <chiranjeevi.rapolu@linux=
.intel.com>; Liu, Haijun <haijun.liu@mediatek.com>; Hanania, Amir <amir.han=
ania@intel.com>; Andy Shevchenko <andriy.shevchenko@linux.intel.com>; Sharm=
a, Dinesh <dinesh.sharma@intel.com>; Lee, Eliot <eliot.lee@intel.com>; Jarv=
inen, Ilpo Johannes <ilpo.johannes.jarvinen@intel.com>; Bossart, Pierre-lou=
is <pierre-louis.bossart@intel.com>; Sethuraman, Muralidharan <muralidharan=
.sethuraman@intel.com>; Mishra, Soumya Prakash <soumya.prakash.mishra@intel=
.com>; Kancharla, Sreehari <sreehari.kancharla@intel.com>; Sahu, Madhusmita=
 <madhusmita.sahu@intel.com>
> Subject: Re: [PATCH net-next v6 04/13] net: wwan: t7xx: Add port proxy in=
frastructure
>
> Hello Moises,
>
> On Tue, Apr 26, 2022 at 10:46 PM Veleta, Moises <moises.veleta@intel.com>=
 wrote:
>> From: Sergey Ryazanov <ryazanov.s.a@gmail.com>
>> Sent: Monday, April 25, 2022 4:53 PM
>> To: Ricardo Martinez <ricardo.martinez@linux.intel.com>
>> Cc: netdev@vger.kernel.org <netdev@vger.kernel.org>; linux-wireless@vger=
.kernel.org <linux-wireless@vger.kernel.org>; Jakub Kicinski <kuba@kernel.o=
rg>; David Miller <davem@davemloft.net>; Johannes Berg <johannes@sipsolutio=
ns.net>; Loic Poulain <loic.poulain@linaro.org>; Kumar, M Chetan <m.chetan.=
kumar@intel.com>; Devegowda, Chandrashekar <chandrashekar.devegowda@intel.c=
om>; linuxwwan <linuxwwan@intel.com>; chiranjeevi.rapolu@linux.intel.com <c=
hiranjeevi.rapolu@linux.intel.com>; Liu, Haijun <haijun.liu@mediatek.com>; =
Hanania, Amir <amir.hanania@intel.com>; Andy Shevchenko <andriy.shevchenko@=
linux.intel.com>; Sharma, Dinesh <dinesh.sharma@intel.com>; Lee, Eliot <eli=
ot.lee@intel.com>; Jarvinen, Ilpo Johannes <ilpo.johannes.jarvinen@intel.co=
m>; Veleta, Moises <moises.veleta@intel.com>; Bossart, Pierre-louis <pierre=
-louis.bossart@intel.com>; Sethuraman, Muralidharan <muralidharan.sethurama=
n@intel.com>; Mishra, Soumya Prakash <soumya.prakash.mishra@intel.com>; Kan=
charla, Sreehari <sreehari.kancharla@intel.com>; Sahu, Madhusmita <madhusmi=
ta.sahu@intel.com>
>> Subject: Re: [PATCH net-next v6 04/13] net: wwan: t7xx: Add port proxy i=
nfrastructure
>>
>> On Fri, Apr 8, 2022 at 1:37 AM Ricardo Martinez
>> <ricardo.martinez@linux.intel.com> wrote:
>>> Port-proxy provides a common interface to interact with different types
>>> of ports. Ports export their configuration via `struct t7xx_port` and
>>> operate as defined by `struct port_ops`.
>>>
>>> Signed-off-by: Haijun Liu <haijun.liu@mediatek.com>
>>> Co-developed-by: Chandrashekar Devegowda <chandrashekar.devegowda@intel=
.com>
>>> Signed-off-by: Chandrashekar Devegowda <chandrashekar.devegowda@intel.c=
om>
>>> Co-developed-by: Ricardo Martinez <ricardo.martinez@linux.intel.com>
>>> Signed-off-by: Ricardo Martinez <ricardo.martinez@linux.intel.com>
>>>
>>> From a WWAN framework perspective:
>>> Reviewed-by: Loic Poulain <loic.poulain@linaro.org>
>>
>> [skipped]
>>
>>> +int t7xx_port_enqueue_skb(struct t7xx_port *port, struct sk_buff *skb)
>>> +{
>>> +       unsigned long flags;
>>> +
>>> +       spin_lock_irqsave(&port->rx_wq.lock, flags);
>>> +       if (port->rx_skb_list.qlen >=3D port->rx_length_th) {
>>> +               spin_unlock_irqrestore(&port->rx_wq.lock, flags);
>>
>> Probably skb should be freed here before returning. The caller assumes
>> that skb will be consumed even in case of error.
>>
>> [MV] We do not drop port ctrl messages. We keep them and try again later=
.
>> Whereas WWAN skbs are dropped if conditions are met.
>
> I missed that the WWAN port returns no error when it drops the skb.
> And then I concluded that any failure to process the CCCI message
> should be accomplished with the skb freeing. Now the handling of CCCI
> messages is more clear to me. Thank you for the clarifications!
>
> To avoid similar misinterpretation in the future, I thought that the
> skb freeing in the WWAN port worth a comment. Something to describe
> that despite dropping the message, the return code is zero, indicating
> skb consumption. Similarly in this (t7xx_port_enqueue_skb) function.
> Something like: "return an error here, the caller will try again
> later". And maybe in t7xx_cldma_gpd_rx_from_q() near the loop break
> after the .skb_recv() failure test. Something like: "break message
> processing for now will try this message later".
>
> What do you think?
>
> Yes, that would remove the unintended obfuscation . Unless, you think thi=
s approach is inappropriate
> and should be refactored.  Otherwise, I will proceed with adding those cl=
arifying comments.
> Thank you.

I am Ok with the current approach. It does not contain obvious errors.
It might look puzzled, but proper comments should solve this.

--=20
Sergey
