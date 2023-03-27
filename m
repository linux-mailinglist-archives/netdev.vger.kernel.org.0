Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0826D6CAF1F
	for <lists+netdev@lfdr.de>; Mon, 27 Mar 2023 21:48:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230461AbjC0Tsz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Mar 2023 15:48:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43198 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229525AbjC0Tsy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Mar 2023 15:48:54 -0400
Received: from mail-lj1-x231.google.com (mail-lj1-x231.google.com [IPv6:2a00:1450:4864:20::231])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2935335B3;
        Mon, 27 Mar 2023 12:48:43 -0700 (PDT)
Received: by mail-lj1-x231.google.com with SMTP id h9so10268361ljq.2;
        Mon, 27 Mar 2023 12:48:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679946521;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=XcVM4CJRWxDPPXEqbhuPEZtCcbmEaUWm5GlqZ20MK+M=;
        b=EFREdTokB3aj0dK4dOgEQc284esTJ0cdFtvXHKT9EgROGQI0DBuEXqCn4Ryyqm28xB
         QBLwOcZS47E0W20uU8RmsrAQg2fsV6OzauwGaRoFyoo0pvIUakx2FRJEHcMQmgJ1v7Mo
         EjZs+/DrRyy3H+3a+toGAzEha/pCCOisXwZaoArJg/G6B/KA8bA4lFhPWntEaOhbLdzN
         DO+egjsTiVbaxLwUBmB1Py2Ut5yWnKXC0KI6wFY1BEfyfXgiMyfOSa1WtCcLAid4ppRi
         lJEmQ/azRW44jdpsS8rxUyhUssICxMrixUeStc0h8lIkrY/M+eqwS6soke578iVp8pPt
         7O3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679946521;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=XcVM4CJRWxDPPXEqbhuPEZtCcbmEaUWm5GlqZ20MK+M=;
        b=cS+iwt6pYbFRtas5iKZ0ks9MXIJBj/5JVaDSYEkzgaQbQidQiB9PMajW8S53Di3ohP
         MfrdxNlHecwgyM7N6k9F63A0zS6OM09JFyagvBFoCrQuwmDHodyQWGMnlvJC3bdpoecr
         Z2aKZFCslZT5dDki5+VEXnPjk9JkxUseJ/WK562/TNJF35YrnF6aJf20A6gdQoxXOpL6
         byYi3evflEnC5iAudsuzX0OMpBMgAtYIXp2w1zeyyJBIWQTVTE3vhhZUsEozBI/+Nzxm
         lZWwVPRlZ/5KVMrBU87JBggXo/LQrwrYaCFkJ96zdSs8h0UDx9m51TWZVywtHKne8MbL
         rzLw==
X-Gm-Message-State: AAQBX9dsM7G6DvJXLr/1+P568M4YHT03tfbOiB16pxRI3UNte/apVOrT
        dPUYGALO23xV03I2vRJhXCrmCeTEnX0Q+3bRQio=
X-Google-Smtp-Source: AKy350b+4HwYHTQhmbZlgOYaL5Wjx/F90GsBFY0Kkzs/r54XyyAOTXcFBS75CODDOVDmbOMgq9su8SNa042E7nem1Lk=
X-Received: by 2002:a2e:a175:0:b0:2a0:5b04:5fe8 with SMTP id
 u21-20020a2ea175000000b002a05b045fe8mr4019265ljl.0.1679946521108; Mon, 27 Mar
 2023 12:48:41 -0700 (PDT)
MIME-Version: 1.0
References: <20230323140942.v8.1.I9b4e4818bab450657b19cda3497d363c9baa616e@changeid>
 <ZCBpBs3i4+RCv5SI@corigine.com>
In-Reply-To: <ZCBpBs3i4+RCv5SI@corigine.com>
From:   Luiz Augusto von Dentz <luiz.dentz@gmail.com>
Date:   Mon, 27 Mar 2023 12:48:29 -0700
Message-ID: <CABBYNZ+Hjr=Feu2c-Vf1dfH1TKEu_6TnPTzmcLNjJWTF61MBAg@mail.gmail.com>
Subject: Re: [PATCH v8 1/4] Bluetooth: Add support for hci devcoredump
To:     Simon Horman <simon.horman@corigine.com>
Cc:     Manish Mandlik <mmandlik@google.com>, marcel@holtmann.org,
        linux-bluetooth@vger.kernel.org,
        chromeos-bluetooth-upstreaming@chromium.org,
        Abhishek Pandit-Subedi <abhishekpandit@chromium.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        Paolo Abeni <pabeni@redhat.com>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Manish, Simon,

