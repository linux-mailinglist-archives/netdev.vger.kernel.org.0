Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F1E787CD4E
	for <lists+netdev@lfdr.de>; Wed, 31 Jul 2019 21:58:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729389AbfGaT6P (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 31 Jul 2019 15:58:15 -0400
Received: from mail-pg1-f196.google.com ([209.85.215.196]:34920 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728326AbfGaT6O (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 31 Jul 2019 15:58:14 -0400
Received: by mail-pg1-f196.google.com with SMTP id s1so26288426pgr.2
        for <netdev@vger.kernel.org>; Wed, 31 Jul 2019 12:58:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=5bjb4JCgRmc6cDqWEKZXjJBZg68tTw2wpBsWp1Ed+Ko=;
        b=n8QF3B+TRFRoNtoeVT7fNLvdOQu0RiuQcEaMnOR3pFExgEVIYOch1KrCEM4ZjgJn/Z
         ds0XtGl8Ayrc1bLpnUduM+kUkvq6rn049Onc9CBPFsPrgv0XowE+nOqy+k5p438jitI4
         9jsDdSlvKMuxLIgxVOpqdRtVfokUbuaAzwwDuoVLCHxx6Z7vlVS5V5DKdefSLGs5fEM+
         dWy7CAZdXBmefNHgQ0RcsB7Pz8eZkcxqOpTKTZe2ZtqmSQsr6Hqa3lxBgIPhf2FeIVRo
         ASzjgYkaLz7JCGD3+67hWKISvtxIkEnZsregg0n/0PcETROXmu40oWa3a2d5/zNS9bL7
         JuYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=5bjb4JCgRmc6cDqWEKZXjJBZg68tTw2wpBsWp1Ed+Ko=;
        b=qTGoZDyPOJZH1O/NbIjK17jPXrHnG8OvwQgEL/l+w8O951ONQ6aAbZNs5jgIIQLoY1
         dOgk8H8EUphl6gxemkv43g4xwkqLzZPsEGv76a3FJS3zHuR/rkzQN756xGYuL9U8IvPR
         bWpeNLKAEP9ruX37yfbIKoxzxFwX73BJidBvD/87LYIGj4/+9c0vP9sBJEzPBeCpgEeZ
         rgMEcIGL5RRuAY8gTRxSQ5NjGW7nR9vrFCEC/QdrP7+M/TRG0dsqx7o2oOut9BiIbFMq
         yV2Zjd75sjtn7NcqkdLIzMcBCvQv0YMhKN4dXZQ0EaAesMBI7cYhTCVTmBtGQ/873vDg
         49oQ==
X-Gm-Message-State: APjAAAX64zTorTE71gtuRkmbyUrhAIJrKcjsiPNbWYwCArt1m+Hq43cd
        Pc3Yqx6AR+J0BuZA5JEGe3lL+DqA
X-Google-Smtp-Source: APXvYqz9WfzpgULzxvNAw3Qoy+gXUKLalyxGfoCT06CyYIiOsvrHyBU9fs/XW9y8/OjXZzDu31kBBQ==
X-Received: by 2002:a63:c03:: with SMTP id b3mr51943488pgl.23.1564603093414;
        Wed, 31 Jul 2019 12:58:13 -0700 (PDT)
Received: from [172.27.227.172] ([216.129.126.118])
        by smtp.googlemail.com with ESMTPSA id u16sm2567095pgm.83.2019.07.31.12.58.11
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 31 Jul 2019 12:58:12 -0700 (PDT)
Subject: Re: [patch net-next v2 1/3] net: devlink: allow to change namespaces
From:   David Ahern <dsahern@gmail.com>
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     Jakub Kicinski <jakub.kicinski@netronome.com>,
        netdev@vger.kernel.org, davem@davemloft.net,
        sthemmin@microsoft.com, mlxsw@mellanox.com
References: <20190730085734.31504-1-jiri@resnulli.us>
 <20190730085734.31504-2-jiri@resnulli.us>
 <20190730153952.73de7f00@cakuba.netronome.com>
 <20190731192627.GB2324@nanopsycho>
 <c4f83be2-adee-1595-f241-de4c26ea55ca@gmail.com>
 <20190731194502.GC2324@nanopsycho>
 <087f584d-06c5-f4b9-722b-ccb72ce0e5de@gmail.com>
Message-ID: <89dc6908-68b8-5b0d-0ef7-1eaf1e4e886b@gmail.com>
Date:   Wed, 31 Jul 2019 13:58:10 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:52.0)
 Gecko/20100101 Thunderbird/52.9.1
MIME-Version: 1.0
In-Reply-To: <087f584d-06c5-f4b9-722b-ccb72ce0e5de@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 7/31/19 1:46 PM, David Ahern wrote:
> On 7/31/19 1:45 PM, Jiri Pirko wrote:
>>> check. e.g., what happens if a resource controller has been configured
>>> for the devlink instance and it is moved to a namespace whose existing
>>> config exceeds those limits?
>>
>> It's moved with all the values. The whole instance is moved.
>>
> 
> The values are moved, but the FIB in a namespace could already contain
> more routes than the devlink instance allows.
> 

From a quick test your recent refactoring to netdevsim broke the
resource controller. It was, and is intended to be, per network namespace.
