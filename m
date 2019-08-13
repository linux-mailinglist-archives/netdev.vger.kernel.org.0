Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B1E2E8B6E8
	for <lists+netdev@lfdr.de>; Tue, 13 Aug 2019 13:31:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727345AbfHMLbi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Aug 2019 07:31:38 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:35535 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725981AbfHMLbi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Aug 2019 07:31:38 -0400
Received: by mail-wr1-f68.google.com with SMTP id k2so21570599wrq.2
        for <netdev@vger.kernel.org>; Tue, 13 Aug 2019 04:31:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=LUxcWLUDMBz/XKmA82va/FLMHDJ/PRSCJnNzZIS25ZU=;
        b=nsJn0o3oseWJ4dd0p0+9ZsQ0/FWkf1jH/wSlXxjFL8VktHQhb3+Nz/HJ/+ymSZ5hDY
         4fwsAaC6oijBws1+ASYvHKCKBAC6xVDEBtRxJhFWmwc8YRRtDSja/bRTm6PBckg9m7UX
         ElrTI/vBEeV0WT7/7feuqdj2EpDGW4t++WtbJSf7XD5cOZvoZaQAnsIdNTeL1GwMHeul
         cn0L5626CcEnT2JPxKU8lyf+dbtxhBApCy3vTFXnbGieJmEyN5E/KmWdZVaSGZyMH+cF
         nVbAvDlDiXed7xCTAAKfvNBhH8U9txUNrjayqqNZAzbjfF6M7I01GaneNgV+CPd1y2sO
         ioiw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=LUxcWLUDMBz/XKmA82va/FLMHDJ/PRSCJnNzZIS25ZU=;
        b=pXBbbUQd+L798Hob5MNGa4uA80Ce9dTZM1o7afSWq1ScQ2vaI7ndsd26txJKCxxjBN
         I8QhoP7C+O/w9ImR7pn8nllZavzFgfR9RtMYRwgCq7AZig37Kh9S6Mc5DZMABYaf1/qA
         KS9R8nKcw3kPluobiNwgIyrLtyfdN6NiDWpbpZ7kqGJbOj10L45d8lBGdsEbOK0dtil7
         0F9HHI2zSvUXw24k6pa96H4Y/2dC3C9NZxU0NWYYtPHdLBha4uftIbecFAUnItiQS5WF
         4U1dm1C8OwiHiW8Qj03qKrevkuOBZ8P2AnEjkaA3Ftbe/b6Z7LuzJsoHy4AbBPw84Rjb
         J9ww==
X-Gm-Message-State: APjAAAWiB84i8KNdiBsInc11iNb1WjcJg52kGc00uVQq950nOn867sQJ
        XoR0QcGbHzQ1Oks1KWynxs8=
X-Google-Smtp-Source: APXvYqygjEjmThA2z9tkfuAJrBnEwD7vxcFKsatNUxGcx8Yp0l7KVEuqZsmsO54ptiTwC4sx0SyKKQ==
X-Received: by 2002:a5d:424d:: with SMTP id s13mr27160439wrr.178.1565695896112;
        Tue, 13 Aug 2019 04:31:36 -0700 (PDT)
Received: from [192.168.8.147] (64.161.185.81.rev.sfr.net. [81.185.161.64])
        by smtp.gmail.com with ESMTPSA id k124sm2731847wmk.47.2019.08.13.04.31.34
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 13 Aug 2019 04:31:35 -0700 (PDT)
Subject: Re: [PATCH net] netlink: Fix nlmsg_parse as a wrapper for strict
 message parsing
To:     David Ahern <dsahern@kernel.org>, davem@davemloft.net
Cc:     netdev@vger.kernel.org, johannes.berg@intel.com,
        edumazet@google.com, David Ahern <dsahern@gmail.com>
References: <20190812200707.25587-1-dsahern@kernel.org>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <dec209a4-b72a-86c3-d8d5-a080e1249886@gmail.com>
Date:   Tue, 13 Aug 2019 13:31:34 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20190812200707.25587-1-dsahern@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 8/12/19 10:07 PM, David Ahern wrote:
> From: David Ahern <dsahern@gmail.com>
> 
> Eric reported a syzbot warning:
> 
> 
> The root cause is nlmsg_parse calling __nla_parse which means the
> header struct size is not checked.
> 
> nlmsg_parse should be a wrapper around __nlmsg_parse with
> NL_VALIDATE_STRICT for the validate argument very much like
> nlmsg_parse_deprecated is for NL_VALIDATE_LIBERAL.
> 
> Fixes: 3de6440354465 ("netlink: re-add parse/validate functions in strict mode")
> Reported-by: Eric Dumazet <edumazet@google.com>
> Reported-by: syzbot <syzkaller@googlegroups.com>
> Signed-off-by: David Ahern <dsahern@gmail.com>
> ---

Reviewed-by: Eric Dumazet <edumazet@google.com>

Thanks !

