Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 394F2676B7
	for <lists+netdev@lfdr.de>; Sat, 13 Jul 2019 01:12:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727840AbfGLXL2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Jul 2019 19:11:28 -0400
Received: from mail-pg1-f195.google.com ([209.85.215.195]:41734 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727704AbfGLXL2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Jul 2019 19:11:28 -0400
Received: by mail-pg1-f195.google.com with SMTP id q4so5182255pgj.8
        for <netdev@vger.kernel.org>; Fri, 12 Jul 2019 16:11:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding:content-language;
        bh=EQm1wMo+oTPeEPm7wKRduWlBphRwNxiDpUlJVaHer0Q=;
        b=pd72pcWlacRiVM1ua/fzzyvDiAqlPQtQts78fYeVIEeQmikqB3g7UQOVeqlewCCR4K
         RJ1dWxgTuKj1P9Fxx2hZduVzBcIbFFn5QTKhhGujQ+i+0q48+K2RwG+5/PjAaFwZrtbp
         GPKgDrsYnM232/tt6U6IkDvl9qmShGiCbC1Q7b4WgaOH8XzZFdCu6Z+oXnLzCjaEsYa0
         i4MpdMKvRRRAM7hiyQp4kby4bJQJj8GFtZg2Z8rPfvjsIxrUzIBWPNoKvg77hajaRvxM
         pmOi/oWO8DCB+CpVsm3w7uXg+2RkybSdDk6jAWPrmUnGjqfPG2FOhaMB30fajwLeZWRA
         X+gg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=EQm1wMo+oTPeEPm7wKRduWlBphRwNxiDpUlJVaHer0Q=;
        b=bc8kq5vReIbGgGzbObYQxlt3Ebl9MdgLzcUdTF/yZIbJUftK07RAK1oVaP3xmTE9i1
         OTYrO1MArOgt6HYzsfYbcebuuviG54aR9pSGLRgYeFNlU9wSDqXEulL0P0dXP6cewAyw
         EelWdUUp4ZPsiOVqVjMZtUWu8sBMfmrbo+8wzT0tNPrASMU0sTEkqB+YbblxE19dAyBx
         Fx88qewxeEOctrifH0j2GkHdl4FDgDJrYYTCjX9vXgQEcGX3qYOernW0sH0FvhuW2pgW
         Twk7zMWoJb2Po99WXpbkHiK4YA8O1riLReGV5bK2VEV3b7y9ffvyTu8oYC35S1/Nq+RN
         KavQ==
X-Gm-Message-State: APjAAAXj+UG8Z2ZtxrLjx+5BX9EpSbQD6RW5cvd2Gjf6mRMH8YEK0SJD
        H3t2jMN4U44pcwbcAkL3gQFLXn/Y
X-Google-Smtp-Source: APXvYqzGhYgYFX/dsLHdGTY6vPKDbBy60Pgm9LJY1oKXp1cZ6fGDqV0xFmGXxjZ0fNJZED8wzYT7Jg==
X-Received: by 2002:a63:194f:: with SMTP id 15mr14101540pgz.382.1562973087281;
        Fri, 12 Jul 2019 16:11:27 -0700 (PDT)
Received: from [192.168.43.118] (73.sub-174-224-29.myvzw.com. [174.224.29.73])
        by smtp.gmail.com with ESMTPSA id k3sm620964pgq.92.2019.07.12.16.11.25
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 12 Jul 2019 16:11:26 -0700 (PDT)
Subject: Re: [PATCH net-next] net: openvswitch: do not update max_headroom if
 new headroom is equal to old headroom
To:     David Miller <davem@davemloft.net>, ap420073@gmail.com
Cc:     pshelar@ovn.org, netdev@vger.kernel.org, dev@openvswitch.org
References: <20190705160809.5202-1-ap420073@gmail.com>
 <20190712.151846.1093841226730573129.davem@davemloft.net>
From:   Gregory Rose <gvrose8192@gmail.com>
Message-ID: <1821c501-3c86-2ac5-dc86-232c30a8a83e@gmail.com>
Date:   Fri, 12 Jul 2019 16:11:24 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190712.151846.1093841226730573129.davem@davemloft.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 7/12/2019 3:18 PM, David Miller wrote:
> From: Taehee Yoo <ap420073@gmail.com>
> Date: Sat,  6 Jul 2019 01:08:09 +0900
>
>> When a vport is deleted, the maximum headroom size would be changed.
>> If the vport which has the largest headroom is deleted,
>> the new max_headroom would be set.
>> But, if the new headroom size is equal to the old headroom size,
>> updating routine is unnecessary.
>>
>> Signed-off-by: Taehee Yoo <ap420073@gmail.com>
> I don't think Taehee should be punished because it took several days
> to get someone to look at and review and/or test this patch and
> meanwhile the net-next tree closed down.
>
> I ask for maintainer review as both a courtesy and a way to lessen
> my workload.  But if that means patches rot for days in patchwork
> I'm just going to apply them after my own review.
>
> So I'm applying this now.
>
My apologies Dave.  I did test and review the patch, perhaps you didn't 
see it.  In any case, you're right, Taehee was owed a more timely review 
and I missed it.

Thanks for applying the patch.

- Greg
