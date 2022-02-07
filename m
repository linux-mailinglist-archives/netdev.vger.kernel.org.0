Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 13FC54ACB01
	for <lists+netdev@lfdr.de>; Mon,  7 Feb 2022 22:13:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237328AbiBGVNM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Feb 2022 16:13:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41604 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235998AbiBGVNL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Feb 2022 16:13:11 -0500
Received: from mail-ed1-x535.google.com (mail-ed1-x535.google.com [IPv6:2a00:1450:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 09DFDC06173B;
        Mon,  7 Feb 2022 13:13:11 -0800 (PST)
Received: by mail-ed1-x535.google.com with SMTP id l25so12550369eda.12;
        Mon, 07 Feb 2022 13:13:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=zT3oKzS7n7TI0D8XaL63jjRHo7FI4UGfj4YRLtEmDxg=;
        b=QR4Jc2mIcnWKHiYdoFEJ5zevhFJyEliAI5KBqZrUbY9rLUnmJuFmL5mMzVoJQveBx6
         bQKjeiAEyGGkvvKddmCr4S0JElAz3tca5rUbg9We0fHqb6MJhOU3cbspzMY7eP5q3VSv
         o73vYEdAF5+amj8IL/ESmg3zp2/x6vzygRMHArv14zYwJsjV/z+qZDGo04DAUZEt7TQd
         5q3hEJf/+LcyDZG2f556d1kDc8HVzfvkdYmTUtYi/PtpFDb+zdv32TgeFqvgB0slNyHb
         gPv40errXwoy706jxPdyeF8dAh3O2tPaKh7Iwga0jwATcDdGGJR0Fps0AfOmnEIO4Ccf
         6UJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=zT3oKzS7n7TI0D8XaL63jjRHo7FI4UGfj4YRLtEmDxg=;
        b=ikGdHmzinLGnY385TcpwaA+lPnsNXo6KkctiR0js8RBGuMWlegb5RE5BEn2F/hgwy9
         MHtT5XI9yl3csswLJilozlziXqUtRmildx3vzy5cBMRaQQM17SJk6qCthBaARvzxYJ7y
         A/Dq4oGxxTffDWHzQqqJq7cu+ZrH3jIpZsGUrimDnYVVJpeVZGESJ+R8qBv8p2FuPMtk
         C6DAxmP30+cGV7zZJNXxf1uo1YqtL/9CcCJMmxZQXYc2TcYzG51JgPhTEuS3HLo0LaIC
         GpD0/pX/CsIgiGwYrPw0DymEBClIkDSIHbyhywGmSD+Ck9KFCmaqk/ZM3rs/FmL9pFQn
         lRRw==
X-Gm-Message-State: AOAM530iHn7zNw9naD+t+fsplVwqCvucZBFTRtKF38cR5DhIIztJaFY8
        ItRHgz7/Jx5Xh5tvwVXk+xJqBN66M7c=
X-Google-Smtp-Source: ABdhPJwCC1iS4UP4hrkX15xYRf3fNO8oBBK+NyVHs/d2yncCD2u4zkXVuzWYG4uaZpq0AanrIwNZmg==
X-Received: by 2002:a05:6402:254a:: with SMTP id l10mr1340361edb.318.1644268389476;
        Mon, 07 Feb 2022 13:13:09 -0800 (PST)
Received: from debian64.daheim (pd9e292b6.dip0.t-ipconnect.de. [217.226.146.182])
        by smtp.gmail.com with ESMTPSA id z6sm4058135ejd.96.2022.02.07.13.13.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Feb 2022 13:13:08 -0800 (PST)
Received: from localhost.daheim ([127.0.0.1])
        by debian64.daheim with esmtp (Exim 4.95)
        (envelope-from <chunkeey@gmail.com>)
        id 1nHAN7-001CUZ-Os;
        Mon, 07 Feb 2022 22:13:08 +0100
Message-ID: <feb446cd-e935-6fc4-7f3c-d7ab21d18d8e@gmail.com>
Date:   Mon, 7 Feb 2022 22:13:08 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.1
Subject: Re: [BUG] intersil: p54: possible deadlock in p54_remove_interface()
 and p54_stop()
Content-Language: en-US
To:     Jia-Ju Bai <baijiaju1990@gmail.com>, chunkeey@googlemail.com,
        kvalo@kernel.org, davem@davemloft.net, kuba@kernel.org
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <fb543659-f69d-242f-b18a-69dd8b8b5ca1@gmail.com>
From:   Christian Lamparter <chunkeey@gmail.com>
In-Reply-To: <fb543659-f69d-242f-b18a-69dd8b8b5ca1@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On 07/02/2022 16:31, Jia-Ju Bai wrote:
> Hello,
> 
> My static analysis tool reports a possible deadlock in the p54 driver in Linux 5.16:
> 
> p54_remove_interface()
>    mutex_lock(&priv->conf_mutex); --> Line 262 (Lock A)
> wait_for_completion_interruptible_timeout(&priv->beacon_comp, HZ); --> Line 271 (Wait X)
> 
> p54_stop()
>    mutex_lock(&priv->conf_mutex); --> Line 208 (Lock A)
>    p54p_stop() (call via priv->stop)
>      p54_free_skb()
>        p54_tx_qos_accounting_free()
>          complete(&priv->beacon_comp); --> Line 230 (Wake X)
> 
> When p54_remove_interface() is executed, "Wait X" is performed by holding "Lock A". 
> If p54_stop() is executed at this time, "Wake X" cannot be performed to wake 
> up "Wait X" in p54_remove_interface(), because "Lock A" has been already hold by
> p54_remove_interface(), causing a possible deadlock.
>
> I find that "Wait X" is performed with a timeout, to relieve the possible deadlock;
> but I think this timeout can cause inefficient execution.
> 
> I am not quite sure whether this possible problem is real and how to fix it if it is real.
> Any feedback would be appreciated, thanks :)

This has been such a long long time ago. But I think I found
the right documentation entry for you:

<https://www.kernel.org/doc/html/v5.16/driver-api/80211/mac80211.html> (scroll down a bit)
| remove_interface
| 	Notifies a driver that an interface is going down.
| 	>>The stop callback is called after this if it is the last interface
|	and no monitor interfaces are present.<<
|	(it goes on a bit. But I don't think there's anything important left)

The documentation tells you not to worry. p54_stop() and p54_remove_interface()
are being serialized by mac80211.

Cheers,
Christian
