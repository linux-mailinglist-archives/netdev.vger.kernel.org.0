Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1979F6D26F
	for <lists+netdev@lfdr.de>; Thu, 18 Jul 2019 18:59:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727770AbfGRQ67 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Jul 2019 12:58:59 -0400
Received: from mail-io1-f65.google.com ([209.85.166.65]:44912 "EHLO
        mail-io1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727623AbfGRQ67 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Jul 2019 12:58:59 -0400
Received: by mail-io1-f65.google.com with SMTP id s7so52458700iob.11
        for <netdev@vger.kernel.org>; Thu, 18 Jul 2019 09:58:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=FLviXMSpU9ReD21RHrDBoaOtK19HwNoXlrVIdW8ZxHU=;
        b=uKTLC5h76yY7j3bHYvyZqC6EVJCia6SSTiWySKnTY3aJJcOMA84DVmb/tOcU0J7JCg
         69MAJz5DaxX35ZXjInOLUcjgkmpJKIb261wrgITb31xk3WET62grOGo4+TXtGJ18t58t
         2L05/tR/b995m6PpCWYySlai5HatEeegD9jQcI0izLPhtiVBbzHeevbM3YVt1QLV1qSe
         R2aa5zls5MMc4nFf+7qqheqlKNovMH3Lcie8DvjxKhpf7pP4mgFRNRhTQS70EDPWVRQ1
         vjvLH6OHIYbLt8CPwGb3fgDuBWW/lxuo++n0k1iu6J6DPq/6BfjHnHZtTaOGkZZh8CVv
         bKuQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=FLviXMSpU9ReD21RHrDBoaOtK19HwNoXlrVIdW8ZxHU=;
        b=gN9TeCxCQzydQNYMJFZt3li1l6Nqia4GrRV0fPo0sp61nH6CbKcgiX+fpEC+OI9SpZ
         KWsK4itdJTF6ih3TFXwQ79xq7oBKhIwK2g5Y0Eebg2L+qtuL3GKcwqMKMduW5tjpdcSh
         e+uijcrNUBbejTrweALqA3h7oc5OTqWXNoPuQ1lQLO9MFN+EpuhEMs3dM2qZC5fHKJ9F
         Q8lv90ou1XmqHEoijjptQVlgbOTOvXqDPxwGc2tRleuP/NWryL89Xd5mI8GWVvp+uDT0
         2TKAowzXldjhZm/QuGjOPidCt6ybhUHiUbsXOr6FWZD/LSnxb1/F2iphMdUvtQUGRpw+
         1W6A==
X-Gm-Message-State: APjAAAVH8yj1RYHrF06RftsglLgHDtM+nzx4rsYxg++givrP0nTZWnEN
        XKpo/idKnCYq/ZfQKJ0rcE4=
X-Google-Smtp-Source: APXvYqwlXOzj6/apJCEOJLMe88O7xXUFA+QQuC50pcmYRx/dtsSDZcYWEn/YpDjTYEIK7Da6/qmOfw==
X-Received: by 2002:a05:6638:52:: with SMTP id a18mr50349152jap.75.1563469138464;
        Thu, 18 Jul 2019 09:58:58 -0700 (PDT)
Received: from ?IPv6:2601:282:800:fd80:d57e:4df9:f3b0:1b7c? ([2601:282:800:fd80:d57e:4df9:f3b0:1b7c])
        by smtp.googlemail.com with ESMTPSA id i23sm20143556ioj.24.2019.07.18.09.58.57
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 18 Jul 2019 09:58:57 -0700 (PDT)
Subject: Re: [PATCH net-next iproute2 v2 0/3] net/sched: Introduce tc
 connection tracking
To:     Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Paul Blakey <paulb@mellanox.com>
Cc:     Jiri Pirko <jiri@mellanox.com>, Roi Dayan <roid@mellanox.com>,
        Yossi Kuperman <yossiku@mellanox.com>,
        Oz Shlomo <ozsh@mellanox.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Aaron Conole <aconole@redhat.com>,
        Zhike Wang <wangzhike@jd.com>,
        Rony Efraim <ronye@mellanox.com>,
        "nst-kernel@redhat.com" <nst-kernel@redhat.com>,
        John Hurley <john.hurley@netronome.com>,
        Simon Horman <simon.horman@netronome.com>,
        Justin Pettit <jpettit@ovn.org>
References: <1562832867-32347-1-git-send-email-paulb@mellanox.com>
 <9286cbad-6821-786a-6882-d2bf56b3cf05@mellanox.com>
 <20190718165233.GT3390@localhost.localdomain>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <62d7b2a2-82d4-cd2e-d508-c37b4829998c@gmail.com>
Date:   Thu, 18 Jul 2019 10:58:56 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:52.0)
 Gecko/20100101 Thunderbird/52.9.1
MIME-Version: 1.0
In-Reply-To: <20190718165233.GT3390@localhost.localdomain>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 7/18/19 10:52 AM, Marcelo Ricardo Leitner wrote:
> On Thu, Jul 18, 2019 at 03:00:34PM +0000, Paul Blakey wrote:
>> Hey guys,
>>
>> any more comments?
> 
> From my side, just the man page on tc-ct(8) that is missing.
> Everything else seems to be in place.
> 
> Thanks,
> Marcelo
> 

Paul: If there are no other comments, I'll push these to iproute2-next
later today. In that case, send the man page as a follow on patch.
