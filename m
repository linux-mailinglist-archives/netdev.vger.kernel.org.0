Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BC3ED3FA452
	for <lists+netdev@lfdr.de>; Sat, 28 Aug 2021 09:31:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233526AbhH1HcX convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Sat, 28 Aug 2021 03:32:23 -0400
Received: from mail-pj1-f50.google.com ([209.85.216.50]:37642 "EHLO
        mail-pj1-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233348AbhH1HcQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 28 Aug 2021 03:32:16 -0400
Received: by mail-pj1-f50.google.com with SMTP id j10-20020a17090a94ca00b00181f17b7ef7so10504166pjw.2;
        Sat, 28 Aug 2021 00:31:26 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=72FGwkr2cgYiG2mCqnRFPrgyEIFWlTQT13Q2rpcWR6c=;
        b=L+vVgObJEkYk7Kj9HifFAAdZZz9aNXuZhrDFsHtkhV/VNZ9897PRKglf16uBw9UTmi
         9cddLe4hmacg1zuTx0Re7pbPE0Mu2682dNgSCqsErobItEHcivwT4vp0DIXGbjgUNEMj
         2rNX76AW5H0hrl6T6OAuJSsZgYY6aqgBfjAIYp0eQCb0lOsI1miW8y6tD+fBfmbGH5Ga
         hrwwnW2IxSwKUGz2+WagX5HEe7uKuGUCf7NdHgX2EfrSVPgXUU4QsDrlFGsE7cXEIpds
         hSdsKTY1p6UZEaEMMAy25+O4GC4/8THYW7nXYvxNsptsURic/iQqiZiRFCP6azgQDCae
         3Emw==
X-Gm-Message-State: AOAM532ki5yPgAYmkfZytjljhxN8sJ4nQPsm0mxEFyhA1t4fcpcHX1ON
        VbT0VlKLLafWNf5/vTAAermSbuEibtBEYOKX4zU=
X-Google-Smtp-Source: ABdhPJzVwiRr/iufrwRsD3iA1dLD0/75TS+nkg+Sq3eKriL7lOlxSYaVCBACpKhZsKqGUkHhvzxRECVhEBWX+9qFs7M=
X-Received: by 2002:a17:902:9b89:b0:12d:7f02:f6a5 with SMTP id
 y9-20020a1709029b8900b0012d7f02f6a5mr12373883plp.39.1630135885761; Sat, 28
 Aug 2021 00:31:25 -0700 (PDT)
MIME-Version: 1.0
References: <20210826050458.1540622-1-keescook@chromium.org>
 <20210826050458.1540622-3-keescook@chromium.org> <20210826062452.jekmoo43f4xu5jxk@pengutronix.de>
 <202108270915.B4DD070AF@keescook>
In-Reply-To: <202108270915.B4DD070AF@keescook>
From:   Vincent MAILHOL <mailhol.vincent@wanadoo.fr>
Date:   Sat, 28 Aug 2021 16:31:14 +0900
Message-ID: <CAMZ6Rq+b1wy3miNvXyeM5Cbp16CH78RKRf2WxUSL4s4w5=+aYg@mail.gmail.com>
Subject: Re: [PATCH v2 2/5] treewide: Replace open-coded flex arrays in unions
To:     Kees Cook <keescook@chromium.org>
Cc:     Marc Kleine-Budde <mkl@pengutronix.de>,
        open list <linux-kernel@vger.kernel.org>,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Ayush Sawal <ayush.sawal@chelsio.com>,
        Vinay Kumar Yadav <vinay.yadav@chelsio.com>,
        Rohit Maheshwari <rohitm@chelsio.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Kalle Valo <kvalo@codeaurora.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Stanislaw Gruszka <stf_xl@wp.pl>,
        Luca Coelho <luciano.coelho@intel.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Johannes Berg <johannes.berg@intel.com>,
        Mordechay Goodstein <mordechay.goodstein@intel.com>,
        Lee Jones <lee.jones@linaro.org>,
        Wolfgang Grandegger <wg@grandegger.com>,
        Arunachalam Santhanam <arunachalam.santhanam@in.bosch.com>,
        Mikulas Patocka <mikulas@artax.karlin.mff.cuni.cz>,
        linux-crypto@vger.kernel.org, ath10k@lists.infradead.org,
        linux-wireless@vger.kernel.org, netdev <netdev@vger.kernel.org>,
        linux-scsi@vger.kernel.org, linux-can <linux-can@vger.kernel.org>,
        bpf@vger.kernel.org, Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        Keith Packard <keithp@keithp.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        clang-built-linux@googlegroups.com, linux-hardening@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Le sam. 28 août 2021 à 01:17, Kees Cook <keescook@chromium.org> a écrit :
>
> On Thu, Aug 26, 2021 at 08:24:52AM +0200, Marc Kleine-Budde wrote:
> > [...]
> > BTW: Is there opportunity for conversion, too?
> >
> > | drivers/net/can/peak_canfd/peak_pciefd_main.c:146:32: warning: array of flexible structures
>
> Untested potential solution:
>
> diff --git a/drivers/net/can/peak_canfd/peak_pciefd_main.c b/drivers/net/can/peak_canfd/peak_pciefd_main.c
> index 1df3c4b54f03..efa2b5a52bd7 100644
> --- a/drivers/net/can/peak_canfd/peak_pciefd_main.c
> +++ b/drivers/net/can/peak_canfd/peak_pciefd_main.c
> @@ -143,7 +143,11 @@ struct pciefd_rx_dma {
>         __le32 irq_status;
>         __le32 sys_time_low;
>         __le32 sys_time_high;
> -       struct pucan_rx_msg msg[];
> +       /*
> +        * with "msg" being pciefd_irq_rx_cnt(priv->irq_status)-many
> +        * variable-sized struct pucan_rx_msg following.
> +        */
> +       __le32 msg[];

Isn't u8 msg[] preferable here?

>  } __packed __aligned(4);
>
>  /* Tx Link record */
> @@ -327,7 +331,7 @@ static irqreturn_t pciefd_irq_handler(int irq, void *arg)
>
>         /* handle rx messages (if any) */
>         peak_canfd_handle_msgs_list(&priv->ucan,
> -                                   rx_dma->msg,
> +                                   (struct pucan_rx_msg *)rx_dma->msg,
>                                     pciefd_irq_rx_cnt(priv->irq_status));
>
>         /* handle tx link interrupt (if any) */
>
>
> It's not great, but it's also not strictly a flex array, in the sense
> that since struct pucan_rx_msg is a variable size, the compiler cannot
> reason about the size of struct pciefd_rx_dma based only on the
> irq_status encoding...

In the same spirit, it is a bit cleaner to change the prototype of
handle_msgs_list().

Like that:


diff --git a/drivers/net/can/peak_canfd/peak_canfd.c b/drivers/net/can/peak_canf
d/peak_canfd.c
index d08718e98e11..81a9faa6193f 100644
--- a/drivers/net/can/peak_canfd/peak_canfd.c
+++ b/drivers/net/can/peak_canfd/peak_canfd.c
@@ -484,9 +484,8 @@ int peak_canfd_handle_msg(struct peak_canfd_priv *priv,

 /* handle a list of rx_count messages from rx_msg memory address */
 int peak_canfd_handle_msgs_list(struct peak_canfd_priv *priv,
-                               struct pucan_rx_msg *msg_list, int msg_count)
+                               void *msg_ptr, int msg_count)
 {
-       void *msg_ptr = msg_list;
        int i, msg_size = 0;

        for (i = 0; i < msg_count; i++) {
diff --git a/drivers/net/can/peak_canfd/peak_canfd_user.h b/drivers/net/can/peak
_canfd/peak_canfd_user.h
index a72719dc3b74..ef91f92e70c3 100644
--- a/drivers/net/can/peak_canfd/peak_canfd_user.h
+++ b/drivers/net/can/peak_canfd/peak_canfd_user.h
@@ -42,5 +42,5 @@ struct net_device *alloc_peak_canfd_dev(int
sizeof_priv, int index,
 int peak_canfd_handle_msg(struct peak_canfd_priv *priv,
                          struct pucan_rx_msg *msg);
 int peak_canfd_handle_msgs_list(struct peak_canfd_priv *priv,
-                               struct pucan_rx_msg *rx_msg, int rx_count);
+                               void *msg_ptr, int rx_count);
 #endif
diff --git a/drivers/net/can/peak_canfd/peak_pciefd_main.c
b/drivers/net/can/peak_canfd/peak_pciefd_main.c
index 1df3c4b54f03..c1de1e3dc4bc 100644
--- a/drivers/net/can/peak_canfd/peak_pciefd_main.c
+++ b/drivers/net/can/peak_canfd/peak_pciefd_main.c
@@ -143,7 +143,11 @@ struct pciefd_rx_dma {
        __le32 irq_status;
        __le32 sys_time_low;
        __le32 sys_time_high;
-       struct pucan_rx_msg msg[];
+       /*
+        * with "msg" being pciefd_irq_rx_cnt(priv->irq_status)-many
+        * variable-sized struct pucan_rx_msg following.
+        */
+       u8 msg[];
 } __packed __aligned(4);

 /* Tx Link record */


Another solution would be to declare a maximum length for struct
pucan_rx_msg::d. Because these are CAN FD messages, I suppose
that maximum length would be CANFD_MAX_DLEN. struct canfd_frame
from the UAPI uses the same pattern.

N.B. This solution is not exclusive from the above one (actually,
I think that using both would be the best solution).

diff --git a/include/linux/can/dev/peak_canfd.h
b/include/linux/can/dev/peak_canfd.h
index f38772fd0c07..a048359db430 100644
--- a/include/linux/can/dev/peak_canfd.h
+++ b/include/linux/can/dev/peak_canfd.h
@@ -189,7 +189,7 @@ struct __packed pucan_rx_msg {
        u8      client;
        __le16  flags;
        __le32  can_id;
-       u8      d[];
+       u8      d[CANFD_MAX_DLEN];
 };

 /* uCAN error types */



I only tested for compilation.

Yours sincerely,
Vincent
