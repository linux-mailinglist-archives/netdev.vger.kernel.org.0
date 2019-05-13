Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 892B51BB1B
	for <lists+netdev@lfdr.de>; Mon, 13 May 2019 18:38:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730611AbfEMQiz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 May 2019 12:38:55 -0400
Received: from mail-pl1-f194.google.com ([209.85.214.194]:39848 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728167AbfEMQiz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 May 2019 12:38:55 -0400
Received: by mail-pl1-f194.google.com with SMTP id g9so6750492plm.6
        for <netdev@vger.kernel.org>; Mon, 13 May 2019 09:38:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=CY2iW5dxUiiw4vTthzbLv0iBRh+H+Ldd6sWlh00UwlE=;
        b=YA44uv8nf7hOd1kAw5TIFmF9bANlmuSc+1fVBa7aVharWepyPTSOf9m6tVAldu3ZG7
         gWmFVwlErSR87fAC6Izbw9gDOJpBZXOqcaQ2J90dztAQkoN03VDTeHyxus+Bx03X/orZ
         Nesi51AyU3yLxt+kD+lwzsxUtiLiUEc0+/8HJqlckuZ+qeecv/m+51xquBJ6am1Hiq7L
         kYTM8yb7Qn2hOZOkZKSc7zQ5k4M20m4yy2I4StpKHcR7PK4bC/uLRZl2ZHkp8QCS8A3a
         d/OxzqdAQPujg7CV9Nyyy3eaGP76MdUyUFxnKunx2OewREiRCW8mTc1r/GdDyoIRzYgs
         9GXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=CY2iW5dxUiiw4vTthzbLv0iBRh+H+Ldd6sWlh00UwlE=;
        b=jAjtBIYVPP7AvzCGk0Eb0N/05XaUiihzsDCk3By5hCly5KWLf0185cook3jXbQMmae
         oT9FR/AaoMgWqN/fln3+Mc97vdgrCYtYygUaPus4yVemmWyL0ORYtAhQLARo7vc7rXNR
         a89S84cLKrUo3imT5iwrS3/XxlJ0R66RHUXeKNelidv1s52NgFcBp20liZAuQa7vSR18
         iCinO+Af/cu4UsvC5Iu41gLCtGhh096djD5++HN6o/228v39OngwvsWj99fXETa3Z12x
         24vPG833XT7xJ+R46cToIHywFK+E+9IKAkkooxZrqQXh0FhMoI/cHwu8t3jufQ8hOpWo
         KPAA==
X-Gm-Message-State: APjAAAXh0btoXPQ3KYt/nYqTDT2XHfEF/ky+VpPd7wG6YxUun/ZQ7jNg
        a1087uOafZnUriTHqVsefGA=
X-Google-Smtp-Source: APXvYqz9YB8dCVnCD2P7Okm/8wYVxNIki4XWvhmg0mf3SG186gYGlvZccbD1OQtd1KauAwwjjw2CgQ==
X-Received: by 2002:a17:902:2947:: with SMTP id g65mr12780758plb.115.1557765534728;
        Mon, 13 May 2019 09:38:54 -0700 (PDT)
Received: from ?IPv6:2601:282:800:fd80:5dd:49d5:5580:adf5? ([2601:282:800:fd80:5dd:49d5:5580:adf5])
        by smtp.googlemail.com with ESMTPSA id e24sm2450566pgl.94.2019.05.13.09.38.53
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 13 May 2019 09:38:53 -0700 (PDT)
Subject: Re: [PATCH net v2] rtnetlink: always put ILFA_LINK for links with a
 link-netnsid
To:     nicolas.dichtel@6wind.com, Sabrina Dubroca <sd@queasysnail.net>,
        netdev@vger.kernel.org
Cc:     Dan Winship <danw@redhat.com>
References: <d5c4710117d390e0f204b7046483727daf452233.1557755096.git.sd@queasysnail.net>
 <9974090c-5124-b3a1-1290-ac9efc4569c4@gmail.com>
 <83ffac16-f03a-acd7-815a-0b952c0ef951@6wind.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <0ae8a852-ddb7-20a2-1da6-75d5ad503e61@gmail.com>
Date:   Mon, 13 May 2019 10:38:52 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:52.0)
 Gecko/20100101 Thunderbird/52.9.1
MIME-Version: 1.0
In-Reply-To: <83ffac16-f03a-acd7-815a-0b952c0ef951@6wind.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 5/13/19 9:18 AM, Nicolas Dichtel wrote:
> Adding this attribute may change the output of 'ip link'.
> See this patch for example:
> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=95ec655bc465
> 
> 

I figured that would be the response, but wanted to make sure.
