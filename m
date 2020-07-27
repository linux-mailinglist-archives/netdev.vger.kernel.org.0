Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C760722F92F
	for <lists+netdev@lfdr.de>; Mon, 27 Jul 2020 21:37:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728408AbgG0ThY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jul 2020 15:37:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58220 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726139AbgG0ThY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Jul 2020 15:37:24 -0400
Received: from mail-pg1-x543.google.com (mail-pg1-x543.google.com [IPv6:2607:f8b0:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F99FC061794;
        Mon, 27 Jul 2020 12:37:24 -0700 (PDT)
Received: by mail-pg1-x543.google.com with SMTP id g67so10480031pgc.8;
        Mon, 27 Jul 2020 12:37:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=2L+TQ66njkseoRALpENSKdBKaqcZldzm1sijdwKkLEY=;
        b=JuZcSv5KcEHcRpMn3Sfg9eeVSCueFpQ8h/HTUrB51tAE6uau9HurS98P4mNy82WpFy
         AjWu/QP+Tr9aE1XB8QTSwK3XgZXPFoc9wdJQ/MFHuW0oaZuel/nbWfTNzaKMsmlQ14GO
         Ryw5O3rsSaaJt74eraIPH42EcjQSY7vXBTFUNfujQ42BcU+1YxiYuo+62kbOLeP9ji8v
         /O9FwnCk0dsbZ0K2vSaG4fe219VfYfS1HD7WAUEfGb3mQzx/TaIy94qDHpIuzL69cn6U
         tsa7FukW9ZxFDekRT48IymJYOFCiPIMmQUW9QqTTDAGCGbLBGArV/Y4hsj+bi03ZBr4u
         cD5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=2L+TQ66njkseoRALpENSKdBKaqcZldzm1sijdwKkLEY=;
        b=gJt0lX2Np7u68bCzmHc/vGg1TfwBFLYFyTgfJUHzgj8dcV9WIno63ymPMSqsIlijuz
         317/d5hamTQlyHivnV2QbO/2ZcYQjH4/0+BRtg4S2+/WFRr7lIYxGd36bDCEL9AJZe1X
         +DlCoo41hFVqyQGG7V9X9PyCha5MltTcna1WK1sxjlrrze3QQDtKLxR9Y0Z+s9inUhYd
         TkulUkIhi8kqql8XG7r426TUKoUYhTQkM7AFegcdeCgw0/DmqXbKD5XRnV1CcaaJwa83
         MaeckZolEU3avU3eHXbjbK27KS/HZi451MlDOebulf3fT/f1X8ZzZLQoqvQkKzG21fCO
         kLhA==
X-Gm-Message-State: AOAM531Nwzl6jUm2DqAdWiFHU4gMVtbVGAb1JA2yGmdi8xv1Uovx5c7H
        RMDAe9f9MnGhyPjcFW/G0Ms=
X-Google-Smtp-Source: ABdhPJzCSriqvByXiMJlX7vlc3TfHwPRuYltXmLIZpcamaogZIj3rIz6UBMx2BYSPvPUH3Vpp8mIJw==
X-Received: by 2002:a63:e556:: with SMTP id z22mr21033754pgj.130.1595878643660;
        Mon, 27 Jul 2020 12:37:23 -0700 (PDT)
Received: from [10.1.10.11] (c-73-241-150-58.hsd1.ca.comcast.net. [73.241.150.58])
        by smtp.gmail.com with ESMTPSA id lt17sm400055pjb.6.2020.07.27.12.37.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 27 Jul 2020 12:37:23 -0700 (PDT)
Subject: Re: UDP data corruption in v4.4
To:     Dexuan Cui <decui@microsoft.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Greg KH <greg@kroah.com>, Al Viro <viro@zeniv.linux.org.uk>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>, Willy Tarreau <w@1wt.eu>,
        Joseph Salisbury <Joseph.Salisbury@microsoft.com>,
        Michael Kelley <mikelley@microsoft.com>
References: <KL1P15301MB028018F5C84C618BF7628045BF740@KL1P15301MB0280.APCP153.PROD.OUTLOOK.COM>
 <20200725055840.GD1047853@kroah.com>
 <KL1P15301MB02800FAB6F40F03FD4349E0ABF720@KL1P15301MB0280.APCP153.PROD.OUTLOOK.COM>
 <CANn89i+JPamwsU-22oBTU-8HC+e6oxtQU+QgiO=-S1ZmrkGvtg@mail.gmail.com>
 <KL1P15301MB0280926949A1180B671CA516BF720@KL1P15301MB0280.APCP153.PROD.OUTLOOK.COM>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <5cbd979d-8e9e-804c-cb68-18c808e7e08e@gmail.com>
Date:   Mon, 27 Jul 2020 12:37:21 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <KL1P15301MB0280926949A1180B671CA516BF720@KL1P15301MB0280.APCP153.PROD.OUTLOOK.COM>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 7/27/20 11:57 AM, Dexuan Cui wrote:
>> From: Eric Dumazet <edumazet@google.com>

> Oh, yes! :-) Thank you!
> 
> Eric, I'll add your Signed-off-by and mine. Please let me know in case
> this is not ok.

Sure, do not worry about this.

> 
> I'll do a little more testing with the patch and I plan to post the patch
> to stable@vger.kernel.org and netdev@vger.kernel.org this afternoon,
> i.e. in 3~4 hours or so. 
> 
> Thanks,
> -- Dexuan
> 
