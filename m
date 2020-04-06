Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B8D3C19FD65
	for <lists+netdev@lfdr.de>; Mon,  6 Apr 2020 20:45:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726331AbgDFSp1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Apr 2020 14:45:27 -0400
Received: from mail-pg1-f196.google.com ([209.85.215.196]:34026 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725876AbgDFSp1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Apr 2020 14:45:27 -0400
Received: by mail-pg1-f196.google.com with SMTP id l14so428689pgb.1;
        Mon, 06 Apr 2020 11:45:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=/1DPYFqAeGE+UCkdCXoyPwx1w0eifFPE8zzU1CMzhOQ=;
        b=hKWwlFiDELsryAnxzd68vIeOzEQrdoqEl+IlUclRCJCQFqwobsWYl7DAEz5sTUgHev
         5WYzJRLB4rmo3X1+ChPvAkQZNyYo5OK81AxbYTgBhFzjhBTPHJC+8mOuhjc/0IWVi9ZH
         c5aKR1HP/j6hheiTxmN+hE3TBNdU4/FCHRrUP5cz/uZ1NH6EAN0H+Iduo9Lgippyduq+
         sRc5jt6pN41X16LBSrA89cba6n9cB7yP4rUkjUnmDZA11SeVlxach34+KwjK+Oor1LwT
         tKh4dw14UKLG3eGVxDZmtsQkt30lgXiNI6eoMvFCsKRsfp3pEvpHTJqzxSUGvx9qQ+e9
         MSuA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=/1DPYFqAeGE+UCkdCXoyPwx1w0eifFPE8zzU1CMzhOQ=;
        b=a0WOm3jaaqx0yLyj3mqHe/tz2ER2gn5mOyssv8e1DpnAGhmdfO6Nu8az6NN+9TS2kv
         gWs9XhP3zvoIaDyZkxc24LhTFR4R73rxkT8Lvzb3IKlloYbZ2MYoxDyC35B5qwel6Lpi
         ED2cBzjP4WMR29D+0D0z4lMI2PoxEMVX6F179yAT8QiNJxz+z/h4PROhHl2ysQGrGgWQ
         5C4wg3qrISMUD5tZPZS8e9SCAE/ZXD2UHApPI7qgzjZQDxoMDm9oBtPRCGe/tf+IebtN
         rPZRndY3bTGDbGl8j3wOG4ToJVu+FTsb8Y1N+mL7z5kechXxN7e8SVxp+tjTGKoDnPL8
         4Tig==
X-Gm-Message-State: AGi0PubiDG+Jm8646n2ed4vnv+7WLn+6KXgyB/GYetdvDP/Sc2zZ9ltF
        RU3gebaytyW/DEQsn/tLNZg=
X-Google-Smtp-Source: APiQypJyK7NUWrU47DEl6MuoqEoOTtj5ngNdJjMv97JA9OlH+gVQKnSW2c9KY9p3WwSdiMBgntXRPg==
X-Received: by 2002:a63:5023:: with SMTP id e35mr467624pgb.165.1586198726005;
        Mon, 06 Apr 2020 11:45:26 -0700 (PDT)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id h15sm12193700pfq.10.2020.04.06.11.45.24
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 06 Apr 2020 11:45:25 -0700 (PDT)
Date:   Mon, 6 Apr 2020 11:45:23 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Marcel Holtmann <marcel@holtmann.org>
Cc:     Sonny Sasaka <sonnysasaka@chromium.org>,
        Alain Michaud <alainmichaud@google.com>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        BlueZ <linux-bluetooth@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Bluetooth: Simplify / fix return values from tk_request
Message-ID: <20200406184523.GA49680@roeck-us.net>
References: <20200403150236.74232-1-linux@roeck-us.net>
 <CALWDO_WK2Vcq+92isabfsn8+=0UPoexF4pxbnEcJJPGas62-yw@mail.gmail.com>
 <0f0ea237-5976-e56f-cd31-96b76bb03254@roeck-us.net>
 <6456552C-5910-4D77-9607-14D9D1FA38FD@holtmann.org>
 <CAOxioNneH_wieg39xLyBHb_E12LXiAm-uZBqvt3brdoQr0c7XQ@mail.gmail.com>
 <40C87EEE-BE73-4B32-91AD-480112B9A2F4@holtmann.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <40C87EEE-BE73-4B32-91AD-480112B9A2F4@holtmann.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Apr 06, 2020 at 08:26:55PM +0200, Marcel Holtmann wrote:
> Hi Sonny,
> 
> > Can this patch be merged? Or do you prefer reverting the original
> > patch and relanding it together with the fix?
> 
> since the original patch is already upstream, I need a patch with Fixes etc. And a Reviewed-By from you preferably.
> 

Isn't that what I sent with https://patchwork.kernel.org/patch/11472991/ ?
What is missing (besides Sonny's Reviewed-by: tag) ?

Thanks,
Guenter
