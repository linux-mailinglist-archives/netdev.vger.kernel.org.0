Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2FCD2395A30
	for <lists+netdev@lfdr.de>; Mon, 31 May 2021 14:13:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231462AbhEaMOv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 May 2021 08:14:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41738 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231397AbhEaMOs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 31 May 2021 08:14:48 -0400
Received: from mail-qk1-x731.google.com (mail-qk1-x731.google.com [IPv6:2607:f8b0:4864:20::731])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7BE21C061574
        for <netdev@vger.kernel.org>; Mon, 31 May 2021 05:13:07 -0700 (PDT)
Received: by mail-qk1-x731.google.com with SMTP id c20so10988169qkm.3
        for <netdev@vger.kernel.org>; Mon, 31 May 2021 05:13:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=mX6vpqpr3JLgxu1jEwCMQgMPdHWhzij0Fneqz5FAH9c=;
        b=FT5P6jzsIGBxTh50FwxtMBBMcoExrJ12fQ5TLa93BPHFE8rdPR6U/L9ezueKmz7fSX
         IjUYPSvZNCvYvEHWPZTfTWYQFx+rAu4yE3+cVd3f8CdkNsiSrEzF9fy5XK7DbTKNek05
         8T5bjmjgwdgYw3qZiaBuyfvksJDtjBy5lCZaJ76SHh7dwiZ1CkHaVkIJAJh1dmUxy4xO
         BqeYmPr64/khITOn/W9i7ARNQCp9g35Mb7JPlRUu9c7KJ2EpkowcI0b+Yf/aaGgqYfzX
         dzX7whqSfMGe1qQdDB3YllMz8TfW6S6LylFoRJ+ikydwsPfY9PlVYAlqZPYHIbwnEoBR
         A65Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=mX6vpqpr3JLgxu1jEwCMQgMPdHWhzij0Fneqz5FAH9c=;
        b=EWxRWJUPnxC6azsOWr5SwxcwaQ7MlET3336HqAxXkRVTiBMXLyqdex85uaitm9ap92
         PcM3nAU430p68F2enP/GZ70ubSggPziT4pnIIv8/8K1SaoQVDK+sI422/F9VBptTIryG
         193fYc6cTDVb0qeO2L0PvkUkPV2lYcaIkYF8XJqm1q4ey6dk551lkWMIceo6FtZlwVl9
         YkiI3Ri7B2ygiGgN22Gn7s+wukqeA6pKiXimMRo9xLn+eQiT0mGsrh0SQIGQBM5IsNLj
         CaUi7i4ku5JfSspaij5JiZrqGDXu9IegAjH26AN9UlyTVGTY7FjHRDwxBMTaAQv0nf0w
         WkUA==
X-Gm-Message-State: AOAM532Eeysrn3+Z42PmcniwJpIjmTfTf0psJK/eKr86TtAwQUki5SoM
        KlIYslBMGzWC3EUFvM1drPISAA==
X-Google-Smtp-Source: ABdhPJzLbBjOLjfRjRGp4qrb0nKkpTdLK1WPh4CYmJ9ltPonzG40evaEQV5E30ZvHU0qPcpJ4eGe0A==
X-Received: by 2002:a37:46cd:: with SMTP id t196mr16298837qka.305.1622463186703;
        Mon, 31 May 2021 05:13:06 -0700 (PDT)
Received: from [192.168.1.79] (bras-base-kntaon1617w-grc-28-184-148-47-211.dsl.bell.ca. [184.148.47.211])
        by smtp.googlemail.com with ESMTPSA id p19sm8947842qki.119.2021.05.31.05.13.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 31 May 2021 05:13:06 -0700 (PDT)
Subject: Re: [PATCH net-next v3 0/3] net/sched: act_vlan: Fix modify to allow
 0
To:     Davide Caratti <dcaratti@redhat.com>,
        Boris Sukholitko <boris.sukholitko@broadcom.com>
Cc:     netdev@vger.kernel.org, Jiri Pirko <jiri@resnulli.us>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        linux-kselftest@vger.kernel.org, shuah@kernel.org,
        Ilya Lifshits <ilya.lifshits@broadcom.com>,
        Shmulik Ladkani <shmulik.ladkani@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>
References: <20210530114052.16483-1-boris.sukholitko@broadcom.com>
 <YLTPEzvYsUmxOIr9@dcaratti.users.ipa.redhat.com>
From:   Jamal Hadi Salim <jhs@mojatatu.com>
Message-ID: <98780fe0-f34f-277a-f137-543f7ddd5d0c@mojatatu.com>
Date:   Mon, 31 May 2021 08:13:05 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.9.1
MIME-Version: 1.0
In-Reply-To: <YLTPEzvYsUmxOIr9@dcaratti.users.ipa.redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2021-05-31 7:57 a.m., Davide Caratti wrote:
> On Sun, May 30, 2021 at 02:40:49PM +0300, Boris Sukholitko wrote:
>> Currently vlan modification action checks existence of vlan priority by
>> comparing it to 0. Therefore it is impossible to modify existing vlan
>> tag to have priority 0.
> 
> hello Boris, thanks for following up!
>   
>> Change Log:
>> v2 -> v3:
>> - Push assumes that the priority is being set
>> - tcf_vlan_get_fill_size accounts for priority existence
> 
> Reviewed-by: Davide Caratti <dcaratti@redhat.com>
> 

Looks good to me as well. And thanks for adding the tests!

Acked-by: Jamal Hadi Salim <jhs@mojatatu.com>

cheers,
jamal
