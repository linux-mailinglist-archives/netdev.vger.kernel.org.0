Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9BCB6234A44
	for <lists+netdev@lfdr.de>; Fri, 31 Jul 2020 19:31:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387455AbgGaRbp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Jul 2020 13:31:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50516 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732970AbgGaRbo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 Jul 2020 13:31:44 -0400
Received: from mail-pl1-x642.google.com (mail-pl1-x642.google.com [IPv6:2607:f8b0:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF82DC061574;
        Fri, 31 Jul 2020 10:31:44 -0700 (PDT)
Received: by mail-pl1-x642.google.com with SMTP id p1so17765166pls.4;
        Fri, 31 Jul 2020 10:31:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=fQJ4K4WTAcUQrIZ+9ByJXhYGj+Opn9+r2wnqSlYmSBM=;
        b=QI7R7ijI9AZSDPbEh3LMc3YQofbpFJMhFT6cxjz1oqbQKVmG4CM2BSdq2qVMctkd55
         kjkOfrSanPeMHc3SeMGVdn0Rc8mGARN0Ilg52nMYM1N/qwLlTKhlecu/6rbQ8A8sfgzL
         x6dCJRdSumPzC2QnN8CIy7w3BhSjbp285ULapanyGZXg6ttP5LAgKbd+dRdidEdQ3XTK
         Qwlj/2AVs7nMFxu6Sz5VHVOuRk2eGTIjOVQw9WGell4N7gEJGD/ElR3bRAkmGnV1FTXT
         e1fORWiLm8V9jVYbEFKi/R6hWnJwfi23eK4YFDQ/oxlr9w2rXaO9Wkbkzd3uuhYjtYER
         SY3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=fQJ4K4WTAcUQrIZ+9ByJXhYGj+Opn9+r2wnqSlYmSBM=;
        b=HYzEoR8NHggmfpv8QBF5CHUMDzfU1l3IvQJyUEP16uPycarrEOpgaKxC3BSYWbUdwY
         ybmWgN02P37+fAyb1KOemoAaZOZLZPrcs6M/EwDWx8dE8dCdi6peRPttIYy6s/ISt7u7
         z8GQPBxtyrrLltKL/hwIZS0knk+9rhKFP4Q1mdCqGCnDfWzP+jLF12L1Jm9d146MHt6A
         9trGPH8kb/bk9EmCOqPBT3X9z0IuD8AwpRTZ+FnSjF2QQMDYchcWk76cTtgtRUJE0ahn
         Zh9b0dlfBAYm38DL9vyJvJJkD8bovHOMv1r30P9+yusQfYCmxSnbS1M5ihirIIS11Nzs
         q3Og==
X-Gm-Message-State: AOAM533zJ57LPjGWB+lxNoFUBxqUBnWFp6dl1MIgEUjV+Nz1lbQJWTXd
        xcqDZV/OMUM6aWZqG+5EDZU=
X-Google-Smtp-Source: ABdhPJwN1D1QXUWHzVcer4sHJ0Gl2Si8s98l/xxCxm314xCSJZkDLMkSokeuZkp8aWjGmIf3ozRyQw==
X-Received: by 2002:a17:90a:2210:: with SMTP id c16mr2992127pje.65.1596216704297;
        Fri, 31 Jul 2020 10:31:44 -0700 (PDT)
Received: from [10.1.10.11] (c-73-241-150-58.hsd1.ca.comcast.net. [73.241.150.58])
        by smtp.gmail.com with ESMTPSA id y17sm10590971pfe.30.2020.07.31.10.31.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 31 Jul 2020 10:31:43 -0700 (PDT)
Subject: Re: [PATCH v3 bpf-next 1/9] tcp: Use a struct to represent a
 saved_syn
To:     Eric Dumazet <edumazet@google.com>, Martin KaFai Lau <kafai@fb.com>
Cc:     bpf <bpf@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        kernel-team <kernel-team@fb.com>,
        Lawrence Brakmo <brakmo@fb.com>,
        Neal Cardwell <ncardwell@google.com>,
        netdev <netdev@vger.kernel.org>,
        Yuchung Cheng <ycheng@google.com>
References: <20200730205657.3351905-1-kafai@fb.com>
 <20200730205704.3352619-1-kafai@fb.com>
 <CANn89iK8h8x6oVZ0O0P+3gs1NyxfX0F--+Gw4CjOBhHE0NxqqA@mail.gmail.com>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <a2b65147-092b-6bbc-bd62-19f2c1e9345c@gmail.com>
Date:   Fri, 31 Jul 2020 10:31:41 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <CANn89iK8h8x6oVZ0O0P+3gs1NyxfX0F--+Gw4CjOBhHE0NxqqA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 7/31/20 8:57 AM, Eric Dumazet wrote:
> On Thu, Jul 30, 2020 at 1:57 PM Martin KaFai Lau <kafai@fb.com> wrote:
>>
>> The TCP_SAVE_SYN has both the network header and tcp header.
>> The total length of the saved syn packet is currently stored in
>> the first 4 bytes (u32) of an array and the actual packet data is
>> stored after that.
>>
>> A latter patch will add a bpf helper that allows to get the tcp header
> 
> s/latter/later/

Sorry, brain fart. I am using a different wording, that is all ;)

