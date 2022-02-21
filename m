Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1A3E04BDF33
	for <lists+netdev@lfdr.de>; Mon, 21 Feb 2022 18:49:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379830AbiBUQEN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Feb 2022 11:04:13 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:46690 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379823AbiBUQEM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Feb 2022 11:04:12 -0500
Received: from mail-pg1-x535.google.com (mail-pg1-x535.google.com [IPv6:2607:f8b0:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B434D15A34
        for <netdev@vger.kernel.org>; Mon, 21 Feb 2022 08:03:48 -0800 (PST)
Received: by mail-pg1-x535.google.com with SMTP id h125so14652426pgc.3
        for <netdev@vger.kernel.org>; Mon, 21 Feb 2022 08:03:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=KDDcEDbkhzVfk+TQu2VWBarB+wWAgtgnv4l9j8SAhzM=;
        b=T8aD3JVZIuLdwLNZyJjGWUui94FnQKIBVDw041q+vcCQEvLWWSKE8exC0dSOMu2Q/h
         lnb2TLGz/SCRcCVUA4bXGGGshyenePqnVVxnhwjynVMYYfDZ6DD4AVChA6lOgPU49Zk7
         tlAYA5GG6MzAx4drXRF4y9gq9OOvtNyhTgPJ+aTRtz4lXOY7I+fmeEk4/FbiP6r7QKEi
         oxBb2TNfCmZBIwrxjSIl3G/ffti1o1ka82kdwPoQkMZT0ruggi8PwsK/7im0gb3x1f+P
         /t6kVVaTbNpIJbGvQ4jrQwJFxgJNnKpZgAR2aj32vyIlpVBzwvDVZmTu8/CF413C3Qdh
         32kg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=KDDcEDbkhzVfk+TQu2VWBarB+wWAgtgnv4l9j8SAhzM=;
        b=p4KPx/Ql6CCcfQFkazj9NTawKaD0R9pMWeyah9PhKV+KhUA5ukbr6qaKSFwaCxz1Qn
         J2aiS5tptmn0AZ2VOGNIinpoG4xRS/liJO/iVohoDRi9aPuLsq7RUAiZV+nUa4e8DBMj
         LblFC7+hl2IOixGvKHxLV9LYrypQb/dMzaxE8R/m5OOfd1JBldMpXkEPNz1D0mVmgD6V
         fB5mvrk0F0q5q5Ttxac3UJlmhhiXCKhIhpg3c+hlwprxXmTtNnWOwCXpthbpErKYgHEH
         tqp+DsgBA3mAPxGLDiE7Fg02LK7H3KnS8naYA5r93NBy0J+x1bPVzTDKSYqej92roMyj
         tN/w==
X-Gm-Message-State: AOAM530cYRvcXsHizfEzD0hGQFuhL7OgGW5N9UBk8hB3lnXzxBAebkPC
        tOhbyLyV9WRpNX0vuDX/Rd1rKDlIh4Oe9W1lPOuFtA==
X-Google-Smtp-Source: ABdhPJwTeU+cl/tUCmxZ+SlBQzxBPm34/ct8ehbDHEHNf1+KgasY+llurrqRyk+ef4RB9itQLMhlQ3/otRH2B16Db2c=
X-Received: by 2002:a62:8f87:0:b0:4cc:3f6:ca52 with SMTP id
 n129-20020a628f87000000b004cc03f6ca52mr20608357pfd.79.1645459428172; Mon, 21
 Feb 2022 08:03:48 -0800 (PST)
MIME-Version: 1.0
References: <yonglin.tan@outlook.com> <MEYP282MB237454C97E14056454FBBC77FD3A9@MEYP282MB2374.AUSP282.PROD.OUTLOOK.COM>
In-Reply-To: <MEYP282MB237454C97E14056454FBBC77FD3A9@MEYP282MB2374.AUSP282.PROD.OUTLOOK.COM>
From:   Loic Poulain <loic.poulain@linaro.org>
Date:   Mon, 21 Feb 2022 17:03:12 +0100
Message-ID: <CAMZdPi_7KGx69s5tFumkswVXiQSdxXZjDXT5f9njRnBNz1k-VA@mail.gmail.com>
Subject: Re: [PATCH] net: wwan: To support SAHARA port for Qualcomm WWAN module.
To:     Yonglin Tan <yonglin.tan@outlook.com>
Cc:     ryazanov.s.a@gmail.com, johannes@sipsolutions.net,
        davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Yonglin,

On Mon, 21 Feb 2022 at 13:21, Yonglin Tan <yonglin.tan@outlook.com> wrote:
>
> The SAHARA port for Qualcomm WWAN module is used to capture
> memory dump. But now this feature has not been supported by
> linux kernel code. Such that no SAHARA driver matched while
> the device entered to DUMP mode. Once the device crashed due
> to some reasons, device will enter into DUMP mode and running
> in SBL stage. After that, the device change EE to SBL and the
> host will detect the EE change event and re-enumerate SAHARA
> port.
>
> Cc: stable@vger.kernel.org
> Fixes: fa588eba632d ("net: Add Qcom WWAN control driver")
> Signed-off-by: Yonglin Tan <yonglin.tan@outlook.com>
> Reviewed-by: Loic Poulain <loic.poulain@linaro.org>

Sorry, but I've not yet offered that tag :-)

The WWAN framework is a generic way to expose a WWAN device and its
related control/data protocols, such as AT, QMI, MBIM, QCDM, etc...
All the exposed protocols are supported by open-source user
tools/daemons such as ModemManager, ofono, fwupd... SAHARA does not
seem to be WWAN specific and is not something needed for controlling a
modem, right?

I know it would be easier to just add this channel to the WWAN ports,
but we don't want to rawly expose something that could fit into an
existing framework/subsystem, that's why I referred to the devcoredump
framework, which 'seems' a better place for its integration. But I
could be wrong, I don't know much about devcoredump and maybe SAHARA
is doing much more than a firmware coredump...

As a last resort, I think this kind of debug interface should go to debugfs.

Regards,
Loic




> ---
>  drivers/net/wwan/mhi_wwan_ctrl.c | 1 +
>  drivers/net/wwan/wwan_core.c     | 4 ++++
>  include/linux/wwan.h             | 1 +
>  3 files changed, 6 insertions(+)
>
> diff --git a/drivers/net/wwan/mhi_wwan_ctrl.c b/drivers/net/wwan/mhi_wwan_ctrl.c
> index e4d0f69..4cf420e 100644
> --- a/drivers/net/wwan/mhi_wwan_ctrl.c
> +++ b/drivers/net/wwan/mhi_wwan_ctrl.c
> @@ -262,6 +262,7 @@ static const struct mhi_device_id mhi_wwan_ctrl_match_table[] = {
>         { .chan = "QMI", .driver_data = WWAN_PORT_QMI },
>         { .chan = "DIAG", .driver_data = WWAN_PORT_QCDM },
>         { .chan = "FIREHOSE", .driver_data = WWAN_PORT_FIREHOSE },
> +       { .chan = "SAHARA", .driver_data = WWAN_PORT_SAHARA },
>         {},
>  };
>  MODULE_DEVICE_TABLE(mhi, mhi_wwan_ctrl_match_table);
> diff --git a/drivers/net/wwan/wwan_core.c b/drivers/net/wwan/wwan_core.c
> index b8c7843..2630677 100644
> --- a/drivers/net/wwan/wwan_core.c
> +++ b/drivers/net/wwan/wwan_core.c
> @@ -318,6 +318,10 @@ static const struct {
>                 .name = "FIREHOSE",
>                 .devsuf = "firehose",
>         },
> +       [WWAN_PORT_SAHARA] = {
> +               .name = "SAHARA",
> +               .devsuf = "sahara",
> +       },
>  };
>
>  static ssize_t type_show(struct device *dev, struct device_attribute *attr,
> diff --git a/include/linux/wwan.h b/include/linux/wwan.h
> index 5ce2acf..fc8ecaf 100644
> --- a/include/linux/wwan.h
> +++ b/include/linux/wwan.h
> @@ -26,6 +26,7 @@ enum wwan_port_type {
>         WWAN_PORT_QMI,
>         WWAN_PORT_QCDM,
>         WWAN_PORT_FIREHOSE,
> +       WWAN_PORT_SAHARA,
>
>         /* Add new port types above this line */
>
> --
> 2.7.4
>
