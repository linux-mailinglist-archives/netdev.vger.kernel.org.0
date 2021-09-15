Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DF5C340CCAF
	for <lists+netdev@lfdr.de>; Wed, 15 Sep 2021 20:40:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230362AbhIOSl0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Sep 2021 14:41:26 -0400
Received: from mail-4319.protonmail.ch ([185.70.43.19]:64655 "EHLO
        mail-4319.protonmail.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229466AbhIOSlZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Sep 2021 14:41:25 -0400
Date:   Wed, 15 Sep 2021 18:40:02 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=protonmail.com;
        s=protonmail; t=1631731204;
        bh=U70ux2LVAeOwD9Lo011Vrynw3kWVFWitmfH28s9YPhY=;
        h=Date:To:From:Cc:Reply-To:Subject:In-Reply-To:References:From;
        b=p7IlhyN8p6hm/kZf81Yn2d43wy1yVAVT0VFADMRsUykB2AbPwewppjcwDxXENKFLJ
         0IuPZ7gwcTZhrv+NHQlHTaN4cFxpYrWSSClMi7JCNlotgeIdW7NuBZ7v89ZD53uXr0
         83ggwFA8maAo+BniLf+F2qRkjVAZtSUgnm79vbaU=
To:     Steev Klimaszewski <steev@kali.org>
From:   Yassine Oudjana <y.oudjana@protonmail.com>
Cc:     Dan Carpenter <dan.carpenter@oracle.com>,
        bjorn.andersson@linaro.org, butterflyhuangxx@gmail.com,
        davem@davemloft.net, kuba@kernel.org,
        linux-arm-msm@vger.kernel.org, loic.poulain@linaro.org,
        mani@kernel.org, netdev@vger.kernel.org
Reply-To: Yassine Oudjana <y.oudjana@protonmail.com>
Subject: Re: [PATCH v2 net] net: qrtr: make checks in qrtr_endpoint_post() stricter
Message-ID: <QvTONvzS6__GE_w1qYluX-y9sMtfeFFyTeDROhqnm8j6phRilXBJihf4Tp8COJkG54g-Hi64c2j5WLvJ-4rXeEiwkAgJ3jI0_H4ISzoJZ8E=@protonmail.com>
In-Reply-To: <95ee6b7d-a51d-71bb-1245-501740357839@kali.org>
References: <S4IVYQ.R543O8OZ1IFR3@protonmail.com> <20210906065320.GC1935@kadam> <95ee6b7d-a51d-71bb-1245-501740357839@kali.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-1.2 required=10.0 tests=ALL_TRUSTED,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM shortcircuit=no
        autolearn=disabled version=3.4.4
X-Spam-Checker-Version: SpamAssassin 3.4.4 (2020-01-24) on
        mailout.protonmail.ch
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wednesday, September 15th, 2021 at 9:30 PM, Steev Klimaszewski <steev@ka=
li.org> wrote:

> On 9/6/21 1:53 AM, Dan Carpenter wrote:
>
> > On Fri, Sep 03, 2021 at 07:29:28PM +0000, Yassine Oudjana wrote:
> >
> > > > if (cb->dst_port !=3D QRTR_PORT_CTRL && cb->type !=3D QRTR_TYPE_DAT=
A &&
> > > >
> > > > @@ -506,8 +506,12 @@ int qrtr_endpoint_post(struct qrtr_endpoint
> > > >
> > > > *ep, const void *data, size_t len)
> > > >
> > > > if (cb->type =3D=3D QRTR_TYPE_NEW_SERVER) {
> > > >
> > > > /* Remote node endpoint can bridge other distant nodes */
> > > >
> > > > -   const struct qrtr_ctrl_pkt *pkt =3D data + hdrlen;
> > > >
> > > > -   const struct qrtr_ctrl_pkt *pkt;
> > > >
> > > > -   if (size < sizeof(*pkt))
> > > >
> > > > -   goto err;
> > > >
> > > >
> > > > -   pkt =3D data + hdrlen;
> > > >
> > > >     qrtr_node_assign(node, le32_to_cpu(pkt->server.node));
> > > >
> > > >     }
> > > >
> > > >
> > > > --
> > > >
> > > > 2.20.1
> > >
> > > This is crashing MSM8996. I get these messages (dmesg | grep
> > >
> > > remoteproc):
> > >
> > > Yes. I apologize for that. The fix has been merged already.
> >
> > regards,
> >
> > dan carpenter
>
> Where has the fix been merged to?=C2=A0 5.14.4 released with this patch i=
n
>
> it, and wifi is now crashing on the Lenovo Yoga C630 with the same
>
> messages that Yassine was seeing.

The fix is in master[1]. You need to cherry-pick it.

[1] https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/comm=
it/?id=3Dd2cabd2dc8da78faf9b690ea521d03776686c9fe
