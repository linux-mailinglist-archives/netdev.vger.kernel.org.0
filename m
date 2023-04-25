Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8C0956EE382
	for <lists+netdev@lfdr.de>; Tue, 25 Apr 2023 15:56:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234318AbjDYN4z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Apr 2023 09:56:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48180 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233992AbjDYN4u (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Apr 2023 09:56:50 -0400
Received: from mail-oi1-x235.google.com (mail-oi1-x235.google.com [IPv6:2607:f8b0:4864:20::235])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED98813F98
        for <netdev@vger.kernel.org>; Tue, 25 Apr 2023 06:56:46 -0700 (PDT)
Received: by mail-oi1-x235.google.com with SMTP id 5614622812f47-38bed577755so2141717b6e.0
        for <netdev@vger.kernel.org>; Tue, 25 Apr 2023 06:56:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1682431006; x=1685023006;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7P8SMWBA+RBPPYGo/Nxb/0udZK58dNXX+gwvTfNxDxA=;
        b=TdOqC6cMRGC2vzLDfuTn7My6uuegXXZRS4a9becExazuyXDhdGFyThCyv6H4Usv0YZ
         E+yIFNpE6fbOK1ky553BvzspXTqb0pL4WTv9lQbZgiF20YT+1lEc5G8LkFVzYH2fsMpp
         Qdzs39jyAHSqFMF1wCbDcN19jWmJod2SHcBKOlR78/GmqluYYg2H62m1j5VxZIWRbZk2
         OsLWDFgTcA7FGw7pDZJ5WO9w+iY2Ob0KLyIRzMO59l70TwDj4MwPSvy9Vrj2U+fXbC2u
         DNBizgDE/4bX/Zj8PNhvKr3c7VsK6rqYNEnWMYe2MnL462h2LZgPfz/Lwk9QRCPcRins
         XmOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682431006; x=1685023006;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=7P8SMWBA+RBPPYGo/Nxb/0udZK58dNXX+gwvTfNxDxA=;
        b=gqtZavYz6U3V1st1JitcG+2ikAgkF6Npv8tl+Mz0ueYX6aV+RHLwn/fzhqGG/PKcCI
         Fryex53lY2bi9K5DmY612NFOc0zfUI+S49sUV+m26xf+w3ZNHP3WwvVvXfU9VpWaOE2r
         DFsz+AkOCNml/f+5PhbnCBURfgEAz8uFR0iYbBQ8C1CytLHk9re/d2T3ZHF0JAKy3wy0
         cKTOflnkti0/rgsDZn3LacuAMichXcZJzR0WIlcf2RQ81eNxV4DPSiiYAQ44gFDXC9Hq
         FaWOIVutqN2KbyMWTqFOd8JZpPwjpFGf+oAXCgDrNu6QkuHSxnwkQPjXpXFBHG6GweFw
         KDQw==
X-Gm-Message-State: AAQBX9dVf7FGxviiqNbCgEuMDRWm08WN19umjOtVVHlKtglaJDcpNdh5
        EMjh7MBYf3T+RwbLAjP2HsZ3dYlQfbBre9XjVOa76g==
X-Google-Smtp-Source: AKy350ZF4qRTH2OA79A8jprfuZM3L7YMZFpSDSfKYgsWMCqP/j8wuXaJ1ZXdIRHjbp1yxqZM2EjtQu73xgaLWAEmCbI=
X-Received: by 2002:a05:6808:2229:b0:38e:2f8f:e53c with SMTP id
 bd41-20020a056808222900b0038e2f8fe53cmr12771482oib.21.1682431005856; Tue, 25
 Apr 2023 06:56:45 -0700 (PDT)
MIME-Version: 1.0
References: <20230317080942.183514-1-yanchao.yang@mediatek.com>
 <20230317080942.183514-2-yanchao.yang@mediatek.com> <CAMZdPi9_xYO_MQ0BpxcqDci761uu=ZoczGMg81qkEDeOsP6apw@mail.gmail.com>
 <462e25346631c6f195ccc3d85ea58d4d0da66e86.camel@mediatek.com> <bbcd7e5155421d7671c995212d69ca7d8f575375.camel@mediatek.com>
In-Reply-To: <bbcd7e5155421d7671c995212d69ca7d8f575375.camel@mediatek.com>
From:   Loic Poulain <loic.poulain@linaro.org>
Date:   Tue, 25 Apr 2023 15:56:09 +0200
Message-ID: <CAMZdPi-=jbsxYJp1VCoTyPZMH+TYdrVo5aTe3mphVJSsWZ=kLQ@mail.gmail.com>
Subject: Re: [PATCH net-next v4 01/10] net: wwan: tmi: Add PCIe core
To:     =?UTF-8?B?WWFuY2hhbyBZYW5nICjmnajlvabotoUp?= 
        <Yanchao.Yang@mediatek.com>
Cc:     =?UTF-8?B?Q2hyaXMgRmVuZyAo5Yav5L+d5p6XKQ==?= 
        <Chris.Feng@mediatek.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mediatek@lists.infradead.org" 
        <linux-mediatek@lists.infradead.org>,
        =?UTF-8?B?TWluZ2xpYW5nIFh1ICjlvpDmmI7kuq4p?= 
        <mingliang.xu@mediatek.com>,
        =?UTF-8?B?TWluIERvbmcgKOiRo+aVjyk=?= <min.dong@mediatek.com>,
        "linuxwwan@intel.com" <linuxwwan@intel.com>,
        "m.chetan.kumar@intel.com" <m.chetan.kumar@intel.com>,
        =?UTF-8?B?TGlhbmcgTHUgKOWQleS6rik=?= <liang.lu@mediatek.com>,
        =?UTF-8?B?SGFpanVuIExpdSAo5YiY5rW35YabKQ==?= 
        <haijun.liu@mediatek.com>,
        =?UTF-8?B?SGFvemhlIENoYW5nICjluLjmtanlk7Ip?= 
        <Haozhe.Chang@mediatek.com>,
        =?UTF-8?B?SHVhIFlhbmcgKOadqOWNjik=?= <Hua.Yang@mediatek.com>,
        "ryazanov.s.a@gmail.com" <ryazanov.s.a@gmail.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        =?UTF-8?B?QWlkZW4gV2FuZyAo546L5ZKP6bqSKQ==?= 
        <Aiden.Wang@mediatek.com>,
        "edumazet@google.com" <edumazet@google.com>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        =?UTF-8?B?VGluZyBXYW5nICjnjovmjLop?= <ting.wang@mediatek.com>,
        "johannes@sipsolutions.net" <johannes@sipsolutions.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        =?UTF-8?B?R3VvaGFvIFpoYW5nICjlvKDlm73osaop?= 
        <Guohao.Zhang@mediatek.com>,
        =?UTF-8?B?RmVsaXggQ2hlbiAo6ZmI6Z2eKQ==?= <Felix.Chen@mediatek.com>,
        =?UTF-8?B?TGFtYmVydCBXYW5nICjnjovkvJ8p?= 
        <Lambert.Wang@mediatek.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        =?UTF-8?B?TWluZ2NodWFuZyBRaWFvICjkuZTmmI7pl68p?= 
        <Mingchuang.Qiao@mediatek.com>,
        =?UTF-8?B?WGlheXUgWmhhbmcgKOW8oOWkj+Wuhyk=?= 
        <Xiayu.Zhang@mediatek.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,


On Mon, 10 Apr 2023 at 14:16, Yanchao Yang (=E6=9D=A8=E5=BD=A6=E8=B6=85)
<Yanchao.Yang@mediatek.com> wrote:
>
> Hi Loic,
>
> sorry for late response, please check following reply.
>
> On Mon, 2023-03-20 at 21:26 +0800, Yanchao Yang wrote:
> > Hi Loic,
> >
> > On Fri, 2023-03-17 at 13:34 +0100, Loic Poulain wrote:
> > > Hi Yanchao,
> > >
> > > On Fri, 17 Mar 2023 at 09:10, Yanchao Yang <
> > > yanchao.yang@mediatek.com
> > > > wrote:
> > > >
> > > > Registers the TMI device driver with the kernel. Set up all the
> > > > fundamental
> > > > configurations for the device: PCIe layer, Modem Host Cross Core
> > > > Interface
> > > > (MHCCIF), Reset Generation Unit (RGU), modem common control
> > > > operations and
> > > > build infrastructure.
> > > >
> > > > * PCIe layer code implements driver probe and removal, MSI-X
> > > > interrupt
> > > > initialization and de-initialization, and the way of resetting
> > > > the
> > > > device.
> > > > * MHCCIF provides interrupt channels to communicate events such
> > > > as
> > > > handshake,
> > > > PM and port enumeration.
> > > > * RGU provides interrupt channels to generate notifications from
> > > > the device
> > > > so that the TMI driver could get the device reset.
> > > > * Modem common control operations provide the basic read/write
> > > > functions of
> > > > the device's hardware registers, mask/unmask/get/clear functions
> > > > of
> > > > the
> > > > device's interrupt registers and inquiry functions of the
> > > > device's
> > > > status.
> > > >
> > > > Signed-off-by: Yanchao Yang <yanchao.yang@mediatek.com>
> > > > Signed-off-by: Ting Wang <ting.wang@mediatek.com>
> > > > ---
> > > >  drivers/net/wwan/Kconfig                 |  14 +
> > > >  drivers/net/wwan/Makefile                |   1 +
> > > >  drivers/net/wwan/mediatek/Makefile       |   8 +
> > > >  drivers/net/wwan/mediatek/mtk_dev.h      | 203 ++++++
> > > >  drivers/net/wwan/mediatek/pcie/mtk_pci.c | 887
> > > > +++++++++++++++++++++++
> > > >  drivers/net/wwan/mediatek/pcie/mtk_pci.h | 144 ++++
> > > >  drivers/net/wwan/mediatek/pcie/mtk_reg.h |  69 ++
> > > >  7 files changed, 1326 insertions(+)
> > > >  create mode 100644 drivers/net/wwan/mediatek/Makefile
> > > >  create mode 100644 drivers/net/wwan/mediatek/mtk_dev.h
> > > >  create mode 100644 drivers/net/wwan/mediatek/pcie/mtk_pci.c
> > > >  create mode 100644 drivers/net/wwan/mediatek/pcie/mtk_pci.h
> > > >  create mode 100644 drivers/net/wwan/mediatek/pcie/mtk_reg.h
> > > >
> > >
> > > [...]
> > >
> > > > +static int mtk_pci_get_virq_id(struct mtk_md_dev *mdev, int
> > > > irq_id)
> > > > +{
> > > > +       struct pci_dev *pdev =3D to_pci_dev(mdev->dev);
> > > > +       int nr =3D 0;
> > > > +
> > > > +       if (pdev->msix_enabled)
> > > > +               nr =3D irq_id % mdev->msi_nvecs;
> > > > +
> > > > +       return pci_irq_vector(pdev, nr);
> > > > +}
> > > > +
> > > > +static int mtk_pci_register_irq(struct mtk_md_dev *mdev, int
> > > > irq_id,
> > > > +                               int (*irq_cb)(int irq_id, void
> > > > *data), void *data)
> > > > +{
> > > > +       struct mtk_pci_priv *priv =3D mdev->hw_priv;
> > > > +
> > > > +       if (unlikely((irq_id < 0 || irq_id >=3D MTK_IRQ_CNT_MAX) ||
> > > > !irq_cb))
> > > > +               return -EINVAL;
> > > > +
> > > > +       if (priv->irq_cb_list[irq_id]) {
> > > > +               dev_err(mdev->dev,
> > > > +                       "Unable to register irq, irq_id=3D%d, it's
> > > > already been register by %ps.\n",
> > > > +                       irq_id, priv->irq_cb_list[irq_id]);
> > > > +               return -EFAULT;
> > > > +       }
> > > > +       priv->irq_cb_list[irq_id] =3D irq_cb;
> > > > +       priv->irq_cb_data[irq_id] =3D data;
> > >
> > > So it looks like you re-implement your own irq chip internally.
> > > What
> > > about creating a new irq-chip/domain for this (cf
> > > irq_domain_add_simple)?
> > > That would allow the client code to use the regular irq interface
> > > and
> > > helpers
> > > and it should simply code and improve its debuggability
> > > (/proc/irq...).
> >
> > We will check it and update you later.
> No, we don=E2=80=99t re-implement irq chip. After studying the irq_domain
> interface you suggest, the TMI driver leverages on MSI irq domain. We
> use pci_alloc_irq_vectors to allocate MSI-X irq desc and use
> pci_request_irq to bind interrupt sources with irq handlers.

What I mean is that you're implementing some interrupt muxing into
your driver, which could possibly be abstracted with a 'virtual' irq
domain and generic ops (e.g with proper irq domain your
mtk_pci_register_irq method could be replaced with the usual
request_irq), Think about it as future improvement, I assume we can go
with the current solution for now.

> > >
> > > [...]
> > >
> > > > +static int mtk_mhccif_register_evt(struct mtk_md_dev *mdev, u32
> > > > chs,
> > > > +                                  int (*evt_cb)(u32 status, void
> > > > *data), void *data)
> > > > +{
> > > > +       struct mtk_pci_priv *priv =3D mdev->hw_priv;
> > > > +       struct mtk_mhccif_cb *cb;
> > > > +       unsigned long flag;
> > > > +       int ret =3D 0;
> > > > +
> > > > +       if (!chs || !evt_cb)
> > > > +               return -EINVAL;
> > > > +
> > > > +       spin_lock_irqsave(&priv->mhccif_lock, flag);
> > >
> > > Why spinlock here and not mutex. AFAIU, you always take this lock
> > > in
> > > a
> > > non-atomic/process context.
> >
> > Currently, the function is only called in the FSM initialization and
> > PM(power management) initialization process. Both are atomic.
> > On the other hand, this registration function will operate the global
> > variables =E2=80=9Cmhccif_cb_list=E2=80=9D, but it takes very little ti=
me. So, we
> > think
> > spinlock is preferred.
> Any ideas or comments for this? Please help share it at your
> convenience.

They do not seem atomic... moreover you're using the _irqsave variant
while you're never accessing the list from (hard|soft)irq context.

> >
> > >
> > > > +       list_for_each_entry(cb, &priv->mhccif_cb_list, entry) {
> > > > +               if (cb->chs & chs) {
> > > > +                       ret =3D -EFAULT;
> > > > +                       dev_err(mdev->dev,
> > > > +                               "Unable to register evt,
> > > > chs=3D0x%08X&0x%08X registered_cb=3D%ps\n",
> > > > +                               chs, cb->chs, cb->evt_cb);
> > > > +                       goto err;
> > > > +               }
> > > > +       }
> > > > +       cb =3D devm_kzalloc(mdev->dev, sizeof(*cb), GFP_ATOMIC);

Maybe alloc this outside the lock, so that you can use the 'regular'
GFP_KERNEL alloc.

> > > > +       if (!cb) {
> > > > +               ret =3D -ENOMEM;
> > > > +               goto err;
> > > > +       }
> > > > +       cb->evt_cb =3D evt_cb;
> > > > +       cb->data =3D data;
> > > > +       cb->chs =3D chs;
> > > > +       list_add_tail(&cb->entry, &priv->mhccif_cb_list);
> > > > +
> > > > +err:
> > > > +       spin_unlock_irqrestore(&priv->mhccif_lock, flag);
> > > > +
> > > > +       return ret;
> > > > +}
> > >
> > > [...]
> > >
> > > > +
> > > > +MODULE_LICENSE("GPL");
> > > > diff --git a/drivers/net/wwan/mediatek/pcie/mtk_pci.h
> > > > b/drivers/net/wwan/mediatek/pcie/mtk_pci.h
> > > > new file mode 100644
> > > > index 000000000000..b487ca9b302e
> > > > --- /dev/null
> > > > +++ b/drivers/net/wwan/mediatek/pcie/mtk_pci.h
> > >
> > > Why a separated header file, isn't the content (e.g. mtk_pci_priv)
> > > used only from mtk_pci.c?
> >
> > Do you mean that we should move all contents of =E2=80=9Cmtk_pci.h=E2=
=80=9D into
> > =E2=80=9Cmtk_pci.c=E2=80=9D directly? The =E2=80=9Cmtk_pci.h=E2=80=9D s=
eems to be redundant, right?
> Any ideas or comments for this? Please help share it at your
> convenience.

Yes, keep that in the  .c file.

Regards,
Loic
