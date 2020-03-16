Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C166F186805
	for <lists+netdev@lfdr.de>; Mon, 16 Mar 2020 10:39:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730478AbgCPJjx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Mar 2020 05:39:53 -0400
Received: from mail-lj1-f195.google.com ([209.85.208.195]:44556 "EHLO
        mail-lj1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730293AbgCPJjw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Mar 2020 05:39:52 -0400
Received: by mail-lj1-f195.google.com with SMTP id w4so3096345lji.11
        for <netdev@vger.kernel.org>; Mon, 16 Mar 2020 02:39:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cogentembedded-com.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=JLytmDCmn51mn44rY6noInxUpy3ZOK9+CPA5ppocb9k=;
        b=AgrLIe5sp8wxfMXOXw2adaEdRxyCCK8y2u0Hhg9ld0v+sZezrd+3DQbWNTjMhx4c70
         67+am6Xz8+PIvZjoKxDgOJvBkSIkbEjfHMHVgMJ6FeRzbBjkJK6lCw+1BUw2ywHXDnO2
         fYU23293O/uKCMZcCwHpeSn0AWr4LRBBwS3/LVp+NrMtKxbg0SrO7zG7OBwByvfwzlJJ
         1Y+MgDvExFuuM69KPbLHLZ7MNN3j7UJ+KJcj7ob/6xgFunxijQgHqWPI+MNeH6D1vc7i
         5iKLHjRiWGnlav90A4cyD5oxChCqjnAjc1DBh0nNxnZCA5ovDVoOclBntuhUu17Jja25
         xDTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=JLytmDCmn51mn44rY6noInxUpy3ZOK9+CPA5ppocb9k=;
        b=gnnBRup4uDvCO2wBCwUn6Ym7L2er3VeaqpNP+cPH1hfJqtU1Zfrq1aq7eYKEMoIiyw
         NgsaaTfDIdbJyHcIQG1PWR6+5fdV2WvS7ZKj8vBKxaUd1FsutXaPYwJtZd7usf4EvqMe
         AW6suUP0DrzDJLQ7zdvGlqSnfCjkeOTBQ2VqqlneGX8s0MNZxa4WOgefwEf5tYox995E
         e4IAdK8An+7l77GE8OjQkFHeWiDGWu+ffy0Ip+kbhE/hmBOT6zaKzXxv/vwBW4JP5Uhl
         2Fkxb5wrezjtF48WQmCPLL+nLZnPgN//jVZWUNxKEijkvGsI6+ogVujliaYZVKNq4CZK
         Y/+Q==
X-Gm-Message-State: ANhLgQ03maSdSoxsco6vDujYyVp3VuZSCAXAASM87lTONfXC2JAyogKL
        2ZJt0wokN66n7/NH0TvqiPZ4aA==
X-Google-Smtp-Source: ADFU+vuuTCqpP/tMAnOSfw02o9lCU2mmkwvTIw6R5yQ7sbu/Sgp//Q3DGEIoMniG/NIUmGJaTxw+ww==
X-Received: by 2002:a2e:9852:: with SMTP id e18mr12844818ljj.249.1584351588489;
        Mon, 16 Mar 2020 02:39:48 -0700 (PDT)
Received: from ?IPv6:2a00:1fa0:487c:8c8d:3425:ccbd:b743:a5f8? ([2a00:1fa0:487c:8c8d:3425:ccbd:b743:a5f8])
        by smtp.gmail.com with ESMTPSA id a13sm1371057lff.81.2020.03.16.02.39.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 16 Mar 2020 02:39:47 -0700 (PDT)
Subject: Re: [PATCH net 3/3] ethtool: reject unrecognized request flags
To:     Michal Kubecek <mkubecek@suse.cz>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Cc:     Johannes Berg <johannes@sipsolutions.net>,
        linux-kernel@vger.kernel.org
References: <cover.1584292182.git.mkubecek@suse.cz>
 <40d6e189e3661dc996f7646c848bfb067ac324cb.1584292182.git.mkubecek@suse.cz>
From:   Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Message-ID: <09ec9c9b-10d3-510b-df0d-bf9f06bf99da@cogentembedded.com>
Date:   Mon, 16 Mar 2020 12:39:44 +0300
User-Agent: Mozilla/5.0 (Windows NT 6.3; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <40d6e189e3661dc996f7646c848bfb067ac324cb.1584292182.git.mkubecek@suse.cz>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello!

On 15.03.2020 20:17, Michal Kubecek wrote:

> As pointed out by Jakub Kicinski, we ethtool netlink code should respond

    s/we/the/?

> with an error if request head has flags set which are not recognized by
> kernel, either as a mistake or because it expects functionality introduced
> in later kernel versions.
> 
> To avoid unnecessary roundtrips, use extack cookie to  provide the
> information about supported request flags.
> 
> Signed-off-by: Michal Kubecek <mkubecek@suse.cz>
[...]

MBR, Sergei
