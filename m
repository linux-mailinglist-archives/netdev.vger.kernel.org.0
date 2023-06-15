Return-Path: <netdev+bounces-10966-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D4399730DC3
	for <lists+netdev@lfdr.de>; Thu, 15 Jun 2023 05:53:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C13C61C20DDC
	for <lists+netdev@lfdr.de>; Thu, 15 Jun 2023 03:53:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5CFE0634;
	Thu, 15 Jun 2023 03:53:37 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A247625
	for <netdev@vger.kernel.org>; Thu, 15 Jun 2023 03:53:37 +0000 (UTC)
Received: from mail-lj1-x22c.google.com (mail-lj1-x22c.google.com [IPv6:2a00:1450:4864:20::22c])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BDE122727
	for <netdev@vger.kernel.org>; Wed, 14 Jun 2023 20:53:07 -0700 (PDT)
Received: by mail-lj1-x22c.google.com with SMTP id 38308e7fff4ca-2b1fe3a1a73so20608731fa.1
        for <netdev@vger.kernel.org>; Wed, 14 Jun 2023 20:53:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1686801186; x=1689393186;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=qGLdRdR9ZHrW8HzfM8CwOmBCpAW87Mhy86bzNglLUuA=;
        b=ZunAurm1vbRWrNQ+3r/YKzqIoGXs/1TtA3NKVcnv6g1CJwqfvUImaq+nSbOjDqUYt0
         B73YWEqtxqQ28s+7uBXo4uo2/To4KaNCXpJlWGWfy0gR2yTjkboe4EEpgfj8seZMnoYM
         6iKVyk7sH0qpD/P+fJXViJYhy05oBAMlQTP6E=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686801186; x=1689393186;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=qGLdRdR9ZHrW8HzfM8CwOmBCpAW87Mhy86bzNglLUuA=;
        b=MQJGEIRM0mUDPP6GF4WfkNsLeFdiy6Y3cXNuL8CIad/2pMc5G5PZATIOrb1E1haAth
         7HWiCLJTN48xCLcp3scWZM7kEB1lINX6IiIBl0dwMLfckOMP3Vujx1t1ozjRx0AcA7LK
         Us+derKkyh/dGjSJXlwHtNok4erW9yPN0EB40BP6SC4LSJsp72CiqZLuEdlSm1a+D9/8
         c1QZl24PXa/TTSMQWlLZ/mO0cpeTVwoQ1VsdjClvbpUW1OMSy3MQKPP/6HDtWf377t8E
         +pBnkesEZ60tO6lkAHDe2+XKG8xhl9Fah9hrobxpNEHLUo/stJGcvHuk3emZukameLXt
         0GUQ==
X-Gm-Message-State: AC+VfDxmA7AJs3Hj9JD2t4J0KU/R/KMJe6Yv6fHYtgmlqX4OYV2A087E
	jWykPBG0Ysz0G9GS0qosLBlfFm4tIBAIiWNE0EkpYA==
X-Google-Smtp-Source: ACHHUZ7HYEcouOVqPuw6vv7GyLB+9T7vWJYaL4E/T8eM1uZa/Bdsf8hf23TEtLjfFRE8UDULebfivNPHrj+Y0M3D1ks=
X-Received: by 2002:a2e:b0d3:0:b0:2b1:bfbb:9f1f with SMTP id
 g19-20020a2eb0d3000000b002b1bfbb9f1fmr6910980ljl.50.1686801185688; Wed, 14
 Jun 2023 20:53:05 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20230614234129.3264175-1-anjali.k.kulkarni@oracle.com> <20230614234129.3264175-4-anjali.k.kulkarni@oracle.com>
In-Reply-To: <20230614234129.3264175-4-anjali.k.kulkarni@oracle.com>
From: Kalesh Anakkur Purayil <kalesh-anakkur.purayil@broadcom.com>
Date: Thu, 15 Jun 2023 09:22:54 +0530
Message-ID: <CAH-L+nMHCKZiCmYM66CRJVBSck1-U5=iRWjYTj=fEx0KZi1nTg@mail.gmail.com>
Subject: Re: [PATCH v6 3/6] connector/cn_proc: Add filtering to fix some bugs
To: Anjali Kulkarni <anjali.k.kulkarni@oracle.com>
Cc: davem@davemloft.net, david@fries.net, edumazet@google.com, kuba@kernel.org, 
	pabeni@redhat.com, zbr@ioremap.net, brauner@kernel.org, 
	johannes@sipsolutions.net, ecree.xilinx@gmail.com, leon@kernel.org, 
	keescook@chromium.org, socketcan@hartkopp.net, petrm@nvidia.com, 
	linux-kernel@vger.kernel.org, netdev@vger.kernel.org, Liam.Howlett@oracle.com, 
	akpm@linux-foundation.org
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
	boundary="000000000000830b1d05fe2301cc"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,HTML_MESSAGE,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

--000000000000830b1d05fe2301cc
Content-Type: multipart/alternative; boundary="0000000000007b45cc05fe2301cc"

--0000000000007b45cc05fe2301cc
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Jun 15, 2023 at 5:12=E2=80=AFAM Anjali Kulkarni <
anjali.k.kulkarni@oracle.com> wrote:

