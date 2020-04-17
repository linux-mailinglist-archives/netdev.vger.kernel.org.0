Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8EE671AE5DD
	for <lists+netdev@lfdr.de>; Fri, 17 Apr 2020 21:34:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730457AbgDQTej (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Apr 2020 15:34:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54476 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728826AbgDQTei (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Apr 2020 15:34:38 -0400
Received: from mail-pj1-x1043.google.com (mail-pj1-x1043.google.com [IPv6:2607:f8b0:4864:20::1043])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C404C061A0C;
        Fri, 17 Apr 2020 12:34:38 -0700 (PDT)
Received: by mail-pj1-x1043.google.com with SMTP id ms17so1493965pjb.0;
        Fri, 17 Apr 2020 12:34:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=tQnh9bMknhmK0SLjhY8GYeOkFSZfOfpp0SuxWOSDDX0=;
        b=IMMzb43Rae3Ny+NkzukzwSVkTodIPkm8EK9cG6V+/8cgcsYlezidqynTgJB7haepXz
         NNx7KxIuli5YAMPp1VzJVr37tuXzI7G3C9T53REH+Qyp4UJ6z2DzXKGu/HZSSqKlJhpC
         XpR2Z0CweEAMPGJeivq90NuYlb33XbXjbrWG6tyTQYSvWH07N8sxr4gh+zoOMIecba3Y
         5M+cKgkVYpyO3gT3TE3Bh602GSfWtRG14NDrsDp2AGkg5OwzZ4Mt7Xg+WVkjkiATfVi8
         5SVfpbUOPFE/NNEzDYeCj2DGcG8DoDFRoHH7taWk4CKhBfpp9JCuXdkINa5yJYTxeBPB
         5sHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=tQnh9bMknhmK0SLjhY8GYeOkFSZfOfpp0SuxWOSDDX0=;
        b=MXJ7oKaX0zzs7f6VlraEHhgNIHqSm+vWRDIjZnS4Sglcd+zE9F2B+D7ekjV7EiFBrZ
         O+AWTZZVyTlLeWqKAXSvTZaBP11vsAmUTRKQgKxbzSeu2AhYrzrPqK3Kef+Ew+xn7kIa
         178U6VW9Roa2za3g4vhhDQsx+Jo2LD1Kvw9ZGqsFHI2wILZupW37Mwz2m3/2V8nSRXq1
         PP8CF7hvn9xgLjmIrMdvIpagKttr+TEZ7R09m8wbKl9SMu9DN0beXFlxFrwSqNJBGjYm
         I39n34pDkYeBVSqdrq26dNsqqPgnc6Rb9nq/HPKmUaK3W/OCVh525ntVJShNw23bw0S7
         HTaA==
X-Gm-Message-State: AGi0Pua8KoojXhY97l+RdEuW1MKHXE16a5TkKXdAc7zRWuDDkwrMbbI0
        wv9KDdbQN2YAP0YdjHCwDvY=
X-Google-Smtp-Source: APiQypIL6KyowX9unVOk4wA2Mdi6nQNAg2BioJEZe34qxKKWZRXAypJ+sBFiBKMg3329barooUFNBA==
X-Received: by 2002:a17:902:d70f:: with SMTP id w15mr5027642ply.138.1587152077669;
        Fri, 17 Apr 2020 12:34:37 -0700 (PDT)
Received: from [10.230.188.26] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id g22sm6299187pju.21.2020.04.17.12.34.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 17 Apr 2020 12:34:36 -0700 (PDT)
Subject: Re: [PATCH net-next 1/3] net: phy: broadcom: add helper to write/read
 RDB registers
To:     Michael Walle <michael@walle.cc>, linux-hwmon@vger.kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Cc:     Jean Delvare <jdelvare@suse.com>,
        Guenter Roeck <linux@roeck-us.net>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S . Miller" <davem@davemloft.net>
References: <20200417192858.6997-1-michael@walle.cc>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <ddc9c4e1-0bbb-a058-be70-e6cb772271da@gmail.com>
Date:   Fri, 17 Apr 2020 12:34:34 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Firefox/68.0 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <20200417192858.6997-1-michael@walle.cc>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 4/17/2020 12:28 PM, Michael Walle wrote:
> RDB regsiters are used on newer Broadcom PHYs. Add helper to read, write
> and modify these registers.

Only if you have to respin: please correct the typo above: regsiters vs. 
registers.

> 
> Signed-off-by: Michael Walle <michael@walle.cc>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
