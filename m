Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 62748115E33
	for <lists+netdev@lfdr.de>; Sat,  7 Dec 2019 20:32:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726720AbfLGTcT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 7 Dec 2019 14:32:19 -0500
Received: from mail-pg1-f193.google.com ([209.85.215.193]:43395 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726489AbfLGTcT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 7 Dec 2019 14:32:19 -0500
Received: by mail-pg1-f193.google.com with SMTP id b1so5015209pgq.10
        for <netdev@vger.kernel.org>; Sat, 07 Dec 2019 11:32:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=aYT4eNPW+FgJqxLzRimbTqK4xRhGxyqZeRppps0EzNk=;
        b=VZceZKtTzhjt7RIArZsztyh2SPbTkNjeG+g3yNqJJJO2Dz7wzkyur3Tr15eQWH3W6I
         xYgmKYM7zslacM++wc050qsD9cPUoE245zgpr0Sbw8jO7juoZEWQCUm5pzwtgisqD2Bl
         EJCOpUiLo4amvOwdbwvv9BSsqDY9M4CRHqH6s8KPMHKl+eTD3xxW9UXvKCdWFWrSGYPY
         U9VTmB20mg9Czr5nSJF/gHv/3lhRpp5Kx+Zv8fA4DLVJtbKWYGdLnxxzQEu+6VCblueA
         seQEl1HlGsAt9FFrwP8JcELJ7byGC+jD/DUhdKO7nvs4J3jBW+tahBdQZERFy08rOOD5
         alHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=aYT4eNPW+FgJqxLzRimbTqK4xRhGxyqZeRppps0EzNk=;
        b=Z0t/Z4dc0Op1YM9PVlbn/HoiUGSd6M1le52B5/YxTBVxbOtPVVodNOby02BmY35tov
         ADM72A/1uh8lgE/EuO9bNPgLcwo/tb9toJMWERBLf8Jmgihf+OfwG0qKIPWWAyZIfH7O
         2e3T5LbZP0KlkYTIopm0olfs/jz62wvRE75il2G1ddMc1rWfDvLDOG7NVF3FmDJ8EHK8
         Ouuxn8BHtLjX4ogMT/2y/TsNsRrVpqLjoCxDqar+SzkZKkze4uCBjUWOvC4eYTFJ0Qst
         8EOaOwaVHIyHfxfKD/3IBHxSITW8JRU9tM2Qj2nwroAqAYwMwOQrNGCFX0qOUYAMeTfo
         lluw==
X-Gm-Message-State: APjAAAWpT1xTuh4xaULk6eigo3wcG6WbWGa2+7i/Gg1j4LGEmkK2A1N+
        fIikgCk6wK+45uB5rE8mazHEQJkT
X-Google-Smtp-Source: APXvYqxJ0IgZ25p843ai5i71Av3lEFcr7YzDiwQcfxViYzKhDK6/Fc3uh9cLh1Ypfa7ttsIQ2P5MAQ==
X-Received: by 2002:a63:ea4b:: with SMTP id l11mr10392167pgk.357.1575747138777;
        Sat, 07 Dec 2019 11:32:18 -0800 (PST)
Received: from [192.168.86.235] (c-73-241-150-58.hsd1.ca.comcast.net. [73.241.150.58])
        by smtp.gmail.com with ESMTPSA id d7sm22560739pfc.180.2019.12.07.11.32.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 07 Dec 2019 11:32:17 -0800 (PST)
Subject: Re: [PATCH net] net_sched: validate TCA_KIND attribute in
 tc_chain_tmplt_add()
To:     Cong Wang <xiyou.wangcong@gmail.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        syzbot <syzkaller@googlegroups.com>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Jiri Pirko <jiri@resnulli.us>
References: <20191207184930.130132-1-edumazet@google.com>
 <CAM_iQpVE5-59QPiP3Od7p-Fkjwjcm5QYrncN0LofWEC+TPTZUw@mail.gmail.com>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <be2b2219-75a7-0724-51b4-2a057936cd37@gmail.com>
Date:   Sat, 7 Dec 2019 11:32:16 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <CAM_iQpVE5-59QPiP3Od7p-Fkjwjcm5QYrncN0LofWEC+TPTZUw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 12/7/19 10:57 AM, Cong Wang wrote:
> On Sat, Dec 7, 2019 at 10:49 AM Eric Dumazet <edumazet@google.com> wrote:
>>
>> Use the new tcf_proto_check_kind() helper to make sure user
>> provided value is well formed.
> ...
>> Fixes: 6f96c3c6904c ("net_sched: fix backward compatibility for TCA_KIND")
>> Signed-off-by: Eric Dumazet <edumazet@google.com>
>> Reported-by: syzbot <syzkaller@googlegroups.com>
>> Cc: Cong Wang <xiyou.wangcong@gmail.com>
>> Cc: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
>> Cc: Jamal Hadi Salim <jhs@mojatatu.com>
>> Cc: Jiri Pirko <jiri@resnulli.us>
> 
> Acked-by: Cong Wang <xiyou.wangcong@gmail.com>
> 
> Just a nit: the extack message should be for a chain template, not
> for a TC filter.

Thanks, I will send a V2 with an updated message.


