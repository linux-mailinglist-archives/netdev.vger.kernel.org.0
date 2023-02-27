Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8FFAE6A4FC2
	for <lists+netdev@lfdr.de>; Tue, 28 Feb 2023 00:41:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229871AbjB0Xlk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Feb 2023 18:41:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47670 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229471AbjB0Xlj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Feb 2023 18:41:39 -0500
Received: from mail-lj1-x22c.google.com (mail-lj1-x22c.google.com [IPv6:2a00:1450:4864:20::22c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A25472748C;
        Mon, 27 Feb 2023 15:41:37 -0800 (PST)
Received: by mail-lj1-x22c.google.com with SMTP id a4so5013041ljr.9;
        Mon, 27 Feb 2023 15:41:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=itKBYE4MkiytTzhEgtekR4ZojeGedgFj0rb7KU/Fqow=;
        b=P2n/IFuh10jAQaY8Ow9Y9G4G/3m/Ulbzo2DhUmmMK7ET/lFNaWal+XS++JCX6bc7bN
         OffG9ZcsYP+wRwYDBJkuAslUXNrOP5xrraAEN+KFfcbT+q0swxTsP09RS8EGJRVXYTZj
         H37+9QdR4cIIp9Y2GEwV0kSJJGJHJmEpjtr9bJmoXvQvGcgTKB/61ZQR2etzVfXuWjbF
         phtHaRsQIx3N/GGVTwOMXfiYOBD4K1vFg6qokLq+5CSGg2rNhqNAnE2gYf9rmof6fnIZ
         86HjxqI5WHe1B0dJwkQWssc5GxfSYQWqoeZP8GHwwiSt9TAQtw2voeHOf18KvTmHL1Ij
         0LAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=itKBYE4MkiytTzhEgtekR4ZojeGedgFj0rb7KU/Fqow=;
        b=KAnNb6a77lb+CyD0N3WDv1D+KbxBYByXed5XybrlUsVMSejFQbQ49lmlVEzbIluo1r
         IaPTboAO6IC6EJYx6nosUiO4d8ORsd7+qluCh2iHNVBIT+PIQcICTdNQCJX0S2o4MvWO
         7TKljZWQk1fr5gqFHx3hjtzuvs8POX6mN8cxl0NfYvYUji2HCvChfCB+Vm00uAdo2JpP
         tYxnw/z2SYAQ1oxaKfHp03rdXWlvAFI7t0ye7juyxqfOTfhUU6JX+A/6a3AXmHwXB3u3
         1HEMYgtDB3JO94UnxgaGX9EGY4AaMPPVV+WGQXQXxIdxp09vL4r8QQXmnMLQRbcxPSTX
         81xw==
X-Gm-Message-State: AO0yUKXRcJ632VZSxo3yyyPKM6mpZffzQOSbGG1+l/BJVVAWB0rrCIw9
        rNqEybYl2G/2/RK5FBwwJZ+Hf4owHOWcfRFRLew=
X-Google-Smtp-Source: AK7set8rhiTPmKb9IFzST9nmfq7KCZ10Ji4Ci6dUCUsOs9JoTB5o9jsK5qeYh8Hhic+9irB3lnyx3D4jvRIAAEMjNbU=
X-Received: by 2002:a2e:a4db:0:b0:28b:e4ac:fea0 with SMTP id
 p27-20020a2ea4db000000b0028be4acfea0mr146513ljm.9.1677541295865; Mon, 27 Feb
 2023 15:41:35 -0800 (PST)
MIME-Version: 1.0
References: <20230224195313.1877313-1-jiangzp@google.com> <20230224115310.kernel.v2.1.If0578b001c1f12567f2ebcac5856507f1adee745@changeid>
 <CABBYNZ+yVWssa09NB+ahp-N87sLXRqYF58-GJK-Vx8jn-Sa5Uw@mail.gmail.com>
 <CAB4PzUrO32Z1AF-3UJviYqTr3YvachGgJ7NiqkNW46ioWigtfw@mail.gmail.com> <CAB4PzUoErDkUzyj6sFQc_CSa7hibucX42yY+oVGw7C4DcJdQFA@mail.gmail.com>
In-Reply-To: <CAB4PzUoErDkUzyj6sFQc_CSa7hibucX42yY+oVGw7C4DcJdQFA@mail.gmail.com>
From:   Luiz Augusto von Dentz <luiz.dentz@gmail.com>
Date:   Mon, 27 Feb 2023 15:41:24 -0800
Message-ID: <CABBYNZL=u88Ro1dR8fYWpiS6E1sZ4E8TXg8BVU7nEGBodYhTrA@mail.gmail.com>
Subject: Re: [kernel PATCH v2 1/1] Bluetooth: hci_sync: clear workqueue before
 clear mgmt cmd
To:     Zhengping Jiang <jiangzp@google.com>
Cc:     linux-bluetooth@vger.kernel.org, marcel@holtmann.org,
        mmandlik@google.com, chromeos-bluetooth-upstreaming@chromium.org,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        Paolo Abeni <pabeni@redhat.com>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Zhengping,

On Sun, Feb 26, 2023 at 11:18=E2=80=AFPM Zhengping Jiang <jiangzp@google.co=
m> wrote:
>
> Hi Luiz,
>
> I have a question. Given that each command in the cmd_sync queue
> should clean up the memory in a callback function. I was wondering if
> the call to cmd_complete_rsp in __mgmt_power_off function is still
> necessary? Will this always risk a race condition that cmd has been
> released when the complete callback or _sync function is run?

Not sure I follow you here, do you have a stack trace when the user
after free occurs?

> Thanks,
> Zhengping
>
> On Fri, Feb 24, 2023 at 2:37=E2=80=AFPM Zhengping Jiang <jiangzp@google.c=
om> wrote:
> >
> > Hi Luiz,
> >
> > > Any particular reason why you are not using hci_cmd_sync_clear
> > > instead?
> >
> > That is a good question and we used hci_cmd_sync_clear in the first
> > version, but it will clear the queue and also close the timer. As a
> > result, when the adapter is turned on again, the timer will not
> > schedule any new jobs. So the option is to use hci_cmd_sync_clear and
> > re-initiate the queue or to write a new function which only clears the
> > queue.
> >
> > > We also may want to move the clearing logic to
> > > hci_dev_close_sync since it should be equivalent to
> > > hci_request_cancel_all.
> >
> > I actually have a question here. I saw
> > "drain_workqueue(hdev->workqueue)" in hci_dev_close_sync and thought
> > it should force clearing the cmd_sync queue. But it seems cannot
> > prevent the use-after-free situation.
> >
> > Any suggestions to improve the solution?
> >
> > Thanks,
> > Zhengping
> >
> >
> > On Fri, Feb 24, 2023 at 1:02 PM Luiz Augusto von Dentz
> > <luiz.dentz@gmail.com> wrote:
> > >
> > > Hi Zhengping,
> > >
> > > On Fri, Feb 24, 2023 at 11:53 AM Zhengping Jiang <jiangzp@google.com>=
 wrote:
> > > >
> > > > Clear cmd_sync_work queue before clearing the mgmt cmd list to avoi=
d
> > > > racing conditions which cause use-after-free.
> > > >
> > > > When powering off the adapter, the mgmt cmd list will be cleared. I=
f a
> > > > work is queued in the cmd_sync_work queue at the same time, it will
> > > > cause the risk of use-after-free, as the cmd pointer is not checked
> > > > before use.
> > > >
> > > > Signed-off-by: Zhengping Jiang <jiangzp@google.com>
> > > > ---
> > > >
> > > > Changes in v2:
> > > > - Add function to clear the queue without stop the timer
> > > >
> > > > Changes in v1:
> > > > - Clear cmd_sync_work queue before clearing the mgmt cmd list
> > > >
> > > >  net/bluetooth/hci_sync.c | 21 ++++++++++++++++++++-
> > > >  1 file changed, 20 insertions(+), 1 deletion(-)
> > > >
> > > > diff --git a/net/bluetooth/hci_sync.c b/net/bluetooth/hci_sync.c
> > > > index 117eedb6f709..b70365dfff0c 100644
> > > > --- a/net/bluetooth/hci_sync.c
> > > > +++ b/net/bluetooth/hci_sync.c
> > > > @@ -636,6 +636,23 @@ void hci_cmd_sync_init(struct hci_dev *hdev)
> > > >         INIT_DELAYED_WORK(&hdev->adv_instance_expire, adv_timeout_e=
xpire);
> > > >  }
> > > >
> > > > +static void hci_pend_cmd_sync_clear(struct hci_dev *hdev)
> > > > +{
> > > > +       struct hci_cmd_sync_work_entry *entry, *tmp;
> > > > +
> > > > +       mutex_lock(&hdev->cmd_sync_work_lock);
> > > > +       list_for_each_entry_safe(entry, tmp, &hdev->cmd_sync_work_l=
ist, list) {
> > > > +               if (entry->destroy) {
> > > > +                       hci_req_sync_lock(hdev);
> > > > +                       entry->destroy(hdev, entry->data, -ECANCELE=
D);
> > > > +                       hci_req_sync_unlock(hdev);
> > > > +               }
> > > > +               list_del(&entry->list);
> > > > +               kfree(entry);
> > > > +       }
> > > > +       mutex_unlock(&hdev->cmd_sync_work_lock);
> > > > +}
> > > > +
> > > >  void hci_cmd_sync_clear(struct hci_dev *hdev)
> > > >  {
> > > >         struct hci_cmd_sync_work_entry *entry, *tmp;
> > > > @@ -4842,8 +4859,10 @@ int hci_dev_close_sync(struct hci_dev *hdev)
> > > >
> > > >         if (!auto_off && hdev->dev_type =3D=3D HCI_PRIMARY &&
> > > >             !hci_dev_test_flag(hdev, HCI_USER_CHANNEL) &&
> > > > -           hci_dev_test_flag(hdev, HCI_MGMT))
> > > > +           hci_dev_test_flag(hdev, HCI_MGMT)) {
> > > > +               hci_pend_cmd_sync_clear(hdev);
> > >
> > > Any particular reason why you are not using hci_cmd_sync_clear
> > > instead? We also may want to move the clearing logic to
> > > hci_dev_close_sync since it should be equivalent to
> > > hci_request_cancel_all.
> > >
> > > >                 __mgmt_power_off(hdev);
> > > > +       }
> > > >
> > > >         hci_inquiry_cache_flush(hdev);
> > > >         hci_pend_le_actions_clear(hdev);
> > > > --
> > > > 2.39.2.722.g9855ee24e9-goog
> > > >
> > >
> > >
> > > --
> > > Luiz Augusto von Dentz



--=20
Luiz Augusto von Dentz
