Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1D276244EFE
	for <lists+netdev@lfdr.de>; Fri, 14 Aug 2020 21:56:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727876AbgHNT4R (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Aug 2020 15:56:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60280 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726297AbgHNT4R (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Aug 2020 15:56:17 -0400
Received: from mail-ot1-x341.google.com (mail-ot1-x341.google.com [IPv6:2607:f8b0:4864:20::341])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 416D3C061385;
        Fri, 14 Aug 2020 12:56:16 -0700 (PDT)
Received: by mail-ot1-x341.google.com with SMTP id h22so8483275otq.11;
        Fri, 14 Aug 2020 12:56:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=sD1hZF2WdFP1115pTPAq+FgT6KZuW8nyCloT6zbSfds=;
        b=OFSJI9uLzODA4OcY1hVAe6WHCPZQZoKwaxcAlkY3h7E+FIVyKNBc+LitG0bJce7GM9
         MI8t2RVPG1bPqQYEhRkPl1B+ZisQwqamhVZY4Ugayj54oXPxzK2O+cNz9fGv6nNdkDUP
         KuiJInYJstOMsOVbUgEOlknsCJUzx3pYpBMpRGc6JCryU79HxqGybFK8Tm1xNlAYhgZ6
         gy6LCOMb1V1bv1NyGvwCvuMzCVGXDq+xt1yH5R2lvCLiMIrImA5MFQT2ZOiBBknFfHLI
         JgupdGsIcdpLUlGfmyFxvVPXrb//GWhVPfCJAsUt1fX/ngEu3//rAr2eUBRUSxIraJgy
         x1sQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=sD1hZF2WdFP1115pTPAq+FgT6KZuW8nyCloT6zbSfds=;
        b=Tlqk1UT5RWSvffk2oZ23mchyfhuXwP2RJVYpQipoikXRBhhXLzcbjNR8mEOqHkxEKs
         M4C0Kw4VRDnMnM2OYWzuVF0BunJuHn992AtfMqyEKJ8Dyve+WOeo6luvDqKzCHey2KdC
         KxzZWJDWbXXEk/+nYVakQ46rEB4A2TzLnPiCKoVULRv8mD+W/ZIgi1krhN+mYrUiwAvU
         LQxrmlymmqIYEgD1T1Mvav6KabVEidPe9yCRFVlnJgpm3khJV800hmh5Z0LCFXaDBJeB
         HvgHz5TXb3Mvtx7PnulPkZ6juwM+8CzZE40AlMNT/4s4iOjCOULGiCLEYb4zdj3AJ1CE
         5WHw==
X-Gm-Message-State: AOAM532vXKp9yoauLdxlxdKBtsbdY7UDY/+LsOHiZTYyFuD70Rn72NCP
        bUUmVZYAiuy+N+U/yji1tVWKlrdEBCU25gRQyg8=
X-Google-Smtp-Source: ABdhPJy6y8VniNbwmMIOoU7RwRwYzrIN3Z8PfE0Fq+Prr4D1B0V/OsFpi82tLiD5BIDc6eUrhcwgYOzjKVvfaC/2Ms0=
X-Received: by 2002:a9d:6053:: with SMTP id v19mr2981691otj.362.1597434976086;
 Fri, 14 Aug 2020 12:56:16 -0700 (PDT)
MIME-Version: 1.0
References: <20200813084129.332730-1-josephsih@chromium.org> <20200813164059.v1.2.I03247d3813c6dcbcdbeab26d068f9fd765edb1f5@changeid>
In-Reply-To: <20200813164059.v1.2.I03247d3813c6dcbcdbeab26d068f9fd765edb1f5@changeid>
From:   Luiz Augusto von Dentz <luiz.dentz@gmail.com>
Date:   Fri, 14 Aug 2020 12:56:05 -0700
Message-ID: <CABBYNZJ-nBXeujF2WkMEPYPQhXAphqKCV39gr-QYFdTC3GvjXg@mail.gmail.com>
Subject: Re: [PATCH v1 2/2] Bluetooth: sco: expose WBS packet length in socket option
To:     Joseph Hwang <josephsih@chromium.org>
Cc:     "linux-bluetooth@vger.kernel.org" <linux-bluetooth@vger.kernel.org>,
        Marcel Holtmann <marcel@holtmann.org>,
        Joseph Hwang <josephsih@google.com>,
        ChromeOS Bluetooth Upstreaming 
        <chromeos-bluetooth-upstreaming@chromium.org>,
        Alain Michaud <alainm@chromium.org>,
        Abhishek Pandit-Subedi <abhishekpandit@chromium.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "open list:NETWORKING [GENERAL]" <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Joseph,

On Thu, Aug 13, 2020 at 1:42 AM Joseph Hwang <josephsih@chromium.org> wrote:
>
> It is desirable to expose the wideband speech packet length via
> a socket option to the user space so that the user space can set
> the value correctly in configuring the sco connection.
>
> Reviewed-by: Alain Michaud <alainm@chromium.org>
> Reviewed-by: Abhishek Pandit-Subedi <abhishekpandit@chromium.org>
> Signed-off-by: Joseph Hwang <josephsih@chromium.org>
> ---
>
>  include/net/bluetooth/bluetooth.h | 2 ++
>  net/bluetooth/sco.c               | 8 ++++++++
>  2 files changed, 10 insertions(+)
>
> diff --git a/include/net/bluetooth/bluetooth.h b/include/net/bluetooth/bluetooth.h
> index 9125effbf4483d..922cc03143def4 100644
> --- a/include/net/bluetooth/bluetooth.h
> +++ b/include/net/bluetooth/bluetooth.h
> @@ -153,6 +153,8 @@ struct bt_voice {
>
>  #define BT_SCM_PKT_STATUS      0x03
>
> +#define BT_SCO_PKT_LEN         17
> +
>  __printf(1, 2)
>  void bt_info(const char *fmt, ...);
>  __printf(1, 2)
> diff --git a/net/bluetooth/sco.c b/net/bluetooth/sco.c
> index dcf7f96ff417e6..97e4e7c7b8cf62 100644
> --- a/net/bluetooth/sco.c
> +++ b/net/bluetooth/sco.c
> @@ -67,6 +67,7 @@ struct sco_pinfo {
>         __u32           flags;
>         __u16           setting;
>         __u8            cmsg_mask;
> +       __u32           pkt_len;
>         struct sco_conn *conn;
>  };
>
> @@ -267,6 +268,8 @@ static int sco_connect(struct sock *sk)
>                 sco_sock_set_timer(sk, sk->sk_sndtimeo);
>         }
>
> +       sco_pi(sk)->pkt_len = hdev->sco_pkt_len;
> +
>  done:
>         hci_dev_unlock(hdev);
>         hci_dev_put(hdev);
> @@ -1001,6 +1004,11 @@ static int sco_sock_getsockopt(struct socket *sock, int level, int optname,
>                         err = -EFAULT;
>                 break;
>
> +       case BT_SCO_PKT_LEN:
> +               if (put_user(sco_pi(sk)->pkt_len, (u32 __user *)optval))
> +                       err = -EFAULT;
> +               break;

Couldn't we expose this via BT_SNDMTU/BT_RCVMTU?

>         default:
>                 err = -ENOPROTOOPT;
>                 break;
> --
> 2.28.0.236.gb10cc79966-goog
>


-- 
Luiz Augusto von Dentz
