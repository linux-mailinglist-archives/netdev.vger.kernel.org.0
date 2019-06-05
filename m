Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A7FE635C0F
	for <lists+netdev@lfdr.de>; Wed,  5 Jun 2019 13:51:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727470AbfFELvn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Jun 2019 07:51:43 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:43941 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726119AbfFELvm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Jun 2019 07:51:42 -0400
Received: by mail-wr1-f65.google.com with SMTP id r18so10144200wrm.10
        for <netdev@vger.kernel.org>; Wed, 05 Jun 2019 04:51:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=6wind.com; s=google;
        h=reply-to:subject:to:references:from:organization:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=KJ3vSGgyORrvU6rv7Vd/aRyYxs/h9/TJdjXOUcZUHdg=;
        b=iJiHvCrASg90jqAAcFWfGNGsju46omR2yCfQINcDkRHNjx56o3zWqXT7uvAb/Li9vQ
         zEGeji+4nSWvp/Utep7wMso1P3EFCVga/j/ZZOnpO7VvgNOyFbrCT1pP3PaPOgDNcPmw
         JAYzCria9T77Q9XY2FpmNQRRXymO3ROzGV6T5OWr3D+YB29a6emG58FSVyyNHXJBzXdI
         kTVX4RbLl9mW1GU4O8frTq4hXsh9LQOwKQNYgcW/zJHTpQ+t1FTxQ5Xi5x2e3/qrC4zv
         8qqxBUXRn+Gmjs585F/jeotvYZO6QI4pj1FtHuEzQ84i2w5MecBXFEWFJfKeqY9gC3u2
         TcSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:reply-to:subject:to:references:from:organization
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=KJ3vSGgyORrvU6rv7Vd/aRyYxs/h9/TJdjXOUcZUHdg=;
        b=KjalGjeXODXda3Vmh8KqgXZpfE5yLCzUTs41N/Pj8ZhTYg62++KPyVMzrYpnGkOZ05
         lomfK9JSpeZFE+BWRLnR+6Y9JKxE3Cp2NmSJmH6yow1RpkY8wI1/XO0Dn0+NPLxkSsWC
         YSEz/2Q+AmWkyDiWsbrw1YTt2pGLvjh29oPjW1k2bO15SxzWvn3ZCpW3oA6pp8f6KRz0
         7tcWfEx4R4JvVj+N1nUJFpaFXfjCHpWsG1DaI5vgZEqnLq4LbHi6GslhOvC0bUDNcJ63
         MsJbQeAjC1syxM3o7/I8F+hIKn2gsIu+MXZm/6ysgd1JfXT6Z3/wjGDv9MSd9OgoM9pP
         TNVA==
X-Gm-Message-State: APjAAAW85XsGGb4XJI/hlHPQe/m7gPbMwJBLdUtpZAl3aAm5JDxrdOod
        AjhRyb9MqgXDqVvi0SR3lPe4WA==
X-Google-Smtp-Source: APXvYqxmmwsxsPhKKvybZ7OoTCjJJefPEKhz5dNVQ551z/CnXZdi3hRDobh8ThZMftMCWsgitRK38w==
X-Received: by 2002:adf:ba47:: with SMTP id t7mr24177086wrg.175.1559735501458;
        Wed, 05 Jun 2019 04:51:41 -0700 (PDT)
Received: from ?IPv6:2a01:e35:8b63:dc30:c5ec:3696:b85c:3139? ([2a01:e35:8b63:dc30:c5ec:3696:b85c:3139])
        by smtp.gmail.com with ESMTPSA id r131sm9514282wmf.4.2019.06.05.04.51.40
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 05 Jun 2019 04:51:40 -0700 (PDT)
Reply-To: nicolas.dichtel@6wind.com
Subject: Re: [RFC][PATCH kernel_bpf] honor CAP_NET_ADMIN for BPF_PROG_LOAD
To:     Andreas Steinmetz <ast@domdv.de>, netdev@vger.kernel.org,
        bpf@vger.kernel.org
References: <56c1f2f89428b49dad615fc13cc8c120d4ca4abf.camel@domdv.de>
 <1188fe85-d627-89d1-d56b-91011166f9c7@6wind.com>
 <f3b59d9ac00eec18bc62a75f2dd6dbba48da0b35.camel@domdv.de>
From:   Nicolas Dichtel <nicolas.dichtel@6wind.com>
Organization: 6WIND
Message-ID: <f8488876-a507-2e27-b140-e8168a6f117c@6wind.com>
Date:   Wed, 5 Jun 2019 13:51:39 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <f3b59d9ac00eec18bc62a75f2dd6dbba48da0b35.camel@domdv.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Le 05/06/2019 à 12:59, Andreas Steinmetz a écrit :
[snip]
> If there is a change for this to get accepted, sure, I'm willing to
> submit this formally (need some advice, though).
At least, you need to submit it without the RFC tag. RFC patches are not aimed
to be merged.


Regards,
Nicolas
