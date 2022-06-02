Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BF58B53B6C8
	for <lists+netdev@lfdr.de>; Thu,  2 Jun 2022 12:18:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233462AbiFBKRK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Jun 2022 06:17:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39422 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230153AbiFBKRI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Jun 2022 06:17:08 -0400
Received: from mail-lf1-x12e.google.com (mail-lf1-x12e.google.com [IPv6:2a00:1450:4864:20::12e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E81FE1C8645;
        Thu,  2 Jun 2022 03:17:06 -0700 (PDT)
Received: by mail-lf1-x12e.google.com with SMTP id a15so7039600lfb.9;
        Thu, 02 Jun 2022 03:17:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:in-reply-to:references:date:message-id
         :mime-version;
        bh=OfL1oE8E5VUJipAihqvicf8O595es3dpUsW+47EuKCY=;
        b=fPH/OXEF4aWfuqMLZjJjspqSrKGuHIXivBc2TH1XFAnfKX7dIES4CqwmbJkJMkgZaS
         aLbLeB03ocWh/mJ3KX5nwifk0mqRjdYkZMBcDWNU+J9riwzosD9MqiU8d5k9tTac1P3y
         40iICoXleS9wOCo85Jxxwb6xc51YKyEO4qYx1qIDTuLPrxTPr3yRmgeDY+590QOUSf+d
         ZeLL6yG4Y02fLrfMInR6zJTwvacH5r2oz+VnG5WR/uDN0V7EA9miP+1pwQ5kIhycmtaF
         C0SdrN0oWry6F4di+poq7ojQ9yHRqyZiRVQkvDkdK4obYqs128afI9ADaLUdaT3YjT1d
         Fpsw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=OfL1oE8E5VUJipAihqvicf8O595es3dpUsW+47EuKCY=;
        b=aVNlyCFTlLCR6YKWcIkbWD5H61ztGZYLTRJ83BP8qX3pC9OBODu0X/pOFCCQZyI2mw
         y7DRmFEgn1H6KuQKuHjFAgVkeoTYKfXy0z8s4oF525bney3IqxJ9jB4ja9X+ln4N6gF5
         8PuKf4p84JLACETl4GMxEf3oocMxo8TPO5WfhEfW3J3/KXG/dRXUkoETrnHHFQEus6yn
         sw/JzIsRf+vZLH7KebOW11txv/KWXxX23UKlb40bEO9BdbMZTaq20JNMC3RbYWEDN0qI
         97itggczeGixY86q0D1TdEJWn82DBrYeWE9PbWF+/qmnPtHg7bSgIxOLEDqpq8EvFniY
         UTog==
X-Gm-Message-State: AOAM532YtuqOwx7fdhvB/D0fKbqECs00uAEd/tQ7MLYQNRfehyzgt9Md
        nSI77x3cna0QjiqPR6REyRDMVmQh3lDuJg==
X-Google-Smtp-Source: ABdhPJwoXhgkd+mJ5N9o5LUK3SSXkfhC3/uG/ZU+2A8rBS13nRZXnz4HRP9Jj6FhMYPTW7Ck/a9NqA==
X-Received: by 2002:a05:6512:3130:b0:479:2e0:631b with SMTP id p16-20020a056512313000b0047902e0631bmr5965447lfd.561.1654165025269;
        Thu, 02 Jun 2022 03:17:05 -0700 (PDT)
Received: from wse-c0127 ([208.127.141.28])
        by smtp.gmail.com with ESMTPSA id h16-20020a2e5310000000b0024f3d1dae87sm790662ljb.15.2022.06.02.03.17.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Jun 2022 03:17:04 -0700 (PDT)
From:   Hans Schultz <schultz.hans@gmail.com>
X-Google-Original-From: Hans Schultz <schultz.hans+netdev@gmail.com>
To:     Nikolay Aleksandrov <razor@blackwall.org>,
        Hans Schultz <schultz.hans@gmail.com>,
        Ido Schimmel <idosch@nvidia.com>
Cc:     Ido Schimmel <idosch@idosch.org>, davem@davemloft.net,
        kuba@kernel.org, netdev@vger.kernel.org,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, Jiri Pirko <jiri@resnulli.us>,
        Ivan Vecera <ivecera@redhat.com>,
        Roopa Prabhu <roopa@nvidia.com>, Shuah Khan <shuah@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        linux-kernel@vger.kernel.org, bridge@lists.linux-foundation.org,
        linux-kselftest@vger.kernel.org
Subject: Re: [PATCH V3 net-next 1/4] net: bridge: add fdb flag to extent
 locked port feature
In-Reply-To: <d88b6090-2ac8-0664-0e38-bb2860be7f6e@blackwall.org>
References: <20220524152144.40527-1-schultz.hans+netdev@gmail.com>
 <20220524152144.40527-2-schultz.hans+netdev@gmail.com>
 <Yo+LAj1vnjq0p36q@shredder> <86sfov2w8k.fsf@gmail.com>
 <YpCgxtJf9Qe7fTFd@shredder> <86sfoqgi5e.fsf@gmail.com>
 <YpYk4EIeH6sdRl+1@shredder> <86y1yfzap3.fsf@gmail.com>
 <d88b6090-2ac8-0664-0e38-bb2860be7f6e@blackwall.org>
Date:   Thu, 02 Jun 2022 12:17:01 +0200
Message-ID: <86sfonjroi.fsf@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On tor, jun 02, 2022 at 12:33, Nikolay Aleksandrov <razor@blackwall.org> wrote:
> On 02/06/2022 12:17, Hans Schultz wrote:
>> On tis, maj 31, 2022 at 17:23, Ido Schimmel <idosch@nvidia.com> wrote:
>>> On Tue, May 31, 2022 at 11:34:21AM +0200, Hans Schultz wrote:

>> Another issue is that
>> bridge fdb add MAC dev DEV master static
>> seems to add the entry with the SELF flag set, which I don't think is
>> what we would want it to do or?
>
> I don't see such thing (hacked iproute2 to print the flags before cmd):
> $ bridge fdb add 00:11:22:33:44:55 dev vnet110 master static
> flags 0x4
>
> 0x4 = NTF_MASTER only
>

I also get 0x4 from iproute2, but I still get SELF entries when I look
with:
bridge fdb show dev DEV

>> Also the replace command is not really supported properly as it is. I
>> have made a fix for that which looks something like this:
>> 
>> diff --git a/net/bridge/br_fdb.c b/net/bridge/br_fdb.c
>> index 6cbb27e3b976..f43aa204f375 100644
>> --- a/net/bridge/br_fdb.c
>> +++ b/net/bridge/br_fdb.c
>> @@ -917,6 +917,9 @@ static int fdb_add_entry(struct net_bridge *br, struct net_bridge_port *source,
>>                 if (flags & NLM_F_EXCL)
>>                         return -EEXIST;
>>  
>> +               if (flags & NLM_F_REPLACE)
>> +                       modified = true;
>> +
>>                 if (READ_ONCE(fdb->dst) != source) {
>>                         WRITE_ONCE(fdb->dst, source);
>>                         modified = true;
>> 
>> The argument for always sending notifications to the driver in the case
>> of replace is that a replace command will refresh the entries timeout if
>> the entry is the same. Any thoughts on this?
>
> I don't think so. It always updates its "used" timer, not its "updated" timer which is the one
> for expire. A replace that doesn't actually change anything on the entry shouldn't generate
> a notification.

Okay, so then there is missing checks on flags as the issue arose from
replacing locked entries with dynamic entries. I will do another fix
based on flags as modified needs to be true for the driver to get notified.
