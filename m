Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DA520A3CC2
	for <lists+netdev@lfdr.de>; Fri, 30 Aug 2019 19:03:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727959AbfH3RDr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Aug 2019 13:03:47 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:55999 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726183AbfH3RDq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Aug 2019 13:03:46 -0400
Received: by mail-wm1-f65.google.com with SMTP id g207so4112083wmg.5
        for <netdev@vger.kernel.org>; Fri, 30 Aug 2019 10:03:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=uNYvdSv5xn2X+PnrOCqaUktbCVp4LrcwmYlRU/h6rmA=;
        b=fGtuRVTuBbu6pfe+WM58j73yXrx1gb/c7T/ADN9l5IKaTKYRsc6VdLbIY2l1xPwhrK
         mW3vh1+6wOr2EHbcpwd3hOajy6S1O1HAuMbEYn6S9PgnaDpflTR4fj00BZE0uaUfvxb7
         cWRq7hzeh8lVb/vN9cDIfQBl/g7yf94UcJtH0DWMPLSf1S1FBXnmDGXasU4ipJRUrSO3
         qYiEUQBXwt1gyvxB/2SKRtC4u0u8GlwOrdSpXBANFSTWKSmzJI7E8aoz181X8qJE5BFU
         2tQ6SU7miZKt1jvzPeK0HGqVgjGhPpDiWDt2rG9d4BqY+xkOhn20bU1ZKK6YsTdnVa/i
         gNkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=uNYvdSv5xn2X+PnrOCqaUktbCVp4LrcwmYlRU/h6rmA=;
        b=nxRjucO2wSMKxA2VCce1QAqOsPS1vdsGdJE+vObzGrm7RcTf1nI8Y9wuUGBX+s6L5o
         pkwdQ1om0o5o6htMZ1cUzhOwfE+Iahnc31gOHEF6PNZLxOmRoDV5ndIO6mu/J8mkhsmy
         7gKmP7c44IyJosvEPWPfTZkf29TQiLgiJUcphYe+uU1J/LciURQ5PQLoV92syi9MYGok
         aCuOthUE9++YWigQqPmq13sSRKhJmnGsFyrF09CH80zvZE0DqE9ml1GPFGZQ7k6XeGix
         zEYtgx9dJravEzUU3WoBoQU4BM8lLgB3ks7vSqmBH6WtWwNSDZF9SfpJM0jO9IyjYvj7
         LVYw==
X-Gm-Message-State: APjAAAWjDy90gIPW2EhUp3nPe7IQsZM0lfZk/4IPcX4x9aQg5qqfqUks
        AuslBAPkdf57hwpjucFC5mpijQ==
X-Google-Smtp-Source: APXvYqx/nNolezHfi/dYwR/KOEjUFdXYh3Ozr3xt20Qa9/jcQosoxRw5m7lwJo6/HkTYEbgoORwgXA==
X-Received: by 2002:a1c:a558:: with SMTP id o85mr13196253wme.30.1567184624252;
        Fri, 30 Aug 2019 10:03:44 -0700 (PDT)
Received: from localhost (ip-78-45-163-186.net.upcbroadband.cz. [78.45.163.186])
        by smtp.gmail.com with ESMTPSA id l2sm3616813wme.36.2019.08.30.10.03.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 30 Aug 2019 10:03:43 -0700 (PDT)
Date:   Fri, 30 Aug 2019 19:03:42 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     Roopa Prabhu <roopa@cumulusnetworks.com>
Cc:     Michal Kubecek <mkubecek@suse.cz>, netdev <netdev@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        David Ahern <dsahern@gmail.com>,
        Stephen Hemminger <sthemmin@microsoft.com>, dcbw@redhat.com,
        Andrew Lunn <andrew@lunn.ch>, parav@mellanox.com,
        Saeed Mahameed <saeedm@mellanox.com>,
        mlxsw <mlxsw@mellanox.com>
Subject: Re: [patch net-next rfc 3/7] net: rtnetlink: add commands to add and
 delete alternative ifnames
Message-ID: <20190830170342.GR2312@nanopsycho>
References: <20190826151552.4f1a2ad9@cakuba.netronome.com>
 <20190826.151819.804077961408964282.davem@davemloft.net>
 <20190827070808.GA2250@nanopsycho>
 <20190827.012242.418276717667374306.davem@davemloft.net>
 <20190827093525.GB2250@nanopsycho>
 <CAJieiUjpE+o-=x2hQcsKQJNxB8O7VLHYw2tSnqzTFRuy_vtOxw@mail.gmail.com>
 <20190828070711.GE2312@nanopsycho>
 <CAJieiUiipZY3A+04Po=WnvgkonfXZxFX2es=1Q5dq1Km869Obw@mail.gmail.com>
 <20190829052620.GK29594@unicorn.suse.cz>
 <CAJieiUgGY4amm_z1VGgBF-3WZceah+R5OVLEi=O2RS8RGpC9dg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJieiUgGY4amm_z1VGgBF-3WZceah+R5OVLEi=O2RS8RGpC9dg@mail.gmail.com>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fri, Aug 30, 2019 at 04:35:23PM CEST, roopa@cumulusnetworks.com wrote:
>On Wed, Aug 28, 2019 at 10:26 PM Michal Kubecek <mkubecek@suse.cz> wrote:
>>
>> On Wed, Aug 28, 2019 at 09:36:41PM -0700, Roopa Prabhu wrote:
>> >
>> > yes,  correct. I mentioned that because I was wondering if we can
>> > think along the same lines for this API.
>> > eg
>> > (a) RTM_NEWLINK always replaces the list attribute
>> > (b) RTM_SETLINK with NLM_F_APPEND always appends to the list attribute
>> > (c) RTM_DELLINK with NLM_F_APPEND updates the list attribute
>> >
>> > (It could be NLM_F_UPDATE if NLM_F_APPEND sounds weird in the del
>> > case. I have not looked at the full dellink path if it will work
>> > neatly..its been a busy day )
>>
>> AFAICS rtnl_dellink() calls nlmsg_parse_deprecated() so that even
>> current code would ignore any future attribute in RTM_DELLINK message
>> (any kernel before the strict validation was introduced definitely will)
>> and it does not seem to check NLM_F_APPEND or NLM_F_UPDATE either. So
>> unless I missed something, such message would result in deleting the
>> network device (if possible) with any kernel not implementing the
>> feature.
>
>ok, ack. yes today it does. I was hinting if that can be changed to
>support list update with a flag like the RTM_DELLINK AF_BRIDGE does
>for vlan list del.
>
>so to summarize, i think we have discussed the following options to
>update a netlink list attribute so far:
>(a) encode an optional attribute/flag in the list attribute in
>RTM_SETLINK to indicate if it is a add or del
>(b) Use a flag in RTM_SETLINK and RTM_DELINK to indicate add/del
>(close to bridge vlan add/del)

Nope, bridge vlan add/del is done according to the cmd, not any flag.


>(c) introduce a separate generic msg type to add/del to a list
>attribute (IIUC this does need a separate msg type per subsystem or
>netlink API)
