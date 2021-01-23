Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 21C3C3016DE
	for <lists+netdev@lfdr.de>; Sat, 23 Jan 2021 17:37:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726208AbhAWQgy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 23 Jan 2021 11:36:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49722 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726111AbhAWQgv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 23 Jan 2021 11:36:51 -0500
Received: from mail-lf1-x132.google.com (mail-lf1-x132.google.com [IPv6:2a00:1450:4864:20::132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 72BC7C061786;
        Sat, 23 Jan 2021 08:36:09 -0800 (PST)
Received: by mail-lf1-x132.google.com with SMTP id v67so11900987lfa.0;
        Sat, 23 Jan 2021 08:36:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=PrviOZAF/Z/WvaXzLoflp5bWDkueLuaEZaeOy5rWH64=;
        b=u8XHL62s5WBuNxLEznm9AeJT7EGgZhMVe72DdWlai5zpRJqQPEM4D+ZepGRYOYysP8
         7PgSHXW2/NFvEqmIMyyXd2PP6JeBta4jWvRif7vDwsurvmaeqyYxW1j8m6h3pvde7L5e
         0X75rIYCKVIdQKEb8UDnqkNMxZLjbuA4dagfhVnz0td1oEms3W8CpU8/hSEDDz2wFELq
         wdHszRhT05T+du1lvzbdRG8OHKI/ZaPRB8vYXn6NMZ7zq57XJibo4dz9Xw4qlCslpfE5
         IxePvAWMX8Z54zHtXsc0Zv46zZULYakHQZ+S82fUM9lThCGxCRbnDXKVZ/vfW9jtXH7u
         YhEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=PrviOZAF/Z/WvaXzLoflp5bWDkueLuaEZaeOy5rWH64=;
        b=dwbqcIbZdG97M0c7WkG8BJf5PllOTdrt2ZT8zMGAvelxE53eynWvLeuzhpY1xa7veI
         qRuGOyECQCT1/SqId/8qMoQnJAA6B01KMsxiPVhBy53i5C5+2B6tqdNoEKL6NDg+jPPU
         bqP++IS3g7uVXK/jlz7MJ7UTk5MgCB/oWFZHCgqBX48icjczBlbyuqchTHrgujNpeWDY
         62AgTSj/5Nkvzjy4FusXoaDKRrNNbxJnRQQraunz8KIIg2r33jJwWN2b9iCnhcOkEMV6
         S30V1HcPl8EoE4zBQtFKG9fnWlHXDN90AxQf3eSenYs6lpk6U2GWswdZxN7jiU2nXRLt
         0byQ==
X-Gm-Message-State: AOAM533bzqguzWiM0drh3chQb5RNzaySjSTQqNKGg3z5IuCvA1jjoYLL
        OTalrWDv7r6UseSz3fv/2hEMzvG6Qggh/nQyZy8=
X-Google-Smtp-Source: ABdhPJzW1DdDlMhGZT4R7RVbO7LVnxmblngLCX9rBXYU/bOweQzYzNtc/jpb3l0EzUL43rVb10yeI8hiEDbdfx1/F6A=
X-Received: by 2002:a19:6a0a:: with SMTP id u10mr94681lfu.308.1611419767973;
 Sat, 23 Jan 2021 08:36:07 -0800 (PST)
MIME-Version: 1.0
References: <20210122062255.202620-1-suyanjun218@gmail.com> <CAMZ6RqL87RpZrH39H9c6wi5wg4=1r104oKf542oAZ2vHRke2WQ@mail.gmail.com>
In-Reply-To: <CAMZ6RqL87RpZrH39H9c6wi5wg4=1r104oKf542oAZ2vHRke2WQ@mail.gmail.com>
From:   knigh dark <suyanjun218@gmail.com>
Date:   Sun, 24 Jan 2021 00:36:06 +0800
Message-ID: <CAMdsLGyWyXzWgzuCEovqVafOUv0_HG1S58ZyMsbiBaOYc5gxhQ@mail.gmail.com>
Subject: Re: [PATCH v1] can: mcp251xfd: Add some sysfs debug interfaces for
 registers r/w
To:     Vincent MAILHOL <mailhol.vincent@wanadoo.fr>
Cc:     Marc Kleine-Budde <mkl@pengutronix.de>,
        Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
        thomas.kopp@microchip.com, Wolfgang Grandegger <wg@grandegger.com>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, lgirdwood@gmail.com,
        broonie@kernel.org, linux-can <linux-can@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Vincent MAILHOL <mailhol.vincent@wanadoo.fr> =E4=BA=8E2021=E5=B9=B41=E6=9C=
=8822=E6=97=A5=E5=91=A8=E4=BA=94 =E4=B8=8B=E5=8D=884:51=E5=86=99=E9=81=93=
=EF=BC=9A
>
> Hi,
>
> In addition to Marc=E2=80=99s comment, I also have security concerns.
>
> On Fri. 22 Jan 2021 at 15:22, Su Yanjun <suyanjun218@gmail.com> wrote:
> > When i debug mcp2518fd, some method to track registers is
> > needed. This easy debug interface will be ok.
> >
> > For example,
> > read a register at 0xe00:
> > echo 0xe00 > can_get_reg
> > cat can_get_reg
> >
> > write a register at 0xe00:
> > echo 0xe00,0x60 > can_set_reg
>
> What about:
> printf "A%0.s" {1..1000} > can_set_reg
>
> Doesn=E2=80=99t it crash the kernel?
I check the input buffer in __get_param with 16 bytes limit.
Thanks for your review.
>
> I see no checks of the buf len in your code and I suspect it to be
> vulnerable to stack buffer overflow exploits.
>
> > Signed-off-by: Su Yanjun <suyanjun218@gmail.com>
> > ---
> >  .../net/can/spi/mcp251xfd/mcp251xfd-core.c    | 132 ++++++++++++++++++
> >  1 file changed, 132 insertions(+)
> >
> > diff --git a/drivers/net/can/spi/mcp251xfd/mcp251xfd-core.c b/drivers/n=
et/can/spi/mcp251xfd/mcp251xfd-core.c
> > index ab8aad0a7594..d65abe5505d5 100644
> > --- a/drivers/net/can/spi/mcp251xfd/mcp251xfd-core.c
> > +++ b/drivers/net/can/spi/mcp251xfd/mcp251xfd-core.c
> > @@ -27,6 +27,131 @@
> >
> >  #define DEVICE_NAME "mcp251xfd"
> >
> > +/* Add sysfs debug interface for easy to debug
> > + *
> > + * For example,
> > + *
> > + * - read a register
> > + * echo 0xe00 > can_get_reg
> > + * cat can_get_reg
> > + *
> > + * - write a register
> > + * echo 0xe00,0x1 > can_set_reg
> > + *
> > + */
> > +static int reg_offset;
> > +
> > +static int __get_param(const char *buf, char *off, char *val)
> > +{
> > +       int len;
> > +
> > +       if (!buf || !off || !val)
> > +               return -EINVAL;
> > +
> > +       len =3D 0;
> > +       while (*buf !=3D ',') {
> > +               *off++ =3D *buf++;
> > +               len++;
> > +
> > +               if (len >=3D 16)
> > +                       return -EINVAL;
> > +       }
> > +
> > +       buf++;
> > +
> > +       *off =3D '\0';
> > +
> > +       len =3D 0;
> > +       while (*buf) {
> > +               *val++ =3D *buf++;
> > +               len++;
> > +
> > +               if (len >=3D 16)
> > +                       return -EINVAL;
> > +       }
> > +
> > +       *val =3D '\0';
> > +
> > +       return 0;
> > +}
> > +
> > +static ssize_t can_get_reg_show(struct device *dev,
> > +                               struct device_attribute *attr, char *bu=
f)
> > +{
> > +       int err;
> > +       u32 val;
> > +       struct mcp251xfd_priv *priv;
> > +
> > +       priv =3D dev_get_drvdata(dev);
> > +
> > +       err =3D regmap_read(priv->map_reg, reg_offset, &val);
> > +       if (err)
> > +               return 0;
> > +
> > +       return sprintf(buf, "reg =3D 0x%08x, val =3D 0x%08x\n", reg_off=
set, val);
> > +}
> > +
> > +static ssize_t can_get_reg_store(struct device *dev,
> > +                                struct device_attribute *attr, const c=
har *buf, size_t len)
> > +{
> > +       u32 off;
> > +
> > +       reg_offset =3D 0;
> > +
> > +       if (kstrtouint(buf, 0, &off) || (off % 4))
> > +               return -EINVAL;
> > +
> > +       reg_offset =3D off;
> > +
> > +       return len;
> > +}
> > +
> > +static ssize_t can_set_reg_show(struct device *dev,
> > +                               struct device_attribute *attr, char *bu=
f)
> > +{
> > +       return 0;
> > +}
> > +
> > +static ssize_t can_set_reg_store(struct device *dev,
> > +                                struct device_attribute *attr, const c=
har *buf, size_t len)
> > +{
> > +       struct mcp251xfd_priv *priv;
> > +       u32 off, val;
> > +       int err;
> > +
> > +       char s1[16];
> > +       char s2[16];
> > +
> > +       if (__get_param(buf, s1, s2))
> > +               return -EINVAL;
> > +
> > +       if (kstrtouint(s1, 0, &off) || (off % 4))
> > +               return -EINVAL;
> > +
> > +       if (kstrtouint(s2, 0, &val))
> > +               return -EINVAL;
> > +
> > +       err =3D regmap_write(priv->map_reg, off, val);
> > +       if (err)
> > +               return -EINVAL;
> > +
> > +       return len;
> > +}
> > +
> > +static DEVICE_ATTR_RW(can_get_reg);
> > +static DEVICE_ATTR_RW(can_set_reg);
> > +
> > +static struct attribute *can_attributes[] =3D {
> > +       &dev_attr_can_get_reg.attr,
> > +       &dev_attr_can_set_reg.attr,
> > +       NULL
> > +};
> > +
> > +static const struct attribute_group can_group =3D {
> > +       .attrs =3D can_attributes,
> > +       NULL
> > +};
> > +
> >  static const struct mcp251xfd_devtype_data mcp251xfd_devtype_data_mcp2=
517fd =3D {
> >         .quirks =3D MCP251XFD_QUIRK_MAB_NO_WARN | MCP251XFD_QUIRK_CRC_R=
EG |
> >                 MCP251XFD_QUIRK_CRC_RX | MCP251XFD_QUIRK_CRC_TX |
> > @@ -2944,6 +3069,12 @@ static int mcp251xfd_probe(struct spi_device *sp=
i)
> >         if (err)
> >                 goto out_free_candev;
> >
> > +       err =3D sysfs_create_group(&spi->dev.kobj, &can_group);
> > +       if (err) {
> > +               netdev_err(priv->ndev, "Create can group fail.\n");
> > +               goto out_free_candev;
> > +       }
> > +
> >         err =3D can_rx_offload_add_manual(ndev, &priv->offload,
> >                                         MCP251XFD_NAPI_WEIGHT);
> >         if (err)
> > @@ -2972,6 +3103,7 @@ static int mcp251xfd_remove(struct spi_device *sp=
i)
> >         mcp251xfd_unregister(priv);
> >         spi->max_speed_hz =3D priv->spi_max_speed_hz_orig;
> >         free_candev(ndev);
> > +       sysfs_remove_group(&spi->dev.kobj, &can_group);
> >
> >         return 0;
> >  }
> > --
> > 2.25.1
> >
