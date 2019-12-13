Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4A4AE11DBCD
	for <lists+netdev@lfdr.de>; Fri, 13 Dec 2019 02:47:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731458AbfLMBq7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Dec 2019 20:46:59 -0500
Received: from mail-pg1-f172.google.com ([209.85.215.172]:38303 "EHLO
        mail-pg1-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727084AbfLMBq6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Dec 2019 20:46:58 -0500
Received: by mail-pg1-f172.google.com with SMTP id a33so706474pgm.5;
        Thu, 12 Dec 2019 17:46:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=DQN+c/XoQHFCxSakIJRYUeZx27nMrip4+1yJpWHdOaU=;
        b=eiOUp9daulK1XiDWuJczbXZ91xl5eAYXTVgIDlIyHXD3ph+vj2XY25A9md64czwV5A
         Bpund4OeiqP8MfMBrPTHKcGWfduxfCzUAS/oZZnoEHYdCID4uuvGVBWicDYmT5CBZS3o
         HCemndy7tV/uErRxeGC2Jjxah+qzX0v02rhssWsd4szHdBEaQttBrknRum+Roi43iFMA
         mObyfolVtIiY7A5faifRIhViFDB5o8qJ0v3dDTYog1JsGz3bhN+KDJ/hwduwoNgppUOv
         PO1wEM4ZoAKd3IhpwneynsiTrFZ6FlyyOZxGY+3lqN7fdJ2ksT5gupdY+k4Ro2heDtS/
         4UMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=DQN+c/XoQHFCxSakIJRYUeZx27nMrip4+1yJpWHdOaU=;
        b=fM+28wqeHaaKy6Kcg3s+iyVMZC0qXt+CtsBF80poQKUeXPhFNMYlR81sqNKBmnBMiS
         VQTQ6Xitf0FodsOaAN6CkqkZDKLytw0CIQH+eKDcQuCD+8UW/csbMPKMt8Ew1MkYs83r
         bE47ypvO+yTM/lGyxo+29gb0ahQokb8QVnl65Yyi1GpzMcEEdUH6yw0asZx54i9ScnpT
         FO/R6+wYkrbVPcyBjUqz2dvOPtKbhglw6QhJ8bQQUB4Dmtht3RXUvmFVNop5pZYyo0e4
         M35jSsxE1FyDJC/EOAPYbERKOzBGM6UNRziKYDWOG1PU5GQ4voRhjAaVK3fxT32umtX3
         5F5g==
X-Gm-Message-State: APjAAAXbH9ZyW6wpE0kEbMPhPmfLQC+h3aaD2F95O64GFc6RlGJtkVPT
        0VSkJYeCZol4Nb2Z2v/U9k87OLk+
X-Google-Smtp-Source: APXvYqxFZPh4/9ddIRpKT1XLG5JlQjBS84W0h/mzO8dD9Xl++O9QBZnfTuw55gnq4SN5IK8VHMF8Tg==
X-Received: by 2002:a65:488f:: with SMTP id n15mr14683013pgs.61.1576201617698;
        Thu, 12 Dec 2019 17:46:57 -0800 (PST)
Received: from [192.168.86.235] (c-73-241-150-58.hsd1.ca.comcast.net. [73.241.150.58])
        by smtp.gmail.com with ESMTPSA id e27sm8910691pfj.129.2019.12.12.17.46.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 12 Dec 2019 17:46:56 -0800 (PST)
Subject: Re: [Make-wifi-fast] debugging TCP stalls on high-speed wifi
To:     Simon Barber <simon@superduper.net>,
        Dave Taht <dave.taht@gmail.com>
Cc:     Make-Wifi-fast <make-wifi-fast@lists.bufferbloat.net>,
        Johannes Berg <johannes@sipsolutions.net>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        Neal Cardwell <ncardwell@google.com>,
        Netdev <netdev@vger.kernel.org>
References: <14cedbb9300f887fecc399ebcdb70c153955f876.camel@sipsolutions.net>
 <CADVnQym_CNktZ917q0-9dVY9dhtiJVRRotGTrPNdZUpkjd3vyw@mail.gmail.com>
 <f4670ce0f4399fe82e7168fb9c491d8eb718e8d8.camel@sipsolutions.net>
 <99748db5-7898-534b-d407-ed819f07f939@gmail.com>
 <ff6b35ad589d7cf0710cb9fca4c799538da2e653.camel@sipsolutions.net>
 <CAA93jw6b6n0jm_BC6DbccEU3uN9zXcfjqnZMNm=vFjLVqYKyNA@mail.gmail.com>
 <22B5F072-630A-44BE-A0E5-BF814A6CB9B0@superduper.net>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <34a05f62-8dd0-9ea0-2192-1da5bfe6d843@gmail.com>
Date:   Thu, 12 Dec 2019 17:46:55 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <22B5F072-630A-44BE-A0E5-BF814A6CB9B0@superduper.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 12/12/19 4:59 PM, Simon Barber wrote:
> I’m currently adding ACK thinning to Linux’s GRO code. Quite a simple addition given the way that code works.
> 
> Simon
> 
>

Please don't.

1) It will not help since many NIC  do not use GRO.

2) This does not help if you receive one ACK per NIC interrupt, which is quite common.

3) This breaks GRO transparency.

4) TCP can implement this in a more effective/controlled way,
   since the peer know a lot more flow characteristics.

Middle-box should not try to make TCP better, they usually break things.
