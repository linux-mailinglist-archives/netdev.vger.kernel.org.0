Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CFD93A6DCB
	for <lists+netdev@lfdr.de>; Tue,  3 Sep 2019 18:17:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730034AbfICQRN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Sep 2019 12:17:13 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:39537 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728571AbfICQRN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Sep 2019 12:17:13 -0400
Received: by mail-wr1-f67.google.com with SMTP id t16so18163458wra.6
        for <netdev@vger.kernel.org>; Tue, 03 Sep 2019 09:17:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=e1amEEi7DPleRDG4iwwlMlME+rEqQsHQWVcEf1HZJDk=;
        b=Oi5pIQeUGiG/BPcOqP3Lv4SwTaWI0ADcoHLhXf/vQK76+p+/deVdjuSPrIgIg7oTOm
         IBmk7o0+9wVdoPfL/YcX7ldQ347HyAyG6oRoh1ePoRCzo1nmGF5DEWa0VtuXLoDweQi9
         +wCKx7eFX22DQtydqIsQ4jQ1wq5RXa734QWQuNmMsMO/5S6CyA5sNjQemTyxmJZE8OUy
         Qj8ZjHQMjCD67VgLShJ2ZeBaEvurK2/Z7FFR2NDKcBMJy3NpONNkcaxGqNm6r38FwQ2Y
         6ol4XdlHF5XsfWPf/nzcKNEG2+R0jMRcF46Fhn4DRQsSsa3JfBW/OmPT61XcFZPCRDdn
         ruAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=e1amEEi7DPleRDG4iwwlMlME+rEqQsHQWVcEf1HZJDk=;
        b=OYINvCTLCFjIAvW34p8GciBdr5GGFi4Mu0oi47w4oibsWvJxyE9e7QxCG0LMnDwxW0
         aXkxln+sw3p1/5q4JrcYWGtAti86FRlN0sjsF0wtXruVZ2rk7zWj+mLNaempye1l+QX3
         Oy80bKbsHb+SPt3aHJTWzW4mar/oOU1AJ+lH4jZcK1tts5Iaus4keqwrjKwDFvnBKFaK
         KYlWxFUU+0VIGlGtY0BO3m3a1yGY9TZgu4I4YnX6hKIt6I2V7ztNPh4DHHAt/N66lHtR
         lz17AbG1q/uTymIQ3ZRqA40YdzuYorRWx8UjnbMEIj/cgobNkBUwMkY0bTkilgLAbaRt
         vveg==
X-Gm-Message-State: APjAAAXFnt8q6QgBOeIg7ITNbZCe3MriL+BP+RCdJCG4OggV09rMt2I+
        1xvm5X34kUZVcwVxQ3mrvEw=
X-Google-Smtp-Source: APXvYqz3d/ClUWRkLtdLQNijnlJ4gfrZjRtkVEEKE6TnUHYwaMBEFgRlLQCnxdBcu7Oz+6XHY7MDUg==
X-Received: by 2002:a5d:6ac8:: with SMTP id u8mr7959317wrw.104.1567527431480;
        Tue, 03 Sep 2019 09:17:11 -0700 (PDT)
Received: from [192.168.8.147] (83.173.185.81.rev.sfr.net. [81.185.173.83])
        by smtp.gmail.com with ESMTPSA id j20sm27829937wre.65.2019.09.03.09.17.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 03 Sep 2019 09:17:11 -0700 (PDT)
Subject: Re: [PATCH] Clock-independent TCP ISN generation
To:     Cyrus Sh <sirus.shahini@gmail.com>,
        Eric Dumazet <eric.dumazet@gmail.com>, davem@davemloft.net
Cc:     shiraz.saleem@intel.com, jgg@ziepe.ca, arnd@arndb.de,
        netdev@vger.kernel.org, sirus@cs.utah.edu
References: <70c41960-6d14-3943-31ca-75598ad3d2d7@gmail.com>
 <fa0aadb3-9ada-fb08-6f32-450f5ac3a3e1@gmail.com>
 <bf10fbfb-a83f-a8d8-fefc-2a2fd1633ef8@gmail.com>
 <2cbd5a8f-f120-a7df-83a3-923f33ca0a10@gmail.com>
 <e3bf138f-672e-cefa-5fe5-ea25af8d3d61@gmail.com>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <492bb69e-0722-f6fc-077a-2348edf081d8@gmail.com>
Date:   Tue, 3 Sep 2019 18:17:09 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <e3bf138f-672e-cefa-5fe5-ea25af8d3d61@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 9/3/19 6:06 PM, Cyrus Sh wrote:
> 
> 
> On 9/3/19 9:59 AM, Eric Dumazet wrote:
>>
>> You could add a random delay to all SYN packets, if you believe your host has clock skews.
> 
> In theory yes, but again do you know any practical example with tested
> applications and the list of the rules? I'm interested to see an actual example
> that somebody has carried out and observed its results.
> 

Do you have a real program showing us how this clock skew can be used practically ?

