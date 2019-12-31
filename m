Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BC65E12D628
	for <lists+netdev@lfdr.de>; Tue, 31 Dec 2019 05:30:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726509AbfLaEa5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Dec 2019 23:30:57 -0500
Received: from mail-io1-f67.google.com ([209.85.166.67]:47032 "EHLO
        mail-io1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726364AbfLaEa4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Dec 2019 23:30:56 -0500
Received: by mail-io1-f67.google.com with SMTP id t26so33105790ioi.13
        for <netdev@vger.kernel.org>; Mon, 30 Dec 2019 20:30:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=CiVWv1Jox6NAUYvW3SUonnVuidXZX8xyKeekEFFeGo0=;
        b=mnunQonlKL0YGvHfFUC5Z93uE8FqFfLoSWvkEKtIGbj5W5fhR0JvGuhuTndBLVbZSX
         EQpxb39pnqMcTHCvfKJHJkjWyUD8gVBh34hRUGgxhcmHGemcRTFCP5TzoRVV8GuHi4aX
         7XFm0/ioFDzQWp6kLToVoWzZGNV7Lkmxmo30BK+XzS2DSgksSWLRBShY26wQva5mPr87
         t/dGNsC00eyUrYhkoi3vh8vXyXl7nuJS3c8DyR2khwEY/JPvnrjmF5qg+SAfBd1euEoI
         tAgdJJWuvqtNXP90w41xX+BEUlOl5Ah43RciDyfl05xx/hFSZJwvw8heHE66BOKEYJI7
         o6aw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=CiVWv1Jox6NAUYvW3SUonnVuidXZX8xyKeekEFFeGo0=;
        b=XdWvSfVaroXSKmNk2WrG8XH6ItPEQeGFfwEKYRdDNmNY+9+2V1isBlboYsWPPvhbld
         P48fOCPbvgGjf7qCaV5BQI+QsrZHgiZI3eIsnByV0Hm9tQhTHKWa2DCwcj2GBcUCkERK
         TJOTq8n5v+Nnupj62ryGw6oYAbWUFtbNA9xnx1Fa4E9K2ovO5u2xvqk8IzKjzHL+j+br
         Y9zfattv5M7uHL3qALYSNkG4iBmUfUFY5ivgY1+1S/QXP/wkdiAMAJYKjlAUTII0suxn
         q0WhWOAcHbgAQGZXUHxYpvl1mZX3YYOFnvSzO06ao3lbhqzL3xKgAjt22nF2qFA0JzjU
         boqw==
X-Gm-Message-State: APjAAAX7kiMcNpq1ypBYaEzBz3oxOZL6/2yLoJ8cUes3kKgJPI+JdUfj
        Vs/r7Rs50xS50apgWQSq618=
X-Google-Smtp-Source: APXvYqz4ckvsConlqdqSPloflIzuvuUcKY7bSGjdAWWD0uSt5vxhLn9bPjkGNuDoj3kG55P76M8kQQ==
X-Received: by 2002:a5d:844d:: with SMTP id w13mr48165054ior.83.1577766655902;
        Mon, 30 Dec 2019 20:30:55 -0800 (PST)
Received: from ?IPv6:2601:282:800:7a:ed82:9285:ce7:fa57? ([2601:282:800:7a:ed82:9285:ce7:fa57])
        by smtp.googlemail.com with ESMTPSA id i83sm17256970ilf.65.2019.12.30.20.30.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 30 Dec 2019 20:30:55 -0800 (PST)
Subject: Re: [PATCH iproute2-next] taprio: Add support for the SetAndHold and
 SetAndRelease commands
To:     Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        Jose Abreu <Jose.Abreu@synopsys.com>, netdev@vger.kernel.org
Cc:     Joao Pinto <Joao.Pinto@synopsys.com>,
        David Ahern <dsahern@gmail.com>
References: <060ba6e2de48763aec25df3ed87b64f86022f8b1.1576591746.git.Jose.Abreu@synopsys.com>
 <874kxxck0m.fsf@linux.intel.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <8230b532-ffe6-4218-94ae-2609eb9034c1@gmail.com>
Date:   Mon, 30 Dec 2019 21:30:54 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.3.1
MIME-Version: 1.0
In-Reply-To: <874kxxck0m.fsf@linux.intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 12/18/19 4:05 PM, Vinicius Costa Gomes wrote:
> Hi Jose,
> 
> Jose Abreu <Jose.Abreu@synopsys.com> writes:
> 
>> Although this is already in kernel, currently the tool does not support
>> them. We need these commands for full TSN features which are currently
>> supported in Synopsys IPs such as QoS and XGMAC3.
>>
>> Signed-off-by: Jose Abreu <Jose.Abreu@synopsys.com>
> 
> This patch looks good in itself. 
> 
> However, I feel that this is incomplete. At least the way I understand
> things, without specifying which traffic classes are going to be
> preemptible (or it's dual concept, express), I don't see how this is
> going to be used in practice. Or does the hardware have a default
> configuration, that all traffic classes are preemptible, for example.
> 
> What am I missing here?
> 

this patch has been lingering for a while. What's the status? good
enough for commit or are changes needed?
