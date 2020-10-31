Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D05CC2A1AB5
	for <lists+netdev@lfdr.de>; Sat, 31 Oct 2020 22:31:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728523AbgJaVbp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 31 Oct 2020 17:31:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39520 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726254AbgJaVbo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 31 Oct 2020 17:31:44 -0400
Received: from mail-pf1-x443.google.com (mail-pf1-x443.google.com [IPv6:2607:f8b0:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C6CB5C0617A6;
        Sat, 31 Oct 2020 14:31:44 -0700 (PDT)
Received: by mail-pf1-x443.google.com with SMTP id c20so7903758pfr.8;
        Sat, 31 Oct 2020 14:31:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding:content-language;
        bh=RCKrBdi/cuSwF+6eSqklRGXkPD1B4n+vjLH1fafi1Qg=;
        b=vWCONXYnUidMTCnGsyyuztaQpLNmqARfQJ2C/VrYifLJhCv0ExU4LHwl4x1PDDJW52
         aEDwrl+chZ+M4q2Fz3jSdvjrMu6MEtHbRBnI2q+Udub9vnLkD/w//X13eeed6WFBfnWa
         g3fpby3wVcwVlXlIBszHnmW5jLA5sfMM8uwaVj/X5SfQhh5zA+BVQgH6m5rfFn10K1Y5
         8PeFxiyoB0u8cf9q9DE2RWOyYCAg9AWjfX1Tfa4hgGwaVH7sIqXL37/rU0ce9E/YKBEJ
         qYSLiJ98ytk7J2BJMatoI7lwBJLuS9ZIZ9KRRiXqESTbPXkfSJa2RkBefDCMfuJ+Nup5
         iqOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=RCKrBdi/cuSwF+6eSqklRGXkPD1B4n+vjLH1fafi1Qg=;
        b=Z94+NNgsXdZZ23dC+jVD9UZR969QlCVy3W6LwZ7JZ7HSrr1g35Sn3fx76W/gzOptfr
         90PZQ6WR3rcRRpZP0Q5j33xOXlW0T+Vw+7qme4bjCMlosllg2JvnJFcNTuW5GRcT9aAN
         i+ZEwqkJIKZk1hM7iytvT9vnvvrOdaboglrO72Hk3DyvOIrmk77Qb9j3ghIKpghkD6V4
         e4pbMgigZBifwZd9ecL/RVGPV81eh0HZMtV5wd7PzZJclKoWZ9tQw1RNpS18Cqz6Tm3o
         IplmALlEYuA+EJ9RzXOrXas3rL2J1Gp+OaKqVj7zUkgT6QmhVGentnreqmvZMANg29O4
         THfw==
X-Gm-Message-State: AOAM530RdekjCwQNFqyF+tEN4rOlK5a4ps4GuuNLUf8/I1bryS0uJJtI
        Ei7F8l94nZEpJdqANkbDRfI=
X-Google-Smtp-Source: ABdhPJxoDqQlWCNGptgKYg0kKtOKxYD8uHOWpgQjtzMSrZJQccWOXnL0yAGVDp9mamOeM66SCupGPw==
X-Received: by 2002:aa7:989a:0:b029:18a:8d62:e024 with SMTP id r26-20020aa7989a0000b029018a8d62e024mr6251979pfl.71.1604179904084;
        Sat, 31 Oct 2020 14:31:44 -0700 (PDT)
Received: from [192.168.0.104] ([49.207.221.93])
        by smtp.gmail.com with ESMTPSA id s38sm8818573pgm.62.2020.10.31.14.31.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 31 Oct 2020 14:31:43 -0700 (PDT)
Subject: Re: [PATCH v2] net: usb: usbnet: update __usbnet_{read|write}_cmd()
 to use new API
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Oliver Neukum <oneukum@suse.com>,
        "David S . Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-kernel-mentees@lists.linuxfoundation.org
References: <20201010065623.10189-1-anant.thazhemadam@gmail.com>
 <20201029132256.11793-1-anant.thazhemadam@gmail.com>
 <20201031141143.5c8463e1@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
From:   Anant Thazhemadam <anant.thazhemadam@gmail.com>
Message-ID: <f31767d8-cb06-f5cb-bd48-5822d12132c2@gmail.com>
Date:   Sun, 1 Nov 2020 03:01:39 +0530
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20201031141143.5c8463e1@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 01/11/20 2:41 am, Jakub Kicinski wrote:
> On Thu, 29 Oct 2020 18:52:56 +0530 Anant Thazhemadam wrote:
>> +	return usb_control_msg_recv(dev->udev, 0,
>> +			      cmd, reqtype, value, index, data, size,
>> +			      USB_CTRL_GET_TIMEOUT, GFP_KERNEL);
> Please align continuation lines after the opening bracket.

I will do that, and send in a v3 right away.

Thanks,
Anant

