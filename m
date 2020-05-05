Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 06DCD1C4CA7
	for <lists+netdev@lfdr.de>; Tue,  5 May 2020 05:24:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727892AbgEEDYp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 May 2020 23:24:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60284 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726345AbgEEDYo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 May 2020 23:24:44 -0400
Received: from mail-pj1-x1041.google.com (mail-pj1-x1041.google.com [IPv6:2607:f8b0:4864:20::1041])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8DF3BC061A0F
        for <netdev@vger.kernel.org>; Mon,  4 May 2020 20:24:44 -0700 (PDT)
Received: by mail-pj1-x1041.google.com with SMTP id a5so403986pjh.2
        for <netdev@vger.kernel.org>; Mon, 04 May 2020 20:24:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=/m3VPQKLznb5MM6hUBd8eqsU+akNCDrSEyiSzmBap4c=;
        b=hVzPj5x8BhZ53xNGU5o06hcWIsf6sifeW+ifhinxCsSfuXzk61XHZPo8+sETnSg9L7
         l+Vbe5e8TL5YC2seFdeX4Z0H/8ut963/rt0Jyb2vxtLqf+iuYWD9q4S3GIXcJZxt11gr
         aM/8O5699trwt8JMzBiTLuSnuoISxmlyyLaeece2XuOh7JE9ck9EoU/gOlly0jfLKVW9
         LhVOnrcOM2vy6NU7IemJNW/keyS+2dcDtEl6hJ/sI0fVTVpIWR13vBxpBzlr16MyXc+D
         19Y2xuQacf0kuNR9Kyq/d+DY/FZzI8zsYgpObQym+A9SNtQquiSSZLdQdjuY8tr6ISF3
         NeAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=/m3VPQKLznb5MM6hUBd8eqsU+akNCDrSEyiSzmBap4c=;
        b=dmxeUReN9n6POoD0duUK/AVB43iuXRFCl1Bl1xoE83BfCYDWDcD4H8oV8BJI8MTMDe
         JDuUOa0p7rcFDTkQYMheyjXeDzebMPx+yEjh9KbaH4DxgNxd1Fc0/XV8KrP6Yf/4W0Hp
         9JZFLbhB5O2F0sq4AqFqWW25ZYa408ujZ/UllzvLwjzEs2K27ghADJWLXCyTMqlPcSyk
         mJMCyiXLS8Dk7VaNN80XBHO74lZUyL8DgNRKwSzRcO/8v+X2REu3YsxrdVCZTwLxk1cu
         gfZWGvulQbKM01ooD3JRB1GV+nor1n17+PxN0XH3aopOG+vOI0GHoserilZILS7sst0D
         4rOw==
X-Gm-Message-State: AGi0PuZ0OjB1JAJ4u6Jf9TScq5UYSohIXNMGcfVDFLP+gmm+j8WvCJLw
        wwOiFW8W/lrX6k7JMSUjCn4=
X-Google-Smtp-Source: APiQypIFw1eRe5GO5RyIrL8B9IQOUOKkfk0eRnNHXlWWg3W+iv4sGkOAR67juxNQWeVR0tcowBLm1g==
X-Received: by 2002:a17:902:bb82:: with SMTP id m2mr822860pls.291.1588649084125;
        Mon, 04 May 2020 20:24:44 -0700 (PDT)
Received: from [192.168.1.3] (ip68-111-84-250.oc.oc.cox.net. [68.111.84.250])
        by smtp.gmail.com with ESMTPSA id y10sm519539pfb.53.2020.05.04.20.24.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 04 May 2020 20:24:43 -0700 (PDT)
Subject: Re: [PATCH net-next v2 09/10] net: phy: Put interface into oper
 testing during cable test
To:     Andrew Lunn <andrew@lunn.ch>, David Miller <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Chris Healy <cphealy@gmail.com>,
        Michal Kubecek <mkubecek@suse.cz>, michael@walle.cc
References: <20200505001821.208534-1-andrew@lunn.ch>
 <20200505001821.208534-10-andrew@lunn.ch>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <4167d927-9853-bf06-4add-e51fee3d5726@gmail.com>
Date:   Mon, 4 May 2020 20:24:42 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Firefox/68.0 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <20200505001821.208534-10-andrew@lunn.ch>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 5/4/2020 5:18 PM, Andrew Lunn wrote:
> Since running a cable test is disruptive, put the interface into
> operative state testing while the test is running.
> 
> Signed-off-by: Andrew Lunn <andrew@lunn.ch>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
