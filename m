Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8DD51EE6E6
	for <lists+netdev@lfdr.de>; Mon,  4 Nov 2019 19:06:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728971AbfKDSGZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Nov 2019 13:06:25 -0500
Received: from mout.gmx.net ([212.227.15.19]:56523 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728012AbfKDSGZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 4 Nov 2019 13:06:25 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1572890760;
        bh=i/YVkRXw1W5UTTmqjVB4l15sajoU6ZqsE7IG48uUlI0=;
        h=X-UI-Sender-Class:Subject:To:Cc:References:From:Date:In-Reply-To;
        b=No5ZiOcmUg9BEwYx9x8oiEFNqyBFm9TBXUP0/dK52Fo0dJgffnQrVEaj8op2OfdG9
         AFhfyNz2rj7NcW0dbwGtPRf75Qircu9uSi3hyinCh1EwFYrj4PPnf/hUNQjErw7HtW
         jOfIMpwyer2meTEmPK+5XpUfZXpCx6M/B6HB7qAs=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from [192.168.1.164] ([37.4.249.112]) by mail.gmx.com (mrgmx005
 [212.227.17.190]) with ESMTPSA (Nemesis) id 1MSKyI-1iKyf227UO-00Sb5o; Mon, 04
 Nov 2019 19:06:00 +0100
Subject: Re: [PATCH] net: usb: lan78xx: Disable interrupts before calling
 generic_handle_irq()
To:     Daniel Wagner <dwagner@suse.de>, netdev@vger.kernel.org
Cc:     linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        Woojung Huh <woojung.huh@microchip.com>,
        Marc Zyngier <maz@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Jisheng Zhang <Jisheng.Zhang@synaptics.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Thomas Gleixner <tglx@linutronix.de>,
        David Miller <davem@davemloft.net>
References: <20191025080413.22665-1-dwagner@suse.de>
 <20191104085703.diajpzpxo6dchuhs@beryllium.lan>
From:   Stefan Wahren <wahrenst@gmx.net>
Message-ID: <793b1cfa-dc45-c01c-ef0f-72db6df3ecd1@gmx.net>
Date:   Mon, 4 Nov 2019 19:05:58 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20191104085703.diajpzpxo6dchuhs@beryllium.lan>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Provags-ID: V03:K1:+2FOEEptqMf+RzO7I8AY6R0vpsaB7v7bFwPTF71L/23k22IwCw8
 JYzhXR2mv4+1F9xloVqtO6TxHLtLWwDofr60ce0pyYbvQGD91CoH01M0w398CU0s5zkm0UA
 HV8sM98GCy2yCQXLsDLVeClndDPTCxEXiIatoBnzHTKMAX7hkLg6EE1gT7o/OmCIFnByawW
 BwLi3SOFN1N1onxX7AsRQ==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:aRrNqB+ccsI=:fwsVjTKA065NF6oEatWVFt
 LLQaPUpcoN3YYYhJvGCnARQ34rkirIrhihqUq4x7nwFYcySgj3fAHmECpw3sHq+asJTHoGVT5
 RXIEZLQKwKMQmhGVoBJ3jqrxpXSpgL8zejKUzO+Y8v1gPl1z+hwNLPxmwP/1CBE1au5vRAmKJ
 JLl+cCYQ0Jl7PORbzEO6bTv8yyDD33HynvhGug9yKotPgA/74ibojqbx4NeHMRBJuRKKg+m7x
 f87GtfbBEsjam3dw/banZkdIzgFWpURSC8Ve8jCJ84+XdmSz+eYo3hSY1NzIJNpLiUB4LbsMB
 fsjv4ocbiNK8ww72fAJGWPsZYjPUMepdykMWywXTNCu3nm+e03KeF45gu8SPq31GUzbQgU0V9
 +05mkx3TSHkwTq7deg/OZ2INSfOxm1lXDZARVjNd79kB4gDMHnO+BRdn8Vr3GDmvwJ0wvUAw6
 zItAOi2Csonx6WlcI8CC2cNmOOalm9OMuPTqE+m8QbXLMhHBWut/TE1B/YSBSK2Q/zudEajwB
 uQxDHsxTpZMFDjMGTP4yqgHm7mAkiWrt1C9LHUvDyscD24lWTLakAiXuPebf0J4xsuECPW5iV
 7aM/V+ZRqB1WLhrpJYmg7oFJJLza9ezeX6hPnQoL669A6QZGiKzTUqgDhTh+Lx+Duj/ovNd6c
 nortiecFni0Lf7CA/y8wG/xoyZ+bluCsSiHIR+a3CuDW/RXb5IRNqQcFsRhL4ae4mhLIyjG54
 dfyyu6WQneFQNyVUYOIbvvh714Gt0UZfOUozq/cobvd2SDFdLG/edUQoqupKOXQS4vBPSXRbK
 LDFGjatAuC1FwYyNLXUHSuyz1vU6N4rmiGJRU4bafAIhUbQCFD0xBLRbJAeT0XqbDlvwzJLXZ
 2c+xMccDQ4UXXoDzY+afRjZEasP5d1xi9tNQFj+qL3je0b8FwCIHtJwsPQ02SmEXlEdU0LflQ
 Eezn/RVaz08l491qXhBEJhOGZ+GyuBnoWLq8Y2O37GtiipAy8k7CRTplBGPuE7VPtAxTxcTbf
 oq547618PQXIc3PvdgeSUDGwcStDMsc3fhEC6/KEkVRT7OiR8OOgT86FM8kK4PkTMOq1rr2up
 UvjP3lHjIRBVdYDY6Wmk1du5vW3H8p9CZrC0P0OAaq/MJ1h4K4vfQLgOFKyRhtPa+Ag5t4Vu0
 z+TyoCu2Bm7Pq0q4uu6Acl+p1nKtUls2ZXzpL/Czu1PmsPWwKqTYuiTVNydW57IVKjiJ4b/O4
 w5DYfRboVkDmnJ+pxrcflIGXohbvQzy7TsikLs67/iUMHlq5K6+L1LZ0+cs0=
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Daniel,

Am 04.11.19 um 09:57 schrieb Daniel Wagner:
> On Fri, Oct 25, 2019 at 10:04:13AM +0200, Daniel Wagner wrote:
>> This patch just fixes the warning. There are still problems left (the
>> unstable NFS report from me) but I suggest to look at this
>> separately. The initial patch to revert all the irqdomain code might
>> just hide the problem. At this point I don't know what's going on so I
>> rather go baby steps. The revert is still possible if nothing else
>> works.
> I replaced my power supply with the official RPi one and the NFS
> timeouts problems are gone. Also a long test session with different
> network loads didn't show any problems. I feel so stupid...
did you never saw a warning about under voltage from the Raspberry Pi
hwmon driver?
>
> Thanks,
> Daniel
>
