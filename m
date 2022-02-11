Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 44CE84B1A62
	for <lists+netdev@lfdr.de>; Fri, 11 Feb 2022 01:25:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346314AbiBKAZc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Feb 2022 19:25:32 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:55632 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345707AbiBKAZb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Feb 2022 19:25:31 -0500
Received: from mail-vs1-xe29.google.com (mail-vs1-xe29.google.com [IPv6:2607:f8b0:4864:20::e29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E32145594;
        Thu, 10 Feb 2022 16:25:31 -0800 (PST)
Received: by mail-vs1-xe29.google.com with SMTP id t184so8399687vst.13;
        Thu, 10 Feb 2022 16:25:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=XsFEH8aEgkgHkeo10lC/NBTETZY5bC6A1Dsa3VentE8=;
        b=TCzw4iKVnFA3wJCZFhzjB1KClTtQOs1KVM+jciYqMIjeBS/ATybF3d7XprHuPT72sL
         NH9Iaa4KFYhrz3YTyIqS74pprfnbPDMN734pMwXtb0kQuKc9VKEPS2oulONZtmggU/X3
         QmZfyk22kskIUWlfTMcdeH2BgxGKKX7ubXLN8ZVvGUl/nqpc7aHUAueOWVbDHa8J2jC0
         6w7Ddel5r3wKyl13wJJVMmXOA7eb4E7HCLvf9MPXET6QZNwBM6CPYOvhP0eCqyQdTnPY
         zjB8ueB60nvhTz8al3IMZLAfxwIqalLMIbPv/usHlHfXWzhpJjVMpUZS1QKzzQfhROpr
         2P5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=XsFEH8aEgkgHkeo10lC/NBTETZY5bC6A1Dsa3VentE8=;
        b=JMOLnVgwKSN/vVohTy8SJv6VOnb8XmRxd7+gdGJb5Wqwgs1vDqjhTOdRM1BlMj+r/k
         b3LeJvANHUC+Gmqrz1ERZ4Yw5Wh6IuoVEplqliEvERDuZ5RBomE3NjbgCXCR1uK4AyUa
         n9hY3Y6s/He2/8lXexM5DQNIgFw9TqwNZCPEtJyK+4cK3bOy/V1WzlhSwAQ07M3gpyXg
         fbJOeXFOxh7QZwypAnN4JXcnX6B98kxBC++BEetfjimR/FWAnYx2kyZ/6cSKHSj9M/tg
         Djlq1GbfpnfGl5ByQbR9K35baOCE3JLFepkQCGlyDL0/ZgmyzzQr8+KsNlrWHVcLRoEn
         owzw==
X-Gm-Message-State: AOAM531LdVTniuc3/8U2iYczVmZC4jHLl5xY3THc6NR/U8beJTbHRvD9
        MrCkJNouKpIJw5CLq640GC/3N4ILsnpbrMcDG00=
X-Google-Smtp-Source: ABdhPJy+DVx47o6CflVet9riBFfvd0SjNbHLahFbTkbkxbmupv1eEoDGkqdqRBcv7nVgbUR9TPZixuDSkUCTEyedrjM=
X-Received: by 2002:a05:6102:2e3:: with SMTP id j3mr3679038vsj.32.1644539131086;
 Thu, 10 Feb 2022 16:25:31 -0800 (PST)
MIME-Version: 1.0
References: <20220114010627.21104-1-ricardo.martinez@linux.intel.com>
 <20220114010627.21104-3-ricardo.martinez@linux.intel.com> <d5854453-84b-1eba-7cc7-d94f41a185d@linux.intel.com>
 <4a4b2848-d665-c9ba-c66a-dd4408e94ea5@linux.intel.com>
In-Reply-To: <4a4b2848-d665-c9ba-c66a-dd4408e94ea5@linux.intel.com>
From:   Sergey Ryazanov <ryazanov.s.a@gmail.com>
Date:   Fri, 11 Feb 2022 03:25:31 +0300
Message-ID: <CAHNKnsT9y0ssM3zVriEdEzoRMuJyianKrOx4BAcmT80PCJBigg@mail.gmail.com>
Subject: Re: [PATCH net-next v4 02/13] net: wwan: t7xx: Add control DMA interface
To:     "Martinez, Ricardo" <ricardo.martinez@linux.intel.com>
Cc:     =?UTF-8?Q?Ilpo_J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
        Netdev <netdev@vger.kernel.org>, linux-wireless@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>,
        Johannes Berg <johannes@sipsolutions.net>,
        Loic Poulain <loic.poulain@linaro.org>,
        M Chetan Kumar <m.chetan.kumar@intel.com>,
        chandrashekar.devegowda@intel.com,
        Intel Corporation <linuxwwan@intel.com>,
        chiranjeevi.rapolu@linux.intel.com,
        =?UTF-8?B?SGFpanVuIExpdSAo5YiY5rW35YabKQ==?= 
        <haijun.liu@mediatek.com>, amir.hanania@intel.com,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        dinesh.sharma@intel.com, eliot.lee@intel.com,
        moises.veleta@intel.com, pierre-louis.bossart@intel.com,
        muralidharan.sethuraman@intel.com, Soumya.Prakash.Mishra@intel.com,
        sreehari.kancharla@intel.com
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

Hello Ricardo,

On Wed, Jan 19, 2022 at 1:22 AM Martinez, Ricardo
<ricardo.martinez@linux.intel.com> wrote:
> On 1/18/2022 6:13 AM, Ilpo J=C3=A4rvinen wrote:
>> On Thu, 13 Jan 2022, Ricardo Martinez wrote:
> ...
>>> +#define CLDMA_NUM 2
>> I tried to understand its purpose but it seems that only one of the
>> indexes is used in the arrays where this define gives the size? Related =
to
>> this, ID_CLDMA0 is not used anywhere?
>
> The modem HW has 2 CLDMAs, idx 0 for the app processor (SAP) and idx 1
> for the modem (MD).
>
> CLDMA_NUM is defined as 2 to reflect the HW capabilities but mainly to
> have a cleaner upcoming patches, which will use ID_CLDMA0.
>
> If having array's of size 1 is not a problem then we can define
> CLDMA_NUM as 1 and play with the CLDMA indexes.

Please keep CLDMA_NUM defined as 2. Especially if you have a plan for
further driver development. Saving a few bytes in the structure for a
short term is not worth the jungling with indexes, possible errors and
further rework. Just document them as suggested by Ilpo and mark idx 0
as unused at the moment.

BTW, did you consider to define the cldma_id enum something like this:

/**
 * ...
 * @CLDMA_ID_AP: ... (unused ATM)
 * @CLDMA_ID_MD: ...
 */
enum cldma_id {
    CLDMA_ID_AP =3D 0,
    CLDMA_ID_MD =3D 1,

    CLDMA_NUM
};

This way elements will be self descriptive as well as CLDMA_NUM value
will be less puzzled.

--=20
Sergey
