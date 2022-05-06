Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2891251D960
	for <lists+netdev@lfdr.de>; Fri,  6 May 2022 15:40:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1441800AbiEFNo0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 May 2022 09:44:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42328 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1441805AbiEFNoP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 May 2022 09:44:15 -0400
Received: from mail-ua1-x92d.google.com (mail-ua1-x92d.google.com [IPv6:2607:f8b0:4864:20::92d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0AC80FF1;
        Fri,  6 May 2022 06:40:27 -0700 (PDT)
Received: by mail-ua1-x92d.google.com with SMTP id v3so2811403uau.4;
        Fri, 06 May 2022 06:40:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=D/9vItxcPrE5lo7EB96aVhAnmOIWcTLzCizvmWL6Ah4=;
        b=fr2fU+qa4hg9UYIW009FfLE5XYSSZORij6uQE4lNiNIalBnDmI53UDcWW+vJ2+Ox59
         gNoaBxFtmK45PyVAe7qZRGGOVpzVQA2ZTGkcqJlEImBeVkcJ9tunYI3BMlBzHOW8yk12
         jyitijnxl7IHFRGoHMg4+AewudS9TmhisoNI3mw9Pin4uauAk/THtBZiBxq1GhXCV0AL
         WyEDX2vkHw04EH8IthHqkz2TV4YyH4dLjXMMnkipV9ccpBeXdvjPk5wo6UGvv+BDl9+M
         o0Ryv8ZA2ilpUkymIcoTaI51DsMtr5vS8V7qjVwrox9TqAqACJPhphaplzfw0O1mNSym
         tjDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=D/9vItxcPrE5lo7EB96aVhAnmOIWcTLzCizvmWL6Ah4=;
        b=LwcLKzelFhPRCW7H/FORSX4MjnvwAsNTXZWW7qs2AnP1vWeP1SbE0puFrJxFFfVU3S
         Hl0AldjOWO4LZil3TgX1F/7TsXmxZ6wPHAF6lmeWbBbtZyffHQ59VrRzi/deFqW06jxO
         n49wi3eY5bW308psTrQwEHX2OQxH9r9g8YdKUvHgitFCR2KNIlKdqXInDh70CnEtMd32
         R40Eld0Sfp+U4F6+lv8GSa2Re85pwsogxBsvcCs0ECVkbnGY4i6nGy2CqpriHIRzuAoI
         6Lfj9AqXy9uy5Ts3Du56lMSDTtxX1z3JP/gyti77pQuXmPtZmpgyzsFz4NrPiqxZdXI2
         5UZw==
X-Gm-Message-State: AOAM532q0cd8mWQziJ9IDjjCmldUVVvzx0nRKEdLwKeaP0hpr+nHi+xi
        UCJS/PzQvrhi6XGUwDUvf04iprs7s8IMTOGOKgI=
X-Google-Smtp-Source: ABdhPJyN9Jggh2tJChsGSAD6/TzoWYSV4/Eq/d2m38Kl3VJ7mkUdqk82StSXpinXxaZQoynb+WLYoisyyUBWoVzxafU=
X-Received: by 2002:ab0:375b:0:b0:355:c2b3:f6c with SMTP id
 i27-20020ab0375b000000b00355c2b30f6cmr973544uat.84.1651844425785; Fri, 06 May
 2022 06:40:25 -0700 (PDT)
MIME-Version: 1.0
References: <20220506011616.1774805-1-ricardo.martinez@linux.intel.com> <20220506011616.1774805-4-ricardo.martinez@linux.intel.com>
In-Reply-To: <20220506011616.1774805-4-ricardo.martinez@linux.intel.com>
From:   Sergey Ryazanov <ryazanov.s.a@gmail.com>
Date:   Fri, 6 May 2022 16:40:14 +0300
Message-ID: <CAHNKnsRqaKUJA7mjV5pdnPkCAiqtc3FD7wp29mzD=8zS988KqQ@mail.gmail.com>
Subject: Re: [PATCH net-next v7 03/14] net: wwan: t7xx: Add control DMA interface
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
> Cross Layer DMA (CLDMA) Hardware interface (HIF) enables the control
> path of Host-Modem data transfers. CLDMA HIF layer provides a common
> interface to the Port Layer.
>
> CLDMA manages 8 independent RX/TX physical channels with data flow
> control in HW queues. CLDMA uses ring buffers of General Packet
> Descriptors (GPD) for TX/RX. GPDs can represent multiple or single
> data buffers (DB).
>
> CLDMA HIF initializes GPD rings, registers ISR handlers for CLDMA
> interrupts, and initializes CLDMA HW registers.
>
> CLDMA TX flow:
> 1. Port Layer write
> 2. Get DB address
> 3. Configure GPD
> 4. Triggering processing via HW register write
>
> CLDMA RX flow:
> 1. CLDMA HW sends a RX "done" to host
> 2. Driver starts thread to safely read GPD
> 3. DB is sent to Port layer
> 4. Create a new buffer for GPD ring
>
> Note: This patch does not enable compilation since it has dependencies
> such as t7xx_pcie_mac_clear_int()/t7xx_pcie_mac_set_int() and
> struct t7xx_pci_dev which are added by the core patch.
>
> Signed-off-by: Haijun Liu <haijun.liu@mediatek.com>
> Signed-off-by: Chandrashekar Devegowda <chandrashekar.devegowda@intel.com=
>
> Co-developed-by: Ricardo Martinez <ricardo.martinez@linux.intel.com>
> Signed-off-by: Ricardo Martinez <ricardo.martinez@linux.intel.com>
> Reviewed-by: Loic Poulain <loic.poulain@linaro.org>
> Reviewed-by: Ilpo J=C3=A4rvinen <ilpo.jarvinen@linux.intel.com>

Reviewed-by: Sergey Ryazanov <ryazanov.s.a@gmail.com>
