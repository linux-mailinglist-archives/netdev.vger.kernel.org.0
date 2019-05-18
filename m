Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E6EC8224E7
	for <lists+netdev@lfdr.de>; Sat, 18 May 2019 22:39:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729140AbfERUjI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 18 May 2019 16:39:08 -0400
Received: from mail-qt1-f193.google.com ([209.85.160.193]:40637 "EHLO
        mail-qt1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728813AbfERUjH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 18 May 2019 16:39:07 -0400
Received: by mail-qt1-f193.google.com with SMTP id k24so12007771qtq.7
        for <netdev@vger.kernel.org>; Sat, 18 May 2019 13:39:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=1GG1QYpYqJSRolK/auQ5jVZehl8TpD5H90//4zk91/U=;
        b=aDV3sV0FkVntrGQlm7Z805hZwjG0L192l5Tf1nnkx6KxaSsovacjnhsq8jpDtIfj9w
         wUmmL1m7OgFZQUC3nZSiXJg0oyoOo6Rdc5dtEHCouUH6irCfgQ0WiRvKv1gP65Z6M7U3
         RBwSPvFswsS/NcsWNPW+GrgAcnIsid8p81S+ALYUU/uYgRFLGaIPT1D/Io8P/Lzr2kaB
         3li+sckp19OlImWQkoYGh+gqsttbMInJcHpah3XOHCb3gwB7ozdlwGUYBnyw7UFLVmve
         959QT8WJFLNTcT/OXCZwGfED6u50Bxu03doCx8NTNGu14QIKeOq4VfP6Y9k7tH6uTjXr
         8nog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=1GG1QYpYqJSRolK/auQ5jVZehl8TpD5H90//4zk91/U=;
        b=ZZwz/4yt1i1zgUIFrrvRgqYI2wu3cKQ8sHOmiIdkUhYuexcCXgoVEPEHpPJ/8+ATvQ
         MsK44dIuOxQEIEN1vRT/Se9LgHFtb5sGpK0poa21epZx/huAW2sNh5YHxqR3uJCVVjIH
         FaIhCGi0LT7I3eaTHF7QjoWjP2jO72WM1u8JYwPPsL9EvhDkDVFZ4HxmpK2eYn2PYgbF
         AxGzYmwzlgOXFELi34QKvFlmtdvxm2tT2hXXQkX8oNXo2u/lGTJZxbSb+02Oa8wlML5R
         bvYIiWjkkWOclHg0RI9vjZLvUt2Ra+GGB3FcvKlhFDUTOhQJs9kHmho4ejlk3A9cnzdQ
         Nr/w==
X-Gm-Message-State: APjAAAUE7byA61YDO+m5EmyFMcQO7qAuNSGN/1sEDV4nNCYUHTENGJbh
        m0thAR+pkxQidok83Eant/jW+A==
X-Google-Smtp-Source: APXvYqwS+NpouO7f0JN4tMUzy1vxmsWKRVafmOv5Y+iPL6N9sieFWOgzp0gapQctofyLvuk8ce7vew==
X-Received: by 2002:a0c:b98d:: with SMTP id v13mr25822203qvf.11.1558211947100;
        Sat, 18 May 2019 13:39:07 -0700 (PDT)
Received: from [192.168.0.124] (24-212-162-241.cable.teksavvy.com. [24.212.162.241])
        by smtp.googlemail.com with ESMTPSA id h20sm7340121qtc.16.2019.05.18.13.39.05
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 18 May 2019 13:39:06 -0700 (PDT)
Subject: Re: [RFC PATCH v2 net-next 0/3] flow_offload: Re-add per-action
 statistics
To:     Edward Cree <ecree@solarflare.com>, Jiri Pirko <jiri@resnulli.us>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        David Miller <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Michael Chan <michael.chan@broadcom.com>,
        Vishal Kulkarni <vishal@chelsio.com>
References: <9b137a90-9bfb-9232-b01b-6b6c10286741@solarflare.com>
 <f4fdc1f1-bee2-8456-8daa-fbf65aabe0d4@solarflare.com>
From:   Jamal Hadi Salim <jhs@mojatatu.com>
Message-ID: <cacfe0ec-4a98-b16b-ef30-647b9e50759d@mojatatu.com>
Date:   Sat, 18 May 2019 16:39:05 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <f4fdc1f1-bee2-8456-8daa-fbf65aabe0d4@solarflare.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2019-05-17 1:14 p.m., Edward Cree wrote:
> On 17/05/2019 16:27, Edward Cree wrote:
>> I'm now leaning towards the
>>   approach of adding "unsigned long cookie" to struct flow_action_entry
>>   and populating it with (unsigned long)act in tc_setup_flow_action().
> 
> For concreteness, here's what that looks like: patch 1 is replaced with
>   the following, the other two are unchanged.
> Drivers now have an easier job, as they can just use the cookie directly
>   as a hashtable key, rather than worrying about which action types share
>   indices.

Per my other email, this will break tc semantics. It doesnt look
possible to specify an index from user space. Did i miss
something?


cheers,
jamal
