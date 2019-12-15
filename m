Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4BA5B11FAB5
	for <lists+netdev@lfdr.de>; Sun, 15 Dec 2019 20:20:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726346AbfLOTU0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 15 Dec 2019 14:20:26 -0500
Received: from mail-pf1-f194.google.com ([209.85.210.194]:44716 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726219AbfLOTU0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 15 Dec 2019 14:20:26 -0500
Received: by mail-pf1-f194.google.com with SMTP id d199so4372916pfd.11
        for <netdev@vger.kernel.org>; Sun, 15 Dec 2019 11:20:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=TD8eJUgG1fhr01DWCx63pJF7m5T34fG5E5EbI/ICcoE=;
        b=eNI6ibgcFTrrNyxWgMtfTebJC9mSh5Q5F8xaII86wD8vHx73easJ4146o+yjnYIJbM
         ws2Wm0h3cDcDvR8T1BITJqBgIdPYKgD71N5Z03EQaCZJOZTSL40Ag1iWjun9L+3FIrQC
         fLyCzGpRUGC7oFuIUcsWFjggKnxODgBmUrT35/3w3isurbucshyLaooKntvVP4atoc0c
         OWbRW9VaCfpQ+vDkqbsbUhan7QMIQzB9pQSH4fyPfluSd6EmdIMb5lwrXTJ511AXBA9w
         M+RTcV+j4Yz2c4r4sAqzeigj7bd4z+7Xvw+pk5/JwhOBHdmXQDcMxFiWEzJb1ariwe9R
         4G3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=TD8eJUgG1fhr01DWCx63pJF7m5T34fG5E5EbI/ICcoE=;
        b=QBboGJE9e/+3ffhqzJS/4GkSUm0shaJq5GxB5CSOO/MIAvEpYXLhBXjIE/mMqWo1Hi
         /TiD2XOeLCaE0WGSXkGBTfuZsJCXdzVeA7kH5CFIqgUTv7FN1RA1nfYzdmWRUVzG5Q8y
         KV6FFQDUJ7dg0wEJv1flLWEhccsnbrXT6iMciISQ8Oz4VEvtuMk5E43vH0Jp3TG/CP9r
         QO8fJoxiuVrhr6zQCLgObqpT/4rspVJKM+7cTsW4J2f+wVqG4/ADVT8L8GMX+m8x8Vdv
         5bT+3DfcLZi081IuMOxDko8EnURwaqoNR6DjXY5p/6Ojhv8yenDJbdKz+rLHfxj+WBSr
         3OeQ==
X-Gm-Message-State: APjAAAXL40GyOe1IErkSdF3NlLdOOthJedrSHZP9nz5JzQxqoIvPA3MR
        RyyLAMrgMYuxuNhIarAvfPPJfg==
X-Google-Smtp-Source: APXvYqwGMkQyRGWbisciu/rJbahasoESOgS7WFYgZZNlvWfCJRYa6aMtywa8svInvMnFMszi6MH1mg==
X-Received: by 2002:a63:dc41:: with SMTP id f1mr14067497pgj.119.1576437625797;
        Sun, 15 Dec 2019 11:20:25 -0800 (PST)
Received: from hermes.lan (204-195-22-127.wavecable.com. [204.195.22.127])
        by smtp.gmail.com with ESMTPSA id d77sm20483423pfd.126.2019.12.15.11.20.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 15 Dec 2019 11:20:25 -0800 (PST)
Date:   Sun, 15 Dec 2019 11:20:17 -0800
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Aditya Pakki <pakki001@umn.edu>
Cc:     kjlu@umn.edu, "David S. Miller" <davem@davemloft.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Markus Elfring <elfring@users.sourceforge.net>,
        Richard Fontana <rfontana@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] hdlcdrv: replace assertion with recovery code
Message-ID: <20191215112017.07502383@hermes.lan>
In-Reply-To: <20191215175842.30767-1-pakki001@umn.edu>
References: <20191215175842.30767-1-pakki001@umn.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 15 Dec 2019 11:58:41 -0600
Aditya Pakki <pakki001@umn.edu> wrote:

> In hdlcdrv_register, failure to register the driver causes a crash.
> However, by returning the error to the caller in case ops is NULL
> can avoid the crash. The patch fixes this issue.
> 
> Signed-off-by: Aditya Pakki <pakki001@umn.edu>
> ---
>  drivers/net/hamradio/hdlcdrv.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/net/hamradio/hdlcdrv.c b/drivers/net/hamradio/hdlcdrv.c
> index df495b5595f5..38e5d1e54800 100644
> --- a/drivers/net/hamradio/hdlcdrv.c
> +++ b/drivers/net/hamradio/hdlcdrv.c
> @@ -687,7 +687,8 @@ struct net_device *hdlcdrv_register(const struct hdlcdrv_ops *ops,
>  	struct hdlcdrv_state *s;h
>  	int err;
>  
> -	BUG_ON(ops == NULL);
> +	if (!ops)
> +		return ERR_PTR(-EINVAL);
>  
>  	if (privsize < sizeof(struct hdlcdrv_state))
>  		privsize = sizeof(struct hdlcdrv_state);

It is good to remove BUG_ON's but this is not a good way to fix it.
The original code was being over paranoid.  There are only 3 places
this function is called in the current kernel and all pass a valid
pointer.  Better just remove the BUG_ON all together; it is not
worth carrying bug checks for "some day somebody might add broken code".
