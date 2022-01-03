Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CEB2D48344D
	for <lists+netdev@lfdr.de>; Mon,  3 Jan 2022 16:35:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234088AbiACPfR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Jan 2022 10:35:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55442 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232579AbiACPfQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Jan 2022 10:35:16 -0500
Received: from mail-wr1-x432.google.com (mail-wr1-x432.google.com [IPv6:2a00:1450:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 95092C061761;
        Mon,  3 Jan 2022 07:35:15 -0800 (PST)
Received: by mail-wr1-x432.google.com with SMTP id t26so70585757wrb.4;
        Mon, 03 Jan 2022 07:35:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=fwoh/wxpLCTrTZD3q7z2iU1EBbvcdilR8NQ1crz+Dak=;
        b=FbSoY90AKEGYS7Bgpb3nuWnfa68L5JDl8Dj2rJnG7iw4CiY1Qitu+Z/fzhtAS5OMO/
         hO68KW+RPZ+udHaAw1v4p7uOqE1USPbUzeURv7C2Q4nnLlGYLAt3ZsTbKlrnFPEgxrF9
         UsHnEjhAZoSIxa1a4GMAjKQpzhbXQbfv7Lf0CV6RUuPlr/X4WOUahygScAfGQpf3j38W
         wrd/0ioJJjBCqiZTb+6frG7j5PhE37ugu1MaDCmaApvbRcX1FRD/m7OPv0nlWL3md2WD
         87Ys1771Dq3yQrz/uf0pxEbfUO0po0e6S0JrGdpkclzM4vSmhic/5p697yWi/bPXwPrJ
         8ftA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=fwoh/wxpLCTrTZD3q7z2iU1EBbvcdilR8NQ1crz+Dak=;
        b=KNt6u9P2ZdzuQvqT9O6K0ePVlHhFFg4A8TrUzS07dUZPVvKfdaAr9w9xuP/vyNmSbD
         P2fnmiZpcWvhRPqWr3251hkDTVU+CsoM9WlTXiOzhzdbOg93losZVsChhs6AsdZUDSCD
         H8cxEHdPjLrj02szxOuI26KvQSvhfv8f22Jm1EJVi8/JR79+M1gf21akX6wDJzeC09ih
         QEI6eK6XWpCo9WII+AmLEStsAJrRE73ebPxZax8D5IsC/XIBGnuE+jIoBBtRT/AcDlkM
         JTq+s3xJDm0qNULIa2W7gujW+POcoV5vZsV5R5kXgQ9cIV9Y5I7Fmhiy9abOU0W2pV1y
         H2hw==
X-Gm-Message-State: AOAM533VZ5AezecNQHR0qc3vbVQhmKZShHSi/9HQPFwv+U9D41gAxonF
        FfKXDf+vxQ2yI0dQtKxM8QtAkOyBQnVqQtRoaEo=
X-Google-Smtp-Source: ABdhPJyfYR5Tgej1+JbfKke6k6aFWArD0MekU/04WhRD9OHXM6/dib5ggFdNePgFDDRJu1kABOsT7XoAjKW/ssWe5jM=
X-Received: by 2002:a05:6000:186e:: with SMTP id d14mr40390261wri.205.1641224114204;
 Mon, 03 Jan 2022 07:35:14 -0800 (PST)
MIME-Version: 1.0
References: <CAG_fn=VDEoQx5c7XzWX1yaYBd5y5FrG1aagrkv+SZ03c8TfQYQ@mail.gmail.com>
 <20220102171943.28846-1-paskripkin@gmail.com> <YdL0GPxy4TdGDzOO@kroah.com>
In-Reply-To: <YdL0GPxy4TdGDzOO@kroah.com>
From:   Alexander Aring <alex.aring@gmail.com>
Date:   Mon, 3 Jan 2022 10:35:03 -0500
Message-ID: <CAB_54W7HQmm1ncCEsTmZFR+GVf6p6Vz0RMWDJXAhXQcW4r3hUQ@mail.gmail.com>
Subject: Re: [PATCH RFT] ieee802154: atusb: move to new USB API
To:     Greg KH <greg@kroah.com>
Cc:     Pavel Skripkin <paskripkin@gmail.com>,
        Stefan Schmidt <stefan@datenfreihafen.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-wpan - ML <linux-wpan@vger.kernel.org>,
        "open list:NETWORKING [GENERAL]" <netdev@vger.kernel.org>,
        kernel list <linux-kernel@vger.kernel.org>,
        "# 3.19.x" <stable@vger.kernel.org>,
        Alexander Potapenko <glider@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On Mon, 3 Jan 2022 at 08:03, Greg KH <greg@kroah.com> wrote:
>
> On Sun, Jan 02, 2022 at 08:19:43PM +0300, Pavel Skripkin wrote:
> > Alexander reported a use of uninitialized value in
> > atusb_set_extended_addr(), that is caused by reading 0 bytes via
> > usb_control_msg().
> >
> > Since there is an API, that cannot read less bytes, than was requested,
> > let's move atusb driver to use it. It will fix all potintial bugs with
> > uninit values and make code more modern
> >
> > Fail log:
> >
> > BUG: KASAN: uninit-cmp in ieee802154_is_valid_extended_unicast_addr include/linux/ieee802154.h:310 [inline]
> > BUG: KASAN: uninit-cmp in atusb_set_extended_addr drivers/net/ieee802154/atusb.c:1000 [inline]
> > BUG: KASAN: uninit-cmp in atusb_probe.cold+0x29f/0x14db drivers/net/ieee802154/atusb.c:1056
> > Uninit value used in comparison: 311daa649a2003bd stack handle: 000000009a2003bd
> >  ieee802154_is_valid_extended_unicast_addr include/linux/ieee802154.h:310 [inline]
> >  atusb_set_extended_addr drivers/net/ieee802154/atusb.c:1000 [inline]
> >  atusb_probe.cold+0x29f/0x14db drivers/net/ieee802154/atusb.c:1056
> >  usb_probe_interface+0x314/0x7f0 drivers/usb/core/driver.c:396
> >
> > Fixes: 7490b008d123 ("ieee802154: add support for atusb transceiver")
> > Cc: stable@vger.kernel.org # 5.9
> > Reported-by: Alexander Potapenko <glider@google.com>
> > Signed-off-by: Pavel Skripkin <paskripkin@gmail.com>
> > ---
> >  drivers/net/ieee802154/atusb.c | 61 +++++++++++++++++++++-------------
> >  1 file changed, 38 insertions(+), 23 deletions(-)
> >
> > diff --git a/drivers/net/ieee802154/atusb.c b/drivers/net/ieee802154/atusb.c
> > index 23ee0b14cbfa..43befea0110f 100644
> > --- a/drivers/net/ieee802154/atusb.c
> > +++ b/drivers/net/ieee802154/atusb.c
> > @@ -80,10 +80,9 @@ struct atusb_chip_data {
> >   * in atusb->err and reject all subsequent requests until the error is cleared.
> >   */
> >
> > -static int atusb_control_msg(struct atusb *atusb, unsigned int pipe,
> > -                          __u8 request, __u8 requesttype,
> > -                          __u16 value, __u16 index,
> > -                          void *data, __u16 size, int timeout)
> > +static int atusb_control_msg_recv(struct atusb *atusb, __u8 request, __u8 requesttype,
> > +                               __u16 value, __u16 index,
> > +                               void *data, __u16 size, int timeout)
>
> Why do you need a wrapper function at all?  Why not just call the real
> usb functions instead?
>

This driver has a lot of history, there is a comment which states:

"To reduce the number of error checks in the code, we record the first
error in atusb->err and reject all subsequent requests until the error
is cleared."

I think in the early state of this driver (as it was acting more as an
USB<->SPI bridge) there was a lot of state handling involved. Nowadays
we have a lot of such handling inside the device firmware (which is
btw. open source). This might be not an excuse but an explanation why
it was introduced in such a way.

...
>
> I would recommend just moving to use the real USB functions and no
> wrapper function at all like this, it will make things more obvious and
> easier to understand over time.

okay.

- Alex
