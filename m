Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A0A991191AD
	for <lists+netdev@lfdr.de>; Tue, 10 Dec 2019 21:15:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726968AbfLJUPb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Dec 2019 15:15:31 -0500
Received: from mail-lj1-f195.google.com ([209.85.208.195]:44392 "EHLO
        mail-lj1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726364AbfLJUPa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Dec 2019 15:15:30 -0500
Received: by mail-lj1-f195.google.com with SMTP id c19so21275611lji.11
        for <netdev@vger.kernel.org>; Tue, 10 Dec 2019 12:15:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cumulusnetworks.com; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=91mr6eeADorjnfR5x6lK4E8CAqAHq5gQKNZL6IXrUFA=;
        b=bQA61WiJYd7BqY39Yve6U2jh2wYlAPueDf+k46tLEX1y3Aj89Yno4yd9FjOOUMU8eE
         qaBZqveZUZGDG0MltiNRwN5Fdz/2fNYsoZlgrNyJe3P0+AdoFtwpeyQCrx/DhcQPy3b/
         zRLUGxmcOGbmoSBmX/KC7RuG3f9wNB+fPaTQM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=91mr6eeADorjnfR5x6lK4E8CAqAHq5gQKNZL6IXrUFA=;
        b=dMp6YAhPK166CNfqblyQgKMx5JiTvgRj0kFK+Qj6hEaJWegY7RDuey+EA8QXZe9XGJ
         NkHwyZtd4oR7Bi0N98OvgIHb5QGMTk9x8SULKa8KNq9qKICXYBWOA/YtV9EIg3NHvv0R
         cizt69+65uuDqs5PqMlnhH5954BSMMc7/No/2/QWKexVgXILcavHIykqiyu8/Bkv+6C7
         i6CA7lLXZ3V6sWz9JhwSBzNZJIou5NiG3HSv8eZQvGC1lQHjUeD8P2iir/VUBaS/k0On
         5BB8+2kzAqcBZ96botRDdX39PE3flauVj9Pr7k5HBdxhZb8B/giWWEEuYXjmpZwfLPv8
         BfcQ==
X-Gm-Message-State: APjAAAVLlNncLzqJ3Gmp3bTwyjvwwccebOaYYT4s4wVZ/dcUd0eCtT4x
        NDSnLYo/8tuAhlaMmPIxQSOeyA==
X-Google-Smtp-Source: APXvYqyJqWadhotEciJHD7Dq5ycnfp73ZFdCSUYp45Va2Ao7YkJJOLpTHAvGruR0clwe9eQFZf9c0Q==
X-Received: by 2002:a2e:9008:: with SMTP id h8mr22407749ljg.217.1576008928612;
        Tue, 10 Dec 2019 12:15:28 -0800 (PST)
Received: from [192.168.0.107] (84-238-136-197.ip.btc-net.bg. [84.238.136.197])
        by smtp.gmail.com with ESMTPSA id 10sm2511653ljw.2.2019.12.10.12.15.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 10 Dec 2019 12:15:28 -0800 (PST)
Subject: Re: [PATCH net-next] net: bridge: add STP xstats
To:     Vivien Didelot <vivien.didelot@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Roopa Prabhu <roopa@cumulusnetworks.com>,
        netdev@vger.kernel.org, bridge@lists.linux-foundation.org,
        Stephen Hemminger <stephen@networkplumber.org>
References: <20191209230522.1255467-1-vivien.didelot@gmail.com>
 <a3b8e24d-5152-7243-545f-8a3e5fbaa53a@cumulusnetworks.com>
 <20191210143931.GF1344570@t480s.localdomain>
 <2f4e351c-158a-4f00-629f-237a63742f66@cumulusnetworks.com>
 <20191210151047.GB1423505@t480s.localdomain>
From:   Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
Message-ID: <1aa8b6e4-6a73-60b0-c5fb-c0dfa05e27e6@cumulusnetworks.com>
Date:   Tue, 10 Dec 2019 22:15:26 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
MIME-Version: 1.0
In-Reply-To: <20191210151047.GB1423505@t480s.localdomain>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/12/2019 22:10, Vivien Didelot wrote:
> Hi Nikolay,
> 
> On Tue, 10 Dec 2019 21:50:10 +0200, Nikolay Aleksandrov <nikolay@cumulusnetworks.com> wrote:
>>>> Why do you need percpu ? All of these seem to be incremented with the
>>>> bridge lock held. A few more comments below.
>>>
>>> All other xstats are incremented percpu, I simply followed the pattern.
>>>
>>
>> We have already a lock, we can use it and avoid the whole per-cpu memory handling.
>> It seems to be acquired in all cases where these counters need to be changed.
> 
> Since the other xstats counters are currently implemented this way, I prefer
> to keep the code as is, until we eventually change them all if percpu is in
> fact not needed anymore.
> 
> The new series is ready and I can submit it now if there's no objection.
> 
> 
> Thanks,
> 
> 	Vivien
> 

There is a reason other counters use per-cpu - they're incremented without any locking from fast-path.
The bridge STP code already has a lock which is acquired in all of these paths and we don't need
this overhead and the per-cpu memory allocations. Unless you can find a STP codepath which actually
needs per-cpu, I'd prefer you drop it.

Thank you,
 Nik
