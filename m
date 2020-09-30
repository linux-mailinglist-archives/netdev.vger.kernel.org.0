Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 73D7027F480
	for <lists+netdev@lfdr.de>; Wed, 30 Sep 2020 23:55:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730998AbgI3VzM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Sep 2020 17:55:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45530 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730958AbgI3VzF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Sep 2020 17:55:05 -0400
Received: from mail-pg1-x531.google.com (mail-pg1-x531.google.com [IPv6:2607:f8b0:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E83E9C0613D3
        for <netdev@vger.kernel.org>; Wed, 30 Sep 2020 14:55:04 -0700 (PDT)
Received: by mail-pg1-x531.google.com with SMTP id s31so2056665pga.7
        for <netdev@vger.kernel.org>; Wed, 30 Sep 2020 14:55:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding:content-language;
        bh=winCJzsTjvWJuLI5jZvB9zMxjgesq0GWvLBJvTg56N0=;
        b=VBaeBNvLwEdht6L9JYXvcCOxYc5/N9sYVmc5w4M8vSbucUE9U5hbIHG/eIhIK8NSzU
         CCZ/aZHuOCsTsA/FczBYdDk2QNp/T9rDevdn9AJfqlbE7E8d9n8WSoBz2iFwkyKEs6QB
         d9jB2yFM6Nbwx+dr1q/A1cPq8l5uL5Ob7t4E+PxdGdyX0ElGa3Nwxv361BQ+qMMWN9if
         afbgih/tK+U3B0zDtuS3Wu22PSrfunIZl9cMH1K7QlmzsUyBcVlaA9NTJYv3XNWgKhiI
         6DpOiqXB599EN3FBkTFKDD4jVcZAtkyttxMa4TLjDQfJRJnCvpFiN5QSV7OYymlH3lHS
         IURQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=winCJzsTjvWJuLI5jZvB9zMxjgesq0GWvLBJvTg56N0=;
        b=mz9NkbaiqRn3+kB6mCXVJbky2gHtMqIR2c0uBigAyH5nNmRzGjLlCScj0zqiPoShmA
         QZlvlhbT98AZUF2uK3D7eEsWOK587mjolgB0PjgqqnBW1X+6O1F2sc1RO8XfJIQqppNc
         1xVgwsBxk2BgdkdbHte8Kc8CMhuOLuaZ5n0DfuFOwvJP66n2EAKjqXQLGI+6CfVEGTGP
         1X5ZzhVAbyeC/FhhlNRY9tmzofNpztkfJe/cCg/dJlFxb7HOXJztXInVEHhjpR/u09wL
         UEf4+WyGXtbyt3CeDb+gf6jupV0WGjy2sY8tcCRYIyaibxldJwL2QehTYy5nP4ne9Ffu
         7TnQ==
X-Gm-Message-State: AOAM5326w5cd5GnZrKlmjoTpQ/0pyFDmr1Q1MANUtUWhvgTbDyiztFsM
        PnRMqKBY0AhlsCYG1v9CCkXZdsSY1g8Yxw==
X-Google-Smtp-Source: ABdhPJzDY1NhL3FYJJs133tTjlJUn1ZS922puwJ4vmarb9jAPLhocnfNPNa9eGmQ3ubm3lJKwEZfTw==
X-Received: by 2002:a17:902:8f8f:b029:d2:439c:3b7d with SMTP id z15-20020a1709028f8fb02900d2439c3b7dmr4059875plo.39.1601502904152;
        Wed, 30 Sep 2020 14:55:04 -0700 (PDT)
Received: from Shannons-MacBook-Pro.local (static-50-53-47-17.bvtn.or.frontiernet.net. [50.53.47.17])
        by smtp.gmail.com with ESMTPSA id y197sm3651622pfc.220.2020.09.30.14.55.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 30 Sep 2020 14:55:03 -0700 (PDT)
Subject: Re: [iproute2-next v1] devlink: display elapsed time during flash
 update
To:     Jacob Keller <jacob.e.keller@intel.com>,
        Jakub Kicinski <kubakici@wp.pl>
Cc:     netdev@vger.kernel.org
References: <20200929215651.3538844-1-jacob.e.keller@intel.com>
 <df1ad702-ab31-e027-e711-46d09f8fa095@pensando.io>
 <1f8a0423-97ef-29c4-4d77-4b91d23a9e7c@intel.com>
 <20200930143659.7fee35d4@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <7a9ff898-bdae-9dab-12a9-30d825b6b67d@intel.com>
From:   Shannon Nelson <snelson@pensando.io>
Message-ID: <d2cf51a6-f09d-7507-e5f1-e6cd84819554@pensando.io>
Date:   Wed, 30 Sep 2020 14:55:57 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <7a9ff898-bdae-9dab-12a9-30d825b6b67d@intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 9/30/20 2:43 PM, Jacob Keller wrote:
> On 9/30/2020 2:36 PM, Jakub Kicinski wrote:
>> On Wed, 30 Sep 2020 14:20:43 -0700 Jacob Keller wrote:
>>>> Thanks, Jake.  In general this seems to work pretty well.  One thing,
>>>> tho'...
>>>>
>>>> Our fw download is slow (I won't go into the reasons here) so we're
>>>> clicking through the Download x% over maybe 100+ seconds.  Since we send
>>>> an update every 3% or so, we end up seeing the ( 0m 3s ) pop up and stay
>>>> there the whole time, looking a little odd:
>>>>
>>>>       ./iproute2-5.8.0/devlink/devlink dev flash pci/0000:b5:00.0 file
>>>> ionic/dsc_fw_1.15.0-150.tar
>>>>       Preparing to flash
>>>>       Downloading  37% ( 0m 3s )
>>>>     ...
>>>>       Downloading  59% ( 0m 3s )
>>>>     ...
>>>>       Downloading  83% ( 0m 3s )
>> I'm not sure how to interpret this - are you saying that the timer
>> doesn't tick up or that the FW happens to complete the operation right
>> around the 3sec mark?
>>
>
> The elapsed time is calculated from the last status message we receive.
> In Shannon's case, the done/total % status messages come approximately
> slow enough that the elapsed time message keeps popping up. Since it's
> measuring from the last time we got a status message, it looks weird
> because it resets to 3 seconds over and over and over.
>
>>>> And at the end we see:
>>>>
>>>>       Preparing to flash
>>>>       Downloading 100% ( 0m 3s )
>>>>       Installing ( 0m 43s : 25m 0s )
>>>>       Selecting ( 0m 5s : 0m 30s )
>>>>       Flash done
>>>>
>>>> I can have the driver do updates more often in order to stay under the 3
>>>> second limit and hide this, but it looks a bit funky, especially at the
>>>> end where I know that 100% took a lot longer than 3 seconds.
>>>>    
>>> I think we have two options here:
>>>
>>> 1) never display an elapsed time when we have done/total information
>>>
>>> or
>>>
>>> 2) treat elapsed time as a measure since the last status message
>>> changed, refactoring this so that it shows the total time spent on that
>>> status message.
>>>
>>> Thoughts on this? I think I'm leaning towards (2) at the moment myself.
>>> This might lead to displaying the timing info on many % calculations
>>> though... Hmm
>> Is the time information useful after stage is complete? I'd just wipe
>> it before moving on to the next message.
>>
> My point was about changing when we calculated elapsed time from to be
> "since the status message changed" rather than "since the last time the
> driver sent any status even if the message remains the same".

This would be better, and is a bit like what I was imagining early on, 
but at this point I'm wondering if the display of the elapsed time is 
actually useful, or simply making it messier.

>
> I think clearing the timing message is a good improvement either way, so
> I'll do that too.
Yes.

sln


