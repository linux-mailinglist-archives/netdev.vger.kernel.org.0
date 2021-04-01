Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 80BBE35215C
	for <lists+netdev@lfdr.de>; Thu,  1 Apr 2021 23:12:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234512AbhDAVMD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Apr 2021 17:12:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47786 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234464AbhDAVMA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Apr 2021 17:12:00 -0400
Received: from mail-pg1-x52d.google.com (mail-pg1-x52d.google.com [IPv6:2607:f8b0:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ECFBCC0613E6
        for <netdev@vger.kernel.org>; Thu,  1 Apr 2021 14:12:00 -0700 (PDT)
Received: by mail-pg1-x52d.google.com with SMTP id t140so2341657pgb.13
        for <netdev@vger.kernel.org>; Thu, 01 Apr 2021 14:12:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding:content-language;
        bh=5ue1BU8DRC1M7wtcUC+ttBd+0ksITxtgJOrXfVlsK5Q=;
        b=y++0shFbJjlf2G74IcRdg76uqqrVoVpJDHjhJybq0dDh3+pvh695x5aCf/EakuEwUK
         HZ5kt+LjoF9rZlkX4yHHpKQ2jlMoYSCL68koyUaLdsfgyczkVkOSh3jgi3tmrrrVHuH5
         6vmzciZl5OEb+R0jQrNw2wTrW3nt8p9F0j7NyP/fhqiZ1qfGEqzcxvXET8IFXYAzcdbp
         TSKcTxHbBF6pFSF9yiuYi5ggjzomtdGYolCW4E8weHWebshPLEP/WZ9aTGD4W9oqJbiI
         zrq5mfTI54/TExECH1ZUI8NEkXEUbyHjIYdyUyHh5YBrjyIwpR2F2QxORrezmZflCX2y
         5C5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=5ue1BU8DRC1M7wtcUC+ttBd+0ksITxtgJOrXfVlsK5Q=;
        b=VkZLYGAHhPhtJJmcUt1yoOGUcvUyQZvv6n7MYffz8re7t7oXbqptQoiB9dAQQIYC1q
         pnZeDh0SRRCfHzSGSs/T2ImtvQB7F+0WmP1uX66DLmcgXXal04ytJo8IXgOjbOlyUlnF
         19gft+OMhDu75xXJ4S45tw+Tk1k9GovkyrTgy8p4JmJMt6aQdD39es7dECBVvnNwv+co
         8oGOEYfsuXSKUIC40jkJxdPLnkE67SI4uWfgTIMPk+N1sVL5tKf4HO3JzId5EclW1EMH
         jjOfGXVaaRE2MwVuVhXhbphlR3UFLTj7HpUo5gYF2uz2v66BhF6cEXfVd60gORGdZdPg
         Tc8Q==
X-Gm-Message-State: AOAM533wz254kmJRzoLX8SjbbN7GebUhUdbY1BKtdY95KKGuhXdHDst9
        LqI4o40h0uKCnYK7gbEcLsuX/tuayJSdRA==
X-Google-Smtp-Source: ABdhPJwRrJ7asY6P5vAyHI9Di9pDQTeZ6YtwQbMMabgCKKWi1m5uGqZK5USjk1C6K/WOjE+4zGTxBg==
X-Received: by 2002:a65:4942:: with SMTP id q2mr8977649pgs.34.1617311520400;
        Thu, 01 Apr 2021 14:12:00 -0700 (PDT)
Received: from Shannons-MacBook-Pro.local ([50.53.47.17])
        by smtp.gmail.com with ESMTPSA id x19sm6222848pfc.152.2021.04.01.14.11.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 01 Apr 2021 14:12:00 -0700 (PDT)
Subject: Re: [PATCH net-next 00/12] ionic: add PTP and hw clock support
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        drivers@pensando.io, Richard Cochran <richardcochran@gmail.com>
References: <20210401175610.44431-1-snelson@pensando.io>
 <YGY0/4Ab8Sf4NdHb@lunn.ch>
From:   Shannon Nelson <snelson@pensando.io>
Message-ID: <7e3a24c0-9dba-6bbd-7a38-4f8a321eb83c@pensando.io>
Date:   Thu, 1 Apr 2021 14:11:59 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.9.0
MIME-Version: 1.0
In-Reply-To: <YGY0/4Ab8Sf4NdHb@lunn.ch>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 4/1/21 2:02 PM, Andrew Lunn wrote:
> On Thu, Apr 01, 2021 at 10:55:58AM -0700, Shannon Nelson wrote:
>> This patchset adds support for accessing the DSC hardware clock and
>> for offloading PTP timestamping.
> Hi Shannon
>
> Please always Cc: the PTP maintainer for PTP patches.
> Richard Cochran <richardcochran@gmail.com>
>
> 	Andrew

Thanks for the heads-up, Andrew, I will do so on any followups.
sln

