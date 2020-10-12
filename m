Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F287828AB83
	for <lists+netdev@lfdr.de>; Mon, 12 Oct 2020 03:49:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727526AbgJLBtW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 11 Oct 2020 21:49:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34100 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726430AbgJLBtV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 11 Oct 2020 21:49:21 -0400
Received: from mail-pg1-x541.google.com (mail-pg1-x541.google.com [IPv6:2607:f8b0:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BBDC4C0613CE;
        Sun, 11 Oct 2020 18:49:21 -0700 (PDT)
Received: by mail-pg1-x541.google.com with SMTP id q21so1556062pgi.13;
        Sun, 11 Oct 2020 18:49:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=rIbb0/SViFEAq3N3skmCoQu+YzgDQ+YxSiq/Tk6Jyjs=;
        b=YatStj6JeisBAbir+YmU7Y5u3EZpGBGxbKaXAmw1CVHxTUc6NcIKpPqjbiRhurBwTi
         9+/cysSBOniaSGTCjhfXMLOFLQ1wQHQuw0bdIqd4Z92Hmkv4PL0lszVvOvrbEK8jdOkM
         sA5idgF+CcK58S1mlBzS4oJwDDX/f16/4ock0VZbnFal3wyWoA5qrRNDCgtEhlIsPcBD
         fksa9vLGqLi7PndXJtXuZSSbdTIf92YYTPLiTcG0/O/6uOE+/2R7TEDcX6qaOK7xBobz
         /I2Q4ZfZKhD18n2wf2Qb8rrn+HxwwIF7YwWylf6De1dZ0XhJo6DjT1h2S1IhR99CK/au
         cOpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=rIbb0/SViFEAq3N3skmCoQu+YzgDQ+YxSiq/Tk6Jyjs=;
        b=P1khmQyt6XcIK9iZBdVMGA5yyOa0thxfr0siejD7Yk/F41QBbFx87amCp4UtaAJKCb
         0/aPWtqmtyFcCsFj9w+OwOTkydmXNG0sL79VGnGNbI4RlEFBJzWXztJjqRdmC5bc930i
         WBC+kYQhbI90l0kShk+DftX11Gtc4DiAyGfUecJQV5wbaSq7w3RSzLAfK7GcfLruGpDg
         HUl5W7HMYgEMS7qHn99Bp0Wt/RrIUWG3AUEkfQvZvClXNxQJjnAF3KaWfiE7N6JAuMDJ
         tvk8lUBpiBP+UCBHnGvW3/UtB8dcoW3+DJbew3bxhXyVoB6yqAPZlwj3KlgaDF/6Eelo
         LaoA==
X-Gm-Message-State: AOAM530FXK9j0TQduaJmK7YMwrrFpIwAewOsBrWcW/v0IbY+CuZtMyJH
        YsxTMVo4Rseag1+C4YaZi9A=
X-Google-Smtp-Source: ABdhPJw4Pe7H9he+gRS6c+vGPBxNBkJ5eYwam9urDtnsK8QiQhWjspuehNW3K1oIiXedZsnV0pVyCw==
X-Received: by 2002:a62:5bc2:0:b029:13e:d13d:a130 with SMTP id p185-20020a625bc20000b029013ed13da130mr21501632pfb.24.1602467361220;
        Sun, 11 Oct 2020 18:49:21 -0700 (PDT)
Received: from [192.168.1.3] (ip68-111-84-250.oc.oc.cox.net. [68.111.84.250])
        by smtp.gmail.com with ESMTPSA id g3sm21133168pjl.6.2020.10.11.18.49.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 11 Oct 2020 18:49:20 -0700 (PDT)
Subject: Re: [PATCH net-next 08/12] net: dsa: use new function
 dev_fetch_sw_netstats
To:     Heiner Kallweit <hkallweit1@gmail.com>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        =?UTF-8?Q?Bj=c3=b8rn_Mork?= <bjorn@mork.no>,
        Oliver Neukum <oneukum@suse.com>,
        Igor Mitsyanko <imitsyanko@quantenna.com>,
        Sergey Matyukevich <geomatsi@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Johannes Berg <johannes@sipsolutions.net>,
        Pravin B Shelar <pshelar@ovn.org>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Herbert Xu <herbert@gondor.apana.org.au>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        linux-rdma@vger.kernel.org,
        Linux USB Mailing List <linux-usb@vger.kernel.org>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        bridge@lists.linux-foundation.org
References: <a46f539e-a54d-7e92-0372-cd96bb280729@gmail.com>
 <4c7b9a8d-caa2-52dd-8973-10f4e2892dd6@gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <44356f33-2191-c5a6-4c38-50c2934d16b0@gmail.com>
Date:   Sun, 11 Oct 2020 18:49:17 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.3.2
MIME-Version: 1.0
In-Reply-To: <4c7b9a8d-caa2-52dd-8973-10f4e2892dd6@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 10/11/2020 12:41 PM, Heiner Kallweit wrote:
> Simplify the code by using new function dev_fetch_sw_netstats().
> 
> Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
