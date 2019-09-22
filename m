Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AC35BBAA28
	for <lists+netdev@lfdr.de>; Sun, 22 Sep 2019 21:53:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437560AbfIVTXS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 22 Sep 2019 15:23:18 -0400
Received: from mail-io1-f47.google.com ([209.85.166.47]:40942 "EHLO
        mail-io1-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2436454AbfIVTXQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 22 Sep 2019 15:23:16 -0400
Received: by mail-io1-f47.google.com with SMTP id h144so28258576iof.7
        for <netdev@vger.kernel.org>; Sun, 22 Sep 2019 12:23:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=YNF4BJoEfTZ6yF6Euv2wHggS1gb0xTHHrjsaFO+MrPQ=;
        b=AogUcGjJIXArr2khTfs8MA3oV/TOkjvsXelaErnqVk4Dn+AHRySSqOyPysl4rbWlrf
         +jQcWhJULsBYU8lZygOn4H0UTDeo6IE+GpvpCWmbIKX/SjHIolNeJCEbb9hSuS0ylRaR
         SBrqFcxb6xw7Ks9t+MmenTB1kCoOi5dBD5hokRYZJt+28yflUNwo+QIpR63n8SnrJSxG
         mxa2DyeTz1AOER4DpdeXrULjUJR4FySoxdkhvQ8dpOQhCLbKaQFcAZ1oHhLd34GMOue6
         RrI8v70xKgyAQGyb3B/0XnUdtAGTXD3u2RAuV9pATMd49TC3qZ9twQMbrvkabanLdcPM
         M/Dw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=YNF4BJoEfTZ6yF6Euv2wHggS1gb0xTHHrjsaFO+MrPQ=;
        b=L62cCz2jdlKR1lcze8d/TfVSRiTgyb1Zj3Vn9+sD46NF1SPFWoS7N8EyytwlmwtfUX
         HumClMeh6kaHMzxEn8sAO8y7VMjgiBPiI67Wz4b6XAocVhkpF2Ut+yaWcg3SjCesWAG2
         cMi/EvxcM7RLpsWsSnx4e1KUN1HlcekPmufJsR3xYvFDaJorvodCPnlV0InQV+bMlMiM
         bep9NaQo4h/rkAiHM0lUaDSrrbYGRMeqhNgDy6W8VZwD82tXreIsRlE16ft0r3k9zEWV
         V0PkoQXE0ZTHvbPMo/1CszUrfX6wvVbKj5vDkMbKp/lD6u9wlBJD4oMC+6fEzd89RQ6Q
         oAjQ==
X-Gm-Message-State: APjAAAUECVD5obyNMfUbtY/m9sBhmM/SkmN9DT+ve7iqpYkH8x09ORJt
        UwoKosdy4QNQMXtLvK+wRrd4YnVq
X-Google-Smtp-Source: APXvYqzkeszbvZ1eQ/aYq9eQ9GyNWo/cy98CeZFYZUNk5UmW4w6DVxd2t4nuAJtIq2WBZBA34iJjBQ==
X-Received: by 2002:a02:3785:: with SMTP id r127mr32559441jar.40.1569180195065;
        Sun, 22 Sep 2019 12:23:15 -0700 (PDT)
Received: from dahern-DO-MB.local ([2601:282:800:fd80:e0ce:c2a7:805f:6f8b])
        by smtp.googlemail.com with ESMTPSA id j11sm6201846ioa.55.2019.09.22.12.23.13
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 22 Sep 2019 12:23:14 -0700 (PDT)
Subject: Re: Strange routing with VRF and 5.2.7+
To:     Ben Greear <greearb@candelatech.com>,
        netdev <netdev@vger.kernel.org>
References: <91749b17-7800-44c0-d137-5242b8ceb819@candelatech.com>
 <51aae991-a320-43be-bf73-8b8c0ffcba60@candelatech.com>
 <7d1de949-5cf0-cb74-6ca3-52315c34a340@candelatech.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <795cb41e-4990-fdbe-8cbe-9c0ada751b80@gmail.com>
Date:   Sun, 22 Sep 2019 13:23:13 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:60.0)
 Gecko/20100101 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <7d1de949-5cf0-cb74-6ca3-52315c34a340@candelatech.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 9/20/19 9:57 AM, Ben Greear wrote:
> On 9/10/19 6:08 PM, Ben Greear wrote:
>> On 9/10/19 3:17 PM, Ben Greear wrote:
>>> Today we were testing creating 200 virtual station vdevs on ath9k,
>>> and using
>>> VRF for the routing.
>>
>> Looks like the same issue happens w/out VRF, but there I have oodles
>> of routing
>> rules, so it is an area ripe for failure.
>>
>> Will upgrade to 5.2.14+ and retest, and try 4.20 as well....
> 
> Turns out, this was ipsec (strongswan) inserting a rule that pointed to
> a table
> that we then used for a vrf w/out realizing the rule was added.
> 
> Stopping strongswan and/or reconfiguring how routing tables are assigned
> resolved the issue.
> 

Hi Ben:

Since you are the pioneer with vrf and ipsec, can you add an ipsec
section with some notes to Documentation/networking/vrf.txt?

