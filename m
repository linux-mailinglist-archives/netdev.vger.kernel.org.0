Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0844E62737B
	for <lists+netdev@lfdr.de>; Mon, 14 Nov 2022 00:33:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234044AbiKMXdD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 13 Nov 2022 18:33:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46030 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230525AbiKMXdC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 13 Nov 2022 18:33:02 -0500
Received: from mailout1.samsung.com (mailout1.samsung.com [203.254.224.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C50BCE2A
        for <netdev@vger.kernel.org>; Sun, 13 Nov 2022 15:32:59 -0800 (PST)
Received: from epcas2p1.samsung.com (unknown [182.195.41.53])
        by mailout1.samsung.com (KnoxPortal) with ESMTP id 20221113233255epoutp01213cdffced0191aa7c7dfa5fcd2cc101~nSO5TRMFa1369313693epoutp01f
        for <netdev@vger.kernel.org>; Sun, 13 Nov 2022 23:32:55 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20221113233255epoutp01213cdffced0191aa7c7dfa5fcd2cc101~nSO5TRMFa1369313693epoutp01f
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1668382375;
        bh=3Ta4r+uWuN2ErpuE49BmaqTT97NRPox6CmorEHALark=;
        h=Subject:Reply-To:From:To:CC:In-Reply-To:Date:References:From;
        b=m3mdLkjQjtsCBAsgDJolq+Jym0Pz/uNvqFbviwzCJ4F6ZF1x5a+2pHHtvmwcZeQe2
         ibPUklIKwyhw7uNdbm2w6VJAGHsHGVseXvkRWm+wjuv/oiiS+lJ56C2wEgd8maSROq
         Sql+Kc9jmN20cRiFDqykI6MycB+Yxij9QoR+V7hA=
Received: from epsnrtp1.localdomain (unknown [182.195.42.162]) by
        epcas2p2.samsung.com (KnoxPortal) with ESMTP id
        20221113233255epcas2p2b57fcbe3134869ff3583b2dd41b1c0e1~nSO5EqL4D1363413634epcas2p2p;
        Sun, 13 Nov 2022 23:32:55 +0000 (GMT)
Received: from epsmges2p1.samsung.com (unknown [182.195.36.100]) by
        epsnrtp1.localdomain (Postfix) with ESMTP id 4N9TJQ51DVz4x9Pp; Sun, 13 Nov
        2022 23:32:54 +0000 (GMT)
X-AuditID: b6c32a45-3f1ff7000001f07d-a3-63717ea64615
Received: from epcas2p2.samsung.com ( [182.195.41.54]) by
        epsmges2p1.samsung.com (Symantec Messaging Gateway) with SMTP id
        23.41.61565.6AE71736; Mon, 14 Nov 2022 08:32:54 +0900 (KST)
Mime-Version: 1.0
Subject: Re: [PATCH net-next v3] nfc: Allow to create multiple virtual nci
 devices
Reply-To: bongsu.jeon@samsung.com
Sender: Bongsu Jeon <bongsu.jeon@samsung.com>
From:   Bongsu Jeon <bongsu.jeon@samsung.com>
To:     Dmitry Vyukov <dvyukov@google.com>,
        Bongsu Jeon <bongsu.jeon@samsung.com>
CC:     "leon@kernel.org" <leon@kernel.org>,
        "krzysztof.kozlowski@linaro.org" <krzysztof.kozlowski@linaro.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "syzkaller@googlegroups.com" <syzkaller@googlegroups.com>
X-Priority: 3
X-Content-Kind-Code: NORMAL
In-Reply-To: <CACT4Y+YQB_HU-fwwUHd=NBX5PM2ADhcfgO7QBwRXD7gZVGg=vA@mail.gmail.com>
X-CPGS-Detection: blocking_info_exchange
X-Drm-Type: N,general
X-Msg-Generator: Mail
X-Msg-Type: PERSONAL
X-Reply-Demand: N
Message-ID: <20221113233254epcms2p4a55e241336fd6f5d8868f00f9a8ed3ec@epcms2p4>
Date:   Mon, 14 Nov 2022 08:32:54 +0900
X-CMS-MailID: 20221113233254epcms2p4a55e241336fd6f5d8868f00f9a8ed3ec
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
CMS-TYPE: 102P
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpmk+LIzCtJLcpLzFFi42LZdljTTHdZXWGywa0pShZbmiexW0x42MZu
        sff1VnaLKb+WMlscWyBmceRNN7MDm8eCTaUeeyaeZPPYtKqTzePOtT1sHn1bVjF6fN4kF8AW
        lW2TkZqYklqkkJqXnJ+SmZduq+QdHO8cb2pmYKhraGlhrqSQl5ibaqvk4hOg65aZA3SEkkJZ
        Yk4pUCggsbhYSd/Opii/tCRVISO/uMRWKbUgJafAvECvODG3uDQvXS8vtcTK0MDAyBSoMCE7
        497L7cwFm80r1t35xd7AOEGzi5GTQ0LARGLVxEVMILaQwA5GianfK7sYOTh4BQQl/u4QBgkL
        C4RI7Pl+lg2iRFHif8c5Noi4rsSLv0fBbDYBbYm1RxvBxogI+EusPLGGtYuRi4NZ4B6jxLqP
        l9ghdvFKzGh/ygJhS0tsX76VEcTmFAiUeHR2OVRcQ+LHsl5mCFtU4ubqt+ww9vtj8xkhbBGJ
        1ntnoWoEJR783A0Vl5L49PAMK4SdL/FyVwcbhF0i8fjMIqh6c4k9b3aBxXkFfCXOvf0N1ssi
        oCrx69AsqF4XiTVTZoLVMAvIS2x/O4cZFCbMApoS63fpg5gSAsoSR26xQFTwSXQc/gv34Y55
        T5ggbFWJ3uYvTDDfTp7dAnWlh8TtZf9ZJzAqzkIE9Cwku2Yh7FrAyLyKUSy1oDg3PbXYqMAQ
        HrXJ+bmbGMGpUct1B+Pktx/0DjEycTAeYpTgYFYS4Z0nk58sxJuSWFmVWpQfX1Sak1p8iNEU
        6MuJzFKiyfnA5JxXEm9oYmlgYmZmaG5kamCuJM7bNUMrWUggPbEkNTs1tSC1CKaPiYNTqoHJ
        +0Ot3b7zzvp1UwMENLrPiqUuKq/0yfcJfWgks7Hxw5vvTxpz3nZFHTaKdlLZI+6xVERYUO/B
        i62Bfp1z+jZ9XC71bsq90BCOx37sc/3PL7i71DTg/dXzQnlNPlVab5xkBG+6fjZ88P1g879p
        emrzvwarmepuF312Jnril8bpv5wePdeTtpn7I9Nhg//KaRl+jF82psp9yFb10vdRLfY8emfx
        Q+tbj5muJGx7ssPR41lS5ZGr8qmvGxlmhUxMsU7V2KR5cJvDEufF+9Ve37J8/T+l0vKa+GKZ
        YmOO06U6vXO3Oi5n4AvRXPQ5M/B+dNtG27WfJmQctIiP3nR3p0buWrvNKckVv5vmHPl40stL
        iaU4I9FQi7moOBEAdGfBaRYEAAA=
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20221104170430epcas2p1d854f31557e623e8fd9d16f6c162d90d
References: <CACT4Y+YQB_HU-fwwUHd=NBX5PM2ADhcfgO7QBwRXD7gZVGg=vA@mail.gmail.com>
        <20221104170422.979558-1-dvyukov@google.com>
        <20221107024604epcms2p174f8813f4e18607b93813021f5b048b0@epcms2p1>
        <CACT4Y+aVXi5hWNMrYavfhmhr3+FVyJoq8KhzrLp1gJFiSCxpxg@mail.gmail.com>
        <20221108004316epcms2p63ff537496ef759cb0c734068bd58855c@epcms2p6>
        <CACT4Y+ZdkFV0--A2i3Q9H9_OnTzgfWVHJUJT13x0O3xNz3kiyQ@mail.gmail.com>
        <20221109003457epcms2p558755edeebc687dba23195ce5b1935c7@epcms2p5>
        <CGME20221104170430epcas2p1d854f31557e623e8fd9d16f6c162d90d@epcms2p4>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 9, 2022 at 9:42 AM Dmitry Vyukov<dvyukov@google.com> wrote:
> On Tue, 8 Nov 2022 at 16:35, Bongsu Jeon <bongsu.jeon@samsung.com> wrote:
> > > > > > On Sat, Nov 5, 2022 at 2:04 AM Dmitry Vyukov<dvyukov@google.com> wrote:
> > > > > > > The current virtual nci driver is great for testing and fuzzing.
> > > > > > > But it allows to create at most one "global" device which does not allow
> > > > > > > to run parallel tests and harms fuzzing isolation and reproducibility.
> > > > > > > Restructure the driver to allow creation of multiple independent devices.
> > > > > > > This should be backwards compatible for existing tests.
> > > > > >
> > > > > > I totally agree with you for parallel tests and good design.
> > > > > > Thanks for good idea.
> > > > > > But please check the abnormal situation.
> > > > > > for example virtual device app is closed(virtual_ncidev_close) first and then
> > > > > > virtual nci driver from nci app tries to call virtual_nci_send or virtual_nci_close.
> > > > > > (there would be problem in virtual_nci_send because of already destroyed mutex)
> > > > > > Before this patch, this driver used virtual_ncidev_mode state and nci_mutex that isn't destroyed.
> > > > >
> > > > > I assumed nci core must stop calling into a driver at some point
> > > > > during the driver destruction. And I assumed that point is return from
> > > > > nci_unregister_device(). Basically when nci_unregister_device()
> > > > > returns, no new calls into the driver must be made. Calling into a
> > > > > driver after nci_unregister_device() looks like a bug in nci core.
> > > > >
> > > > > If this is not true, how do real drivers handle this? They don't use
> > > > > global vars. So they should either have the same use-after-free bugs
> > > > > you described, or they handle shutdown differently. We just need to do
> > > > > the same thing that real drivers do.
> > > > >
> > > > > As far as I see they are doing the same what I did in this patch:
> > > > > https://elixir.bootlin.com/linux/v6.1-rc4/source/drivers/nfc/fdp/i2c.c#L343
> > > > > https://elixir.bootlin.com/linux/v6.1-rc4/source/drivers/nfc/nfcmrvl/usb.c#L354
> > > > >
> > > > > They call nci_unregister_device() and then free all resources:
> > > > > https://elixir.bootlin.com/linux/v6.1-rc4/source/drivers/nfc/nfcmrvl/main.c#L186
> > > > >
> > > > > What am I missing here?
> > > >
> > > > I'm not sure but I think they are little different.
> > > > nfcmrvl uses usb_driver's disconnect callback function and fdp's i2c uses i2c_driver's remove callback function for unregister_device.
> > > > But virtual_ncidev just uses file operation(close function) not related to driver.
> > > > so Nci simulation App can call close function at any time.
> > > > If Scheduler interrupts the nci core code right after calling virtual_nci_send and then
> > > > other process or thread calls virtual_nci_dev's close function,
> > > > we need to handle this problem in virtual nci driver.
> > >
> > > Won't the same issue happen if nci send callback is concurrent with
> > > USB/I2C driver disconnect?
> > >
> > > I mean something internal to the USB subsystem cannot affect what nci
> > > subsystem is doing, unless the USB driver calls into nci and somehow
> > > notifies it that it's about to destroy the driver.
> > >
> > > Is there anything USB/I2C drivers are doing besides calling
> > > nci_unregister_device() to ensure that there are no pending nci send
> > > calls? If yes, then we should do the same in the virtual driver. If
> > > not, then all other drivers are the subject to the same use-after-free
> > > bug.
> > >
> > > But I assumed that nci_unregister_device() ensures that there are no
> > > in-flight send calls and no future send calls will be issued after the
> > > function returns.
> >
> > Ok, I understand your mention. you mean that nci_unregister_device should prevent
> > the issue using dev lock or other way. right?
> 
> Yes.
> 
> > It would be better to handle the issue in nci core if there is.
> 
> And yes.
> 
> Krzysztof, can you confirm this is the case (nci core won't call
> ops->send callback after nci_unregister_device() returns)?

I think we can add this to selftest to verify nci core.

> 
> 
> > > > > > > Signed-off-by: Dmitry Vyukov <dvyukov@google.com>
> > > > > > > Cc: Bongsu Jeon <bongsu.jeon@samsung.com>
> > > > > > > Cc: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
> > > > > > > Cc: netdev@vger.kernel.org
> > > > > > >
> > > > > > > ---
> > > > > > > Changes in v3:
> > > > > > >  - free vdev in virtual_ncidev_close()
> > > > > > >
> > > > > > > Changes in v2:
> > > > > > >  - check return value of skb_clone()
> > > > > > >  - rebase onto currnet net-next
> > > > > > > ---
> > > > > > >  drivers/nfc/virtual_ncidev.c | 147 +++++++++++++++++------------------
> > > > > > >  1 file changed, 71 insertions(+), 76 deletions(-)
> > > > > > >
> > > > > > > diff --git a/drivers/nfc/virtual_ncidev.c b/drivers/nfc/virtual_ncidev.c
> > > > > > > index 85c06dbb2c449..bb76c7c7cc822 100644
> > > > > > > --- a/drivers/nfc/virtual_ncidev.c
> > > > > > > +++ b/drivers/nfc/virtual_ncidev.c
> > > > > > > @@ -13,12 +13,6 @@
> > > > > > >
> > > > > > >  static int virtual_nci_send(struct nci_dev *ndev, struct sk_buff *skb)
> > > > > > >  {
> > > > > > > -     mutex_lock(&nci_mutex);
> > > > > > > -     if (state != virtual_ncidev_enabled) {
> > > > > > > -             mutex_unlock(&nci_mutex);
> > > > > > > +     struct virtual_nci_dev *vdev = nci_get_drvdata(ndev);
> > > > > > > +
> > > > > > > +     mutex_lock(&vdev->mtx);
> > > > > >
> > > > > >   I think this vdev and vdev->mtx are already destroyed so that it would be problem.
> > > > > >
> > > > > > > +     if (vdev->send_buff) {
> > > > > > > +             mutex_unlock(&vdev->mtx);
> > > > > > >               kfree_skb(skb);
> > > > > > > -             return 0;
> > > > > > > +             return -1;
> > > > > > >       }
> > > > > > >
> > > > > > >
> > > > > > >  static int virtual_ncidev_close(struct inode *inode, struct file *file)
> > > > > > >  {
> > > > > > > -     mutex_lock(&nci_mutex);
> > > > > > > -
> > > > > > > -     if (state == virtual_ncidev_enabled) {
> > > > > > > -             state = virtual_ncidev_disabling;
> > > > > > > -             mutex_unlock(&nci_mutex);
> > > > > > > +     struct virtual_nci_dev *vdev = file->private_data;
> > > > > > >
> > > > > > > -             nci_unregister_device(ndev);
> > > > > > > -             nci_free_device(ndev);
> > > > > > > -
> > > > > > > -             mutex_lock(&nci_mutex);
> > > > > > > -     }
> > > > > > > -
> > > > > > > -     state = virtual_ncidev_disabled;
> > > > > > > -     mutex_unlock(&nci_mutex);
> > > > > > > +     nci_unregister_device(vdev->ndev);
> > > > > > > +     nci_free_device(vdev->ndev);
> > > > > > > +     mutex_destroy(&vdev->mtx);
> > > > > > > +     kfree(vdev);
> > > > > > >
> > > > > > >       return 0;
> > > > > > >  }
> > >
