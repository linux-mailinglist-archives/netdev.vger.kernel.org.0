Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7EFFC650ECD
	for <lists+netdev@lfdr.de>; Mon, 19 Dec 2022 16:41:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231878AbiLSPl4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Dec 2022 10:41:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57858 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232194AbiLSPlw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Dec 2022 10:41:52 -0500
Received: from mail-pl1-x62b.google.com (mail-pl1-x62b.google.com [IPv6:2607:f8b0:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 84BBD11C1C;
        Mon, 19 Dec 2022 07:41:50 -0800 (PST)
Received: by mail-pl1-x62b.google.com with SMTP id t2so9420653ply.2;
        Mon, 19 Dec 2022 07:41:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=fXRMECeSihGqmWG74yCTIQhhKAPitfCCnqxEDYcuAtU=;
        b=DykZmQqoIi775xW8KXCy07Il+mmh1SzG1KJF+R5HV1zpZY22UYqXlx4ssy0Lfeny2n
         rFqM1yt9WAxP/T9BDHnrMjli5aNDPF5cKzCuZPKcZmjUBIoI5kq9euDE7GcDAWeAxcTi
         OPVWjLkr04W6yW6eRPPdrxUuSw1hTqTycuw3CR5Ma9x6Gz9BPfoZ1ttBoqhQTNgRJp6g
         07t3jri31YvWIsmR2W671oPig2WtWltOEIFBWJl93SqnbBgXFn/64LTZyhk87f9ksRY7
         x6sHiRtaWKh6aFe5pmNeEWg3iI7ut05OhabrTHR79NFSwMCSUkrL+pfWHV27/SSNU9EZ
         n1SQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=fXRMECeSihGqmWG74yCTIQhhKAPitfCCnqxEDYcuAtU=;
        b=q22ht4eohrilu6CzTREsb0oG/3MAOt3wdY24vkCsw8pt/gt0ZrIMNWY0vbhLNntmtC
         APAMVKcF4oI5EwuzM87svEP94h9QEblSDc/T2DJCBdnjXSWvg3BG+kGWCcmeOLYi1FVi
         O+E7PGQxJTDBsqfT0KKaSog+3NS1E8C3KRt3mB7h0/JdoSjlHiNBC//lQQCGvIvhmlCg
         Bc0hsHu27Pv8enOeCzSrtcmFfNZi6tGV3OPj/4sJBrSIDwH++MHMzK/aM80dKseJik5K
         WpHCcEZhOoPYogaO8gPdcdvjsTpyrvOU++N2XnKSdIRj4a47EmW6LL6AwuLi0VV7KI/S
         qMng==
X-Gm-Message-State: AFqh2kp2SZnXxscjXSf3O2rbQ+MoP+Cf5mr17AesUWML7nNJORvYxUpU
        zfLr4y4fuLK4odypVkr28Hl6zE64JR3ZStnqZFk=
X-Google-Smtp-Source: AMrXdXuasPUZTuqThKbsVyhqYmShIh1bIOJlRUUha9LZ0njIorDO6zqjyNg5nQoRniQi0VPBsEhNsxMC/hlCFbhGYHI=
X-Received: by 2002:a17:902:9a8c:b0:190:fc28:8cb6 with SMTP id
 w12-20020a1709029a8c00b00190fc288cb6mr715247plp.144.1671464509999; Mon, 19
 Dec 2022 07:41:49 -0800 (PST)
MIME-Version: 1.0
References: <20221213141228.101786-1-a.burakov@rosalinux.ru>
 <5841f9021baf856c26fb27ac1d75fc1e29d3e044.camel@gmail.com> <bd44539b-b3fb-f88d-86f2-fbc3fa83c783@linaro.org>
In-Reply-To: <bd44539b-b3fb-f88d-86f2-fbc3fa83c783@linaro.org>
From:   Alexander Duyck <alexander.duyck@gmail.com>
Date:   Mon, 19 Dec 2022 07:41:38 -0800
Message-ID: <CAKgT0UemyUYpfchg7=ArO1NzkLofUgbSK8F71SRLHZDUxaDc-Q@mail.gmail.com>
Subject: Re: [PATCH] nfc: st-nci: array index overflow in st_nci_se_get_bwi()
To:     Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Cc:     Aleksandr Burakov <a.burakov@rosalinux.ru>,
        Christophe Ricard <christophe.ricard@gmail.com>,
        Samuel Ortiz <sameo@linux.intel.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, lvc-project@linuxtesting.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Dec 19, 2022 at 1:06 AM Krzysztof Kozlowski
<krzysztof.kozlowski@linaro.org> wrote:
>
> On 14/12/2022 19:35, Alexander H Duyck wrote:
> > On Tue, 2022-12-13 at 09:12 -0500, Aleksandr Burakov wrote:
> >> Index of info->se_info.atr can be overflow due to unchecked increment
> >> in the loop "for". The patch checks the value of current array index
> >> and doesn't permit increment in case of the index is equal to
> >> ST_NCI_ESE_MAX_LENGTH - 1.
> >>
> >> Found by Linux Verification Center (linuxtesting.org) with SVACE.
> >>
> >> Fixes: ed06aeefdac3 ("nfc: st-nci: Rename st21nfcb to st-nci")
> >> Signed-off-by: Aleksandr Burakov <a.burakov@rosalinux.ru>
> >> ---
> >>  drivers/nfc/st-nci/se.c | 5 +++--
> >>  1 file changed, 3 insertions(+), 2 deletions(-)
> >>
> >> diff --git a/drivers/nfc/st-nci/se.c b/drivers/nfc/st-nci/se.c
> >> index ec87dd21e054..ff8ac1784880 100644
> >> --- a/drivers/nfc/st-nci/se.c
> >> +++ b/drivers/nfc/st-nci/se.c
> >> @@ -119,10 +119,11 @@ static u8 st_nci_se_get_bwi(struct nci_dev *ndev)
> >>      /* Bits 8 to 5 of the first TB for T=1 encode BWI from zero to nine */
> >>      for (i = 1; i < ST_NCI_ESE_MAX_LENGTH; i++) {
> >>              td = ST_NCI_ATR_GET_Y_FROM_TD(info->se_info.atr[i]);
> >> -            if (ST_NCI_ATR_TA_PRESENT(td))
> >> +            if (ST_NCI_ATR_TA_PRESENT(td) && i < ST_NCI_ESE_MAX_LENGTH - 1)
> >>                      i++;
> >>              if (ST_NCI_ATR_TB_PRESENT(td)) {
> >> -                    i++;
> >> +                    if (i < ST_NCI_ESE_MAX_LENGTH - 1)
> >> +                            i++;
> >>                      return info->se_info.atr[i] >> 4;
> >>              }
> >>      }
> >
> > Rather than adding 2 checks you could do this all with one check.
> > Basically you would just need to replace:
> >   if (ST_NCI_ATR_TB_PRESENT(td)) {
> >       i++;
> >
> > with:
> >   if (ST_NCI_ATR_TB_PRESENT(td) && ++i < ST_NCI_ESE_MAX_LENGTH)
> >
> > Basically it is fine to increment "i" as long as it isn't being used as
> > an index so just restricting the last access so that we don't
> > dereference using it as an index should be enough.
>
> These are different checks - TA and TB. By skipping TA, your code is not
> equivalent. Was it intended?

Sorry, I wasn't talking about combining the TA and TB checks. I was
talking about combining the TB check and the bounds check so that you
didn't return and se_info_atr for a value that may not have actually
aligned due to the fact you had overflowed. Specifically, is skipping
the i++ the correct response to going out of bounds? I'm wondering if
you should be returning the default instead in the case of overflow?

The TA check could be modified so that it checks for "++i =
ST_NCI_ESE_MAX_LENGTH" and if that is true break rather than continue
in the loop.
