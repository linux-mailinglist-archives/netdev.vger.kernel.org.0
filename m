Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 10B034BEA68
	for <lists+netdev@lfdr.de>; Mon, 21 Feb 2022 20:36:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230216AbiBUSWv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Feb 2022 13:22:51 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:45626 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230200AbiBUSUm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Feb 2022 13:20:42 -0500
Received: from mail-vs1-xe36.google.com (mail-vs1-xe36.google.com [IPv6:2607:f8b0:4864:20::e36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC2A811C0C;
        Mon, 21 Feb 2022 10:12:49 -0800 (PST)
Received: by mail-vs1-xe36.google.com with SMTP id t22so18461339vsa.4;
        Mon, 21 Feb 2022 10:12:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=ifxp+oAlm2yMFNon3VLJzDL+D3DBh2HNHEmG4Ml9zb0=;
        b=Rlr9COL1Llqt7kw3rO7nvsMKahQFjas2hu/wLUz4jU939rpNXGjySCevgwWcfTu+/j
         gZPHu4QRXTPCkmBBAwGeP1X1lcIk7YkiwmCjjwPr89EDPA2NI+XorD1kpcNyuqRKz5eq
         6m07UoguhQW+/TAQmM7xpJIbd4Gvz9+xcsO7uj34HuW/OtABV3iVNeoeLVE4CT2IoVzc
         GecghsENS5WOApHe9nhcNUaEhNkx9gsrsXekGedb1K2eQxUiDpVouuMpUb5BMcru9sBS
         X2gRStEWtcWyrnwG2W0Gu0QiCkkm9vVlT5BJMSZZk6e/AbBUVWDDftEkf947CqYijPus
         Azmg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=ifxp+oAlm2yMFNon3VLJzDL+D3DBh2HNHEmG4Ml9zb0=;
        b=Z7equoiVXH0rC6iO1o2zfgz2sli9SHaUoxmK0vi63Jnid94jys7/ZjfuS2P9gQjcmb
         gIX32zFXJ+GQ6b/emCImr9829fRGzfsmfwens8PK5kWpDv5W2JtAlY/jud3+cNg9c9LY
         PDyfJJwRacze2ZPV3RvlCuTLpPISKzxD9Fc8VI3KznrsuqBDuciIW+EIs5URDjfjBLPV
         lpRTtfo5drTS2XC7WCJztL0s0QsYG+bnv3BeoAE7QQASMd6kT1g33v186glcd9JFK8tR
         /oNLeeDvxgu+ri9uEcNIjc+UMemM/BqCN+v0DtdfTLQkJQn9U1jml+YcCSg7vWU1JnxW
         RPzw==
X-Gm-Message-State: AOAM533BxiAvAzLOICTf8rtxT+d3T7XQkbJdpIOjDTuFULnYI7UfXCcG
        gE1kXsyvKWxe9zx9xbLYa522peGa1U1cQWE/7x4=
X-Google-Smtp-Source: ABdhPJzFoIn78Lp4wnf0kYFF3TXrdo7QcL9/NZ62n/cDuV0zl3L5ZDiqeB+mDhq4xkfM35WmnUHJuj5OJliHPXU6gGM=
X-Received: by 2002:a05:6102:5715:b0:31b:3dc6:10fd with SMTP id
 dg21-20020a056102571500b0031b3dc610fdmr7679285vsb.50.1645467168788; Mon, 21
 Feb 2022 10:12:48 -0800 (PST)
MIME-Version: 1.0
References: <yonglin.tan@outlook.com> <MEYP282MB237454C97E14056454FBBC77FD3A9@MEYP282MB2374.AUSP282.PROD.OUTLOOK.COM>
 <CAMZdPi_7KGx69s5tFumkswVXiQSdxXZjDXT5f9njRnBNz1k-VA@mail.gmail.com> <MEYP282MB2374BDAB34B7AE65C1246A44FD3A9@MEYP282MB2374.AUSP282.PROD.OUTLOOK.COM>
In-Reply-To: <MEYP282MB2374BDAB34B7AE65C1246A44FD3A9@MEYP282MB2374.AUSP282.PROD.OUTLOOK.COM>
From:   Sergey Ryazanov <ryazanov.s.a@gmail.com>
Date:   Mon, 21 Feb 2022 21:12:55 +0300
Message-ID: <CAHNKnsQtENMg2pv+AD1BYm=MA63O3j=1agUXGdgogpZh5c6JCw@mail.gmail.com>
Subject: Re: [PATCH] net: wwan: To support SAHARA port for Qualcomm WWAN module.
To:     =?UTF-8?B?6LCtIOawuOaelw==?= <yonglin.tan@outlook.com>
Cc:     Loic Poulain <loic.poulain@linaro.org>,
        "johannes@sipsolutions.net" <johannes@sipsolutions.net>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
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

Hello Yonglin,

On Mon, Feb 21, 2022 at 7:21 PM =E8=B0=AD =E6=B0=B8=E6=9E=97 <yonglin.tan@o=
utlook.com> wrote:
> SAHARA protocol is used not only to dump the memory but also to enable FW=
 downloading.
> The protocol is designed primarily for transferring software images from =
a host to a target and provides a simple mechanism for requesting data to b=
e transferred over any physical link.
>
> To conclude, the SAHARA port provide a mechanism to transfer messages bet=
ween host and device during SBL.
>
> -----=E9=82=AE=E4=BB=B6=E5=8E=9F=E4=BB=B6-----
> =E5=8F=91=E4=BB=B6=E4=BA=BA: Loic Poulain <loic.poulain@linaro.org>
> =E5=8F=91=E9=80=81=E6=97=B6=E9=97=B4: 2022=E5=B9=B42=E6=9C=8822=E6=97=A5 =
0:03
> =E6=94=B6=E4=BB=B6=E4=BA=BA: Yonglin Tan <yonglin.tan@outlook.com>
> =E6=8A=84=E9=80=81: ryazanov.s.a@gmail.com; johannes@sipsolutions.net; da=
vem@davemloft.net; kuba@kernel.org; netdev@vger.kernel.org; linux-kernel@vg=
er.kernel.org; stable@vger.kernel.org
> =E4=B8=BB=E9=A2=98: Re: [PATCH] net: wwan: To support SAHARA port for Qua=
lcomm WWAN module.
>
> Hi Yonglin,
>
> On Mon, 21 Feb 2022 at 13:21, Yonglin Tan <yonglin.tan@outlook.com> wrote=
:
>>
>> The SAHARA port for Qualcomm WWAN module is used to capture memory
>> dump. But now this feature has not been supported by linux kernel
>> code. Such that no SAHARA driver matched while the device entered to
>> DUMP mode. Once the device crashed due to some reasons, device will
>> enter into DUMP mode and running in SBL stage. After that, the device
>> change EE to SBL and the host will detect the EE change event and
>> re-enumerate SAHARA port.
>>
>> Cc: stable@vger.kernel.org
>> Fixes: fa588eba632d ("net: Add Qcom WWAN control driver")
>> Signed-off-by: Yonglin Tan <yonglin.tan@outlook.com>
>> Reviewed-by: Loic Poulain <loic.poulain@linaro.org>
>
> Sorry, but I've not yet offered that tag :-)
>
> The WWAN framework is a generic way to expose a WWAN device and its relat=
ed control/data protocols, such as AT, QMI, MBIM, QCDM, etc...
> All the exposed protocols are supported by open-source user tools/daemons=
 such as ModemManager, ofono, fwupd... SAHARA does not seem to be WWAN spec=
ific and is not something needed for controlling a modem, right?
>
> I know it would be easier to just add this channel to the WWAN ports, but=
 we don't want to rawly expose something that could fit into an existing fr=
amework/subsystem, that's why I referred to the devcoredump framework, whic=
h 'seems' a better place for its integration. But I could be wrong, I don't=
 know much about devcoredump and maybe SAHARA is doing much more than a fir=
mware coredump...
>
> As a last resort, I think this kind of debug interface should go to debug=
fs.

Here I agree with Loic. An interface that is exported through the WWAN
subsystem should be common enough for WWAN devices. For a firmware
crash dump collection, there are better solutions like devcoredump as
already pointed out by Loic. The firmware update function can be
implemented using the devlink firmware flashing API. You could see the
use of both APIs in the IOSM driver.

If none of these interfaces can be used to utilize the SAHARA
functionality, then, as Loic has already pointed out, such an
interface should probably go to the debugfs. But I suggest to
implement the firmware management functionality using the generic
kernel API. This will save time for end users, distro maintainers and
probably for modem vendor support too.

--=20
Sergey
