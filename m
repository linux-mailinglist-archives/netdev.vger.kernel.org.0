Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 20BA61154F9
	for <lists+netdev@lfdr.de>; Fri,  6 Dec 2019 17:19:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726352AbfLFQTK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Dec 2019 11:19:10 -0500
Received: from mail-pj1-f47.google.com ([209.85.216.47]:34220 "EHLO
        mail-pj1-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726284AbfLFQTJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Dec 2019 11:19:09 -0500
Received: by mail-pj1-f47.google.com with SMTP id j11so1817064pjs.1;
        Fri, 06 Dec 2019 08:19:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=41QvHatHr0g3uZPwHbiixW/aEz8FiwJ4DRuDN3ZTAZU=;
        b=kDgU7N/FqrEaiBPUK3AQSShoOnDpdLUi6+T3Dv9758TdJM2N+yVEtJUwPnP1GSb0n6
         rMHgB0VGs98mnoNW9NaSuWAYvL8bRPDc9JI9cx5HrvxojjckmbBiflAlsB8wP0XVPh1Q
         GcqLi6HqEyxzTyMilAkmWUNAXUYVdsmJjrVkJn2zS18WlZFuAikif/gEGsUCsNCHcHBh
         Dc0c51GCkZu66l673y4us9LPrn3GkE+Kd/FN/7QiZWNIfRxepmIedBdah+hE4WW3KDb2
         Iqjkjxxj6WYH2NFHKV/ngt9/G1hI2ONc3vz90tEpX9twhfPbM2X7UaK0pmCSKYjZ/vzF
         rEKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=41QvHatHr0g3uZPwHbiixW/aEz8FiwJ4DRuDN3ZTAZU=;
        b=cnZ4QgpPlU71Xt4PaTw9akOtBrLf6QX9xZsc0RJv9YBPBiKhY+aJEv7xCUUELICxnp
         Yxiw4Ea/m7BqlXwVfCp/zgQtqaJVt0IBMYGaS1/VmXofC1EknZWfszGHK2WYduoQJ496
         0q91JmZMZxyZf3tpHWy/YLuwG51zsCgyyPtWYbFXlaf1u0mLiwkepLOZi27DFO8SQWPM
         za3pCMD2MQLHhXFjmoQxXyUGXjbv5vZFQdrThrrn2Ta1LSR3tkDc82fdxPn2AfhEsEoz
         wzSt+LUXn1AOu8YY2weTEAEKBRmGHLa1uSOzuNKnLHH0PKztv+CeH065itsNblC0ULFO
         EXBA==
X-Gm-Message-State: APjAAAXSlZCo8zfZYAYKl3McihEUqOx6lbUywwF9TV5dwQH6kgXOBN8d
        daGS63KQBCdqXvqF6+4IvoUN4ZO8
X-Google-Smtp-Source: APXvYqwP7ciMTfz113hONKdgvFWnVcg5bk56SmmrYXxIlvQPh6h6eSbqeAGJ8qI3xCJCnyWSnBnXBQ==
X-Received: by 2002:a17:90a:c790:: with SMTP id gn16mr16647645pjb.76.1575649149075;
        Fri, 06 Dec 2019 08:19:09 -0800 (PST)
Received: from [192.168.84.65] (8.100.247.35.bc.googleusercontent.com. [35.247.100.8])
        by smtp.gmail.com with ESMTPSA id s2sm17531268pfb.109.2019.12.06.08.19.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 06 Dec 2019 08:19:08 -0800 (PST)
Subject: Re: recvfrom/recvmsg performance and CONFIG_HARDENED_USERCOPY
To:     Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        David Laight <David.Laight@ACULAB.COM>,
        network dev <netdev@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <23db23416d3148fa86e54dccc6152266@AcuMS.aculab.com>
 <dc10298d-4280-b9b4-9203-be4000e85c42@gmail.com>
 <8b8a3cc1c3341912e0db5c55cd0e504dd4371588.camel@redhat.com>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <fbac8306-247f-10f3-4067-14c0610b17d6@gmail.com>
Date:   Fri, 6 Dec 2019 08:19:03 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <8b8a3cc1c3341912e0db5c55cd0e504dd4371588.camel@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 12/6/19 8:09 AM, Paolo Abeni wrote:

> Oh, nice! I though the compiler was smart enough to avoid the indirect
> call with the current code, but it looks like that least gcc 9.2.1 is
> not.
> 
> Thanks for pointing that out!
> 
> In this specific scenario I think the code you propose above is better
> than INDIRECT_CALL.
> 
> Would you submit the patch formally?

Certainly, although I am not sure this will be enough to close
the gap between recvmsg() and recvfrom() :)

Also I was wondering if a likely() or unlikely() clause would
make sense.

This could prevent an over zealous compiler optimizer
to put back the indirect call that we tried to avoid.
