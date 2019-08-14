Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C3E868DEE7
	for <lists+netdev@lfdr.de>; Wed, 14 Aug 2019 22:34:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727523AbfHNUe6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Aug 2019 16:34:58 -0400
Received: from mail-lf1-f68.google.com ([209.85.167.68]:43725 "EHLO
        mail-lf1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725895AbfHNUe5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Aug 2019 16:34:57 -0400
Received: by mail-lf1-f68.google.com with SMTP id c19so196963lfm.10
        for <netdev@vger.kernel.org>; Wed, 14 Aug 2019 13:34:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cumulusnetworks.com; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=WaTpDcNJiFZ4IX53WMjagAg27UGU/T1qAMZT3ZurcgM=;
        b=IPxN8Jas+/uH5XGOyP1zFTo6cyC+dxOCOwsRWzAF/DXb+/ZAyQrLYV9ajpXQZEK1PJ
         o6pCQNuei16cetLhbZTmWt9ZbquwZTsHkN9Z0EjN0D48sLX50LKJKpTLS+JLHNnXU8vh
         Nn+oWRzJFG/tq7mCHEWJOZGE++KBtJSnfUd10=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=WaTpDcNJiFZ4IX53WMjagAg27UGU/T1qAMZT3ZurcgM=;
        b=R6j2+4Fjbb9OvJDii3BEB7qDkykjecntCIrcZggE8PSakvMdOY6rQxOG8zvkcW8qL0
         2n3PbGQRBj4HW+mHUdR5dMs9rPBiAiI09bh4B+3MptigE44psSnYAOJbOHeMkdeZwlED
         m2+9h3Mxr2kHcIu9PVTyHzzZ6NQmL55FQfjAelhtGvrfR5e9mvxvZkaHEgGPUDft43fq
         MDYWL9AAriIawGqYZgTCvOH52zBhLXN4F7vt3PaAupSP7uWa5/2TSiNiAc4lihO3BWpD
         YPaV/P5qEeKBopdtsEkb4n+Z0mKwa+nk8l9KSuRxLumTACqkRaSAv5GAmKcloV/bCNuy
         9n7w==
X-Gm-Message-State: APjAAAXnDfIc50nSmIasU6PVjR8rERNqTWSL+JV/xYBfgoRV8o5/cwxO
        E3KWmmSeY2y/NG7ab2/BS2+kmA==
X-Google-Smtp-Source: APXvYqwSFkz4D0yKfJypaBayIEzRaIzmqDibuhPMxmuQunuqn5fcJSzpV6yh8GrMUl5djQ3M7f8xlw==
X-Received: by 2002:a19:ed11:: with SMTP id y17mr629641lfy.141.1565814895558;
        Wed, 14 Aug 2019 13:34:55 -0700 (PDT)
Received: from [192.168.0.104] ([79.134.174.40])
        by smtp.googlemail.com with ESMTPSA id g12sm97826lfc.96.2019.08.14.13.34.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 14 Aug 2019 13:34:55 -0700 (PDT)
Subject: Re: [PATCH net-next] mcast: ensure L-L IPv6 packets are accepted by
 bridge
To:     =?UTF-8?Q?Linus_L=c3=bcssing?= <linus.luessing@c0d3.blue>,
        Patrick Ruddy <pruddy@vyatta.att-mail.com>
Cc:     bridge@lists.linux-foundation.org,
        Ido Schimmel <idosch@idosch.org>, netdev@vger.kernel.org,
        roopa@cumulusnetworks.com
References: <20190813141804.20515-1-pruddy@vyatta.att-mail.com>
 <20190813195341.GA27005@splinter>
 <43ed59db-9228-9132-b9a5-31c8d1e8e9e9@cumulusnetworks.com>
 <620d3cfbe58e3ae87ef1d5e7f2aa1588cac3e64a.camel@vyatta.att-mail.com>
 <20190814201138.GE2431@otheros>
From:   Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
Message-ID: <d0be5038-e76f-d21b-a034-e450cbb3010e@cumulusnetworks.com>
Date:   Wed, 14 Aug 2019 23:34:47 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190814201138.GE2431@otheros>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/14/19 11:11 PM, Linus Lüssing wrote:
> On Wed, Aug 14, 2019 at 05:40:58PM +0100, Patrick Ruddy wrote:
>> The group is being joined by MLD at the L3 level but the packets are
>> not being passed up to the l3 interface becasue there is a MLD querier
>> on the network
>>
>> snippet from /proc/net/igmp6
>> ...
>> 40   sw1             ff0200000000000000000001ff008700     1 00000004 0
>> 40   sw1             ff020000000000000000000000000002     1 00000004 0
>> 40   sw1             ff020000000000000000000000000001     1 0000000C 0
>> 40   sw1             ff010000000000000000000000000001     1 00000008 0
>> 41   lo1             ff020000000000000000000000000001     1 0000000C 0
>> 41   lo1             ff010000000000000000000000000001     1 00000008 0
>> 42   sw1.1           ff020000000000000000000000000006     1 00000004 0
>> 42   sw1.1           ff020000000000000000000000000005     1 00000004 0
>> 42   sw1.1           ff0200000000000000000001ff000000     2 00000004 0
>> 42   sw1.1           ff0200000000000000000001ff008700     1 00000004 0
>> 42   sw1.1           ff0200000000000000000001ff000099     1 00000004 0
>> 42   sw1.1           ff020000000000000000000000000002     1 00000004 0
>> 42   sw1.1           ff020000000000000000000000000001     1 0000000C 0
>> 42   sw1.1           ff010000000000000000000000000001     1 00000008 0
>> ...
>>
>> the bridge is sw1 and the l3 intervace is sw1.1
> 
> What kind of interface is sw1.1 exactly? Is it a VLAN or a VRF
> interface? Something else?
> 
+1

> Could you also post the output of bridge mdb show?
> 
> Regards, Linus
> 
> 
> PS: Also please include the bridge mailinglist in the future.
> 

Note that if you'd like to debug a host joined group currently bridge mdb show
will not dump it and if the group is host-joined only it
can even be empty. You can use my latest set (not applied yet):
http://patchwork.ozlabs.org/project/netdev/list/?series=125169

Alternatively you could monitor the mdb events, it will show up there even
today without any changes (bridge monitor mdb) and you can check if it's
getting deleted.

Cheers,
 Nik