On Sun, Mar 26, 2023 at 8:47=E2=80=AFAM Simon Horman <simon.horman@corigine=
.com> wrote:
>
> On Thu, Mar 23, 2023 at 02:10:15PM -0700, Manish Mandlik wrote:
> > From: Abhishek Pandit-Subedi <abhishekpandit@chromium.org>
> >
> > Add devcoredump APIs to hci core so that drivers only have to provide
> > the dump skbs instead of managing the synchronization and timeouts.
> >
> > The devcoredump APIs should be used in the following manner:
> >  - hci_devcoredump_init is called to allocate the dump.
> >  - hci_devcoredump_append is called to append any skbs with dump data
> >    OR hci_devcoredump_append_pattern is called to insert a pattern.
> >  - hci_devcoredump_complete is called when all dump packets have been
> >    sent OR hci_devcoredump_abort is called to indicate an error and
> >    cancel an ongoing dump collection.
> >
> > The high level APIs just prepare some skbs with the appropriate data an=
d
> > queue it for the dump to process. Packets part of the crashdump can be
> > intercepted in the driver in interrupt context and forwarded directly t=
o
> > the devcoredump APIs.
> >
> > Internally, there are 5 states for the dump: idle, active, complete,
> > abort and timeout. A devcoredump will only be in active state after it
> > has been initialized. Once active, it accepts data to be appended,
> > patterns to be inserted (i.e. memset) and a completion event or an abor=
t
> > event to generate a devcoredump. The timeout is initialized at the same
> > time the dump is initialized (defaulting to 10s) and will be cleared
> > either when the timeout occurs or the dump is complete or aborted.
> >
> > Signed-off-by: Abhishek Pandit-Subedi <abhishekpandit@chromium.org>
> > Signed-off-by: Manish Mandlik <mmandlik@google.com>
> > Reviewed-by: Abhishek Pandit-Subedi <abhishekpandit@chromium.org>
>
> ...
>
> > +static int hci_devcoredump_update_hdr_state(char *buf, size_t size, in=
t state)
> > +{
> > +     int len =3D 0;
> > +
> > +     if (!buf)
> > +             return 0;
> > +
> > +     len =3D snprintf(buf, size, "Bluetooth devcoredump\nState: %d\n",=
 state);
>
> The snprintf documentation says:
>
>  * The return value is the number of characters which would be
>  * generated for the given input, excluding the trailing null,
>  * as per ISO C99.  If the return is greater than or equal to
>  * @size, the resulting string is truncated.
>
> While the scnprintf documentation says:
>
>  * The return value is the number of characters written into @buf not inc=
luding
>  * the trailing '\0'. If @size is =3D=3D 0 the function returns 0.
>
> As the return value us used to determine how many bytes to put to
> an skb, you might want scnprintf(), or a check on the value of len here.

+1

> > +
> > +     return len + 1; /* snprintf adds \0 at the end upon state rewrite=
 */
> > +}
> > +
> > +/* Call with hci_dev_lock only. */
> > +static int hci_devcoredump_update_state(struct hci_dev *hdev, int stat=
e)
> > +{
> > +     hdev->dump.state =3D state;
> > +
> > +     return hci_devcoredump_update_hdr_state(hdev->dump.head,
> > +                                             hdev->dump.alloc_size, st=
ate);
> > +}
>
> ...
>
> > +/* Call with hci_dev_lock only. */
> > +static int hci_devcoredump_prepare(struct hci_dev *hdev, u32 dump_size=
)
> > +{
> > +     struct sk_buff *skb =3D NULL;
> > +     int dump_hdr_size;
> > +     int err =3D 0;
> > +
> > +     skb =3D alloc_skb(MAX_DEVCOREDUMP_HDR_SIZE, GFP_ATOMIC);
> > +     if (!skb) {
> > +             bt_dev_err(hdev, "Failed to allocate devcoredump prepare"=
);
>
> I don't think memory allocation errors need to be logged like this,
> as they are already logged by the core.
>
> Please run checkpatch, which flags this.

+1, looks like the CI was already causing warnings about these.

> > +             return -ENOMEM;
> > +     }
> > +
> > +     dump_hdr_size =3D hci_devcoredump_mkheader(hdev, skb);
> > +
> > +     if (hci_devcoredump_alloc(hdev, dump_hdr_size + dump_size)) {
> > +             err =3D -ENOMEM;
> > +             goto hdr_free;
> > +     }
> > +
> > +     /* Insert the device header */
> > +     if (!hci_devcoredump_copy(hdev, skb->data, skb->len)) {
> > +             bt_dev_err(hdev, "Failed to insert header");
> > +             hci_devcoredump_free(hdev);
> > +
> > +             err =3D -ENOMEM;
> > +             goto hdr_free;
> > +     }
> > +
> > +hdr_free:
> > +     if (skb)
>
> It seems that this condition is always true.
> And in any case, kfree_skb can handle a NULL argument.

+1

> > +             kfree_skb(skb);
> > +
> > +     return err;
> > +}
>
> ...
>
> > +void hci_devcoredump_rx(struct work_struct *work)
> > +{
> > +     struct hci_dev *hdev =3D container_of(work, struct hci_dev, dump.=
dump_rx);
> > +     struct sk_buff *skb;
> > +     struct hci_devcoredump_skb_pattern *pattern;
> > +     u32 dump_size;
> > +     int start_state;
> > +
> > +#define DBG_UNEXPECTED_STATE() \
> > +             bt_dev_dbg(hdev, \
> > +                        "Unexpected packet (%d) for state (%d). ", \
> > +                        hci_dmp_cb(skb)->pkt_type, hdev->dump.state)
>
> nit: indentation seems excessive in above 3 lines.
>
> > +
> > +     while ((skb =3D skb_dequeue(&hdev->dump.dump_q))) {
> > +             hci_dev_lock(hdev);
> > +             start_state =3D hdev->dump.state;
> > +
> > +             switch (hci_dmp_cb(skb)->pkt_type) {
> > +             case HCI_DEVCOREDUMP_PKT_INIT:
> > +                     if (hdev->dump.state !=3D HCI_DEVCOREDUMP_IDLE) {
> > +                             DBG_UNEXPECTED_STATE();
> > +                             goto loop_continue;
>
> I'm probably missing something terribly obvious.
> But can the need for the loop_continue label be avoided by using 'break;'=
 ?

Yeah, in fact I think Id use dedicated functions for each state.

> > +                     }
> > +
> > +                     if (skb->len !=3D sizeof(dump_size)) {
> > +                             bt_dev_dbg(hdev, "Invalid dump init pkt")=
;
> > +                             goto loop_continue;
> > +                     }
> > +
> > +                     dump_size =3D *((u32 *)skb->data);
> > +                     if (!dump_size) {
> > +                             bt_dev_err(hdev, "Zero size dump init pkt=
");
> > +                             goto loop_continue;
> > +                     }

I'd replace the code above with skb_pull_data, we could perhaps start
adding something like skb_pull_u32 to make it simpler though.

> > +                     if (hci_devcoredump_prepare(hdev, dump_size)) {
> > +                             bt_dev_err(hdev, "Failed to prepare for d=
ump");
> > +                             goto loop_continue;
> > +                     }
> > +
> > +                     hci_devcoredump_update_state(hdev,
> > +                                                  HCI_DEVCOREDUMP_ACTI=
VE);
> > +                     queue_delayed_work(hdev->workqueue,
> > +                                        &hdev->dump.dump_timeout,
> > +                                        DEVCOREDUMP_TIMEOUT);
> > +                     break;
> > +
> > +             case HCI_DEVCOREDUMP_PKT_SKB:
> > +                     if (hdev->dump.state !=3D HCI_DEVCOREDUMP_ACTIVE)=
 {
> > +                             DBG_UNEXPECTED_STATE();
> > +                             goto loop_continue;
> > +                     }
> > +
> > +                     if (!hci_devcoredump_copy(hdev, skb->data, skb->l=
en))
> > +                             bt_dev_dbg(hdev, "Failed to insert skb");
> > +                     break;
> > +
> > +             case HCI_DEVCOREDUMP_PKT_PATTERN:
> > +                     if (hdev->dump.state !=3D HCI_DEVCOREDUMP_ACTIVE)=
 {
> > +                             DBG_UNEXPECTED_STATE();
> > +                             goto loop_continue;
> > +                     }
> > +
> > +                     if (skb->len !=3D sizeof(*pattern)) {
> > +                             bt_dev_dbg(hdev, "Invalid pattern skb");
> > +                             goto loop_continue;
> > +                     }
> > +
> > +                     pattern =3D (void *)skb->data;
> > +
> > +                     if (!hci_devcoredump_memset(hdev, pattern->patter=
n,
> > +                                                 pattern->len))
> > +                             bt_dev_dbg(hdev, "Failed to set pattern")=
;
> > +                     break;
> > +
> > +             case HCI_DEVCOREDUMP_PKT_COMPLETE:
> > +                     if (hdev->dump.state !=3D HCI_DEVCOREDUMP_ACTIVE)=
 {
> > +                             DBG_UNEXPECTED_STATE();
> > +                             goto loop_continue;
> > +                     }
> > +
> > +                     hci_devcoredump_update_state(hdev,
> > +                                                  HCI_DEVCOREDUMP_DONE=
);
> > +                     dump_size =3D hdev->dump.tail - hdev->dump.head;
> > +
> > +                     bt_dev_info(hdev,
> > +                                 "Devcoredump complete with size %u "
> > +                                 "(expect %zu)",
>
> I think it is best practice not to split quoted strings across multiple l=
ines.
> Although it leads to long lines (which is undesirable)
> keeping the string on one line aids searching the code (with grep).
>
> checkpatch warns about this.

Well this should be an info to begin with and I'd probably add a
bt_dev_dbg at the beginning printing like "%s -> %s", old_state,
new_state, which makes things a lot simpler.

> > +                                 dump_size, hdev->dump.alloc_size);
> > +
> > +                     dev_coredumpv(&hdev->dev, hdev->dump.head, dump_s=
ize,
> > +                                   GFP_KERNEL);
> > +                     break;
> > +
> > +             case HCI_DEVCOREDUMP_PKT_ABORT:
> > +                     if (hdev->dump.state !=3D HCI_DEVCOREDUMP_ACTIVE)=
 {
> > +                             DBG_UNEXPECTED_STATE();
> > +                             goto loop_continue;
> > +                     }
> > +
> > +                     hci_devcoredump_update_state(hdev,
> > +                                                  HCI_DEVCOREDUMP_ABOR=
T);
> > +                     dump_size =3D hdev->dump.tail - hdev->dump.head;
> > +
> > +                     bt_dev_info(hdev,
> > +                                 "Devcoredump aborted with size %u "
> > +                                 "(expect %zu)",
> > +                                 dump_size, hdev->dump.alloc_size);

Ditto, lets log the old state and new state using bt_dev_dbg.

> > +                     /* Emit a devcoredump with the available data */
> > +                     dev_coredumpv(&hdev->dev, hdev->dump.head, dump_s=
ize,
> > +                                   GFP_KERNEL);
> > +                     break;
> > +
> > +             default:
> > +                     bt_dev_dbg(hdev,
> > +                                "Unknown packet (%d) for state (%d). "=
,
> > +                                hci_dmp_cb(skb)->pkt_type, hdev->dump.=
state);
> > +                     break;
> > +             }
> > +
> > +loop_continue:
> > +             kfree_skb(skb);
> > +             hci_dev_unlock(hdev);
> > +
> > +             if (start_state !=3D hdev->dump.state)
> > +                     hci_devcoredump_notify(hdev, hdev->dump.state);
> > +
> > +             hci_dev_lock(hdev);
> > +             if (hdev->dump.state =3D=3D HCI_DEVCOREDUMP_DONE ||
> > +                 hdev->dump.state =3D=3D HCI_DEVCOREDUMP_ABORT)
> > +                     hci_devcoredump_reset(hdev);
> > +             hci_dev_unlock(hdev);

Don't think this is much better than calling hci_devcoredump_reset at
the respective state handler instead since you had to lock again, or
is this because hci_devcoredump_notifty? I'd probably document if that
is the case, otherwise I'd move it to be called by
hci_devcoredump_update_state.

> > +     }
> > +}
> > +EXPORT_SYMBOL(hci_devcoredump_rx);
>
> ...
>
> > +static inline bool hci_devcoredump_enabled(struct hci_dev *hdev)
> > +{
> > +     return hdev->dump.supported;
> > +}
> > +
> > +int hci_devcoredump_init(struct hci_dev *hdev, u32 dmp_size)
> > +{
> > +     struct sk_buff *skb =3D NULL;
>
> nit: I don't think it is necessary to initialise skb here.
>      Likewise elsewhere in this patch.
>
> > +
> > +     if (!hci_devcoredump_enabled(hdev))
> > +             return -EOPNOTSUPP;
> > +
> > +     skb =3D alloc_skb(sizeof(dmp_size), GFP_ATOMIC);
> > +     if (!skb) {
> > +             bt_dev_err(hdev, "Failed to allocate devcoredump init");
> > +             return -ENOMEM;
> > +     }
> > +
> > +     hci_dmp_cb(skb)->pkt_type =3D HCI_DEVCOREDUMP_PKT_INIT;
> > +     skb_put_data(skb, &dmp_size, sizeof(dmp_size));
> > +
> > +     skb_queue_tail(&hdev->dump.dump_q, skb);
> > +     queue_work(hdev->workqueue, &hdev->dump.dump_rx);
> > +
> > +     return 0;
> > +}
> > +EXPORT_SYMBOL(hci_devcoredump_init);

Since it looks like we are going to need another round, could you
please use hci_devcd_ as prefix instead?


--=20
Luiz Augusto von Dentz
