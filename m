Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 64873ECF69
	for <lists+netdev@lfdr.de>; Sat,  2 Nov 2019 16:11:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726950AbfKBPLc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 2 Nov 2019 11:11:32 -0400
Received: from mail-il1-f195.google.com ([209.85.166.195]:35503 "EHLO
        mail-il1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726440AbfKBPLc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 2 Nov 2019 11:11:32 -0400
Received: by mail-il1-f195.google.com with SMTP id p8so11156325ilp.2;
        Sat, 02 Nov 2019 08:11:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=hOZac+kS9/WS8vujonCBEZ/QV16egc94icIC37C7oxc=;
        b=N6fTdsJzjb0jMXWDUS3kcRu3yrO+ZVCw3wGNRWG44bIDbvrZwurc3XvG2CeSnXUZpg
         YSuMlTl6tSOQVfw0YctZjizRFCr9u74d+e+0fnsPwbf0KUN5fPP5chS8FeUomWaOSs2L
         aRBPVszLGfs168BNRgb8xO/n86k4DcB++q+cnsMFLtQ6NH36hSLwiv/7Y2Wa/spJ7huY
         MWfDr6ub7F26mx8G3WHkK+Mpgbd8fKBBXeQdm3RsN1cs7OW2CD6LlyhpQrvDmNGOop14
         zhsNObvcmtYT8kJihxNQbt8ASj9Mz0kaiaf3BiZ9F/7azWlBA79VFWohTvXiEdzW1Iam
         mTmw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=hOZac+kS9/WS8vujonCBEZ/QV16egc94icIC37C7oxc=;
        b=e9lZCP53IYHxPdMfG2x1gWIcwkxmmTq1VjLtbLpslekzHY/1D2V+PAdB06LAOqFice
         eu/Ib485QkdNCG9x81MzFc/2xdtAzKXpITcRWFr0GOFEaAy5MBQuVXYXmhz/9lWkK9XW
         06Sz+Bq9pbdX8M3Kite1d2XYNNe3SfqVYJC2jtIVjz9BGRht+mtkdVVNPEnZL8lk0R3B
         K4pivklznGpIs+asRMW/KrqHrueneFNVgHxu3DoDnYqZUnajhDdG73JZQitfrGXKVZrp
         63YSYiZEvAoxnRAJiheArHh4k2Wjmv0bvzdGzdAoSQeYkPzdEktjb0u8+dYqmbtKJqXC
         Wa0w==
X-Gm-Message-State: APjAAAUvWHeeanpPTWkZIKk84SQ0cYaV7oJjkWI2ez2lyQiIhinm3XeE
        v6hcvoFGC4VSzYK8MRYt+IPZaZzc
X-Google-Smtp-Source: APXvYqwqQjE9DGp7Vnr1MyrOzJlcYMmfzheQ6XlscDIxw9gUIWIkEdVsc2VFOCoHzQ0ozF7ZA6MRhA==
X-Received: by 2002:a92:4708:: with SMTP id u8mr18216701ila.179.1572707490741;
        Sat, 02 Nov 2019 08:11:30 -0700 (PDT)
Received: from dahern-DO-MB.local ([2601:282:800:fd80:d194:3543:ed5:37ec])
        by smtp.googlemail.com with ESMTPSA id r17sm1621304ill.19.2019.11.02.08.11.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 02 Nov 2019 08:11:30 -0700 (PDT)
Subject: Re: [PATCH net-next 2/2] selftest: net: add icmp reply address test
To:     Francesco Ruggeri <fruggeri@arista.com>
Cc:     David Miller <davem@davemloft.net>, shuah@kernel.org,
        netdev <netdev@vger.kernel.org>, linux-kselftest@vger.kernel.org
References: <20191101233408.BC15495C0902@us180.sjc.aristanetworks.com>
 <0a03def6-3ea0-090f-048f-877700836df2@gmail.com>
 <CA+HUmGgDrY9A7kz7268ycAOhExA3Y1h-QhBS6xwbWYxpUODDWw@mail.gmail.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <690336d7-0478-e555-a49b-143091e6e818@gmail.com>
Date:   Sat, 2 Nov 2019 09:11:28 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:68.0)
 Gecko/20100101 Thunderbird/68.2.1
MIME-Version: 1.0
In-Reply-To: <CA+HUmGgDrY9A7kz7268ycAOhExA3Y1h-QhBS6xwbWYxpUODDWw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/2/19 9:08 AM, Francesco Ruggeri wrote:
> On Sat, Nov 2, 2019 at 7:34 AM David Ahern <dsahern@gmail.com> wrote:
>>
>> It would be better to combine both of these into a single test script;
>> the topology and setup are very similar and the scripts share a lot of
>> common code.
> 
> Sure, I can do that.
> 
>> Also, you still have these using macvlan devices. The intent is to use
>> network namespaces to mimic nodes in a network. As such veth pairs are a
>> better option for this intent.
>>
> 
> I am only using macvlans for N1 in the ipv6 test, where there are 3 nodes.
> How do I use veths for that?

checkout the connect_ns function. It uses veth to connect ns1 to ns2.