> The current proc connector code has the foll. bugs - if there are more
> than one listeners for the proc connector messages, and one of them
> deregisters for listening using PROC_CN_MCAST_IGNORE, they will still get
> all proc connector messages, as long as there is another listener.
>
> Another issue is if one client calls PROC_CN_MCAST_LISTEN, and another on=
e
> calls PROC_CN_MCAST_IGNORE, then both will end up not getting any message=
s.
>
> This patch adds filtering and drops packet if client has sent
> PROC_CN_MCAST_IGNORE. This data is stored in the client socket's
> sk_user_data. In addition, we only increment or decrement
> proc_event_num_listeners once per client. This fixes the above issues.
>
> cn_release is the release function added for NETLINK_CONNECTOR. It uses
> the newly added netlink_release function added to netlink_sock. It will
> free sk_user_data.
>
> Signed-off-by: Anjali Kulkarni <anjali.k.kulkarni@oracle.com>
> ---
>  drivers/connector/cn_proc.c   | 53 ++++++++++++++++++++++++++++-------
>  drivers/connector/connector.c | 21 +++++++++++---
>  drivers/w1/w1_netlink.c       |  6 ++--
>  include/linux/connector.h     |  8 +++++-
>  include/uapi/linux/cn_proc.h  | 43 ++++++++++++++++------------
>  5 files changed, 96 insertions(+), 35 deletions(-)
>
> diff --git a/drivers/connector/cn_proc.c b/drivers/connector/cn_proc.c
> index ccac1c453080..84f38d2bd4b9 100644
> --- a/drivers/connector/cn_proc.c
> +++ b/drivers/connector/cn_proc.c
> @@ -48,6 +48,21 @@ static DEFINE_PER_CPU(struct local_event, local_event)
> =3D {
>         .lock =3D INIT_LOCAL_LOCK(lock),
>  };
>
> +static int cn_filter(struct sock *dsk, struct sk_buff *skb, void *data)
> +{
> +       enum proc_cn_mcast_op mc_op;
> +
> +       if (!dsk)
> +               return 0;
> +
> +       mc_op =3D ((struct proc_input *)(dsk->sk_user_data))->mcast_op;
> +
> +       if (mc_op =3D=3D PROC_CN_MCAST_IGNORE)
> +               return 1;
> +
> +       return 0;
> +}
> +
>  static inline void send_msg(struct cn_msg *msg)
>  {
>         local_lock(&local_event.lock);
> @@ -61,7 +76,8 @@ static inline void send_msg(struct cn_msg *msg)
>          *
>          * If cn_netlink_send() fails, the data is not sent.
>          */
> -       cn_netlink_send(msg, 0, CN_IDX_PROC, GFP_NOWAIT);
> +       cn_netlink_send_mult(msg, msg->len, 0, CN_IDX_PROC, GFP_NOWAIT,
> +                            cn_filter, NULL);
>
>         local_unlock(&local_event.lock);
>  }
> @@ -346,11 +362,9 @@ static void cn_proc_ack(int err, int rcvd_seq, int
> rcvd_ack)
>  static void cn_proc_mcast_ctl(struct cn_msg *msg,
>                               struct netlink_skb_parms *nsp)
>  {
> -       enum proc_cn_mcast_op *mc_op =3D NULL;
> -       int err =3D 0;
> -
> -       if (msg->len !=3D sizeof(*mc_op))
> -               return;
> +       enum proc_cn_mcast_op mc_op =3D 0, prev_mc_op =3D 0;
> +       int err =3D 0, initial =3D 0;
> +       struct sock *sk =3D NULL;
>
[Kalesh] Maintain reverse Xmas tree order.

>
>         /*
>          * Events are reported with respect to the initial pid
> @@ -367,13 +381,32 @@ static void cn_proc_mcast_ctl(struct cn_msg *msg,
>                 goto out;
>         }
>
> -       mc_op =3D (enum proc_cn_mcast_op *)msg->data;
> -       switch (*mc_op) {
> +       if (msg->len =3D=3D sizeof(mc_op))
> +               mc_op =3D *((enum proc_cn_mcast_op *)msg->data);
> +       else
> +               return;
> +
> +       if (nsp->sk) {
> +               sk =3D nsp->sk;
> +               if (sk->sk_user_data =3D=3D NULL) {
> +                       sk->sk_user_data =3D kzalloc(sizeof(struct
> proc_input),
> +                                                  GFP_KERNEL);
>
[Kalesh] you need a check for memory allocation failure here.

> +                       initial =3D 1;
> +               } else {
> +                       prev_mc_op =3D
> +                       ((struct proc_input
> *)(sk->sk_user_data))->mcast_op;
> +               }
> +               ((struct proc_input *)(sk->sk_user_data))->mcast_op =3D
> mc_op;
> +       }
> +
> +       switch (mc_op) {
>         case PROC_CN_MCAST_LISTEN:
> -               atomic_inc(&proc_event_num_listeners);
> +               if (initial || (prev_mc_op !=3D PROC_CN_MCAST_LISTEN))
> +                       atomic_inc(&proc_event_num_listeners);
>                 break;
>         case PROC_CN_MCAST_IGNORE:
> -               atomic_dec(&proc_event_num_listeners);
> +               if (!initial && (prev_mc_op !=3D PROC_CN_MCAST_IGNORE))
> +                       atomic_dec(&proc_event_num_listeners);
>                 break;
>         default:
>                 err =3D EINVAL;
> diff --git a/drivers/connector/connector.c b/drivers/connector/connector.=
c
> index 48ec7ce6ecac..d1179df2b0ba 100644
> --- a/drivers/connector/connector.c
> +++ b/drivers/connector/connector.c
> @@ -59,7 +59,9 @@ static int cn_already_initialized;
>   * both, or if both are zero then the group is looked up and sent there.
>   */
>  int cn_netlink_send_mult(struct cn_msg *msg, u16 len, u32 portid, u32
> __group,
> -       gfp_t gfp_mask)
> +       gfp_t gfp_mask,
> +       int (*filter)(struct sock *dsk, struct sk_buff *skb, void *data),
> +       void *filter_data)
>  {
>         struct cn_callback_entry *__cbq;
>         unsigned int size;
> @@ -110,8 +112,9 @@ int cn_netlink_send_mult(struct cn_msg *msg, u16 len,
> u32 portid, u32 __group,
>         NETLINK_CB(skb).dst_group =3D group;
>
>         if (group)
> -               return netlink_broadcast(dev->nls, skb, portid, group,
> -                                        gfp_mask);
> +               return netlink_broadcast_filtered(dev->nls, skb, portid,
> group,
> +                                                 gfp_mask, filter,
> +                                                 (void *)filter_data);
>         return netlink_unicast(dev->nls, skb, portid,
>                         !gfpflags_allow_blocking(gfp_mask));
>  }
> @@ -121,7 +124,8 @@ EXPORT_SYMBOL_GPL(cn_netlink_send_mult);
>  int cn_netlink_send(struct cn_msg *msg, u32 portid, u32 __group,
>         gfp_t gfp_mask)
>  {
> -       return cn_netlink_send_mult(msg, msg->len, portid, __group,
> gfp_mask);
> +       return cn_netlink_send_mult(msg, msg->len, portid, __group,
> gfp_mask,
> +                                   NULL, NULL);
>  }
>  EXPORT_SYMBOL_GPL(cn_netlink_send);
>
> @@ -162,6 +166,14 @@ static int cn_call_callback(struct sk_buff *skb)
>         return err;
>  }
>
> +static void cn_release(struct sock *sk, unsigned long *groups)
> +{
> +       if (groups && test_bit(CN_IDX_PROC - 1, groups)) {
> +               kfree(sk->sk_user_data);
> +               sk->sk_user_data =3D NULL;
> +       }
> +}
> +
>  /*
>   * Main netlink receiving function.
>   *
> @@ -249,6 +261,7 @@ static int cn_init(void)
>         struct netlink_kernel_cfg cfg =3D {
>                 .groups =3D CN_NETLINK_USERS + 0xf,
>                 .input  =3D cn_rx_skb,
> +               .release =3D cn_release,
>         };
>
>         dev->nls =3D netlink_kernel_create(&init_net, NETLINK_CONNECTOR,
> &cfg);
> diff --git a/drivers/w1/w1_netlink.c b/drivers/w1/w1_netlink.c
> index db110cc442b1..691978cddab7 100644
> --- a/drivers/w1/w1_netlink.c
> +++ b/drivers/w1/w1_netlink.c
> @@ -65,7 +65,8 @@ static void w1_unref_block(struct w1_cb_block *block)
>                 u16 len =3D w1_reply_len(block);
>                 if (len) {
>                         cn_netlink_send_mult(block->first_cn, len,
> -                               block->portid, 0, GFP_KERNEL);
> +                                            block->portid, 0,
> +                                            GFP_KERNEL, NULL, NULL);
>                 }
>                 kfree(block);
>         }
> @@ -83,7 +84,8 @@ static void w1_reply_make_space(struct w1_cb_block
> *block, u16 space)
>  {
>         u16 len =3D w1_reply_len(block);
>         if (len + space >=3D block->maxlen) {
> -               cn_netlink_send_mult(block->first_cn, len, block->portid,
> 0, GFP_KERNEL);
> +               cn_netlink_send_mult(block->first_cn, len, block->portid,
> +                                    0, GFP_KERNEL, NULL, NULL);
>                 block->first_cn->len =3D 0;
>                 block->cn =3D NULL;
>                 block->msg =3D NULL;
> diff --git a/include/linux/connector.h b/include/linux/connector.h
> index 487350bb19c3..cec2d99ae902 100644
> --- a/include/linux/connector.h
> +++ b/include/linux/connector.h
> @@ -90,13 +90,19 @@ void cn_del_callback(const struct cb_id *id);
>   *             If @group is not zero, then message will be delivered
>   *             to the specified group.
>   * @gfp_mask:  GFP mask.
> + * @filter:     Filter function to be used at netlink layer.
> + * @filter_data:Filter data to be supplied to the filter function
>   *
>   * It can be safely called from softirq context, but may silently
>   * fail under strong memory pressure.
>   *
>   * If there are no listeners for given group %-ESRCH can be returned.
>   */
> -int cn_netlink_send_mult(struct cn_msg *msg, u16 len, u32 portid, u32
> group, gfp_t gfp_mask);
> +int cn_netlink_send_mult(struct cn_msg *msg, u16 len, u32 portid,
> +                        u32 group, gfp_t gfp_mask,
> +                        int (*filter)(struct sock *dsk, struct sk_buff
> *skb,
> +                                      void *data),
> +                        void *filter_data);
>
>  /**
>   * cn_netlink_send - Sends message to the specified groups.
> diff --git a/include/uapi/linux/cn_proc.h b/include/uapi/linux/cn_proc.h
> index db210625cee8..6a06fb424313 100644
> --- a/include/uapi/linux/cn_proc.h
> +++ b/include/uapi/linux/cn_proc.h
> @@ -30,6 +30,30 @@ enum proc_cn_mcast_op {
>         PROC_CN_MCAST_IGNORE =3D 2
>  };
>
> +enum proc_cn_event {
> +       /* Use successive bits so the enums can be used to record
> +        * sets of events as well
> +        */
> +       PROC_EVENT_NONE =3D 0x00000000,
> +       PROC_EVENT_FORK =3D 0x00000001,
> +       PROC_EVENT_EXEC =3D 0x00000002,
> +       PROC_EVENT_UID  =3D 0x00000004,
> +       PROC_EVENT_GID  =3D 0x00000040,
> +       PROC_EVENT_SID  =3D 0x00000080,
> +       PROC_EVENT_PTRACE =3D 0x00000100,
> +       PROC_EVENT_COMM =3D 0x00000200,
> +       /* "next" should be 0x00000400 */
> +       /* "last" is the last process event: exit,
> +        * while "next to last" is coredumping event
> +        */
> +       PROC_EVENT_COREDUMP =3D 0x40000000,
> +       PROC_EVENT_EXIT =3D 0x80000000
> +};
> +
> +struct proc_input {
> +       enum proc_cn_mcast_op mcast_op;
> +};
> +
>  /*
>   * From the user's point of view, the process
>   * ID is the thread group ID and thread ID is the internal
> @@ -44,24 +68,7 @@ enum proc_cn_mcast_op {
>   */
>
>  struct proc_event {
> -       enum what {
> -               /* Use successive bits so the enums can be used to record
> -                * sets of events as well
> -                */
> -               PROC_EVENT_NONE =3D 0x00000000,
> -               PROC_EVENT_FORK =3D 0x00000001,
> -               PROC_EVENT_EXEC =3D 0x00000002,
> -               PROC_EVENT_UID  =3D 0x00000004,
> -               PROC_EVENT_GID  =3D 0x00000040,
> -               PROC_EVENT_SID  =3D 0x00000080,
> -               PROC_EVENT_PTRACE =3D 0x00000100,
> -               PROC_EVENT_COMM =3D 0x00000200,
> -               /* "next" should be 0x00000400 */
> -               /* "last" is the last process event: exit,
> -                * while "next to last" is coredumping event */
> -               PROC_EVENT_COREDUMP =3D 0x40000000,
> -               PROC_EVENT_EXIT =3D 0x80000000
> -       } what;
> +       enum proc_cn_event what;
>         __u32 cpu;
>         __u64 __attribute__((aligned(8))) timestamp_ns;
>                 /* Number of nano seconds since system boot */
> --
> 2.41.0
>
>
>

--=20
Regards,
Kalesh A P

--0000000000007b45cc05fe2301cc
Content-Type: text/html; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><div dir=3D"ltr"><br></div><br><div class=3D"gmail_quote">=
<div dir=3D"ltr" class=3D"gmail_attr">On Thu, Jun 15, 2023 at 5:12=E2=80=AF=
AM Anjali Kulkarni &lt;<a href=3D"mailto:anjali.k.kulkarni@oracle.com">anja=
li.k.kulkarni@oracle.com</a>&gt; wrote:<br></div><blockquote class=3D"gmail=
_quote" style=3D"margin:0px 0px 0px 0.8ex;border-left:1px solid rgb(204,204=
,204);padding-left:1ex">The current proc connector code has the foll. bugs =
- if there are more<br>
than one listeners for the proc connector messages, and one of them<br>
deregisters for listening using PROC_CN_MCAST_IGNORE, they will still get<b=
r>
all proc connector messages, as long as there is another listener.<br>
<br>
Another issue is if one client calls PROC_CN_MCAST_LISTEN, and another one<=
br>
calls PROC_CN_MCAST_IGNORE, then both will end up not getting any messages.=
<br>
<br>
This patch adds filtering and drops packet if client has sent<br>
PROC_CN_MCAST_IGNORE. This data is stored in the client socket&#39;s<br>
sk_user_data. In addition, we only increment or decrement<br>
proc_event_num_listeners once per client. This fixes the above issues.<br>
<br>
cn_release is the release function added for NETLINK_CONNECTOR. It uses<br>
the newly added netlink_release function added to netlink_sock. It will<br>
free sk_user_data.<br>
<br>
Signed-off-by: Anjali Kulkarni &lt;<a href=3D"mailto:anjali.k.kulkarni@orac=
le.com" target=3D"_blank">anjali.k.kulkarni@oracle.com</a>&gt;<br>
---<br>
=C2=A0drivers/connector/cn_proc.c=C2=A0 =C2=A0| 53 ++++++++++++++++++++++++=
++++-------<br>
=C2=A0drivers/connector/connector.c | 21 +++++++++++---<br>
=C2=A0drivers/w1/w1_netlink.c=C2=A0 =C2=A0 =C2=A0 =C2=A0|=C2=A0 6 ++--<br>
=C2=A0include/linux/connector.h=C2=A0 =C2=A0 =C2=A0|=C2=A0 8 +++++-<br>
=C2=A0include/uapi/linux/cn_proc.h=C2=A0 | 43 ++++++++++++++++------------<=
br>
=C2=A05 files changed, 96 insertions(+), 35 deletions(-)<br>
<br>
diff --git a/drivers/connector/cn_proc.c b/drivers/connector/cn_proc.c<br>
index ccac1c453080..84f38d2bd4b9 100644<br>
--- a/drivers/connector/cn_proc.c<br>
+++ b/drivers/connector/cn_proc.c<br>
@@ -48,6 +48,21 @@ static DEFINE_PER_CPU(struct local_event, local_event) =
=3D {<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 .lock =3D INIT_LOCAL_LOCK(lock),<br>
=C2=A0};<br>
<br>
+static int cn_filter(struct sock *dsk, struct sk_buff *skb, void *data)<br=
>
+{<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0enum proc_cn_mcast_op mc_op;<br>
+<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0if (!dsk)<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0return 0;<br>
+<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0mc_op =3D ((struct proc_input *)(dsk-&gt;sk_use=
r_data))-&gt;mcast_op;<br>
+<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0if (mc_op =3D=3D PROC_CN_MCAST_IGNORE)<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0return 1;<br>
+<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0return 0;<br>
+}<br>
+<br>
=C2=A0static inline void send_msg(struct cn_msg *msg)<br>
=C2=A0{<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 local_lock(&amp;local_event.lock);<br>
@@ -61,7 +76,8 @@ static inline void send_msg(struct cn_msg *msg)<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0*<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0* If cn_netlink_send() fails, the data is=
 not sent.<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0*/<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0cn_netlink_send(msg, 0, CN_IDX_PROC, GFP_NOWAIT=
);<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0cn_netlink_send_mult(msg, msg-&gt;len, 0, CN_ID=
X_PROC, GFP_NOWAIT,<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 cn_filter, NULL);<br>
<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 local_unlock(&amp;local_event.lock);<br>
=C2=A0}<br>
@@ -346,11 +362,9 @@ static void cn_proc_ack(int err, int rcvd_seq, int rcv=
d_ack)<br>
=C2=A0static void cn_proc_mcast_ctl(struct cn_msg *msg,<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 struct netlink_skb_parms *nsp)<br>
=C2=A0{<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0enum proc_cn_mcast_op *mc_op =3D NULL;<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0int err =3D 0;<br>
-<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0if (msg-&gt;len !=3D sizeof(*mc_op))<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0return;<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0enum proc_cn_mcast_op mc_op =3D 0, prev_mc_op =
=3D 0;<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0int err =3D 0, initial =3D 0;<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0struct sock *sk =3D NULL;<br></blockquote><div>=
[Kalesh] Maintain reverse Xmas tree order.</div><blockquote class=3D"gmail_=
quote" style=3D"margin:0px 0px 0px 0.8ex;border-left:1px solid rgb(204,204,=
204);padding-left:1ex">
<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 /* <br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0* Events are reported with respect to the=
 initial pid<br>
@@ -367,13 +381,32 @@ static void cn_proc_mcast_ctl(struct cn_msg *msg,<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 goto out;<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 }<br>
<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0mc_op =3D (enum proc_cn_mcast_op *)msg-&gt;data=
;<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0switch (*mc_op) {<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0if (msg-&gt;len =3D=3D sizeof(mc_op))<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0mc_op =3D *((enum p=
roc_cn_mcast_op *)msg-&gt;data);<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0else<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0return;<br>
+<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0if (nsp-&gt;sk) {<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0sk =3D nsp-&gt;sk;<=
br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0if (sk-&gt;sk_user_=
data =3D=3D NULL) {<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0sk-&gt;sk_user_data =3D kzalloc(sizeof(struct proc_input),<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 GFP_KERNEL);<br></blockquote><div>[Kalesh] you =
need a check for memory allocation failure here.</div><blockquote class=3D"=
gmail_quote" style=3D"margin:0px 0px 0px 0.8ex;border-left:1px solid rgb(20=
4,204,204);padding-left:1ex">
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0initial =3D 1;<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0} else {<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0prev_mc_op =3D<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0((struct proc_input *)(sk-&gt;sk_user_data))-&gt;mcast_op;<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0}<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0((struct proc_input=
 *)(sk-&gt;sk_user_data))-&gt;mcast_op =3D mc_op;<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0}<br>
+<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0switch (mc_op) {<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 case PROC_CN_MCAST_LISTEN:<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0atomic_inc(&amp;pro=
c_event_num_listeners);<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0if (initial || (pre=
v_mc_op !=3D PROC_CN_MCAST_LISTEN))<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0atomic_inc(&amp;proc_event_num_listeners);<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 break;<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 case PROC_CN_MCAST_IGNORE:<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0atomic_dec(&amp;pro=
c_event_num_listeners);<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0if (!initial &amp;&=
amp; (prev_mc_op !=3D PROC_CN_MCAST_IGNORE))<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0atomic_dec(&amp;proc_event_num_listeners);<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 break;<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 default:<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 err =3D EINVAL;<br>
diff --git a/drivers/connector/connector.c b/drivers/connector/connector.c<=
br>
index 48ec7ce6ecac..d1179df2b0ba 100644<br>
--- a/drivers/connector/connector.c<br>
+++ b/drivers/connector/connector.c<br>
@@ -59,7 +59,9 @@ static int cn_already_initialized;<br>
=C2=A0 * both, or if both are zero then the group is looked up and sent the=
re.<br>
=C2=A0 */<br>
=C2=A0int cn_netlink_send_mult(struct cn_msg *msg, u16 len, u32 portid, u32=
 __group,<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0gfp_t gfp_mask)<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0gfp_t gfp_mask,<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0int (*filter)(struct sock *dsk, struct sk_buff =
*skb, void *data),<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0void *filter_data)<br>
=C2=A0{<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 struct cn_callback_entry *__cbq;<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 unsigned int size;<br>
@@ -110,8 +112,9 @@ int cn_netlink_send_mult(struct cn_msg *msg, u16 len, u=
32 portid, u32 __group,<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 NETLINK_CB(skb).dst_group =3D group;<br>
<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 if (group)<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0return netlink_broa=
dcast(dev-&gt;nls, skb, portid, group,<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 gfp_mask=
);<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0return netlink_broa=
dcast_filtered(dev-&gt;nls, skb, portid, group,<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0gfp_mask, filter,<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0(void *)filter_data);<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 return netlink_unicast(dev-&gt;nls, skb, portid=
,<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 !gfpflags_allow_blocking(gfp_mask));<br>
=C2=A0}<br>
@@ -121,7 +124,8 @@ EXPORT_SYMBOL_GPL(cn_netlink_send_mult);<br>
=C2=A0int cn_netlink_send(struct cn_msg *msg, u32 portid, u32 __group,<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 gfp_t gfp_mask)<br>
=C2=A0{<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0return cn_netlink_send_mult(msg, msg-&gt;len, p=
ortid, __group, gfp_mask);<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0return cn_netlink_send_mult(msg, msg-&gt;len, p=
ortid, __group, gfp_mask,<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0NULL, NULL);<br>
=C2=A0}<br>
=C2=A0EXPORT_SYMBOL_GPL(cn_netlink_send);<br>
<br>
@@ -162,6 +166,14 @@ static int cn_call_callback(struct sk_buff *skb)<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 return err;<br>
=C2=A0}<br>
<br>
+static void cn_release(struct sock *sk, unsigned long *groups)<br>
+{<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0if (groups &amp;&amp; test_bit(CN_IDX_PROC - 1,=
 groups)) {<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0kfree(sk-&gt;sk_use=
r_data);<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0sk-&gt;sk_user_data=
 =3D NULL;<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0}<br>
+}<br>
+<br>
=C2=A0/*<br>
=C2=A0 * Main netlink receiving function.<br>
=C2=A0 *<br>
@@ -249,6 +261,7 @@ static int cn_init(void)<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 struct netlink_kernel_cfg cfg =3D {<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 .groups =3D CN_NETL=
INK_USERS + 0xf,<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 .input=C2=A0 =3D cn=
_rx_skb,<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0.release =3D cn_rel=
ease,<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 };<br>
<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 dev-&gt;nls =3D netlink_kernel_create(&amp;init=
_net, NETLINK_CONNECTOR, &amp;cfg);<br>
diff --git a/drivers/w1/w1_netlink.c b/drivers/w1/w1_netlink.c<br>
index db110cc442b1..691978cddab7 100644<br>
--- a/drivers/w1/w1_netlink.c<br>
+++ b/drivers/w1/w1_netlink.c<br>
@@ -65,7 +65,8 @@ static void w1_unref_block(struct w1_cb_block *block)<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 u16 len =3D w1_repl=
y_len(block);<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 if (len) {<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 cn_netlink_send_mult(block-&gt;first_cn, len,<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0block-&gt;portid, 0, GFP_KERNEL);<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 block-&gt;portid, 0,<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 GFP_KERNEL, NULL, NULL);<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 }<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 kfree(block);<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 }<br>
@@ -83,7 +84,8 @@ static void w1_reply_make_space(struct w1_cb_block *block=
, u16 space)<br>
=C2=A0{<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 u16 len =3D w1_reply_len(block);<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 if (len + space &gt;=3D block-&gt;maxlen) {<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0cn_netlink_send_mul=
t(block-&gt;first_cn, len, block-&gt;portid, 0, GFP_KERNEL);<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0cn_netlink_send_mul=
t(block-&gt;first_cn, len, block-&gt;portid,<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 0, GFP_KERNEL, NULL, N=
ULL);<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 block-&gt;first_cn-=
&gt;len =3D 0;<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 block-&gt;cn =3D NU=
LL;<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 block-&gt;msg =3D N=
ULL;<br>
diff --git a/include/linux/connector.h b/include/linux/connector.h<br>
index 487350bb19c3..cec2d99ae902 100644<br>
--- a/include/linux/connector.h<br>
+++ b/include/linux/connector.h<br>
@@ -90,13 +90,19 @@ void cn_del_callback(const struct cb_id *id);<br>
=C2=A0 *=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0If @group is not ze=
ro, then message will be delivered<br>
=C2=A0 *=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0to the specified gr=
oup.<br>
=C2=A0 * @gfp_mask:=C2=A0 GFP mask.<br>
+ * @filter:=C2=A0 =C2=A0 =C2=A0Filter function to be used at netlink layer=
.<br>
+ * @filter_data:Filter data to be supplied to the filter function<br>
=C2=A0 *<br>
=C2=A0 * It can be safely called from softirq context, but may silently<br>
=C2=A0 * fail under strong memory pressure.<br>
=C2=A0 *<br>
=C2=A0 * If there are no listeners for given group %-ESRCH can be returned.=
<br>
=C2=A0 */<br>
-int cn_netlink_send_mult(struct cn_msg *msg, u16 len, u32 portid, u32 grou=
p, gfp_t gfp_mask);<br>
+int cn_netlink_send_mult(struct cn_msg *msg, u16 len, u32 portid,<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 u32 group, gfp_t gfp_mask,<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 int (*filter)(struct sock *dsk, struct sk_buff *skb,<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 void *data),<br=
>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 void *filter_data);<br>
<br>
=C2=A0/**<br>
=C2=A0 * cn_netlink_send - Sends message to the specified groups.<br>
diff --git a/include/uapi/linux/cn_proc.h b/include/uapi/linux/cn_proc.h<br=
>
index db210625cee8..6a06fb424313 100644<br>
--- a/include/uapi/linux/cn_proc.h<br>
+++ b/include/uapi/linux/cn_proc.h<br>
@@ -30,6 +30,30 @@ enum proc_cn_mcast_op {<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 PROC_CN_MCAST_IGNORE =3D 2<br>
=C2=A0};<br>
<br>
+enum proc_cn_event {<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0/* Use successive bits so the enums can be used=
 to record<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 * sets of events as well<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 */<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0PROC_EVENT_NONE =3D 0x00000000,<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0PROC_EVENT_FORK =3D 0x00000001,<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0PROC_EVENT_EXEC =3D 0x00000002,<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0PROC_EVENT_UID=C2=A0 =3D 0x00000004,<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0PROC_EVENT_GID=C2=A0 =3D 0x00000040,<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0PROC_EVENT_SID=C2=A0 =3D 0x00000080,<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0PROC_EVENT_PTRACE =3D 0x00000100,<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0PROC_EVENT_COMM =3D 0x00000200,<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0/* &quot;next&quot; should be 0x00000400 */<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0/* &quot;last&quot; is the last process event: =
exit,<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 * while &quot;next to last&quot; is coredumpin=
g event<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 */<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0PROC_EVENT_COREDUMP =3D 0x40000000,<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0PROC_EVENT_EXIT =3D 0x80000000<br>
+};<br>
+<br>
+struct proc_input {<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0enum proc_cn_mcast_op mcast_op;<br>
+};<br>
+<br>
=C2=A0/*<br>
=C2=A0 * From the user&#39;s point of view, the process<br>
=C2=A0 * ID is the thread group ID and thread ID is the internal<br>
@@ -44,24 +68,7 @@ enum proc_cn_mcast_op {<br>
=C2=A0 */<br>
<br>
=C2=A0struct proc_event {<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0enum what {<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0/* Use successive b=
its so the enums can be used to record<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 * sets of events a=
s well<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 */<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0PROC_EVENT_NONE =3D=
 0x00000000,<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0PROC_EVENT_FORK =3D=
 0x00000001,<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0PROC_EVENT_EXEC =3D=
 0x00000002,<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0PROC_EVENT_UID=C2=
=A0 =3D 0x00000004,<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0PROC_EVENT_GID=C2=
=A0 =3D 0x00000040,<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0PROC_EVENT_SID=C2=
=A0 =3D 0x00000080,<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0PROC_EVENT_PTRACE =
=3D 0x00000100,<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0PROC_EVENT_COMM =3D=
 0x00000200,<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0/* &quot;next&quot;=
 should be 0x00000400 */<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0/* &quot;last&quot;=
 is the last process event: exit,<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 * while &quot;next=
 to last&quot; is coredumping event */<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0PROC_EVENT_COREDUMP=
 =3D 0x40000000,<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0PROC_EVENT_EXIT =3D=
 0x80000000<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0} what;<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0enum proc_cn_event what;<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 __u32 cpu;<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 __u64 __attribute__((aligned(8))) timestamp_ns;=
<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 /* Number of nano s=
econds since system boot */<br>
-- <br>
2.41.0<br>
<br>
<br>
</blockquote></div><br clear=3D"all"><div><br></div><span class=3D"gmail_si=
gnature_prefix">-- </span><br><div dir=3D"ltr" class=3D"gmail_signature"><d=
iv dir=3D"ltr">Regards,<div>Kalesh A P</div></div></div></div>

--0000000000007b45cc05fe2301cc--

--000000000000830b1d05fe2301cc
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

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
riBJ/K1AFUjRAjFhGV64l++td7dkmnq/X8ET75ti+w1s4FRpFqkD2m7pg5NxdsZphYIXAgMBAAGj
QjBAMA4GA1UdDwEB/wQEAwIBBjAPBgNVHRMBAf8EBTADAQH/MB0GA1UdDgQWBBSP8Et/qC5FJK5N
UPpjmove4t0bvDANBgkqhkiG9w0BAQsFAAOCAQEAS0DbwFCq/sgM7/eWVEVJu5YACUGssxOGhigH
M8pr5nS5ugAtrqQK0/Xx8Q+Kv3NnSoPHRHt44K9ubG8DKY4zOUXDjuS5V2yq/BKW7FPGLeQkbLmU
Y/vcU2hnVj6DuM81IcPJaP7O2sJTqsyQiunwXUaMld16WCgaLx3ezQA3QY/tRG3XUyiXfvNnBB4V
14qWtNPeTCekTBtzc3b0F5nCH3oO4y0IrQocLP88q1UOD5F+NuvDV0m+4S4tfGCLw0FREyOdzvcy
a5QBqJnnLDMfOjsl0oZAzjsshnjJYS8Uuu7bVW/fhO4FCU29KNhyztNiUGUe65KXgzHZs7XKR1g/
XzCCBWowggRSoAMCAQICDDfBRQmwNSI92mit0zANBgkqhkiG9w0BAQsFADBbMQswCQYDVQQGEwJC
RTEZMBcGA1UEChMQR2xvYmFsU2lnbiBudi1zYTExMC8GA1UEAxMoR2xvYmFsU2lnbiBHQ0MgUjMg
UGVyc29uYWxTaWduIDIgQ0EgMjAyMDAeFw0yMjA5MTAwODI5NTZaFw0yNTA5MTAwODI5NTZaMIGi
MQswCQYDVQQGEwJJTjESMBAGA1UECBMJS2FybmF0YWthMRIwEAYDVQQHEwlCYW5nYWxvcmUxFjAU
BgNVBAoTDUJyb2FkY29tIEluYy4xHzAdBgNVBAMTFkthbGVzaCBBbmFra3VyIFB1cmF5aWwxMjAw
BgkqhkiG9w0BCQEWI2thbGVzaC1hbmFra3VyLnB1cmF5aWxAYnJvYWRjb20uY29tMIIBIjANBgkq
hkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAxnv1Reaeezfr6NEmg3xZlh4cz9m7QCN13+j4z1scrX+b
JfnV8xITT5yvwdQv3R3p7nzD/t29lTRWK3wjodUd2nImo6vBaH3JbDwleIjIWhDXLNZ4u7WIXYwx
aQ8lYCdKXRsHXgGPY0+zSx9ddpqHZJlHwcvas3oKnQN9WgzZtsM7A8SJefWkNvkcOtef6bL8Ew+3
FBfXmtsPL9I2vita8gkYzunj9Nu2IM+MnsP7V/+Coy/yZDtFJHp30hDnYGzuOhJchDF9/eASvE8T
T1xqJODKM9xn5xXB1qezadfdgUs8k8QAYyP/oVBafF9uqDudL6otcBnziyDBQdFCuAQN7wIDAQAB
o4IB5DCCAeAwDgYDVR0PAQH/BAQDAgWgMIGjBggrBgEFBQcBAQSBljCBkzBOBggrBgEFBQcwAoZC
aHR0cDovL3NlY3VyZS5nbG9iYWxzaWduLmNvbS9jYWNlcnQvZ3NnY2NyM3BlcnNvbmFsc2lnbjJj
YTIwMjAuY3J0MEEGCCsGAQUFBzABhjVodHRwOi8vb2NzcC5nbG9iYWxzaWduLmNvbS9nc2djY3Iz
cGVyc29uYWxzaWduMmNhMjAyMDBNBgNVHSAERjBEMEIGCisGAQQBoDIBKAowNDAyBggrBgEFBQcC
ARYmaHR0cHM6Ly93d3cuZ2xvYmFsc2lnbi5jb20vcmVwb3NpdG9yeS8wCQYDVR0TBAIwADBJBgNV
HR8EQjBAMD6gPKA6hjhodHRwOi8vY3JsLmdsb2JhbHNpZ24uY29tL2dzZ2NjcjNwZXJzb25hbHNp
Z24yY2EyMDIwLmNybDAuBgNVHREEJzAlgSNrYWxlc2gtYW5ha2t1ci5wdXJheWlsQGJyb2FkY29t
LmNvbTATBgNVHSUEDDAKBggrBgEFBQcDBDAfBgNVHSMEGDAWgBSWM9HmWBdbNHWKgVZk1b5I3qGP
zzAdBgNVHQ4EFgQUI3+tdStI+ABRGSqksMsiCmO9uDAwDQYJKoZIhvcNAQELBQADggEBAGfe1o9b
4wUud0FMjb/FNdc433meL15npjdYWUeioHdlCGB5UvEaMGu71QysfoDOfUNeyO9YKp0h0fm7clvo
cBqeWe4CPv9TQbmLEtXKdEpj5kFZBGmav69mGTlu1A9KDQW3y0CDzCPG2Fdm4s73PnkwvemRk9E2
u9/kcZ8KWVeS+xq+XZ78kGTKQ6Wii3dMK/EHQhnDfidadoN/n+x2ySC8yyDNvy81BocnblQzvbuB
a30CvRuhokNO6Jzh7ZFtjKVMzYas3oo6HXgA+slRszMu4pc+fRPO41FHjeDM76e6P5OnthhnD+NY
x6xokUN65DN1bn2MkeNs0nQpizDqd0QxggJtMIICaQIBATBrMFsxCzAJBgNVBAYTAkJFMRkwFwYD
VQQKExBHbG9iYWxTaWduIG52LXNhMTEwLwYDVQQDEyhHbG9iYWxTaWduIEdDQyBSMyBQZXJzb25h
bFNpZ24gMiBDQSAyMDIwAgw3wUUJsDUiPdpordMwDQYJYIZIAWUDBAIBBQCggdQwLwYJKoZIhvcN
AQkEMSIEIFbY8m5oz1ZOI2sv1+lnrpL1LTkMnW8odHMkyHH4120+MBgGCSqGSIb3DQEJAzELBgkq
hkiG9w0BBwEwHAYJKoZIhvcNAQkFMQ8XDTIzMDYxNTAzNTMwNlowaQYJKoZIhvcNAQkPMVwwWjAL
BglghkgBZQMEASowCwYJYIZIAWUDBAEWMAsGCWCGSAFlAwQBAjAKBggqhkiG9w0DBzALBgkqhkiG
9w0BAQowCwYJKoZIhvcNAQEHMAsGCWCGSAFlAwQCATANBgkqhkiG9w0BAQEFAASCAQB3gxqqw8T+
uusr35MbilB3DM84s5XO4s4xxAt6FvlVxGhYPrc9uQLIDAsZ3TN2LEfB38Y906OAK5F33YkDgPd2
s7na9y4G0HMvR2zkBFU4poE1PvZ1ZNC6N8Y1+JnAzbOLdYFbIo7MavrMOgjJ5FxNBA+1V+OeG4na
hX6PVKEexbqxBCSPenIsbn0ObwEuPy4GVncDRMYF+RzxbGKt+J1gzVwl8mXNJIuAkUIciF3CSrF1
BlodHv23+2istFIonovrRIdjxtF9/fzvZNk68p5b6P/36rIQtUyRRnpc52YX1kfzOybWa8GKUC+g
zBs6wCJK1aMKAFER7WzOYMlEAso+
--000000000000830b1d05fe2301cc--

