Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 14009525AEC
	for <lists+netdev@lfdr.de>; Fri, 13 May 2022 07:07:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377038AbiEMFB0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 May 2022 01:01:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46500 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351159AbiEMFBY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 May 2022 01:01:24 -0400
Received: from mail-pf1-x42a.google.com (mail-pf1-x42a.google.com [IPv6:2607:f8b0:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D12651321
        for <netdev@vger.kernel.org>; Thu, 12 May 2022 22:01:21 -0700 (PDT)
Received: by mail-pf1-x42a.google.com with SMTP id 204so6725723pfx.3
        for <netdev@vger.kernel.org>; Thu, 12 May 2022 22:01:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=ZKGGqj/fBknl+5a6k8JjY3fuXMGdDG3G41qRMwLgESM=;
        b=S84d8VqK6R2yttmhMOcFyrjQLouNjMWKSnxeCHKZT5IoIlD6wwZkX9zINQvbhuBd+L
         XsqYn8nf01grOQjjFfUR82vt3yJqcYCBsasLLqsviBMQ1B+FdO+zSJLBdSQ6sBsmwvM0
         1n13Zymt1SdSj0DMy0hr3Hd8l3neWrh46d2MqAVhcsrigqVCiqZh1T1HBOqhYvNmkBRF
         j8j8HxQRgEOtRUF93Xbgkn/L9oGfe2j56yMWkeMdfYCZJrq2K1IIYd0v+xK4/aEkbwbm
         Hxj0+YfhznfQDj1NeCsOxq7g5f8aURMmGthv1NH9zjygLWfr220q6LSQXh1S2z/vgxOU
         KXFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=ZKGGqj/fBknl+5a6k8JjY3fuXMGdDG3G41qRMwLgESM=;
        b=tzW5ryUoaCnMoS4FQo+ZaHFbyoDrUXFTmYIeWW0QspdfMBLt6/IemyLl5x1sSEbUBH
         SVSFT1NOeTfH90AP4fTH/nZHnQ3BBM3y1qXhL42U/ofXRQ7XBRWeHWV0tHl34oR93EKe
         WlgTy62DYPoceKxLspm0uM19xJNV4tMTEhHHQES759weCsu7mjufYbTy/z+CnkBUMCDU
         R/2zOgTQiHBh2Nf4KEzeS+m4v0L07O5SUQnBVENrA/Jbajnoyg9tExfW2BvuQhBXvAA+
         XtpLQvhdt5c1mCvGvh5gK7Exd0viGO02lYRV4TMbYXGtnZzxinTdp2xO+OKQKjYmYRLg
         J9jA==
X-Gm-Message-State: AOAM5309Meydxxu8B7RgKSzcQT2spU71PRSqumsIb0qo3Dwsu2j3YhQX
        5IX0Lk37xyTJl61mxYLe6/Q=
X-Google-Smtp-Source: ABdhPJyIhCwkqB2yoIq0PBE26QvCWUzo6qDKlMqg5KnIocBeQ1O4gzPXOavu2et+SsZWwRyhobQjpw==
X-Received: by 2002:a65:6954:0:b0:3c6:42cd:bd38 with SMTP id w20-20020a656954000000b003c642cdbd38mr2471551pgq.331.1652418080772;
        Thu, 12 May 2022 22:01:20 -0700 (PDT)
Received: from smtpclient.apple ([223.104.68.116])
        by smtp.gmail.com with ESMTPSA id j21-20020a170902c3d500b0015e8d4eb27dsm766722plj.199.2022.05.12.22.01.17
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 12 May 2022 22:01:20 -0700 (PDT)
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3696.80.82.1.1\))
Subject: Re: [Intel-wired-lan] [PATCH v2 2/2] igb_main: Assign random MAC
 address instead of fail in case of invalid one
From:   lixue liang <lixue.liang5086@gmail.com>
In-Reply-To: <d50b23b1-38b5-2522-cbf4-c360c0ed05cd@molgen.mpg.de>
Date:   Fri, 13 May 2022 13:00:00 +0800
Cc:     Jesse Brandeburg <jesse.brandeburg@intel.com>,
        anthony.l.nguyen@intel.com, kuba@kernel.org,
        intel-wired-lan@lists.osuosl.org, netdev@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <E9E5BF74-D135-471B-8E59-E9740016AD53@gmail.com>
References: <20220512093918.86084-1-lianglixue@greatwall.com.cn>
 <d50b23b1-38b5-2522-cbf4-c360c0ed05cd@molgen.mpg.de>
To:     Paul Menzel <pmenzel@molgen.mpg.de>
X-Mailer: Apple Mail (2.3696.80.82.1.1)
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Dear Paul,

Thank you so much for taking so much time to provide guidance,
I've fixed the other two issues, but the "Reported by" tag issue I =
don=E2=80=99t quite understand.

> 2022=E5=B9=B45=E6=9C=8812=E6=97=A5 21:55=EF=BC=8CPaul Menzel =
<pmenzel@molgen.mpg.de> =E5=86=99=E9=81=93=EF=BC=9A
>=20
> Dear Lixue,
>=20
>=20
> Thank you for sending version 2. Some more minor nits.
>=20
> Am 12.05.22 um 11:39 schrieb lixue liang:
>> In some cases, when the user uses igb_set_eeprom to modify the MAC
>> address to be invalid, the igb driver will fail to load. If there is =
no
>> network card device, the user must modify it to a valid MAC address =
by
>> other means.
>> Since the MAC address can be modified ,then add a random valid MAC =
address
>> to replace the invalid MAC address in the driver can be workable, it =
can
>> continue to finish the loading ,and output the relevant log reminder.
>=20
> Please add the space after the comma.
>=20
>> Reported-by: kernel test robot <lkp@intel.com>
>=20
> This line is confusing. Maybe add that to the version change-log below =
the `---`.

I add it in the form of cmmit message. I understand that you mean to add=20=

"Reported by" under '---=E2=80=98, but I don't know how to add it. =
Please give me=20
further guidance. I'm so sorry to trouble you.Sincerely waiting for your =
response.

Thank you!

PS,
When I use lianglixue@greatwall.com.cn to reply, I get this error:=20
<intel-wired-lan@lists.osuosl.org>: host =
lists.osuosl.org[140.211.166.34] said:
554 5.7.1 <spamfw.greatwall.com.cn[111.48.58.95]>: Client host rejected:
Access denied (in reply to RCPT TO command)

So I temporarily use lixue.liang5086@gmail.com to send, sorry about =
that.=
