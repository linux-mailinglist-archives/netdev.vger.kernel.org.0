Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 763DD3C9E03
	for <lists+netdev@lfdr.de>; Thu, 15 Jul 2021 13:51:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230141AbhGOLyg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Jul 2021 07:54:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44934 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230106AbhGOLyg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Jul 2021 07:54:36 -0400
Received: from mail-oi1-x22a.google.com (mail-oi1-x22a.google.com [IPv6:2607:f8b0:4864:20::22a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2752CC06175F;
        Thu, 15 Jul 2021 04:51:43 -0700 (PDT)
Received: by mail-oi1-x22a.google.com with SMTP id c197so6194334oib.11;
        Thu, 15 Jul 2021 04:51:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=TxXJgw71KmdSk4k4SH+Pctzu46vlSWe9kQ50HddNuBA=;
        b=W+OqtshGeUZfjD2+yimgIobozHeI6SjfyupTahQITqEO7vZfhDcycBxTlqha6L+KM8
         lpt5/kgqVVqTjiAtRwEhZKXLAKBYDJHTrW0gUt1BNALdfkQz3POxhgAZBxT1DULUR3/e
         m2lOf9ntVL+HmePXbxTC7O8p5FT4y+26eI8IBRK9e1YHKpbzrr+5Ky68BTwGtdZfQjBA
         NRdkWKgC7EeJ9hIuGZP5qDFIGDUjyune463m8KtdGY25Snc6DgzSWQbbBiEYxprewc1H
         bEZXSjNfRWlJqk572Mea0hd53mpNoUi5/fsJeJIjpSiQU+jaDZC69EK6+4RbVzcFnh85
         pHhA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=TxXJgw71KmdSk4k4SH+Pctzu46vlSWe9kQ50HddNuBA=;
        b=CjI3GaUg/BOIj4/nvn/tFN3eSENKlyZvPmqqwCLWnYFAfqqz77wVv6/+SLy/X7TpZH
         b1iW4HfkkeWpkbo4+/Qc2QyBLLdFMiMNHRBZRiSiwUPEWiYRg4ohN05JWG4gVPBv2TFm
         vAQOIyer9f7Lpb9dpJzdO7Yg2+AV5Qu/GzVcKZUf+uq1U/SZv5py4k0aiW/duWn86otM
         4wsFPteC3gZvrds49ItdVeRgFu961PBFs3ZRDcLD1AiJgBcU6ogJU5tuiRy9WlN1mbhD
         HVJNGK4p93CrdNe9vCBxM366GpuOItvlmNjkiH2oWUahFWgwOwnTXZdGOcSI4zhyTh2r
         muiQ==
X-Gm-Message-State: AOAM530mTIavhQ6hbZ91WcUF76HyHPv66P0flL1DaWQz+e9uAGOABPP6
        fcGdqX1+pWi+GI13OBzZL/WsDxMtke56XNnGtSGoaMPWWkI=
X-Google-Smtp-Source: ABdhPJx+XxaHOHMvL65rp/B5mM0H7gzKmsf+YNd0VEUT1Z0RCchD7AlI7juYcEKO6SXkYV5swQ1fs+C+p8xAakA2gIk=
X-Received: by 2002:a05:6808:1153:: with SMTP id u19mr7741443oiu.20.1626349902535;
 Thu, 15 Jul 2021 04:51:42 -0700 (PDT)
MIME-Version: 1.0
References: <20210715082536.1882077-1-aisheng.dong@nxp.com>
 <20210715082536.1882077-2-aisheng.dong@nxp.com> <20210715091207.gkd73vh3w67ccm4q@pengutronix.de>
 <CAA+hA=QDJhf_LnBZCiKE-FbUNciX4bmgmrvft8Y-vkB9Lguj=w@mail.gmail.com>
 <DB8PR04MB6795ACFCCB64354C8E810EE8E6129@DB8PR04MB6795.eurprd04.prod.outlook.com>
 <20210715110706.ysktvpzzaqaiimpl@pengutronix.de> <CAA+hA=RBysrM5qXC=gve5n8-Rm7w_Nvsf+qurYJTkWQWPmGobw@mail.gmail.com>
 <DB8PR04MB679513E50585817AF8E2C7E7E6129@DB8PR04MB6795.eurprd04.prod.outlook.com>
In-Reply-To: <DB8PR04MB679513E50585817AF8E2C7E7E6129@DB8PR04MB6795.eurprd04.prod.outlook.com>
From:   Dong Aisheng <dongas86@gmail.com>
Date:   Thu, 15 Jul 2021 19:49:42 +0800
Message-ID: <CAA+hA=R8XsZn3FDkywHpww7=4mvXrYzzXgsoKNF_-1M2McVTwA@mail.gmail.com>
Subject: Re: [PATCH 1/7] dt-bindings: can: flexcan: fix imx8mp compatbile
To:     Joakim Zhang <qiangqing.zhang@nxp.com>
Cc:     Marc Kleine-Budde <mkl@pengutronix.de>,
        Aisheng Dong <aisheng.dong@nxp.com>,
        devicetree <devicetree@vger.kernel.org>,
        "moderated list:ARM/FREESCALE IMX / MXC ARM ARCHITECTURE" 
        <linux-arm-kernel@lists.infradead.org>,
        dl-linux-imx <linux-imx@nxp.com>,
        Sascha Hauer <kernel@pengutronix.de>,
        Rob Herring <robh+dt@kernel.org>,
        Shawn Guo <shawnguo@kernel.org>,
        "linux-can@vger.kernel.org" <linux-can@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 15, 2021 at 7:44 PM Joakim Zhang <qiangqing.zhang@nxp.com> wrot=
e:
>
>
> > -----Original Message-----
> > From: Dong Aisheng <dongas86@gmail.com>
> > Sent: 2021=E5=B9=B47=E6=9C=8815=E6=97=A5 19:36
> > To: Marc Kleine-Budde <mkl@pengutronix.de>
> > Cc: Joakim Zhang <qiangqing.zhang@nxp.com>; Aisheng Dong
> > <aisheng.dong@nxp.com>; devicetree <devicetree@vger.kernel.org>;
> > moderated list:ARM/FREESCALE IMX / MXC ARM ARCHITECTURE
> > <linux-arm-kernel@lists.infradead.org>; dl-linux-imx <linux-imx@nxp.com=
>;
> > Sascha Hauer <kernel@pengutronix.de>; Rob Herring <robh+dt@kernel.org>;
> > Shawn Guo <shawnguo@kernel.org>; linux-can@vger.kernel.org;
> > netdev@vger.kernel.org
> > Subject: Re: [PATCH 1/7] dt-bindings: can: flexcan: fix imx8mp compatbi=
le
> >
> > On Thu, Jul 15, 2021 at 7:07 PM Marc Kleine-Budde <mkl@pengutronix.de>
> > wrote:
> > >
> > > On 15.07.2021 11:00:07, Joakim Zhang wrote:
> > > > > I checked with Joakim that the flexcan on MX8MP is derived from
> > > > > MX6Q with extra ECC added. Maybe we should still keep it from HW =
point
> > of view?
> > > >
> > > > Sorry, Aisheng, I double check the history, and get the below resul=
ts:
> > > >
> > > > 8MP reuses 8QXP(8QM), except ECC_EN
> > > > (ipv_flexcan3_syn_006/D_IP_FlexCAN3_SYN_057 which corresponds to
> > > > version d_ip_flexcan3_syn.03.00.17.01)
> > >
> > > Also see commit message of:
> > >
> > > https://eur01.safelinks.protection.outlook.com/?url=3Dhttps%3A%2F%2Fl=
ore
> > > .kernel.org%2Flinux-can%2F20200929211557.14153-2-qiangqing.zhang%40n
> > xp
> > > .com%2F&amp;data=3D04%7C01%7Cqiangqing.zhang%40nxp.com%7Cf5cd871
> > e13b34e9
> > >
> > 5817b08d9478504af%7C686ea1d3bc2b4c6fa92cd99c5c301635%7C0%7C1%7C
> > 6376194
> > >
> > 58893680146%7CUnknown%7CTWFpbGZsb3d8eyJWIjoiMC4wLjAwMDAiLCJQIj
> > oiV2luMz
> > >
> > IiLCJBTiI6Ik1haWwiLCJXVCI6Mn0%3D%7C3000&amp;sdata=3DYwH3vD%2FtIol5
> > OXPHPM
> > > VbiVCLTC7gowOdIP3Ih1lBHh0%3D&amp;reserved=3D0
> > >
> > > > I prefer to change the dtsi as Mac suggested if possible, shall I
> > > > send a fix patch?
> > >
> > > Make it so!
> >
> > Then should it be "fsl,imx8mp-flexcan", "fsl,imx8qxp-flexcan" rather th=
an only
> > drop "fsl,imx6q-flexcan"?
>
> No, I will only use " fsl,imx8mp-flexcan" to avoid ECC impact.
>

Is ECC issue SW or HW compatibility issue?
If SW, then we should keep the backward compatible string as DT is
describing HW.

Regards
Aisheng

> Best Regards,
> Joakim Zhang
> > Regards
> > Aisheng
> >
> > >
> > > regards,
> > > Marc
> > >
> > > --
> > > Pengutronix e.K.                 | Marc Kleine-Budde           |
> > > Embedded Linux                   |
> > https://eur01.safelinks.protection.outlook.com/?url=3Dhttps%3A%2F%2Fwww=
.p
> > engutronix.de%2F&amp;data=3D04%7C01%7Cqiangqing.zhang%40nxp.com%7Cf
> > 5cd871e13b34e95817b08d9478504af%7C686ea1d3bc2b4c6fa92cd99c5c30163
> > 5%7C0%7C1%7C637619458893680146%7CUnknown%7CTWFpbGZsb3d8eyJWI
> > joiMC4wLjAwMDAiLCJQIjoiV2luMzIiLCJBTiI6Ik1haWwiLCJXVCI6Mn0%3D%7C3
> > 000&amp;sdata=3DsoLd53hGDcxtF42AjJ7u5k9TT%2FsZt6TG%2Bljw4rvtdy4%3D&
> > amp;reserved=3D0  |
> > > Vertretung West/Dortmund         | Phone: +49-231-2826-924     |
> > > Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |
