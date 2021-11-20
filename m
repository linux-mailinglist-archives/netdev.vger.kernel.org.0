Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 30C1B457D3A
	for <lists+netdev@lfdr.de>; Sat, 20 Nov 2021 12:20:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237191AbhKTLXV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 20 Nov 2021 06:23:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54364 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231252AbhKTLXV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 20 Nov 2021 06:23:21 -0500
Received: from mail-ed1-x530.google.com (mail-ed1-x530.google.com [IPv6:2a00:1450:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F03DCC061574
        for <netdev@vger.kernel.org>; Sat, 20 Nov 2021 03:20:17 -0800 (PST)
Received: by mail-ed1-x530.google.com with SMTP id g14so53957936edb.8
        for <netdev@vger.kernel.org>; Sat, 20 Nov 2021 03:20:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oldum-net.20210112.gappssmtp.com; s=20210112;
        h=message-id:subject:from:to:cc:date:in-reply-to:references
         :user-agent:mime-version;
        bh=zWwej0KBTwSJvlkBzzEbwxRYrkC2zYWSfwtgNI5KcNM=;
        b=lfQwtwyU1ZkE78mY6Zj16UrGC/BoMt1g5MpD908HoL/nek4hvYUpnjL2OJ31CJRuGJ
         4JEfoEno3XwznOhpCRbHbfSeoH1QCHxCbFQWMRfxbV7K61806keOrZ03sFnO6PvsBl5y
         MNt+04O6Px9X3tyLjg7TrlNIigz6KQaeWZFZXfTPzdUR/Ev3v1/6lF1vFIT8628N5H50
         JT+5Tv3k5PQcMGULdxGrDL3lqUxzp3FkfXNOAth9/e0KZbf5OAacXQRiEQi7/nLA43ha
         1L5nplHtxBl4xkhd/s/mYSi3xUa9hj0TgJ/otTZZyLY9ylmDbYY+XoRGnkqIHLw04bzF
         hbnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version;
        bh=zWwej0KBTwSJvlkBzzEbwxRYrkC2zYWSfwtgNI5KcNM=;
        b=bAChrLP9w9aNR6hxRR9LgwbQUX1p/uOzbJlK1BpQfrw6TrYa99V++XjX5xmKgBItk+
         bHAQURn5/+6BG3yvOzOELYmqmashFnzasMR474F71tkF/mgF9YvazybbKVYJfIaKcKTH
         HhcaH7RmddVzi6oBPGy/F5/NhUe4B5zZd+VbPtq/QvySfIGJkaNzM9PF+lanKv0GJ8+S
         oSBPz7fa7AIF5X3NUEUM0T2cFeCV7AZIYvW2PpzHx9prOkPfVm/ehriHCG//h4t3/SSe
         lbMjiihAqC6V1Q5S5TMjWwxW1hycDvtb5DZunxWn1E4WML6m2S0rsSCph7jExUEDt7x6
         k1ZA==
X-Gm-Message-State: AOAM533kDCvH4+jv65Khk9HH0q0WTeXVRnGan/YZflHrHX7CAtnvOvtj
        mRIp/QPNG1bPXdN4WAWfF2t65A==
X-Google-Smtp-Source: ABdhPJxLKjVWRV6VJaQUJfcVh1shMp63txOw93gk5yR31eg4d94pdj2ZizNlC2FgjHe75uk8gS9yQQ==
X-Received: by 2002:a17:907:1c0a:: with SMTP id nc10mr18312537ejc.211.1637407216448;
        Sat, 20 Nov 2021 03:20:16 -0800 (PST)
Received: from [10.1.0.200] (external.oldum.net. [82.161.240.76])
        by smtp.googlemail.com with ESMTPSA id z25sm1039552ejd.80.2021.11.20.03.20.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 20 Nov 2021 03:20:15 -0800 (PST)
Message-ID: <cef6a6c6f8313a609ef104cc64ee6cf9d0ed6adb.camel@oldum.net>
Subject: Re: [PATCH v3 6/7] 9p/trans_virtio: support larger msize values
From:   Nikolay Kichukov <nikolay@oldum.net>
To:     Christian Schoenebeck <linux_oss@crudebyte.com>,
        v9fs-developer@lists.sourceforge.net
Cc:     netdev@vger.kernel.org,
        Dominique Martinet <asmadeus@codewreck.org>,
        Eric Van Hensbergen <ericvh@gmail.com>,
        Latchesar Ionkov <lucho@ionkov.net>,
        Greg Kurz <groug@kaod.org>, Vivek Goyal <vgoyal@redhat.com>
Date:   Sat, 20 Nov 2021 12:20:35 +0100
In-Reply-To: <8119d4d93a39758075bb83730dcb571f5d071af6.1632327421.git.linux_oss@crudebyte.com>
References: <cover.1632327421.git.linux_oss@crudebyte.com>
         <8119d4d93a39758075bb83730dcb571f5d071af6.1632327421.git.linux_oss@crudebyte.com>
Content-Type: multipart/mixed; boundary="=-2/+iitcN5ZmKXaQ8auzP"
User-Agent: Evolution 3.42.1 
MIME-Version: 1.0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--=-2/+iitcN5ZmKXaQ8auzP
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit

Thanks for the patches and sorry for top-posting.

I've tested them on GNU/Gentoo Linux, kernel 5.15.3 on amd64
architecture on both guest and KVM host.

The patches from this series, v3 have been applied to the host kernel
and also to the guest kernel. Guest kernel is clang compiled and host
kernel is compiled with gcc-11.

The host also received the qemu patches:
https://github.com/cschoenebeck/qemu/commit/04a7f9e55e0930b87805f7c97851eea4610e78fc
https://github.com/cschoenebeck/qemu/commit/b565bccb00afe8b73d529bbc3a38682996dac5c7
https://github.com/cschoenebeck/qemu/commit/669ced09b3b6070d478acce51810591b78ab0ccd

Qemu version on the host is 6.0.0-r54.

When the client mounts the share via virtio, requested msize is:
10485760 or 104857600

however the mount succeeds with:
msize=507904 in the end as per the /proc filesystem. This is less than
the previous maximum value.

However, performance-wise, I do see an improvement in throughput,
perhaps related to the qemu patches or some combination.

In addition to the above, when the kernel on the guest boots and loads
9pfs support, the attached memory allocation failure trace is generated.

Is anyone else seeing similar and was anybody able to get msize set to
10MB via virtio protocol with these patches?

Thank you,
-Nikolay

On Wed, 2021-09-22 at 18:00 +0200, Christian Schoenebeck wrote:
> The virtio transport supports by default a 9p 'msize' of up to
> approximately 500 kB. This patch adds support for larger 'msize'
> values by resizing the amount of scatter/gather lists if required.
> 
> Signed-off-by: Christian Schoenebeck <linux_oss@crudebyte.com>
> ---
>  net/9p/trans_virtio.c | 61 +++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 61 insertions(+)
> 
> diff --git a/net/9p/trans_virtio.c b/net/9p/trans_virtio.c
> index e478a34326f1..147ebf647a95 100644
> --- a/net/9p/trans_virtio.c
> +++ b/net/9p/trans_virtio.c
> @@ -203,6 +203,31 @@ static struct virtqueue_sg *vq_sg_alloc(unsigned
> int nsgl)
>         return vq_sg;
>  }
>  
> +/**
> + * vq_sg_resize - resize passed virtqueue scatter/gather lists to the
> passed
> + * amount of lists
> + * @_vq_sg: scatter/gather lists to be resized
> + * @nsgl: new amount of scatter/gather lists
> + */
> +static int vq_sg_resize(struct virtqueue_sg **_vq_sg, unsigned int
> nsgl)
> +{
> +       struct virtqueue_sg *vq_sg;
> +
> +       BUG_ON(!_vq_sg || !nsgl);
> +       vq_sg = *_vq_sg;
> +       if (vq_sg->nsgl == nsgl)
> +               return 0;
> +
> +       /* lazy resize implementation for now */
> +       vq_sg = vq_sg_alloc(nsgl);
> +       if (!vq_sg)
> +               return -ENOMEM;
> +
> +       kfree(*_vq_sg);
> +       *_vq_sg = vq_sg;
> +       return 0;
> +}
> +
>  /**
>   * p9_virtio_close - reclaim resources of a channel
>   * @client: client instance
> @@ -774,6 +799,10 @@ p9_virtio_create(struct p9_client *client, const
> char *devname, char *args)
>         struct virtio_chan *chan;
>         int ret = -ENOENT;
>         int found = 0;
> +#if !defined(CONFIG_ARCH_NO_SG_CHAIN)
> +       size_t npages;
> +       size_t nsgl;
> +#endif
>  
>         if (devname == NULL)
>                 return -EINVAL;
> @@ -796,6 +825,38 @@ p9_virtio_create(struct p9_client *client, const
> char *devname, char *args)
>                 return ret;
>         }
>  
> +       /*
> +        * if user supplied an 'msize' option that's larger than what
> this
> +        * transport supports by default, then try to allocate more sg
> lists
> +        */
> +       if (client->msize > client->trans_maxsize) {
> +#ifdef CONFIG_ARCH_NO_SG_CHAIN
> +               pr_info("limiting 'msize' to %d because architecture
> does not "
> +                       "support chained scatter gather lists\n",
> +                       client->trans_maxsize);
> +#else
> +               npages = DIV_ROUND_UP(client->msize, PAGE_SIZE);
> +               if (npages > chan->p9_max_pages) {
> +                       npages = chan->p9_max_pages;
> +                       pr_info("limiting 'msize' as it would exceed the
> max. "
> +                               "of %lu pages allowed on this system\n",
> +                               chan->p9_max_pages);
> +               }
> +               nsgl = DIV_ROUND_UP(npages, SG_USER_PAGES_PER_LIST);
> +               if (nsgl > chan->vq_sg->nsgl) {
> +                       /*
> +                        * if resize fails, no big deal, then just
> +                        * continue with default msize instead
> +                        */
> +                       if (!vq_sg_resize(&chan->vq_sg, nsgl)) {
> +                               client->trans_maxsize =
> +                                       PAGE_SIZE *
> +                                       ((nsgl * SG_USER_PAGES_PER_LIST)
> - 3);
> +                       }
> +               }
> +#endif /* CONFIG_ARCH_NO_SG_CHAIN */
> +       }
> +
>         client->trans = (void *)chan;
>         client->status = Connected;
>         chan->client = client;


--=-2/+iitcN5ZmKXaQ8auzP
Content-Disposition: attachment; filename="9p-msize.txt"
Content-Transfer-Encoding: base64
Content-Type: text/plain; name="9p-msize.txt"; charset="UTF-8"

WyAgICAxLjUyNzk4MV0gOXA6IEluc3RhbGxpbmcgdjlmcyA5cDIwMDAgZmlsZSBzeXN0ZW0gc3Vw
cG9ydApbICAgIDEuNTI4MTczXSAtLS0tLS0tLS0tLS1bIGN1dCBoZXJlIF0tLS0tLS0tLS0tLS0K
WyAgICAxLjUyODE3NF0gV0FSTklORzogQ1BVOiAxIFBJRDogNzkxIGF0IG1tL3BhZ2VfYWxsb2Mu
Yzo1MzU2IF9fYWxsb2NfcGFnZXMrMHgxZWQvMHgyOTAKWyAgICAxLjUyODE3OV0gTW9kdWxlcyBs
aW5rZWQgaW46IDlwIDlwbmV0X3ZpcnRpbyB2aXJ0aW9fbmV0IG5ldF9mYWlsb3ZlciBmYWlsb3Zl
ciB2aXJ0aW9fY29uc29sZSA5cG5ldCB2aXJ0aW9fYmFsbG9vbiBlZml2YXJmcwpbICAgIDEuNTI4
MTgyXSBDUFU6IDEgUElEOiA3OTEgQ29tbTogbW91bnQgTm90IHRhaW50ZWQgNS4xNS4zLWdlbnRv
by14ODZfNjQgIzEKWyAgICAxLjUyODE4NF0gSGFyZHdhcmUgbmFtZTogUUVNVSBTdGFuZGFyZCBQ
QyAoUTM1ICsgSUNIOSwgMjAwOSksIEJJT1MgMC4wLjAgMDIvMDYvMjAxNQpbICAgIDEuNTI4MTg1
XSBSSVA6IDAwMTA6X19hbGxvY19wYWdlcysweDFlZC8weDI5MApbICAgIDEuNTI4MTg3XSBDb2Rl
OiBlZiA0NCA4OSBmNiBlOCAzNCAxMyAwMCAwMCAzMSBlZCBlOSA1YiBmZiBmZiBmZiA4MSBlMyAz
ZiBmZiBmZiBmZiA4OSBkOSA4OSBjYiA4MyBlMyBmNyBhOSAwMCAwMCAwMCAxMCAwZiA0NCBkOSBl
OSA2NCBmZSBmZiBmZiA8MGY+IDBiIDMxIGVkIGU5IDQyIGZmIGZmIGZmIDQxIDg5IGRmIDY1IDhi
IDA1IDA4IDY1IDlmIDY5IDQxIDgxIGNmClsgICAgMS41MjgxODhdIFJTUDogMDAxODpmZmZmYjY2
NjQwNTAzOWU4IEVGTEFHUzogMDAwMTAyNDYKWyAgICAxLjUyODE4OV0gUkFYOiBjNDkxMjU5MzQ5
ZjNlZjAwIFJCWDogMDAwMDAwMDAwMDA0MGM0MCBSQ1g6IDAwMDAwMDAwMDAwMDAwMDAKWyAgICAx
LjUyODE5MF0gUkRYOiAwMDAwMDAwMDAwMDAwMDAwIFJTSTogMDAwMDAwMDAwMDAwMDAwYyBSREk6
IDAwMDAwMDAwMDAwNDBjNDAKWyAgICAxLjUyODE5MV0gUkJQOiAwMDAwMDAwMDAwMDAwMDBjIFIw
ODogMDAwMDAwMDAwMDAwMDA5MCBSMDk6IGZmZmZmYTNjYzAxMTE2NDAKWyAgICAxLjUyODE5Ml0g
UjEwOiAwMDAwMDAwMDAwMDAwMDAxIFIxMTogMDAwMDAwMDAwMDAwMDAwMCBSMTI6IDAwMDAwMDAw
MDAwMDBjNDAKWyAgICAxLjUyODE5Ml0gUjEzOiBmZmZmOWZjOTQ0NDU5Yzg4IFIxNDogMDAwMDAw
MDAwMDAwMDAwYyBSMTU6IDAwMDAwMDAwMDAwMDBjNDAKWyAgICAxLjUyODE5NF0gRlM6ICAwMDAw
N2ZmNjIwZTU3NzQwKDAwMDApIEdTOmZmZmY5ZmM5YmJjNDAwMDAoMDAwMCkga25sR1M6MDAwMDAw
MDAwMDAwMDAwMApbICAgIDEuNTI4MTk1XSBDUzogIDAwMTAgRFM6IDAwMDAgRVM6IDAwMDAgQ1Iw
OiAwMDAwMDAwMDgwMDUwMDMzClsgICAgMS41MjgxOTZdIENSMjogMDAwMDdmY2ZjMTRlODAwMCBD
UjM6IDAwMDAwMDAwMDMzNTgwMDAgQ1I0OiAwMDAwMDAwMDAwMzUwZWEwClsgICAgMS41MjgxOThd
IENhbGwgVHJhY2U6ClsgICAgMS41MjgyMDFdICA8VEFTSz4KWyAgICAxLjUyODIwMl0gIGttYWxs
b2Nfb3JkZXIrMHgzOS8weGYwClsgICAgMS41MjgyMDRdICBrbWFsbG9jX29yZGVyX3RyYWNlKzB4
MTMvMHg3MApbICAgIDEuNTI4MjA1XSAgX19rbWFsbG9jKzB4MWZjLzB4MmIwClsgICAgMS41Mjgy
MDhdICBwOV9mY2FsbF9pbml0KzB4M2QvMHg2MCBbOXBuZXRdClsgICAgMS41MjgyMTBdICBwOV9j
bGllbnRfcHJlcGFyZV9yZXErMHg4Mi8weDJiMCBbOXBuZXRdClsgICAgMS41MjgyMTJdICBwOV9j
bGllbnRfcnBjKzB4ODAvMHgzNTAgWzlwbmV0XQpbICAgIDEuNTI4MjE0XSAgPyBwOV92aXJ0aW9f
Y3JlYXRlKzB4MjUzLzB4MmIwIFs5cG5ldF92aXJ0aW9dClsgICAgMS41MjgyMTZdICA/IGtmcmVl
KzB4MjYwLzB4MzUwClsgICAgMS41MjgyMTddICBwOV9jbGllbnRfdmVyc2lvbisweDYwLzB4MWQw
IFs5cG5ldF0KWyAgICAxLjUyODIxOV0gIHA5X2NsaWVudF9jcmVhdGUrMHgzYjQvMHg0NjAgWzlw
bmV0XQpbICAgIDEuNTI4MjIxXSAgdjlmc19zZXNzaW9uX2luaXQrMHhhYi8weDc2MCBbOXBdClsg
ICAgMS41MjgyMjJdICA/IHVzZXJfcGF0aF9hdF9lbXB0eSsweDdiLzB4OTAKWyAgICAxLjUyODIy
NF0gID8ga21lbV9jYWNoZV9hbGxvY190cmFjZSsweDE4OC8weDI2MApbICAgIDEuNTI4MjI2XSAg
djlmc19tb3VudCsweDQzLzB4MmQwIFs5cF0KWyAgICAxLjUyODIyN10gIGxlZ2FjeV9nZXRfdHJl
ZS5sbHZtLjYxMjM3Nzk4MzM3NDY2NTYyMCsweDIyLzB4NDAKWyAgICAxLjUyODIzMF0gIHZmc19n
ZXRfdHJlZSsweDIxLzB4YjAKWyAgICAxLjUyODIzMl0gIHBhdGhfbW91bnQrMHg3MGQvMHhjZDAK
WyAgICAxLjUyODIzNF0gIF9feDY0X3N5c19tb3VudCsweDE0OC8weDFjMApbICAgIDEuNTI4MjM2
XSAgZG9fc3lzY2FsbF82NCsweDRhLzB4YjAKWyAgICAxLjUyODIzOF0gIGVudHJ5X1NZU0NBTExf
NjRfYWZ0ZXJfaHdmcmFtZSsweDQ0LzB4YWUKWyAgICAxLjUyODI0MF0gUklQOiAwMDMzOjB4N2Zm
NjIwZjkyZDVhClsgICAgMS41MjgyNDFdIENvZGU6IDQ4IDhiIDBkIDExIGMxIDBiIDAwIGY3IGQ4
IDY0IDg5IDAxIDQ4IDgzIGM4IGZmIGMzIDY2IDJlIDBmIDFmIDg0IDAwIDAwIDAwIDAwIDAwIDBm
IDFmIDQ0IDAwIDAwIDQ5IDg5IGNhIGI4IGE1IDAwIDAwIDAwIDBmIDA1IDw0OD4gM2QgMDEgZjAg
ZmYgZmYgNzMgMDEgYzMgNDggOGIgMGQgZGUgYzAgMGIgMDAgZjcgZDggNjQgODkgMDEgNDgKWyAg
ICAxLjUyODI0Ml0gUlNQOiAwMDJiOjAwMDA3ZmZlNDY3NWY5ZjggRUZMQUdTOiAwMDAwMDI0NiBP
UklHX1JBWDogMDAwMDAwMDAwMDAwMDBhNQpbICAgIDEuNTI4MjQ0XSBSQVg6IGZmZmZmZmZmZmZm
ZmZmZGEgUkJYOiAwMDAwMDAwMDAwMDAwMDAwIFJDWDogMDAwMDdmZjYyMGY5MmQ1YQpbICAgIDEu
NTI4MjQ0XSBSRFg6IDAwMDAwMDAwMDA1NDFmOTAgUlNJOiAwMDAwMDAwMDAwNTQxZjQwIFJESTog
MDAwMDAwMDAwMDU0MWYyMApbICAgIDEuNTI4MjQ1XSBSQlA6IDAwMDAwMDAwMDAwMDBjMDAgUjA4
OiAwMDAwMDAwMDAwNTQyMWYwIFIwOTogMDAwMDdmZmU0Njc1ZTc5MApbICAgIDEuNTI4MjQ2XSBS
MTA6IDAwMDAwMDAwMDAwMDBjMDAgUjExOiAwMDAwMDAwMDAwMDAwMjQ2IFIxMjogMDAwMDAwMDAw
MDUzZDRmMApbICAgIDEuNTI4MjQ2XSBSMTM6IDAwMDAwMDAwMDA1NDFmMjAgUjE0OiAwMDAwMDAw
MDAwNTQxZjkwIFIxNTogMDAwMDdmZjYyMTA5ZGNmNApbICAgIDEuNTI4MjQ3XSAgPC9UQVNLPgpb
ICAgIDEuNTI4MjQ4XSAtLS1bIGVuZCB0cmFjZSA4NGYwNWIyYWEzNWYxOWIzIF0tLS0KClsgICA5
MC44OTQ4NTNdIDlwbmV0OiBMaW1pdGluZyAnbXNpemUnIHRvIDUwNzkwNCBhcyB0aGlzIGlzIHRo
ZSBtYXhpbXVtIHN1cHBvcnRlZCBieSB0cmFuc3BvcnQgdmlydGlvCg==


--=-2/+iitcN5ZmKXaQ8auzP--
