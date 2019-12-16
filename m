Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6C36B1219DC
	for <lists+netdev@lfdr.de>; Mon, 16 Dec 2019 20:20:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727241AbfLPTUI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Dec 2019 14:20:08 -0500
Received: from mail-pf1-f175.google.com ([209.85.210.175]:42730 "EHLO
        mail-pf1-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726191AbfLPTUH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Dec 2019 14:20:07 -0500
Received: by mail-pf1-f175.google.com with SMTP id 4so6124438pfz.9;
        Mon, 16 Dec 2019 11:20:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=pfOv1lQoi+q268iMK7gTa2TnPvnr8S8hwCiLEnPHWh4=;
        b=toOIdg6dhNu82nmf911KFp9vg1ejc4YILG59m5qOsy4CqbGouNmru/5LCjrqInMKPf
         IA7xDdOs9MIuInx44BfQXFInAN0wDN3n+UCoNK0oBM6W6jjgzc/T4L3z4ehmzG5QaPN2
         8wafhu2wphVJROdRjCNL3XZhH4SFiAW4x5VvUzWW04juSgftkvXnNl6MRNbrUfwfjZXl
         XiaK3lLEcEvWN9AvjerWNVIHZPERap2LbnN5XlqFdsmep1Y4GHoo9ltR+13DlG+GvMCF
         30wXlHw/xc0feQe/t+B06zqtM7DukF4zR63mVx84mw0Y7lZ8iu3j2ruQak2LkN3xEYIl
         mwJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=pfOv1lQoi+q268iMK7gTa2TnPvnr8S8hwCiLEnPHWh4=;
        b=hZxP+RYiKWVP89ToW/hMW/JVOv2XnvJ1jnP4RzqdbW4zT4D5S/Aqk6oPFCSnOeuFDc
         C16Ns820HvAtpQr9dw0I4iTcdilL9lNe8DvOpgkc0M81WHscQ9vMVzmxwwdzw+yC/7ao
         4cUSAehdR9d4wfKthDkBp5B8zEdhAhd5Rm5GaRhKD45epN996JS/5+GyZgDQocyblRT0
         2895/6UYt0nWpTtvZFaVO9MlxB2xfRoJmWlb/tPlyNOmqXpSmmq1Wf2Yb+LxGTuNNVDu
         SXn9aW1QpxfSR/YBUN8YMuI1wE0urwVuTt7twe6/dKd9V8+MsC3EOUkIZmo1W4j58C/G
         roUA==
X-Gm-Message-State: APjAAAX2iqb8D6Xz1dDvg4yOAN/D8gOtQNxe2a38YTLrqxNhrGSs5U+7
        v/SphFXvObx7xE1K0/5Hklc=
X-Google-Smtp-Source: APXvYqyj549w92CUiv/GQQqV0RLnCOj7dq+R/ttPkAduDIJpN3FqY558oHQ9VYV+3FCkaDvx/yYDPg==
X-Received: by 2002:a63:d94b:: with SMTP id e11mr20129287pgj.79.1576524007072;
        Mon, 16 Dec 2019 11:20:07 -0800 (PST)
Received: from ?IPv6:2620:15c:2c1:200:55c7:81e6:c7d8:94b? ([2620:15c:2c1:200:55c7:81e6:c7d8:94b])
        by smtp.gmail.com with ESMTPSA id c18sm23731190pgj.24.2019.12.16.11.20.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 16 Dec 2019 11:20:06 -0800 (PST)
Subject: Re: debugging TCP stalls on high-speed wifi
To:     Simon Barber <simon@superduper.net>,
        Eric Dumazet <eric.dumazet@gmail.com>
Cc:     Johannes Berg <johannes@sipsolutions.net>,
        linux-wireless@vger.kernel.org, ncardwell@google.com,
        netdev@vger.kernel.org, toke@redhat.com
References: <80B44318-C66D-4585-BCE3-C926076E8FF8@superduper.net>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <6e1b5c34-9353-de1d-015b-68d6b20db390@gmail.com>
Date:   Mon, 16 Dec 2019 11:20:04 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <80B44318-C66D-4585-BCE3-C926076E8FF8@superduper.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 12/16/19 10:14 AM, Simon Barber wrote:
> I see Macbook wifi clients seemingly randomly switch in and out of using GRO (I’ve not yet figured out a pattern to it), and the packet rate when they are doing GRO (on a download) is much lower, due to ACKing one in 8 packets instead of every other data packet. This has a big impact on performance.
> 
> Simon
> 


GRO has been added to linux back in 2008.
LRO might have been supported on NICs even earlier.

Modern network speeds need GRO/TSO, even if this means software stacks need some changes.

If some stacks still rely on the old rule of having one ACK per two mss,
they might not have the best experience.

RFC3449 might be a good starting point.
