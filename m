Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2AEAE5BAC1B
	for <lists+netdev@lfdr.de>; Fri, 16 Sep 2022 13:13:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229658AbiIPLN3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Sep 2022 07:13:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34698 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229696AbiIPLN1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 16 Sep 2022 07:13:27 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B9EF1AD
        for <netdev@vger.kernel.org>; Fri, 16 Sep 2022 04:13:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1663326801;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=+c+X3n3nDrK8nHpE4DKFcOu/omHWgHqfEgCTLvi6yLY=;
        b=Em1kEGk2/mYlcNUxKH7BADJcJMcLq9HKOHDhz9/E1v1CI0iYVCeJu3s+srwipIifoO6LCJ
        aonl6lqYPUmHykCEKkCJJpwFr3W/SsnO6/+c7Bq/+crRABfaU26BnysbXLmecDVFbTqXuG
        FEdiIweAFMNbxE89rYKkYRlocnK5P48=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-581-Od4B2x2uNPezmNEyAgH_Sw-1; Fri, 16 Sep 2022 07:13:20 -0400
X-MC-Unique: Od4B2x2uNPezmNEyAgH_Sw-1
Received: by mail-wr1-f69.google.com with SMTP id d9-20020adfa349000000b0022ad6fb2845so356323wrb.17
        for <netdev@vger.kernel.org>; Fri, 16 Sep 2022 04:13:19 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=+c+X3n3nDrK8nHpE4DKFcOu/omHWgHqfEgCTLvi6yLY=;
        b=C6MSwk+jD+BS+tjmPHlv5zO51/pzdioN91WfKoCIoHKHB8RaEWbuLviOfoqpmTKzVS
         qvj5MX/uw27SA0gzajs25IBUfpmUa1teS2RguvsJPVMsOPrN7Qi69uMSp+39LnoZNTNZ
         PFlyO55Dm1SQBLcwRqB5slYlw+NqZNYjKYmynLbV0uonlTucIAceP6ldaG4qXiIsnwCx
         MATgAjygOCR0XB/q4ZQO5xe2TId+2OJGGmjip5IzUqfbB50F5dPR3AOQgKZFyh7kmxxD
         6xaz9lgHakt2EdRKk6jCDp20W1dEqHqK1MX/JDyiIb5K1khsM8NTZkUluaqmh8KrSoYO
         VPKg==
X-Gm-Message-State: ACrzQf2QOrg/d6m9v6FQN24OGWEEsBLIyj3L50gCdnr0HxVerYdxdvp1
        /hsoam1x4nFqb8uz+d3s3sdP2RoARU+MrRh8Q1y0Q/ShU2vun6hPY/wcgj8X23DE9pJmZOXltoI
        UB/gCTj5nQJxa5OxrlcDehC5J85JZwwDb
X-Received: by 2002:a5d:6390:0:b0:22a:4831:e35 with SMTP id p16-20020a5d6390000000b0022a48310e35mr2436274wru.88.1663326798829;
        Fri, 16 Sep 2022 04:13:18 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM4nFxCCov6wvhy1+LiO3PaqiTSR6MOP9gxrvJnIalgtLFPCOX9KA0f3h8uj54rpDj9miJ6W0adsW0uKmh/Y2Yc=
X-Received: by 2002:a5d:6390:0:b0:22a:4831:e35 with SMTP id
 p16-20020a5d6390000000b0022a48310e35mr2436256wru.88.1663326798543; Fri, 16
 Sep 2022 04:13:18 -0700 (PDT)
MIME-Version: 1.0
References: <20220908121927.3074843-1-tcs_kernel@tencent.com>
In-Reply-To: <20220908121927.3074843-1-tcs_kernel@tencent.com>
From:   Alexander Aring <aahringo@redhat.com>
Date:   Fri, 16 Sep 2022 07:13:07 -0400
Message-ID: <CAK-6q+jG4fVVi7d=c87fVN19iAMs-Y04=KG5VEm0pBFQW1VtRg@mail.gmail.com>
Subject: Re: [PATCH V3] net/ieee802154: fix uninit value bug in dgram_sendmsg
To:     Haimin Zhang <tcs.kernel@gmail.com>
Cc:     alex.aring@gmail.com, stefan@datenfreihafen.org,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, linux-wpan@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Haimin Zhang <tcs_kernel@tencent.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

just something that we should fix in the future...

