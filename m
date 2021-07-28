Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8E2463D961A
	for <lists+netdev@lfdr.de>; Wed, 28 Jul 2021 21:37:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231585AbhG1Thd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Jul 2021 15:37:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54282 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229542AbhG1Thb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Jul 2021 15:37:31 -0400
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 36489C061757;
        Wed, 28 Jul 2021 12:37:29 -0700 (PDT)
Received: by mail-pj1-x102e.google.com with SMTP id m1so6783149pjv.2;
        Wed, 28 Jul 2021 12:37:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=YGNbXA3LWoeJvRqmwBvBDGTrMpQsxN7Ok+KzzHRsrJE=;
        b=BYHqUywK6NhuYK8K63h8dsZIeYvypTzKbDDQusjvHwR5ZclWGmvOmGEv4IuYp2c/mC
         W4RvFdId2rD1w1Y8ClR8xM44L40dR6Bl3Iz7Q8rRkY2nMyXrucXK6aJNVT2KcL7QUVie
         gq8GOllM308JsT4ptYu0SptVrVUFH0I0Fl6RbNN4mQT5bIN8Ky9qI0+ll4zUI3/hFQ/J
         DoNOJ1TpF6o/NG5/O1pMMaC7LdwAehVRfhiOMYmKfn29fqvJ8N2MJp0LKp5BQ6smkqDH
         dqiot/YvFBp0djSX4pd1WvHsKeU9DCIn0zEK6UzFchg6sIsSsZpOEk70Yu2IAwc0gr7J
         UA8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=YGNbXA3LWoeJvRqmwBvBDGTrMpQsxN7Ok+KzzHRsrJE=;
        b=dJrfzrX4jw/tgL93V6igCq80icE9OOAg2BSCQcvqzBd31yTBpYVj8GYi5dTyoLsXIs
         iveblb/gA02Tf9LoX7rWABIkF3pytN7P+mMtCbiX2KqcOr6LQE3D1jSKx6j7egod6XI3
         QwH/EOlsWSl72TcPwTyp8JI23y9xvJr0LOHc/CKMBovrv74FeJR/dPMS8GWQr9xT3SLU
         MA1zdnSGJ+XHxsqv+T4jo4aOktAFxVNfEASp4l7LfcHskKHFCfYkDpJz7ebtf+/23ZVf
         Uv7R61l7uJ8UxJGalyTpuVzO3v4fSi4o+FwOwSXBYEzWfClmQ7gs+bdW8hMTOYvpmx+A
         iyYQ==
X-Gm-Message-State: AOAM531TA+6zv6LT8DXt9vxvaNHreB7yoINVKJb/xtcqXZXkZxfgfJUj
        4iVqtrjSDVn4BhLlvwJUGmhycpCE+FLhqR4T
X-Google-Smtp-Source: ABdhPJxn0tndfDcbLrGTOjSfF0xXe64xCfGTt9FAN3qryeAvMdxs1I2MuhGkzqcgXSV2bfAAzyBHAg==
X-Received: by 2002:a17:902:a606:b029:12b:fbb7:1f9d with SMTP id u6-20020a170902a606b029012bfbb71f9dmr1243712plq.22.1627501048516;
        Wed, 28 Jul 2021 12:37:28 -0700 (PDT)
Received: from [192.168.1.10] ([223.236.188.83])
        by smtp.gmail.com with ESMTPSA id 2sm656294pgz.26.2021.07.28.12.37.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 28 Jul 2021 12:37:28 -0700 (PDT)
Subject: Re: [PATCH v2] ath9k_htc: Add a missing spin_lock_init()
To:     ath9k-devel@qca.qualcomm.com, kvalo@codeaurora.org,
        davem@davemloft.net, kuba@kernel.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <38fa8cc-c9c4-66c1-e2ee-fe02caa7ef63@gmail.com>
 <20210728191719.17856-1-rajatasthana4@gmail.com>
From:   Rajat Asthana <rajatasthana4@gmail.com>
Message-ID: <eb79099c-8dc9-21ee-f03e-207d1685941c@gmail.com>
Date:   Thu, 29 Jul 2021 01:07:24 +0530
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210728191719.17856-1-rajatasthana4@gmail.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

please ignore this patch!



I have sent this by wrongly giving the `in-reply-to` field in the `git 
send-email`. Really sorry for this!



Best wishes,

-- Rajat
