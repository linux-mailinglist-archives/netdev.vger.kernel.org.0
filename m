Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 078E6165FE
	for <lists+netdev@lfdr.de>; Tue,  7 May 2019 16:47:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726437AbfEGOrl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 May 2019 10:47:41 -0400
Received: from mail-pf1-f196.google.com ([209.85.210.196]:41267 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725843AbfEGOrl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 May 2019 10:47:41 -0400
Received: by mail-pf1-f196.google.com with SMTP id l132so3829383pfc.8
        for <netdev@vger.kernel.org>; Tue, 07 May 2019 07:47:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=RywkV7Co6OMoiPZ+l0BLL+IKOYb8QlsgleWldzuz7n8=;
        b=Xb8MXT1YFHhRQTLmRGlOMJ7wf9vZKgT/ykN2suoz7nI0Lli60BGLsTOx2oO1GEvH0S
         HwYPd7k+mG+FcUPNwWWPTQaqaZrRPMm44Pv/AsNLwvhQtrfQWUoitmsZUVCn6Q7w9HNm
         KbTt3K3Sl3Q94oLimorl5I3pqw9ffJDBTE+6X43Nvg7yKPfk/VSqU5UA2/6GBbtsLWjj
         O15uX68oY8X3W5prUopEiXM+EyD1c9fkBgRLFT8uJuUnU4SL+iFz77odHYWqXdZ8GMTX
         hb2FzKxpKejms1CUTRcq5YVh7XMX2Tppds5ahMVEiBsbiJr3d7QpHe8VvppzYRtp8WJu
         y1Qg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=RywkV7Co6OMoiPZ+l0BLL+IKOYb8QlsgleWldzuz7n8=;
        b=mtvP6yxBd8WqLfAyAvB4zgnzXnRc5XSOa1zC2v4fyvKxm9grHOKjH8vwDGIYFRkbps
         kMU2y/WP8sxNqC3XTCv5A+zMqw7Pa+mcGKunEBLlOffiUAbj/TqUVyUlK+2TcX+yK5f5
         iUP8mFb2Gb6ZBa8jGBU9lQeEnfNeV0Ha64u8HFxEyhWs3IwOVvXMNqnO7hjM4UvVEoNB
         gDcTwyc2VNlnbbeHF3cfbBlRDgVBMPuLKrssu1YxA9epeK64If2fSC0BF0wWW8wiCp4h
         nwMHEMdmXhiNYBzLe1DQYV0r3tm2ha1aEjrRVoepqYZ8Ad2pXyxCu3uJhARqR5X6YfxY
         6JKw==
X-Gm-Message-State: APjAAAW5sUh2SfHt3OkN63RnNmTNPq1a8Gz18yyQi9vVXT0UvD7Hr8Pe
        eZHuS+CcT3VB5s0ufLJc55U=
X-Google-Smtp-Source: APXvYqzwNI6r2AbOQrori3hgeaLJlmkxQsbC5AEEF973yq1NZC8nPQhbPkV0hU+ZZPw1b9FPVNbjpg==
X-Received: by 2002:a62:2041:: with SMTP id g62mr33898863pfg.168.1557240460575;
        Tue, 07 May 2019 07:47:40 -0700 (PDT)
Received: from [192.168.84.92] (8.100.247.35.bc.googleusercontent.com. [35.247.100.8])
        by smtp.gmail.com with ESMTPSA id e14sm188842pgk.72.2019.05.07.07.47.37
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Tue, 07 May 2019 07:47:39 -0700 (PDT)
Subject: Re: [PATCH net] tuntap: synchronize through tfiles array instead of
 tun->numqueues
To:     Jason Wang <jasowang@redhat.com>,
        Eric Dumazet <eric.dumazet@gmail.com>, netdev@vger.kernel.org
Cc:     mst@redhat.com, YueHaibing <yuehaibing@huawei.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        "weiyongjun (A)" <weiyongjun1@huawei.com>
References: <1557199416-55253-1-git-send-email-jasowang@redhat.com>
 <7b9744b4-42ec-7d0a-20ff-d65f71b16c63@gmail.com>
 <6f880c3e-ebb6-a683-6c75-c94409a60741@redhat.com>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <98fb0760-a772-ca1c-d97b-d8b70066c9aa@gmail.com>
Date:   Tue, 7 May 2019 07:47:35 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <6f880c3e-ebb6-a683-6c75-c94409a60741@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 5/6/19 11:54 PM, Jason Wang wrote:
> 
> On 2019/5/7 上午11:41, Eric Dumazet wrote:
>>
>>>   
>> If you remove the test on (!numqueues),
>> the following might crash with a divide by zero...
> 
> 
> Indeed, let me post V2.

You probably want to fix tun_ebpf_select_queue() as well.