On Thu, Sep 8, 2022 at 8:19 AM Haimin Zhang <tcs.kernel@gmail.com> wrote:
>
> There is uninit value bug in dgram_sendmsg function in
> net/ieee802154/socket.c when the length of valid data pointed by the
> msg->msg_name isn't verified.
>
> We introducing a helper function ieee802154_sockaddr_check_size to
> check namelen. First we check there is addr_type in ieee802154_addr_sa.
> Then, we check namelen according to addr_type.
>
> Also fixed in raw_bind, dgram_bind, dgram_connect.
>
> Signed-off-by: Haimin Zhang <tcs_kernel@tencent.com>
> ---
>  include/net/ieee802154_netdev.h | 37 +++++++++++++++++++++++++++++
>  net/ieee802154/socket.c         | 42 ++++++++++++++++++---------------
>  2 files changed, 60 insertions(+), 19 deletions(-)
>
> diff --git a/include/net/ieee802154_netdev.h b/include/net/ieee802154_netdev.h
> index d0d188c32..a8994f307 100644
> --- a/include/net/ieee802154_netdev.h
> +++ b/include/net/ieee802154_netdev.h
> @@ -15,6 +15,22 @@
>  #ifndef IEEE802154_NETDEVICE_H
>  #define IEEE802154_NETDEVICE_H
>
> +#define IEEE802154_REQUIRED_SIZE(struct_type, member) \
> +       (offsetof(typeof(struct_type), member) + \
> +       sizeof(((typeof(struct_type) *)(NULL))->member))
> +
> +#define IEEE802154_ADDR_OFFSET \
> +       offsetof(typeof(struct sockaddr_ieee802154), addr)
> +
> +#define IEEE802154_MIN_NAMELEN (IEEE802154_ADDR_OFFSET + \
> +       IEEE802154_REQUIRED_SIZE(struct ieee802154_addr_sa, addr_type))
> +
> +#define IEEE802154_NAMELEN_SHORT (IEEE802154_ADDR_OFFSET + \
> +       IEEE802154_REQUIRED_SIZE(struct ieee802154_addr_sa, short_addr))
> +
> +#define IEEE802154_NAMELEN_LONG (IEEE802154_ADDR_OFFSET + \
> +       IEEE802154_REQUIRED_SIZE(struct ieee802154_addr_sa, hwaddr))
> +
>  #include <net/af_ieee802154.h>
>  #include <linux/netdevice.h>
>  #include <linux/skbuff.h>
> @@ -165,6 +181,27 @@ static inline void ieee802154_devaddr_to_raw(void *raw, __le64 addr)
>         memcpy(raw, &temp, IEEE802154_ADDR_LEN);
>  }
>
> +static inline int
> +ieee802154_sockaddr_check_size(struct sockaddr_ieee802154 *daddr, int len)
> +{
> +       struct ieee802154_addr_sa *sa;
> +
> +       sa = &daddr->addr;
> +       if (len < IEEE802154_MIN_NAMELEN)
> +               return -EINVAL;
> +       switch (sa->addr_type) {
> +       case IEEE802154_ADDR_SHORT:
> +               if (len < IEEE802154_NAMELEN_SHORT)
> +                       return -EINVAL;
> +               break;
> +       case IEEE802154_ADDR_LONG:
> +               if (len < IEEE802154_NAMELEN_LONG)
> +                       return -EINVAL;
> +               break;
> +       }

There is a missing IEEE802154_ADDR_NONE here. If it's NONE the size is
correct, although all other possible values which are not SHORT, LONG
or NONE, should here end in an -EINVAL as well. In those cases the
size is "undefined" for now.

> +       return 0;
> +}
> +
>  static inline void ieee802154_addr_from_sa(struct ieee802154_addr *a,
>                                            const struct ieee802154_addr_sa *sa)
>  {
> diff --git a/net/ieee802154/socket.c b/net/ieee802154/socket.c
> index 718fb77bb..7889e1ef7 100644
> --- a/net/ieee802154/socket.c
> +++ b/net/ieee802154/socket.c
> @@ -200,8 +200,9 @@ static int raw_bind(struct sock *sk, struct sockaddr *_uaddr, int len)
>         int err = 0;
>         struct net_device *dev = NULL;
>
> -       if (len < sizeof(*uaddr))
> -               return -EINVAL;
> +       err = ieee802154_sockaddr_check_size(uaddr, len);
> +       if (err < 0)
> +               return err;
>
>         uaddr = (struct sockaddr_ieee802154 *)_uaddr;
>         if (uaddr->family != AF_IEEE802154)
> @@ -493,7 +494,8 @@ static int dgram_bind(struct sock *sk, struct sockaddr *uaddr, int len)
>
>         ro->bound = 0;
>
> -       if (len < sizeof(*addr))
> +       err = ieee802154_sockaddr_check_size(addr, len);
> +       if (err < 0)
>                 goto out;
>
>         if (addr->family != AF_IEEE802154)
> @@ -564,8 +566,9 @@ static int dgram_connect(struct sock *sk, struct sockaddr *uaddr,
>         struct dgram_sock *ro = dgram_sk(sk);
>         int err = 0;
>
> -       if (len < sizeof(*addr))
> -               return -EINVAL;
> +       err = ieee802154_sockaddr_check_size(addr, len);
> +       if (err < 0)
> +               return err;
>
>         if (addr->family != AF_IEEE802154)
>                 return -EINVAL;
> @@ -604,6 +607,7 @@ static int dgram_sendmsg(struct sock *sk, struct msghdr *msg, size_t size)
>         struct ieee802154_mac_cb *cb;
>         struct dgram_sock *ro = dgram_sk(sk);
>         struct ieee802154_addr dst_addr;
> +       DECLARE_SOCKADDR(struct sockaddr_ieee802154*, daddr, msg->msg_name);
>         int hlen, tlen;
>         int err;
>
> @@ -612,10 +616,20 @@ static int dgram_sendmsg(struct sock *sk, struct msghdr *msg, size_t size)
>                 return -EOPNOTSUPP;
>         }
>
> -       if (!ro->connected && !msg->msg_name)
> -               return -EDESTADDRREQ;
> -       else if (ro->connected && msg->msg_name)
> -               return -EISCONN;
> +       if (msg->msg_name) {
> +               if (ro->connected)
> +                       return -EISCONN;
> +               if (msg->msg_namelen < IEEE802154_MIN_NAMELEN)
> +                       return -EINVAL;

nitpick, we do this in ieee802154_sockaddr_check_size() as well?

> +               err = ieee802154_sockaddr_check_size(daddr, msg->msg_namelen);
> +               if (err < 0)
> +                       return err;
> +               ieee802154_addr_from_sa(&dst_addr, &daddr->addr);
> +       } else {
> +               if (!ro->connected)
> +                       return -EDESTADDRREQ;

I'm not sure about this change but it looks okay to me.

That's it. I am sorry for the delay... I usually schedule my review
for the weekend if I can't do it then the next weekend...

- Alex

