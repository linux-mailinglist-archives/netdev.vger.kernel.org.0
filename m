Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 981083567A
	for <lists+netdev@lfdr.de>; Wed,  5 Jun 2019 07:57:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726407AbfFEF5t (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Jun 2019 01:57:49 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:50813 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725268AbfFEF5t (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Jun 2019 01:57:49 -0400
Received: by mail-wm1-f65.google.com with SMTP id f204so920918wme.0
        for <netdev@vger.kernel.org>; Tue, 04 Jun 2019 22:57:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=DA/gHQEskkU0upcOS5+E5efHOYupq+ZEpDFft7GQELg=;
        b=aGRg/Abwd39zaE696uZHGtsY0KadyB6m5rLR9LHXSCc0BD2rfBlcxZf/aijCsmDAKf
         aaqyByJRALd7rhALfHwbwrx3ygJJ1QGcS0N2OMGCoNQ6yCkLWgDtkReIOsOj+paBjvdJ
         GbM26HL5OXyYMswzp60CF6+36xnHb7H7ki+NUG7O43kanUidTlWU774M9Y02nbCrYuaA
         G49F0y5hvQKnr2rnqchkUIP01PR+D2NTzf5lgikzwzcjbV4r6RlUafbGg/sRBGsGa4qE
         9Z06ll09AKDAKI9+5t+vlmCXACtK94fKEaaSymhARLg0YUcvo2fQroL+JIrJxhGAS4IN
         GCow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=DA/gHQEskkU0upcOS5+E5efHOYupq+ZEpDFft7GQELg=;
        b=XSiE1caDnwBsxG2RKWrSzz4u9GWL5FGHVADANlBBruBZqz7AFGpAkkpdCkDzBZEvKb
         +nkCgHAUSVVszMusNHamTk5wgHsB5xi+BLNgmR1/ZJbePsAXMp+u+ieCx50tnkQ+rr3I
         iKJp+2OKPhvojOuaVeGpqGi3r1d3Pybw7MbqJ35OraxX7tcymf5SldHCJsiYVqn/oyIR
         dmhWBc0/Krr3at3Q+ODL7IrBoQRSJoAGL4XpkesKpXU4LpiB2pKWBdYKfMINVYy7Sh1O
         Hsvt2dVvlkTEx7bfJuG6KKMZWCvcqLuDpr7TVPQ1qxKJcXDQt8zAHinFL62qQQ4bayNZ
         bXPA==
X-Gm-Message-State: APjAAAVKM7ZnOuNcUyVZ/oxpyGyXf1WmISARNmbN8ldkT1NwkqcHN/8i
        xG+HYEVdGrUOKmXSJGqVuZXW1GCF
X-Google-Smtp-Source: APXvYqys8SjCk0faa9XlRT/srvjOZGKSiBQcEI5LWzb1wTUUMz+STchJrRl8Pi6YMMF6494VgtKTgQ==
X-Received: by 2002:a7b:c748:: with SMTP id w8mr8247654wmk.36.1559714267182;
        Tue, 04 Jun 2019 22:57:47 -0700 (PDT)
Received: from ?IPv6:2003:ea:8bf3:bd00:8871:c3cd:95c8:45d1? (p200300EA8BF3BD008871C3CD95C845D1.dip0.t-ipconnect.de. [2003:ea:8bf3:bd00:8871:c3cd:95c8:45d1])
        by smtp.googlemail.com with ESMTPSA id n4sm17579715wrp.61.2019.06.04.22.57.46
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 04 Jun 2019 22:57:46 -0700 (PDT)
Subject: Re: [PATCH net-next 0/2] r8169: factor out firmware handling
To:     David Miller <davem@davemloft.net>
Cc:     nic_swsd@realtek.com, netdev@vger.kernel.org
References: <3e2e0491-8b0f-17e1-b163-e47fcb931eb5@gmail.com>
 <20190604.193553.2005995029161038338.davem@davemloft.net>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Message-ID: <a3990c4d-ae69-9e23-bcd0-a554cb020985@gmail.com>
Date:   Wed, 5 Jun 2019 07:57:37 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <20190604.193553.2005995029161038338.davem@davemloft.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 05.06.2019 04:35, David Miller wrote:
> From: Heiner Kallweit <hkallweit1@gmail.com>
> Date: Tue, 4 Jun 2019 07:44:53 +0200
> 
>> Let's factor out firmware handling into a separate source code file.
>> This simplifies reading the code and makes clearer what the interface
>> between driver and firmware handling is.
> 
> This doesn't apply cleanly to net-next, specifically the hunks that move code
> out of r8169_main.c
> 
Ah, sorry. Will check and resubmit.
