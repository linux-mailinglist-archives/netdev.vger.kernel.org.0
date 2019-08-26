Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 049A19CA05
	for <lists+netdev@lfdr.de>; Mon, 26 Aug 2019 09:21:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729925AbfHZHVx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Aug 2019 03:21:53 -0400
Received: from mail-vk1-f196.google.com ([209.85.221.196]:39856 "EHLO
        mail-vk1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727228AbfHZHVx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Aug 2019 03:21:53 -0400
Received: by mail-vk1-f196.google.com with SMTP id x20so3742269vkd.6
        for <netdev@vger.kernel.org>; Mon, 26 Aug 2019 00:21:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=endlessm-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=Q//x/B+FcM5+mJKULk/MG/UlK4qdLpiW5WdWmOLmU7s=;
        b=FAgv1IhJFDubdW4a8IRMDFF7CJnLICrSzCXNV2KIDokUkWTZPW64toOYjmqCftxUAk
         TKJp6jam2Q1Vfiq7TG4EpHv+eTbbQ2f1CGRJ+DSRzVj6789Ku6ZzK5LWdbwxI46ox0SS
         ZWRlWw2cGfpTZog2t3WNNMjk5+i+6jdEpR8tY4/DzmulesZcwdxgfs9L8iRfBu3D6+z9
         e9fG/Od0+6fJrQQtBvojIbFiP8DBP62UQElQ3LtF8MBQU3SRcwVgWaRk16x1yvUX9SyD
         8f1pKdOaKRAYVhA9lfcgar53ApGcNfN5v2Em8CUnTiYmwMqy6lbssyuInVqWV6VpclJX
         kY2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=Q//x/B+FcM5+mJKULk/MG/UlK4qdLpiW5WdWmOLmU7s=;
        b=ki3mRpOBmqyWN0uwO/SQeZC8DjVBHr5w9HIBp1Qll1o8fcGcmmaHoeGWNEUtQ9GZAs
         eB1zzgFgMVmx/V2gMgIL8eAQ1c+AUYh66D+fMpWnoW6xjlgruPYA8Dv+SwEbN+Qhvwme
         df3VHXD1ZG5rLGQE2zRzSffqdkw7uE1ZyaaZ16eCzYfV7LQ/CCFo44+RPqKGmelomtSm
         viHZxxBGaCcou/FBySEtvcBg21xu0mcOM6GiYsaBcojRGQWfLmzPRRMmi8JI6oeTgz4r
         7LkkkVsjywa3L33TPitBTdc4/bNNDX0/y1xXNgb4sN4IAPIDQjY1jYQn2ik1HbRW0xcC
         A7nA==
X-Gm-Message-State: APjAAAXoapdGhdXKy+6TRj9LRcde+20/2KdPgQWM338QA0ZR7gMkRLlb
        d8TaeyKBeM/piRCE8YAMno8GdQaQljnS2cTwjjnWgA==
X-Google-Smtp-Source: APXvYqznGccIjmJXFqVoPf9Q3Qu8ITqUYkyxxABcNsL+ixapg2DtVic3eVRnXspFOdEfJxm4mPn4tcv1H+dhSfQTLgg=
X-Received: by 2002:ac5:c7b5:: with SMTP id d21mr5608482vkn.56.1566804111572;
 Mon, 26 Aug 2019 00:21:51 -0700 (PDT)
MIME-Version: 1.0
References: <CAPpJ_edU68X-Ki+J61qfws+1-=zv54bcak9tzkMX=CkDS5mOMA@mail.gmail.com>
 <20190820045934.24841-1-jian-hong@endlessm.com> <F7CD281DE3E379468C6D07993EA72F84D18A5786@RTITMBSVM04.realtek.com.tw>
In-Reply-To: <F7CD281DE3E379468C6D07993EA72F84D18A5786@RTITMBSVM04.realtek.com.tw>
From:   Jian-Hong Pan <jian-hong@endlessm.com>
Date:   Mon, 26 Aug 2019 15:21:15 +0800
Message-ID: <CAPpJ_edXoHhR++pn9gwbi==wHQXW4y2Z5-_KajdcpMQp-FqQXw@mail.gmail.com>
Subject: Re: [PATCH v3] rtw88: pci: Move a mass of jobs in hw IRQ to soft IRQ
To:     Tony Chuang <yhchuang@realtek.com>
Cc:     Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux@endlessm.com" <linux@endlessm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Tony Chuang <yhchuang@realtek.com> =E6=96=BC 2019=E5=B9=B48=E6=9C=8821=E6=
=97=A5 =E9=80=B1=E4=B8=89 =E4=B8=8B=E5=8D=884:16=E5=AF=AB=E9=81=93=EF=BC=9A
>
> Hi,
>
> > From: Jian-Hong Pan [mailto:jian-hong@endlessm.com]
> >
> > There is a mass of jobs between spin lock and unlock in the hardware
> > IRQ which will occupy much time originally. To make system work more
> > efficiently, this patch moves the jobs to the soft IRQ (bottom half) to
> > reduce the time in hardware IRQ.
> >
> > Signed-off-by: Jian-Hong Pan <jian-hong@endlessm.com>
> > ---
> > v2:
> >  Change the spin_lock_irqsave/unlock_irqrestore to spin_lock/unlock in
> >  rtw_pci_interrupt_handler. Because the interrupts are already disabled
> >  in the hardware interrupt handler.
> >
> > v3:
> >  Extend the spin lock protecting area for the TX path in
> >  rtw_pci_interrupt_threadfn by Realtek's suggestion
> >
> >  drivers/net/wireless/realtek/rtw88/pci.c | 33 +++++++++++++++++++-----
> >  1 file changed, 27 insertions(+), 6 deletions(-)
> >
> > diff --git a/drivers/net/wireless/realtek/rtw88/pci.c
> > b/drivers/net/wireless/realtek/rtw88/pci.c
> > index 00ef229552d5..a8c17a01f318 100644
> > --- a/drivers/net/wireless/realtek/rtw88/pci.c
> > +++ b/drivers/net/wireless/realtek/rtw88/pci.c
> > @@ -866,12 +866,29 @@ static irqreturn_t rtw_pci_interrupt_handler(int =
irq,
> > void *dev)
> >  {
> >       struct rtw_dev *rtwdev =3D dev;
> >       struct rtw_pci *rtwpci =3D (struct rtw_pci *)rtwdev->priv;
> > -     u32 irq_status[4];
> >
> >       spin_lock(&rtwpci->irq_lock);
> >       if (!rtwpci->irq_enabled)
> >               goto out;
> >
> > +     /* disable RTW PCI interrupt to avoid more interrupts before the =
end of
> > +      * thread function
> > +      */
> > +     rtw_pci_disable_interrupt(rtwdev, rtwpci);
> > +out:
> > +     spin_unlock(&rtwpci->irq_lock);
> > +
> > +     return IRQ_WAKE_THREAD;
> > +}
> > +
> > +static irqreturn_t rtw_pci_interrupt_threadfn(int irq, void *dev)
> > +{
> > +     struct rtw_dev *rtwdev =3D dev;
> > +     struct rtw_pci *rtwpci =3D (struct rtw_pci *)rtwdev->priv;
> > +     unsigned long flags;
> > +     u32 irq_status[4];
> > +
> > +     spin_lock_irqsave(&rtwpci->irq_lock, flags);
> >       rtw_pci_irq_recognized(rtwdev, rtwpci, irq_status);
> >
> >       if (irq_status[0] & IMR_MGNTDOK)
> > @@ -891,8 +908,10 @@ static irqreturn_t rtw_pci_interrupt_handler(int i=
rq,
> > void *dev)
> >       if (irq_status[0] & IMR_ROK)
> >               rtw_pci_rx_isr(rtwdev, rtwpci, RTW_RX_QUEUE_MPDU);
> >
> > -out:
> > -     spin_unlock(&rtwpci->irq_lock);
> > +     /* all of the jobs for this interrupt have been done */
> > +     if (rtw_flag_check(rtwdev, RTW_FLAG_RUNNING))
> > +             rtw_pci_enable_interrupt(rtwdev, rtwpci);
>
> I've applied this patch and tested it.
> But I failed to connect to AP, it seems that the
> scan_result is empty. And when I failed to connect
> to the AP, I found that the IMR is not enabled.
> I guess the check bypass the interrupt enable function.
>
> And I also found that *without MSI*, the driver is
> able to connect to the AP. Could you please verify
> this patch again with MSI interrupt enabled and
> send a v4?
>
> You can find my MSI patch on
> https://patchwork.kernel.org/patch/11081539/

I have just sent v4 patch.  Also tested the modified MSI patch like below:
The WiFi works fine on ASUS X512DK (including MSI enabled).

Jian-Hong Pan

diff --git a/drivers/net/wireless/realtek/rtw88/pci.c
b/drivers/net/wireless/realtek/rtw88/pci.c
index 955dd6c6fb57..d18f5aae1585 100644
--- a/drivers/net/wireless/realtek/rtw88/pci.c
+++ b/drivers/net/wireless/realtek/rtw88/pci.c
@@ -11,6 +11,10 @@
 #include "fw.h"
 #include "debug.h"

+static bool rtw_disable_msi;
+module_param_named(disable_msi, rtw_disable_msi, bool, 0644);
+MODULE_PARM_DESC(disable_msi, "Set Y to disable MSI interrupt support");
+
 static u32 rtw_pci_tx_queue_idx_addr[] =3D {
     [RTW_TX_QUEUE_BK]    =3D RTK_PCI_TXBD_IDX_BKQ,
     [RTW_TX_QUEUE_BE]    =3D RTK_PCI_TXBD_IDX_BEQ,
@@ -1116,6 +1120,48 @@ static struct rtw_hci_ops rtw_pci_ops =3D {
     .write_data_h2c =3D rtw_pci_write_data_h2c,
 };

+static int rtw_pci_request_irq(struct rtw_dev *rtwdev, struct pci_dev *pde=
v)
+{
+    struct rtw_pci *rtwpci =3D (struct rtw_pci *)rtwdev->priv;
+    int ret;
+
+    if (!rtw_disable_msi) {
+        ret =3D pci_enable_msi(pdev);
+        if (ret) {
+            rtw_warn(rtwdev, "failed to enable msi %d, using legacy irq\n"=
,
+                 ret);
+        } else {
+            rtw_warn(rtwdev, "pci msi enabled\n");
+            rtwpci->msi_enabled =3D true;
+        }
+    }
+
+    ret =3D devm_request_threaded_irq(rtwdev->dev, pdev->irq,
+                    rtw_pci_interrupt_handler,
+                    rtw_pci_interrupt_threadfn,
+                    IRQF_SHARED, KBUILD_MODNAME, rtwdev);
+    if (ret) {
+        rtw_err(rtwdev, "failed to request irq %d\n", ret);
+        if (rtwpci->msi_enabled) {
+            pci_disable_msi(pdev);
+            rtwpci->msi_enabled =3D false;
+        }
+    }
+
+    return ret;
+}
+
+static void rtw_pci_free_irq(struct rtw_dev *rtwdev, struct pci_dev *pdev)
+{
+    struct rtw_pci *rtwpci =3D (struct rtw_pci *)rtwdev->priv;
+
+    devm_free_irq(rtwdev->dev, rtwpci->pdev->irq, rtwdev);
+    if (rtwpci->msi_enabled) {
+        pci_disable_msi(pdev);
+        rtwpci->msi_enabled =3D false;
+    }
+}
+
 static int rtw_pci_probe(struct pci_dev *pdev,
              const struct pci_device_id *id)
 {
@@ -1170,10 +1216,7 @@ static int rtw_pci_probe(struct pci_dev *pdev,
         goto err_destroy_pci;
     }

-    ret =3D devm_request_threaded_irq(rtwdev->dev, pdev->irq,
-                    rtw_pci_interrupt_handler,
-                    rtw_pci_interrupt_threadfn,
-                    IRQF_SHARED, KBUILD_MODNAME, rtwdev);
+    ret =3D rtw_pci_request_irq(rtwdev, pdev);
     if (ret) {
         ieee80211_unregister_hw(hw);
         goto err_destroy_pci;
@@ -1212,7 +1255,7 @@ static void rtw_pci_remove(struct pci_dev *pdev)
     rtw_pci_disable_interrupt(rtwdev, rtwpci);
     rtw_pci_destroy(rtwdev, pdev);
     rtw_pci_declaim(rtwdev, pdev);
-    devm_free_irq(rtwdev->dev, rtwpci->pdev->irq, rtwdev);
+    rtw_pci_free_irq(rtwdev, pdev);
     rtw_core_deinit(rtwdev);
     ieee80211_free_hw(hw);
 }
diff --git a/drivers/net/wireless/realtek/rtw88/pci.h
b/drivers/net/wireless/realtek/rtw88/pci.h
index 87824a4caba9..a8e369c5eaca 100644
--- a/drivers/net/wireless/realtek/rtw88/pci.h
+++ b/drivers/net/wireless/realtek/rtw88/pci.h
@@ -186,6 +186,7 @@ struct rtw_pci {
     spinlock_t irq_lock;
     u32 irq_mask[4];
     bool irq_enabled;
+    bool msi_enabled;

     u16 rx_tag;
     struct rtw_pci_tx_ring tx_rings[RTK_MAX_TX_QUEUE_NUM];


> > +     spin_unlock_irqrestore(&rtwpci->irq_lock, flags);
> >
> >       return IRQ_HANDLED;
> >  }
> > @@ -1152,8 +1171,10 @@ static int rtw_pci_probe(struct pci_dev *pdev,
> >               goto err_destroy_pci;
> >       }
> >
> > -     ret =3D request_irq(pdev->irq, &rtw_pci_interrupt_handler,
> > -                       IRQF_SHARED, KBUILD_MODNAME, rtwdev);
> > +     ret =3D devm_request_threaded_irq(rtwdev->dev, pdev->irq,
> > +                                     rtw_pci_interrupt_handler,
> > +                                     rtw_pci_interrupt_threadfn,
> > +                                     IRQF_SHARED, KBUILD_MODNAME, rtwd=
ev);
> >       if (ret) {
> >               ieee80211_unregister_hw(hw);
> >               goto err_destroy_pci;
> > @@ -1192,7 +1213,7 @@ static void rtw_pci_remove(struct pci_dev *pdev)
> >       rtw_pci_disable_interrupt(rtwdev, rtwpci);
> >       rtw_pci_destroy(rtwdev, pdev);
> >       rtw_pci_declaim(rtwdev, pdev);
> > -     free_irq(rtwpci->pdev->irq, rtwdev);
> > +     devm_free_irq(rtwdev->dev, rtwpci->pdev->irq, rtwdev);
> >       rtw_core_deinit(rtwdev);
> >       ieee80211_free_hw(hw);
> >  }
> > --
>
>
> NACK
> Need to verify it with MSI https://patchwork.kernel.org/patch/11081539/
> And hope v4 could fix it.
>
> Yan-Hsuan
>
