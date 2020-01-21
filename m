Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E439914488B
	for <lists+netdev@lfdr.de>; Wed, 22 Jan 2020 00:49:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726970AbgAUXs5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Jan 2020 18:48:57 -0500
Received: from mail-ua1-f67.google.com ([209.85.222.67]:35886 "EHLO
        mail-ua1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725876AbgAUXs5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Jan 2020 18:48:57 -0500
Received: by mail-ua1-f67.google.com with SMTP id y3so1752176uae.3
        for <netdev@vger.kernel.org>; Tue, 21 Jan 2020 15:48:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=Ss/iHhXfH0bkdkXpRw1s82EALDsyOHTjJKIfLzwEJx4=;
        b=CaCm1RwyWIZTnuMUJUyGox8hjZ12svzqp6HNLmAhl9qb9rM1Rm7hGOm2eBrrjpvtUk
         X5ZQ93uPfOPIAkayMHUmohPsCGC0158TXiHIKcLBNxvtEl6R82hFZxHNBBwbhW4++9Uw
         tA6qFojwRaa90+oc6X3ut/HmPKxX+vqtmCCfQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=Ss/iHhXfH0bkdkXpRw1s82EALDsyOHTjJKIfLzwEJx4=;
        b=E8Z6RBNR1Z09R33wu1wnC2DWGWUbE8fwFmZ/+ZLuhyl1KVAEmNdePY003p0LlmmEn0
         VG6UlJbir+G4jrD0gaElps/EFgBDmXirg2Ff3xfmU5zKv6cBDIPcsWviBFegAL4oQU8T
         7e3JXOIO3uMRyWwncDS4QAFNV/17t/pSPSxmA6hXz3FSQJE46Rv40MSmRlmmfAXyn/+C
         vsztlpcHBIk4wG/vL4vSRjbxfBBr6j/dn/Ic5Wu7vZ6LSHZxjNQzXVW4NCca+LYR0PtH
         BQYH8EAOLQ0rVMnSMu2XrQfXLqUKTfWIkAHwAbOrn2zYQiOOsYphi9JUpMLTtlGOZ8bF
         YE+Q==
X-Gm-Message-State: APjAAAUCqHvEsYRDwHJHrAtN5LnxFPhlPBYZAZ7bF3Qf7Lovczp9L8np
        TEmPgWRpZWvR1kLbQPCpS4JAYuUdxavsQFOKtII7KA==
X-Google-Smtp-Source: APXvYqwFRpNCUM2hECc1jJDWYjt+9PYukx0Jm7MYciRdUPWpaMhfbWut3L9xIW++OcIijIr0GP2CrDkWW/PCKkIUkF0=
X-Received: by 2002:ab0:6615:: with SMTP id r21mr4676911uam.136.1579650535126;
 Tue, 21 Jan 2020 15:48:55 -0800 (PST)
MIME-Version: 1.0
References: <20200117212705.57436-1-abhishekpandit@chromium.org>
 <20200117132623.RFC.2.I5f47e609ee90484bef06a09e37a66c6569eeb584@changeid> <CE580C0E-3F79-466C-BC93-0E469418496D@holtmann.org>
In-Reply-To: <CE580C0E-3F79-466C-BC93-0E469418496D@holtmann.org>
From:   Abhishek Pandit-Subedi <abhishekpandit@chromium.org>
Date:   Tue, 21 Jan 2020 15:48:44 -0800
Message-ID: <CANFp7mVqPGMw-Q4kcZHNLT9Vv-chWGZ3bi3M4Y_fX+atK8-Luw@mail.gmail.com>
Subject: Re: [RFC PATCH 2/2] Bluetooth: Handle PM_SUSPEND_PREPARE and PM_POST_SUSPEND
To:     Marcel Holtmann <marcel@holtmann.org>
Cc:     Luiz Augusto von Dentz <luiz.dentz@gmail.com>,
        Alain Michaud <alainm@chromium.org>,
        Bluez mailing list <linux-bluetooth@vger.kernel.org>,
        chromeos-bluetooth-upstreaming@chromium.org,
        "David S. Miller" <davem@davemloft.net>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Marcel,

On Tue, Jan 21, 2020 at 8:53 AM Marcel Holtmann <marcel@holtmann.org> wrote=
:
>
> Hi Abhishek,
>
> > Register for PM_SUSPEND_PREPARE and PM_POST_SUSPEND to make sure the
> > Bluetooth controller is prepared correctly for suspend/resume. The
> > suspend notifier will wait for all tasks to complete before returning.
> >
> > At a high level, we do the following when entering suspend:
> > - Pause any active discovery
> > - Pause any active advertising
> > - Set the event filter with addresses of wake capable Classic devices
> >  and enable Page Scan
> > - Update the LE whitelist to only include devices that can wake the
> >  system, update the scan parameters and enable passive scanning.
> > - Disconnect all devices with a POWER_DOWN reason
> >
> > On resume, it reverses the above operations:
> > - Clear event filters and restore page scan
> > - Restore LE whitelist and restore passive scan
> > - If advertising was active before suspend, re-enable it
> > - If discovery was active before suspend, re-enable it
> >
> > Signed-off-by: Abhishek Pandit-Subedi <abhishekpandit@chromium.org>
> > ---
> >
> > include/net/bluetooth/hci.h      |  30 +++-
> > include/net/bluetooth/hci_core.h |  45 +++++
> > net/bluetooth/hci_core.c         |  70 ++++++++
> > net/bluetooth/hci_event.c        |  24 ++-
> > net/bluetooth/hci_request.c      | 297 ++++++++++++++++++++++++++++---
> > net/bluetooth/hci_request.h      |   4 +-
> > net/bluetooth/mgmt.c             |  52 +++++-
> > 7 files changed, 486 insertions(+), 36 deletions(-)
> >
> > diff --git a/include/net/bluetooth/hci.h b/include/net/bluetooth/hci.h
> > index 6293bdd7d862..3c85c556e59a 100644
> > --- a/include/net/bluetooth/hci.h
> > +++ b/include/net/bluetooth/hci.h
> > @@ -932,10 +932,31 @@ struct hci_cp_sniff_subrate {
> > #define HCI_OP_RESET                  0x0c03
> >
> > #define HCI_OP_SET_EVENT_FLT          0x0c05
> > -struct hci_cp_set_event_flt {
> > +#define HCI_SET_EVENT_FLT_SIZE               9
> > +struct hci_cp_set_event_filter {
> >       __u8     flt_type;
> >       __u8     cond_type;
> > -     __u8     condition[0];
> > +     union {
> > +             union {
> > +                     struct {
> > +                             __u8 val[3];
> > +                             __u8 mask[3];
> > +                     } __packed dev_class;
> > +                     bdaddr_t addr;
> > +             } inq;
> > +             union {
> > +                     __u8 auto_accept_any;
> > +                     struct {
> > +                             __u8 val[3];
> > +                             __u8 mask[3];
> > +                             __u8 auto_accept;
> > +                     } __packed dev_class;
> > +                     struct {
> > +                             bdaddr_t bdaddr;
> > +                             __u8 auto_accept;
> > +                     } __packed addr;
> > +             } conn;
> > +     } cond;
>
> if we are only planning to use the address to whitelist device that are a=
llowed to wake us up, then lets keep this struct simple. If at a later poin=
t we want to do something different, we deal with it then.

Acknowledged. Will simplify in the next series.

>
> > } __packed;
> >
> > /* Filter types */
> > @@ -949,8 +970,9 @@ struct hci_cp_set_event_flt {
> > #define HCI_CONN_SETUP_ALLOW_BDADDR   0x02
> >
> > /* CONN_SETUP Conditions */
> > -#define HCI_CONN_SETUP_AUTO_OFF      0x01
> > -#define HCI_CONN_SETUP_AUTO_ON       0x02
> > +#define HCI_CONN_SETUP_AUTO_OFF              0x01
> > +#define HCI_CONN_SETUP_AUTO_ON               0x02
> > +#define HCI_CONN_SETUP_AUTO_ON_WITH_RS       0x03
> >
> > #define HCI_OP_READ_STORED_LINK_KEY   0x0c0d
> > struct hci_cp_read_stored_link_key {
> > diff --git a/include/net/bluetooth/hci_core.h b/include/net/bluetooth/h=
ci_core.h
> > index ce4bebcb0265..963871fca069 100644
> > --- a/include/net/bluetooth/hci_core.h
> > +++ b/include/net/bluetooth/hci_core.h
> > @@ -88,6 +88,49 @@ struct discovery_state {
> >       unsigned long           scan_duration;
> > };
> >
> > +#define SUSPEND_NOTIFIER_TIMEOUT     msecs_to_jiffies(2000) /* 2 secon=
ds */
> > +
> > +enum suspend_tasks {
> > +     SUSPEND_PAUSE_DISCOVERY,
> > +     SUSPEND_UNPAUSE_DISCOVERY,
> > +
> > +     SUSPEND_PAUSE_ADVERTISING,
> > +     SUSPEND_UNPAUSE_ADVERTISING,
> > +
> > +     SUSPEND_LE_SET_SCAN_ENABLE,
> > +     SUSPEND_DISCONNECTING,
> > +
> > +     SUSPEND_PREPARE_NOTIFIER,
> > +     __SUSPEND_NUM_TASKS
> > +};
> > +
> > +enum suspended_state {
> > +     BT_RUNNING =3D 0,
> > +     BT_SUSPENDED,
> > +};
> > +
> > +struct suspend_state {
> > +     int     discovery_old_state;
> > +     int     advertising_old_state;
> > +
> > +     bool    discovery_paused;
> > +     bool    advertising_paused;
> > +
> > +     int     disconnect_counter;
> > +
> > +     /* BREDR: Disallow changing event filters + page scan.
> > +      * LE: Disallow changing whitelist, scan params and scan enable.
> > +      */
> > +     bool    freeze_filters;
> > +
> > +     DECLARE_BITMAP(tasks, __SUSPEND_NUM_TASKS);
> > +     wait_queue_head_t       tasks_wait_q;
> > +
> > +     struct work_struct      prepare;
> > +     enum suspended_state    next_state;
> > +     enum suspended_state    state;
> > +};
> > +
>
> With a simple glance, I am not convinced that this should be a separate s=
truct. I would include things directly in hci_dev actually.

Acknowledged. Will flatten in next series.

>
> > struct hci_conn_hash {
> >       struct list_head list;
> >       unsigned int     acl_num;
> > @@ -389,6 +432,8 @@ struct hci_dev {
> >       void                    *smp_bredr_data;
> >
> >       struct discovery_state  discovery;
> > +     struct suspend_state    suspend;
> > +     struct notifier_block   suspend_notifier;
> >       struct hci_conn_hash    conn_hash;
> >
> >       struct list_head        mgmt_pending;
> > diff --git a/net/bluetooth/hci_core.c b/net/bluetooth/hci_core.c
> > index 7057b9b65173..76bd4f376790 100644
> > --- a/net/bluetooth/hci_core.c
> > +++ b/net/bluetooth/hci_core.c
> > @@ -31,6 +31,8 @@
> > #include <linux/debugfs.h>
> > #include <linux/crypto.h>
> > #include <linux/property.h>
> > +#include <linux/suspend.h>
> > +#include <linux/wait.h>
> > #include <asm/unaligned.h>
> >
> > #include <net/bluetooth/bluetooth.h>
> > @@ -3241,6 +3243,65 @@ void hci_copy_identity_address(struct hci_dev *h=
dev, bdaddr_t *bdaddr,
> >       }
> > }
> >
> > +static int hci_suspend_wait_event(struct hci_dev *hdev)
> > +{
> > +#define WAKE_COND                                                     =
         \
> > +     (find_first_bit(hdev->suspend.tasks, __SUSPEND_NUM_TASKS) =3D=3D =
          \
> > +      __SUSPEND_NUM_TASKS)
> > +
> > +     int i;
> > +     int ret =3D wait_event_timeout(hdev->suspend.tasks_wait_q,
> > +                                  WAKE_COND, SUSPEND_NOTIFIER_TIMEOUT)=
;
> > +
> > +     if (ret =3D=3D 0) {
> > +             BT_DBG("Timed out waiting for suspend");
> > +             for (i =3D 0; i < __SUSPEND_NUM_TASKS; ++i) {
> > +                     if (test_bit(i, hdev->suspend.tasks))
> > +                             BT_DBG("Bit %d is set", i);
> > +                     clear_bit(i, hdev->suspend.tasks);
> > +             }
> > +
> > +             ret =3D -ETIMEDOUT;
> > +     } else {
> > +             ret =3D 0;
> > +     }
> > +
> > +     return ret;
> > +}
> > +
> > +static void hci_prepare_suspend(struct work_struct *work)
> > +{
> > +     struct hci_dev *hdev =3D
> > +             container_of(work, struct hci_dev, suspend.prepare);
> > +
> > +     hci_dev_lock(hdev);
> > +     hci_req_prepare_suspend(hdev, hdev->suspend.next_state);
> > +     hci_dev_unlock(hdev);
> > +}
> > +
> > +static int hci_suspend_notifier(struct notifier_block *nb, unsigned lo=
ng action,
> > +                             void *data)
> > +{
> > +     struct hci_dev *hdev =3D
> > +             container_of(nb, struct hci_dev, suspend_notifier);
> > +     int ret =3D 0;
> > +
> > +     if (action =3D=3D PM_SUSPEND_PREPARE) {
> > +             hdev->suspend.next_state =3D BT_SUSPENDED;
> > +             set_bit(SUSPEND_PREPARE_NOTIFIER, hdev->suspend.tasks);
> > +             queue_work(hdev->req_workqueue, &hdev->suspend.prepare);
> > +
> > +             ret =3D hci_suspend_wait_event(hdev);
> > +     } else if (action =3D=3D PM_POST_SUSPEND) {
> > +             hdev->suspend.next_state =3D BT_RUNNING;
> > +             set_bit(SUSPEND_PREPARE_NOTIFIER, hdev->suspend.tasks);
> > +             queue_work(hdev->req_workqueue, &hdev->suspend.prepare);
> > +
> > +             ret =3D hci_suspend_wait_event(hdev);
> > +     }
> > +
> > +     return ret ? notifier_from_errno(-EBUSY) : NOTIFY_STOP;
> > +}
> > /* Alloc HCI device */
> > struct hci_dev *hci_alloc_dev(void)
> > {
> > @@ -3319,6 +3380,7 @@ struct hci_dev *hci_alloc_dev(void)
> >       INIT_WORK(&hdev->tx_work, hci_tx_work);
> >       INIT_WORK(&hdev->power_on, hci_power_on);
> >       INIT_WORK(&hdev->error_reset, hci_error_reset);
> > +     INIT_WORK(&hdev->suspend.prepare, hci_prepare_suspend);
> >
> >       INIT_DELAYED_WORK(&hdev->power_off, hci_power_off);
> >
> > @@ -3327,6 +3389,7 @@ struct hci_dev *hci_alloc_dev(void)
> >       skb_queue_head_init(&hdev->raw_q);
> >
> >       init_waitqueue_head(&hdev->req_wait_q);
> > +     init_waitqueue_head(&hdev->suspend.tasks_wait_q);
> >
> >       INIT_DELAYED_WORK(&hdev->cmd_timer, hci_cmd_timeout);
> >
> > @@ -3438,6 +3501,11 @@ int hci_register_dev(struct hci_dev *hdev)
> >       hci_sock_dev_event(hdev, HCI_DEV_REG);
> >       hci_dev_hold(hdev);
> >
> > +     hdev->suspend_notifier.notifier_call =3D hci_suspend_notifier;
> > +     error =3D register_pm_notifier(&hdev->suspend_notifier);
> > +     if (error)
> > +             goto err_wqueue;
> > +
> >       queue_work(hdev->req_workqueue, &hdev->power_on);
> >
> >       return id;
> > @@ -3471,6 +3539,8 @@ void hci_unregister_dev(struct hci_dev *hdev)
> >
> >       hci_dev_do_close(hdev);
> >
> > +     unregister_pm_notifier(&hdev->suspend_notifier);
> > +
> >       if (!test_bit(HCI_INIT, &hdev->flags) &&
> >           !hci_dev_test_flag(hdev, HCI_SETUP) &&
> >           !hci_dev_test_flag(hdev, HCI_CONFIG)) {
> > diff --git a/net/bluetooth/hci_event.c b/net/bluetooth/hci_event.c
> > index 6ddc4a74a5e4..623eca68afdd 100644
> > --- a/net/bluetooth/hci_event.c
> > +++ b/net/bluetooth/hci_event.c
> > @@ -2474,6 +2474,7 @@ static void hci_inquiry_result_evt(struct hci_dev=
 *hdev, struct sk_buff *skb)
> > static void hci_conn_complete_evt(struct hci_dev *hdev, struct sk_buff =
*skb)
> > {
> >       struct hci_ev_conn_complete *ev =3D (void *) skb->data;
> > +     struct inquiry_entry *ie;
> >       struct hci_conn *conn;
> >
> >       BT_DBG("%s", hdev->name);
> > @@ -2482,14 +2483,25 @@ static void hci_conn_complete_evt(struct hci_de=
v *hdev, struct sk_buff *skb)
> >
> >       conn =3D hci_conn_hash_lookup_ba(hdev, ev->link_type, &ev->bdaddr=
);
> >       if (!conn) {
> > -             if (ev->link_type !=3D SCO_LINK)
> > -                     goto unlock;
> > +             ie =3D hci_inquiry_cache_lookup(hdev, &ev->bdaddr);
> > +             if (ie) {
> > +                     conn =3D hci_conn_add(hdev, ev->link_type, &ev->b=
daddr,
> > +                                         HCI_ROLE_SLAVE);
> > +                     if (!conn) {
> > +                             bt_dev_err(hdev, "no memory for new conn"=
);
> > +                             goto unlock;
> > +                     }
> > +             } else {
> > +                     if (ev->link_type !=3D SCO_LINK)
> > +                             goto unlock;
>
> I do not understand this change. What does it do? I think you would need =
to add a comment here. Maybe this is a change that needs to be split out in=
to a separate patch.

When configuring the event filter for suspend, I configure the event
filter to auto-connect. A connection is added to hdev->conn_hash
during hci_conn_request_evt which isn't called for auto-connect. This
just allows an auto-accepted connection if it didn't go through
connection request first.
Will add a comment to that regard.

>
> >
> > -             conn =3D hci_conn_hash_lookup_ba(hdev, ESCO_LINK, &ev->bd=
addr);
> > -             if (!conn)
> > -                     goto unlock;
> > +                     conn =3D hci_conn_hash_lookup_ba(hdev, ESCO_LINK,
> > +                                                    &ev->bdaddr);
> > +                     if (!conn)
> > +                             goto unlock;
> >
> > -             conn->type =3D SCO_LINK;
> > +                     conn->type =3D SCO_LINK;
> > +             }
> >       }
> >
> >       if (!ev->status) {
> > diff --git a/net/bluetooth/hci_request.c b/net/bluetooth/hci_request.c
> > index 2a1b64dbf76e..3044d9e1ea2b 100644
> > --- a/net/bluetooth/hci_request.c
> > +++ b/net/bluetooth/hci_request.c
> > @@ -447,7 +447,7 @@ static void __hci_update_background_scan(struct hci=
_request *req)
> >               if (hci_dev_test_flag(hdev, HCI_LE_SCAN))
> >                       hci_req_add_le_scan_disable(req);
> >
> > -             hci_req_add_le_passive_scan(req);
> > +             hci_req_add_le_passive_scan(req, false);
>
> Generally it is pretty bad to have a list of boolean parameters since you=
 don=E2=80=99t know what this call does. From context you can=E2=80=99t tel=
l what this false means that is pretty bad if you have to re-read that code=
 in a few month.
>
> Can we do this more elegant without having to add a suspending variable t=
o a bunch of existing functions?

#1 I can move the suspending boolean into hdev and check
hdev->suspending (reduces having to pass it around in parameters but
makes things slightly less clear since state is in struct hci_device).
#2 Or I can make the boolean an int and use #define LE_SCAN_SUSPENDING
1. (i.e. hci_req_add_le_passive_scan(req, LE_SCAN_SUSPENDING) )

I am more partial to #2 because it makes it clear that I'm doing
something different when I call it with a parameter.

>
> >
> >               BT_DBG("%s starting background scanning", hdev->name);
> >       }
> > @@ -654,6 +654,12 @@ void hci_req_add_le_scan_disable(struct hci_reques=
t *req)
> > {
> >       struct hci_dev *hdev =3D req->hdev;
> >
> > +     /* Early exit if we've frozen filters for suspend*/
>
> Space before */

Ack.

>
> > +     if (hdev->suspend.freeze_filters) {
> > +             BT_DBG("Filters are frozen for suspend");
> > +             return;
> > +     }
> > +
> >       if (use_ext_scan(hdev)) {
> >               struct hci_cp_le_set_ext_scan_enable cp;
> >
> > @@ -681,12 +687,25 @@ static void add_to_white_list(struct hci_request =
*req,
> >       hci_req_add(req, HCI_OP_LE_ADD_TO_WHITE_LIST, sizeof(cp), &cp);
> > }
> >
> > -static u8 update_white_list(struct hci_request *req)
> > +static void del_from_white_list(struct hci_request *req, bdaddr_t *bda=
ddr,
> > +                             u8 bdaddr_type)
> > +{
> > +     struct hci_cp_le_del_from_white_list cp;
> > +
> > +     cp.bdaddr_type =3D bdaddr_type;
> > +     bacpy(&cp.bdaddr, bdaddr);
> > +
> > +     hci_req_add(req, HCI_OP_LE_DEL_FROM_WHITE_LIST, sizeof(cp), &cp);
> > +}
> > +
> > +static u8 update_white_list(struct hci_request *req, bool allow_rpa,
> > +                         bool remove_nonwakeable)
> > {
> >       struct hci_dev *hdev =3D req->hdev;
> >       struct hci_conn_params *params;
> >       struct bdaddr_list *b;
> >       uint8_t white_list_entries =3D 0;
> > +     bool wakeable;
> >
> >       /* Go through the current white list programmed into the
> >        * controller one by one and check if that address is still
> > @@ -695,24 +714,37 @@ static u8 update_white_list(struct hci_request *r=
eq)
> >        * command to remove it from the controller.
> >        */
> >       list_for_each_entry(b, &hdev->le_white_list, list) {
> > -             /* If the device is neither in pend_le_conns nor
> > -              * pend_le_reports then remove it from the whitelist.
> > +             wakeable =3D !!hci_bdaddr_list_lookup(&hdev->wakeable, &b=
->bdaddr,
> > +                                                 b->bdaddr_type);
> > +
> > +             /* If the device is not likely to connect or report, remo=
ve it
> > +              * from the whitelist. Make an exception for wakeable dev=
ices if
> > +              * we're removing only non-wakeable devices (we want them=
 to
> > +              * stay in whitelist).
> >                */
> >               if (!hci_pend_le_action_lookup(&hdev->pend_le_conns,
> >                                              &b->bdaddr, b->bdaddr_type=
) &&
> >                   !hci_pend_le_action_lookup(&hdev->pend_le_reports,
> > -                                            &b->bdaddr, b->bdaddr_type=
)) {
> > -                     struct hci_cp_le_del_from_white_list cp;
> > -
> > -                     cp.bdaddr_type =3D b->bdaddr_type;
> > -                     bacpy(&cp.bdaddr, &b->bdaddr);
> > +                                            &b->bdaddr, b->bdaddr_type=
) &&
> > +                 (!wakeable && remove_nonwakeable)) {
> > +                     BT_DBG("Removing %pMR (0x%x) - not pending or wak=
eable",
> > +                            &b->bdaddr, b->bdaddr_type);
> > +                     del_from_white_list(req, &b->bdaddr, b->bdaddr_ty=
pe);
> > +                     continue;
> > +             }
> >
> > -                     hci_req_add(req, HCI_OP_LE_DEL_FROM_WHITE_LIST,
> > -                                 sizeof(cp), &cp);
> > +             /* If we're removing non wakeable devices and this whitel=
ist
> > +              * entry is not wake capable, we remove it from the white=
list.
> > +              */
> > +             if (remove_nonwakeable && !wakeable) {
> > +                     BT_DBG("Removing %pMR (0x%x) - not wake capable",
> > +                            &b->bdaddr, b->bdaddr_type);
> > +                     del_from_white_list(req, &b->bdaddr, b->bdaddr_ty=
pe);
> >                       continue;
> >               }
> >
> > -             if (hci_find_irk_by_addr(hdev, &b->bdaddr, b->bdaddr_type=
)) {
> > +             if (!allow_rpa &&
> > +                 hci_find_irk_by_addr(hdev, &b->bdaddr, b->bdaddr_type=
)) {
> >                       /* White list can not be used with RPAs */
> >                       return 0x00;
> >               }
> > @@ -740,14 +772,20 @@ static u8 update_white_list(struct hci_request *r=
eq)
> >                       return 0x00;
> >               }
> >
> > -             if (hci_find_irk_by_addr(hdev, &params->addr,
> > -                                      params->addr_type)) {
> > +             if (!allow_rpa && hci_find_irk_by_addr(hdev, &params->add=
r,
> > +                                                    params->addr_type)=
) {
> >                       /* White list can not be used with RPAs */
> >                       return 0x00;
> >               }
> >
> > +             if (remove_nonwakeable &&
> > +                 !hci_bdaddr_list_lookup(&hdev->wakeable, &b->bdaddr,
> > +                                         b->bdaddr_type))
> > +                     continue;
> > +
> >               white_list_entries++;
> >               add_to_white_list(req, params);
> > +             BT_DBG("Adding %pMR to whitelist", &params->addr);
> >       }
> >
> >       /* After adding all new pending connections, walk through
> > @@ -764,14 +802,20 @@ static u8 update_white_list(struct hci_request *r=
eq)
> >                       return 0x00;
> >               }
> >
> > -             if (hci_find_irk_by_addr(hdev, &params->addr,
> > -                                      params->addr_type)) {
> > +             if (!allow_rpa && hci_find_irk_by_addr(hdev, &params->add=
r,
> > +                                                    params->addr_type)=
) {
> >                       /* White list can not be used with RPAs */
> >                       return 0x00;
> >               }
> >
> > +             if (remove_nonwakeable &&
> > +                 !hci_bdaddr_list_lookup(&hdev->wakeable, &b->bdaddr,
> > +                                         b->bdaddr_type))
> > +                     continue;
> > +
> >               white_list_entries++;
> >               add_to_white_list(req, params);
> > +             BT_DBG("Adding %pMR to whitelist", &params->addr);
> >       }
> >
> >       /* Select filter policy to use white list */
> > @@ -784,7 +828,8 @@ static bool scan_use_rpa(struct hci_dev *hdev)
> > }
>
> I have the feeling we might now need to restructure the update white list=
 function to keep it readable. It already has tons of comments for corner c=
ases and would require now even more for the suspend corner cases.
>
> My advice to really add comments explaining why this is correct or what t=
hings do for function that are complicated by nature.

Will refactor to improve clarity.

>
> >
> > static void hci_req_start_scan(struct hci_request *req, u8 type, u16 in=
terval,
> > -                            u16 window, u8 own_addr_type, u8 filter_po=
licy)
> > +                            u16 window, u8 own_addr_type, u8 filter_po=
licy,
> > +                            u8 filter_dup)
> > {
> >       struct hci_dev *hdev =3D req->hdev;
> >
> > @@ -836,7 +881,7 @@ static void hci_req_start_scan(struct hci_request *=
req, u8 type, u16 interval,
> >
> >               memset(&ext_enable_cp, 0, sizeof(ext_enable_cp));
> >               ext_enable_cp.enable =3D LE_SCAN_ENABLE;
> > -             ext_enable_cp.filter_dup =3D LE_SCAN_FILTER_DUP_ENABLE;
> > +             ext_enable_cp.filter_dup =3D filter_dup;
> >
> >               hci_req_add(req, HCI_OP_LE_SET_EXT_SCAN_ENABLE,
> >                           sizeof(ext_enable_cp), &ext_enable_cp);
> > @@ -855,17 +900,47 @@ static void hci_req_start_scan(struct hci_request=
 *req, u8 type, u16 interval,
> >
> >               memset(&enable_cp, 0, sizeof(enable_cp));
> >               enable_cp.enable =3D LE_SCAN_ENABLE;
> > -             enable_cp.filter_dup =3D LE_SCAN_FILTER_DUP_ENABLE;
> > +             enable_cp.filter_dup =3D filter_dup;
> >               hci_req_add(req, HCI_OP_LE_SET_SCAN_ENABLE, sizeof(enable=
_cp),
> >                           &enable_cp);
> >       }
> > }
>
> If this is required, we should have this as a separate patch. Again, plea=
se see my comment with two many parameters. We ensured that callers use var=
iable that clearly give a hint what the parameter is and what it does.
>
> >
> > -void hci_req_add_le_passive_scan(struct hci_request *req)
> > +static u16 __hci_get_scan_interval(struct hci_dev *hdev, bool suspendi=
ng)
> > +{
> > +     if (suspending)
> > +             return 0x0060;
> > +     else
> > +             return hdev->le_scan_interval;
> > +}
> > +
> > +static u16 __hci_get_scan_window(struct hci_dev *hdev, bool suspending=
)
> > +{
> > +     if (suspending)
> > +             return 0x0012;
> > +     else
> > +             return hdev->le_scan_window;
> > +}
>
> I think this makes the code harder to read. Just put the if-clause where =
you use it and use a constant for 0x0060 and 0x0012.

Ack.

>
> > +
> > +void hci_req_add_le_passive_scan(struct hci_request *req, bool suspend=
ing)
> > {
> >       struct hci_dev *hdev =3D req->hdev;
> >       u8 own_addr_type;
> >       u8 filter_policy;
> > +     u8 filter_dup;
> > +
> > +     /* We allow whitelisting even with RPAs in suspend. In the worst =
case,
> > +      * we won't be able to wake from devices that use the privacy1.2
> > +      * features. Additionally, once we support privacy1.2 and IRK
> > +      * offloading, we can update this to also check for those conditi=
ons.
> > +      */
> > +     bool allow_rpa =3D suspending;
> > +
> > +     /* Early exit if we've frozen filters for suspend*/
> > +     if (hdev->suspend.freeze_filters) {
> > +             BT_DBG("Filters are frozen for suspend");
> > +             return;
> > +     }
> >
> >       /* Set require_privacy to false since no SCAN_REQ are send
> >        * during passive scanning. Not using an non-resolvable address
> > @@ -881,7 +956,8 @@ void hci_req_add_le_passive_scan(struct hci_request=
 *req)
> >        * happen before enabling scanning. The controller does
> >        * not allow white list modification while scanning.
> >        */
> > -     filter_policy =3D update_white_list(req);
> > +     BT_DBG("Updating white list with suspending =3D %d", suspending);
> > +     filter_policy =3D update_white_list(req, allow_rpa, suspending);
> >
> >       /* When the controller is using random resolvable addresses and
> >        * with that having LE privacy enabled, then controllers with
> > @@ -896,8 +972,14 @@ void hci_req_add_le_passive_scan(struct hci_reques=
t *req)
> >           (hdev->le_features[0] & HCI_LE_EXT_SCAN_POLICY))
> >               filter_policy |=3D 0x02;
> >
> > -     hci_req_start_scan(req, LE_SCAN_PASSIVE, hdev->le_scan_interval,
> > -                        hdev->le_scan_window, own_addr_type, filter_po=
licy);
> > +     filter_dup =3D suspending ? LE_SCAN_FILTER_DUP_DISABLE :
> > +                               LE_SCAN_FILTER_DUP_ENABLE;
>
> I think this warrants a comment why duplicate filtering gets disabled on =
suspend. I for example don=E2=80=99t get it.

The only events that should be processed during suspend are connection
requests from whitelisted devices. In this scenario, I didn't see why
filter duplicates should be enabled. I can leave it disabled to
simplify the code.

>
> > +
> > +     BT_DBG("LE passive scan with whitelist =3D %d", filter_policy);
> > +     hci_req_start_scan(req, LE_SCAN_PASSIVE,
> > +                        __hci_get_scan_interval(hdev, suspending),
> > +                        __hci_get_scan_window(hdev, suspending),
> > +                        own_addr_type, filter_policy, filter_dup);
> > }
> >
> > static u8 get_adv_instance_scan_rsp_len(struct hci_dev *hdev, u8 instan=
ce)
> > @@ -918,6 +1000,170 @@ static u8 get_adv_instance_scan_rsp_len(struct h=
ci_dev *hdev, u8 instance)
> >       return adv_instance->scan_rsp_len;
> > }
> >
> > +static void hci_req_set_event_filter(struct hci_request *req, bool cle=
ar)
> > +{
> > +     struct bdaddr_list *b;
> > +     struct hci_cp_set_event_filter f;
> > +     struct hci_dev *hdev =3D req->hdev;
> > +     int filters_updated =3D 0;
> > +     u8 scan;
> > +
> > +     /* Always clear event filter when starting */
> > +     memset(&f, 0, sizeof(f));
> > +     f.flt_type =3D HCI_FLT_CLEAR_ALL;
> > +     hci_req_add(req, HCI_OP_SET_EVENT_FLT, 1, &f);
> > +
> > +     if (!clear) {
> > +             list_for_each_entry(b, &hdev->wakeable, list) {
> > +                     if (b->bdaddr_type !=3D BDADDR_BREDR)
> > +                             continue;
> > +
> > +                     memset(&f, 0, sizeof(f));
> > +                     bacpy(&f.cond.conn.addr.bdaddr, &b->bdaddr);
> > +                     f.flt_type =3D HCI_FLT_CONN_SETUP;
> > +                     f.cond_type =3D HCI_CONN_SETUP_ALLOW_BDADDR;
> > +                     f.cond.conn.addr.auto_accept =3D HCI_CONN_SETUP_A=
UTO_ON;
> > +
> > +                     BT_DBG("Adding event filters for %pMR", &b->bdadd=
r);
> > +                     hci_req_add(req, HCI_OP_SET_EVENT_FLT, sizeof(f),=
 &f);
> > +
> > +                     filters_updated++;
> > +             }
> > +
> > +             scan =3D filters_updated ? SCAN_PAGE : SCAN_DISABLED;
> > +             hci_req_add(req, HCI_OP_WRITE_SCAN_ENABLE, 1, &scan);
> > +     } else {
> > +             /* Restore page scan to normal (i.e. there are disconnect=
ed
> > +              * devices in the whitelist.
> > +              */
> > +             __hci_req_update_scan(req);
> > +     }
> > +}
>
> Lets have a simple hci_req_clear_event_filter and hci_req_set_event_filte=
r function. Doing both in one function doesn=E2=80=99t save much.

Ack.

>
> > +
> > +static void hci_req_enable_le_suspend_scan(struct hci_request *req,
> > +                                        bool suspending)
> > +{
> > +     /* Can't change params without disabling first */
> > +     hci_req_add_le_scan_disable(req);
> > +
> > +     /* Configure params and enable scanning */
> > +     hci_req_add_le_passive_scan(req, suspending);
> > +
> > +     /* Block suspend notifier on response */
> > +     set_bit(SUSPEND_LE_SET_SCAN_ENABLE, req->hdev->suspend.tasks);
> > +}
> > +
> > +static void le_suspend_req_complete(struct hci_dev *hdev, u8 status, u=
16 opcode)
> > +{
> > +     BT_DBG("Request complete opcode=3D0x%x, status=3D0x%x", opcode, s=
tatus);
> > +
> > +     /* Expecting LE Set scan to return */
> > +     if (opcode =3D=3D HCI_OP_LE_SET_SCAN_ENABLE &&
> > +         test_and_clear_bit(SUSPEND_LE_SET_SCAN_ENABLE,
> > +                            hdev->suspend.tasks)) {
> > +             wake_up(&hdev->suspend.tasks_wait_q);
> > +     }
> > +}
> > +
> > +/* Call with hci_dev_lock */
> > +void hci_req_prepare_suspend(struct hci_dev *hdev, enum suspended_stat=
e next)
> > +{
> > +     int old_state;
> > +     struct hci_conn *conn;
> > +     struct hci_request req;
> > +
> > +     if (next =3D=3D hdev->suspend.state) {
> > +             BT_DBG("Same state before and after: %d", next);
> > +             goto done;
> > +     }
> > +
> > +     hci_req_init(&req, hdev);
> > +     if (next =3D=3D BT_SUSPENDED) {
> > +             /* Pause discovery if not already stopped */
> > +             old_state =3D hdev->discovery.state;
> > +             if (old_state !=3D DISCOVERY_STOPPED) {
> > +                     set_bit(SUSPEND_PAUSE_DISCOVERY, hdev->suspend.ta=
sks);
> > +                     hci_discovery_set_state(hdev, DISCOVERY_STOPPING)=
;
> > +                     queue_work(hdev->req_workqueue, &hdev->discov_upd=
ate);
> > +             }
> > +
> > +             hdev->suspend.discovery_paused =3D true;
> > +             hdev->suspend.discovery_old_state =3D old_state;
> > +
> > +             /* Stop advertising */
> > +             old_state =3D hci_dev_test_flag(hdev, HCI_ADVERTISING);
> > +             if (old_state) {
> > +                     set_bit(SUSPEND_PAUSE_ADVERTISING, hdev->suspend.=
tasks);
> > +                     cancel_delayed_work(&hdev->discov_off);
> > +                     queue_delayed_work(hdev->req_workqueue,
> > +                                        &hdev->discov_off, 0);
> > +             }
> > +
> > +             hdev->suspend.advertising_paused =3D true;
> > +             hdev->suspend.advertising_old_state =3D old_state;
> > +
> > +             /* Enable event filter for existing devices */
> > +             hci_req_set_event_filter(&req, false);
> > +
> > +             /* Enable passive scan at lower duty cycle */
> > +             hci_req_enable_le_suspend_scan(&req, true);
> > +
> > +             hdev->suspend.freeze_filters =3D true;
> > +
> > +             /* Run commands before disconnecting */
> > +             hci_req_run(&req, le_suspend_req_complete);
> > +
> > +             hdev->suspend.disconnect_counter =3D 0;
> > +             /* Soft disconnect everything (power off)*/
> > +             list_for_each_entry(conn, &hdev->conn_hash.list, list) {
> > +                     hci_disconnect(conn, HCI_ERROR_REMOTE_POWER_OFF);
> > +                     hdev->suspend.disconnect_counter++;
> > +             }
> > +
> > +             if (hdev->suspend.disconnect_counter > 0) {
> > +                     BT_DBG("Had %d disconnects. Will wait on them",
> > +                            hdev->suspend.disconnect_counter);
> > +                     set_bit(SUSPEND_DISCONNECTING, hdev->suspend.task=
s);
> > +             }
> > +     } else {
> > +             hdev->suspend.freeze_filters =3D false;
> > +
> > +             /* Clear event filter */
> > +             hci_req_set_event_filter(&req, true);
> > +
> > +             /* Reset passive/background scanning to normal */
> > +             hci_req_enable_le_suspend_scan(&req, false);
> > +
> > +             /* Unpause advertising */
> > +             hdev->suspend.advertising_paused =3D false;
> > +             if (hdev->suspend.advertising_old_state) {
> > +                     set_bit(SUSPEND_UNPAUSE_ADVERTISING,
> > +                             hdev->suspend.tasks);
> > +                     hci_dev_set_flag(hdev, HCI_ADVERTISING);
> > +                     queue_work(hdev->req_workqueue,
> > +                                &hdev->discoverable_update);
> > +                     hdev->suspend.advertising_old_state =3D 0;
> > +             }
> > +
> > +             /* Unpause discovery */
> > +             hdev->suspend.discovery_paused =3D false;
> > +             if (hdev->suspend.discovery_old_state !=3D DISCOVERY_STOP=
PED &&
> > +                 hdev->suspend.discovery_old_state !=3D DISCOVERY_STOP=
PING) {
> > +                     set_bit(SUSPEND_UNPAUSE_DISCOVERY, hdev->suspend.=
tasks);
> > +                     hci_discovery_set_state(hdev, DISCOVERY_STARTING)=
;
> > +                     queue_work(hdev->req_workqueue, &hdev->discov_upd=
ate);
> > +             }
> > +
> > +             hci_req_run(&req, le_suspend_req_complete);
> > +     }
> > +
> > +     hdev->suspend.state =3D next;
> > +
> > +done:
> > +     clear_bit(SUSPEND_PREPARE_NOTIFIER, hdev->suspend.tasks);
> > +     wake_up(&hdev->suspend.tasks_wait_q);
> > +}
> > +
> > static u8 get_cur_adv_instance_scan_rsp_len(struct hci_dev *hdev)
> > {
> >       u8 instance =3D hdev->cur_adv_instance;
> > @@ -2015,6 +2261,9 @@ void __hci_req_update_scan(struct hci_request *re=
q)
> >       if (mgmt_powering_down(hdev))
> >               return;
> >
> > +     if (hdev->suspend.freeze_filters)
> > +             return;
> > +
> >       if (hci_dev_test_flag(hdev, HCI_CONNECTABLE) ||
> >           disconnected_whitelist_entries(hdev))
> >               scan =3D SCAN_PAGE;
> > @@ -2538,7 +2787,7 @@ static int active_scan(struct hci_request *req, u=
nsigned long opt)
> >               own_addr_type =3D ADDR_LE_DEV_PUBLIC;
> >
> >       hci_req_start_scan(req, LE_SCAN_ACTIVE, interval, DISCOV_LE_SCAN_=
WIN,
> > -                        own_addr_type, 0);
> > +                        own_addr_type, 0, LE_SCAN_FILTER_DUP_DISABLE);
> >       return 0;
> > }
> >
> > diff --git a/net/bluetooth/hci_request.h b/net/bluetooth/hci_request.h
> > index a7019fbeadd3..f555bb789664 100644
> > --- a/net/bluetooth/hci_request.h
> > +++ b/net/bluetooth/hci_request.h
> > @@ -66,7 +66,9 @@ void __hci_req_update_name(struct hci_request *req);
> > void __hci_req_update_eir(struct hci_request *req);
> >
> > void hci_req_add_le_scan_disable(struct hci_request *req);
> > -void hci_req_add_le_passive_scan(struct hci_request *req);
> > +void hci_req_add_le_passive_scan(struct hci_request *req, bool suspend=
ing);
> > +
> > +void hci_req_prepare_suspend(struct hci_dev *hdev, enum suspended_stat=
e next);
> >
> > void hci_req_reenable_advertising(struct hci_dev *hdev);
> > void __hci_req_enable_advertising(struct hci_request *req);
> > diff --git a/net/bluetooth/mgmt.c b/net/bluetooth/mgmt.c
> > index 95092130f16c..e5bac060c999 100644
> > --- a/net/bluetooth/mgmt.c
> > +++ b/net/bluetooth/mgmt.c
> > @@ -24,6 +24,7 @@
> >
> > /* Bluetooth HCI Management interface */
> >
> > +#include <linux/delay.h>
> > #include <linux/module.h>
> > #include <asm/unaligned.h>
> >
> > @@ -1385,6 +1386,12 @@ static int set_discoverable(struct sock *sk, str=
uct hci_dev *hdev, void *data,
> >               goto failed;
> >       }
> >
> > +     if (hdev->suspend.advertising_paused) {
> > +             err =3D mgmt_cmd_status(sk, hdev->id, MGMT_OP_SET_DISCOVE=
RABLE,
> > +                                   MGMT_STATUS_BUSY);
> > +             goto failed;
> > +     }
> > +
> >       if (!hdev_is_powered(hdev)) {
> >               bool changed =3D false;
> >
> > @@ -3868,6 +3875,13 @@ void mgmt_start_discovery_complete(struct hci_de=
v *hdev, u8 status)
> >       }
> >
> >       hci_dev_unlock(hdev);
> > +
> > +     /* Handle suspend notifier */
> > +     if (test_and_clear_bit(SUSPEND_UNPAUSE_DISCOVERY,
> > +                            hdev->suspend.tasks)) {
> > +             BT_DBG("Unpaused discovery");
> > +             wake_up(&hdev->suspend.tasks_wait_q);
> > +     }
> > }
> >
> > static bool discovery_type_is_valid(struct hci_dev *hdev, uint8_t type,
> > @@ -3929,6 +3943,13 @@ static int start_discovery_internal(struct sock =
*sk, struct hci_dev *hdev,
> >               goto failed;
> >       }
> >
> > +     /* Can't start discovery when it is paused */
> > +     if (hdev->suspend.discovery_paused) {
> > +             err =3D mgmt_cmd_complete(sk, hdev->id, op, MGMT_STATUS_B=
USY,
> > +                                     &cp->type, sizeof(cp->type));
> > +             goto failed;
> > +     }
> > +
> >       /* Clear the discovery filter first to free any previously
> >        * allocated memory for the UUID list.
> >        */
> > @@ -4096,6 +4117,12 @@ void mgmt_stop_discovery_complete(struct hci_dev=
 *hdev, u8 status)
> >       }
> >
> >       hci_dev_unlock(hdev);
> > +
> > +     /* Handle suspend notifier */
> > +     if (test_and_clear_bit(SUSPEND_PAUSE_DISCOVERY, hdev->suspend.tas=
ks)) {
> > +             BT_DBG("Paused discovery");
> > +             wake_up(&hdev->suspend.tasks_wait_q);
> > +     }
> > }
> >
> > static int stop_discovery(struct sock *sk, struct hci_dev *hdev, void *=
data,
> > @@ -4327,6 +4354,17 @@ static void set_advertising_complete(struct hci_=
dev *hdev, u8 status,
> >       if (match.sk)
> >               sock_put(match.sk);
> >
> > +     /* Handle suspend notifier */
> > +     if (test_and_clear_bit(SUSPEND_PAUSE_ADVERTISING,
> > +                            hdev->suspend.tasks)) {
> > +             BT_DBG("Paused advertising");
> > +             wake_up(&hdev->suspend.tasks_wait_q);
> > +     } else if (test_and_clear_bit(SUSPEND_UNPAUSE_ADVERTISING,
> > +                                   hdev->suspend.tasks)) {
> > +             BT_DBG("Unpaused advertising");
> > +             wake_up(&hdev->suspend.tasks_wait_q);
> > +     }
> > +
> >       /* If "Set Advertising" was just disabled and instance advertisin=
g was
> >        * set up earlier, then re-enable multi-instance advertising.
> >        */
> > @@ -4378,6 +4416,10 @@ static int set_advertising(struct sock *sk, stru=
ct hci_dev *hdev, void *data,
> >               return mgmt_cmd_status(sk, hdev->id, MGMT_OP_SET_ADVERTIS=
ING,
> >                                      MGMT_STATUS_INVALID_PARAMS);
> >
> > +     if (hdev->suspend.advertising_paused)
> > +             return mgmt_cmd_status(sk, hdev->id, MGMT_OP_SET_ADVERTIS=
ING,
> > +                                    MGMT_STATUS_BUSY);
> > +
> >       hci_dev_lock(hdev);
> >
> >       val =3D !!cp->val;
> > @@ -4557,7 +4599,7 @@ static int set_scan_params(struct sock *sk, struc=
t hci_dev *hdev,
> >               hci_req_init(&req, hdev);
> >
> >               hci_req_add_le_scan_disable(&req);
> > -             hci_req_add_le_passive_scan(&req);
> > +             hci_req_add_le_passive_scan(&req, false);
> >
> >               hci_req_run(&req, NULL);
> >       }
> > @@ -7453,6 +7495,14 @@ void mgmt_device_disconnected(struct hci_dev *hd=
ev, bdaddr_t *bdaddr,
> >
> >       mgmt_event(MGMT_EV_DEVICE_DISCONNECTED, hdev, &ev, sizeof(ev), sk=
);
> >
> > +     if (hdev->suspend.disconnect_counter > 0) {
> > +             hdev->suspend.disconnect_counter--;
> > +             if (hdev->suspend.disconnect_counter <=3D 0) {
> > +                     clear_bit(SUSPEND_DISCONNECTING, hdev->suspend.ta=
sks);
> > +                     wake_up(&hdev->suspend.tasks_wait_q);
> > +             }
> > +     }
> > +
> >       if (sk)
> >               sock_put(sk);
>
> I might be wrong, but from an initial review, I feel we need to make this=
 patch a lot simpler with regards to all its states. My proposal would be t=
o break it down into a set of smaller changes and then build it from there.

The pseudo-code for suspend is basically:
* Pause discovering
* Pause advertising
* Set up the LE whitelist
* Set up the BR/EDR whitelist
* Disconnect devices

I will break it up into two patches (one taking care of whitelisting
and the other taking care of discovery/advertising pausing) and reduce
some of the states being tracked (probably merging the pause/unpause
states).

>
> Regards
>
> Marcel
>

Thanks for the feedback,

Abhishek
