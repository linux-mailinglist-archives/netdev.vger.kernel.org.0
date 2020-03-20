Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 499E018C6BE
	for <lists+netdev@lfdr.de>; Fri, 20 Mar 2020 06:21:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726726AbgCTFVi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Mar 2020 01:21:38 -0400
Received: from mail-pg1-f194.google.com ([209.85.215.194]:38853 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726584AbgCTFVh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Mar 2020 01:21:37 -0400
Received: by mail-pg1-f194.google.com with SMTP id x7so2495574pgh.5
        for <netdev@vger.kernel.org>; Thu, 19 Mar 2020 22:21:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding:content-language;
        bh=yDiIkKT626tF908VsxHeuAcrwPbgillNoXszZOLnHeo=;
        b=DC8/sugC7bkkyrfloSQvM/kLLraCWoh8DAmzY/KzQd6TXw0YcjYDHKJccYevBuNZaH
         tv7uMy8vHDdt4gm8wGGLBVObYEiqJaVMYukYNfi8ZMgk3gl8yodL1MWMZtptZtHWHJFj
         IGZcnhubj8I+bvswFkVjUhvKt5f3D0ZtPX0J/Sz5RlCWzUmI+fK6xaF2Kzqu+sOMJjLi
         9VDmbqcRTmgflHun+wxZcRS9dwjoVXpbOcpRm2L/m2gH8rtZujJ99HOPip4QpAm4FPCp
         7ab7JlTNeX0GkIDLb+oZD94zwtmR8hlQSi5WV5TJuvhqQ7ZfFBEWWn7tDvD+l+6D0GOQ
         8nAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=yDiIkKT626tF908VsxHeuAcrwPbgillNoXszZOLnHeo=;
        b=FzdhXWPqZTzqLSPDfNdrLc8opb2+g/p8HJik5uEgdU4lG7EjHnBSaQCeJI38FCBpGO
         TJPcTgMlbIE+5Asyqa9/SnyrVqfWF7EvUbSXlCtGWWG329RZ0iqbTAIHmx5q8KKAhdEG
         tYsONwNPsU2u5ZytPtz2Z382bX52ROiKOKXMjjXoWIS47db40m8nLCDG98/k0zdgrwxV
         GeJMNyvqSLEjPvg7gWkeN8rFf0SGLQKd/L0lxKpdcnfbC5e0VDeIlPmBbrO2s8eWlHI/
         DHLftqB3L3LHeEXfjPNBVmQs4Jsp630oCJr993fzuYXSTgHWjif7N+aBUgtPh7hv8gOP
         4gSQ==
X-Gm-Message-State: ANhLgQ1WxA7lmlOGrLXAU/oZyTePBHZ559qGZtGeNJqZRWVGSE+mYCRA
        MdkcO8fFlLExOMm6Ytl2d0jhHo0Ldak=
X-Google-Smtp-Source: ADFU+vsL72jkWBMlQno/VWTDMlFbUMmuQsPCS5gM0iAnXNLZrRMTgragCWd4SkJSt9Lu16mSrsFH5g==
X-Received: by 2002:a62:8342:: with SMTP id h63mr7742960pfe.24.1584681696541;
        Thu, 19 Mar 2020 22:21:36 -0700 (PDT)
Received: from Shannons-MacBook-Pro.local (static-50-53-47-17.bvtn.or.frontiernet.net. [50.53.47.17])
        by smtp.gmail.com with ESMTPSA id y3sm4077867pfy.158.2020.03.19.22.21.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 19 Mar 2020 22:21:36 -0700 (PDT)
Subject: Re: [PATCH net-next 4/6] ionic: ignore eexist on rx filter add
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net
References: <20200320023153.48655-1-snelson@pensando.io>
 <20200320023153.48655-5-snelson@pensando.io>
 <20200319204358.7e141f1a@kicinski-fedora-PC1C0HJN>
From:   Shannon Nelson <snelson@pensando.io>
Message-ID: <e681ace5-bd70-4f7b-144f-3d5c0d140d12@pensando.io>
Date:   Thu, 19 Mar 2020 22:21:35 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <20200319204358.7e141f1a@kicinski-fedora-PC1C0HJN>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/19/20 8:43 PM, Jakub Kicinski wrote:
> On Thu, 19 Mar 2020 19:31:51 -0700 Shannon Nelson wrote:
>> Don't worry if the rx filter add firmware request fails on
>> EEXIST, at least we know the filter is there.  Same for
>> the delete request, at least we know it isn't there.
>>
>> Fixes: 2a654540be10 ("ionic: Add Rx filter and rx_mode ndo support")
>> Signed-off-by: Shannon Nelson <snelson@pensando.io>
> Why could the filter be there? Seems like the FW shouldn't have filters
> the driver didn't add, could a flush/reset command help to start from
> clean state?
>
> Just curious.
Because there are use cases where the device is configured by an 
external centralized agent and may have already stuck the appropriate 
filters into the its list.

sln

