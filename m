Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B5C7C63DE6
	for <lists+netdev@lfdr.de>; Wed, 10 Jul 2019 00:34:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726977AbfGIWeU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Jul 2019 18:34:20 -0400
Received: from mail-pg1-f181.google.com ([209.85.215.181]:39900 "EHLO
        mail-pg1-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726133AbfGIWeU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Jul 2019 18:34:20 -0400
Received: by mail-pg1-f181.google.com with SMTP id u17so162878pgi.6
        for <netdev@vger.kernel.org>; Tue, 09 Jul 2019 15:34:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding:content-language;
        bh=iaIQTDsAUp826QU1NZUHEJx3LwxYAqE9jkJpWwPKOF8=;
        b=Tk3p77IdRTAezsFDBMa2a469h64Rozeuv3o+2qw3lhR1FHarRRDrP2wNiYkGehf5lq
         qHqVKBEAb2fquXJmUUCkbpY0JzN5qlNiJRnQK8Aqw+14qFhfmv/pHCZr2rpZA60w4a4I
         3r0Kw9P3P4q79a8rp58aJg5fmK+gzxZCVubSan7T8tVHYLfFlYgy851w8DHsr9RednaY
         QDdrluQnK0Md1ho/h2T5COnjlI8V9GiIzt5ryca8SIQmUyhCj+i96CA5WODJ/yTA1qAY
         GCyVdrQIErFZPCxKF10oCKX9l27DAz/r3uxg8iDCG4Cjr1Cy698C3wycmKBn8ulS47OX
         xrkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=iaIQTDsAUp826QU1NZUHEJx3LwxYAqE9jkJpWwPKOF8=;
        b=PRUpwkJ//1YwsyW3JzcB/Oqz6sxP37IwfCFYPfe7kiEyDKDAM6k5N0XNRrn4nfzBQ3
         aIvdK8FBIYxpLG0pgW1obc9kdNij36vltCEpZqwMxU4u88lX9v9UUcFm6tBiR1KlPM7t
         lu0BE60ZON+JYvB/Mkn5aQQKQuHpSj3uWjamuv6bwdTursE7Ws8aHP+IA2BFr7JEZmu7
         KQaUOxZ4MEhDI40sMBKLGEJ6rm6cz66UbYBfE342SOXi6UoJo4TlVJjkU0Kt9D4ohSAn
         Y/ZOybj6rWBZIy4zqnJBHIvxbnXUlYNQDKELsdHRlEMEUXyf7LGEhS+zhJ+7sc8QryXw
         v3wA==
X-Gm-Message-State: APjAAAVvsc+vyWoxT/yD8jjJJmQllsE49mQmmoxRl7WoUuoWUN3L4Ev4
        N/K496Ql7Swd7RWaVWwt38iT5kcUYgk=
X-Google-Smtp-Source: APXvYqwqQJVJ7n9pTTLvequXoPDPPUPzbZMiPl2se9bVGDLdb7iqROxsnerprCssQSZDQLQfvNfkuA==
X-Received: by 2002:a17:90a:3344:: with SMTP id m62mr2644056pjb.135.1562711659617;
        Tue, 09 Jul 2019 15:34:19 -0700 (PDT)
Received: from Shannons-MacBook-Pro.local ([12.1.37.26])
        by smtp.gmail.com with ESMTPSA id j1sm118501pfa.73.2019.07.09.15.34.18
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 09 Jul 2019 15:34:18 -0700 (PDT)
Subject: Re: [PATCH v3 net-next 13/19] ionic: Add initial ethtool support
To:     Michal Kubecek <mkubecek@suse.cz>, netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>
References: <20190708192532.27420-1-snelson@pensando.io>
 <20190708192532.27420-14-snelson@pensando.io>
 <20190708220406.GB17857@lunn.ch> <20190709051501.GA16610@unicorn.suse.cz>
From:   Shannon Nelson <snelson@pensando.io>
Message-ID: <3c3629dc-5334-1f04-86f5-2de658a7d26f@pensando.io>
Date:   Tue, 9 Jul 2019 15:35:15 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:60.0)
 Gecko/20100101 Thunderbird/60.7.1
MIME-Version: 1.0
In-Reply-To: <20190709051501.GA16610@unicorn.suse.cz>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 7/8/19 10:15 PM, Michal Kubecek wrote:
> Also, there is no need to zero initialize ks->link_modes.advertising
> above if it's going to be rewritten here anyway.
>
> Michal

Got it.

Thanks,
sln

