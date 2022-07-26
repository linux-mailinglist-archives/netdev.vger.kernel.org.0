Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 121995816FC
	for <lists+netdev@lfdr.de>; Tue, 26 Jul 2022 18:08:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229787AbiGZQIH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Jul 2022 12:08:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229500AbiGZQIG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Jul 2022 12:08:06 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E0D46B1CD
        for <netdev@vger.kernel.org>; Tue, 26 Jul 2022 09:08:03 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 70F9160D32
        for <netdev@vger.kernel.org>; Tue, 26 Jul 2022 16:08:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AADC9C433D6;
        Tue, 26 Jul 2022 16:08:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1658851682;
        bh=IPogWuV5+L8Kk79eqKdql19pJV98THNw10wlC41/ic4=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=gEDOZqph0HdfIwFVJ6Yyyc0OOF7YKzuCWcUGotlZy8zU0WNrkZmxXpy+4/EUTL0ZR
         NLsEe0xLp0i2v3RoCHw1SWiR1TUV6w/yrSgZiY0Bvb0BYsSgjZP8etRaKFlUxo0JTT
         Y0UD7cdOPIE/zorG79pEjCpdqaQ80jUj3CkUiy+//hYna6r/UL7A+atUXj+eQdDy4l
         79qcX/2tJuYojDozBSqtlXeKBNddwWW2iOKDJzLjyaGd3tLdY3pDXw4uXKEeX6uZc1
         uHZz1lr7Fy3SDvtowd2mu4x53AvsBZSzqKRRB5i5uHH1a4DF1k/xlFSqTjEI7JdhM1
         TmcIaIk2qqnSQ==
Date:   Tue, 26 Jul 2022 09:08:01 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Paolo Abeni <pabeni@redhat.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, edumazet@google.com
Subject: Re: [PATCH net-next] add missing includes and forward declarations
 to networking includes under linux/
Message-ID: <20220726090801.1d4a6137@kernel.org>
In-Reply-To: <843286034774bec118d98e9b4531093faef036f9.camel@redhat.com>
References: <20220723045755.2676857-1-kuba@kernel.org>
        <843286034774bec118d98e9b4531093faef036f9.camel@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 26 Jul 2022 12:00:47 +0200 Paolo Abeni wrote:
> On Fri, 2022-07-22 at 21:57 -0700, Jakub Kicinski wrote:
> > Similarly to a recent include/net/ cleanup, this patch adds
> > missing includes to networking headers under include/linux.
> > All these problems are currently masked by the existing users
> > including the missing dependency before the broken header.

Thanks for the detailed review!

> > --- a/include/linux/if_tap.h
> > +++ b/include/linux/if_tap.h
> > @@ -2,6 +2,8 @@
> >  #ifndef _LINUX_IF_TAP_H_
> >  #define _LINUX_IF_TAP_H_
> > =20
> > +struct file; =20
>=20
> I guess even:
>=20
> struct socket;
> struct ptr_ring;
>=20
> are needed, and you can remove the forward declaration from the #else
> branch.

Let me move the includes which are later on int the file, for some
reason, up.

> >  #if IS_ENABLED(CONFIG_TAP)
> >  struct socket *tap_get_socket(struct file *);
> >  struct ptr_ring *tap_get_ptr_ring(struct file *file);
> > diff --git a/include/linux/mdio/mdio-xgene.h b/include/linux/mdio/mdio-=
xgene.h
> > index 8af93ada8b64..9e588965dc83 100644
> > --- a/include/linux/mdio/mdio-xgene.h
> > +++ b/include/linux/mdio/mdio-xgene.h
> > @@ -8,6 +8,10 @@
> >  #ifndef __MDIO_XGENE_H__
> >  #define __MDIO_XGENE_H__
> > =20
> > +#include <linux/bits.h>
> > +#include <linux/spinlock.h>
> > +#include <linux/types.h>
> > + =20
>=20
> possibly even:
>=20
> struct clk;
> struct device;
> struct mii_bus;
>=20
> used below.

I don't understand why but apparently using a struct type in another
struct is considered a forward declaration.

09:05 ~$ cat /tmp/one.c=20
int some_func(struct bla *b);

int main()
{
	return 0;
}
09:05 ~$ gcc -W -Wall -Wextra -O2 /tmp/one.c  -o /dev/null
/tmp/one.c:1:22: warning: =E2=80=98struct bla=E2=80=99 declared inside para=
meter list will not be visible outside of this definition or declaration
    1 | int some_func(struct bla *b);
      |                      ^~~
09:05 ~$ cat /tmp/two.c=20
struct other {
	struct bla *b;
};

int some_func(struct bla *b);

int main()
{
	return 0;
}
09:05 ~$ gcc -W -Wall -Wextra -O2 /tmp/two.c  -o /dev/null
09:05 ~$=20

> > +++ b/include/linux/sungem_phy.h
> > @@ -2,6 +2,8 @@
> >  #ifndef __SUNGEM_PHY_H__
> >  #define __SUNGEM_PHY_H__
> > =20
> > +#include <linux/types.h>
> > +
> >  struct mii_phy; =20
>=20
> Possibly even:
>=20
> struct net_device;

Same story.

> >  /* Operations supported by any kind of PHY */
> > diff --git a/include/linux/usb/usbnet.h b/include/linux/usb/usbnet.h
> > index 1b4d72d5e891..b42b72391a8d 100644
> > --- a/include/linux/usb/usbnet.h
> > +++ b/include/linux/usb/usbnet.h
> > @@ -23,6 +23,12 @@
> >  #ifndef	__LINUX_USB_USBNET_H
> >  #define	__LINUX_USB_USBNET_H
> > =20
> > +#include <linux/mii.h>
> > +#include <linux/netdevice.h>
> > +#include <linux/skbuff.h>
> > +#include <linux/types.h> =20
>=20
> 'linux/types.h' should not be needed: already included via skbuff.h ->
> atomic.h -> types.h

Yea... sometimes I added it sometimes I didn't.. :)  I don't think=20
the explicit include hurts.

> > +#include <linux/usb.h>
> > +
> >  /* interface from usbnet core to each USB networking link we handle */

